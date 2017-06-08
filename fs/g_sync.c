/*
 * Port of Dynamic Sync v2.0 (andip71) to ZF2 & x86 [Ghost Sync]
 *
 * Copyright (C) 2016 Andip71 <andreasp@gmx.de> (Original Implementation)
 *
 * Copyright (C) 2017 Nutcasev1.5 <win.api_10@outlook.com> (Z00A/8 Implementation & Adoption to Intel x86)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <linux/module.h>
#include <linux/earlysuspend.h>
#include <linux/notifier.h>
#include <linux/reboot.h>

extern bool g_sync;
extern bool sync_in_suspend;

extern int sys_sync(void);

static void g_sync_suspend(struct early_suspend *h)
{
	if (g_sync) {
		sync_in_suspend = true;
		sys_sync();
	}
}

static void g_sync_resume(struct early_suspend *h)
{
	if (g_sync)
		sync_in_suspend = false;
}

static struct early_suspend g_sync_handler __refdata =
{
	.level = EARLY_SUSPEND_LEVEL_STOP_DRAWING,
	.suspend = g_sync_suspend,
	.resume = g_sync_resume,
};

static int g_sync_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
{
	sync_in_suspend = true;
	sys_sync();
	printk("%s: Force Sync", __func__);

	return NOTIFY_DONE;
}

static struct notifier_block g_sync_panic_block = {
	.notifier_call  = g_sync_panic_event,
	.priority       = INT_MAX,
};

static int g_sync_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
{
	if (code == SYS_DOWN || code == SYS_HALT) {
		sync_in_suspend = true;
		sys_sync();
		printk("%s: Force Sync", __func__);
	}
	return NOTIFY_DONE;
}

static struct notifier_block g_sync_notifier = {
	.notifier_call = g_sync_notify_sys,
};

static int __init g_sync_init(void)
{
	unsigned int ret;

	ret = register_reboot_notifier(&g_sync_notifier);
	if (ret)
		goto out;

	ret = atomic_notifier_chain_register(&panic_notifier_list, &g_sync_panic_block);
	if (ret)
		goto out;

	register_early_suspend(&g_sync_handler);

	printk("%s: Ghost Sync Init | Status: Online\n", __func__);

out:
	return ret;
}

static void g_sync_exit(void)
{
	g_sync = false;
	sys_sync();

	unregister_reboot_notifier(&g_sync_notifier);
	atomic_notifier_chain_unregister(&panic_notifier_list, &g_sync_panic_block);
	unregister_early_suspend(&g_sync_handler);

	printk("%s: Ghost Sync Exit\n", __func__);
}

MODULE_AUTHOR("Andip71 <andreasp@gmx.de>");
MODULE_AUTHOR("Nutcasev1.5 <win.api_10@outlook.com>");
MODULE_DESCRIPTION("Ghost Sync - A Fork of Dynamic FSync v2.0");
MODULE_LICENSE("GPLv2");

core_initcall(g_sync_init);
module_exit(g_sync_exit);
