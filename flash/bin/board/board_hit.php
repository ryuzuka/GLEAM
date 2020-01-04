<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);

$query="update board set hit=hit+1 where no=$no";
mysql_query($query,$db);

mysql_close($db);
?>