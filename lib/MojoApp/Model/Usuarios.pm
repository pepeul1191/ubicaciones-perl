package MojoApp::Model::Usuarios;
use MojoApp::Config::Database;

sub new {
    my $class = shift;
    my $db = 'MojoApp::Config::Database';
  	my $odb= $db->new();
  	my $dbh = $odb->getConnection();
    my $self = {
        _dbh => $dbh
    };

    bless $self, $class;
    return $self;
}

sub listar {
    my($self) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT * FROM usuarios LIMIT 0,10')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub validar {
    my($self, $usuario, $contrasenia) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT COUNT(*) AS cantidad FROM usuarios WHERE usuario = ? AND contrasenia = ?')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $usuario );
    $sth->bind_param( 2, $contrasenia );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my $rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        $rpta = $ref->{'cantidad'};
    }

    $sth->finish;

    return $rpta;
}
1;