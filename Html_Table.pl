use HTML::Table;

  $table1 = new HTML::Table($rows, $cols);
    or
  $table1 = new HTML::Table(-rows=>26,
                            -cols=>2,
                            -align=>'center',
                            -rules=>'rows',
                            -border=>0,
                            -bgcolor=>'blue',
                            -width=>'50%',
                            -spacing=>0,
                            -padding=>0,
                            -style=>'color: blue',
                            -class=>'myclass',
                            -evenrowclass=>'even',
                            -oddrowclass=>'odd',
                            -head=> ['head1', 'head2'],
                            -data=> [ ['1:1', '1:2'], ['2:1', '2:2'] ] );
   or
  $table1 = new HTML::Table( [ ['1:1', '1:2'], ['2:1', '2:2'] ] );

  $table1->setCell($cellrow, $cellcol, 'This is Cell 1');
  $table1->setCellBGColor('blue');
  $table1->setCellColSpan(1, 1, 2);
  $table1->setRowHead(1);
  $table1->setColHead(1);

  $table1->print;

  $table2 = new HTML::Table;
  $table2->addRow(@cell_values);
  $table2->addCol(@cell_values2);

  $table1->setCell(1,1, "$table2->getTable");
  $table1->print;