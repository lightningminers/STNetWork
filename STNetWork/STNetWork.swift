//
//  STNetWork.swift
//  Stan
//
//  Created by xiangwenwen on 15/6/2.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit


class STNetWork: NSObject {
    
    /**
    GET|POST 普通的
    
    :param: method  <#method description#>
    :param: url     <#url description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func request(method:String,url:String,success:((dataString:NSString!,data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil)->Void{
        let manager = STNetWorkManager(url: url, method: method,success: success, error: error, STRequest: nil)
        manager.fire()
    }
    
    /**
    GET|POST 带参数的请求
    
    :param: method  <#method description#>
    :param: url     <#url description#>
    :param: params  <#params description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func request(method:String,url:String,params:Dictionary<String,AnyObject>,success:((dataString:NSString!,data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil)->Void{
        var HttpUrl:String! = url
        if method == HTTPMETHOD.GET.rawValue{
            HttpUrl = HttpUrl+"?"+STNetWorkRequest.buildParams(params)
        }
        let manager = STNetWorkManager(url: HttpUrl, method: method, success: success, error: error, STRequest: nil)
        if method != HTTPMETHOD.GET.rawValue{
            manager.STRequest.STParams = params
        }
        manager.fire()
    }
    
    /**
    GET|POST 带参数并且可以设置头
    
    :param: method  <#method description#>
    :param: url     <#url description#>
    :param: params  <#params description#>
    :param: header  <#header description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func request(method:String,url:String,params:Dictionary<String,AnyObject>,header:Dictionary<String,AnyObject>,success:((dataString:NSString!,data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil)->Void{
        var HttpUrl:String! = url
        if method == HTTPMETHOD.GET.rawValue{
            HttpUrl = HttpUrl+"?"+STNetWorkRequest.buildParams(params)
        }
        println(HttpUrl)
        let manager = STNetWorkManager(url: HttpUrl, method: method, success: success, error: error, STRequest: nil)
        manager.STRequest.setRequestHeader(header)
        if method != HTTPMETHOD.GET.rawValue{
            manager.STRequest.STParams = params
        }
        manager.fire()
    }
    
    /**
    POST模拟表单提交文件
    
    :param: url     <#url description#>
    :param: type    <#type description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func upload(url:String,type:STFType,success:((data:NSData!,response:NSURLResponse!)-> Void)? = nil,error:((error:NSError!)-> Void)? = nil)->Void{
        let codeName:String = "file"
        let fileUrl:String? =  NSBundle.mainBundle().pathForResource(type.fileName, ofType:type.fileType)
        if let _fileUrl = fileUrl{
            let manager = STNetWorkUpLoadFileManager(url: url, files: nil, success: success, error: error, STRequest: nil)
            let file = STFile(name: codeName, url: _fileUrl,data:nil)
            let header:Dictionary<String,AnyObject> = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
            manager.STRequest.setRequestHeader(header)
            manager.STRequest.STFileParams = [file]
            manager.fire()
        }
        
    }
    
    /**
    POST Task 提交文件
    
    :param: URL     <#URL description#>
    :param: files   <#files description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func taskupload(URL:String,files:Array<STFile>,success:(data:NSData!,response:NSURLResponse!)-> Void,error:(error:NSError!)-> Void)-> Void{
        let manager = STNetWorkUpLoadFileManager(url: URL,files:files, success: success, error: error, STRequest: nil)
        manager.STRequest.HTTPMethod = HTTPMETHOD.GET.rawValue
        manager.fire()
    }
    
    /**
    下载
    
    :param: URL     <#URL description#>
    :param: success <#success description#>
    :param: error   <#error description#>
    */
    static func download(URL:String,success:(url:NSURL!,response:NSURLResponse!)-> Void,error:(error:NSError!)-> Void)->Void{
        let manager = STNetWorkDownloadManager(URL: URL, success: success, error: error, STRequest: nil)
        manager.STRequest.HTTPMethod = HTTPMETHOD.GET.rawValue
        manager.fire()
    }
}












