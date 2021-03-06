#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

# kstest.pl

@data = (11.72, 10.43, 8.02, 7.58, 1.43, 4.12);
@sorted = sort { $a <=> $b } @data;
$num= @sorted; # number of observations

$smean = 0.0;
foreach $ds (@sorted ) { $smean += $ds; }
$smean /= $num;

# Compute Exp CDF
foreach $ds (@sorted) {
    push(@expCDF, 1 - exp(-$ds / $smean));
}

# Compare data against Exp CDF
$D = 0.0;
for ($j = 1; $j <= $num; $j++) {
    $fn = $j / $num;
    $ff = $expCDF[$j-1];
    $Dt = max(abs($fo - $ff), abs($fn - $ff));
    if ($Dt > $D) { $D = $Dt };
    $fo = $fn;
}
$K = sqrt($num) * $D;
$pvalue = 1 - exp(-2 * $K**2) * ( 1 - 2 * $K / (3 * sqrt($num)));

## Print the results
print "Data  : "; printdata(@data);
print "Ranked: "; printdata(@sorted);
print "ExpCDF: "; printdata(@expCDF);
print "\n" . "K-S Statistics\n" . "--------------\n";
printf("Observations: %2.0f\n", $num);
printf("Sample mean : %7.4f\n", $smean);
printf("D statistic : %7.4f\n", $D);
printf("K statistic : %7.4f\n", $K);
printf("Probability : %7.4f\n", $pvalue);

#---- Subroutines ----#
sub printdata {
    my $datum;
    foreach $datum (@_ ) { 
        printf("%7.4f ", $datum);
    }
    print "\n";
}

sub max {
    my $max = shift(@_);
    foreach $next (@_) {
        $max = $next if $max < $next;
    }
    return $max;
}
