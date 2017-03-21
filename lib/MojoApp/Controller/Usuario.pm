package MojoApp::Controller::Usuario;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Usuarios;
use MojoApp::Controller::Acceso;
use JSON;
use Data::Dumper;
use Try::Tiny;
use strict;
use warnings;

sub listar {
	my $self = shift;
  	my $model = 'MojoApp::Model::Usuarios';
  	my $usuarios= $model->new();
  	my @rpta = $usuarios->listar();
  	my $json_text = to_json \@rpta;

  	$self->render(text => ("$json_text"));
}

sub listar_usuarios {
    my $self = shift;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_usuarios();
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub validar{
	my $self = shift;
	my $usuario = $self->param('usuario');
	my $contrasenia = $self->param('contrasenia');
        $contrasenia =~ tr/ /+/;
	my $model = 'MojoApp::Model::Usuarios';
  	my $usuarios= $model->new();
  	my $rpta = $usuarios->validar($usuario, $contrasenia);
        
        if($rpta == 1){
            my @usuario = $self->obtener_id($usuario, $contrasenia);
            my $acceso = 'MojoApp::Controller::Acceso';
            $acceso->crear(@usuario[0]->{"id"});
        }

  	$self->render(text => ("$rpta"));
}

sub obtener_id{
    my($self, $usuario, $contrasenia) = @_;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();

    return $usuarios->obtener_id($usuario, $contrasenia);
}

sub listar_accesos {
    my $self = shift;
    my $usuario_id = $self->param('usuario_id');
    my $acceso = 'MojoApp::Controller::Acceso';
    my @rpta = $acceso->listar_accesos($usuario_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub listar_accesos {
    my $self = shift;
    my $usuario_id = $self->param('usuario_id');
    my $acceso = 'MojoApp::Controller::Acceso';
    my @rpta = $acceso->listar_accesos($usuario_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub listar_permisos {
    my $self = shift;
    my $usuario_id = $self->param('usuario_id');
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_permisos($usuario_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub listar_roles {
    my $self = shift;
    my $usuario_id = $self->param('usuario_id');
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();
    my @rpta = $usuarios->listar_roles($usuario_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub asociar_roles{
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $usuario_id = $data->{"extra"}->{'usuario_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $rol_id = $nuevo->{'id'};
              $self->asociar_rol($usuario_id, $rol_id);
            }
        }

        for my $rol_id(@eliminados){
            $self->desasociar_rol($usuario_id, $rol_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los roles al usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los roles al usuario";
        my @temp = ("Se ha producido un error en asociar/deasociar los roles al usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub asociar_rol {
    my($self, $usuario_id, $rol_id) = @_;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();

    return $usuarios->asociar_rol($usuario_id, $rol_id);
}

sub desasociar_rol {
    my($self, $usuario_id, $rol_id) = @_;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();

    return $usuarios->desasociar_rol($usuario_id, $rol_id);
}

sub asociar_permisos{
    my $self = shift;
    my $data = decode_json($self->param('data'));
    my @nuevos = @{$data->{"nuevos"}};
    my @editados = @{$data->{"editados"}};
    my @eliminados = @{$data->{"eliminados"}};
    my $usuario_id = $data->{"extra"}->{'usuario_id'};
    my @array_nuevos;
    my %rpta = ();

    try {
        for my $nuevo(@nuevos){
           if ($nuevo) {
              my $permiso_id = $nuevo->{'id'};
              $self->asociar_permiso($usuario_id, $permiso_id);
            }
        }

        for my $permiso_id(@eliminados){
            $self->desasociar_permiso($usuario_id, $permiso_id);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado la asociación/deasociación de los permisos al usuario");
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en asociar/deasociar los permisos al usuario";
        my @temp = ("Se ha producido un error en asociar/deasociar los permisos al usuario", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub asociar_permiso {
    my($self, $usuario_id, $permiso_id) = @_;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();

    return $usuarios->asociar_permiso($usuario_id, $permiso_id);
}

sub desasociar_permiso {
    my($self, $usuario_id, $permiso_id) = @_;
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();

    return $usuarios->desasociar_permiso($usuario_id, $permiso_id);
}

sub validar_correo_repetido{
    my $self = shift;
    my $correo = $self->param('correo');
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();
    my $rpta = $usuarios->validar_correo_repetido($correo);
        
    $self->render(text => ("$rpta"));
}

sub validar_usuario_repetido{
    my $self = shift;
    my $usuario = $self->param('usuario');
    my $model = 'MojoApp::Model::Usuarios';
    my $usuarios= $model->new();
    my $rpta = $usuarios->validar_usuario_repetido($usuario);
        
    $self->render(text => ("$rpta"));
}

1;