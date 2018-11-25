package MyApp::Accessor;

sub AUTOLOAD {
	my $attr =  $AUTOLOAD;
	*$AUTOLOAD =  sub{ @_ == 1? $_[0]{$attr} : ($_[0]{$attr} =  $_[1]) };
	goto &$AUTOLOAD;
}

1;
