package MojoApp::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Items;
use JSON;
use Data::Dumper;

sub menu {
  	my $self = shift;
  	my $nombreModulo = $self->param('nombreModulo');
    my $model = 'MojoApp::Model::Items';
    my $items= $model->new();
    my @rpta = $items->menu($nombreModulo);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}