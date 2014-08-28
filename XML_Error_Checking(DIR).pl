use warnings;
use XML::LibXML qw( );

my $dir = 'D:\\EN-US';
opendir my $dh, $dir or die "can not open $dir: $!";
foreach my $file ( readdir $dh ) {
	next if ( $file =~ /^\.$/ );
	next if ( $file =~ /^\.\.$/ );
	my $path   = $dir . "\\" . $file;
	my $parser = XML::LibXML->new();
	if ( eval { $parser->parse_file($path) } ) {
		print "ok\n";
	}
	else {

		#	open LOG, ">>log.txt";
		#	print LOG "error:\n$@";
		#	close LOG;

		print "error:\n$@";
	}
}
