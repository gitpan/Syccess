
requires 'Moo', '0';
requires 'Module::Runtime', '0';
requires 'Module::Load::Conditional', '0';
requires 'Scalar::Util', '0';

on test => sub {
  requires 'Test::More', '0';
};
