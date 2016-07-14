//
//  SoundInfo.swift
//  test_TableView
//
//  Created by 鶴田義子 on 2015/06/19.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


enum SoundType: Int
{
    case NONE = 0
    case CLASSIC = 1
    case SOUND = 2
    case VOICE = 3
    case ALARM = 4
}


// 曲情報
class SoundInfo : NSObject, NSCoding {
    
    var type :SoundType
    var id :Int
    var soundTitle :String!
    var fileName :String!
    //var artistName :String?
    
    required init(coder aDecoder: NSCoder) {
        self.type = SoundType(rawValue: aDecoder.decodeObjectForKey("type") as! Int)!
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        self.soundTitle = aDecoder.decodeObjectForKey("soundTitle") as! String
        self.fileName = aDecoder.decodeObjectForKey("fileName") as! String
        //self.artistName = aDecoder.decodeObjectForKey("artistName") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.soundTitle, forKey: "soundTitle")
        aCoder.encodeObject(self.fileName, forKey: "fileName")
        //aCoder.encodeObject(self.artistName, forKey: "artistName")
    }
    
    override init() {
        type = .NONE
        id = 0
        soundTitle = ""
        fileName = ""
        //artistName = ""
        
        super.init()
    }
//    init(type :SoundType,
//        id :Int,
//        soundTitle :String!,
//        fileName :String!,
//        artistName :String?) {
//            
//            self.type = type
//            self.id = id
//            self.soundTitle = soundTitle
//            self.fileName = fileName
//            self.artistName = artistName
//    }
    init(type :SoundType,
        id :Int,
        soundTitle :String!,
        fileName :String!) {
            
            self.type = type
            self.id = id
            self.soundTitle = soundTitle
            self.fileName = fileName
    }
}

