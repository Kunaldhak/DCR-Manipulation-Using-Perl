use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use XML::Twig;
use File::Find;
use HTML::Entities ;
use Data::Dumper;
use XML::DOM;
use Data::Dumper qw(Dumper);
require LWP::UserAgent;


my $dcr="C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\Temp\\dcr_product_bba5_barbados_beach_break_c_2016-02-01.xml";

my $twig= XML::Twig->new();
$twig->parsefile($dcr);
my ($model) = $twig->findnodes('/record/item[@name]');
$model->set_att(name => 'dfdsa');
$twig->print;