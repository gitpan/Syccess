package Syccess::Error;
BEGIN {
  $Syccess::Error::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: Syccess error message
$Syccess::Error::VERSION = '0.008';
use Moo;

with qw(
  MooX::Traits
);

has syccess_field => (
  is => 'ro',
  required => 1,
);

has syccess_result => (
  is => 'ro',
  required => 1,
);

has message => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_message {
  my ( $self ) = @_;
  my $validator_message = $self->validator_message;
  my $format;
  my @args = ( $self->syccess_field->label );
  if (ref $validator_message eq 'ARRAY') {
    my @sprintf_args = @{$validator_message};
    $format = shift @sprintf_args;
    push @args, @sprintf_args;
  } else {
    $format = $validator_message;
  }
  return sprintf($format,@args);
}

has validator_message => (
  is => 'ro',
  init_arg => 'message',
  required => 1,
);

1;

__END__

=pod

=head1 NAME

Syccess::Error - Syccess error message

=head1 VERSION

version 0.008

=head1 DESCRIPTION

This class is used to store an error and will be given back on the call of
L<Syccess::Field/errors> or L<Syccess::Result/errors>.

=head1 ATTRIBUTES

=head2 message

Contains the actual resulting error message.

=head2 syccess_field

References to the L<Syccess::Field> where this error comes from.

=head2 syccess_result

References to the L<Syccess::Result> where this error comes from.

=encoding utf8

=head1 SUPPORT

IRC

  Join #sycontent on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/SyContent/Syccess
  Pull request and additional contributors are welcome

Issue Tracker

  http://github.com/SyContent/Syccess/issues

=cut

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Torsten Raudssus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
