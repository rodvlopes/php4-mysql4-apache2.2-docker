<?php
$server = 'localhost:3306';
$db_name = 'mysql';
$user = 'root';
$pass = 'IAmRoot';

$connection = mysql_connect ($server,$user,$pass) or die (mysql_error() . ' Failed to connect to database $server');
$db = mysql_select_db ($db_name, $connection) or die(mysql_error() . ' Failed to select $db_name');
$result = mysql_query('select Host,User from user') or die(mysql_error() . ' Cant select DB.');
echo 'Mysql is Working.';
?>

<?php phpinfo(); ?>

