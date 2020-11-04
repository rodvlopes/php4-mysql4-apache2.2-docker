A very popular stack for webapps in the 2000's. Today could it could be a headache for those who need to run an old app built on this stack. 

This Dockerfile builds this old stack trying to keep everything as it used to be.

  * PHP 4.4.9
  * Apache 2.2
  * MySql 4.1.22

## Build

docker build -t php4 .

## Run

docker run -d --name php4 -p 80:80 -v `pwd`/data:/usr/local/mysql/var -v `pwd`/app:/usr/local/apache2/htdocs php4

### Data Volume (mysql/var)

Must be the copy of the database folder of your old mysql application. All the users, tables, root password, etc. will be the same.

### App Folder (apache2/htdocs)

Must be the copy of folder of your php application.

### Sample App 

This git project carry a sample app/data for testing purpose.
