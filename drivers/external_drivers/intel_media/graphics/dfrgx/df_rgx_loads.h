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
 *    Nutcasev1.5 <tab.andsupp@gmail.com>
 */
#include "df_rgx_defs.h"
#include "dev_freq_debug.h"

/* Load Management Table:
 * Start from Hi to Lo Freqs */

int target_loads[] = {
/* Simple_Ondemand Configuration */
	92, /* 533 Mhz */
	87, /* 457 Mhz */
	78, /* 400 Mhz */
	66, /* 355 Mhz */
	58, /* 320 Mhz */
	46, /* 266 Mhz */
	33, /* 213 Mhz */
	0,  /* 200 Mhz, Needs to be 0 */

/* Performance Configuration */
	50, /* 533 Mhz */
	40, /* 457 Mhz */
	35, /* 400 Mhz */
	25, /* 355 Mhz */
	20, /* 320 Mhz */
	15, /* 266 Mhz */
	10, /* 213 Mhz */
	0,  /* 200 Mhz, Needs to be 0 */

/* Powersave Configuration */
	99, /* 533 Mhz */
	92, /* 457 Mhz */
	86, /* 400 Mhz */
	75, /* 355 Mhz */
	60, /* 320 Mhz */
	50, /* 266 Mhz */
	40, /* 213 Mhz */
	0  /* 200 Mhz, Needs to be 0 */

};

/* End Table */

static inline int get_gpu_target_table_offset(struct df_rgx_data_s *pdfrgx_data)
{
	int base;

	base = sku_levels();

	if (pdfrgx_data->g_profile_index == DFRGX_TURBO_PROFILE_SIMPLE_ON_DEMAND)
		return (0 * base);
	else if (pdfrgx_data->g_profile_index == DFRGX_TURBO_PROFILE_PERFORMANCE)
		return (1 * base);
	else if (pdfrgx_data->g_profile_index == DFRGX_TURBO_PROFILE_POWERSAVE)
		return (2 * base);

	/* Return Simple_Ondemand Config If Gov Not Recognized */
	return (0 * base);
}
