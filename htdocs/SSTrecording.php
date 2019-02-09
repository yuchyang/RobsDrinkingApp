<?php
header("Content-type:text/html;charset=utf-8");
session_start();
/**
 * User: yyc
 * Date: 18/10/23
 * Time: 下午4:51
 */
$dbhost     = "localhost";   //地址
$dbuser     = "root";        //账户
$dbpassword = "191938";            //密码
$dbName     = "MyGuests";       //数据库
$tableName  = "SSTRecord";    //表
$port = "8889";
//创建连接
$conn = mysqli_connect($dbhost, $dbuser, $dbpassword, $dbName, $port);
//检测连接
if (!$conn) {
    die("connection failed:" . mysqli_connect_error());
}

//获取输入的信息
$username = $_POST['username'];
$experimentNumber = $_POST['experimentNumber'];
$incorrect   = $_POST['incorrect']; 
$miss = $_POST['miss'];
$successStopPercent = $_POST ['successStopPercent'];
$correct = $_POST['correct'];


$sql1 = "INSERT INTO SSTRecord (username,success".$experimentNumber.",incorrect".$experimentNumber.",miss".$experimentNumber.",successStopPercent".$experimentNumber.") VALUES ('$username','$correct','$incorrect','$miss','$successStopPercent')";
$result1 = mysqli_query($conn, $sql1 ) ;
echo $sql1 ;
if (!$result1) {
    $sql2 = "UPDATE SSTRecord SET incorrect".$experimentNumber." = '$incorrect', miss".$experimentNumber." = '$miss',successStopPercent".$experimentNumber." = '$successStopPercent', success".$experimentNumber." = '$correct' where username = '$username'";
    $result1 = mysqli_query($conn, $sql2) ;
}

$raw_success = array('code' => '0', 'msg' => '添加成功');
$res_success = json_encode($raw_success);
echo $res_success;



$conn->close();
?>
