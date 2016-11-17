package MojoApp::Controller::Usuario;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Usuarios;
use JSON;

sub listar {
	my $self = shift;
  	my $model = 'MojoApp::Model::Usuarios';
  	my $usuarios= $model->new();
  	my @rpta = $usuarios->listar();
  	my $json_text = to_json \@rpta;

  	$self->render(text => ("$json_text"));
}
