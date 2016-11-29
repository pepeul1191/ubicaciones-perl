package MojoApp::Controller::Subtitulo;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Subtitulos;
use JSON;
use Data::Dumper;

sub listar {
  	my $self = shift;
  	my $modulo_id = $self->param('modulo_id');
    my $model = 'MojoApp::Model::Subtitulos';
    my $subtitulos= $model->new();
    my @rpta = $subtitulos->listar($modulo_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

1;