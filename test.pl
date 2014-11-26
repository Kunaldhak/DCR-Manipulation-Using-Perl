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
#######################################
my $output_CSV="F:\\tsadm\\Kunal\\espresso_data\\cmo_automation_headline_copy1.csv";                    ##Output
my @languages=('en_US','en','es','es_CA','fr','fr_FR','it_IT','pt_BR','zh_CN_cor');      ## Global Variables...
my $dcr_path = "Y:\\default\\main\\espresso\\WORKAREA\\emd\\templatedata\\web_page\\cmo_automation\\data\\en_US";              #base directory
my @files_dcr;
my ($headline_copy_en_US,$headline_copy_en,$headline_copy_es,$headline_copy_es_CA,$headline_copy_fr,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor);
    
#######################################
sub loadFiles(); 
sub mySub(); 
my @files = ();
loadFiles(); #call

open (FILETAR,'>>:encoding(utf8)', $output_CSV) or die "Could not open File : $!\n";

foreach my $targetFile (@files)
{
	print "\n".$targetFile;
	chomp($targetFile);
	my ($headline_copy_en_US,$headline_copy_en,$headline_copy_es,$headline_copy_es_CA,$headline_copy_fr,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor)=&get_value_en_US($targetFile);
	#my $display_name1 = decode('HZ', $display_name);
	#binmode STDOUT, ': ISO-8859-1';
	my $file_name=basename($targetFile);
	#print FILETAR $file_name.",".$headline_copy_en_US.",".$headline_copy_en.",".$headline_copy_es.",".$headline_copy_es_CA.",".$headline_copy_fr.",".$headline_copy_fr_FR.",".$headline_copy_it_IT.",".$headline_copy_pt_BR.",".$headline_copy_zh_CN_cor."\n" ;
	print FILETAR $file_name.",".$headline_copy_en_US.",".$headline_copy_es_CA.",".$headline_copy_fr_FR.",".$headline_copy_it_IT."\n" ;

}

sub get_value_en_US{                                                          #base subroutine declaration
	my ($targetFile)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="headline_copy"]/value/text()')->get_nodelist)
	{
		 $headline_copy_en_US = $xmlrepoNode->getValue;
	}
	$headline_copy_en=&get_value_en($targetFile);
	$headline_copy_es=&get_value_es($targetFile);
	$headline_copy_es_CA=&get_value_es_CA($targetFile);
	$headline_copy_fr=&get_value_fr($targetFile);
	$headline_copy_fr_FR=&get_value_fr_FR($targetFile);
	$headline_copy_it_IT=&get_value_it_IT($targetFile);
	$headline_copy_pt_BR=&get_value_pt_BR($targetFile);
	$headline_copy_zh_CN_cor=&get_value_zh_CN_cor($targetFile);
	
	
return($headline_copy_en_US,$headline_copy_en,$headline_copy_es,$headline_copy_es_CA,$headline_copy_fr,$headline_copy_fr_FR,$headline_copy_it_IT,$headline_copy_pt_BR,$headline_copy_zh_CN_cor);
	
}
sub get_value{
	my ($targetFile)=@_;
	my $lang_dir=dirname(dirname($targetFile))."\\".$languages[1];
	my $lang_file=basename($targetFile);
	my $lang_target=$lang_dir."\\".$lang_file;
	#print "\n".$lang_target;
	if(-e $lang_target){
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $lang_target);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="headline_copy"]/value/text()')->get_nodelist)
	{
		$headline_copy_en = $xmlrepoNode->getValue;
	}
	
	return ($headline_copy_en);  }
	#not using return
	else{return ('Null')}
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



