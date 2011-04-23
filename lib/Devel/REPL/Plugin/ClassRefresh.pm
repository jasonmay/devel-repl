package Devel::REPL::Plugin::ClassRefresh;

use Devel::REPL::Plugin;
use namespace::clean -except => [ 'meta' ];
use Class::Refresh;

before eval => sub { Class::Refresh->refresh };

1;

__END__

=head1 NAME

Devel::REPL::Plugin::ClassRefresh - reload libraries with Class::Refresh

=head1 DESCRIPTION

This plugin runs L<Class::Refresh>->refresh before each line is evaluated.

=head1 AUTHOR

Jesse Luehrs <doy at tozt dot net>

=cut

