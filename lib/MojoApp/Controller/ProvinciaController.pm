package MojoApp::Controller::ProvinciaController;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Provincia;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use File::Basename;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::Provincia';
    my $provincia= $model->new();
    my $departamento_id = $self->param('departamento_id');
    my @rpta = $provincia->listar($departamento_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub guardar {
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $departamento_id = $data->{"extra"}->{'departamento_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = $self->crear($departamento_id, $nombre);
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
              $self->editar($id, $nombre);
            }
        }

        for my $eliminado(@eliminados){
            $self->eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en las provincias", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de provincias";
        my @temp = ("Se ha producido un error en guardar la tabla de provincias", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $departamento_id, $nombre) = @_;
    my $model = 'MojoApp::Model::Provincia';
    my $provincia= $model->new();

    return $provincia->crear($departamento_id, $nombre);
}

sub editar {
    my($self, $id, $nombre) = @_;
    my $model = 'MojoApp::Model::Provincia';
    my $provincia= $model->new();
    $provincia->editar($id, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Provincia';
    my $provincia= $model->new();
    $provincia->eliminar($id);
}

1;