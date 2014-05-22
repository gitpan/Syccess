package Syccess::Validator;
BEGIN {
  $Syccess::Validator::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: Syccess validator
$Syccess::Validator::VERSION = '0.002';
use Moo::Role;

requires qw(
  validate
);

has syccess_field => (
  is => 'ro',
  required => 1,
  handles => [qw(
    syccess
  )],
);

has arg => (
  is => 'ro',
  predicate => 1,
);

1;

__END__

=pod

=head1 NAME

Syccess::Validator - Syccess validator

=head1 VERSION

version 0.002

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Torsten Raudssus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
