
#use TeamSite::Config;
#use XML::XPath;
#use XML::XPath::XMLParser;
use File::Find;
#use XML::Parser;
use XML::DOM;

my $dir = "//MRMTSPROD01/default/main/royal/WORKAREA/emd/templatedata/fleet/deck/data/en_US";
my @files = ();

loadFiles(); #call

 
$dcr_path = "//MRMTSPROD01/default/main/royal/WORKAREA/emd/templatedata/fleet/deck/data/en_US/dcr_deck_AD_02_1582.xml";
foreach $dcr_path (@files)   
#$dcr_path=$ARGV[0];
#print $ARGV[0];
{
print "\n".$dcr_path;
chomp($dcr_path);
my $parser = new XML::DOM::Parser;
my $doc = $parser->parsefile($dcr_path);
my $totalitem = $doc->getElementsByTagName('item');
my $len = $totalitem->getLength();
my $flag="false";

for (my $i=0;$i<$len;$i++) 
	{
	my $node = $totalitem->item($i);
	my $nodeatt = $node->getAttributes();
    my $nodeattval = $nodeatt->item(0)->getValue();
	
	if ($nodeattval eq "breadcrumb_text")
		{
			my $nodechild = $node->getElementsByTagName('value');
			my $nodechildval = $nodechild->item(0)->getFirstChild;						
			if (defined $nodechildval) {
			my $val1 = $nodechildval->getNodeValue();
			if($val1 =~ m| Class|gi)
			{
				#print "\n".$val1."\n";
				my $val2 = $nodechildval->setNodeValue("");
				$flag="true";
			}
			}
		}
	if ($nodeattval eq "breadcrumb_url" and $flag eq "true")
		{
			my $nodechild = $node->getElementsByTagName('value');
			my $nodechildval = $nodechild->item(0)->getFirstChild;						
			if (defined $nodechildval) {
			my $val1 = $nodechildval->getNodeValue();
			if($val1 =~ m|class|gi)
			{
				#print "\n".$val1."\n";
				my $val2 = $nodechildval->setNodeValue("");
				$flag="false";
			}
			}
		}
}
#print "done : targetFile";
#$doc->printToFile($dcr_path);

#open (FILE, "> $dcr_path") || iwpt_output("could not open $!");
#print FILE $doc->toString();
#close FILE;
#
#}
#print "\nEND !";
# 
#sub loadFiles()
#{
#  print "$dir";
#  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
#}
#sub mySub()
#{
#push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
#}


 
	
	
	
