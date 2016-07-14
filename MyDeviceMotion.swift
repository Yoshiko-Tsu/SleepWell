//
//  MyDeviceMotion.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/12.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import CoreMotion


let MOTION_INTERVAL = 15.0          // motionの値を取得する時間間隔（sec）
//let MOTION_CHECK_LIMIT = 0.2        // 振動と判別するしきい値
//let MOTION_CHECK_TIME = 3 * 60.0    // 振動を判別する時間間隔（sec）
//let MOTION_CHECK_LIMIT = 0.1        // 振動と判別するしきい値
let MOTION_CHECK_LIMIT = 0.05       // 振動と判別するしきい値
let MOTION_CHECK_TIME = 2 * 60.0    // 振動を判別する時間間隔（sec）


struct structDeviceMotion {
    
    var gravity_x = 0.0 {
        didSet {
            if (gravity_x >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var gravity_y = 0.0 {
        didSet {
            if (gravity_y >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var gravity_z = 0.0 {
        didSet {
            if (gravity_z >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var userAcceleration_x = 0.0 {
        didSet {
            if (userAcceleration_x >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var userAcceleration_y = 0.0 {
        didSet {
            if (userAcceleration_y >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var userAcceleration_z = 0.0 {
        didSet {
            if (userAcceleration_z >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAccelerometer_x = 0.0 {
        didSet {
            if (deviceMotionAccelerometer_x >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAccelerometer_y = 0.0 {
        didSet {
            if (deviceMotionAccelerometer_y >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAccelerometer_z = 0.0 {
        didSet {
            if (deviceMotionAccelerometer_z >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionGyro_x = 0.0 {
        didSet {
            if (deviceMotionGyro_x >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionGyro_y = 0.0 {
        didSet {
            if (deviceMotionGyro_y >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionGyro_z = 0.0 {
        didSet {
            if (deviceMotionGyro_z >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAttitudeRoll = 0.0 {
        didSet {
            if (deviceMotionAttitudeRoll >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAttitudePitch = 0.0 {
        didSet {
            if (deviceMotionAttitudePitch >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionAttitudeYaw = 0.0 {
        didSet {
            if (deviceMotionAttitudeYaw >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    var deviceMotionMagnetometerAzimuth = 0.0 {
        didSet {
            if (deviceMotionMagnetometerAzimuth >= MOTION_CHECK_LIMIT) {
                maxFlg++
            }
        }
    }
    
    var maxFlg = 0
}



protocol MyDeviceMotionDelegate: class {
    
    func myDeviceMotionStop()
}


// 加速度センサー・ジャイロスコープ・磁力センサーのデータを統合して加工
class MyDeviceMotion {
    
    var manager: CMMotionManager!
    var myMotion: MyMotion!
    
    var nowData = structDeviceMotion()
    var oldData = structDeviceMotion()
    var diffAbsData = structDeviceMotion()

    var maxNum = 0
    var timerNum = 0
    var initFlg = true

    var MyDeviceMotion_delegate :MyDeviceMotionDelegate?

    
    init (mymanager :CMMotionManager, mymotion :MyMotion) {
        
        manager = mymanager
        myMotion = mymotion
        
        manager.deviceMotionUpdateInterval = myMotion.intervalSec
    }
    
    
    func startDeviceMotion() {
        
        if (manager.deviceMotionAvailable) {
            
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(),
                withHandler: {(motion:CMDeviceMotion!, error:NSError!) -> Void in
                    
                    let now = NSDate()
                    self.nowData.gravity_x = motion.gravity.x
                    self.nowData.gravity_y = motion.gravity.y
                    self.nowData.gravity_z = motion.gravity.z
                    self.nowData.userAcceleration_x = motion.userAcceleration.x
                    self.nowData.userAcceleration_y = motion.userAcceleration.y
                    self.nowData.userAcceleration_z = motion.userAcceleration.z
                    self.nowData.deviceMotionAccelerometer_x = self.nowData.gravity_x + self.nowData.userAcceleration_x
                    self.nowData.deviceMotionAccelerometer_y = self.nowData.gravity_y + self.nowData.userAcceleration_y
                    self.nowData.deviceMotionAccelerometer_z = self.nowData.gravity_z + self.nowData.userAcceleration_z
                    self.nowData.deviceMotionGyro_x = motion.rotationRate.x
                    self.nowData.deviceMotionGyro_y = motion.rotationRate.y
                    self.nowData.deviceMotionGyro_z = motion.rotationRate.z
                    self.nowData.deviceMotionAttitudeRoll = motion.attitude.roll
                    self.nowData.deviceMotionAttitudePitch = motion.attitude.pitch
                    self.nowData.deviceMotionAttitudeYaw = motion.attitude.yaw
                    
                    self.myMotion.strDeviceMotion = self.getDataString()

                    
                    // 差分データ取得
                    self.diffAbsData.maxFlg = 0
                    self.getDiffAbs()
                    self.myMotion.strDeviceMotionAbs = self.getdiffAbsDataString()
                    self.oldData = self.nowData

                    
                    // 差分データチェック
                    // MOTION_CHECK_LIMIT値より大きいデータがあるか？
                    if (self.diffAbsData.maxFlg > 0) {
                        
                        if (!self.initFlg) {
                            self.maxNum++
                            self.timerNum++
                        } else {
                            self.initFlg = false
                        }
                        
                    }
                    if (self.timerNum > 0) {
                        
                        // タイマーの代わり
                        self.timerNum++

                        // 設定時間内計測
                        if (self.timerNum > Int(MOTION_CHECK_TIME / MOTION_INTERVAL)) {
                        
                            // 設定時間内で半分以上、振動を感知したか？
//                            if (self.maxNum > Int(MOTION_CHECK_TIME / MOTION_INTERVAL) / 2) {
                            if (self.maxNum > Int(MOTION_CHECK_TIME / MOTION_INTERVAL) / 4) {

                                // 終了
                                self.stopDeviceMotion()
                                
                            } else {
                                
                                // もう１度、計測
                                self.maxNum = 0
                                self.timerNum = 0
                            }
                        }
                    }
                    
                    
                    self.myMotion.saveDeviceMotionData()
            })
        }
    }
    
    
    func stopDeviceMotion() {

        if (manager.deviceMotionActive) {
            manager.stopDeviceMotionUpdates()
        }

        MyDeviceMotion_delegate?.myDeviceMotionStop()
    }
    
    
    func getDiffAbs() {
        
        diffAbsData.gravity_x = abs(nowData.gravity_x - oldData.gravity_x)
        diffAbsData.gravity_y = abs(nowData.gravity_y - oldData.gravity_y)
        diffAbsData.gravity_z = abs(nowData.gravity_z - oldData.gravity_z)
        diffAbsData.userAcceleration_x = abs(nowData.userAcceleration_x - oldData.userAcceleration_x)
        diffAbsData.userAcceleration_y = abs(nowData.userAcceleration_y - oldData.userAcceleration_y)
        diffAbsData.userAcceleration_z = abs(nowData.userAcceleration_z - oldData.userAcceleration_z)
        diffAbsData.deviceMotionAccelerometer_x = abs(nowData.deviceMotionAccelerometer_x - oldData.deviceMotionAccelerometer_x)
        diffAbsData.deviceMotionAccelerometer_y = abs(nowData.deviceMotionAccelerometer_y - oldData.deviceMotionAccelerometer_y)
        diffAbsData.deviceMotionAccelerometer_z = abs(nowData.deviceMotionAccelerometer_z - oldData.deviceMotionAccelerometer_z)
        diffAbsData.deviceMotionGyro_x = abs(nowData.deviceMotionGyro_x - oldData.deviceMotionGyro_x)
        diffAbsData.deviceMotionGyro_y = abs(nowData.deviceMotionGyro_y - oldData.deviceMotionGyro_y)
        diffAbsData.deviceMotionGyro_z = abs(nowData.deviceMotionGyro_z - oldData.deviceMotionGyro_z)
        diffAbsData.deviceMotionAttitudeRoll = abs(nowData.deviceMotionAttitudeRoll - oldData.deviceMotionAttitudeRoll)
        diffAbsData.deviceMotionAttitudePitch = abs(nowData.deviceMotionAttitudePitch - oldData.deviceMotionAttitudePitch)
        diffAbsData.deviceMotionAttitudeYaw = abs(nowData.deviceMotionAttitudeYaw - oldData.deviceMotionAttitudeYaw)
        diffAbsData.deviceMotionMagnetometerAzimuth = abs(nowData.deviceMotionMagnetometerAzimuth - oldData.deviceMotionMagnetometerAzimuth)
    }
    
    
    func getDataString() -> String {
        
        let str2 = "\(nowData.userAcceleration_x)" + "," + "\(nowData.userAcceleration_y)" + "," + "\(nowData.userAcceleration_z)"
        let str3 = "\(nowData.deviceMotionAccelerometer_x)" + "," + "\(nowData.deviceMotionAccelerometer_y)" + "," + "\(nowData.deviceMotionAccelerometer_z)"
        let str6 = "\(nowData.deviceMotionAttitudeRoll)" + "," + "\(nowData.deviceMotionAttitudePitch)" + "," + "\(nowData.deviceMotionAttitudeYaw)"

        let valueStr = str2 + "," + str3 + "," + str6
        
        return valueStr
    }
    func getdiffAbsDataString() -> String {
        
        let str2 = "\(diffAbsData.userAcceleration_x)" + "," + "\(diffAbsData.userAcceleration_y)" + "," + "\(diffAbsData.userAcceleration_z)"
        let str3 = "\(diffAbsData.deviceMotionAccelerometer_x)" + "," + "\(diffAbsData.deviceMotionAccelerometer_y)" + "," + "\(diffAbsData.deviceMotionAccelerometer_z)"
        let str6 = "\(diffAbsData.deviceMotionAttitudeRoll)" + "," + "\(diffAbsData.deviceMotionAttitudePitch)" + "," + "\(diffAbsData.deviceMotionAttitudeYaw)"
        
        let valueStr = str2 + "," + str3 + "," + str6 + "," + "\(diffAbsData.maxFlg)" + "," + "\(maxNum)"
        
        return valueStr
    }
    func getHeadderString() -> String {
        
        let str2 = "userAcceleration_x" + "," + "userAcceleration_y" + "," + "userAcceleration_z"
        let str3 = "deviceMotionAccelerometer_x" + "," + "deviceMotionAccelerometer_y" + "," + "deviceMotionAccelerometer_z"
        let str6 = "deviceMotionAttitudeRoll" + "," + "deviceMotionAttitudePitch" + "," + "deviceMotionAttitudeYaw"
        
        let valueStr = str2 + "," + str3 + "," + str6

        return valueStr
    }
    func getDiffAbsHeadderString() -> String {
        
        let str2 = "ABS userAcceleration_x" + "," + "ABS userAcceleration_y" + "," + "ABS userAcceleration_z"
        let str3 = "ABS deviceMotionAccelerometer_x" + "," + "ABS deviceMotionAccelerometer_y" + "," + "ABS deviceMotionAccelerometer_z"
        let str6 = "ABS deviceMotionAttitudeRoll" + "," + "ABS deviceMotionAttitudePitch" + "," + "ABS deviceMotionAttitudeYaw"
        
        let valueStr = str2 + "," + str3 + "," + str6 + "," + "MaxFlg" + "," + "MaxNum"
        
        return valueStr
    }
}


