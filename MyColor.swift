//
//  MyColor.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/09.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit

// よく使う色定義
//let navigation_back_red = MyColor.UIColorFromRGB(0xdd2f30)

class MyColor {

    // 16進表記のカラーコードでUIColorを指定
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}



