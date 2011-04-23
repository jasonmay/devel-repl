package Devel::REPL::Plugin::Time;

use Devel::REPL::Plugin;
use Time::HiRes 'time';
use namespace::clean -except => [ 'meta' ];

sub BEFORE_PLUGIN {
    my $self = shift;
    $self->load_plugin('Turtles');
}

sub expr_command_time {
    my $self = shift;
    my ($eval, @rest) = @_;

    my @ret;
    my $start = time;

    if (!defined wantarray) {
        $self->$eval(@rest);
    }
    elsif (wantarray) {
        @ret = $self->$eval(@rest);
    }
    else {
        $ret[0] = $self->$eval(@rest);
    }

    $self->print("Took " . (time - $start) . " seconds.\n");

    return !defined wantarray ? () : wantarray ? @ret : $ret[0];
}

1;

__END__

=head1 NAME

Devel::REPL::Plugin::Time - time specific commands

=head1 COMMANDS

This plugin provides the C<#time> command for your Devel::REPL shell. It will
run the code given, and print out how long it took to run afterwards.

=head1 AUTHOR

Jesse Luehrs <doy at tozt dot net>

=cut

