package MojoApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    #inicio hook CORS
    $self->hook(before_dispatch => sub {
        my $c = shift;
        $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    });
    #fin hook CORS

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    #inicio CORS
    $self->plugin('SecureCORS');
    $self->plugin('SecureCORS', { max_age => undef });
    $self->routes->to('cors.credentials'=>1);
    #fin CORS

    # Router
    my $r = $self->routes;

    $r->get('/item/listar/menu/:nombreModulo')->to('item#menu');
    $r->get('/item/listar/:subtitulo_id')->to('item#listar');
    $r->post('/item/guardar')->to('item#guardar');

    $r->get('/modulo/listar')->to('modulo#listar');
    $r->post('/modulo/guardar')->to('modulo#guardar');

    $r->get('/permiso/listar')->to('permiso#listar');
    $r->post('/permiso/guardar')->to('permiso#guardar');
    $r->get('/permiso/listar_asociados/:rol_id')->to('permiso#listar_asociados');

    $r->get('/rol/listar')->to('rol#listar');
    $r->post('/rol/guardar')->to('rol#guardar');
    $r->post('/rol/ascociar_permisos')->to('rol#ascociar_permisos');

    $r->get('/subtitulo/listar/:modulo_id')->to('subtitulo#listar');
    $r->post('/subtitulo/guardar')->to('subtitulo#guardar');

    $r->get('/usuario/listar')->to('usuario#listar');
    $r->get('/usuario/listar_accesos/:usuario_id')->to('usuario#listar_accesos');
    $r->post('/usuario/validar')->to('usuario#validar');

    $r->get('/demo')->to('demo-test#index');
}

1;
