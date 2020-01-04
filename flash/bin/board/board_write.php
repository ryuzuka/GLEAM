<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);

if($db)
{
	$query="SELECT MAX(uid)+1 FROM board";
	$result=mysql_query($query,$db);
	$data=mysql_fetch_array($result);

	$uid=$data[0];
	$depth=0;

	$check=time();
	$hit=0;
	$ip=$REMOTE_ADDR;
	$query="insert into board values('','$name','$subject','$message','$email',$check,$hit,'$ip','$pass','$depth','$uid')";
	$result=mysql_query($query,$db);
	if($result)
	{
		echo "write success";
	}
	else
	{
		echo "write fail";
	}
}
mysql_close($connect);
?>