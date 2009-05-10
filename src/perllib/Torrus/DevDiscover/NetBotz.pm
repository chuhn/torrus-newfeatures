#  Copyright (C) 2009 Stanislav Sinyagin
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
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# $Id$

# NetBotz modular sensors

package Torrus::DevDiscover::NetBotz;

use strict;
use Torrus::Log;


$Torrus::DevDiscover::registry{'NetBotz'} = {
    'sequence'     => 500,
    'checkdevtype' => \&checkdevtype,
    'discover'     => \&discover,
    'buildConfig'  => \&buildConfig
    };


our %oiddef =
    (
     'netBotzV2Products'     => '1.3.6.1.4.1.5528.100.20',
     );


our %sensor_types =
    ('temp'   => {
        'oid' => '1.3.6.1.4.1.5528.100.4.1.1.1',
        'template' => 'NetBotz::netbotz-temp-sensor'
        },
     'humi'   => {
         'oid' => '1.3.6.1.4.1.5528.100.4.1.2.1',
         'template' => 'NetBotz::netbotz-humi-sensor'
         },
     'dew'    => {
         'oid' => '1.3.6.1.4.1.5528.100.4.1.3.1',
         'template' => 'NetBotz::netbotz-dew-sensor'
         },
     'audio'  => {
         'oid' => '1.3.6.1.4.1.5528.100.4.1.4.1',
         'template' => 'NetBotz::netbotz-audio-sensor'
         },
     'air' => {
         'oid' => '1.3.6.1.4.1.5528.100.4.1.5.1',
         'template' => 'NetBotz::netbotz-air-sensor'
         },
     'door' => {
         'oid' => '1.3.6.1.4.1.5528.100.4.2.2.1',
         'template' => 'NetBotz::netbotz-door-sensor'
         },
     );
     
     

sub checkdevtype
{
    my $dd = shift;
    my $devdetails = shift;

    if( not $dd->oidBaseMatch
        ( 'netBotzV2Products',
          $devdetails->snmpVar( $dd->oiddef('sysObjectID') ) ) )
    {
        return 0;
    }
    
    $devdetails->setCap('interfaceIndexingPersistent');

    return 1;
}


sub discover
{
    my $dd = shift;
    my $devdetails = shift;

    my $data = $devdetails->data();
    my $session = $dd->session();


    foreach my $stype (sort keys %sensor_types)
    {
        my $oid = $sensor_types{$stype}{'oid'};
        
        my $sensorTable = $session->get_table( -baseoid => $oid );

        if( defined( $sensorTable ) )
        {
            $devdetails->storeSnmpVars( $sensorTable );

            foreach my $INDEX ($devdetails->getSnmpIndices($oid . '.1'))
            {
                my $label = $devdetails->snmpVar( $oid . '.4.' . $INDEX );

                my $leafName = $label;
                $leafName =~ s/\W/_/g;

                my $param = {
                    'netbotz-sensor-index' => $INDEX,
                    'graph-title' => $label,
                    'precedence' => sprintf('%d', 1000 - $INDEX)
                };
            
                $data->{'NetBotz'}{$INDEX} = {
                    'param'    => $param,
                    'leafName' => $leafName,
                    'template' => $sensor_types{$stype}{'template'}};
            }
        }        
    }
    
    return 1;
}


sub buildConfig
{
    my $devdetails = shift;
    my $cb = shift;
    my $devNode = shift;

    my $data = $devdetails->data();

    foreach my $INDEX ( sort {$a<=>$b} keys %{$data->{'NetBotz'}} )
    {
        my $ref = $data->{'NetBotz'}{$INDEX};
        
        $cb->addLeaf( $devNode, $ref->{'leafName'}, $ref->{'param'},
                      [$ref->{'template'}] );
    }
}



1;


# Local Variables:
# mode: perl
# indent-tabs-mode: nil
# perl-indent-level: 4
# End:
