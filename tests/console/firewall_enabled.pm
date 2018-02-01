# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Ensure firewall is running
# Maintainer: Oliver Kurz <okurz@suse.de>
# Tags: fate#323436

use base 'opensusebasetest';
use strict;
use testapi;
use version_utils 'is_jeos';
use utils 'zypper_call';

sub run {
    my ($self) = @_;
    if ($self->firewall eq 'firewalld') {
        if (is_jeos) {
            assert_script_run("grep '^FW_CONFIGURATIONS_EXT=\"sshd\"\\|^FW_SERVICES_EXT_TCP=\"ssh\"' /etc/sysconfig/SuSEfirewall2");
        }
        if (script_run('rpmquery firewalld')) {
            record_soft_failure('bsc#1078743 - firewalld not in JeOS image');
            zypper_call('install firewalld');
            assert_script_run('systemctl start firewalld.service');
        }
        assert_script_run('firewallctl state');
    }
    else {
        assert_script_run('SuSEfirewall2 status');
    }
}

1;
