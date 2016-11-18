package MojoApp::Model::Modulos;
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
    my $sth = $self->{_dbh}->prepare('SELECT url, nombre FROM modulos') 
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        push @rpta, $ref;
    }

    $sth->finish;

    return @rpta;
}

1;