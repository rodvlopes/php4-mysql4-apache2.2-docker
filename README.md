A very popular stack for webapps in the 2000's. Today could it could be a headache for those who need to run an old app built on this stack. 

This Dockerfile builds this old stack trying to keep everything as it used to be.

  * PHP 4.4.9
  * Apache 2.2
  * MySql 4.1.22

## Base image

  * based on alpine: `76MB`
  * **arm64** alpine based: `81MB`
  * based on ubuntu 14.04: `266MB`

## Build

    docker build -f Dockerfile.ubuntu -t php4 .

## Run

    docker run -d --name php4 --restart=always -p 80:80 -v `pwd`/data:/usr/local/mysql/var -v `pwd`/app:/usr/local/apache2/htdocs php4

### Data Volume (mysql/var)

Must be the copy of the database folder of your old mysql application. All the users, tables, root password, etc. will be the same.

### App Folder (apache2/htdocs)

Must be the copy of folder of your php application.

### Sample App 

This git repository carry a sample app/data for testing/validate purpose.

### Docker Hub

* ubuntu based: docker pull rodvlopes/php4:ubuntu
* alpine based: docker pull rodvlopes/php4:alpine
* arm64 alpine based: docker pull rodvlopes/php4:arm64

### Thoughts about Alpine vs Ubuntu

The only diffrence that I can see is that the build proccess of the alpine version is a little bit hacky.

## Motivation

Run my first ever production webapp written in 2003 on a RockPi4 (Raspbarry 4 alternative) and let it running in production for a few for years :-)
