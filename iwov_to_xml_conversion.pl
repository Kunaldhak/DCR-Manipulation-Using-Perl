use strict;
use warnings;

use Test::More tests => 1;

use XML::Twig;

my( $in, $expected)= do { local $/="\n\n"; <DATA> };

my $result= XML::Twig->new( twig_handlers => { item   => sub { $_->set_tag( $_->att( 'name'))->del_att( 'name'); },
                                              value  => sub { $_->erase; },
                                              record => sub { $_->erase; },   
                                             },
                            pretty_print => 'indented',
                          )
                     ->parse( $in)
                     ->sprint;

is( $result, $expected);
