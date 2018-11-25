#!/usr/bin/env perl

use lib "local/lib/perl5";

use Benchmark 'cmpthese';
use Crypt::PRNG qw/ random_string irand rand /;


## Prepare data
print "Generate hash with 1_000_000 values...\n";
my %h1;
for( 1..1_000_000 ) {
	my $key     =  random_string( 10 );
	my $value   =  int rand(900000)+100000; # [100000..999999)
	$h1{ $key } =  $value;
}


sub report {
	my( $initial, $result ) =  @_;

	my $initial_count  =  keys %$initial;
	my $filtered_count =  keys %$result;
	printf "There are %d uniq values at %d\n",
		$filtered_count, $initial_count;
}



sub native {
	my %tmp =  %h1; # make environment same

	my %res =  reverse %h1;
	%res =  reverse %res;


	report( \%h1, \%res );
}



sub manual_opt {
	my %tmp =  %h1; # make environment same

	my %track;
	my( $key, $value ); # reuse old memory for efficiency
	while( ( $key, $value ) =  each %h1 ) {
		!exists $track{ $value }   or next;
		$track{ $value } =  $key;
	}


	my %res =  reverse %track;
	report( \%h1, \%res );
}



sub manual {
	my %tmp =  %h1; # make environment same

	my %track;
	while( my( $key, $value ) =  each %h1 ) {
		!exists $track{ $value }   or next;
		$track{ $value } =  $key;
	}


	my %res =  reverse %track;
	report( \%h1, \%res );
}



sub del_opt {
	my %res =  %h1; # make environment same

	my %track;
	my( $key, $value );
	while( ( $key, $value ) =  each %res ) {
		!exists $track{ $value }   or do{
			delete $res{ $key };
			next;
		};

		$track{ $value } =  1;
	}


	report( \%h1, \%res );
}



sub del {
	# Because we modify source data we copy initial data to leave it intact.
	# In real life we do need this copy
	my %res =  %h1; # NOTICE: We put this copying into other subs too to make
	# environment same

	my %track;
	while( my( $key, $value ) =  each %res ) {
		!exists $track{ $value }   or do{
			delete $res{ $key };
			next;
		};

		$track{ $value } =  1;
	}


	report( \%h1, \%res );
}


print "Comparing subs...\n";
cmpthese( 20, {
	native     =>  \&native,
	manual_opt =>  \&manual_opt,
	manual     =>  \&manual,
	del_opt    =>  \&del_opt,
	del        =>  \&del,
});



__END__
           s/iter     native     manual manual_opt        del    del_opt
native       5.37         --       -18%       -20%       -44%       -45%
manual       4.41        22%         --        -3%       -32%       -33%
manual_opt   4.29        25%         3%         --       -30%       -31%
del          2.98        80%        48%        44%         --        -1%
del_opt      2.97        81%        49%        44%         1%         --
