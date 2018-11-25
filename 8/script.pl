#!/usr/bin/env perl

use strict;
use warnings;

my @arr;
$arr[1_000_000] =  undef; # Preallocate memory;
@arr =  ();

# Fill array with values: [1_000_000..10_000_000)
push @arr, int rand(9_000_000)+1_000_000   for 0..1_000_000;
@arr =  sort @arr;


sub find_index {
	my( $arr, $target ) =  @_;

	my $first =  0;
	my $last  =  $#$arr;

	my $next;
	# Binary search
	while( $last -$first > 1 ) {
		$next =  int( ( $last +$first )/2 );
		$arr->[ $next ] > $target? $last =  $next : $first =  $next;
	}


	# If value at first index is closer to our target than value at last index
	# then return
	($target -$arr[ $first ]) < ($arr[ $last ] -$target)?
		return $first:
		return $last;
}

# my $idx =  find_index( \@arr, 2000000 );
# print "The index with most closest value is $idx\n";

# print "Values around:\n";
# print $arr[ $_ ] ."\n"  for $idx-1..$idx+1;



use Benchmark 'timethis';
timethis( 1_000_000, sub{ find_index( \@arr, 200000 ) } );
