## License

This work is dual-licensed under The Unlicense and MIT License.
You can choose between one of them if you use this work.

`SPDX-License-Identifier: Unlicense OR MIT`


## Nextcloud

Use Docker Compose to run a Nextcloud Instance with Redis, MariaDB and a Collabora Server.
Caddy acts as a Reverse Proxy (http -> https).
spdyn.de is used as Dynamic-DNS-SERVICE.

## How to Use

There are 2 files that need to be customized and renamed:
1. .env_dummy -> .env
2. Caddyfile_dummy -> Caddyfile
Since both .env and Caddyfile are supposed to hold individual information they are listed in the .gitignore.

## Initial Nextcloud Setup

After you created the nextcloud admin user you need to insert the credentials to the database.

Under "Storage & databast", choose MySQL/MariaDB and fill the 4 input fields: "Database user", "Database password", "Database name" and "Database host". The user, password and name are defined in the .env file. The host is the name of the database docker container (nc_db in our case).

## Setup Connection to Collabora Server

From within the Nextcloud site: Make sure the "Collabora Online" App is installed (We do not need the CODE server. We have a Collabora Server running within a docker containter).
Go to Settings -> Collabora Online and choose "Use your own server". Insert whatever the domain Name you assigned to COLLABORA_FQDN in the .env file.

## Grant Clients Access to the Nextcloud

https://help.nextcloud.com/t/cannot-grant-access/64566/11 suggests (and experience show :) that granting clients access does work only after one adds the following line:
   ‘overwriteprotocol’ => ‘https’
at the end of the last list in config/config.php within the docker container. Apparently when generating URLs, NC wants to detect if it is accessed via http or https. Behind the caddy reverse proxy http is used. NC does not know about the ssl encryption outside the reverse proxy. Therefore it generates incorrect URLs.
