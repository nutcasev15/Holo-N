/*
 * Dynamic Hotplug for mako / hammerhead / shamu / Z00A/8
 *
 * Copyright (C) 2013 Stratos Karafotis <stratosk@semaphore.gr> (dyn_hotplug for mako)
 *
 * Copyright (C) 2015 engstk <eng.stk@sapo.pt> (hammerhead & shamu implementation, fixes and changes to blu_plug)
 *
 * Copyright (C) 2017 Nutcasev1.5 <win.api_10@outlook.com> (Z00A/8 Implementation & Adoption to Intel x86)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#define DEBUG 0
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/cpu.h>
#include <linux/workqueue.h>
#include <linux/sched.h>
#include <linux/timer.h>
#include <linux/cpufreq.h>
#include <linux/delay.h>
#include <linux/slab.h>
#ifdef CONFIG_STATE_NOTIFIER
#include <linux/state_notifier.h>
#endif

#define INIT_DELAY		90000 /* All cores online for 90 Seconds During Boot */
#define DELAY			500
#define UP_THRESHOLD		80
#define MIN_ONLINE		2
#define MAX_ONLINE		4
#define DEF_DOWN_TIMER_CNT	6 /* 3 Seconds */
#define DEF_UP_TIMER_CNT	2 /* 1 Second */
#define MAX_CORES_SCREENOFF     2
#define DEF_PLUG_THRESHOLD      70
#define BLU_PLUG_ENABLED	0

static unsigned int blu_plug_enabled = BLU_PLUG_ENABLED;

static unsigned int up_threshold = UP_THRESHOLD;
static unsigned int delay = DELAY;
static unsigned int min_online = MIN_ONLINE;
static unsigned int max_online = MAX_ONLINE;
static unsigned int down_timer;
static unsigned int up_timer;
static unsigned int down_timer_cnt = DEF_DOWN_TIMER_CNT;
static unsigned int up_timer_cnt = DEF_UP_TIMER_CNT;
static unsigned int max_cores_screenoff = MAX_CORES_SCREENOFF;
static unsigned int max_cores;

static struct delayed_work dyn_work;
static struct workqueue_struct *dyn_workq;
static struct notifier_block notify;

/* Iterate through possible CPUs and bring online the first offline found */
static void __ref up_one(void)
{
	unsigned int cpu;

	/* All CPUs are online, return */
	if (num_online_cpus() >= max_online)
		goto out;

	for_each_possible_cpu(cpu) {
		if (cpu_is_offline(cpu)) {
			cpu_up(cpu);
#if DEBUG
			printk("%s: Core %u Up\n", __func__, cpu);
#endif
			break;
		}
	}

out:
	down_timer = 0;
	up_timer = 0;
}

/* Iterate through online CPUs and take offline latest core */
static void __ref down_one(void)
{
	unsigned int cpu;

	/* Min online CPUs, return */
	if (num_online_cpus() <= min_online)
		goto out;

	for (cpu = max_cores; cpu > 0; cpu--) {
		if (cpu_online(cpu)) {
#if DEBUG
			printk("%s: Selected Core %u\n", __func__, cpu);
#endif
			cpu_down(cpu);
			break;
		}
	}

#if DEBUG
	printk("%s: Core %u Down\n", __func__, cpu);
#endif

out:
	down_timer = 0;
	up_timer = 0;
}

/*
 * Every DELAY, check the average load of online CPUs. If the average load
 * is above up_threshold bring online one more CPU if up_timer has expired.
 * If the average load is below up_threshold offline one more CPU if the
 * down_timer has expired.
 */
static void load_timer(struct work_struct *work)
{
	unsigned int cpu;
	unsigned int avg_load = 0;
	unsigned int online_cpus = num_online_cpus();

	if (down_timer < down_timer_cnt)
		down_timer++;

	if (up_timer < up_timer_cnt)
		up_timer++;

	for_each_online_cpu(cpu)
		avg_load += cpufreq_quick_get_util(cpu);
		
	avg_load /= online_cpus;

#if DEBUG
	printk("%s: avg_load: %u, num_online_cpus: %u\n", __func__, avg_load, online_cpus);
	printk("%s: up_timer: %u, down_timer: %u\n", __func__, up_timer, down_timer);
#endif

	if ((avg_load >= up_threshold && up_timer >= up_timer_cnt) ||
		online_cpus < min_online)
		up_one();
	else if ((down_timer >= down_timer_cnt && avg_load <= up_threshold) || online_cpus > max_online)
		down_one();

	queue_delayed_work_on(0, dyn_workq, &dyn_work, msecs_to_jiffies(delay));
}

#ifdef CONFIG_STATE_NOTIFIER
static void blu_plug_suspend(void)
{
	int cpu;

	cancel_delayed_work_sync(&dyn_work);

	while (num_online_cpus() > max_cores_screenoff)
		down_one();
}

static void blu_plug_resume(void)
{
#if DEBUG
	printk("%s: Starting Operations", __func__);
#endif

	while (num_online_cpus() < max_cores)
		up_one();
	queue_delayed_work_on(0, dyn_workq, &dyn_work, msecs_to_jiffies(delay));
}

