#!F:/iw-home/teamsite/iw-perl/bin/iwperl

#use TeamSite::Config;
#use lib TeamSite::Config::iwgethome() . "/custom/common/core";
my $iwhome = TeamSite::Config::iwgethome();
my $iwmount = TeamSite::Config::iwgetmount();# Get the iw-mount point from environment
my $ddArea;
#use logger; # Logger module



##############################################################################
#        File Name            : royal_dd.ipl                                  #
#        Description          : IT helper script to manually deploy content  #
#        I/P Parameters       :                                              #
#        O/P Parameters       : N/A                                          #
#        Usage                :                                              #
#        Author               : Aboobacker Cheethayil & Paulo Gouveia        #
#        Date Written         : 11-17-2004                                   #
#        Includes             :                                              #
##############################################################################

################################
#Customization section         #
################################
                               #
my $scriptName = "royal_dd.ipl";#
my $branch     = "royal";       #
my $workarea   = "emd";        #
                               #
################################

my ($category, $dataType, $dbName, $dcrName) = (@ARGV[0..3]); 
my($argCount) = scalar(@ARGV);
my @dcrArray;
my $instNumber = 0;

chomp($category, $dataType, $dbName, $dcrName);


if($argCount < 3)
{
	usage();
	exit;
}

if ($dbName eq "production")
{
	$ddArea = "/default/main/" . $branch . "/STAGING";
} 
else
{
	$ddArea = "/default/main/" . $branch . "/WORKAREA/" . $workarea;
}	
	
print "$ddArea = [$ddArea] \n";
my $dcrPath = "templatedata/" . $category . "/" . $dataType . "/data/";
my $dcrFullPath = $ddArea . "/" . $dcrPath;



# dbName Validation 
if ($dbName ne "production" && $dbName ne "development" && $dbName ne "development_2008" && $dbName ne "staging" && $dbName ne "workarea" && $dbName ne "stage_stage")
{
	print "\n ERROR :  " . $scriptName . "... dbName is not valid! \n" ;
	#parserLog($scriptName . "WARNING :  " . $scriptName . "... dbName is not valid!", $branch);
	
	exit;
}

# Check whether all the DCRs are valid as well as given directory in case of deploying all the dcrs.
if ($dcrName ne "")
{
	@dcrArray = split(/,/, $dcrName);
		
	foreach my $fileNameKey (@dcrArray)
	{
		chomp($fileNameKey);
		chomp($dcrFullPath);
		my $tempDCRFullPath = $dcrFullPath . $fileNameKey;
		print "dcrFullPath = [" . $dcrFullPath . "]\n";
		print "fileNameKey = [" . $fileNameKey . "]\n";
					
		if (! -e ($iwmount . $tempDCRFullPath ))
		{
			print "\n Error :  " . $scriptName . " - [" . $tempDCRFullPath . "] - Its not a valid DCR path \n";
			#parserLog($scriptName . "Error :  " . $scriptName . " - [" . $tempDCRFullPath . "] - Its not a valid DCR path", $branch);
			exit;
		}
	}
}


print "\n running " . $scriptName . " with category=[$category], dataType=[$dataType], dbName=[$dbName], dcrName=[$dcrName] \n";
#parserLog($scriptName . " .... category=[$category], dataType=[$dataType], dcrName=[$dcrName], dbName=[$dbName]  \n", $branch);


my $ddInvokeCommand = "F:/iw-home/opendeploy/OpenDeployNG/bin/iwodcmd start ";
my $ddCfgCommand = " dd/royal/" . $category . "/" . $dataType . "/" . $dataType . "_dd";
my $deploymentCommand = " -k iwdd=" . $dataType;
my $ddCommandArea = " -k area=" . $ddArea;
my $ddCommandDCR =  " -k dcr=$dcrPath";
my $ddCommandDataBase = " -k database=" . $dbName;
my $ddInstCommand = " -inst ";  

my $executeCommand = "";
my $ddCommand = "";

my $tempDdCommandDCR = "";


if(@dcrArray)
{
      foreach my $fileNameKey (@dcrArray)
      {
      		$instNumber = $instNumber + 1;
        	chomp($fileNameKey);
       	    $tempDdCommandDCR = "";
	        $tempDdCommandDCR = $ddCommandDCR . $fileNameKey;

			$ddCommand = $ddInvokeCommand . $ddCfgCommand . $deploymentCommand . $ddCommandArea .  $tempDdCommandDCR . $ddCommandDataBase . $ddInstCommand . " " . $instNumber;
			
	        print "\n Data deploy Command is [$ddCommand] \n";
	        #parserLog($scriptName . " DD Command is  [$ddCommand] ",$branch);
	        `$ddCommand`;
	        $executeCommand = $_;
	        if($executeCommand eq "")
			{
					$executeCommand = "success";
			}
	        #parserLog($scriptName . " Command result is  [$executeCommand] ",$branch);
	        #print "\n Command Result is [$executeCommand] \n";
      }
}
else
{
		#F:/iw-home/opendeploy/OpenDeployNG/bin/iwodcmd start dd/celebrity/misc/homepage/homepage_dd -k 
		#iwdd=homepage -k area=/default/main/celebrity/STAGING -k 
		#dcr=templatedata/misc/homepage/data/en/dcr_homepage_homepage_us_google -k database=production -inst -1
		
		
 

				$ddCommand = $ddInvokeCommand . $ddCfgCommand . $deploymentCommand . $ddCommandArea .  $ddCommandDCR . $ddCommandDataBase . $ddInstCommand . " " . $instNumber;

				print "\n DD Command is [$ddCommand] \n";
				#parserLog($scriptName . " DD Command is  [$ddCommand] ",$branch);
				`$ddCommand`;
				$executeCommand = $_;
				
				if($executeCommand eq "")
				{
					$executeCommand = "success";
				}
				#print "\n Command Result is [$executeCommand] \n";
				#parserLog($scriptName . " Command result is  [$executeCommand] ",$branch);
}

exit;

sub usage()
{
		#system("clear");
        print "\n \n Usage :  " . $scriptName . " category dataType dbName dcrName(eg. 'en_UK', 'en_UK,es_SA'or 'en_UK/dcr_ship_OA.xml') \n";
        ##parserLog($scriptName . " .... Usage : " . $scriptName . " category dataType dbName dcrName", $branch);
}
