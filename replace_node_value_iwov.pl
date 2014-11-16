#!F:\iw-home\teamsite/iw-perl/bin/iwperl
#########################################################################################################
#     Name:          Replace banner_image field value with new  ones present in csv
#     Description:   This script will replace the banner_image field of shore_ex dcrs with values mentioned in csv 
#     Created By:    Gavlin Kaur
#     Date:          Aug 8th 2014
#     
#	  Modification History
#	  Date			   Author							Description
##########################################################################################################
#
#use TeamSite::Config;
#use XML::XPath;
#use XML::DOM;
#use XML::XPath::XMLParser;
use File::Find;
use Data::Dumper;

my $GLOBAL_DCR_PATH = "";

my %image_extract_fn = image_extract_fn();

image_extract_fn();

my $banner_image;

 foreach my $dcr_path (keys %image_extract_fn) 
  {
	my @new_banner_image = @{$image_extract_fn{$dcr_path}};
	#print $dcr_path."\n";
	$GLOBAL_DCR_PATH = $dcr_path;
	if (-e $dcr_path)
	{
		#print "$dcr_path"."----"."@new_banner_image\n";
		chomp($dcr_path);
		my $parser = new XML::DOM::Parser;
		my $doc ;
		eval { $doc = $parser->parsefile($dcr_path);};  if ($@)      {		my $error_found = $@;	print "---File error------".$GLOBAL_DCR_PATH ."\n";	next;}
		my $root = $doc->getDocumentElement();
			foreach my $detail ( $root->getChildNodes() ) {
				my $attList	= $detail->getAttributes;
					if( $attList ){ 
						$attLength = $attList->getLength;
						if($attLength)
						{	
							for( my $j=0; $j<$attLength; $j++ )
							{
								my $attNode = $attList->item($j);
								$attrValue=$attNode->getValue;
								if("banner_image" eq $attrValue){
								$root->removeChild($detail);
								last;
								}
							}
						}
					}
			   }
			   
			my $newbanner_image = $doc->createElement("item");		
			$newbanner_image->setAttributeNode($doc->createAttribute("name"));
			$newbanner_image->setAttribute("name", "banner_image");
			
			my $newbanner_image_value = $doc->createElement("value");
			$newbanner_image_value->addText(@new_banner_image);
			
			$newbanner_image->appendChild($newbanner_image_value);
			$root->appendChild($newbanner_image);

		$doc->printToFile($dcr_path);
	}
	else
	{
		print "---File doesnt exist------".$dcr_path."\n";
	}
}



sub image_extract_fn 
{
my %hash = ();
open (CSV, "F:/tsadm/ywang/2014/shore_ex_image/List_of_banner_shorex.csv")or die "Could not open csv : $!\n";;
 while (my $line = <CSV>) 
 {
 chomp($line);
 my %hash_values = split (/,/, $line);
 foreach my $k (keys %hash_values) 
  {
    my $new_key =$hash_values{$k};
	my $new_value = $k;
	#converting values to keys and vice-versa
	push( @{$hash{$new_key}}, $new_value);
  }
 }
close CSV;
 #print @{$hash{'Y:/default/main/asr/WORKAREA/asr_main/templatedata/product/shore_ex/data/en_US/alesund/dcr_product_ae19_alesund_city_walking_t_c_2014-07-14.xml'}};
 #print Dumper \%hash;
	return %hash;
}

 
	
	
	