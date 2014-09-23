#!F:\iw-home\teamsite/iw-perl/bin/iwperl
#use TeamSite::Config;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Find;
 
my $dir = "//MRMTSPROD01/default/main/royal/WORKAREA/emd/templatedata/fleet/deck/data/en_US";
my @files = ();

loadFiles(); #call
 
#$dcr_path = "//MRMTSPROD01/default/main/royal/WORKAREA/emd/templatedata/fleet/deck/data/en_US/dcr_deck_BR_02_1430.xml";
foreach $dcr_path (@files)   
{
print "\n".$dcr_path;
chomp($dcr_path);
my $p = XML::Parser->new( NoLWP => 1);
my $xp = XML::XPath->new(parser => $p, filename => $dcr_path);
my($root) = $xp->findnodes('/'); 

my $nodeset = $root->find('/record/item[@name="breadcrumb"]/value'); 

foreach my $node ($nodeset->get_nodelist) { 

      if($node->toString =~ /(.*) Class/i) { 
	  print "\n\n".$node->toString;
	  my $parent = $node->getParentNode; 
        $parent->removeChild($node); 
        
}
}
#nodeset->removeChildNodes();
 
open (FILE, "> $dcr_path") || iwpt_output("could not open $!");
print FILE $root->toString();
close FILE;
}
print "\nEND !";
 
sub loadFiles()
{
  print "$dir";
  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
}


 
	
	
	
