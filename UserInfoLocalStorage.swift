//
//  UserInfoLocalStorage.swift
//  
//
//  Created by 鶴田義子 on 2014/10/30.
//  Copyright (c) 2014年 鶴田義子. All rights reserved.
//

class UserInfoLocalStorage {
    
    /**
     * ローカルストレージに保存する
     */
    class func saveBundleVersion(str: String) {
        LocalStorage.setValue(str, key: "APP_VERSION")
    }
    class func saveIosDevice(str: String) {
        LocalStorage.setValue(str, key: "USER_IOS_DEVICE")
    }
    class func saveIosVersion(num: String) {
        LocalStorage.setValue(num, key: "USER_IOS_VERSION")
    }
    
    /**
     * ローカルストレージから取得する
     */
    class func loadBundleVersion() -> String? {
        return LocalStorage.getValue("APP_VERSION") as! String?
    }
    class func loadIosDevice() -> String? {
        return LocalStorage.getValue("USER_IOS_DEVICE")as! String?
    }
    class func loadIosVersion() -> String? {
        return LocalStorage.getValue("USER_IOS_VERSION")as! String?
    }

        
    /**
     * ローカルストレージから削除する
     */
    class func clearBundleVersion() {
        LocalStorage.removeValue("APP_VERSION")
    }
    class func clearIosDevice() {
        LocalStorage.removeValue("USER_IOS_DEVICE")
    }
    class func clearIosVersion() {
        LocalStorage.removeValue("USER_IOS_DEVICE")
    }
    
}