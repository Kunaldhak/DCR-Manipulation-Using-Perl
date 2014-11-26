#!F:\iw-home\teamsite/iw-perl/bin/iwperl
use XML::XPath;
use XML::XPath::XMLParser;
use File::Find;
use XML::DOM;
use File::Basename;
use Encode;

#my $dir = "//MRMTSPROD01/default/main/espresso/WORKAREA/emd/templatedata/faq/contextual_help/data/".$ARGV[0];
my @files = ();
my $dir ="Y:\\default\\main\\espresso\\WORKAREA\\emd\\templatedata\\web_page\\cmo_automation\\data\\en_US";

open LOG, ">F:\\tsadm\\Kunal\\espresso_data\\cmo_automation_headline_copy.csv";

#open (LOG,'>:encoding(utf8)', 'F:\\tsadm\\Kunal\\espresso_data\\cmo_automation_headline_copy.csv') or die "Could not open File : $!\n";
loadFiles();    #call
my $str = "DCR name, en_US, es_CA, fr_FR, it_IT, pt_BR, zh_CN_cor,en,es,fr";

foreach my $targetFile (@files) {
	if ( -f $targetFile ) {

#$targetFile = "//MRMTSPROD01/default/main/espresso/WORKAREA/emd/templatedata/faq/contextual_help/data/en_US/dcr_contextual_help_bookings_that_require_attention_1606.xml";
		$fileName = $targetFile;

#$fileName =~ s|//MRMTSPROD01/default/main/espresso/WORKAREA/emd/templatedata/faq/contextual_help/data/en_US/||gi;
		$str .= "\n" . basename($fileName);
		getValues($targetFile);
		print "\n$targetFile";
		$targetFile =~ s|en_US|es_CA|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|es_CA|fr_FR|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|fr_FR|it_IT|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|it_IT|pt_BR|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|pt_BR|zh_CN_cor|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|zh_CN_cor|en|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|en|es|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
		$targetFile =~ s|es|fr|gi;
		if ( -e $targetFile ) {

			#print "\n$targetFile";
			getValues($targetFile);
		}
		else { $str .= ","; }
	}
}

print LOG $str;

close LOG;
print "\nEND !";

sub getValues() {
	$str .= ",";
	my ($targetFile) = shift;
	chomp($targetFile);
	my $p = XML::Parser->new( NoLWP => 1 );
	my $xp = XML::XPath->new( parser => $p, filename => $targetFile );

	my $answer_copy;
	foreach my $xmlrepoNode (
		$xp->find('/record/item[@name="headline_copy"]/value/text()')->get_nodelist )
	{
		$answer_copy = $xmlrepoNode->getValue;
	}
	$answer_copy =~ s/"/""/g;

	#my $display_name1 = decode('HZ', $display_name);
	#binmode STDOUT, ': ISO-8859-1';
	$str .= "\"" . $answer_copy . "\"";

	#$str.=qq($answer_copy);
}

sub loadFiles() {
	print "$dir";
	find( \&mySub, "$dir" );    #custom subroutine find, parse $dir
}

sub mySub() {
	push @files, $File::Find::name
	  ;    # modify the regex as per your needs or pass it as another arg
}
