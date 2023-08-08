# Setup script for a very basic Dockerised server using PHP-FPM and Caddy.

Note this is designed to use SQLite to keep the setup as simple as possible.

## 1. Set up the server.

SSH into the server as `root`.

`curl -fsSL https://raw.githubusercontent.com/ikmolbo/Simple-PHP-Server/master/install.sh | sudo bash`

Run install.sh to install Docker, set up a user, download this repository from GitHub and extract the contents.

Keep the username and password safe.

## 2. Test all is working.

Go to `111.111.111.111` (replace with the server's public IP address) and check we see PHP Info. If not, check the IP address in the Caddyfile matches the one provided by the VPS.

If it looks good, point the A records of your domain (e.g. here `example.com`) to this IP address.

## 3. Copy PHP code

SSH or SFTP into the server and copy the website code to `/www/example.com/staging`. `ìndex.php` should be in the `/www/example.com/staging/public` subfolder.

Probably easiest to ZIP up a Laravel site, and unzip in place.

## 4. Add the new site to Caddyfile.

For a Laravel site, all we need to do is to add a new line to the Caddyfile in `./Caddy`: `import laravel-app example.com`. 

## 5. Reload Caddy

We then need to reload the Caddy server for the new configuration to take effect. Opening `staging.example.com` should now show the website uploaded earlier.

## 6. Copy code to production

If all looks good, copy the code to `/www/example.com/production` to access it at `www.example.com`

## 7. Add more sites as required.

New sites can now be added by repeating steps 3-6 above.