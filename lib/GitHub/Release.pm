package GitHub::Release 0.001;
use v5.16;
use warnings;

use HTTP::Tinyish;

sub new {
    my $class = shift;
    my $http = HTTP::Tinyish->new(verify_SSL => 1);
    bless { http => $http }, $class;
}

sub get_tags {
    my ($self, $url) = @_;
    $url = "$url/releases";
    my $res = $self->{http}->get($url);
    if (!$res->{success}) {
        die "$res->{status}, $url\n";
    }
    my @href = $res->{content} =~ m{ href="(.+?)" }xgi;
    map { m{/releases/tag/([^/]+)} ? $1 : () } @href;
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
    my @tag = $self->get_tags($url);
    $tag[0];
}

sub get_latest_assets {
    my ($self, $url) = @_;
    my $tag = $self->get_latest_tag($url);
    $self->get_assets($url, $tag);
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
