//
//  PlayList.swift
//  test_TableView
//
//  Created by 鶴田義子 on 2015/06/19.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


class PlayList : NSObject, NSCoding {

    var id :Int
    var name :String?
    var playTime :Int
    var playVolume :Int
    var soundList :[SoundInfo]
    
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        self.playTime = aDecoder.decodeObjectForKey("playTime") as! Int
        self.playVolume = aDecoder.decodeObjectForKey("playVolume") as! Int
        self.soundList = aDecoder.decodeObjectForKey("playList") as! [SoundInfo]
        self.name = aDecoder.decodeObjectForKey("name") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.playTime, forKey: "playTime")
        aCoder.encodeObject(self.playVolume, forKey: "playVolume")
        aCoder.encodeObject(self.soundList, forKey: "playList")
        aCoder.encodeObject(self.name, forKey: "name")
    }
    
    override init() {

        id = 0;
        name = ""
        playTime = 0
        playVolume = 0
        soundList = []
        
        super.init()
    }
    
    
    func makeNew(num :Int) {
        
        id = num
//        name = "プレイリスト" + String(id)
        name = "プレイリスト"
    }
    
    
    func findSound(check :SoundInfo) -> Bool {
        
        for one in soundList {
            if (one.type == check.type && one.id == check.id) {
                return true
            }
        }
        return false
    }
    
    func getIndexNo(check :SoundInfo) -> Int {
        
        for (i, one) in enumerate(soundList) {
            if (one.type == check.type && one.id == check.id) {
                return i
            }
        }
        return -1
    }
    
}