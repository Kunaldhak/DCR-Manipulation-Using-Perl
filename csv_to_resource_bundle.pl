use strict;
use warnings;
my $language_code = 'en_US';
my $bundle_name = 'resource_bundle_currency';
my $brand="C";
#my $workarea = '/default/main/CELEBRITY/celebritycruises.com/WORKAREA/content/';
#my $outputFile = $workarea."/templatedata/misc/resource_bundle/data";
my $outputFile="C:\\Users\\Enigma\\Desktop";
my $csvFile="Temp\\currency.csv";

$outputFile = $outputFile."\\"."any.xml";

open FILE, ">", $outputFile or die $!;

my $outxml=qq(<?xml version="1.0" encoding="UTF-8"?>
<resource_bundle>
	<publishing>
		<language_code>$language_code</language_code>
		<status>published</status>
	</publishing>
	<cms_type>misc/resource_bundle</cms_type>
	<brand_code>$brand</brand_code>
	<bundle_name>$bundle_name</bundle_name>
	<resources>
	);

open CSV, "<", $csvFile or die $!;

while (<CSV>) {
(my $key,my $val) = split(/,/,$_);
chomp($key);
chomp($val);


      print "$key -->$val \n"; 

	  $outxml.=qq(
		<resource>
			<key>$key</key>
			<value>$val</value>
		</resource>
		);
}

$outxml.=qq(
	</resources>
</resource_bundle>);

print FILE $outxml;
close FILE;

		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s TeamSite/Metadata/bundle_name=$bundle_name $outputFile`;
		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s TeamSite/Metadata/publishing/language_code=$language_code $outputFile`;
		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s TeamSite/Metadata/cms_type=misc/resource_bundle $outputFile`;
		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s TeamSite/Metadata/publishing/status=published $outputFile`;
		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s TeamSite/Templating/DCR/Type=misc/resource_bundle $outputFile`;
		`/apps/autonomy/app/iw-home/TeamSite/bin/iwextattr -s iw_form_valid=true $outputFile`;
