#!/usr/bin/perl -w
# Validating XML Using DTD File

use XML::LibXML;

$parser = XML::LibXML->new;
$parser->validation(1);
$parser->parse_file("DCR_Node_Replace.xml");