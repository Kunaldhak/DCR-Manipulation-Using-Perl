#											    my $parser = XML::LibXML->new( recover => $recover );    --->for automatic recovery
#												Use 1 for $recover if you want the parser to be warn when it fixes a problem.
#												Use 2 for $recover if you want the parser to fix problems silently
#                                               Error Checking For single File

use warnings;
use XML::LibXML qw( );

my $file = "C:\\IWTemp\\MRMTSPROD01\\cache\\default\\main\\royal\\WORKAREA\\emd\\templatedata\\fleet\\deck\\data\\en_US\\dcr_deck_SR_12_1601.xml";
my $parser = XML::LibXML->new();
if ( eval { $parser->parse_file($file) } ) {
	print "ok\n";
}
else {

	#	open LOG, ">>log.txt";
	#	print LOG "error:\n$@";
	#	close LOG;

	print "error:\n$@";
}
