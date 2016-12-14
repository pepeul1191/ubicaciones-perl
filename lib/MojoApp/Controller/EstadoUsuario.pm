package MojoApp::Controller::EstadoUsuario;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::EstadoUsuarios;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::EstadoUsuarios';
    my $items= $model->new();
    my @rpta = $items->listar();
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}
1;