//
//  SelectionViewController.swift
//  Testmk2
//
//  Created by 杨昱程 on 2018/10/3.
//  Copyright © 2018年 杨昱程. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    var vip_id_str:String?  // 准备接收传过来的值
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        self.performSegue(withIdentifier: "logout", sender: vip_id_str)
    }
    @IBAction func DDTButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toDDT", sender: vip_id_str)
    }
    @IBAction func SSTButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toSST", sender: vip_id_str)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDDT"{ // 如果 标识符 是 toSST
            // 获取要跳转的视图的控制器
            let controller = segue.destination as! MainViewController // HomeViewController 被传递的视图的控制器
            // 设置要跳转的视图的控制器 哪个变量（vip_id_str） 接收 传递过去的值（vip_id）
            controller.vip_id_str = sender as? String                 // vip_id_str         被传递的视图的控制器 的 对应变量
        }
        else if segue.identifier == "toSST"{ // 如果 标识符 是 toSST
            // 获取要跳转的视图的控制器
            let controller = segue.destination as! SSTViewController // HomeViewController 被传递的视图的控制器
            // 设置要跳转的视图的控制器 哪个变量（vip_id_str） 接收 传递过去的值（vip_id）
            controller.vip_id_str = sender as? String                 // vip_id_str         被传递的视图的控制器 的 对应变量
        }
    }
   

}
