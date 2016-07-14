//
//  CsvFile.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/15.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


final class CsvFile {
    
    class func checkAndMakeDir() -> String {
        
        // 保存ヂレクトリをDataに設定
        let dirName = "Data"

        // パスを取得
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsPath: AnyObject = paths[0]
        let dirPath = documentsPath as! String + "/" + dirName
        
        // ディレクトリ確認
        let fileManager = NSFileManager.defaultManager()
        let bTrue = fileManager.fileExistsAtPath(dirPath)
        if (!bTrue) {
            // なかったら、作成
            fileManager.createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        
        return dirPath
    }
    
    class func makeCsvFile() -> String {
        
        // ディレクトリ取得
        let dirPath = checkAndMakeDir()
        
        // 日付フォーマッター作成
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.timeStyle = .MediumStyle
        formatter.dateStyle = .MediumStyle
        
        // 現在の年月日を取得
        let date = NSDate()
        let dateStr0 = formatter.stringFromDate(date)
        // dateStrを分解
        let dateStr1 = dateStr0.componentsSeparatedByString(" ")     // 月日と時刻を分割
        let dateStrYMD = dateStr1[0].componentsSeparatedByString("/")
        let dateStrHMS = dateStr1[1].componentsSeparatedByString(":")
        let dateStr = dateStrYMD[0] + dateStrYMD[1] + dateStrYMD[2] + dateStrHMS[0] + dateStrHMS[1]
        
        // ファイル名作成
        let filePath = dirPath + "/" + "data_" + dateStr + ".csv"
        NSLog("新規作成CSVファイル名 == \(filePath)")
        
        // ファイル作成
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(filePath, contents: nil, attributes: nil)
        
        return filePath
    }
    
    class func write(filePath :String, data :String) {
        
        let fHandle = NSFileHandle(forWritingAtPath: filePath)
        
        if (fHandle == nil) {
            
            NSLog("CSVファイル［\(filePath)］が存在しません！！")
        } else {
            fHandle!.seekToEndOfFile()
            
            var nsData:NSData = data.dataUsingEncoding(NSUTF8StringEncoding)!
            fHandle!.writeData(nsData)
            
            fHandle!.closeFile()
        }
    }
    
    class func read(filePath :String) -> [Dictionary<String, String>] {
    
        let fHandle = NSFileHandle(forReadingAtPath: filePath)
        
        if (fHandle == nil) {

            NSLog("CSVファイル［\(filePath)］が存在しません！！")
            return []
        }
        
        let dataNSData = fHandle!.readDataToEndOfFile()
        fHandle!.closeFile()
        
        let dataNSString = NSString(data: dataNSData, encoding: NSUTF8StringEncoding)
        let data = dataNSString as! String
        
        let bodyDict = makeDictData(data, encode: "utf8")
        return bodyDict
    }
    

    // NSUTF8StringEncodingでエンコードすると、NSStringがnilになってしまう
    // そのため、NSShiftJISStringEncodingでエンコードするコードを追加
    class func read_shiftJis(filePath :String) -> [Dictionary<String, String>] {
        
        // NSShiftJISStringEncodingでエンコード
        let dataNSString = NSString(contentsOfFile: filePath, encoding: NSShiftJISStringEncoding, error: nil)!
        let data = dataNSString as! String
        
        let bodyDict = makeDictData(data, encode: "shiftJis")
        return bodyDict
    }
    
    // shiftJisで作成したものを、utf8に変換したからか、
    // 改行コードは"\r"
    class func read_mix(filePath :String) -> [Dictionary<String, String>] {
        
        let fHandle = NSFileHandle(forReadingAtPath: filePath)
        
        if (fHandle == nil) {
            
            NSLog("CSVファイル［\(filePath)］が存在しません！！")
            return []
        }
        
        let dataNSData = fHandle!.readDataToEndOfFile()
        fHandle!.closeFile()
        
        let dataNSString = NSString(data: dataNSData, encoding: NSUTF8StringEncoding)
        let data = dataNSString as! String
        
        let bodyDict = makeDictData(data, encode: "shiftJis")
        return bodyDict
    }
    
    class func makeDictData(data :String, encode :String) -> [Dictionary<String, String>] {
        
        var lines :[String]
        if (encode == "utf8") {
            lines = split(data){ $0 == "\n" }
        } else {
            // ShiftJis用
            lines = split(data){ $0 == "\r" }
        }
        
        // ヘッダーからキーを取得
        let header :String = lines.first!
        lines.removeAtIndex(0)
        let keys :[String] = split(header){ $0 == "," }
        
        
        // ボディ
        var body :[Dictionary<String, String>] = []
        for oneLine in lines {
            
            var cells :[String] = split(oneLine){ $0 == "," }

            var indx = 0
            var oneDict: [String: String] = Dictionary()
            for cell in cells {
                
                oneDict[keys[indx]] = cell
                indx++
            }
            
            body.append(oneDict)
        }
        
        return body
    }

    
    // makeDictDataで、"\r"での分割がうまくいかなかった場合用
    class func readToString(filePath :String) -> String {
        
        let fHandle = NSFileHandle(forReadingAtPath: filePath)
        
        if (fHandle == nil) {
            
            NSLog("CSVファイル［\(filePath)］が存在しません！！")
            return ""
        }
        
        let dataNSData = fHandle!.readDataToEndOfFile()
        fHandle!.closeFile()
        
        let dataNSString = NSString(data: dataNSData, encoding: NSUTF8StringEncoding)
        let data = dataNSString as! String
        
        return data
    }
    
}

