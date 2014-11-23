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
my $output_CSV="D:\\chinese.csv";     
my @languages=('en_US','it_IT','zh_CN_cor');      ## Global Variables...
my @content=('display_name'); 
my $dcr_path = "D:\\Test_DCR\\zh_CN_cor"; 
my @files_dcr;       
#######################################

finddepth(\&load_dcr, $dcr_path);

sub load_dcr 
{	
	-f && push(@files_dcr, $File::Find::name);
	
}

open (FILETAR,'>>', $output_CSV) or die "Could not open File : $!\n";

foreach my $targetFile (@files_dcr)
{
	print "\n".$targetFile;
	chomp($targetFile);
	my $display_name=&get_value($targetFile);
	#my $display_name1 = decode('HZ', $display_name);
	#binmode STDOUT, ': ISO-8859-1';
	my $file_name=basename($targetFile);
	print FILETAR $file_name.",".$display_name."\n"
	
}

sub get_value{
	my ($targetFile)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	my $display_name;
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{$display_name = $xmlrepoNode->getValue;}
	return $display_name;
}







