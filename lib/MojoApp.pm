package MojoApp;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');

  $r->get('/item/listar/menu/:nombreModulo')->to('item#menu');

  $r->get('/modulo/listar')->to('modulo#listar');

  $r->get('/usuario/listar')->to('usuario#listar');
  #$r->get('/usuario/validar/:id')->to('usuario#validar');
  $r->post('/usuario/validar')->to('usuario#validar');
}

1;
