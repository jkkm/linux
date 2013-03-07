/*
 * FIPS 200 support.
 *
 * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 */

#include "internal.h"

int fips_enabled;
EXPORT_SYMBOL_GPL(fips_enabled);

/* forbid loading modules in fips mode if the module is not signed */
int crypto_sig_check(struct module *m)
{
#if defined(CONFIG_MODULE_SIG)
	if (!fips_enabled || !m || (m && m->sig_ok))
		return 1;
	else
		return 0;
#else
	return 1;
#endif
}

/* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
static int fips_enable(char *str)
{
	fips_enabled = !!simple_strtol(str, NULL, 0);
	printk(KERN_INFO "fips mode: %s\n",
		fips_enabled ? "enabled" : "disabled");
	return 1;
}

__setup("fips=", fips_enable);
