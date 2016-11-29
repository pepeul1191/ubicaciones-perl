package MojoApp::Model::Items;
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

sub menu {
    my($self, $nombreModulo) = @_;
    my $sth = $self->{_dbh}->prepare('
            SELECT I.nombre AS item, I.url, S.nombre AS subtitulo FROM items I 
            INNER JOIN subtitulos S ON I.subtitulo_id = S.id
            INNER JOIN modulos M ON S.modulo_id = M.id
            WHERE M.nombre = ?
        ') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombreModulo );
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub listar {
    my($self, $subtitulo_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM items WHERE  subtitulo_id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $subtitulo_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

1;