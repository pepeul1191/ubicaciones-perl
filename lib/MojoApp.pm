package MojoApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    #inicio hook CORS
    $self->hook(before_dispatch => sub {
        my $c = shift;
        $c->res->headers->header('Access-Control-Allow-Origin' => '*');
        $c->res->headers->header('x-powered-by' => 'Mojolicious (Perl)');
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
    # departamento
    $r->get('/departamento/listar')->to('departamento_controller#listar');
    $r->post('/departamento/guardar')->to('departamento_controller#guardar');
    # distrito
    $r->get('/distrito/listar/:provincia_id')->to('distrito_controller#listar');
    $r->get('/distrito/buscar')->to('distrito_controller#buscar');
    $r->post('/distrito/guardar')->to('distrito_controller#guardar');
    # provincia
    $r->get('/provincia/listar/:departamento_id')->to('provincia_controller#listar');
    $r->post('/provincia/guardar')->to('provincia_controller#guardar');
}

1;
