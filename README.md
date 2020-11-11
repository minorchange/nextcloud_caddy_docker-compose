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

## Grant Clients Access to the Nextcloud

https://help.nextcloud.com/t/cannot-grant-access/64566/11 suggests (and experience show :) that granting clients access does work only after one adds the following line:
   ‘overwriteprotocol’ => ‘https’
at the end of the last list in config/config.php within the docker container. Apparently when generating URLs, NC wants to detect if it is accessed via http or https. Behind the caddy reverse proxy http is used. NC does not know about the ssl encryption outside the reverse proxy. Therefore it generates incorrect URLs.
