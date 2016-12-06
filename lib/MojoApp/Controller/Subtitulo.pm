package MojoApp::Controller::Subtitulo;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Subtitulos;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $modulo_id = $self->param('modulo_id');
    my $model = 'MojoApp::Model::Subtitulos';
    my $subtitulos= $model->new();
    my @rpta = $subtitulos->listar($modulo_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub guardar {
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $id_modulo = $data->{"extra"}->{'id_modulo'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $temp_id = $nuevo->{'id'};
              my $nombre = $nuevo->{'nombre'};
              my $id_generado = $self->crear($id_modulo, $nombre);
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
              $self->editar($id, $id_modulo, $nombre);
            }
        }

        for my $eliminado(@eliminados){
            $self->eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los subtitulos", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de subtitulos";
        my @temp = ("Se ha producido un error en guardar la tabla de subtitulos", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $id_modulo, $nombre) = @_;
    my $model = 'MojoApp::Model::Subtitulos';
    my $subtitulos= $model->new();

    return $subtitulos->crear($id_modulo, $nombre);
}

sub editar {
    my($self, $id, $id_modulo, $nombre) = @_;
    my $model = 'MojoApp::Model::Subtitulos';
    my $subtitulos= $model->new();
    $subtitulos->editar($id, $id_modulo, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Subtitulos';
    my $subtitulos= $model->new();
    $subtitulos->eliminar($id);
}

1;