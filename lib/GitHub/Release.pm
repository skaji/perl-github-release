package GitHub::Release;
use strict;
use warnings;

use HTTP::Tinyish 0.18;

sub new {
    my $class = shift;
    bless {
        http => HTTP::Tinyish->new,
        http_no_redirect => HTTP::Tinyish->new(max_redirect => 0),
    }, $class;
}

sub get_latest_tag {
    my ($self, $url) = @_;
    $url = "$url/releases/latest";
    my $res = $self->{http_no_redirect}->get($url);
    if ($res->{status} !~ /^3/) {
        die "$res->{status}, $url\n";
    }
    my $loc = $res->{headers}{location};
    (split /\//, $loc)[-1];
}

sub get_latest_assets {
    my ($self, $url) = @_;
    $url = "$url/releases/latest";
    my $res = $self->{http}->get($url);
    if (!$res->{success}) {
        die "$res->{status}, $url\n";
    }
    my @href = $res->{content} =~ m{ href="(.+?)" }xgi;
    map { m{^https} ? $_ : "https://github.com$_" } grep { m{/releases/download/} } @href;
}

1;
