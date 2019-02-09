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
    $tableName  = "SSTReact";    //表
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
    $reaction1   = $_POST['reaction1'];
    $reaction2   = $_POST['reaction2'];
    $reaction3   = $_POST['reaction3'];
    $reaction4   = $_POST['reaction4'];
    $reaction5   = $_POST['reaction5'];
    $reaction6   = $_POST['reaction6'];
    $reaction7   = $_POST['reaction7'];
    $reaction8   = $_POST['reaction8'];
    $reaction9   = $_POST['reaction9'];
    $reaction10   = $_POST['reaction10'];
    
  
    $sql1 = "INSERT INTO SSTReact (user_id,experiment".$experimentNumber."_reaction1,experiment".$experimentNumber."_reaction2,experiment".$experimentNumber."_reaction3,experiment".$experimentNumber."_reaction4,experiment".$experimentNumber."_reaction5,experiment".$experimentNumber."_reaction6,experiment".$experimentNumber."_reaction7,experiment".$experimentNumber."_reaction8,experiment".$experimentNumber."_reaction9,experiment".$experimentNumber."_reaction10) VALUES ('$username','$reaction1','$reaction2','$reaction3','$reaction4','$reaction5','$reaction6','$reaction7','$reaction8','$reaction9','$reaction10')";
    $result1 = mysqli_query($conn, $sql1 ) ;
    echo $sql1 ;
    if (!$result1) {
        $sql2 = "UPDATE SSTReact SET experiment".$experimentNumber."_reaction1 = '$reaction1', experiment".$experimentNumber."_reaction2 = '$reaction2',experiment".$experimentNumber."_reaction3 = '$reaction3', experiment".$experimentNumber."_reaction4 = '$reaction4',experiment".$experimentNumber."_reaction5 = '$reaction5',experiment".$experimentNumber."_reaction6 = '$reaction6',experiment".$experimentNumber."_reaction7 = '$reaction7',experiment".$experimentNumber."_reaction8 = '$reaction8',experiment".$experimentNumber."_reaction9 = '$reaction9',experiment".$experimentNumber."_reaction10 = '$reaction10' where user_id = '$username'";
        $result1 = mysqli_query($conn, $sql2) ;
    }
    
    $raw_success = array('code' => '0', 'msg' => '添加成功');
    $res_success = json_encode($raw_success);
    echo $res_success;
    
    
    
    $conn->close();
    ?>

