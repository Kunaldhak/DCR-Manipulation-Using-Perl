use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;
use Encode;

my $output_CSV="D:\\chinese.txt";


# my $locale ="en_US";	
my $dcr = "D:\\zh_CN_cor";
my @files_dcr;

finddepth(\&wanted_dcr, $dcr);

sub wanted_dcr 
{	-f && push(@files_dcr, $File::Find::name);}

open (FILETAR,'>>', $output_CSV) or die "Could not open File : $!\n";

foreach my $targetFile (@files_dcr)

{
	print $targetFile;
	chomp($targetFile);
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	
	my $display_name;
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{$display_name = $xmlrepoNode->getValue;}
	my $display_name1 = decode('HZ', $display_name);
	binmode STDOUT, ': ISO-8859-1';
	print FILETAR $targetFile.",".$display_name."\n"
	
}