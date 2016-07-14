//
//  AudioButton.swift
//  test_TableView2
//
//  Created by 鶴田義子 on 2015/06/30.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// 音をならすボタン
class AudioButton: UIButton {

    let playImage = UIImage(named: "Music_Play")
    let stopImage = UIImage(named: "Music_Stop")
    

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    func playNow() {
        
        self.setImage(stopImage, forState: .Normal)
    }
    
    func stopNow() {
        
        self.setImage(playImage, forState: .Normal)
    }
    
}
