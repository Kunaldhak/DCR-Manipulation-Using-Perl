use File::Find;

sub loadFiles(); 
sub mySub(); 

my @files = ();
my $templateName = $ARGV[0];
my $dbName = $ARGV[1];
my $configPath = "espresso"; 

my $dir= "Y:/default/main/espresso/WORKAREA/emd/templatedata/".$templateName."/data";

my $workarea =$dir;
$workarea =~ s|Y:(.*)/templatedata(.*)|$1|gi;
my $dataType = $dir;
$dataType =~ s|(.*)templatedata/(.*)/data(.*)|$2|gi;
my $branch = $dir;
$branch =~ s|(.*)WORKAREA/(.*)/templatedata(.*)|$2|gi;
my $branchValue = $dir;
$branchValue =~ s|(.*)main/(.*)/WORKAREA(.*)|$2|gi;

loadFiles(); #call
map { 
my $fname = $_;
$fname =~ s|(.*)$branch/(.*)|$2|ig;
print "\n$fname"; 
#my $cmd = "F:/iw-home/TeamSite/custom/common/scripts/ddrun.ipl /default/main/Test/WORKAREA/cmo_chinese_royal $fname fleet/ship Test/cmo_chinese_royal test_chinese";
#my $cmd = "F:/iw-home/TeamSite/custom/common/scripts/ddrun.ipl $workarea $fname $dataType $branchValue/$branch test_chinese";
my $cmd = "F:/iw-home/TeamSite/custom/common/scripts/ddrun.ipl $workarea $fname $dataType $configPath $dbName";
print "\n".$cmd;
system($cmd);
} @files;

sub loadFiles()
{
  print "$dir";
  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
}