//
//  ViewController.swift
//  Testmk2
//
//  Created by 杨昱程 on 2018/8/30.
//  Copyright © 2018年 杨昱程. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class ViewController: UIViewController {
    
    func alert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var et_vip_code: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var bt_login: UIButton!
    override func viewDidLoad() {
        et_vip_code.placeholder = "Please input username"
        super.viewDidLoad()
        Password.placeholder = "Please input passward"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func bt_login_clicked(_ sender: Any) {
        let vipCode = et_vip_code.text!
        let password = Password.text!
        let params = ["username":vipCode,"password":password,"method":"login"]
        let loginUrl = "http://10.0.0.2:8888/login.php"
        NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl, parameters: params as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
            
            if error != nil  {
                print(error!)
                return
            }
            print(result!)
            
            // 使用 SwiftyJSON 解析json -- 这里解析的是 jsonObject
            let json = JSON(result as Any)
            if let vip_id = json["code"].string {
                print("id是：",vip_id)
//                self.view.makeToast("id = " + vip_id) // Toast 提示
                if vip_id == "1" {
//                    self.view.makeToast("Please input the correct username or password") // Toast 提示
                    self.alert("Please input the correct username or password")
                }else{
                    self.view.makeToast("Register Success") // Toast 提示
                    // 跳转页面 - 从登录界面跳转到主界面
                    //      withIdentifier  跳转连接
                    //      sender          要传递的值
                    //      这里，我们传递vip_id，一个字符串。如果需要，我们也可以传递一个对象
                    self.performSegue(withIdentifier: "toSelection", sender: vipCode)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelection"{ // 如果 标识符 是 main2home
            // 获取要跳转的视图的控制器
            let controller = segue.destination as! SelectionViewController // HomeViewController 被传递的视图的控制器
            // 设置要跳转的视图的控制器 哪个变量（vip_id_str） 接收 传递过去的值（vip_id）
            controller.vip_id_str = sender as? String                 // vip_id_str         被传递的视图的控制器 的 对应变量
        }
    }
    @IBAction func register_touch(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: "参数")
    }
    @IBAction func et_vip_code_changed(_ sender: Any) {
        let vipCode = et_vip_code.text!
        if vipCode.count > 0 {
            bt_login.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.5411764706, blue: 1, alpha: 1) // 已经输入登录按钮背景色
        } else{
            bt_login.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.3921568627, blue: 0.5137254902, alpha: 1) // 没有输入登录按钮背景色
        }
    }
    @IBAction func CloseKeyBoard(_ sender: Any) {
        et_vip_code.resignFirstResponder()
        Password.resignFirstResponder()
    }
}

