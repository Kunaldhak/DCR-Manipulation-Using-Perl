use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
#use XML::Twig;
use File::Find;
use HTML::Entities ;
use Data::Dumper;
use XML::DOM;
use Data::Dumper qw(Dumper);
require LWP::UserAgent;
#use TeamSite::Config;
#use lib TeamSite::Config::iwgethome() . "/custom/common/core";
#my $hostserver    = TeamSite::Config::hostname();

my $dcr="C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\Temp\\dcr_product_bba5_barbados_beach_break_c_2016-02-01.xml";

&add_section($dcr);

sub add_section(){
	
}