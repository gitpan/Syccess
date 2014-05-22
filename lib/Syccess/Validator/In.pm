package Syccess::Validator::In;
BEGIN {
  $Syccess::Validator::In::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check if a value is inside of a list of values
$Syccess::Validator::In::VERSION = '0.002';
use Moo;
use Carp qw( croak );

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub BUILD {
  my ( $self ) = @_;
  croak __PACKAGE__." arg must be ARRAY" unless ref $self->arg eq 'ARRAY';
}

sub _build_message {
  return 'This value for %s is not allowed.';
}

sub validator {
  my ( $self, $value ) = @_;
  my @values = @{$self->arg};
  return $self->message unless grep { $value eq $_ } @values;
  return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::In - A validator to check if a value is inside of a list of values

=head1 VERSION

version 0.002

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ in => [qw( a b c )] ],
    ],
  );

=head1 DESCRIPTION

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
