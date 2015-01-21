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

my $cmd="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/global_content_type='local'  $fname";
my $cmd1="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/global_content_type/core='y'  $fname";
my $cmd2="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/need_to_translate='yes'   $fname";
my $cmd3="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/need_to_translate/yes='y'  $fname";
my $cmd4="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/target_languages='en-gb, it-it, pt-br, es-es, fr-fr'   $fname";
my $cmd5="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/target_languages/es-es='y'  $fname";
my $cmd6="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/target_languages/fr-fr='y'  $fname";
my $cmd7="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/target_languages/it-it='y'  $fname";
my $cmd8="f:\\iw-home\\TeamSite\\bin\\iwextattr.exe -s TeamSite/Metadata/target_languages/pt-br='y'  $fname";
system($cmd);
system($cmd2);
system($cmd3);
system($cmd4);
system($cmd5);
system($cmd6);
system($cmd7);
system($cmd8);
#print "$cmd\n"; 
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