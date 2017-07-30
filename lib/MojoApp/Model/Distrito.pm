package MojoApp::Model::Distrito;
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
    my($self, $provincia_id) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM distritos WHERE provincia_id = ?;') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $provincia_id);
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub buscar {
    my($self, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('SELECT id, nombre FROM vw_distrito_provincia_departamento WHERE nombre LIKE ? LIMIT 0,10;') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre . "%");
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

sub crear {
    my($self, $provincia_id, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('INSERT INTO distritos (provincia_id, nombre) VALUES (?, ?)') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $provincia_id);
    $sth->bind_param( 2, $nombre);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    
    my $id_generated = $self->{_dbh}->last_insert_id(undef, undef, undef, undef );
    $sth->finish;

    return $id_generated;
}

sub editar {
    my($self, $id, $nombre) = @_;
    my $sth = $self->{_dbh}->prepare('UPDATE distritos SET nombre = ? WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $nombre);
    $sth->bind_param( 2, $id);

    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

sub eliminar {
    my($self, $id) = @_;
    my $sth = $self->{_dbh}->prepare('DELETE FROM distritos WHERE id = ?') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->bind_param( 1, $id);
    $sth->execute() or die "execution failed: $dbh->errstr()";
    $sth->finish;
}

1;