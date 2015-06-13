##STNetwork

> Tag 0.0.1

![](bike-233379_640.jpg)

![](https://img.shields.io/jenkins/s/https/jenkins.qa.ubuntu.com/precise-desktop-amd64_default.svg)
![](https://img.shields.io/github/license/mashape/apistatus.svg)
![](https://camo.githubusercontent.com/770175f6c01d89c84a020706126a9e6399ff76c4/68747470733a2f2f696d672e736869656c64732e696f2f636f636f61706f64732f702f4b696e676669736865722e7376673f7374796c653d666c6174)

STNetwork is an HTTP networking library written in Swift

##Requirements

* iOS 7.0+
* Xcode 6.3

##HTTP Method

	public enum HTTPMETHOD:String{
    	case DELETE = "DELETE"
    	case GET = "GET"
    	case HEAD = "HEAD"
    	case OPTIONS = "OPTIONS"
    	case PATCH = "PATCH"
    	case POST = "POST"
    	case PUT = "PUT"
	}

These values can be passed as the first argument of the STNetWork.request method:
	
	STNetwork.request(HTTPMETHOD.GET.rawValue, url:"http://lcepy.github.io")
	
	STNetwork.request(HTTPMETHOD.POST.rawValue, url:"http://lcepy.github.io")
	
##File Struct

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
	
##Params

GET Request With URL-Encoded Params

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
    
    //http://apis.baidu.com/apistore/aqiservice/aqi?city=%E5%8C%97%E4%BA%AC

POST Request With URL-Encoded Params

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
    
if your set Header Content-type equal "application/json",then STNetWork used NSJSONSerialization handler your params

##STNetworkResponse

Response with handler

* getAllResponseHeader 获取所有的头信息(get all response header)
* getResponseHeader 根据key返回一个header值 (return header value -single)
* getStatusCode 返回响应的状态码 (return status code )
* getAllStorageCookie 获取全局所有的cookie包括共享的cookie (get all storage cookies <Array> NSHTTPCookie)
* getAllResponseCookie 获取当前response的cookie（return header Set-Cookie）
* getResponseCookie 根据key返回一个cookie值 (return cookie value -single)

##STNetworkRequest

* setRequestHeader 设置header信息( set your request headers)
* setRequestCookie 设置cookie (set cookie header Set-Cookie)
* setRequestTimeout 设置超时时间 (set request time out)
* static buildParams 拼接URL字符串
* static queryComponents 查询字符串
* static escape 转义
* property STParams 不是文件数据的请用它的set方法
* property STFileParams 文件数据请用它的set方法

##Usage

* request
* upload
* download
* taskupload

使用例子

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

##License

STNetWork is released under the MIT license. See LICENSE for details.