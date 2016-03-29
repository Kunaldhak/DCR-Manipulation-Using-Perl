use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
#use XML::Twig;
use File::Find;
#use TeamsiteUtil;
use HTML::Entities ;
use Data::Dumper;
use XML::DOM;
use Data::Dumper qw(Dumper);
require LWP::UserAgent;
#use TeamSite::Config;
#use lib TeamSite::Config::iwgethome() . "/custom/common/core";
#my $hostserver    = TeamSite::Config::hostname();


sub loadFiles(); 
sub mySub(); 

my @files = ();
my $dir = shift || die "Argument missing: directory name\n";

loadFiles(); #call


map { 
my $dcr = $_;
print "dcr name  ; $dcr \n";
&updateDCR_IWOV($dcr);
} @files;

sub updateDCR_IWOV                      #For Updating Single Field
{
	my ($targetFile) = @_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	my @node_list=$xp->find('/record/item[@name="what_to_bring"]/value')->get_nodelist;
	my $results = $xp->findnodes_as_string('/record/item[@name="what_to_bring"]');
	my $results1 = $xp->findnodes_as_string('/record/item[@name="product_long_description"]');
	#print $results1."\n";
	#my $results = $xp->find('/record/item[@name="what_to_bring"]');
	my $size=@node_list;
	my @rep_list=TeamsiteUtil::getValue_IWOV($targetFile,"what_to_bring","description");
	my $value="Insect repellant";
	my $value1="Insect repellent";
	if ( grep( /^$value$/, @rep_list) ||  grep( /^$value1$/, @rep_list)) {
  	print "Already there ... Skipping";
	}

	elsif (!defined $results || $results eq ""){
		&create_node($targetFile);
		
	}
        else {
        	&update_node($targetFile,$size);
        }
		

	}

sub update_node(){
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
			my $search="What to bring";
			if (index($long_description, "$search") != -1 || index($long_description, "What to Bring") != -1 || index($long_description, "What To Bring") != -1) {
    		print "Long description contains $search\n";
    		$long_description =~ s|</p><p><strong>What to Wear:</strong>| <br />&bull; Insect repellent </p> <p><strong>What to Wear:</strong>|gi;
			$long_description =~ s|<strong><br />What to Wear:| &bull; Insect repellent<br /><strong><br />What to Wear:|gi;
			$long_description =~ s|<br /><br /><strong>What to Wear:| <br />&bull; Insect repellent<br /><strong><br />What to Wear:|gi;
			$long_description =~ s|</p>\n<p><strong>What to Wear:| <br />&bull; Insect repellent </p><p><strong><br />What to Wear:|gi;
			$long_description =~ s|Insect rapellent| Insect repellent |gi;
			$long_description =~ s|Insect Rapellent| Insect repellent |gi;
			$long_description =~ s|Insect Rapellant| Insect repellent |gi;
			$long_description =~ s|Insect rapellant| Insect repellent |gi;
			#print "\n $long_description";
			$nodechildval->setNodeValue($long_description);
			}	
			else {
				print "what to bring not found in long description \n";
				$long_description=$long_description."<p><strong>What to bring:</strong><br /> &bull; Insect repellent</p>";
				$nodechildval->setNodeValue($long_description);
			}

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
         			print "\n Found  what_to_bring..\n";
					my $value_elem = $doc->createElement('value');
					my $elem_title = $doc->createElement('item');
					$elem_title->setAttribute('name','title');
					my $value_elem_title = $doc->createElement('value');
					if($size ==0){
					$value_elem_title->appendChild($doc->createTextNode("What To Bring"));
					}
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
	open (FILE, "> $dcr_path") || iwpt_output("could not open $!");
	print FILE $doc->toString();
	close FILE;
	print "\nEND !!";
}
sub create_node(){
	my ($dcr_path) = @_;
	chomp($dcr_path);
	
	local $XML::DOM::IgnoreReadOnly = 1;
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($dcr_path);
	my $root = $doc->getDocumentElement();

	my @parent = $doc->getElementsByTagName ("item");
	
	foreach my $items(@parent){
	
	my $item = $doc->createElement('item');
	$item->setAttributeNode($doc->createAttribute("name"));
	$item->setAttribute("name", "what_to_bring");
	
	$root->appendChild($item);
		
	open (FILE, "> $dcr_path") || iwpt_output("could not open $!");
	print FILE $doc->toString();
	close FILE;
	&update_node($dcr_path,0);
	last;
	}
}
sub loadFiles()
{
  print "$dir";
  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i);                 # modify the regex as per your needs or pass it as another arg
}