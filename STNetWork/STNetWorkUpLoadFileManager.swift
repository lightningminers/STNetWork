//
//  STNetWorkUpLoadFileManager.swift
//  STNetWork
//
//  Created by xiangwenwen on 15/6/12.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit


public struct STFile{
    let fileName:String!
    let fileURL:String?
    let fileData:NSData?
    internal init(name:String,url:String?,data:NSData?){
        self.fileName = name
        self.fileURL = url
        self.fileData = data
    }
}

public struct STFType{
    let fileName:String!
    let fileType:String!
    internal init(name:String,type:String){
        self.fileName = name
        self.fileType = type
    }
}

class STNetworkUpLoadFileManager: NSObject{
    
    let HttpUrl:String
    let success:((data:NSData!,response:NSURLResponse!)-> Void)?
    let error:((error:NSError!)-> Void)?
    
    var STRequest:STNetworkRequest!
    var files:Array<STFile>?
    
    init(url:String,files:Array<STFile>?,success:((data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil,STRequest:STNetworkRequest?) {
        
        self.HttpUrl = url
        self.success = success
        self.error = error
        self.files = files
        if let _STRequest = STRequest{
            self.STRequest = STRequest
        }else{
            self.STRequest = STNetworkRequest(HttpURL: NSURL(string: HttpUrl)!)
        }
    }
    
    func fire()->Void{
        let configur:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configur)
        var _files:Array<STFile>!
        if let STFileP = self.STRequest.STFileParams{
            _files = self.STRequest.STFileParams!
        }else{
            _files = self.files!
        }
        if _files[0].fileData == nil{
            self.STRequest.HTTPMethod = HTTPMETHOD.POST.rawValue
            let task:NSURLSessionTask = session.dataTaskWithRequest(self.STRequest, completionHandler: { (data, response, error) -> Void in
                if error != nil{
                    let err = NSError(domain: "\(domain)", code: error.code, userInfo: error.userInfo)
                    self.error?(error: err)
                }else{
                    if let HttpResponse = response as? NSHTTPURLResponse{
                        let code = HttpResponse.statusCode
                        if code >= 400{
                            self.error?(error: NSError(domain: "\(domain)", code: code, userInfo: error.userInfo))
                        }else{
                            self.success?(data: data, response: response)
                        }
                        println("STNetWork HTTP Status: \(code) \(NSHTTPURLResponse.localizedStringForStatusCode(code))")
                    }
                }
            })
            task.resume()
        }else{
            let task:NSURLSessionTask = session.uploadTaskWithRequest(self.STRequest, fromData: _files[0].fileData, completionHandler: { (data, response, error) -> Void in
                if error != nil{
                    let err = NSError(domain: "\(domain)", code: error.code, userInfo: error.userInfo)
                    self.error?(error: err)
                }else{
                    self.success?(data: data, response: response)
                }
            })
            task.resume()
        }
    }
}