use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;

my $targetFile="d:\\dcr_product_wl54_wild_wellington_seal_c_c_2014-11-17.xml";

my $p = XML::Parser->new( NoLWP => 1 );
my $xp = XML::XPath->new( parser => $p, filename => $targetFile );
 my($root) = $xp->findnodes('/'); 
foreach my $node ($root->find('/record/item[@name="hero_banner"]/value/item[@name="image"]/value')->get_nodelist) { 
 if($node->toString eq  '<value />') { 
        my $prev_parent = $node->getParentNode;
        my $parent=$prev_parent-> getParentNode;
        my $top_parent=$parent->getParentNode;
        $top_parent->removeChild($parent); 
       
      } 
      
  } 

  print $root->toString; 
  
   