////
////  NetTools.swift
////  wk微博
////
////  Created by wangkang on 2018/4/13.
////  Copyright © 2018年 wangkang. All rights reserved.
////
//
//import UIKit
//
//
//class NetTools:  AFHTTPSessionManager{
//    //let 线程安全 单例写法
//    //单例 1.shareInstance 永远是一个一个实例(一个固定的方式去哪 永远是一个实例)
//    //2.0永远只要一个实例
//    static let shareInstance: NetTools = {
//        let tools = NetTools();
//
//        return tools;
//    }()
//
//}
////MARK - 封装请求方法
//extension NetTools{
//    func request (methodType :RequestType ,urlString:String ,parameters:[String:AnyObject],finished:@escaping (_ result : Any?, _ error : NSError?) -> ()) {
//        // 1.定义成功的回调闭包
//        let successCallBack = { (task : URLSessionDataTask, result : Any?) -> Void in
//            finished(result, nil)
//        }
//
//        // 2.定义失败的回调闭包
//        let failureCallBack = { (task : URLSessionDataTask?, error : NSError) -> Void in
//            finished(nil, error)
//        }
//
//        // 3.发送网络请求
//        if methodType == .GET {
////            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
//            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
//        } else {
////            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
//        }
//
//
//    }
//}
import  UIKit
import Alamofire

enum RequestType:String{
    case GET = "GET"
    case POST = "POST"
}

class NetTools:  NSObject{
    //let 线程安全 单例写法
    //单例 1.shareInstance 永远是一个一个实例(一个固定的方式去哪 永远是一个实例)
    //2.0永远只要一个实例
    static let shareInstance: NetTools = {
        let tools = NetTools();

        return tools;
    }()
}

//MARK:-获取用户的信息
extension NetTools{
    func loadUserInfo(access_token : String ,uid :String,finished:@escaping (_ result:[String: AnyObject]?,_ error:Error?)->()){
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parameters = ["access_token":access_token,"uid":uid];
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            guard response.response?.statusCode == 200 else{
                finished(nil,response.error);
                return ;
            }
            finished(response.result.value as? [String : AnyObject],response.error);
        }
        
        
        
    }
}

//MARK:-请求accessToken
extension NetTools{
    func loadAccessToken(code:String,finished:@escaping (_ resule:[String:AnyObject]?,_ error:Error?)->()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //2.获取请求的参数
        let  paramsters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        Alamofire.request(urlString, method: .post, parameters: paramsters).responseJSON { (response) in
            guard response.response?.statusCode == 200 else{
                finished(nil,response.error);
                return
            }
            finished(response.result.value as? [String:AnyObject],response.error);
        }
        
    }
}

//MARK:- 封装请求
extension NetTools{
    func request(methodType : RequestType, urlString : String, parameters : [String : AnyObject], finished : @escaping (_ result :[String: AnyObject]?, _ error : Error?) -> ()) {
        if methodType == .GET {
            Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
                finished(response.result.value as? [String : AnyObject],response.error);
            };
        }else{
            Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON { (response) in
                finished(response.result.value as? [String : AnyObject],response.error);
            };
        }
        
    }
}

//获取首页数据
extension NetTools{
    func loadStatuses(_ since_id:Int ,_ max_id :Int, finished:@escaping (_ result :[[String:AnyObject]]?,_ error:Error?)->()){
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token":(UserAccountViewModel.shareIntance.account?.access_token)!, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (dict, error) in
            guard let resultDict = dict else {
                finished(nil,error);
                return;
            }
            
            finished(resultDict["statuses"] as? [[String:AnyObject]],error)
        }
    }
}
//发送微博
extension NetTools{
    func sendStatus(statusText:String , isSuccess:@escaping (_ isSuccess:Bool)->()){
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parameters = ["access_token":(UserAccountViewModel.shareIntance.account?.access_token)!,"status":statusText]
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            if error == nil {
                isSuccess(true)
            }else{
                isSuccess(false)
            }
        }
    }
}
//发送带图片的微博
extension NetTools{
    func sendStatus(statusText:String , image:UIImage, isSuccess:@escaping (_ isSuccess:Bool)->()){
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
//        let imageData = UIImageJPEGRepresentation(image,0.5)
        let imageData = image.jpegData(compressionQuality: 0.5)
        //3.发送网络请求
        Alamofire.upload(multipartFormData: { (data) in
            data.append(imageData!, withName: "pic", mimeType: "image/png")
            for  dict in parameters{
                let key =  dict.key
                let value = dict.value
                data.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: urlString) { (result) in
            switch result{
            case .success(request: _, streamingFromDisk: _, streamFileURL: _):
                isSuccess(true)
                break
            case .failure(_):
                isSuccess(false)
                break
            }
        }
    }
}
