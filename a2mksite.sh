#!/usr/bin/php
<?php
error_reporting(0);
$_username = $argv[1];
$_thedomain = $argv[2];
$_option = $argv[3];

switch($_option){
  default:
    break;

  case '--create-dir':
    create_vhost( $_username, $_thedomain);
    if (!mkdir("/home/$_username/public_html", 0777, true)) {
        die('Failed to create PUBLIC_HTML folders...');
    }
    if (!mkdir("/home/$_username/log", 0777, true)) {
        die('Failed to create LOG folders...');
    }
    break;

  case '--no-dir':
    create_vhost( $_username, $_thedomain);
    break;

  case '--create-https':
    create_vhost( $_username, $_thedomain, 'https');
    break;
}

function create_vhost( $_username, $_thedomain, $mode = 'apache')
{
  $path = "/etc/apache2/sites-available/";

  if( !is_dir($path))
  {
    mkdir($path, 0755, true);
  }
  # Create Apache Virtualhost Config File
  $vhost = file_get_contents('./templates/'.$mode.'.conf');
  $vhost = str_replace("THE_DOMAIN", $_thedomain, $vhost);
  $vhost = str_replace("USERNAME", $_username, $vhost);

  $files = fopen($path.$_thedomain.'.conf', "w");
  fwrite($files, $vhost);
  fclose($files);

  echo "Successfully create $_thedomain.conf";
}