package MojoApp::Controller::Usuario;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Usuarios;
use MojoApp::Controller::Acceso;
use JSON;
use Data::Dumper;

sub listar {
	my $self = shift;
  	my $model = 'MojoApp::Model::Usuarios';
  	my $usuarios= $model->new();
  	my @rpta = $usuarios->listar();
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

1;