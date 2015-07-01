use strict;
use File::Find;
my $dcr_path = $ARGV[0];  
sub loadFiles(); 
sub mySub(); 
my @files = ();
loadFiles(); #call


foreach my $targetFile (@files){
open(FILE, $targetFile) || die "File not found";
my @lines = <FILE>;
close(FILE);
my @newlines;
foreach(@lines) {
   $_ =~ s/100000000002404343/KDJ/g;
   $_ =~ s/100000000002404510/MMM/g;
   $_ =~ s/100000000002404510/MMM/g;
   push(@newlines,$_);
}


open(FILE,">", $targetFile) || die "File not found";
print FILE @newlines;
close(FILE);
}

sub loadFiles()
{
	
  find(\&mySub,"$dcr_path"); 
}
sub mySub()
{
push @files, $File::Find::name if(/\.xml$/i);                 # modify the regex as per your needs or pass it as another arg
}