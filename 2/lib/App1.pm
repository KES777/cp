package App1;

use base 'MyApp::Accessor';

sub new {
	my $class = shift;
	return bless { @_ }, ref $class  ||  $class;
}

1;
