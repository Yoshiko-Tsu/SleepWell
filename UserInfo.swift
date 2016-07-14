//
//  UserInfo.swift
//  
//
//  Created by 鶴田義子 on 2014/10/30.
//  Copyright (c) 2014年 鶴田義子. All rights reserved.
//

class UserInfo: NSObject {
    
    class func getBundleVersion() {
        let versionName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
//        let buildName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String
//        let bundleVersion = versionName + "." + buildName
//        minikuraLocalStorage.saveBundleVersion(bundleVersion)
        UserInfoLocalStorage.saveBundleVersion(versionName)
    }
    
    class func getIosVersion() {
        // ios8のみ
//        let os = NSProcessInfo().operatingSystemVersion
//        switch (os.majorVersion, os.minorVersion, os.patchVersion) {
//        case (8, 0, _):
//            iosVersion = 8.0
//        case (8, _, _):
//            iosVersion = 8.1
//        case (7, 0, _):
//            iosVersion = 7.0
//        case (7, _, _):
//            iosVersion = 7.1
//        default:
//            iosVersion = 6.0
//        }
        let iosVersion = UIDevice.currentDevice().systemVersion
        UserInfoLocalStorage.saveIosVersion(iosVersion)
    }

    
    class func getIosDevice() {
        var iOSDevice: String!

//        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
//        let myBoundSizeStr: NSString = "Bounds width: \(myBoundSize.width) height: \(myBoundSize.height)"
//        NSLog("\(myBoundSizeStr)")
//        
//        let myAppFrameSize: CGSize = UIScreen.mainScreen().applicationFrame.size
//        let myAppFrameSizeStr: NSString = "applicationFrame width: \(myAppFrameSize.width) NativeBoundheight: \(myAppFrameSize.height)"
//        NSLog("\(myAppFrameSizeStr)")
//
//        let myNativeBoundSize: CGSize = UIScreen.mainScreen().nativeBounds.size
//        let myNativeBoundSizeStr: NSString = "NativeBounds width: \(myNativeBoundSize.width) NativeBoundheight: \(myNativeBoundSize.height)"
//        NSLog("\(myNativeBoundSizeStr)")
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if 1.0 < UIScreen.mainScreen().scale {
                let size = UIScreen.mainScreen().bounds.size
                let scale = UIScreen.mainScreen().scale
                let result = CGSizeMake(size.width * scale, size.height * scale)
                switch result.height {
                case 960:
                    iOSDevice = "iPhone4/4S"
                case 1136:
                    iOSDevice = "iPhone5/5s/5c"
                case 1334:
                    iOSDevice = "iPhone6"
                case 2208:
                    iOSDevice = "iPhone6 Plus"
                default:
                    iOSDevice = "iPhone unknown"
                }
            } else {
                iOSDevice = "iPhone3"
            }
        } else {
            if 1.0 < UIScreen.mainScreen().scale {
                iOSDevice = "iPad Retina"
            } else {
                iOSDevice = "iPad"
            }
        }
        UserInfoLocalStorage.saveIosDevice(iOSDevice)
    }

    
    class func getUserAgent() -> String!{
        let webView:UIWebView = UIWebView()
        webView.frame = CGRectZero
        let userAgent:String! = webView.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        NSLog("userAgent == \(userAgent)")
        
        return userAgent
    }
    
    class func setUserAgent() {
        let userAgent = getUserAgent()
        let dic:NSDictionary = ["UserAgent":userAgent]
        NSUserDefaults.standardUserDefaults().registerDefaults(dic as [NSObject : AnyObject])
        
    }

    
    class func is_iPhone() -> Bool {
        if ((UserInfoLocalStorage.loadIosDevice()?.hasPrefix("iPhone")) == true) {
                return true
        }
        return false
    }
    
    class func is_iPhone5() -> Bool {
        if (UserInfoLocalStorage.loadIosDevice()?.hasPrefix("iPhone5") == true) {
            return true
        }
        return false
    }
    
    class func is_iPhone6() -> Bool {
        if (UserInfoLocalStorage.loadIosDevice() == "iPhone6") {
            return true
        }
        return false
    }
    
    class func is_iPhone6Plus() -> Bool {
        if (UserInfoLocalStorage.loadIosDevice() == "iPhone6 Plus") {
            return true
        }
        return false
    }
    
    class func is_iPad() -> Bool {
        if ((UserInfoLocalStorage.loadIosDevice()?.hasPrefix("iPad")) == true) {
            return true
        }
        return false
    }
    
    class func is_iPhone7() -> Bool {
        if (UserInfoLocalStorage.loadIosVersion() >= "7.0" &&
            UserInfoLocalStorage.loadIosVersion() < "8.0") {
                return true
        }
        return false
    }
    
    class func is_iPhone8() -> Bool {
        if (UserInfoLocalStorage.loadIosVersion() >= "8.0") {
                return true
        }
        return false
    }
    
}