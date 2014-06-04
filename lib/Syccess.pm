package Syccess;
BEGIN {
  $Syccess::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: Easy Validation Handler
$Syccess::VERSION = '0.006';
use Moo;
use Module::Runtime qw( use_module );
use Tie::IxHash;

with qw(
  MooX::Traits
);

has validator_namespaces => (
  is => 'lazy',
);

sub _build_validator_namespaces {
  my ( $self ) = @_;
  return [
    @{$self->custom_validator_namespaces},
    'Syccess::Validator',
    'SyccessX::Validator',
  ];
}

has custom_validator_namespaces => (
  is => 'lazy',
);

sub _build_custom_validator_namespaces {
  return [];
}

has field_class => (
  is => 'lazy',
);

sub _build_field_class {
  return 'Syccess::Field';
}

has field_traits => (
  is => 'ro',
  predicate => 1,
);

has result_class => (
  is => 'lazy',
);

sub _build_result_class {
  return 'Syccess::Result';
}

has result_traits => (
  is => 'ro',
  predicate => 1,
);

has error_class => (
  is => 'lazy',
);

sub _build_error_class {
  return 'Syccess::Error';
}

has error_traits => (
  is => 'ro',
  predicate => 1,
);

has fields_args => (
  is => 'ro',
  predicate => 1,
);

has errors_args => (
  is => 'ro',
  predicate => 1,
);

has fields_list => (
  is => 'ro',
  required => 1,
  init_arg => 'fields',
);

has fields => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_fields {
  my ( $self ) = @_;
  my @fields;
  my $fields_list = Tie::IxHash->new(@{$self->fields_list});
  for my $key ($fields_list->Keys) {
    push @fields, $self->new_field($key,$fields_list->FETCH($key));
  }
  return [ @fields ];
}

sub field {
  my ( $self, $name ) = @_;
  my @field = grep { $_->name eq $name } @{$self->fields};
  return scalar @field ? $field[0] : undef;
}

has resulting_field_class => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_resulting_field_class {
  my ( $self ) = @_;
  my $field_class = use_module($self->field_class);
  if ($self->has_field_traits) {
    $field_class = $field_class->with_traits(@{$self->field_traits});
  }
  return $field_class;
}

sub new_field {
  my ( $self, $name, $validators_list ) = @_;
  my %fields_args = $self->has_fields_args
    ? (%{$self->fields_args}) : ();
  return $self->resulting_field_class->new(
    %fields_args,
    syccess => $self,
    name => $name,
    validators => $validators_list,
  );
}

sub validate {
  my ( $self, %params ) = @_;
  my $result_class = use_module($self->result_class);
  if ($self->has_result_traits) {
    $result_class = $result_class->with_traits(@{$self->result_traits});
  }
  return $result_class->new(
    syccess => $self,
    params => { %params },
  );
}

sub BUILD {
  my ( $self ) = @_;
  $self->fields;
}

1;

__END__

=pod

=head1 NAME

Syccess - Easy Validation Handler

=head1 VERSION

version 0.006

=head1 SYNOPSIS

  use Syccess;

  my $syccess = Syccess->new(
    fields => [
      foo => [ required => 1, length => 4, label => 'PIN Code' ],
      bar => [ required => { message => 'You have 5 seconds to comply.' } ],
      baz => [ length => { min => 2, max => 4 }, label => 'Ramba Zamba' ],
    ],
  );

  my $result = $syccess->validate( foo => 1, bar => 1 );
  if ($result->success) {
    print "Yeah!\n";
  }

  my $failed = $syccess->validate();
  unless ($result->success) {
    for my $message (@{$failed->errors}) {
      print $message->message."\n";
    }
  }

  my $traitsful_syccess = Syccess->new(
    result_traits => [qw( MyApp::Syccess::ResultRole )],
    error_traits => [qw( MyApp::Syccess::ErrorRole )],
    field_traits => [qw( MyApp::Syccess::FieldRole )],
    fields => [
      # ...
    ],
  );

=head1 DESCRIPTION

Syccess is developed for L<SyContent|https://sycontent.de/>.

B<BEHAVIOUR INFO:> The validators provided by the Syccess core are all
designed to ignore a non existing value, an undefined value or an empty
string. If you want that giving those leads to an error, then you must use the
B<required> validator of B<Syccess::Validator::Required>. If you need to check
against those values, for example you use B<Syccess::Validator::Code> and in
some cases an undefined value is valid and sometimes not, then you must make
a custom validator, see L</custom_validator_namespaces>.

=head1 ATTRIBUTES

=head2 fields

Required ArrayRef containing the definition of the fields for the validation.
It always first the name of the field and then an ArrayRef again with the
validators. Those will be dispatched to instantiation L<Syccess::Field> to
create the B<fields> objects. See more about validators on its attribute at
L<Syccess::Field>.

=head2 validator_namespaces

This attribute is the main namespace collection, where Syccess searches for
its validators. Normally you do not set it directly, instead you set
B<custom_validator_namespaces>, else you would remove B<Syccess::Validator>
and the B<SyccessX::Validator>, which are automatically added after the
B<custom_validator_namespaces> by default here.

=head2 custom_validator_namespaces

Here you define an ArrayRef of the namespaces that should be used additional
to the default ones. For example, if you add validator B<foo_bar>, then
Syccess would search first with your custom namespace, for example
B<MyApp::Validator::FooBar>, and after that it checks for
B<Syccess::Validator::FooBar> and finally B<SyccessX::Validator::FooBar>.

For making custom validator, you must use the L<Syccess::Validator> role, which
allows to check over all params given. If you just want to make a simple
validator that checks against only the relevant value of the field, then you
can use L<Syccess::ValidatorSimple>.

Please use B<SyccessX::Validator> as namespace if you want to upload a new
general validator to B<CPAN>.

=head2 result_class

The class which is used for the result. Default is L<Syccess::Result>.

=head2 error_class

The class which is used for errors. Default is L<Syccess::Error>.

=head2 field_class

The class which is used for the fields. Default is L<Syccess::Field>.

=head2 result_traits

Traits to be added to the L<Syccess::Result> class. See B<with_traits> at
L<MooX::Traits>.

=head2 error_traits

Traits to be added to the L<Syccess::Error> class. See B<with_traits> at
L<MooX::Traits>.

=head2 field_traits

Traits to be added to the L<Syccess::Field> class. See B<with_traits> at
L<MooX::Traits>.

=head2 fields_args

Here you can give custom attributes which are dispatched to the instantiation
of the L</field_class> objects.

=head2 errors_args

Here you can give custom attributes which are dispatched to the instantiation
of the L</error_class> objects.

=head1 METHODS

=head2 new_with_traits

See L<MooX::Traits>.

=head2 field

Get the L<Syccess::Field> for the name given as parameter.

=head2 fields

Get all L<Syccess::Field> of the Syccess object.

=head2 validate

This is the main function to produce a L</result_class> object, which will
then hold the result and the errors of the validation process. This function
must be called with a Hash (no HashRef yet supported) of the values to check
for the validation.

=encoding utf8

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome

Issue Tracker

  http://github.com/SyContent/Syccess/issues

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Torsten Raudssus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
