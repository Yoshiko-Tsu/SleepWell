//
//  DocumentDirectoryFile.swift
//  test_TableView
//
//  Created by 鶴田義子 on 2015/06/19.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


// データ永続化
//    /Documents
//    アプリがファイルを作成して保存できる領域
//    /Library/Caches
//    アプリが一時的に使用する領域
//    /tmp
//    一時ファイルの保存先に使用する領域
//

class DocumentDirectoryFile :NSObject {
    
    var filePath: AnyObject!
    
    
    init(name :String) {
        
        // Documentsを使用
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        // 名前をつける
        filePath = paths[0].stringByAppendingPathComponent(name) as AnyObject!
        NSLog("/Documents/file == \(filePath)")
    }
    
    
    //
    // 保存領域に保存
    func save(data :AnyObject) {
        
        var success: Bool
        success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath as! String)
        if success {
            NSLog("DocumentDirectoryFile::save success!!")
        }
    }
    
    func saveArray(arrayData :NSArray) {
        // saveArray(◯◯ as NSArray)でコール
        
        var success: Bool
        if (arrayData != []) {
            // NSKeyedArchiverクラスを使用
            success = NSKeyedArchiver.archiveRootObject(arrayData, toFile: filePath as! String)
            if success {
                NSLog("DocumentDirectoryFile::saveArray success!!")
            }
        }
    }

    
    //
    // 保存領域からデータを取得
    func load() -> AnyObject? {
        
        let data: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath as! String) as AnyObject?
        
        return data
    }
    
    func loadArray() -> NSArray {
        // loadArray() as! [◯◯]でコール
        
        let arrayData = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath as! String) as! NSArray?
        if ((arrayData) != nil) {

            NSLog("DocumentDirectoryFile::loadArray success!!")
            return arrayData!
            
        } else {
            return []
        }
        
    }
    
}