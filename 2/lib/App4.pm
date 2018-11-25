package App4;

use Class::XSAccessor
	constructor => 'new',
	getters     => {
		get_foo => 'foo',
	},
	setters => {
		set_foo => 'foo',
	},
	accessors => {
		foo => 'foo',
	};


1;
