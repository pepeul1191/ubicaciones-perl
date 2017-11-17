package MojoApp::Controller::DistritoController;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Distrito;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use File::Basename;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();
    my $provincia_id = $self->param('provincia_id');
    my @rpta = $distrito->listar($provincia_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub buscar {
    my $self = shift;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();
    my $nombre = $self->param('nombre');
    my @rpta = $distrito->buscar($nombre);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub nombre {
    my $self = shift;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();
    my $distrito_id = $self->param('distrito_id');
    my $rpta = $distrito->nombre($distrito_id);

    $self->render(text => ($rpta));
}

sub guardar {
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $provincia_id = $data->{"extra"}->{'provincia_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = $self->crear($provincia_id, $nombre);
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
        my @temp = ("Se ha registrado los cambios en las distritos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de distritos";
        my @temp = ("Se ha producido un error en guardar la tabla de distritos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $provincia_id, $nombre) = @_;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();

    return $distrito->crear($provincia_id, $nombre);
}

sub editar {
    my($self, $id, $nombre) = @_;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();
    $distrito->editar($id, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Distrito';
    my $distrito= $model->new();
    $distrito->eliminar($id);
}

1;