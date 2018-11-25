#!/usr/bin/env perl

use lib "local/lib/perl5";
use lib "lib";

use App1;
use App2;
use App3;
use App4;
use Benchmark 'cmpthese';


my $app1 =  App1->new;
my $app2 =  App2->new;
my $app3 =  App3->new;
my $app4 =  App4->new;


sub app1_get { $app1->foo }
sub app1_set { $app1->foo( 33 ) }

sub app2_get { $app2->foo }
sub app2_set { $app2->foo( 33 ) }

sub app3_get { $app3->foo }
sub app3_set { $app3->foo( 33 ) }

sub app4_get { $app4->foo }
sub app4_set { $app4->foo( 33 ) }

cmpthese( 10_000_000, {
	app1_get => \&app1_get,
	app1_set => \&app1_set,
	app2_get => \&app2_get,
	app2_set => \&app2_set,
	app3_get => \&app3_get,
	app3_set => \&app3_set,
	app4_get => \&app4_get,
	app4_set => \&app4_set,
});


__END__

               Rate app2_set app2_get app3_set app1_set app3_get app1_get app4_set app4_get
app2_set  1152074/s       --     -20%     -65%     -66%     -72%     -77%     -88%     -92%
app2_get  1434720/s      25%       --     -56%     -57%     -65%     -72%     -85%     -90%
app3_set  3246753/s     182%     126%       --      -3%     -21%     -36%     -67%     -78%
app1_set  3344482/s     190%     133%       3%       --     -19%     -34%     -66%     -78%
app3_get  4115226/s     257%     187%      27%      23%       --     -19%     -58%     -72%
app1_get  5102041/s     343%     256%      57%      53%      24%       --     -47%     -66%
app4_set  9708738/s     743%     577%     199%     190%     136%      90%       --     -35%
app4_get 14925373/s    1196%     940%     360%     346%     263%     193%      54%       --


Also see https://metacpan.org/pod/Class::Accessor::Grouped#Benchmark
