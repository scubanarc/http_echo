# http_echo
A simple http echo server written in perl that prints http connection requests to the console and sends a reply to the connected client.

# Use
Edit the script to listen on whatever port you want. The default is 8080.

Modify the sub get_http_reply to optionally parse the request and create a response. Otherwise, leave it the default, which replies with 'ok' to all requests.

Run the script and it will print which IP address and port it is listening on. Then use an http client to GET or POST to the listening echo server. The http connection string will be printed to the console exactly as it was received. Then http_echo will reply with a basic http response and the string 'ok'.

You can modify the script to parse the http request and construct a reply based whatever you want.

# Use Case
Useful when designing software that submits POST and GET requests to API endpoints.

Also handy to see exactly what curl is sending before sending it to an API.

# Required Modules
```perl
use IO::Socket::INET;
use Net::Address::IP::Local;
use Time::Moment;
use Term::ANSIColor qw(:constants);
```


