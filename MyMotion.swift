//
//  MyMotion.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/12.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import CoreMotion


class MyMotion {

    let dateFormatter = NSDateFormatter()
    var counter = 0
    
    var csvFileName = ""
    var headDeviceMotion = ""
    var strDeviceMotion = ""
    var strDeviceMotionAbs = ""

    
    // センサーの更新間隔（秒単位）
    var intervalSec :Double!

    
    class var sharedInstance :MyMotion {
        struct Static{
            static let instance :MyMotion = MyMotion()
        }
        return Static.instance
    }
    
    private init() {
        
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
    }
    
    func setIntervalTime(interval :Double) {
        
        intervalSec = interval
    }
    
    func initMyMotion() {
        
        strDeviceMotion = ""
        strDeviceMotionAbs = ""
    }
    
    
    func initCsvFile() {
        
        // ヘッダー作成
        let header = "id" + "," + "time" + "," + headDeviceMotion + "\n"
        
        // csvファイル名決定
        csvFileName = CsvFile.makeCsvFile()
        
        
        // 書き込み
        CsvFile.write(csvFileName, data: header)
    }
    
    func saveDeviceMotionData() {
        
        let now = NSDate()
        var valStr = "\(counter)" + "," + self.dateFormatter.stringFromDate(now) + "," + strDeviceMotion + "," + strDeviceMotionAbs
        valStr += "\n"
        NSLog("Save data == " + valStr)
        
        // 書き込み
        CsvFile.write(csvFileName, data: valStr)
        
        counter++
        initMyMotion()
    }
    
}
