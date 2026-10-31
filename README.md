A very popular stack for webapps in the 2000's. Today could it could be a headache for those who need to run an old app built on this stack. 

This Dockerfile builds this old stack trying to keep everything as it used to be.

  * PHP 4.4.9
  * Apache 2.2
  * MySql 4.1.22
  * SQLite 2.8 (PECL `sqlite` 1.0.3 extension with the bundled libsqlite 2.8.14, plus the `sqlite` 2.8.17 command line tool)

Both databases are available in the same image: use MySQL, SQLite or both, just like an app from that time would.

## Base image

  * based on alpine: `76MB`
  * **arm64** alpine based: `81MB`
  * based on ubuntu 14.04: `266MB`

## Build

    docker build -f Dockerfile.ubuntu -t php4 .

## Run

    docker run -d --name php4 --restart=always -p 80:80 \
      -v `pwd`/data:/usr/local/mysql/var \
      -v `pwd`/sqlite-data:/usr/local/sqlite/var \
      -v `pwd`/app:/usr/local/apache2/htdocs \
      php4

## Or with docker compose (alpine.arm64)

    docker compose up -d

To use another image, change `dockerfile` in [docker-compose.yml](docker-compose.yml).

Then open:

  * http://localhost/ - MySQL test + `phpinfo()`
  * http://localhost/sqlite.php - SQLite test

## Volumes

| Host folder | Container folder | Content |
|---|---|---|
| `data` | `/usr/local/mysql/var` | MySQL data folder |
| `sqlite-data` | `/usr/local/sqlite/var` | SQLite database files |
| `app` | `/usr/local/apache2/htdocs` | PHP application |

### App Folder (apache2/htdocs)

Must be the copy of folder of your php application.

## Using MySQL

The `data` volume must be the copy of the database folder of your old mysql application. All the users, tables, root password, etc. will be the same.

Connect from PHP with the old `mysql_*` functions:

```php
$connection = mysql_connect('localhost:3306', 'root', 'IAmRoot');
mysql_select_db('mysql', $connection);
```

The MySQL server always starts with the container and needs a valid data folder, even if your app only uses SQLite. In that case keep the sample `data` folder mounted.

## Using SQLite

PHP 4 only speaks **SQLite 2** (the `sqlite_*` functions). SQLite 3 files can't be opened: PDO_SQLITE and `sqlite3` only exist from PHP 5.1/5.3 on. Check the file header to know what you have:

    head -c 48 my.db
    # ** This file contains an SQLite 2.1 database **   -> works
    # SQLite format 3                                   -> not supported

Copy your database files to `sqlite-data` and open them from PHP:

```php
$db = sqlite_open('/usr/local/sqlite/var/my.db', 0666, $error) or die($error);
$result = sqlite_query($db, 'SELECT * FROM my_table');
while ($row = sqlite_fetch_array($result, SQLITE_ASSOC)) {
    // ...
}
sqlite_close($db);
```

Notes:

  * Apache runs as `daemon`, which needs write access to the database file **and** its folder (SQLite creates a `-journal` file next to it). The container fixes ownership of `/usr/local/sqlite/var` on startup.
  * Old apps often kept the database inside the web root. That works too, and Apache refuses to serve `*.db`, `*.sqlite` and `*.sqlite2` files directly.
  * Only the procedural API exists in PHP 4. The `SQLiteDatabase` class is PHP 5 only.
  * The library uses the ISO-8859 encoding (the extension default at the time), so `length()`, `upper()` and `LIKE` work on bytes.
  * The extension is patched to run on 64-bit CPUs (x86_64/aarch64): see [patches/pecl-sqlite-1.0.3-lp64.patch](patches/pecl-sqlite-1.0.3-lp64.patch).

Command line tool (same file format):

    docker compose exec php4 sqlite /usr/local/sqlite/var/sample.db

The sample database was created from [sqlite-data/sample.sql](sqlite-data/sample.sql). To recreate it:

    rm sqlite-data/sample.db
    docker compose exec -T php4 sqlite /usr/local/sqlite/var/sample.db < sqlite-data/sample.sql

## Sample App 

This git repository carry a sample app/data for testing/validate purpose:

  * [app/index.php](app/index.php) + `data`: MySQL
  * [app/sqlite.php](app/sqlite.php) + `sqlite-data/sample.db`: SQLite

## Docker Hub

Images published before SQLite support was added don't include it. Build locally to get it.

* ubuntu based: docker pull rodvlopes/php4:ubuntu
* alpine based: docker pull rodvlopes/php4:alpine
* arm64 alpine based: docker pull rodvlopes/php4:arm64

## Thoughts about Alpine vs Ubuntu

The only diffrence that I can see is that the build proccess of the alpine version is a little bit hacky.

## Motivation

Run my first ever production webapp written in 2003 on a RockPi4 (Raspbarry 4 alternative) and let it running in production for a few for years :-)
