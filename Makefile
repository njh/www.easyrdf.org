COMPOSER_FLAGS=--no-ansi --verbose --no-interaction

all: build

build: composer-install \
       apidocs \
       public/css/bootstrap.css \
       public/packages.json \
       data/examples.ttl

apidocs: composer-install
	./vendor/bin/sami.php update vendor/easyrdf/easyrdf/config/sami.php -n
	cp -Rf vendor/easyrdf/easyrdf/docs/api public/docs/

composer-install: composer.phar
	php composer.phar $(COMPOSER_FLAGS) install

update: clean composer.phar
	php composer.phar $(COMPOSER_FLAGS) update

composer.phar:
	curl -s -z composer.phar -o composer.phar http://getcomposer.org/composer.phar


public/css/bootstrap.css:
	php scripts/compile-less.php

public/packages.json:
	php scripts/build-packages-data.php

data/examples.ttl:
	php scripts/build-example-data.php


clean:
	rm -f composer.phar
	rm -Rf vendor/
	rm -Rf public/docs/api
	rm -f public/css/bootstrap.css
	rm -f public/packages.json
	rm -f data/examples.ttl
	rm -f logs/*
	rm -Rf tmp/*

.PHONY: all build update clean
