//
//  RegisterViewController.swift
//  Testmk2
//
//  Created by 杨昱程 on 2018/9/20.
//  Copyright © 2018年 杨昱程. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON

class RegisterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
    

    @IBOutlet weak var user_id: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Mail: UITextField!
    @IBOutlet weak var Age: UIPickerView!
    @IBOutlet weak var Sex: UIPickerView!
    @IBOutlet weak var Name: UITextField!
    var sexType = ["Please select your gender","Male","Female"]
    var age = [String]()
    var selectedSex = ""
    var selectedAge = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Age.dataSource = self
        Age.delegate = self
        Sex.dataSource = self
        Sex.delegate = self
        user_id.placeholder = "Please input User ID"
        Password.placeholder = "Please input passward"
        Mail.placeholder = "Plsease input mail address"
        Name.placeholder = "Plsease input your name"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func register_button_clicked(_ sender: Any) {
        let username = user_id.text!
        let password = Password.text!
        let mail = Mail.text!
        let sex = selectedSex
        let age = selectedAge
        let name = Name.text!
        let params = ["username":username,"password":password,"method":"registered","email":mail,"sex":sex,"age":age,"name":name]
        let loginUrl = "http://10.0.0.2:8888/login.php"
       
        if !username.CheckUserName(){
            print("失败")
            self.view.makeToast("The format of username is ilegal")
        }
        else if !password.CheckPassword(){
            print("失败")
            self.view.makeToast("To verify the password, you must have more than 6 characters. And it is necessary to have numbers and English, any two of the symbols")
        }
        else if !mail.CheckMail(){
            print("失败")
            self.view.makeToast("The format of mail address is ilegal")
        }
        else if !name.CheckName(){
            print("失败")
            self.view.makeToast("Name is ilegal")
        }
        
        else if age == ""{
            self.view.makeToast("Please select your Age")
        }
        else if sex == ""{
            print("失败")
            self.view.makeToast("Please select your gender")
        }

        else{
            NetworkTools.shareInstance.request(methodType: .POST, urlString: loginUrl, parameters: params as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
            
                if error != nil  {
                    print(error!)
                    return
                }
                let json = JSON(result as Any)
                if let code = json["code"].string{
                    if code == "1" {
                        self.view.makeToast("User name has already existed") // Toast 提示
                    }
                    else{
                        self.view.makeToast("Register Success")
                        self.performSegue(withIdentifier: "backToLogin",sender: "参数")
                    }
                }
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == Sex {
            return 3
        }
        else{
            return 99
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        //print(peopleData[row])
        if(pickerView == Sex){
            return sexType[row]
        }
        else{
            age.append("Age")
            for i in 1...100{
                age.append(String(i))
            }
            return age[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == Sex){
            //记录用户选择的值
            selectedSex = sexType[row]
            print(selectedSex)
        }
        else{
            selectedAge = age[row]
            print(selectedAge)
        }
    }
    @IBAction func backToMaunal(_ sender: Any) {
        self.performSegue(withIdentifier: "backToLogin",sender: "参数")
    }
    
    @IBAction func CloseKeyBoard(_ sender: Any) {
        user_id.resignFirstResponder()
        Password.resignFirstResponder()
        Mail.resignFirstResponder()
        Name.resignFirstResponder()
    }
    
}


extension String {
    
            //MARK:检测用户名
    
            func CheckUserName() -> Bool {
        
                        let patten = "(^[\u{4e00}-\u{9fa5}]{2,12}$)|(^[A-Za-z0-9_-]{4,12}$)"
        
                        let regex = try! NSRegularExpression(pattern: patten, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        
                        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
            
                                    return true
            
                            }
        
                        return false
        
                        }
            func CheckPassword() -> Bool {
                
                                let patten = "^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,20}$"
                
                                let regex = try! NSRegularExpression(pattern: patten, options: NSRegularExpression.Options.dotMatchesLineSeparators)
                
                                if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
                    
                                            return true
                    
                                    }
                
                                return false
                
                        }
            func CheckName() -> Bool {
        
                        let patten = "^\\w+[\\w\\s]+\\w+$"
        
                        let regex = try! NSRegularExpression(pattern: patten, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        
                        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
            
                                    return true
            
                            }
        
                        return false
        
                        }
            func CheckMail() -> Bool {
                
                                                let patten = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                
                                                let regex = try! NSRegularExpression(pattern: patten, options: NSRegularExpression.Options.dotMatchesLineSeparators)
                
                                                if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
                    
                                                                    return true
                    
                                                    }
                
                                                return false
                
                                }
    
            
    
}
