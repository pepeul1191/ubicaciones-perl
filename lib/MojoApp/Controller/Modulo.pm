package MojoApp::Controller::Modulo;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Modulos;
use JSON;
use Data::Dumper;

sub listar {
  my $self = shift;
    my $model = 'MojoApp::Model::Modulos';
    my $modulos= $model->new();
    my @rpta = $modulos->listar();
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}