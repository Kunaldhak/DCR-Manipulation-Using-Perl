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
my $output_CSV="D:\\new1.csv";                    ##Output
my @languages=('en_US','it_IT','zh_CN_cor');      ## Global Variables...
my $dcr_path = "D:\\Test_DCR\\en_US";             ##base directory
my @files_dcr;
my ($display_name_en,$display_name_it,$display_name_cn);
    
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
	my ($display_name_en,$display_name_it,$display_name_cn)=&get_value_en_US($targetFile);
	#my $display_name1 = decode('HZ', $display_name);
	#binmode STDOUT, ': ISO-8859-1';
	my $file_name=basename($targetFile);
	print FILETAR $file_name.",".$display_name_en.",".$display_name_it.",".$display_name_cn."\n" ;
	
}

sub get_value_en_US{                                                          #base subroutine declaration
	my ($targetFile)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{
		 $display_name_en = $xmlrepoNode->getValue;
	}
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="cabin_type_sel"]/value/text()')->get_nodelist)
	{
		my $cabin_type_sel_en = $xmlrepoNode->getValue;
		
	}
	$display_name_it=&get_value_it_IT($targetFile);
	$display_name_cn=&get_value_zh_CN_cor($targetFile);
	return ($display_name_en,$display_name_it,$display_name_cn);
	
}

sub get_value_it_IT{
	my ($targetFile)=@_;
	my $lang_dir=dirname(dirname($targetFile))."\\".$languages[1];
	my $lang_file=basename($targetFile);
	my $lang_target=$lang_dir."\\".$lang_file;
	#print "\n".$lang_target;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $lang_target);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{
		$display_name_it = $xmlrepoNode->getValue;
	}
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="cabin_type_sel"]/value/text()')->get_nodelist)
	{
	my 	$cabin_type_sel = $xmlrepoNode->getValue;
		
	}
	return ($display_name_it);                                                             #not using return
	
}
sub get_value_zh_CN_cor{
	my ($targetFile)=@_;
	my $lang_dir=dirname(dirname($targetFile))."\\".$languages[2];
	my $lang_file=basename($targetFile);
	my $lang_target=$lang_dir."\\".$lang_file;
	#print "\n".$lang_target;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $lang_target);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{
		$display_name_cn = $xmlrepoNode->getValue;
	}
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="cabin_type_sel"]/value/text()')->get_nodelist)
	{
	my 	$cabin_type_sel = $xmlrepoNode->getValue;
		
	}
	return ($display_name_cn);                                                             #not using return
	
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






