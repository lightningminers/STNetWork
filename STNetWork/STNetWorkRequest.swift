//
//  STNetWorkRequest.swift
//  STNetWork
//
//  Created by xiangwenwen on 15/6/12.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit

public enum HTTPMETHOD:String{
    case DELETE = "DELETE"
    case GET = "GET"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case PATCH = "PATCH"
    case POST = "POST"
    case PUT = "PUT"
}

let boundary = "WenUGl0YXlh"
let domain = "wen.STNetWork"

extension String {
    var STNSData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    var STBase64: String! {
        let utf8EncodeData: NSData! = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let base64EncodingData = utf8EncodeData.base64EncodedStringWithOptions(nil)
        return base64EncodingData
    }
}

class STNetworkRequest:NSMutableURLRequest{
    
    let STUserAgent: String = {
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey] ?? "Unknown"
            let bundle: AnyObject = info[kCFBundleIdentifierKey] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey] ?? "Unknown"
            let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, 0) == 1 {
                return mutableUserAgent as NSString as! String
            }
        }
        return "STNetWork"
    }()
    var STParams:Dictionary<String,AnyObject>?{
        get{
            return self._STParams
        }
        set(newValue){
            self._STParams = newValue
            self.HTTPBody = self.setRequestBody()
        }
    }
    private var _STParams:Dictionary<String,AnyObject>?
    
    var STFileParams:Array<STFile>?{
        get{
            return self._STFileParams
        }
        set(newValue){
            self._STFileParams = newValue
            self.HTTPBody = self.setRequestFile()
        }
    }
    private var _STFileParams:Array<STFile>?
    
    
    /**
    便利构造方法（传入一个NSURL）
    
    :param: HttpURL <#HttpURL description#>
    
    :returns: <#return value description#>
    */
    convenience init(HttpURL:NSURL){
        self.init(HttpURL:HttpURL,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,timeoutInterval:NSTimeInterval(13))
    }
    
    /**
    便利构造方法（传入一个NSURL，设置超时时间）
    
    :param: HttpURL         <#HttpURL description#>
    :param: timeoutInterval <#timeoutInterval description#>
    
    :returns: <#return value description#>
    */
    convenience init(HttpURL:NSURL,timeoutInterval:NSTimeInterval){
        self.init(HttpURL:HttpURL,cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,timeoutInterval:timeoutInterval)
    }
    
    /**
    原始的init方法（传入一个NSURL，指定缓存策略，设置超时时间）
    
    :param: HttpURL         <#HttpURL description#>
    :param: cachePolicy     <#cachePolicy description#>
    :param: timeoutInterval <#timeoutInterval description#>
    
    :returns: <#return value description#>
    */
    init(HttpURL:NSURL,cachePolicy:NSURLRequestCachePolicy,timeoutInterval:NSTimeInterval){
        super.init(URL: HttpURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.addValue(self.STUserAgent, forHTTPHeaderField: "User-Agent")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    设置header
    
    :param: header <#header description#>
    */
    func setRequestHeader(header:Dictionary<String,AnyObject>?)-> Void{
        if let Rheader:Dictionary<String,AnyObject> = header{
            for(key,value) in Rheader{
                self.addValue(value as? String, forHTTPHeaderField: key)
            }
        }
    }
    
    /**
    设置cookie
    
    :param: cookie <#cookie description#>
    */
    func setRequestCookie(cookie:Dictionary<String,AnyObject>?)->Void{
        if let Rcookie:Dictionary<String,AnyObject> = cookie{
            var _cookie:String = ""
            for(key,value) in Rcookie{
                _cookie = _cookie+"\(key)=\(value as! String);"
            }
            self.setRequestHeader(["Set-Cookie":_cookie])
        }
    }
    
    /**
    给当前request 设置超时时间
    
    :param: timeout <#timeout description#>
    */
    func setRequestTimeout(timeout:NSTimeInterval?)-> Void{
        self.timeoutInterval = NSTimeInterval(timeout == nil ? NSTimeInterval(10) : NSTimeInterval(timeout!))
    }

    /**
    拼接URL字符串
    
    :param: parameters <#parameters description#>
    
    :returns: <#return value description#>
    */
    static func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(parameters.keys), <) {
            let value: AnyObject! = parameters[key]
            components += STNetworkRequest.queryComponents(key, value)
        }
        return join("&", components.map{"\($0)=\($1)"} as [String])
    }
    
    /**
    查询字符串
    
    :param: key   <#key description#>
    :param: value <#value description#>
    
    :returns: <#return value description#>
    */
    static func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.extend([(STNetworkRequest.escape(key), escape("\(value)"))])
        }
        return components
    }
    
    /**
    转义
    
    :param: string <#string description#>
    
    :returns: <#return value description#>
    */
    static func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    private func setRequestBody()-> NSData{
        var header = self.allHTTPHeaderFields
        var body = NSMutableData()
        if let contentType:AnyObject = header!["Content-Type"]{
            if String(contentType as! String) == "application/json"{
                if let params = self._STParams{
                    println("set Content-Type --- \(contentType)")
                    return NSJSONSerialization.dataWithJSONObject(self._STParams!, options:NSJSONWritingOptions.allZeros, error: nil)!
                }
            }
            if String(contentType as! String) == "application/x-www-form-urlencoded"{
                if let params = self._STParams{
                    println("set Content-Type --- \(contentType)")
                    var _paramsString:String = ""
                    for(key,value) in self._STParams!{
                        _paramsString = _paramsString+(value as! String)
                    }
                    body.appendData(_paramsString.STNSData)
                    return body
                }
            }
        }
        println("set Content-Type --- empty")
        if let params = self._STParams{
            body.appendData(STNetworkRequest.buildParams(self._STParams!).STNSData)
            return body
        }else{
            return body
        }
    }
    
    private func setRequestFile()-> NSData{
        var header = self.allHTTPHeaderFields
        var body = NSMutableData()
        //multipart/form-data  上传所使用的Content-Type
        //image/jpg  upload task
        if let contentType:AnyObject = header!["Content-Type"]{
            println("set Content-Type --- \(contentType)")
        }else{
            println("set Content-Type --- empty")
        }
        for file in self.STFileParams!{
            if file.fileData == nil{
                body.appendData("--\(boundary)\r\n".STNSData)
                var _fileURL = NSURL(fileURLWithPath: file.fileURL!)!
                body.appendData("Content-Disposition: form-data; name=\"\(file.fileName)\"; filename=\"\(_fileURL.description.lastPathComponent)\"\r\n\r\n".STNSData)
                if let fileData = NSData(contentsOfFile: file.fileURL!){
                    body.appendData(fileData)
                    body.appendData("\r\n".STNSData)
                }
            }else{
                body.appendData(file.fileData!)
            }
        }
        body.appendData("--\(boundary)--\r\n".STNSData)
        return body
    }
}