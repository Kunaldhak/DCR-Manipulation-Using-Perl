###############################################################################################
# This script can be used to extract data from different language directory for particular field
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
use Text::CSV::Encoded;
#######################################
my $output_CSV="F:\\tsadm\\Kunal\\espresso_data\\cmo_automation_headline_copy1.csv";                    ##Output
my $dcr_path = "Y:\\default\\main\\espresso\\WORKAREA\\emd\\templatedata\\web_page\\cmo_automation\\data\\en_US";              #base directory
my @files_dcr;
my ($headline_copy_en_US,$headline_copy_en,$headline_copy_es,$headline_copy_es_CA,$headline_copy_fr,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor);
    
#######################################
my $csv = Text::CSV::Encoded->new ( {
										binary => 1,  
										#encoding_in  => "utf-8",     # the encoding comes into   Perl
							        	#encoding_out => "utf-8",   # the encoding comes out of Perl
							        	eol => $/    
									} )  # should set binary attribute.
             or die "Cannot use CSV: ".Text::CSV->error_diag ();

sub loadFiles(); 
sub mySub(); 
my @files = ();
loadFiles(); #call

open (my $fh,'>', $output_CSV) or die "Could not open File : $!\n";

foreach my $targetFile (@files)
{
	
	chomp($targetFile);
	$headline_copy_en_US=&get_value($targetFile);
	$targetFile =~ s|en_US|it_IT|gi;
	$headline_copy_it_IT=&get_value($targetFile);
	$targetFile =~ s|it_IT|es_CA|gi;
	$headline_copy_es_CA=&get_value($targetFile);
	$targetFile =~ s|es_CA|fr_FR|gi;
	$headline_copy_fr_FR=&get_value($targetFile);
	$targetFile =~ s|fr_FR|pt_BR|gi;
	$headline_copy_pt_BR=&get_value($targetFile);
	$targetFile =~ s|pt_BR|zh_CN_cor|gi;
	print "\n".$targetFile;
	$headline_copy_zh_CN_cor=&get_value($targetFile);
	my $file_name=basename($targetFile);
    $csv->print ($fh,[$file_name,$headline_copy_en_US,$headline_copy_zh_CN_cor]) ;
	
}

sub get_value{
	my $headline_copy ;
	my ($targetFile)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	if(-e $targetFile){
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
  	foreach my $xmlrepoNode ($xp->find('/record/item[@name="headline_copy"]/value/text()')->get_nodelist)
	{ $headline_copy = $xmlrepoNode->getValue;}
	
}
return $headline_copy;	
}

sub loadFiles()
{
	print "$dcr_path";
  find(\&mySub,"$dcr_path"); 
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i);                 # modify the regex as per your needs or pass it as another arg
}



