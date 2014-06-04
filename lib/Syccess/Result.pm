package Syccess::Result;
BEGIN {
  $Syccess::Result::AUTHORITY = 'cpan:GETTY';
}
# ABSTRACT: A validation process result
$Syccess::Result::VERSION = '0.006';
use Moo;
use Module::Runtime qw( use_module );

with qw(
  MooX::Traits
);

has syccess => (
  is => 'ro',
  required => 1,
);

has params => (
  is => 'ro',
  required => 1,
);

has success => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_success {
  my ( $self ) = @_;
  return $self->error_count ? 0 : 1;
}

has error_count => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_error_count {
  my ( $self ) = @_;
  return scalar @{$self->errors};
}

has errors => (
  is => 'lazy',
  init_arg => undef,
);

around errors => sub {
  my ( $orig, $self, @args ) = @_;
  my @errors = @{$self->$orig()};
  return [ @errors ] unless scalar @args > 0;
  my @args_errors;
  for my $error (@errors) {
    for my $arg (@args) {
      push @args_errors, $error if $error->syccess_field->name eq $arg;
    }
  }
  return [ @args_errors ];
};

has error_class => (
  is => 'lazy',
  init_arg => undef,
);

sub _build_error_class {
  my ( $self ) = @_;
  my $error_class = use_module($self->syccess->error_class);
  if ($self->syccess->has_error_traits) {
    $error_class = $error_class->with_traits(@{$self->syccess->error_traits});
  }
  return $error_class;
}

sub _build_errors {
  my ( $self ) = @_;
  my %params = %{$self->params};
  my @fields = @{$self->syccess->fields};
  my %errors_args = $self->syccess->has_errors_args
    ? (%{$self->syccess->errors_args}) : ();
  my @errors;
  for my $field (@fields) {
    my @messages = $field->validate( %params );
    for my $message (@messages) {
      my $ref = ref $message;
      if ($ref eq 'ARRAY' or !ref) {
        push @errors, $self->error_class->new(
          %errors_args,
          message => $message,
          syccess_field => $field,
          syccess_result => $self,
        );
      } elsif ($ref eq 'HASH') {
        my %error_args = %{$message};
        push @errors, $self->error_class->new(
          %errors_args,
          %error_args,
          syccess_field => $field,
          syccess_result => $self,
        );        
      } else {
        if (%errors_args && $message->can('errors_args')) {
          $message->errors_args({ %errors_args });
        }
        push @errors, $message;
      }
    }
  }
  return [ @errors ];
}

1;

__END__

=pod

=head1 NAME

Syccess::Result - A validation process result

=head1 VERSION

version 0.006

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 errors

Gives back an ArrayRef of all errors, if no parameter is given. If you give
a list of field names as parameters, then you will only get the errors of
those specific fields.

=head2 error_count

Gives back the amount of errors.

=head2 success

Gives back a Bool value which indicates if the result of the validation was
a general success or not, or other said, if there are no errors.

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
