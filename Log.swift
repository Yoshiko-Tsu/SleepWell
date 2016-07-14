//
//  Log.swift
//  minikura_ios
//
//  Created by 鶴田義子 on 2015/02/02.
//  Copyright (c) 2015年 鶴田義子. All rights reserved.
//

import Foundation


//#if DEBUG
//    func LOG(msg: Any) {
//        println("[\(__FILE__) : \(__FUNCTION__) : \(__LINE__)] \(msg)")
//    }
//#else
//    func LOG(msg: Any) {
//    }
//#endif


final class Log {
        
    class func checkAndDeleteLog() {
        // 保存期間を１日に設定
        let intervalTime = 1.0
        // 保存ヂレクトリをLogに設定
        let logDirName = "Log"
        
        // 日付フォーマッター作成
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.timeStyle = .MediumStyle
        formatter.dateStyle = .MediumStyle
        
        // パスを取得
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsPath: AnyObject = paths[0]
        let logDirPath = documentsPath as! String + "/" + logDirName
        
        // ディレクトリ確認
        let fileManager = NSFileManager.defaultManager()
        let bTrue = fileManager.fileExistsAtPath(logDirPath)
        if (!bTrue) {
            fileManager.createDirectoryAtPath(logDirPath, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        // 現在の年月日を取得
        let date = NSDate()
        
        let interval: NSTimeInterval = 60.0 * 60.0 * 24.0 * intervalTime * -1.0
        let deleteDate = date.dateByAddingTimeInterval(interval)
        let deleteDateStr = formatter.stringFromDate(deleteDate)
        NSLog("ログファイル保存期日　ーーー　\(deleteDateStr)")
        
        let logFiles: [AnyObject]? = fileManager.contentsOfDirectoryAtPath(logDirPath, error: nil)
        
        for oneFile in logFiles! {
            let oneFileStr = oneFile as! NSString
            let oneFilePath = logDirPath.stringByAppendingPathComponent(oneFileStr as String)
            let fileAttr: NSDictionary = fileManager.attributesOfItemAtPath(oneFilePath, error: nil)!
            let fileDate = fileAttr.fileCreationDate()
            let fileDateStr = formatter.stringFromDate(fileDate!)
            NSLog("ログファイル名 == \(oneFile)\t 作成時間 == \(fileDateStr)")
            
            if (fileDateStr < deleteDateStr) {
                // 削除
                NSLog("ーーー　削除")
                fileManager.removeItemAtPath(oneFilePath, error: nil)
            } else {
                NSLog("ーーー　保存")
            }
        }
    }
    
    class func setFile() {
        // 保存ヂレクトリをLogに設定
        let logDirName = "Log"
        
        // 日付フォーマッター作成
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.timeStyle = .MediumStyle
        formatter.dateStyle = .MediumStyle
        
        // パスを取得
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsPath: AnyObject = paths[0]
        let logDirPath = documentsPath as! String + "/" + logDirName
        
        // 現在の年月日を取得
        let date = NSDate()
        let dateStr0 = formatter.stringFromDate(date)
        // dateStrを分解
        let dateStr1 = dateStr0.componentsSeparatedByString(" ")     // 月日と時刻を分割
        let dateStrYMD = dateStr1[0].componentsSeparatedByString("/")
        let dateStrHMS = dateStr1[1].componentsSeparatedByString(":")
        let dateStr = dateStrYMD[0] + dateStrYMD[1] + dateStrYMD[2] + dateStrHMS[0] + dateStrHMS[1]
        
        // Logファイル名
        let logFilePath = logDirPath + "/" + "log_" + dateStr + ".txt"
        NSLog("新規作成ログファイル名 == \(logFilePath)")
        freopen(logFilePath, "a+", stderr)

    }
}