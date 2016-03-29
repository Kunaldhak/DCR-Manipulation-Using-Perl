use warnings;
use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::XLSX;

my $filename = "D://espresso.xlsx";
#Parse excel file
my $parser = Spreadsheet::XLSX->new();
my $workbook = $parser->parse("$filename");

#Get cell value from excel sheet1 row 1 column 2
my $worksheet = $workbook->worksheet('Sheet1');
my $cell = $worksheet->get_cell(0,1);

# Print the cell value when not blank
if ( defined $cell and $cell->value() ne "") {
    my $value = $cell->value();
    print "cell value is $value \n";
}