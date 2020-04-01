package PingPong::API;
use strict;
use warnings;
use JSON;
use Plack::Request;
use Plack::Response;
use Router::Boom::Method;

my $router = Router::Boom::Method->new();
$router->add("GET", "/", \&pong);

sub app {
    sub {
        my ($env) = @_;
        my $req = Plack::Request->new($env);
        my ($action, $params) = $router->match($req->method, $req->path);
        my $res = $action ? $action->($params, $req) : res_404();
        $res->finalize();
    };
}

sub res_404 {
    res_json(404, {message => "not_found"});
}

sub res_json {
    my ($status, $body) = @_;
    $body->{status} = $status;
    my $json = JSON->new->canonical->utf8->encode($body);
    Plack::Response->new($status, ["Content-Type" => "application/json"], [$json]);
}

sub req_body {
    my ($req) = @_;
    my $fh = $req->body;
    do { local $/; <$fh> };
}

sub req_json {
    my ($req) = @_;
    if ($req->content_type eq "application/json") {
        my $body = req_body($req);
        JSON->new->utf8->decode($body);
    }
}

sub pong {
    my ($params) = @_;
    res_json(200, {message => "OK"});
}

1;