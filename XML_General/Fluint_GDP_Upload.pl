use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Copy;
use File::Find;
use Data::Dumper;
use Encode;
use File::Basename;
use XML::DOM;

my $fluint_file_path="C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\Temp\\fluint_metadata_en-gb.xml";
my $GDP_Translated_Folder="C:\\Users\\kunald1\\Desktop\\GDP_one\\en_UK";
my $base_dir="/iwmnt/default/main/ROYAL/royalcaribbean.com/WORKAREA/content";
my $en_UK="/iwmnt/default/main/ROYAL/royalcaribbean.com.au/WORKAREA/content";
my $es_CA="/iwmnt/default/main/ROYAL/royalcaribbean.es/WORKAREA/content";
my $es_CA1="/iwmnt/default/main/ROYAL/royalcaribbean-espanol.com/WORKAREA/content";
my $pt_BR="/iwmnt/default/main/ROYAL/royalcaribbean.com.br/WORKAREA/content";
my $language=$ARGV[0];

&parse_fluint($fluint_file_path);

sub parse_fluint{
		my $fluint_file=shift;
		#print "FILE : $fluint_file \n";
		my $parser = new XML::DOM::Parser;
        my $doc;
        $doc = $parser->parsefile($fluint_file);
        my $root = $doc->getDocumentElement();
        my @parent_node = $doc->getElementsByTagName("file");
        foreach my $node(@parent_node){
        	my $path=$node->getAttributeNode('path')->getValue;
            my $filename=$node->getAttributeNode('filename')->getValue;
			my $full_path=$path."/".$filename;
			my $local_file_path=$GDP_Translated_Folder."\\".$filename;
			#print "full path : $local_file_path \n";
			if(-e $local_file_path){
				&copy_dcr($local_file_path,$full_path,$language);
			}
			else{
				print "we could not find file : $local_file_path \n";
			}
			#system("ls -l");
        
        	}
		}
		
sub copy_dcr{
	my ($local_file_path,$full_path,$lang)=@_;
	if($lang eq "en_UK"){
		my $full_domain_path=$en_UK."/".$full_path;
		$full_domain_path =~ s|en_US|en_UK|gi;
		my $full_domain_directory=dirname($full_domain_path);
		if( -e $full_domain_path){
			&copy_local($local_file_path,$full_domain_directory);
			#system("/apps/hp/app/TeamSite/bin/iwcp $local_file_path $full_domain_directory");
		}
		else{
			my $full_base_path=$base_dir."/".$full_path;
			&copy_TS($full_base_path,$full_domain_directory);
			&copy_local($local_file_path,$full_domain_directory);
		}
		#print "$full_domain_path \n"
	}
	
	elsif($lang eq "es_CA"){
		my $full_domain_path=$es_CA."/".$full_path;
		my $full_domain_path1=$es_CA1."/".$full_path;
		$full_domain_path =~ s|en_US|es_CA|gi;
		$full_domain_path1 =~ s|en_US|es_CA|gi;
		my $full_domain_directory=dirname($full_domain_path);
		my $full_domain_directory1=dirname($full_domain_path1);
		if( -e $full_domain_path && -e $full_domain_path1){
			&copy_local($local_file_path,$full_domain_directory);
			&copy_local($local_file_path,$full_domain_directory1);
			#system("/apps/hp/app/TeamSite/bin/iwcp $local_file_path $full_domain_directory");
		}
		else{
			my $full_base_path=$base_dir."/".$full_path;
			&copy_TS($full_base_path,$full_domain_directory);
			&copy_TS($full_base_path,$full_domain_directory1);
			&copy_local($local_file_path,$full_domain_directory);
			&copy_local($local_file_path,$full_domain_directory1);
		}	
	}

	elsif($lang eq "pt_BR"){
		my $full_domain_path=$pt_BR."/".$full_path;
		$full_domain_path =~ s|en_US|pt_BR|gi;
		my $full_domain_directory=dirname($full_domain_path);
		if( -e $full_domain_path){
			&copy_local($local_file_path,$full_domain_directory);
			#system("/apps/hp/app/TeamSite/bin/iwcp $local_file_path $full_domain_directory");
		}
		else{
			my $full_base_path=$base_dir."/".$full_path;
			&copy_TS($full_base_path,$full_domain_directory);
			&copy_local($local_file_path,$full_domain_directory);
		}
		#print "$full_domain_path \n"
	}
}
sub copy_local{
	my ($src ,$dest)=@_;
	my $cmd="/bin/cp $src $dest";
	print "$cmd \n";
	
}
sub copy_TS{
	my ($src ,$dest)=@_;
	my $cmd="/apps/hp/app/TeamSite/bin/iwcp $src $dest";
	print "$cmd \n";
}	
	
	