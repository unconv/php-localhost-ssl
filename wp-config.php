<?php
// set site url
$url = "https://localhost";

// override wordpress options
define( 'WP_SITEURL', $url );
define( 'WP_HOME', $url );

// override HTTPS
$_SERVER['HTTPS'] = "on";
