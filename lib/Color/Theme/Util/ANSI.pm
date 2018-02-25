package Color::Theme::Util::ANSI;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       theme_color_to_ansi
               );

sub theme_color_to_ansi {
    require Color::ANSI::Util;

    my ($color_theme, $item, $args, $is_bg) = @_;

    my $c = $color_theme->{colors}{$item};
    return undef unless defined $c && length $c;

    # resolve coderef color
    if (ref($c) eq 'CODE') {
        $args //= {};
        $c = $c->("self", %$args);
    }

    if (ref $c) {
        my $ansifg = $c->{ansi_fg};
        $ansifg //= Color::ANSI::Util::ansifg($c->{fg})
            if defined $c->{fg};
        $ansifg //= "";
        my $ansibg = $c->{ansi_bg};
        $ansibg //= Color::ANSI::Util::ansibg($c->{bg})
            if defined $c->{bg};
        $ansibg //= "";
        $c = $ansifg . $ansibg;
    } else {
        $c = $is_bg ? Color::ANSI::Util::ansibg($c) :
            Color::ANSI::Util::ansifg($c);
    }
}

1;
# ABSTRACT: Utility routines related to color themes and ANSI code

=head1 FUNCTIONS

=head2 theme_color_to_ansi

Usage: theme_color_to_ansi($color_theme, $item, $args, $is_bg) => str


=head1 SEE ALSO

L<Color::Theme::Util>

L<Color::Theme::Role::ANSI>

L<Color::Theme>

=cut
