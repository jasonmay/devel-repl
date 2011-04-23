package Devel::REPL::Plugin::Editor;

use Devel::REPL::Plugin;
use namespace::clean -except => [ 'meta' ];
use autodie;
use File::HomeDir;
use Proc::InvokeEditor;

sub BEFORE_PLUGIN {
    my $self = shift;
    $self->load_plugin('Turtles');
}

has current_text => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has editor => (
    is      => 'ro',
    isa     => 'Proc::InvokeEditor',
    default => sub { Proc::InvokeEditor->new(keep_file => 1) },
);

sub command_e {
    my $self = shift;
    my ($eval, $filename) = @_;

    my $text;
    if (defined($filename) && length($filename)) {
        if ($filename =~ s+^~/+/+) {
            $filename = File::HomeDir->my_home . $filename;
        }
        elsif ($filename =~ s+^~([^/]*)/+/+) {
            $filename = File::HomeDir->users_home($1) . $filename;
        }

        my $current_text = do { local $/; open my $fh, '<', $filename; <$fh> };
        $text = Proc::InvokeEditor->edit($current_text, '.pl');
    }
    else {
        $text = $self->editor->edit($self->current_text, '.pl');
    }

    $self->current_text($text);
    $self->$eval($text);
}

1;

__END__

=head1 NAME

Devel::REPL::Plugin::Editor - load and execute bits of code in your editor

=head1 COMMANDS

This plugin provides the C<#e> command for your Devel::REPL shell. It will
launch your editor, and allow you to edit bits of code in your editor, which
will then be evaluated all at once. The text you entered will be saved, and
restored the next time you enter the command. Alternatively, you can pass a
filename to the C<#e> command, and the contents of that file will be preloaded
instead.

=head1 AUTHOR

Jesse Luehrs <doy at tozt dot net>

=cut

