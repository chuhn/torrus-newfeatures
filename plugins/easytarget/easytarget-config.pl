#  Copyright (C) 2003  Stanislav Sinyagin
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

# Stanislav Sinyagin <ssinyagin@k-open.com>


# DO NOT EDIT THIS FILE!

# Torrus EasyTarget default configuration
# Put all your local settings into easytarget-siteconfig.pl

use lib(@perllibdirs@);

$Torrus::EasyTarget::version        = '@VERSION@';
$Torrus::EasyTarget::easytargetDir  = '@sitedir@/easytarget/';
$Torrus::EasyTarget::siteXmlDir     = '@sitexmldir@';

@Torrus::EasyTarget::defaultIncludes = ('snmp-defs.xml');
@Torrus::EasyTarget::defaultTemplates = ('snmp-defaults');

%Torrus::EasyTarget::defaultParams =
    ('data-dir'          => '@defrrddir@',
     'data-file'         => '%system-id%.easytarget.rrd',
     'snmp-version'      => '2c',
     'snmp-port'         => 161,
     'rrd-create-dstype' => 'COUNTER',
     'nodeid'            => 'et//%easytarget-node%');
     
     



require '@easytarget_siteconfig_pl@';

1;
