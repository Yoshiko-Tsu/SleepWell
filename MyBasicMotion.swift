//
//  MyBasicMotion.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/12.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import CoreMotion


class MyBasicMotion {
    
    // MotionManagerを生成
    // staticとしてインタンス作成
    class var sharedInstance :CMMotionManager {
        struct Static{
            static let instance :CMMotionManager = CMMotionManager()
        }
        return Static.instance
    }
    
    private init() {
    }
    
    
}


