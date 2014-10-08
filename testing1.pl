use strict;
use warnings;
use Data::Dumper;

my %properties;
my $path="C:\\Users\\kunald1\\Desktop\\Prop\\custom_en.properties";
open( DATA, "<", $path ) or die $!;
while (my $propline = <DATA>) {
   next if $propline =~ /^#/;
   chomp $propline;
   my ($key, $value) = split(/=/, $propline, 2);
   _insert(\%properties, $key, $value);
}

sub _insert {
    my ($root, $key, $value) = @_;
    my ($first, $rest) = split /\./, $key, 2;
    if (defined $rest) {
        $root->{$first} = {} unless ref($root->{$first}) eq 'HASH';
        _insert($root->{$first}, $rest, $value);
    } else {
        $root->{$first} = $value;
    }
}

print Dumper(\%properties);