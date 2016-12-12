package MojoApp::Controller::Demo::Test;
use Mojo::Base 'Mojolicious::Controller';
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub index {
    my $self = shift;
    $self->render(text => ("HOLAAA!!!"));
}

1;