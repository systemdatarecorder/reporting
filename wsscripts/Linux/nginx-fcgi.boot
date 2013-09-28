#!/opt/sdr/report/perl/bin/perl -w

use strict;
use warnings FATAL => qw( all );
use POSIX;
use IO::Socket::UNIX;

my $fcgi_pid     = '/opt/sdr/report/fastcgi_temp/nginx-fcgi.pid';
my $fcgi_bin     = '/opt/sdr/report/sbin/nginx-fcgi';
my $socket_path  = $ARGV[0] || '/opt/sdr/report/fastcgi_temp/nginx-fcgi.sock';
my $num_children = $ARGV[1] || 1;

close STDIN;

unlink $socket_path;
my $socket = IO::Socket::UNIX->new(
    Local => $socket_path,
    Listen => 100,
);

die "Cannot create socket at $socket_path: $!\n" unless $socket;

for (1 .. $num_children) {
    my $pid = fork;
    die "Cannot fork: $!" unless defined $pid;
    next if $pid;

    open FCGIPID, "+>", "$fcgi_pid"
        or die "could not open $fcgi_pid: $!";  
    printf FCGIPID "%d\n", POSIX::getpid();
    close FCGIPID;

    exec $fcgi_bin;
    die "Failed to exec $fcgi_bin: $!\n";
}

