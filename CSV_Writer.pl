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
#######################################
my $output_CSV="D:\\chinese.csv";     
my @languages=('en_US','it_IT','zh_CN_cor');      ## Global Variables...
my $dcr_path = "D:\\Test_DCR\\zh_CN_cor";         #base directory
my @files_dcr;
my ($display_name);   
my @values=();    
#######################################
my $csv = Text::CSV->new ( { binary => 1, eol => "\n" } )  # should set binary attribute.
             or die "Cannot use CSV: ".Text::CSV->error_diag ();
sub loadFiles(); 
sub mySub(); 
my @files = ();
loadFiles(); #call

open (my $fh,'>:encoding(utf8)', $output_CSV) or die "Could not open File : $!\n";


foreach my $targetFile (@files)
{
	print "\n".$targetFile;
	chomp($targetFile);
	$display_name=&get_value($targetFile);
	#my $display_name1 = decode('HZ', $display_name);
	#binmode STDOUT, ': ISO-8859-1';
	my $file_name=basename($targetFile);
    print FILETAR $file_name.",".$display_name."\n";
	#$csv->print ($fh,$display_name) ;
	
}

sub get_value{
	my ($targetFile)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $targetFile);
	foreach my $xmlrepoNode  ($xp->find('/record/item[@name="display_name"]/value/text()')->get_nodelist)
	{$display_name = $xmlrepoNode->getValue;}
	
	return $display_name;
}
sub loadFiles()
{
	print "$dcr_path";
  find(\&mySub,"$dcr_path"); 
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
}






