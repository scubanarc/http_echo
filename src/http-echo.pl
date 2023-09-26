#!/usr/bin/perl

use strict;
use warnings;
use 5.30.0;
use utf8::all;

use IO::Socket::INET;
use Net::Address::IP::Local;
use Time::Moment;
use Term::ANSIColor qw(:constants);

my $localPort = 8080;
my $bufferSize = 1024;

# Create a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => '0.0.0.0',
    LocalPort => $localPort,
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);

if(!$socket) {
    print RED, "ERROR: $!\n", RESET;
    exit 1;
}


$SIG{INT} = sub {
    print GREEN, "\nClosing socket...\n\n", RESET;
    $socket->close();
    exit 0;
};

my $address = Net::Address::IP::Local->public;
print GREEN, "\nListening at ", RESET, "$address:$localPort\n\n";

# loop forever
while(1) {
    my $client_socket = $socket->accept();

    # Get remote client's IP address
    my $client_address = $client_socket->peerhost();

    # Read up to $bufferSize characters from the connected client
    my $data = "";
    $client_socket->recv($data, $bufferSize);
    
    # print the http connection string to the console
    print_http_connection($client_address, $data);
    
    # send a reply, or else the client will wait forever
    $client_socket->send(get_http_reply($data));
}

# print the http connection string to the console
sub print_http_connection {
    my $client_address = shift;
    my $data = shift;

    my $time = Time::Moment->now;
    print "----------------------------------------\n";
    print CYAN, $time->strftime("%Y-%m-%d %H:%M:%S"), RESET, "\n";
    
    print YELLOW, "Connection from: $client_address\n", RESET;
    print "$data\n\n\n";
}

# get the reply string that will be sent to the connected client
sub get_http_reply {
    my $data = shift;

    # optionally parse the http submitted data here and return a reply
    # or you can return a copy of the request:
    # my $reply = $data;

    # or you can return a simple "ok" message to every request:
    my $reply = "ok";

    # this basic HTTP reply should make most web browsers and curl happy
    return "HTTP/1.0 200 OK\r\nContent-Type: text/html; charset=utf-8\r\n\r\n$reply\n";
}