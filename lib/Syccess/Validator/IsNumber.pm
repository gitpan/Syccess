package Syccess::Validator::IsNumber;
BEGIN {
  $Syccess::Validator::IsNumber::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check if value is a number
$Syccess::Validator::IsNumber::VERSION = '0.004';
use Moo;
use Scalar::Util qw( looks_like_number );

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return '%s must be a number.';
}

sub validator {
  my ( $self, $value ) = @_;
  return $self->message unless looks_like_number($value);
  return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::IsNumber - A validator to check if value is a number

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ is_number => 1 ],
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
