#!/opt/sdr/report/perl/bin/perl
#
# COPYRIGHT: Copyright (c) 2011 System Data Recorder
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#  (http://www.gnu.org/copyleft/gpl.html)

use warnings;
use strict;
use XML::LibXML;
use XML::LibXML::XPathContext;
use 5.010;


# parser for XML configuration data
#
# Subroutines:
# 
#   1. open_conf
#   2. get_values



# Open XML configuration file
sub open_conf {
    my ($conf) = @_;
    my $tree;

    my $parser = XML::LibXML->new();
    $parser -> keep_blanks(0);
    # $parser->validation(1);

    # we will parse now the file
    if (-e "$ENV{'REPORT_PATH'}/etc/$conf") {
        $tree = $parser->parse_file("$ENV{'REPORT_PATH'}/etc/$conf");
    } elsif (-e "/opt/sdr/report/etc/$conf") {
        $tree = $parser->parse_file("/opt/sdr/report/etc/$conf");
    } else {
        die "Error: Cannot find configuration file $conf !\n";
        
    }

    # return the tree configuration
    return $tree;
}


# return an array of hashes
sub get_values {
    my ($conf, $path, $pat) = @_;
    my $expr;
    my @result;

    #if (defined $id) {
    #    $expr = $path . "[\@id=\"" . $id . "\"]/*";
    #} else {
        $expr = $path;
    #}


    print "Expr=$expr \n";
    #XPath Walking
    my @childs = $conf -> findnodes ($expr);

    foreach my $node (@childs) {

        #print "Node:" . $node->nodeName() . "\n";
        # check for cell | dcroom modes
        given($node->nodeName()) {

            # Cell Mode
            when('cell') {
                my $cellfile = $node->getAttribute('input');
                print "parsedb.pl: cellfile=$cellfile \n";
                my $tree = open_conf($cellfile);

                # cell->host
                my @cchilds = $tree -> findnodes ("/cell/*");
                foreach my $cnode (@cchilds) {
                    next if $cnode->nodeName() !~ /$pat/;
                    #print "Filtered Node:" . $cnode->nodeName() . "\n";
                    push @result, { $cnode->getAttribute('name')
                                    . ":"
                                    . $cnode->getAttribute('type') ,
                                    $cnode->getAttribute('os') };

                }
            }

            # DataCenter Room Mode
            when('dcroom') {
                my $dcrfile = $node->getAttribute('input');
                print "parsedb.pl: dcroomfile=$dcrfile \n";
                my $tree = open_conf($dcrfile);

                # dcroom->rackN->host
                my @dchilds = $tree -> findnodes ("/dcroom/rack/*");
                foreach my $dnode (@dchilds) {
                    next if $dnode->nodeName() !~ /$pat/;
                    # print "Filtered Node:" . $dnode->nodeName() . "\n";
                    push @result, { $dnode->getAttribute('name')
                                    . ":"
                                    . $dnode->getAttribute('type') ,
                                    $dnode->getAttribute('os') };

                }
            }
        }

        next if $node->nodeName() !~ /$pat/;
        #print "Filtered Node:" . $node->nodeName() . "\n";

        given($pat) {

            when('docroot') {
                return $node->getAttribute('path');
            }
            
            when('host') {
             push @result, { $node->getAttribute('name') 
                             . ":" 
                             . $node->getAttribute('type') , 
                             $node->getAttribute('os') }; 
            }

            default { return ; }
        }
    }

    return @result;
}

1;
