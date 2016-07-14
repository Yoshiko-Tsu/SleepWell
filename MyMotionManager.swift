//
//  MyMotionManager.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/12.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import CoreMotion


class MyMotionManager {
    
    var manager: CMMotionManager!
    var myMotion: MyMotion!
    
    var deviceMotion: MyDeviceMotion
    
    
    init(interval :Double) {
        
        manager = CMMotionManager()
        myMotion = MyMotion.sharedInstance
        myMotion.setIntervalTime(interval)

        deviceMotion = MyDeviceMotion(mymanager: manager, mymotion: myMotion)
        
        // csvファイルヘッダ作成
        let str1 = deviceMotion.getHeadderString()
        let str2 = deviceMotion.getDiffAbsHeadderString()
        myMotion.headDeviceMotion = str1 + "," + str2
        
        myMotion.initCsvFile()

    }
    
    func startMotion() {
        
        deviceMotion.startDeviceMotion()
    }
    
    func stopMotion() {
        
        deviceMotion.stopDeviceMotion()
    }
    
}


