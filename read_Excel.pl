 use strict;
    use Spreadsheet::ParseExcel;

    my $FileName = '';
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($FileName);

    die $parser->error(), ".\n" if ( !defined $workbook );

    # Following block is used to Iterate through all worksheets
    # in the workbook and print the worksheet content 

    for my $worksheet ( $workbook->worksheets() ) {

        # Find out the worksheet ranges
        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();

        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {

                # Return the cell object at $row and $col
                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;

                print "Row, Col    = ($row, $col)\n";
                print "Value       = ", $cell->value(),       "\n";

            }
        }
    }