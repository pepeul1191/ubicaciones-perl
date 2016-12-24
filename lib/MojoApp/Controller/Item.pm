package MojoApp::Controller::Item;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Model::Items;
use JSON;
use JSON::XS 'decode_json';
use Data::Dumper;
use Try::Tiny;
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

sub listar_todos {
    my $self = shift;
    my $model = 'MojoApp::Model::Items';
    my $items= $model->new();
    my @items = $items->listar_todos();
    my @modulos_nombre;
    my @modulos_iconos;
    my %modulos_temp;
    #print("1\n");print Dumper(@items);print("2\n");
    for my $item(@items){
        #my %temp = ( icono => $item->{"icono"}, subtitulo => $item->{"subtitulo"}, modulo => $item->{"modulo"}, items => $self->items_subtitulo($item->{"items"}));
        if($item->{"modulo"} ~~ @modulos_nombre){
            my %temp_subtitulo = ( subtitulo => $item->{"subtitulo"}, items => [$self->items_subtitulo($item->{"items"})]);
           #print("\n");print Dumper(\%temp_subtitulo );print("\n");
           my @temp = $modulos_temp{$item->{"modulo"}};
           @temp = @temp[0];
           push @temp[0], {%temp_subtitulo};
           $modulos_temp{$item->{"modulo"}} = @temp[0];
        }else{
            push @modulos_nombre, $item->{"modulo"};
            push @modulos_iconos, $item->{"icono"};
            my %temp_subtitulo = ( subtitulo => $item->{"subtitulo"}, items => [$self->items_subtitulo($item->{"items"})]);
            print("\n");print Dumper(\%temp_subtitulo );print("\n");
            push(my @temp, { %temp_subtitulo } );
            $modulos_temp{$item->{"modulo"}} = [@temp];
        }
    }

    my @rpta;
    my $k = 0;
    for my $modulo(@modulos_nombre){
        my %temp;
        $temp{"modulo"} = $modulo;
        $temp{"icono"} = @modulos_iconos[$k];
        $temp{"subtitulos"} = $modulos_temp{$modulo};
        $k = $k + 1;
        #print("\n");print Dumper(%temp);print("\n");
        push @rpta, {%temp};
    }

    my $json_text = to_json \@rpta;

    $self->render(text => ("$json_text"));
}

sub items_subtitulo{
    my($self, $items) = @_;
    my @subtitulos= split /[||]/, $items;
    my @items;
    
    for my $subtitulo(@subtitulos){
        if($subtitulo eq ''){}else{
            my @temp= split /[::]/, $subtitulo;
            my %item = ( nombre => @temp[0], url => @temp[2]);
            push @items, {%item};
        }
    }
    return @items;
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
              my $url = $nuevo->{'url'};
              my $id_generado = $self->crear($id_subtitulo, $nombre, $url);
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
              my $url = $editado->{'url'};
              $self->editar($id, $id_subtitulo, $nombre, $url);
            }
        }

        for my $eliminado(@eliminados){
            $self->eliminar($eliminado);
        }

        $rpta{'tipo_mensaje'} = "success";
        my @temp = ("Se ha registrado los cambios en los items", [@array_nuevos]);
        $rpta{'mensaje'} = [@temp];
    } catch {
        #warn "got dbi error: $_";
        $rpta{'tipo_mensaje'} = "error";
        $rpta{'mensaje'} = "Se ha producido un error en guardar la tabla de items";
        my @temp = ("Se ha producido un error en guardar la tabla de items", "" . $_);
        $rpta{'mensaje'} = [@temp];
    };
    #print("\n");print Dumper(%rpta);print("\n");
    my $json_text = to_json \%rpta;
    $self->render(text => ("$json_text"));
}

sub crear {
    my($self, $id_subtitulo, $nombre, $url) = @_;
    my $model = 'MojoApp::Model::Items';
    my $subtitulos= $model->new();

    return $subtitulos->crear($id_subtitulo, $nombre, $url);
}

sub editar {
    my($self, $id, $id_subtitulo, $nombre, $url) = @_;
    my $model = 'MojoApp::Model::Items';
    my $subtitulos= $model->new();
    $subtitulos->editar($id, $id_subtitulo, $nombre, $url);
}

sub eliminar {
    my($self, $id) = @_;
    my $model = 'MojoApp::Model::Items';
    my $subtitulos= $model->new();
    $subtitulos->eliminar($id);
}

1;