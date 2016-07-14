//
//  MyLocalStorage.swift
//  test_TableView
//
//  Created by 鶴田義子 on 2015/06/19.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation

class MyLocalStorage {
    
    /**
    * ローカルストレージに保存する
    */
    class func saveBundleVersion(str: String) {
        LocalStorage.setValue(str, key: "VERSION")
    }
    class func saveIosDevice(str: String) {
        LocalStorage.setValue(str, key: "IOS_DEVICE")
    }
    class func saveIosVersion(num: String) {
        LocalStorage.setValue(num, key: "IOS_VERSION")
    }
    
    /**
    * ローカルストレージから取得する
    */
    class func loadBundleVersion() -> String? {
        return LocalStorage.getValue("VERSION") as! String?
    }
    class func loadIosDevice() -> String? {
        return LocalStorage.getValue("IOS_DEVICE")as! String?
    }
    class func loadIosVersion() -> String? {
        return LocalStorage.getValue("IOS_VERSION")as! String?
    }
    
    /**
    * ローカルストレージから削除する
    */
    class func clearBundleVersion() {
        LocalStorage.removeValue("VERSION")
    }
    class func clearIosDevice() {
        LocalStorage.removeValue("IOS_DEVICE")
    }
    class func clearIosVersion() {
        LocalStorage.removeValue("IOS_VERSION")
    }
    
}