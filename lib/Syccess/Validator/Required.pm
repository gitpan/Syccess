package Syccess::Validator::Required;
BEGIN {
  $Syccess::Validator::Required::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check for a required field
$Syccess::Validator::Required::VERSION = '0.003';
use Moo;

with qw(
  Syccess::Validator
);

has message => (
  is => 'lazy',
);

sub _build_message { '%s is required.' }

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return $self->message if !exists($params{$name})
    || !defined($params{$name})
    || $params{$name} eq '';
  return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::Required - A validator to check for a required field

=head1 VERSION

version 0.003

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ required => 1 ],
      bar => [ required => {
        message => 'You have 5 seconds to comply.'
      } ],
    ],
  );

=head1 DESCRIPTION

This validator allows to check if a field is required. The default error
message is B<%s is required.> and can be overriden via the B<message>
parameter.

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
