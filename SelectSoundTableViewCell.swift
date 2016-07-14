//
//  SelectSoundTableViewCell.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/03.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// 音源設定画面のTableCell設定
class SelectSoundTableViewCell: UITableViewCell {

    @IBOutlet weak var audioButton: AudioButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var to_top_from_label: NSLayoutConstraint!
    @IBOutlet weak var to_label_from_bottom: NSLayoutConstraint!
    
    
    func configureCell(data: SoundInfo, selected :Bool, index :Int) {
        titleLabel.numberOfLines = 2
        titleLabel.text = data.soundTitle.stringByReplacingOccurrencesOfString("  ", withString: "\n  ", options: nil, range: nil)
        audioButton.tag = index
        
        if (selected == true) {
            let stopImage = UIImage(named: "Music_Stop")
            audioButton.setImage(stopImage, forState: .Normal)
        } else {
            let playImage = UIImage(named: "Music_Play")
            audioButton.setImage(playImage, forState: .Normal)
        }
        
    }
    
    
//    func calcHeight() -> CGFloat {
//        
//        titleLabel.sizeToFit()
//        let label_height = titleLabel.frame.height
//        
//        let height = label_height + to_top_from_label.constant + to_label_from_bottom.constant
//        
//        return height
//    }

}
