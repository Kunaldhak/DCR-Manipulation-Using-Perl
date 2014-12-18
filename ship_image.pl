###############################################################################################
# This script can be used to modify field data from a base directory to different language directory for particular field
# Author:Kunal Dhak
###############################################################################################

use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;
use Encode;
use File::Basename;
use Text::CSV;
use XML::DOM;

#######################################
#my $output_CSV="F:\\tsadm\\Kunal\\espresso_data\\cabin_type_per_ship_display_name(AT).csv";                    ##Output
my $dcr_path = "D:\\EN-US\\Test_DCR\\ship\\en_US";              #base directory
my @files_dcr;
#my ($headline_copy_en_US,$headline_copy_es_CA,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor);
    
#######################################


sub loadFiles(); 
sub mySub(); 
my @files = ();
loadFiles(); #call

#open (my $fh,'>', $output_CSV) or die "Could not open File : $!\n";

foreach my $targetFile (@files)
{
	
	chomp($targetFile);

	&get_value($targetFile);
	my $file_name=basename($targetFile);
    #$csv->print ($fh,[$file_name,$headline_copy_en_US,$headline_copy_es_CA,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor]) ;
	
}

sub get_value{
	my $cutaway_image ;
	my ($targetFile)=@_;
		#print "\n".$targetFile;
	my $p = XML::Parser->new( NoLWP => 1);
	if(-e $targetFile){
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
  	foreach my $xmlrepoNode ($xp->find('/record/item[@name="cutaway_image"]/value/text()')->get_nodelist)
	#my @masternode=$xp->find('/record/item[@name="disclaimer_domestic"]/value/item[@name="disclaimer_copy"]/value/text()')->get_nodelist;
	#foreach my $xmlrepoNode (@masternode)
	{ 
		$cutaway_image = $xmlrepoNode->getValue;
		#&set_value($cutaway_image,$targetFile);
			$targetFile =~ s|en_US|es_CA|gi;
				&set_value($cutaway_image,$targetFile);
#				$targetFile =~ s|it_IT|es_CA|gi;
#					&set_value($cutaway_image,$targetFile);
#						$targetFile =~ s|es_CA|fr_FR|gi;
#							&set_value($cutaway_image,$targetFile);
#								$targetFile =~ s|fr_FR|pt_BR|gi;
#									&set_value($cutaway_image,$targetFile);
#										$targetFile =~ s|pt_BR|zh_CN_cor|gi;
#												&set_value($cutaway_image,$targetFile);
			
		}
	
}
return $cutaway_image;	
}
sub set_value{
	my ($cutaway_image,$targetFile)=@_ ;
	my $parser = new XML::DOM::Parser;
	my $doc ;
	eval { $doc = $parser->parsefile($targetFile);}; 
	 if ($@)      {		
	 	my $error_found = $@;	
	 	print "---File error------".$targetFile ."\n";	next;
	 }
		my $root = $doc->getDocumentElement();
	print $root->toString();
	
}


sub loadFiles()
{
	#print "$dcr_path";
  find(\&mySub,"$dcr_path"); 
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i);                 # modify the regex as per your needs or pass it as another arg
}



