use strict;
use warnings;
use File::Copy;
use File::Find;
use File::Basename;
 
 

my $file_path = 'C:\\Users\\kunald1\\git\\DCR-Manipulation-Using-Perl\\Temp\\tour_code_dcrs'; 

 open(my $fh, '<:encoding(UTF-8)', $file_path)
  or die "Could not open file '$file_path' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  my $full_src="y:".$row;
  my $full_directory=dirname($full_src);
  my $dest=$full_directory;
  $dest=~ s|/default/main/asr/WORKAREA/asr_main/templatedata/product/shore_ex/data|/default/main/Test/WORKAREA/PCP_TourCodeConversion/templatedata/product/shore_ex/data|gi;
  my $cmd="iwcp $full_src $dest";
  print "$cmd \n"
}