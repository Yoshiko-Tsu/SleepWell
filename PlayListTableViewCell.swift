//
//  PlayListTableViewCell.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/02.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// プレイリスト画面のTableCell設定
class PlayListTableViewCell: SBGestureTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    
    func configureCell(data :PlayList, selected :Bool, index :Int) {

        self.titleLabel.text = data.name
        
        selectButton.tag = index
        if (selected == true) {
            let selectedImage = UIImage(named: "Playlist_Selected")
            selectButton.setImage(selectedImage, forState: .Normal)
        }
        
        backgroundColor = UIColor.clearColor()
    }

}
