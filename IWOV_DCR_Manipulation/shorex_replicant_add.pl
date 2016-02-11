use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
#use XML::Twig;
use File::Find;
use HTML::Entities ;
use Data::Dumper;
use XML::DOM;
use Data::Dumper qw(Dumper);
require LWP::UserAgent;
#use TeamSite::Config;
#use lib TeamSite::Config::iwgethome() . "/custom/common/core";
#my $hostserver    = TeamSite::Config::hostname();

my $dcr="C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\Temp\\dcr_product_bba5_barbados_beach_break_c_2016-02-01.xml";
&updateDCR_IWOV($dcr);

sub updateDCR_IWOV                      #For Updating Single Field
{
	my ($targetFile) = @_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	my @node_list=$xp->find('/record/item[@name="what_to_bring"]/value')->get_nodelist;
	my $size=@node_list;
	print $size;
	&create_node($targetFile,$size);
}
sub create_node(){
	my ($dcr_path,$size) = @_;
	chomp($dcr_path);
	local $XML::DOM::IgnoreReadOnly = 1;
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($dcr_path);
	my $root = $doc->getDocumentElement();
	my @parent = $doc->getElementsByTagName ("item");
	my $what_to_bring ;
	my $totalitem = $doc->getElementsByTagName('item');

	my $len = $totalitem->getLength();
	#print $doc;
		
	for (my $i=0;$i<$len;$i++) 
		{

		my $node = $totalitem->item($i);
		
		my $nodeatt = $node->getAttributes();
		
		my $nodeattval = $nodeatt->item(0)->getValue();
		#print "$nodeattval , ";
		

		if ($nodeattval eq "long_description")
		{
			my $nodechild = $node->getElementsByTagName('value');
			my $nodechildval = $nodechild->item(0)->getFirstChild;						
			if (defined $nodechildval) {
			my $long_description = $nodechildval->getNodeValue();
			chomp($long_description);	
			print "\n $long_description"	;
			$long_description =~ s|<strong><br \/>What to Wear:| &bull; Insect repellent<br /><strong><br \/>What to Wear:|gi;
			$nodechildval->setNodeValue($long_description);
			}
		}
		if ($nodeattval eq "what_to_bring")
			{
			$what_to_bring =$node;
			last;
			}
		}
	
	foreach my $items(@parent){
        
         	my $node = $items->getAttributeNode('name');            #The return value of getAttributes XML::DOM::NamedNodeMap object
			
 
         		if ($node->getValue eq 'what_to_bring'){
         			print "\n Found overview ..\n";
					my $value_elem = $doc->createElement('value');
					my $elem_title = $doc->createElement('item');
					$elem_title->setAttribute('name','title');
					my $value_elem_title = $doc->createElement('value');
					$value_elem_title->appendChild($doc->createTextNode("What To Bring"));
					$elem_title->appendChild($value_elem_title);
					
					my $elem_desc = $doc->createElement('item');
					$elem_desc->setAttribute('name','description');
					my $value_elem_desc = $doc->createElement('value');
					$value_elem_desc->appendChild($doc->createTextNode("Insect repellent"));
					$elem_desc->appendChild($value_elem_desc);
					
					my $elem_rep = $doc->createElement('item');
					$elem_rep->setAttribute('name','rep_count');
					my $value_elem_rep = $doc->createElement('value');
					my $count=$size+1;
					$value_elem_rep->appendChild($doc->createTextNode($count));
					$elem_rep->appendChild($value_elem_rep);
					
					
					$value_elem->appendChild($elem_title);
					$value_elem->appendChild($elem_desc);
					$value_elem->appendChild($elem_rep);
									
					$what_to_bring->appendChild($value_elem);
					
					
					}
			}
	#open (FILE, "> $dcr") || iwpt_output("could not open $!");
	#print FILE $root->toString();
	#close FILE;
	#print "\nEND !!";
}