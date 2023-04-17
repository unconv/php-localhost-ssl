# How to use HTTPS on localhost

This repository was created as a reference for my YouTube video on how to use an HTTPS connection to localhost with the PHP built-in web server. You can find the video here: https://www.youtube.com/watch?v=sDAX1uQzM8Y

## Instructions

You can find the commands needed to do this in `instructions.sh`.

Basically, you need to create a locally trusted SSL certificate with the `mkcert` tool (https://github.com/FiloSottile/mkcert):

`mkcert -key-file ~/localhost-key.pem -cert-file ~/localhost-cert.pem localhost`

Then you need to bundle the key an certificate into one file:

`cat ~/localhost-key.pem ~/localhost-cert.pem > ~/localhost-bundle.pem`

And give them correct permissions:

`chmod 600 ~/localhost-bundle.pem ~/localhost-key.pem ~/localhost-cert.pem`

Then you need to start a regular PHP built-in server:

`php -S localhost:8080`

And while the server is running, you need to make a tunnel from port 443 to port 8080 with `stunnel`:

`sudo stunnel3 -f -d 443 -r 8080 -p ~/localhost-bundle.pem`

Then you can access https://localhost from your browser, and it will be a trusted connection.

## The `serveit` script

You can also use the `serveit` script I have created, to make a certificate for any arbitrary domain, add it to your `/etc/hosts` file and start both the PHP built in server and `stunnel`. The script will remove the `/etc/hosts` entry and the certificate after the script is stopped with `Ctrl+C`

`serveit <domain> <server port> <stunnel port>`

For example:

`serveit example.com 8080 443`

You can then access https://example.com in your browser and it will point to the PHP built-in server in the folder where you ran the `serveit` script.

If you use your local machine IP address instead of a domain, you can enable HTTPS access for any device on your local network (smartphone or other):

`serveit 192.168.1.10 8080 443`

## How to use it with WordPress

The problem with this approach is that the `$_SERVER['HTTPS']` setting will not be set to `on` when the PHP built in web server is accessed through `stunnel`. This will cause problems with WordPress, for example.

There's also the problem with WordPress that if you have originally created your localhost WordPress site from http://localhost, it will try to redirect you there even if you are accessing it from https://localhost.

You can fix both of these issues by adding the code in the `wp-config.php` file in this repository to your WordPress installation's `wp-config.php` file.

You can also set the `$url` variable to `"https://".$_SERVER['HTTP_HOST]` if you want to allow access to your WordPress website with any domain.

## Installing (mkcert) Root Certificate on other devices

To get other devices to accept your local SSL certificate, you need to install the Root CA certificate created by `mkcert` on your development sever on those devices:

1. link rootCA.pem to be accessible via your brand new (non SSL) web server :   (notice voluntary extension change)
```console
$ ln -s .local/share/mkcert/rootCA.pem rootCA.crt
```
2. download it on your client device from http://192.168.1.10:8080/rootCA.crt (or any domain/IP/port combination you used)
3. install that rootCA in your system/browser (see instructions for [Chrome on Android](https://android.stackexchange.com/a/240913), or [Firefox on Android](https://blog.jeroenhd.nl/article/firefox-for-android-using-a-custom-certificate-authority))
4 access your (now secured) HTTPS website : https://192.168.1.10/
