use File::Find;
#use TeamsiteUtil;
use File::Basename;
use strict;
use warnings;
use File::Copy;
use File::Find;
#use TeamSite::Config;
use XML::XPath;
use XML::XPath::XMLParser;
use XML::DOM;
sub loadFiles(); 
sub mySub(); 

my @files = ();
my $dir = shift || die "Argument missing: directory name\n";
my @single_field_asset={};
my @replicant_field_asset={};

loadFiles(); #call
map { 
	my $fname = $_;
	chomp($fname);
} @files;

sub setValue(){
	my ($dcr_path)=@_;
	local $XML::DOM::IgnoreReadOnly = 1;
	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($dcr_path);
	my $root = $doc->getDocumentElement();
	my @parent = $doc->getElementsByTagName ("item",[0]);
	foreach my $node(@parent){
		print;
	}
	
}
sub setReplicant(){
	
}
sub loadFiles()
{
  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
}