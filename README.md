# PHP DockerStack
> from the initial project by [Kasper Kronborg Isager](http://github.com/kasperisager/php-dockerized)
>
> Dockerized PHP development stack: Nginx, MySQL, PHP-FPM, HHVM, Memcached

[![Build Status](https://travis-ci.org/fstasi/php-dockerstack.svg)](https://travis-ci.org/fstasi/php-dockerstack)

PHP DockerStack provides you a full environment to run your php applications backed by already-configured nginx and MySql.

This stack is already configured to run all the application you put in the www folder, just follow the naming convention and you will be all set.


## What's inside

* [Nginx](http://nginx.org/)
* [MySQL](http://www.mysql.com/)
* [PHP-FPM](http://php-fpm.org/)
* [HHVM](http://www.hhvm.com/)
* [Memcached](http://memcached.org/)

## Requirements

* [Docker](https://docs.docker.com/installation/)

## Running

Install Docker, then, modify the docker-compose.yml file in the root of this repo, setting `adminuser` and `adminpass` variables to be meaningful to you.


Then run:

```sh
$ docker-compose up
```

That's it! You can now access your configured sites via http://localhost:8080/{sitename} or, if you deployed this online and you have the DNS configured already http://{sitename}


## Adding a website

If you want to run a website you own, just place it in the `www` directory that comes with this repo.
The nginx in this stack is already configured to serve all virtualHosts, with a lookup rule based on the domain name.
As an example, all the traffic coming form [www.]example.com will be routed to /var/www/example.com directory.

### Adding a sub-domain (third level domain)

Third level domains are also routed to sub-directories in the domain directory. For example, hello.example.com will be routed to /var/www/example.com/hello

Yes, it's just that easy!


## Initialise your MySQL Database

Any *.sql or *.sql.gz file in the `db` directory will be used to initialise your mysql instance. That's it :)

## SSL

The docker container created already supports the creation of SSL certificates, via the free and awesome [Let's Encrypt](https://letsencrypt.org/) project.

To automatically get a certificate and configure nginx, just run the following command from you host's terminal (replace `example.com` and `your@email.com` with real ones!):
```
docker exec -d phpdockerstack_front_1 /etc/nginx/ssl/sslget example.com your@email.com

```

## License

Copyright &copy; 2016-2017 [Francesco Stasi](http://github.com/fstasi). Licensed under the terms of the [MIT license](LICENSE.md).