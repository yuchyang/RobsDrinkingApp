<?php
	/*验证验证码是否正确*/
	session_start();
	
	$code = trim($_POST['code']);//接收前端传来的数据
	
	$raw_success = array('code' => 1, 'msg' => '验证码正确');
	
	$raw_fail = array('code' => 2, 'msg' => '验证码错误');
	
	$res_success = json_encode($raw_success);
	$res_fail = json_encode($raw_fail);
	
	
	header('Content-Type:application/json');//这个类型声明非常关键
	
	echo $res_success;
?>
