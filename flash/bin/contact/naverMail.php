<?php
$name;
$from;
$to = 'ryuzuka@naver.com';
$subject;
$massage;
$from= "from : ".$name."<".$from.">";

mail($to,$subject,$massage,$from);
echo "mail complete";
?>

<!--
http://ryuzuka.cafe24.com/php/naverMail.php?name=test&from=test@test.com&subject=test&massage=test
-->