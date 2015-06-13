//
//  ViewController.swift
//  Stan
//
//  Created by xiangwenwen on 15/5/30.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

import UIKit


class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //普通的GET 请求
    
    @IBAction func sendGetHttp(sender: UIButton) {
        var url:String = "http://lcepy.github.io";
        STNetwork.request(HTTPMETHOD.GET.rawValue, url: url, success: { (dataString, data, response) -> Void in
            println(dataString)
        }) { (error) -> Void in
            println(error)
        }
        
    }
    
    //带参数的GET 请求
    
    @IBAction func sendGetParamsHttp(sender: UIButton) {
        var url:String = "http://apis.baidu.com/apistore/aqiservice/aqi"
        var citys:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        citys["city"] = "北京"
        var header:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        header["apikey"] = "bce358f5243e78bad9ebd6da21f742d1"
        STNetwork.request(HTTPMETHOD.GET.rawValue, url: url, params: citys, header: header, success: { (dataString, data, response) -> Void in
            println(dataString)
        }) { (error) -> Void in
            println(error)
        }
    }
    
    //POST请求  带参数
    
    @IBAction func sendPostParamsHttp(sender: UIButton) {
        var url = "http://apis.baidu.com/apistore/idlocr/ocr"
        var httpArg = "fromdevice=pc&clientip=10.10.10.0&detecttype=LocateRecognize&languagetype=CHN_ENG&imagetype=1&image=/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABMNDxEPDBMREBEWFRMXHTAfHRsbHTsqLSMwRj5KSUU+RENNV29eTVJpU0NEYYRiaXN3fX59S12Jkoh5kW96fXj/2wBDARUWFh0ZHTkfHzl4UERQeHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHj/wAARCAAfACEDAREAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAAQDBQb/xAAjEAACAgICAgEFAAAAAAAAAAABAgADBBESIRMxBSIyQXGB/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/APawEBAQEBAgy8i8ZTVV3UY6V1eU2XoWDDZB19S646Gz39w9fkKsW1r8Wm2yo1PYis1be0JG9H9QNYCAgc35Cl3yuVuJZl0cB41rZQa32dt2y6OuOiOxo61vsLcVblxaVyXD3hFFjL6La7I/sDWAgICAgICB/9k="
        var header:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        header["Content-Type"] = "application/x-www-form-urlencoded"
        header["apikey"] = "bce358f5243e78bad9ebd6da21f742d1"
        STNetwork.request(HTTPMETHOD.POST.rawValue, url: url, params: ["urlencoded":httpArg], header: header, success: { (dataString, data, response) -> Void in
            println(dataString)
        }) { (error) -> Void in
            println(error)
        }
    }
    
    //普通POST请求
    
    @IBAction func sendPOSTHttp(sender: UIButton) {
        var url = "http://apis.baidu.com/apistore/idlocr/ocr"
        var header:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        header["Content-Type"] = "application/x-www-form-urlencoded"
        header["apikey"] = "bce358f5243e78bad9ebd6da21f742d1"
        STNetwork.request(HTTPMETHOD.POST.rawValue, url: url, success: { (dataString, data, response) -> Void in
            println(dataString)
        }) { (error) -> Void in
            println(error)
        }
        
    }

    //上传文件
    
    @IBAction func sendUPLOADFILEHttp(sender: UIButton) {
        let url:String = "http://pitayaswift.sinaapp.com/pitaya.php"
        //模拟表单提交
        let fileType:STFType = STFType(name: "mage-gnome01-large", type: "jpg")
        STNetwork.upload(url, type: fileType, success: { (data, response) -> Void in
            println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil))
        }) { (error) -> Void in
                println(error)
        }
    }
    
    //下载文件
    
    @IBAction func sendDownloadFile(sender: UIButton) {
        var url:String = "http://content.battlenet.com.cn/wow/media/screenshots/screenshot-of-the-day/warlords-of-draenor/warlords-of-draenor-ss0420-large.jpg"
        STNetwork.download(url, success: { (url, response) -> Void in
            
        }) { (error) -> Void in
            
        }
    }
}

