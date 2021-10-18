# perl github releases

Get latest asset urls of GitHub Releases

# Usage

```perl
use GitHub::Release;

my $release = GitHub::Release->new;

my $url = "https://github.com/skaji/remote-pbcopy-iterm2";

my $tag = $release->get_latest_tag($url);
# 0.0.5

my @asset = $release->get_latest_assets($url);
# [
#   'https://github.com/skaji/remote-pbcopy-iterm2/releases/download/0.0.5/pbcopy-checksums.txt',
#   'https://github.com/skaji/remote-pbcopy-iterm2/releases/download/0.0.5/pbcopy-darwin-amd64.tar.gz',
#   'https://github.com/skaji/remote-pbcopy-iterm2/releases/download/0.0.5/pbcopy-darwin-arm64.tar.gz',
#   'https://github.com/skaji/remote-pbcopy-iterm2/releases/download/0.0.5/pbcopy-linux-amd64.tar.gz',
#   'https://github.com/skaji/remote-pbcopy-iterm2/releases/download/0.0.5/pbcopy-linux-arm64.tar.gz'
# ]
```

# Install

```
cpm install -g https://github.com/skaji/perl-github-release.git
```

# Author

Shoichi Kaji

# License

Artistic-1.0-Perl OR GPL-1.0-or-later
