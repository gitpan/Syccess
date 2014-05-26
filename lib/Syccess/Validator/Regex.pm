package Syccess::Validator::Regex;
BEGIN {
  $Syccess::Validator::Regex::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check with a regex
$Syccess::Validator::Regex::VERSION = '0.004';
use Moo;

with qw(
  Syccess::ValidatorSimple
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return 'Your value for %s is not valid.';
}

sub validator {
  my ( $self, $value ) = @_;
  my $regex = $self->arg;
  my $r = ref $regex eq 'Regexp' ? $regex : qr{$regex};
  return $self->message unless $value =~ m/$r/;
  return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::Regex - A validator to check with a regex

=head1 VERSION

version 0.004

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ regex => qr/^\w+$/ ],
      bar => [ regex => {
        arg => '^[a-z]+$', # will be converted to regexp
        message => 'We only allow lowercase letters on this field.',
      } ],
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
