<?php
$servername = "127.0.0.1";
$username = "root";
$password = "191938";
$dbname = "mysql";
$port = "8889"; 
// 创建连接
$dbc = new mysqli($servername,$username,$password,"testAppDatabase",$port);
// 检测连接
if ($dbc->connect_error) {
    die("连接失败: " . $dbc->connect_error);
} 
echo "连接成功";
$dbc->close();

?>