<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);

$query="select pass from board where no='$no'";
$result=mysql_query($query,$db);
$row=mysql_fetch_array($result);

if($row[pass]==$pass)
{
	$query="delete from board where no='$no'";
	mysql_query($query,$db);
	echo "$delete=ok";
}
else
{
	echo "delete=fail";
}

mysql_close($db);
?>