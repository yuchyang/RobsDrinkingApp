//
//  AFNetworkingManager.swift
//  Testmk2
//
//  Created by 杨昱程 on 2018/9/1.
//  Copyright © 2018年 杨昱程. All rights reserved.
//


import Foundation
import AFNetworking


// 定义枚举类型
enum HTTPRequestType : Int{
    case GET = 0
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    // 设计单例 let是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
    
}

// 封装请求方法
extension NetworkTools {
    func request(methodType : HTTPRequestType, urlString : String, parameters : [String : AnyObject], finished :@escaping (_ result : AnyObject?, _ error : Error?)-> ())  {
        // 1 成功回调
        let successCallBack = {(task :URLSessionDataTask, result : Any) in
            finished(result as AnyObject?, nil)
        }
        // 2 失败回调
        let failureCallBack = {(task : URLSessionDataTask?, error :Error) in
            finished(nil, error)
        }
        
        if methodType == .GET {
            // get请求
            
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else {
            // post请求
            
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }
    }
}
