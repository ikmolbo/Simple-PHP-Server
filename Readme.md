# Setup script for a very basic Dockerised server using PHP-FPM and Caddy.

Note this is designed to use SQLite to keep the setup as simple as possible.

## 1. Set up the server.

SSH into the server as `root`. Run the following to install Docker, set up a user (`www-user`), download this repository from GitHub and extract the contents:

`curl -fsSL -o setup.sh "https://raw.githubusercontent.com/ikmolbo/Simple-PHP-Server/master/setup.sh" && chmod +x setup.sh && sudo bash ./setup.sh`

Keep the username and password safe.

## 2. Test all is working.

Go to the server's public IP address and check we see PHP Info. If not, check the Docker containers are running:

`sudo -u www-user docker-compose ps`

## 3. Log in as www-user.

If all looks good, now we can use the password set earlier to SFTP or SSH into the `/home/www-data` folder as www-data. 

Edit ./caddy/Caddyfile to add the hostname of a new site, e.g. `example.com`. For a Laravel site, all we need to do is to add a new line to the Caddyfile: `import laravel-app example.com`. 

## 3. Copy PHP code

Copy the website code to `/home/www-user/www/example.com/staging`. `ìndex.php` should be in the `/www/example.com/staging/public` subfolder.

Probably easiest to ZIP up a Laravel site, and unzip in place. May need to set permissions.

## 4. Update DNS records

If it looks good, point the A records of your domain (e.g. `example.com`) to this IP address.

## 5. Reload Caddy

We then need to reload the Caddy server for the new configuration to take effect. Opening `staging.example.com` should now show the website uploaded earlier.

Use `docker exec [container name] [command]` to execute commands in the relevant container.

Here, `docker exec caddy caddy reload` to reload the Caddyfile after our changes.

`docker exec php-fpm composer install` should install any Composer dependencies in the Laravel container.

## 6. Copy code to production

If all looks good, copy the code to `/www/example.com/production` to access it at `www.example.com`

## 7. Add more sites as required.

New sites can now be added by repeating steps 3-6 above.