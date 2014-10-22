package Syccess::Validator::Length;
BEGIN {
  $Syccess::Validator::Length::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check the length of the value in chars
$Syccess::Validator::Length::VERSION = '0.005';
use Moo;
use Carp qw( croak );

with qw(
  Syccess::ValidatorSimple
);

has min => (
  is => 'ro',
  predicate => 1,
);

has max => (
  is => 'ro',
  predicate => 1,
);

sub BUILD {
  my ( $self ) = @_;
  croak __PACKAGE__.' cant have arg (specific length) and min/max'
    if $self->has_arg && ( $self->has_min || $self->has_max );
}

has message => (
  is => 'lazy',
);

sub _build_message {
  my ( $self ) = @_;
  if ($self->has_arg) {
    return [ $self->format, $self->arg ];
  } else {
    if ($self->has_min && $self->has_max) {
      return [ $self->format, $self->min, $self->max ];
    } elsif ($self->has_min) {
      return [ $self->format, $self->min ];
    } elsif ($self->has_max) {
      return [ $self->format, $self->max ];
    }
  }
  croak __PACKAGE__.' needs an arg, min or max value';
}

has format => (
  is => 'lazy',
);

sub _build_format {
  my ( $self ) = @_;
  if ($self->has_arg) {
    return '%s must be exactly %s characters.';
  } else {
    if ($self->has_min && $self->has_max) {
      return '%s must be between %s and %s characters.';
    } elsif ($self->has_min) {
      return '%s must be at least %s characters.';
    } elsif ($self->has_max) {
      return '%s is not allowed to be more than %s characters.';
    }
  }
  croak __PACKAGE__.' needs an arg, min or max value';
}

sub validator {
  my ( $self, $value ) = @_;
  my $length = length($value);
  if ($self->has_arg) {
    return $self->message if $length != $self->arg;
  } else {
    if ($self->has_min && $self->has_max) {
      return $self->message if $length < $self->min || $length > $self->max;
    } elsif ($self->has_min) {
      return $self->message if $length < $self->min;
    } elsif ($self->has_max) {
      return $self->message if $length > $self->max;
    }
  }
  return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::Length - A validator to check the length of the value in chars

=head1 VERSION

version 0.005

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      pin => [ length => 4 ],
      username => [ length => {
        min => 3,
        max => 12,
        message => 'Username must be between %s and %s characters.'
      } ],
      tweet => [ length => { max => 140 } ],
    ],
  );

=head1 DESCRIPTION

This validator allows to check for the amount of characters in the value.
The default error message depends on the parameter given.

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
