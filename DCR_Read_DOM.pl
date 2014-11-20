use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;
use Encode;

# my $locale ="en_US";	
my $dcr = "Y:\\default\\main\\espresso\\WORKAREA\\emd\\templatedata\\fleet\\cabin_type_per_ship\\data\\es_CA";
my @files_dcr;

finddepth(\&wanted_dcr, $dcr);

sub wanted_dcr 
{	-f && push(@files_dcr, $File::Find::name);}

open (FILETAR, ">F:\\tsadm\\Kunal\\data_cabin_type_per_ship_es_CA.csv") or die "Could not open File : $!\n";

foreach my $targetFile (@files_dcr)

{
	print $targetFile;
	chomp($targetFile);
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	
	my $display_name;
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{$display_name = $xmlrepoNode->getValue;}
	my $display_name1 = decode_utf8( $display_name);

	print FILETAR $targetFile.",".$display_name1."\n"
	
}