package MojoApp::Controller::Usuario;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Usuarios;
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

  	$self->render(text => ("$rpta"));
}
