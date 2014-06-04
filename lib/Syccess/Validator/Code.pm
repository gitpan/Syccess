package Syccess::Validator::Code;
BEGIN {
  $Syccess::Validator::Code::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validator to check a value through a simple coderef
$Syccess::Validator::Code::VERSION = '0.005';
use Moo;

with qw(
  Syccess::Validator
);

has message => (
  is => 'lazy',
);

sub _build_message {
  return 'Your value for %s is not valid.';
}

sub validate {
  my ( $self, %params ) = @_;
  my $name = $self->syccess_field->name;
  return if !exists($params{$name})
    || !defined($params{$name})
    || $params{$name} eq '';
  my $value = $params{$name};
  my $code = $self->arg;
  my @return;
  for ($value) {
    push @return, $code->($self,%params);
  }
  return map { !defined $_ ? $self->message : $_ } @return;
}

1;

__END__

=pod

=head1 NAME

Syccess::Validator::Code - A validator to check a value through a simple coderef

=head1 VERSION

version 0.005

=head1 SYNOPSIS

  Syccess->new(
    fields => [
      foo => [ code => sub { $_ > 3 ? () : ('You are WRONG!') } ],
      bar => [ code => {
        arg => sub { $_ > 5 ? () : (undef) },
        message => 'You have 5 seconds to comply.'
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
