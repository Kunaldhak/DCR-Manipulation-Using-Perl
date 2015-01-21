	use File::Find;
	
	sub loadFiles(); 
	sub mySub(); 
	
	my @files = ();
	print "Please Enter Preview Directory :-  ";
	my $dir=<STDIN>;
	# my $dir="y\\".$inp_dir;
	# $my $dir = shift || die "Argument missing: directory name\n";
	
	loadFiles(); #call
	map { 
	my $fname = $_;
	print $fname;
	my @presentationPath = split ("\/data\/",$fname);
	print @presentationPath;
	my $tpl = $presentationPath[0]."/presentation/todo.tpl";
	my $cmd = "F:/iw-home/TeamSite/bin/iwgen.exe -t $tpl -r $fname $presentationPath[0]/../../../zz_tst_SCRIPT_PREVIEW.html";
	print "$cmd\n"; 
	system($cmd);
	} @files;
	
	print "\nEND!";
	
	
	sub loadFiles()
	{
	  print "$dir";
	  find(\&mySub,"$dir"); #custom subroutine find, parse $dir
	
	}
	sub mySub()
	{
		  print "here";
	push @files, $File::Find::name if(/\.xml$/i); # modify the regex as per your needs or pass it as another arg
	}