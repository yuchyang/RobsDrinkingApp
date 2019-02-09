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
$tableName  = "MyGuests";    //表
$port = "8889";
//创建连接
$conn = mysqli_connect($dbhost, $dbuser, $dbpassword, $dbName, $port);
//检测连接
if (!$conn) {
    die("connection failed:" . mysqli_connect_error());
}
//获取输入的信息
$username = $_POST['username'];
$passcode = $_POST['password'];
$method   = $_POST['method'];    //registered:注册    login:登录
$email    = $_POST['email'];
$age      = $_POST['age'];
$sex      = $_POST['sex'];
$name     = $_POST['name'];


//根据方法判断
if ($method == "registered") {
    //注册
    //判断用户名是否已存在
    $sql1 = "select * from MyGuests where UserName = '$username'";
    $result1 = mysqli_query($conn, $sql1) or die("SQL 语句执行失败");
    if (!$result1) {
        die('Error: ' . mysqli_error());
    }else {
        if ($row = mysqli_fetch_array($result1)) {
            //重复
	    $raw_fail = array('code' => '1', 'msg' => 'userName 已存在');
	    $res_fail = json_encode($raw_fail);
            echo $res_fail;
        }else {
            //开始注册
            $sql1 = "insert into MyGuests (UserName, Password, Email, Sex, Age ,Name) VALUES ( '$username','$passcode','$email','$sex','$age','$name')";
            $result1 = mysqli_query($conn, $sql1 ) or die("SQL 语句执行失败");
            if (!$result1) {
                die('Error: ' . mysqli_error());
            }
	    $raw_success = array('code' => '0', 'msg' => '注册成功');
	    $res_success = json_encode($raw_success);
            echo $res_success;
        }
    }
}else if ($method == "login") {
    //登录
    $sql2 = "select * from MyGuests where UserName = '$username' and Password = '$passcode'";
    $result2 = mysqli_query($conn, $sql2) or die("SQL 语句执行失败");
    if (!$result2) {
        die('Error: ' . mysqli_error());
    }else {
        if ($row = mysqli_fetch_array($result2)) {
            //重复
	    $raw_success = array('code' => '0', 'msg' => '登录成功');
	    $log_success = json_encode($raw_success);
	    echo $log_success;
        } else {
    	    $raw_fail = array('code' => '1', 'msg' => '登录失败');
    	    $log_fail = json_encode($raw_fail);
    	    echo $log_fail;
        }
    }
}

$conn->close();
?>
