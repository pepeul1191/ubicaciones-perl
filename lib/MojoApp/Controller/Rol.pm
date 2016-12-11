package MojoApp::Controller::Rol;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Roles;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
    my $self = shift;
    my $model = 'MojoApp::Model::Roles';
    my $roles= $model->new();
    my @rpta = $roles->listar();
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
              my $id_generado = $self->crear($nombre);
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
        my @temp = ("Se ha registrado los cambios en los roles", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de roles";
        my @temp = ("Se ha producido un error en guardar la tabla de roles", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $nombre) = @_;
    my $model = 'MojoApp::Model::Roles';
    my $roles= $model->new();

    return $roles->crear($nombre);
}

sub editar {
    my($self, $id, $nombre) = @_;
    my $model = 'MojoApp::Model::Roles';
    my $roles= $model->new();
    $roles->editar($id, $nombre);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Roles';
    my $roles= $model->new();
    $roles->eliminar($id);
}

1;