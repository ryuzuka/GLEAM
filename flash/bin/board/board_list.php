<?
$db=mysql_connect("localhost","ryuzuka","fvyr7fvv");
mysql_select_db("ryuzuka",$db);


$pageIndex=$pageIndex-1;
$pageIndex=$pageIndex*$listNum;

$query="select*from board order by uid DESC limit $pageIndex, $listNum";

$result=mysql_query($query,$db);
$i=0;

while($row=mysql_fetch_array($result))
{
	$no=$row[no];
	$name=$row[name];
	$subject=$row[subject];
	$message=$row[message];
	$email=$row[email];
	$ip=$row[ip];
	$w_date=date("y.m.d",$row[mkdate]);
	$hit=$row[hit];
	$pass=$row[pass];
	$depth=$row[depth];
	$uid=$row[uid];

	$i++;

	echo "no$i=$no&";
	echo "name$i=$name&";
	echo "subject$i=$subject&";
	echo "message$i=$message&";
	echo "email$i=$email&";
	echo "ip$i=$ip&";
	echo "w_date$i=$w_date&";
	echo "hit$i=$hit&";
	echo "pass$i=$pass&";
	echo "depth$i=$depth&";
	echo "uid$i=$uid&";
}
echo "loop=$i&";



$query="select count(*)from board";
$result=mysql_query($query,$db);
$row=mysql_fetch_row($result);
$pageNum=ceil($row[0]/$listNum);
echo "pageNum=$pageNum";

mysql_close($ryuzuka);


?>