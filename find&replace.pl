use strict;

print "hi";
open(FILE, "</dcr/dcr_internet_33w1_unlimited_internet_packag_r_2015_06_17.xml") || die "File not found";
my @lines = <FILE>;
close(FILE);

my @newlines;
foreach(@lines) {
   $_ =~ s/language/ABCD/g;
   push(@newlines,$_);
}

open(FILE, ">/dcr/yourfile.txt") || die "File not found";
print FILE @newlines;
close(FILE);