use warnings;
use XML::LibXML qw( );
use XML::Simple;

my $dir = 'D:\\EN-US';
opendir my $dh, $dir or die "can not open $dir: $!";
foreach my $file ( readdir $dh ) {
	next if ( $file =~ /^\.$/ );
	next if ( $file =~ /^\.\.$/ );
	my $path = $dir . "\\" . $file;
	chomp($path);
	my $dom = XML::LibXML->load_xml( location => $path );
	for my $id ( $dom->findnodes('//value[string()="en_US"]') ) {
		$id->removeChildNodes;
		$id->appendText('KUNAL');
	}

	print $dom->toString ;
	#print XMLout($dom);

}
 
