use strict;

use XML::Writer;

my $doc = new XML::Writer();

# print the open tag, including the attribute
$doc->startTag("doc", class => "simple");

# print an element containing only text
$doc->dataElement( title => "Simple Doc");
  $doc->startTag( "section");
    $doc->dataElement( title => "Introduction", no => 1, type => "intro");
      $doc->startTag( "para");
        $doc->characters( "a text with");
        $doc->dataElement( bold => "bold");
        $doc->characters( " words.");
      $doc->endTag( "para");
    $doc->endTag(); # close section
  $doc->endTag(); # close doc
$doc->end(); # final checks