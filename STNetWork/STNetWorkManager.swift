//
//  STNetWorkManager.swift
//  Stan
//
//  Created by xiangwenwen on 15/6/2.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit

class STNetWorkManager: NSObject {
    let HTTPMethod:String!
    let success:((dataString:NSString!,data:NSData!,response:NSURLResponse!)-> Void)?
    let error:((error:NSError!)-> Void)?
    
    var HTTPUrl:String!
    var STRequest:STNetWorkRequest!
    var task:NSURLSessionTask!
    var session:NSURLSession!

    init(url:String,method:String,success:((dataString:NSString!,data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil,STRequest:STNetWorkRequest?) {
        self.HTTPUrl = url
        self.HTTPMethod = method
        self.error = error
        self.success = success
        if let _STRequest = STRequest{
            self.STRequest = _STRequest
        }else{
            self.STRequest = STNetWorkRequest(HttpURL: NSURL(string: self.HTTPUrl)!)
            self.STRequest.HTTPMethod = self.HTTPMethod
        }
    }
    
    func fire()-> Void{
        println(self.STRequest.allHTTPHeaderFields)
        let configur = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration:configur)
        let task = session.dataTaskWithRequest(self.STRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil{
                let err = NSError(domain: "\(domain)", code: error.code, userInfo: error.userInfo)
                self.error?(error: err)
            }else{
                if let HttpResponse = response as? NSHTTPURLResponse{
                    let code = HttpResponse.statusCode
                    if code >= 400{
                        self.error?(error: NSError(domain: "\(domain)", code: code, userInfo: error.userInfo))
                    }else{
                        let responseString:NSString = NSString(data:data, encoding:NSUTF8StringEncoding)!
                        self.success?(dataString: responseString, data: data, response: response)
                    }
                    println("STNetWork HTTP Status: \(code) \(NSHTTPURLResponse.localizedStringForStatusCode(code))")
                }
            }
        })
        task.resume()
    }
}