static int state_notifier_callback(struct notifier_block *this,
				unsigned long event, void *data)
{
	if (!blu_plug_enabled)
		return NOTIFY_OK;

	switch (event) {
		case STATE_NOTIFIER_ACTIVE:
			blu_plug_resume();
			break;
		case STATE_NOTIFIER_SUSPEND:
			blu_plug_suspend();
			break;
		default:
			break;
	}

	return NOTIFY_OK;
}
#endif

/******************** Module parameters *********************/

/* up_threshold */
static int set_up_threshold(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i > 100)
		return -EINVAL;

	up_threshold = i;

	return ret;
}

static struct kernel_param_ops up_threshold_ops = {
	.set = set_up_threshold,
	.get = param_get_uint,
};

module_param_cb(up_threshold, &up_threshold_ops, &up_threshold, 0644);

/* min_online */
static int set_min_online(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i > max_online || i > max_cores)
		return -EINVAL;

	min_online = i;

	return ret;
}

static struct kernel_param_ops min_online_ops = {
	.set = set_min_online,
	.get = param_get_uint,
};

module_param_cb(min_online, &min_online_ops, &min_online, 0644);

/* max_online */
static int set_max_online(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i < min_online || i > max_cores)
		return -EINVAL;

	max_online = i;

	return ret;
}

static struct kernel_param_ops max_online_ops = {
	.set = set_max_online,
	.get = param_get_uint,
};

module_param_cb(max_online, &max_online_ops, &max_online, 0644);

/* max_cores_screenoff */
static int set_max_cores_screenoff(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i > max_online || i > max_cores)
		return -EINVAL;

	if (i > max_online)
		i = max_online;

	max_cores_screenoff = i;

	return ret;
}

static struct kernel_param_ops max_cores_screenoff_ops = {
	.set = set_max_cores_screenoff,
	.get = param_get_uint,
};

module_param_cb(max_cores_screenoff, &max_cores_screenoff_ops, &max_cores_screenoff, 0644);

/* down_timer_cnt */
static int set_down_timer_cnt(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i > 50)
		return -EINVAL;
		
	if (i < up_timer_cnt)
		i = up_timer_cnt;

	down_timer_cnt = i;

	return ret;
}

static struct kernel_param_ops down_timer_cnt_ops = {
	.set = set_down_timer_cnt,
	.get = param_get_uint,
};

module_param_cb(down_timer_cnt, &down_timer_cnt_ops, &down_timer_cnt, 0644);

/* up_timer_cnt */
static int set_up_timer_cnt(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 1 || i > 50)
		return -EINVAL;

	up_timer_cnt = i;

	return ret;
}

static struct kernel_param_ops up_timer_cnt_ops = {
	.set = set_up_timer_cnt,
	.get = param_get_uint,
};

module_param_cb(up_timer_cnt, &up_timer_cnt_ops, &up_timer_cnt, 0644);

/* plug_threshold */
module_param_array(plug_threshold, uint, NULL, 0644);

/***************** end of module parameters *****************/

static int dyn_hp_init(void)
{
	if (!blu_plug_enabled)
		return 0;

	register_early_suspend(&screen_state);
	max_cores = num_possible_cpus();

	dyn_workq = alloc_workqueue("dyn_hotplug_workqueue", WQ_HIGHPRI | WQ_FREEZABLE, 0);
	if (!dyn_workq)
		return -ENOMEM;

	INIT_DELAYED_WORK(&dyn_work, load_timer);
	queue_delayed_work_on(0, dyn_workq, &dyn_work, msecs_to_jiffies(INIT_DELAY));

	printk("%s: activated\n", __func__);

	return 0;
}

static void __ref dyn_hp_exit(void)
{
	cancel_delayed_work_sync(&dyn_work);

#ifdef CONFIG_STATE_NOTIFIER
	state_unregister_client(&notify);
#endif

	destroy_workqueue(dyn_workq);

	/* Wake up all the sibling cores */
	while (num_online_cpus() != max_cores)
		up_one();
#if DEBUG
	printk("%s: All CPUs Up\n", __func__);
#endif

	printk("%s: deactivated\n", __func__);
}

/* enabled */
static int set_enabled(const char *val, const struct kernel_param *kp)
{
	int ret = 0;
	unsigned int i;

	ret = kstrtouint(val, 10, &i);
	if (ret)
		return -EINVAL;

	if (i < 0 || i > 1)
		return -EINVAL;
		
	if (i == blu_plug_enabled)
		return ret;

	blu_plug_enabled = i;

	if (blu_plug_enabled)
		ret = dyn_hp_init();
	else
		dyn_hp_exit();

	return ret;
}

static struct kernel_param_ops enabled_ops = {
	.set = set_enabled,
	.get = param_get_uint,
};

module_param_cb(enabled, &enabled_ops, &blu_plug_enabled, 0644);

MODULE_AUTHOR("Stratos Karafotis <stratosk@semaphore.gr");
MODULE_AUTHOR("engstk <eng.stk@sapo.pt>");
MODULE_DESCRIPTION("'dyn_hotplug' - A dynamic hotplug driver for mako / hammerhead / shamu (blu_plug)");
MODULE_LICENSE("GPLv2");

late_initcall(dyn_hp_init);
module_exit(dyn_hp_exit);
