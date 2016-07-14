//
//  LocalStorage.swift
//  
//
//  Created by Hiroyuki Kato on 9/18/14.
//  Copyright (c) 2014 Hiroyuki Kato. All rights reserved.
//

import Foundation


class LocalStorage {

    /**
     * データを保存する
     *
     * @param object 保存するデータ
     * @param key 取得したいデータに対応するkey
     */
    class func setValue(objejct: AnyObject?, key: String) {
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        
        nsUserDefault.setObject(objejct, forKey: key)
        nsUserDefault.synchronize()
    }

    /**
     * データを取得する
     *
     * @param key 取得したいデータに対応するkey
     */
    class func getValue(key: String) -> AnyObject? {
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        
        return nsUserDefault.valueForKey(key)
    }
    
    /**
     * データを削除する
     *
     * @param key 削除するデータに対応するkey
     */
    class func removeValue(key: String) {
        let nsUserDefault = NSUserDefaults.standardUserDefaults()
        
        nsUserDefault.removeObjectForKey(key)
    }
}