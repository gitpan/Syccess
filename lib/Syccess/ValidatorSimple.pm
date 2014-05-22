package Syccess::ValidatorSimple;
BEGIN {
  $Syccess::ValidatorSimple::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: Syccess validator
$Syccess::ValidatorSimple::VERSION = '0.002';
use Moo::Role;

with qw(
  Syccess::Validator
);

requires qw(
  validator
);

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return if !exists($params{$name})
    && $self->missing_ok;
  return if exists($params{$name})
    && !defined($params{$name})
    && $self->undef_ok;
  return if exists($params{$name})
    && defined($params{$name})
    && $params{$name} eq ''
    && $self->empty_ok;
  return exists($params{$name})
    ? $self->validator($params{$name})
    : $self->validator();
}

sub missing_ok { 1 }
sub undef_ok { 1 }
sub empty_ok { 1 }

1;

__END__

=pod

=head1 NAME

Syccess::ValidatorSimple - Syccess validator

=head1 VERSION

version 0.002

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Torsten Raudssus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
