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
