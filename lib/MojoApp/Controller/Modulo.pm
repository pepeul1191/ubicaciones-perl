package MojoApp::Controller::Modulo;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Modulos;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::Modulos';
    my $modulos= $model->new();
    my @rpta = $modulos->listar();
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub guardar {
    my $self = shift;
    my $model = 'MojoApp::Model::Modulos';
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $url = $nuevo->{'url'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = $self->crear($url, $nombre);
              my %temp = ();
              $temp{ 'temporal' } = $temp_id;
              $temp{ 'nuevo_id' } = $id_generado;
              push @array_nuevos, {%temp};
            }
        }

        for my $editado(@editados){
            if ($editado) {
              my $id = $editado->{'id'};
              my $url = $editado->{'url'};
              my $nombre = $editado->{'nombre'};
              $self->editar($id, $url, $nombre);
            }
        }

        for my $eliminado(@eliminados){
            $self->eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los modulos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de modulos";
        my @temp = ("Se ha producido un error en guardar la tabla de modulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $url, $nombre) = @_;
    my $model = 'MojoApp::Model::Modulos';
    my $modulos= $model->new();

    return $modulos->crear($url, $nombre);
}

sub editar {
    my($self, $id, $url, $nombre) = @_;
    my $model = 'MojoApp::Model::Modulos';
    my $modulos= $model->new();
    $modulos->editar($id, $url, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Modulos';
    my $modulos= $model->new();
    $modulos->eliminar($id);
}

1;