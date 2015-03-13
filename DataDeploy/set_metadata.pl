use File::Find;

sub loadFiles(); 
sub mySub(); 

my @files = ();
my $dir = shift || die "Argument missing: directory name\n";

loadFiles(); #call
map { 
my $fname = $_;
	chomp($fname);
	my @pathArray1 = split(/templatedata/,$fname);
	my @pathArray2 = split(/data/,$pathArray1[1]);
	my @pathArray3 = split(/\//,$pathArray2[0]);
	my $data_type = $pathArray3[1]."/".$pathArray3[2];

my $cmd="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Templating/DCR/Type=$data_type $fname";
#qx($cmd);
print "$cmd\n"; 
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