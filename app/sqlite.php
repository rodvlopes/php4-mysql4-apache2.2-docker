<?php
$db_file = '/usr/local/sqlite/var/sample.db';

// sqlite_open() would silently create an empty database
if (!file_exists($db_file)) {
	die('Database not found: ' . htmlspecialchars($db_file));
}

$db = sqlite_open($db_file, 0666, $error) or die('Failed to open database: ' . htmlspecialchars($error));
$result = sqlite_query($db, 'SELECT id, name, email, since FROM contacts ORDER BY id')
	or die('Query failed: ' . htmlspecialchars(sqlite_error_string(sqlite_last_error($db))));
?>
<html>
<head><title>SQLite test</title></head>
<body>
<h1>SQLite is Working.</h1>
<p>
  PHP <?php echo phpversion(); ?> &middot;
  SQLite <?php echo sqlite_libversion(); ?> (<?php echo sqlite_libencoding(); ?>) &middot;
  <?php echo htmlspecialchars($db_file); ?>
</p>
<table border="1" cellpadding="4" cellspacing="0">
  <tr><th>id</th><th>name</th><th>email</th><th>since</th></tr>
<?php while ($row = sqlite_fetch_array($result, SQLITE_ASSOC)) { ?>
  <tr>
<?php foreach ($row as $value) { ?>
    <td><?php echo htmlspecialchars($value); ?></td>
<?php } ?>
  </tr>
<?php } ?>
</table>
<?php
// Rolled back: only checks that the journal can be written next to the database
sqlite_query($db, 'BEGIN');
$written = sqlite_query($db, "INSERT INTO contacts (name) VALUES ('write test')");
$write_error = $written ? '' : sqlite_error_string(sqlite_last_error($db));
sqlite_query($db, 'ROLLBACK');
sqlite_close($db);
?>
<p>Write access: <?php echo $written ? 'OK (rolled back)' : 'FAILED - ' . htmlspecialchars($write_error); ?></p>
</body>
</html>
