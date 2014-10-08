 #use Config::Properties;

  # reading...

  open my $fh, '<', 'my_config.props'
    or die "unable to open configuration file";

  my $properties = Config::Properties->new();
  $properties->load($fh);

  $value = $properties->getProperty($key);


  # saving...

  open my $fh, '>', 'my_config.props'
    or die "unable to open configuration file for writing";

  $properties->setProperty($key, $value);

  $properties->format('%s => %s');
  $properties->store($fh, $header );