use XML::Parser;
 
#my $xmlfile = shift @ARGV;  # the file to parse
my $xmlfile = "D:\\EN-US\\dcr_beverage_0701_minute_maid_juice_6_bottl_r_2014_01_06.xml" ;    
 
# initialize parser object and parse the string
my $parser = XML::Parser->new( ErrorContext => 2 );
eval { $parser->parsefile( $xmlfile ); };
 
# report any error that stopped parsing, or announce success
if( $@ ) {
    $@ =~ s/at \/.*?$//s;               # remove module line number
    print STDERR "\nERROR in '$xmlfile':\n$@\n";
} else {
    print STDERR "'$xmlfile' is well-formed\n";
}