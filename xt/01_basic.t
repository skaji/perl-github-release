use strict;
use warnings;
use Test::More;
use GitHub::Release;

my $release = GitHub::Release->new;

my @tag = $release->get_tags("https://github.com/skaji/remote-pbcopy-iterm2");
diag explain \@tag;

my @asset = $release->get_assets("https://github.com/skaji/remote-pbcopy-iterm2", $tag[1]);
diag explain \@asset;

my $tag = $release->get_latest_tag("https://github.com/skaji/remote-pbcopy-iterm2");
diag $tag;

@asset = $release->get_latest_assets("https://github.com/skaji/remote-pbcopy-iterm2");
diag explain \@asset;

pass "ok";

done_testing;
