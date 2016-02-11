#!/apps/hp/app/TeamSite/iw-perl/bin/iwperl

use strict;
use warnings;
use File::Copy;
use File::Find;
use TeamSite::Config;
use XML::XPath;
use XML::XPath::XMLParser;
use XML::DOM;

my $group_list="production_group_migration.csv";
my $member_list="group_members.lst";
my $users_list="TS_users_list.csv";
my $permission_file = "all_permissions.xml";

&add_TSUsers();
&add_TSGroups();
&add_Members_to_Group();
&add_TSPermission();

sub add_TSGroups()
{
open CSV, "<", $group_list or die $!;
while (<CSV>) {
(my $group_name,my $group_id,my $gr_name,my $group_description) = split(/,/,$_);
chomp($group_name);
chomp($group_description);
$group_description =~ s/\015?\012?$//;
chomp($group_id);
print $group_description."\n";
my $cmd="sudo /apps/hp/app/TeamSite/bin/iwgroup create ". $group_name." -id ". $group_id;
print "______________Creating Teamsite Groups______________\n";
print "......executing command : $cmd ........\n";
system($cmd);
print "_____________Teamsite Group Creation Completed______________\n";
print "......Setting Group Description Now.....\n";
my $gr_description="sudo /apps/hp/app/TeamSite/bin/iwgroup set-description ".$group_name." \"".$group_description."\"";
print ".....executing command  : ".$gr_description." ........\n";
system($gr_description);
print "****Group Description Has Been Added **** \n";
  }
}

sub add_Members_to_Group()
{
open FH, "<", $member_list or die $!;
while(<FH>){
(my $grp_name,my $members_array)=split(/=/,$_);
$members_array =~ s/\[|\]|\u:]//g;
$members_array =~ s/u://g;
my @members = split(',', $members_array);
foreach my $member (@members) {
chomp($member);
print "***********Adding Members To The Group $grp_name ****************\n";
my $cmd="sudo /apps/hp/app/TeamSite/bin/iwgroup add-member -u ".$member." ".$grp_name;
print "........executing command $cmd ............\n";
system($cmd);
print "........ Member Have Been Added To Respective Group.......";
  }
 }
}

sub add_TSUsers()
{
print".......Adding GDP OS Users.......";
system("/home/cmsadmin/user_migrate/gdp_os_users.sh");
print "....Set Up Of GDP Users Completed.....";
open FH, "<", $users_list or die $!;
while(<FH>){
(my $user_id,my $user_name,my $user_email,my $ui_access,my $is_master,my $ldap_db)=split(/,/,$_);
chomp($user_id);
chomp($user_name);
chomp($user_email);
chomp($ui_access);
chomp($is_master);
chomp($ldap_db);
$is_master=lc($is_master);
my $addition_cmd="sudo /apps/hp/app/TeamSite/bin/iwuseradm add-user ".$user_id." -db ".$ldap_db;
print " addition command : $addition_cmd \n";
system($addition_cmd);
print "......setting up TS master.......";
my $master_cmd="sudo /apps/hp/app/TeamSite/bin/iwuseradm set-master ".$user_id." ".$is_master;
print"set up master command : $master_cmd \n";
system($master_cmd);
print "..setting up ui for TS users....";
my $ui_cms="sudo /apps/hp/app/TeamSite/bin/iwuseradm set-preferred-ui ".$user_id." ".$ui_access;
print "set up ui command : $ui_cms \n";
system($ui_cms);
 }
}
sub add_TSPermission() {

        my $parser = new XML::DOM::Parser;
        my $doc;
        $doc = $parser->parsefile($permission_file);
        my $root = $doc->getDocumentElement();
        my @parent_node = $doc->getElementsByTagName("vpath");
        foreach my $node (@parent_node) {                                              #for each vpath

                my $atrib_node = $node->getAttributeNode('value');
                print "\n v-path : " . $atrib_node->getValue."\n";
                my $vpath=$atrib_node->getValue;

                &getNodeChildren($node,$vpath);
        }
}


sub getNodeChildren()
{
        my ($child_node,$vpath)=@_;
        my @user_entry=$child_node->getElementsByTagName("user-entry");
        my @group_entry=$child_node->getElementsByTagName("group-entry");
        my @owner_entry=$child_node->getElementsByTagName("owner-entry");

                if (@owner_entry>0){
                        foreach my $entry(@owner_entry){
                                my @user_set= $entry->getElementsByTagName("user");
                                my @role_set= $entry->getElementsByTagName("role");
                                my $user=$user_set[0]->getAttributeNode('id')->getValue;
                                my $role=$role_set[0]->getAttributeNode('id')->getValue;
                                print " owner user : ".$user."   owner role : ".$role."\n";
                                my $cmd="sudo /apps/hp/app/TeamSite/bin/iwaccess add-permission-entry ".$vpath." -owner ".$user." -role ".$role;
                                print "executing owner command .... $cmd";
                                system ($cmd);
                                }
                        }
                if (@user_entry>0){
                        foreach my $entry(@user_entry){
                                my @user_set= $entry->getElementsByTagName("user");
                                my @role_set= $entry->getElementsByTagName("role");
                                my $user=$user_set[0]->getAttributeNode('id')->getValue;
                                my $role=$role_set[0]->getAttributeNode('id')->getValue;
                                print "user : ".$user."   role : ".$role."\n";
                                my $cmd="sudo /apps/hp/app/TeamSite/bin/iwaccess add-permission-entry ".$vpath." -user ".$user." -role ".$role;
                                print "executing user command .... $cmd";
                                system ($cmd);
                                }
                        }
                if (@group_entry>0){
                        foreach my $entry(@group_entry){
                                my @user_set= $entry->getElementsByTagName("group");
                                my @role_set= $entry->getElementsByTagName("role");
                                my $user=$user_set[0]->getAttributeNode('id')->getValue;
                                my $role=$role_set[0]->getAttributeNode('id')->getValue;
                                print " group user : ".$user."   group role : ".$role."\n";
                                my $cmd="sudo /apps/hp/app/TeamSite/bin/iwaccess add-permission-entry ".$vpath." -group ".$user." -role ".$role;
                                print "executing group command .... $cmd";
                                system ($cmd);
                                }
                        }
        }
