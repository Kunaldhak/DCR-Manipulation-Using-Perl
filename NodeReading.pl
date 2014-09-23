use strict;
use warnings;
use XML::LibXML;

my $file1="example.xml";

my $doc = XML::LibXML->load_xml(location => $file1, no_blanks => 1);
my @properties = $doc->findnodes('//INSTANCE[@CLASSNAME = "SharedGtTranslator"]/PROPERTY[@NAME = "Name"]');

for my $property (@properties) {
    print $property->textContent('VALUE'), "\n";
}