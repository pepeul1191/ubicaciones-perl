package MojoApp::Controller::Permiso;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Permisos;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::Permisos';
    my $permisos= $model->new();
    my @rpta = $permisos->listar();
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub guardar {
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $id_subtitulo = $data->{"extra"}->{'id_subtitulo'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $llave = $nuevo->{'llave'};
              my $id_generado = $self->crear($nombre, $llave);
              my %temp = ();
              $temp{ 'temporal' } = $temp_id;
              $temp{ 'nuevo_id' } = $id_generado;
              push @array_nuevos, {%temp};
            }
        }

        for my $editado(@editados){
            if ($editado) {
              my $id = $editado->{'id'};
              my $nombre = $editado->{'nombre'};
              my $llave = $editado->{'llave'};
              $self->editar($id, $nombre, $llave);
            }
        }

        for my $eliminado(@eliminados){
            $self->eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los permisos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de permisos";
        my @temp = ("Se ha producido un error en guardar la tabla de permisos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $nombre, $llave) = @_;
    my $model = 'MojoApp::Model::Permisos';
    my $subtitulos= $model->new();

    return $subtitulos->crear($nombre, $llave);
}

sub editar {
    my($self, $id, $nombre, $llave) = @_;
    my $model = 'MojoApp::Model::Permisos';
    my $subtitulos= $model->new();
    $subtitulos->editar($id, $nombre, $llave);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Permisos';
    my $subtitulos= $model->new();
    $subtitulos->eliminar($id);
}

1;