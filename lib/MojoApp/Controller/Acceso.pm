package MojoApp::Controller::Acceso;
use MojoApp::Model::Accesos;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub crear {
    my($self, $usuario_id) = @_;
    my $model = 'MojoApp::Model::Accesos';
    my $accesos= $model->new();
    $accesos->crear($usuario_id);
}

sub listar_accesos {
    my($self, $usuario_id) = @_;
    my $model = 'MojoApp::Model::Accesos';
    my $accesos= $model->new();
    
    return $accesos->listar_accesos($usuario_id);
}
1;