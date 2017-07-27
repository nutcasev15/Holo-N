/**************************************************************************
 * Copyright (c) 2012, Intel Corporation.
 * All Rights Reserved.

 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Authors:
 *    Javier Torres Castillo <javier.torres.castillo@intel.com>
 */

#include <rgxdf.h>
#include <linux/kernel.h>
#include <linux/earlysuspend.h>
#include <linux/module.h>
#include "dev_freq_graphics_pm.h"
#include "dev_freq_debug.h"

/*dfrgx copy of RGX power state ON/OFF*/
static int df_rgx_active = 0;

/* Screen Check Code */
static int gfx_screen_check = -1;
static void gfx_screen_online(struct early_suspend *h)
{
	gfx_screen_check = 1;
}

static void gfx_screen_offline(struct early_suspend *h)
{
	gfx_screen_check = 0;
}

static struct early_suspend gfx_check __refdata =
{
	.level = EARLY_SUSPEND_LEVEL_DISABLE_FB,
	.suspend = gfx_screen_offline,
	.resume = gfx_screen_online,
};

static int gfx_screen_hook(void)
{
	register_early_suspend(&gfx_check);

	return 0;
}

static void gfx_screen_unhook(void)
{
	unregister_early_suspend(&gfx_check);
}

late_initcall(gfx_screen_hook);
module_exit(gfx_screen_unhook);

/**
 * df_rgx_is_active() - Determines if RGX device
 * is either ON or OFF, it queries the state.
 */
int df_rgx_is_active(void)
{
	DFRGX_DPF(DFRGX_DEBUG_LOW, "%s\n",
		__func__);

	if (gfx_screen_check == -1)
		gfx_screen_check = 1;

	/*Initially We need to know the state of RGX ON/OFF,
	 *then We keep a local copy of it
	*/
	if (rgx_is_device_powered() && gfx_screen_check) {
		DFRGX_DPF(DFRGX_DEBUG_MED, "%s: RGX is Powered ON\n",
		__func__);
		df_rgx_active = 1;
	} else {
		DFRGX_DPF(DFRGX_DEBUG_HIGH, "%s: RGX is Powered OFF,"
		" dev freq will not change freq\n",
		__func__);
		df_rgx_active = 0;
	}

	return df_rgx_active;
}

