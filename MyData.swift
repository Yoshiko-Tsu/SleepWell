//
//  MyData.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/03.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


enum AppTimerType: Int
{
    case NONE = 0
    case SLEEP = 1      // おやすみタイマー
    case WAKEUP = 2      // 目覚ましタイマー
    case BOTH = 3       // SLEEP & ALARM
}

enum SelectSoundType: Int
{
    case NONE = 0
    case PLAYLIST = 1
    case ONE_SOUND = 2
}

enum SleepTimeIntervalType: Int
{
    case NONE = 0
    case MIN15 = 15
    case MIN30 = 30
    case MIN45 = 45
    case MIN60 = 60
    case MIN75 = 75
    case MIN90 = 90
}


// 振動探知時間（めざまし時間より、MOTION_START_INTERVAL前から起動する）（min）
let MOTION_START_INTERVAL = 30

let MAX_PLAYLIST_NUM = 5        // プレリストの数
let MAX_SOUNDS_NUM = 10         // 1プレイリストの楽曲数


class MyData : NSObject, NSCoding {
    
    var timerType :AppTimerType
    
    // Sleep
    var isSleeper :Bool!
    var sleepSound_type :SelectSoundType
    var playLists :[PlayList]!
    var sleep_sound :PlayList!                         // サウンド用
    var sleep_selectedIndex :Int!                      // 選択済みPlayList
    var sleep_volume :Float!
    var sleep_timeInterval :SleepTimeIntervalType      // 15分　30分　45分　60分　75分　90分
    
    // Wakeup
    var isWakeup :Bool!
    var wakeup_hour :Int!
    var wakeup_min :Int!
    var isWakeup_vibration :Bool!
    var isWakeup_sensor :Bool!
    var isWakeup_snooze :Bool!
    var wakeup_volume :Float!
    var wakeup_sound : PlayList!
    
    
    required init(coder aDecoder: NSCoder) {
        
        self.timerType = AppTimerType(rawValue: aDecoder.decodeObjectForKey("timerType") as! Int)!
        
        self.isSleeper = aDecoder.decodeObjectForKey("isSleeper") as! Bool
        self.playLists = aDecoder.decodeObjectForKey("playLists") as! [PlayList]
        self.sleep_selectedIndex = aDecoder.decodeObjectForKey("sleep_selectedIndex") as! Int
        self.sleep_sound = aDecoder.decodeObjectForKey("sleep_sound") as! PlayList
        self.sleepSound_type = SelectSoundType(rawValue: aDecoder.decodeObjectForKey("sleepSound_type") as! Int)!
        self.sleep_volume = aDecoder.decodeObjectForKey("sleep_volume") as! Float
        self.sleep_timeInterval = SleepTimeIntervalType(rawValue: aDecoder.decodeObjectForKey("sleep_timeInterval") as! Int)!
        
        self.isWakeup = aDecoder.decodeObjectForKey("isWakeup") as! Bool
        self.wakeup_hour = aDecoder.decodeObjectForKey("wakeup_hour") as! Int
        self.wakeup_min = aDecoder.decodeObjectForKey("wakeup_min") as! Int
        self.isWakeup_vibration = aDecoder.decodeObjectForKey("isWakeup_vibration") as! Bool
        self.isWakeup_sensor = aDecoder.decodeObjectForKey("isWakeup_sensor") as! Bool
        self.isWakeup_snooze = aDecoder.decodeObjectForKey("isWakeup_snooze") as! Bool
        self.wakeup_volume = aDecoder.decodeObjectForKey("wakeup_volume") as! Float
        self.wakeup_sound = aDecoder.decodeObjectForKey("wakeup_sound") as! PlayList
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.timerType.rawValue, forKey: "timerType")
        
        aCoder.encodeObject(self.isSleeper, forKey: "isSleeper")
        aCoder.encodeObject(self.playLists, forKey: "playLists")
        aCoder.encodeObject(self.sleep_selectedIndex, forKey: "sleep_selectedIndex")
        aCoder.encodeObject(self.sleep_sound, forKey: "sleep_sound")
        aCoder.encodeObject(self.sleepSound_type.rawValue, forKey: "sleepSound_type")
        aCoder.encodeObject(self.sleep_volume, forKey: "sleep_volume")
        aCoder.encodeObject(self.sleep_timeInterval.rawValue, forKey: "sleep_timeInterval")
        
        aCoder.encodeObject(self.isWakeup, forKey: "isWakeup")
        aCoder.encodeObject(self.wakeup_hour, forKey: "wakeup_hour")
        aCoder.encodeObject(self.wakeup_min, forKey: "wakeup_min")
        aCoder.encodeObject(self.isWakeup_vibration, forKey: "isWakeup_vibration")
        aCoder.encodeObject(self.isWakeup_sensor, forKey: "isWakeup_sensor")
        aCoder.encodeObject(self.isWakeup_snooze, forKey: "isWakeup_snooze")
        aCoder.encodeObject(self.wakeup_volume, forKey: "wakeup_volume")
        aCoder.encodeObject(self.wakeup_sound, forKey: "wakeup_sound")
    }
    
    override init() {
        
        timerType = .NONE
        isSleeper  = true
        playLists = []
        sleep_sound = PlayList()
        sleepSound_type = .NONE
        sleep_volume = 0.3
        sleep_timeInterval = .MIN15
        sleep_selectedIndex = -1
        
        isWakeup = true
        wakeup_hour = 0
        wakeup_min = 0
        isWakeup_vibration = false
        isWakeup_sensor = false
        isWakeup_snooze = false
        wakeup_volume = 0.3
        
        wakeup_sound = PlayList()
        // アラーム,1,alarm01.aac,アラーム音1
        var sound = SoundInfo()
        sound.type = .ALARM
        sound.id = 1
        sound.soundTitle = "アラーム音1"
        sound.fileName = "alarm01.aac"
        wakeup_sound.soundList.append(sound)
        
        super.init()
    }
    
    
    func save() {
        
        let document = DocumentDirectoryFile(name: "MyData")
        document.save(self)
    }
    
    func load() -> MyData {
        
        // PlayListの読み込み
        let document = DocumentDirectoryFile(name: "MyData")
        let dum = document.load() as? MyData
        
        var myData :MyData
        if (dum == nil) {
            myData = MyData()
        } else {
            myData = dum!
        }
        
        
        return myData
    }
    
    
}
