package MojoApp::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Items;
use JSON;
use Data::Dumper;
use strict;
use warnings;

sub menu {
  	my $self = shift;
  	my $nombreModulo = $self->param('nombreModulo');
    my $model = 'MojoApp::Model::Items';
    my $items= $model->new();
    my @items = $items->menu($nombreModulo);

    my @subtitulos_temp;
    my %items_temp;

    for my $item (@items) {
		if($item->{"subtitulo"} ~~ @subtitulos_temp){ 
			my %temp_item = ( item => $item->{"item"}, url => $item->{"url"});
			#print("\n");print Dumper(\%temp_item);print("\n");
			my @temp = $items_temp{$item->{"subtitulo"}};
			@temp = @temp[0];
			push @temp[0], {%temp_item};
			$items_temp{$item->{"subtitulo"}} = @temp[0];
		}else{
			push @subtitulos_temp, $item->{"subtitulo"};
			my %temp_item = ( item => $item->{"item"}, url => $item->{"url"});
			push(my @temp, { %temp_item } );
			$items_temp{$item->{"subtitulo"}} = [@temp];
		}
	}

	my @rpta;
	for my $subtitulo(@subtitulos_temp){
		my %temp;
		$temp{"subtitulo"} = $subtitulo;
		$temp{"items"} = $items_temp{$subtitulo};
		#print("\n");print Dumper(%temp);print("\n");
		push @rpta, {%temp};
	}

    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub listar {
  	my $self = shift;
  	my $subtitulo_id = $self->param('subtitulo_id');
    my $model = 'MojoApp::Model::Items';
    my $items= $model->new();
    my @rpta = $items->listar($subtitulo_id);
    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

1;