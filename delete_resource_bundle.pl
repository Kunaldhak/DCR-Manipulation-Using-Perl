use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;
use Encode;
use File::Basename;


my $csvFile="C:\\Users\\kunald1\\Desktop\\sailings_with_coupon_codes_promotions_bbb-europe.csv";
my $targetFile="C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\resource_bundle_sailings_with_coupon_codes_promotions.xml";
open CSV, "<", $csvFile or die $!;
my $p = XML::Parser->new( NoLWP => 1);
my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
my($root) = $xp->findnodes('/'); 
while (<CSV>) {
(my $date,my $key,my $val) =split(/,/,$_);
chomp($date);
chomp($key);
chomp($val);
(my $dd,my $mm,my $yyyy)= split(/-/,$date);
my $yy= substr($yyyy, -2);
my $orgkey="$key-1$yy$mm$dd";
chomp($orgkey);
#print $orgkey  ."\n";

	foreach my $xmlrepoNode  ($root->find('/resource_bundle/resources/resource/key/text()')->get_nodelist){
		my $key = $xmlrepoNode->getValue;
		chomp($key);
		if ($orgkey eq $key){
			my $prev_parent = $xmlrepoNode->getParentNode;
			my $parent =$prev_parent-> getParentNode;	
			my $top_parent=$parent->getParentNode;
       		$top_parent->removeChild($parent); 
			
			 
		}
		
	}
}
open (FILE, "> $targetFile") || iwpt_output("could not open $!");
print FILE $root->toString();
close FILE ;