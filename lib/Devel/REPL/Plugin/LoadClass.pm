package Devel::REPL::Plugin::LoadClass;
use Devel::REPL::Plugin;
use namespace::clean -except => [ 'meta' ];

around eval => sub {
    my ($next, $self, @args) = @_;

    my @result = $self->$next(@args);
    my $error = $result[0];

    if(blessed $error &&
       $error->isa('Devel::REPL::Error') &&
       $error->type eq 'Runtime error' &&
       $error->message =~ /perhaps you forgot to load "([^"]+)"\?/){

        eval {
            Class::MOP::load_class($1);
        };
        if($@){
            return @result;
        }

        return $self->$next(@args);
    }

    return @result;
};

1;

__END__

=head1 NAME

Devel::REPL::Plugin::LoadClass - automatically load used classes

=head1 DESCRIPTION

This plugin allows you to not have to explicitly C<use> modules before using
them in the repl. It catches the C<perhaps you forgot to load> error from perl
when trying to do things with classes that don't exist, and automatically loads
the module and re-evals the code.

=head1 AUTHOR

Jonathan Rockway <jrockway@cpan.org>

=cut

