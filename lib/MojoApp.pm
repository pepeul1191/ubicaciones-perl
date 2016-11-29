package MojoApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Router
    my $r = $self->routes;

    $r->get('/item/listar/menu/:nombreModulo')->to('item#menu');
    $r->get('/item/listar/:subtitulo_id')->to('item#listar');

    $r->get('/modulo/listar')->to('modulo#listar');

    $r->get('/subtitulo/listar/:modulo_id')->to('subtitulo#listar');

    $r->get('/usuario/listar')->to('usuario#listar');
    $r->post('/usuario/validar')->to('usuario#validar');
}

1;
