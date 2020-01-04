<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);

if($db)
{
	$check=time();
	$hit=0;
	$ip=$REMOTE_ADDR;
	$query="UPDATE board SET uid=uid+1 WHERE uid >= $uid";
	$result=mysql_query($query,$db);
	$query="insert into board values('','$name','$subject','$message','$email',$check,$hit,'$ip','$pass','$depth','$uid')";
	$result=mysql_query($query,$db);

	echo "reply=success";
}
else
{
	echo "reply=fail";
}
mysql_close($db);
?>