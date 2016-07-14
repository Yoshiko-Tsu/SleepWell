//
//  SelectSoundHeaderView.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/07.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// 音源設定画面のHeader設定
class SelectSoundHeaderView: UIView {

    @IBOutlet weak var minVol: UIImageView!
    @IBOutlet weak var maxVol: UIImageView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let minVolIcon = FAKIonIcons.iosVolumeLowIconWithSize(32)
    let maxVolIcon = FAKIonIcons.iosVolumeHighIconWithSize(32)

    
    func configure() {
        
        self.backgroundColor = UIColor.clearColor()
        
        minVolIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        maxVolIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        
        //let size = CGSizeMake(48, 48)
//        minVol.image! = minVolIcon.imageWithSize(CGSizeMake(32, 32))
//        maxVol.image! = maxVolIcon.imageWithSize(CGSizeMake(32, 32))
        
        let yellow = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1.0)
        volumeSlider.minimumTrackTintColor = yellow
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
