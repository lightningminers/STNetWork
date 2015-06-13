//
//  STNetWorkResponse.swift
//  STNetWork
//
//  Created by xiangwenwen on 15/6/12.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit

class STNetWorkResponse: NSObject {
    var httpResponse:NSHTTPURLResponse?
    var response:NSURLResponse?
    var responseHeader:Dictionary<NSObject,AnyObject>?
    var responseCookie:Dictionary<NSObject,AnyObject>!
    init(response:NSURLResponse?) {
        self.httpResponse = response as? NSHTTPURLResponse
        self.response = response
        self.responseHeader = self.httpResponse?.allHeaderFields
        super.init()
        self.responseCookie = self.getAllResponseCookie()
    }
    
    /**
    获取 response所有的头信息
    
    :returns: <#return value description#>
    */
    func getAllResponseHeader()-> Dictionary<NSObject,AnyObject>?{
        if let responseHeader = self.responseHeader{
            return responseHeader
        }
        return nil
    }
    
    /**
    获取 response的响应状态
    
    :returns: <#return value description#>
    */
    func getStatusCode()->Int?{
        return self.httpResponse?.statusCode
    }
    
    /**
    根据key返回一个header值
    
    :param: headerKey <#headerKey description#>
    
    :returns: <#return value description#>
    */
    func getResponseHeader(headerKey:NSObject?)->AnyObject?{
        if let key = headerKey{
            return self.responseHeader![headerKey!]
        }
        return nil
    }
    
    /**
    获取所有的 cookie （注意，这个方法获取的是全局的）
    
    :returns: <#return value description#>
    */
    func getAllStorageCookie()->Array<AnyObject>?{
        var cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let cookies:Array<AnyObject> = cookieStorage.cookies{
            return cookies
        }
        return nil
    }
    
    /**
    获取当前 response 的所有cookie
    
    :returns: <#return value description#>
    */
    func getAllResponseCookie()->Dictionary<NSObject,AnyObject>?{
        self.responseCookie = [:]
        if let cookiesString: NSString = self.responseHeader!["Set-Cookie" as NSObject] as? NSString{
            var cookiesArray:Array<AnyObject> = cookiesString.componentsSeparatedByString(";")
            for cookiesOne in cookiesArray{
                if let _cookiesOne = cookiesOne as? NSString{
                    var _cookiesArray:Array<AnyObject> = _cookiesOne.componentsSeparatedByString(",")
                    for _cookiesString in _cookiesArray{
                        if var _value = _cookiesString as? NSString{
                            _value = _value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            var cookie:Array<AnyObject> = _value.componentsSeparatedByString("=")
                            var cookieKey:String = String(cookie[0] as! String)
                            self.responseCookie[cookieKey as NSObject] = cookie[1]
                        }
                    }
                }else{
                    if var value = cookiesOne as? NSString{
                        value = value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        var cookie:Array<AnyObject> = value.componentsSeparatedByString("=")
                        var cookieKey:String = String(cookie[0] as! String)
                        self.responseCookie[cookieKey as NSObject] = cookie[1]
                    }
                }
            }
            return self.responseCookie
        }
        return nil
    }
    
    /**
    根据key返回一个cookie值
    
    :param: cookieKey <#cookieKey description#>
    
    :returns: <#return value description#>
    */
    func getResponseCookie(cookieKey:NSObject?)->AnyObject?{
        if let key:NSObject = cookieKey{
            if let value:AnyObject = self.responseCookie?[key]{
                return value
            }
            return nil
        }
        return nil
    }
}