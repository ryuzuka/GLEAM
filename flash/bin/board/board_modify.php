<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);

$query="select pass from board where no='$no'";
$result=mysql_query($query,$db);
$row=mysql_fetch_array($result);

if($row[pass]==$pass)
{
	$ip=$REMOTE_ADDR;
	$check=time();
	$query="update board set name='$name',subject='$subject',message='$message',email='$email',mkdate=$check,ip='$ip',pass='$changePass' where no='$no'";
	mysql_query($query,$db);

	echo "result=ok";
}
else
{
	echo "result=fail";
}
mysql_close($db);
?>