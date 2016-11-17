package MojoApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';
use MojoApp::Config::Database;
use JSON;

sub welcome {
  my $self = shift;

  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub usuarios {
  	my $self = shift;
  	my $db = 'MojoApp::Config::Database';
  	my $odb= $db->new();
  	my $dbh = $odb->getConnection();
  	my $sth = $dbh->prepare(
        'SELECT * FROM usuarios LIMIT 0,10')
        or die "prepare statement failed: $dbh->errstr()";
    $sth->execute() or die "execution failed: $dbh->errstr()";

    my @rpta;

    while (my $ref = $sth->fetchrow_hashref()) {
        #print "Found a row: id = $ref->{'id'}, fn = $ref->{'first_name'}\n";
        #my $str = Dumper({a => 1, b => 2, c => 3});
        push @rpta, $ref;
    }

    $sth->finish;

    my $json_text = to_json \@rpta;

  	$self->render(text => ("$json_text"));
}

1;
