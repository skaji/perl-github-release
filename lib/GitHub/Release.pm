package GitHub::Release;
use strict;
use warnings;

our $VERSION = '0.001';

{
    package _HTTP;
    use parent 'HTTP::Tinyish::Curl';
    sub new {
        my ($class, %argv) = @_;
        $class->configure;
        $class->supports("https") or die "missing curl";
        $class->SUPER::new(verify_SSL => 1, agent => "Mozilla/5.0", %argv);
    }
    sub build_options {
        my ($self, $url, $opts) = @_;
        my @option = $self->SUPER::build_options($url, $opts);
        if (exists $self->{max_redirect} && !$self->{max_redirect}) {
            my @new = ("--no-location");
            while (my $option = shift @option) {
                if ($option eq "--location") {
                    next;
                }
                if ($option eq "--max-redirs") {
                    shift @option;
                    push @new, "--max-redirs", 0;
                    next;
                }
                push @new, $option;
            }
            @option = @new;
        }
        @option;
    }
}

sub new {
    my $class = shift;
    bless {
        http => _HTTP->new,
        http_no_redirect => _HTTP->new(max_redirect => 0),
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
