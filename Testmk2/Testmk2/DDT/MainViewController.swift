//
//  RegisterViewController.swift
//  Testmk2
//
//  Created by 杨昱程 on 2018/9/19.
//  Copyright © 2018年 杨昱程. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
class MainViewController: UIViewController {
    let loginUrl = "http://10.0.0.2:8888/recording.php"

   
    @IBOutlet weak var Button1: UIButton!
    
    @IBOutlet weak var Button2: UIButton!    
 
    var Question1 =
        ["I perfer $54 today","I perfer $55 today","I perfer $19 today","I perfer $31 today","I perfer $14 today","I perfer $47 today","I perfer $15 today","I perfer $25 today","I perfer $78 today","I perfer $40 today","I perfer $11 today","I perfer $67 today","I perfer $34 today","I perfer $27 today","I perfer $69 today","I perfer $49 today","I perfer $80 today","I perfer $24 today","I perfer $33 today","I perfer $28 today","I perfer $34 today","I perfer $25 today","I perfer $41 today","I perfer $54 today","I perfer $54 today","I perfer $22 today","I perfer $20 today"]
    var Question2 =
        ["I perfer $55 in 117 days","I perfer $75 in 61 days","I perfer $25 in 53 days","I perfer $85 in 7 days","I perfer $25 in 9 days","I perfer $50 in 160 days","I perfer $35 in 13 days","I perfer $60 in 14 days","I perfer $80 in 162 days","I perfer $55 in 62 days","I perfer $30 in 7 days","I perfer $75 in 119 days","I perfer $35 in 186 days","I perfer $50 in 21 days","I perfer $85 in 91 days","I perfer $60 in 89 days","I perfer $85 in 157 days","I perfer $35 in 29 days","I perfer $80 in 14 days","I perfer $30 in 179 days","I perfer $50 in 30 days","I perfer $30 in 80 days","I perfer $75 in 20 days","I perfer $60 in 111 days","I perfer $80 in 30 days","I perfer $25 in 136 days","I perfer $55 in 7 days"]
    var randomNumber:Int = Int(arc4random_uniform(UInt32(26)))
    var qustionNumber = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]
    var vip_id_str:String?  // 准备接收传过来的值
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let rect:CGRect = CGRect(x: 20, y: 64, width: 400, height: 200)
        let label = UILabel.init(frame: rect)
        self.view.addSubview(label)
        let attributeString = NSMutableAttributedString.init(string: "Please selet which reward you woulrd prefer:\nThe smaller reward today, or larger reward in \nthe special number of days.")
        label.attributedText = attributeString
        
        label.numberOfLines = 0
        Button1.setTitle(Question1[randomNumber], for: .normal)
        Button2.setTitle(Question2[randomNumber], for: .normal)
        
      
    }
    @IBAction func Button1Click(_ sender: Any) {
        
        let params = ["username":vip_id_str,"questionNumber":String(qustionNumber[randomNumber]),"result":"oneDay"]

        print(qustionNumber[randomNumber])
        NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl, parameters: params as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
            
            if error != nil  {
                print(error!)
                return
            }
        }
       
        qustionNumber.remove(at: randomNumber)
        Question1.remove(at: randomNumber)
        Question2.remove(at: randomNumber)
        if Question1.isEmpty{
            self.performSegue(withIdentifier: "DDTtoSelection", sender: vip_id_str)
        }
        else{
            let randomNumber1:Int = Int(arc4random_uniform(UInt32(Question1.count)))
            Button1.setTitle(Question1[randomNumber1], for: .normal)
            Button2.setTitle(Question2[randomNumber1], for: .normal)
            randomNumber = randomNumber1
        }
       
    }
    @IBAction func Button2Click(_ sender: Any) {

        let params = ["username":vip_id_str,"questionNumber":String(qustionNumber[randomNumber]),"result":"moreDay"]
        
        NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl, parameters: params as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
            
            if error != nil  {
                print(error!)
                return
            }
        }
        qustionNumber.remove(at: randomNumber)
        Question1.remove(at: randomNumber)
        Question2.remove(at: randomNumber)
        if Question1.isEmpty{
            self.performSegue(withIdentifier: "DDTtoSelection", sender: vip_id_str)
        }
        else{
            let randomNumber1:Int = Int(arc4random_uniform(UInt32(Question1.count)))
            Button1.setTitle(Question1[randomNumber1], for: .normal)
            Button2.setTitle(Question2[randomNumber1], for: .normal)
      
            randomNumber = randomNumber1
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DDTtoSelection"{ // 如果 标识符 是 toSST
            // 获取要跳转的视图的控制器
            let controller = segue.destination as! SelectionViewController // HomeViewController 被传递的视图的控制器
            // 设置要跳转的视图的控制器 哪个变量（vip_id_str） 接收 传递过去的值（vip_id）
            controller.vip_id_str = sender as? String                 // vip_id_str         被传递的视图的控制器 的 对应变量
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
