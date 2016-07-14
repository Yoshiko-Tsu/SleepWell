//
//  EditPlayListTableViewCell.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/03.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// プレイリスト編集画面のTableCell設定
class EditPlayListTableViewCell: SBGestureTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    
    func configureCell(data: SoundInfo) {
        
        titleLabel.text = data.soundTitle
        
        backgroundColor = UIColor.clearColor()
        
    }
    
}
