package GitHub::Release;
use strict;
use warnings;

our $VERSION = '0.001';

use HTTP::Tinyish 0.18;

sub new {
    my $class = shift;
    bless {
        http => HTTP::Tinyish->new(verify_SSL => 1),
        http_no_redirect => HTTP::Tinyish->new(verify_SSL => 1, max_redirect => 0),
    }, $class;
}

sub get_tags {
    my ($self, $url) = @_;
    my ($owner, $repo) = $url =~ m{https://github.com/([^/]+)/([^/]+)};
    my $release_page_url = "https://github.com/$owner/$repo/releases";
    my $res = $self->{http}->get($release_page_url);
    if (!$res->{success}) {
        die "$res->{status}, $release_page_url\n";
    }
    my @tag = $res->{content} =~ m{"/$owner/$repo/releases/tag/(.+?)"}g;
    @tag;
}

sub get_assets {
    my ($self, $url, $tag) = @_;
    $url = "$url/releases/expanded_assets/$tag";
    my $res = $self->{http}->get($url);
    if (!$res->{success}) {
        die "$res->{status}, $url\n";
    }
    my @href = $res->{content} =~ m{ href="(.+?)" }xgi;
    map { m{^https} ? $_ : "https://github.com$_" } grep { m{/releases/download/} } @href;
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
    my $latest_tag = $self->get_latest_tag($url);
    $self->get_assets($url, $latest_tag);
}

1;
__END__

=encoding utf-8

=head1 NAME

GitHub::Release - blah blah blah

=head1 SYNOPSIS

  use GitHub::Release;

=head1 DESCRIPTION

GitHub::Release is

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
