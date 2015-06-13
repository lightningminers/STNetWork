//
//  STNetWorkDownloadManager.swift
//  STNetWork
//
//  Created by xiangwenwen on 15/6/12.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit

class STNetWorkDownloadManager: NSObject {
    
    let HttpUrl:String!
    let success:((url:NSURL!,response:NSURLResponse!)->Void)?
    let error:((error:NSError!)->Void)?
    var STRequest:STNetWorkRequest!
    
    init(URL:String,success:((url:NSURL!,response:NSURLResponse!)->Void)?,error:((error:NSError!)->Void)?,STRequest:STNetWorkRequest?) {
        self.HttpUrl = URL
        self.success = success
        self.error = error
        if let _STRequest = STRequest{
            self.STRequest = _STRequest
        }else{
            self.STRequest = STNetWorkRequest(HttpURL: NSURL(string: self.HttpUrl)!)
        }
    }
    
    func fire()->Void{
        let configur = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configur)
        let task = session.downloadTaskWithRequest(self.STRequest, completionHandler: { (url, response, error) -> Void in
            if error != nil{
                let err = NSError(domain: "\(domain)", code: error.code, userInfo: error.userInfo)
                self.error?(error: err)
            }else{
                self.success?(url: url, response: response)
            }
        })
        task.resume()
    }
}
