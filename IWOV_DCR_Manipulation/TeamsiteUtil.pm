#!F:\iw-home\teamsite/iw-perl/bin/iwperl

#########################################################################################################
#     Name:             General Teamsite and LSCS Utility
#	  Description:		

#     Created By:       Kunal Dhak
#     Date:             2015
#     
#	  Modification History
#	  Date			   Author							Description					
##########################################################################################################

package TeamsiteUtil;

use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use XML::Twig;
use File::Find;
use Data::Dumper;
require LWP::UserAgent;
use TeamSite::Config;
use lib TeamSite::Config::iwgethome() . "/custom/common/core";

my $hostserver    = TeamSite::Config::hostname();


#========================================================================
# Function Name	: getDCR_LSCS
# Description	: This subroutine returns array of dcrs from LSCS 
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: getDCR_LSCS
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub getDcrList_LSCS
{   
	my $log_format=&timeformat();
	my ($LSCS_ENDPOINT,$LSCS_Project,$cms_type,$language)=@_;
	my @file = split( /\//, $cms_type);
	my $log_file=$file[0]."-".$file[1];
	print "file name :  $log_file \n";
	my $filename=$log_file."_list.log";
	open(my $fh, ">$filename") or die "Could not open file '$filename' $!";
	my $LSCS_URL = $LSCS_ENDPOINT."?max=2147483647&start=0&project=//".$LSCS_Project."&q=((TeamSite/Metadata/cms_type:=".$cms_type.")AND(TeamSite/Metadata/publishing/language_code:=".$language."))";
	my $ua = LWP::UserAgent->new;
	my $response = $ua->get("$LSCS_URL");  #Getting Response
	if ($response->is_success) {

		print $fh $response->content;  # Print LSCS Response
		}
		else {
			die $response->status_line;
		}

		close $fh;
		my $dcr="";

 my $twig = XML::Twig->new(
    twig_roots => {
         '/results/assets/document' => sub { $dcr=$dcr.":".$_->att('path') },
     },  
 )->parsefile($filename);
#print $dcr ."\n";
$dcr =~ s/^.//;
 
 my @array = split(/:/, $dcr);
 return @array;
}
#========================================================================
# Function Name	: xmlDcr_LSCS
# Description	: This subroutine returns response file of single dcrs from LSCS 
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: xmlDcr_LSCS
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub xmlDcr_LSCS
{

my ($LSCS_ENDPOINT,$LSCS_Project,$cms_type,$dcr_path)=@_;
my $xml_url = $LSCS_ENDPOINT."/path/".$dcr_path."?project=//".$LSCS_Project;
	my $ua1 = LWP::UserAgent->new;
	my $response1 = $ua1->get("$xml_url");
	my @file = split( /\//, $cms_type);
	my $log_file=$file[0]."-".$file[1];
	my $filename1=$log_file."_DCR_XML.xml";
	open(my $fh1, ">$filename1") or die "Could not open file '$filename1' $!";

		if ($response1->is_success) {
			print $fh1 $response1->content;  # Print Response
		}
		else {
			die $response1->status_line;
		}

		close $fh1;
		return $filename1;
}
#========================================================================
# Function Name	: check_error
# Description	: 
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: check_error
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub check_error()
{
	my $dcr_path=shift;
	
	my $parser = new XML::DOM::Parser;
	if ( eval {$parser->parsefile ($dcr_path) } ) {
		#print "\n No Parsing Error";
		#print "\n ------------------------------------------------------------\n";
		return;
	}
	else {
		print "\n\n $dcr_path having parser error ";
		#return 1;
	if(! open(ChDCR, $dcr_path)){
	#print "Unable to open $dcr_path";
	}
	my $main_xml;
	{
	local $/ = undef;
	$main_xml = <ChDCR>;
	close ChDCR;
	}
	$main_xml =~ s|utf-8|ISO-8859-1|gi;
	$main_xml =~ s| & | &amp; |gi;

	open(OUT, ">$dcr_path") || print "Could not open the file  '$dcr_path' ($!)";
	print OUT $main_xml;
	close (OUT);
	}
}
#========================================================================
# Function Name	: getValue_XML
# Description	: This subroutine returns node value from xml type dcr
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: getValue_XML
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub getValue_XML
{
my ($dcr_xml,$node)=@_;
my $parser = XML::XPath->new(filename => $dcr_xml);

	my $nodeset = $parser->find($node); 
	#print "\n node size \n".$nodeset->size;
	if($nodeset->size==1){
	my $node_value;
	foreach my $node ($nodeset->get_nodelist) 
		{
		 $node_value= $node->string_value;
	
		}
			 return $node_value;
		}
	else{
		my @multi_value;
		foreach my $node ($nodeset->get_nodelist) 
		{
		push (@multi_value, $node->string_value);
		 }
	return @multi_value;
		}
}

#========================================================================
# Function Name	: getValue_IWOV
# Description	: This subroutine returns node value from xml type dcr
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: getValue_IWOV
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub getValue_IWOV
{
	my ($dcr,$item_name,$rep_item_name)=@_;
	my $p = XML::Parser->new( NoLWP => 1);
	my $xp = XML::XPath->new(parser => $p, filename => $dcr);

	#print "\nNode size : ".$nodeset->size."\n";
	if (@_==2){         #if number of argument 2 for single field
		my $node_value;
		my $node="/record/item[\@name=\"".$item_name."\"]/value";
		my $nodeset=$xp->find($node);
		foreach my $xmlrepoNode  ($nodeset->get_nodelist)
	{
		 $node_value = $xmlrepoNode->string_value;
		 #print "here-- ".$node_value;
	}
	return $node_value;
	}
	else{                #if number of argument 3 , for replicants
	my @multi_value;
	my $node="/record/item[\@name=\"".$item_name."\"]/value/item[\@name=\"".$rep_item_name."\"]/value";
	my $nodeset=$xp->find($node);
	foreach my $node ($nodeset->get_nodelist) 
		{
	push (@multi_value, $node->string_value);
		 
		}
	return @multi_value;
	}

}


#========================================================================
# Function Name	: updateDCR_IWOV
# Description	: 
# I/P Parameter : None
# O/P Parameter : 
# Usage        	: updateDCR_IWOV
# Author       	: Kunal Dhak
# Date Written  : 2015
# General Info 	: 
#
# Modification History
#
# Date	Author		Description
# ----	------		-----------
#========================================================================
sub updateDCR_IWOV                      #For Updating Single Field
{
my ($dcr_path,$field_value,$attrib_value) = @_;
chomp($dcr_path);
my $difference_flag="No";
my $parser = new XML::DOM::Parser;
my $doc = $parser->parsefile($dcr_path);
my $root = $doc->getDocumentElement();
my $totalitem = $doc->getElementsByTagName('item');
my $len = $totalitem->getLength();
for (my $i=0;$i<$len;$i++) 
	{
	my $node = $totalitem->item($i);
	my $nodeatt = $node->getAttributes();
	my $nodeattval = $nodeatt->item(0)->getValue();
	
	if ($nodeattval eq $attrib_value)
		{
		my $nodechild = $node->getElementsByTagName('value');
		my $nodechildval = $nodechild->item(0)->getFirstChild;						
		if (defined $nodechildval) {
			my $old_value = $nodechildval->getNodeValue();		
					if ($field_value eq $old_value)
					{$difference_flag = "No";}
					else
					{$difference_flag = "Yes";}
			}
			$root->removeChild($node);
			last;
		}
	}
######Creating Element######
	
my $item = $doc->createElement('item');
$item->setAttributeNode($doc->createAttribute("name"));
$item->setAttribute("name", $attrib_value);
my $node_name = $doc->createElement('value');
my $node_value = $doc->createTextNode($field_value);
$node_name->appendChild($node_value);
$item->appendChild($node_name);
$root->appendChild($item);
if ($difference_flag eq "Yes")
	{
	open (FILE, "> $dcr_path") || print  "could not open $dcr_path .\n";
	print FILE $doc->toString();
	close FILE;

	$doc->dispose;
	#check_error($dcr_path);
	return "Done";                                        #Return Done If Modified
	}
	
	return "Skipped";                                     #Return Skipped If Not Modified 
}


sub timeformat
{
	my ($tsec,$tmin,$thour,$tmday,$tmon,$tyear,$twday,$tyday) = localtime( time() );
    my $returnTimeValue = (1900 + $tyear) . "_" . (1 + $tmon) . "_" . $tmday . "_" . $thour . "_" . $tmin . "_" . $tsec;
	return($returnTimeValue);
}