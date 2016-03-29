use strict;
use warnings;
use Data::Dumper;
use List::Util;
my $csvFile="C:\\Users\\kunald1\\Desktop\\Espresso_rework.csv";
my $propFile="C:\\Users\\kunald1\\Desktop\\EnglishPropertiesFile.txt";
my $outputFile="C:\\Users\\Enigma\\Desktop";
my $remain="C:\\Users\\kunald1\\Desktop\\new 4";


open CSV, "<", $csvFile or die $!;
my %hash;
chomp(my @lines = <CSV>);
&myfind(@lines);
close CSV;
#print "key : ".$key."\n";

#print "$key --> $boolean_return \n";
#my $flag=findstring($key);
#                #print "\n flag $flag";
#                if($flag eq "true")
#                {
#                                print "\nFound";
#                }
#                else
#                {
#                                print "\nNot Found";
#                }


sub findstring
{
                my ($line) = (shift);                
                my $flag="false";
                open( my $pfh, '<', $propFile ) or die "Can't open $propFile: $!";
                while ( my $prop = <$pfh> ) 
                {
                                $prop =~ s/^\s+//;
                                $prop =~ s/\s+$//;
                                my @values = split('=', $prop);
                                my $result = index($values[1], $line);
                                #print "\nvalues ". $values[1];
                                #print "\nline $line";
                                #print "\nresult $result";
                                if($result != -1)
                                {
                                           $flag="true";
                                }
                }
                return $flag;
}


sub checkProp{
	my $orig_key=$_;
	chomp($orig_key);
	no warnings 'uninitialized';
	open TEXT, "<", $propFile or die $!;
	while (<TEXT>) {
	my ($key,$val) = split(/=/,$_);
	chomp($key);
	chomp($val);
	$hash{$key} = $val;
	
}
%hash=reverse %hash;
#print Dumper \%hash;
my @ary = grep{/^$orig_key/} keys %hash;
my @ary1 = grep{/$orig_key$/} keys %hash;
#print "found", if(scalar @ary > 0)
if (exists($hash{$orig_key}) || scalar @ary > 0 || scalar @ary1 > 0) 
{
  
  print "$orig_key = PROP \n" ;
  
} 
else 
{
   print "$orig_key = CONT \n" ;
}
}
sub myfind{
my @lines=@_;
#print $orig_key;
open TEXT, "<", $propFile or die $!;
chomp(my @lines1 = <TEXT>);
foreach my $line(@lines){
my @matches = grep { /\Q$line/ } @lines1;
if(scalar @matches > 0){
	print "$line -->Found \n"
}
else {
	print "$line -->NOT FOUND \n"
}

}
}