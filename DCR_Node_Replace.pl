use strict;
use warnings;
use XML::LibXML;

#my $filename = $ARGV[0];
my $filename = "DCR_Node_Replace.xml";
my $parser   = XML::LibXML->new();
my $doc      = $parser->parse_file($filename);
my $xc       = XML::LibXML::XPathContext->new( $doc->documentElement() );

for my $sample ( $doc->findnodes('/record/item') ) {
	my $child=$sample->getchildnodes();
	print '$child';
#	my ($object) = $doc->findnodes("/root/item/[name/text()");
#	my $text = XML::LibXML::Text->new('14');
#	$object->replaceNode($text);
}
