//
//  SoundSource.swift
//  test_TableView
//
//  Created by 鶴田義子 on 2015/06/18.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation



class SoundSource {
    
    var Classic: [SoundInfo] = []
    var Sound: [SoundInfo] = []
    var Voice: [SoundInfo] = []
    var Alarm: [SoundInfo] = []
    

    class var sharedInstance :SoundSource {
        struct Static{
            static let instance :SoundSource = SoundSource()
        }
        return Static.instance
    }
    
    private init() {
        
    }
    
    
    func readMusicData() -> [Dictionary<String, String>] {
        
        let filePath :String = NSBundle.mainBundle().pathForResource("MusicData", ofType: "csv")!
        //return CsvFile.read_shiftJis(filePath)
        return CsvFile.read_mix(filePath)
    }
    
    func makeData() {
    
        let dictData :[Dictionary<String, String>] = readMusicData()
        
        for data in dictData {
            
            var type :SoundType = .NONE
            switch (data["ジャンル"]!) {
                case "クラシック":
                    type = .CLASSIC
                case "サウンド":
                    type = .SOUND
                case "癒しのボイス":
                    type = .VOICE
                case "アラーム":
                    type = .ALARM
                default:
                    type = .NONE
            }
            var id = data["id"]!.toInt()
            
//            var info = SoundInfo(type: type, id: id!, soundTitle: data["曲名"]!, fileName: data["ファイル名"]!, artistName: data["アーティスト"])
            var info = SoundInfo(type: type, id: id!, soundTitle: data["曲名"]!, fileName: data["ファイル名"]!)
            switch (type) {
                case .CLASSIC:
                    Classic.append(info)
                case .SOUND:
                    Sound.append(info)
                case .VOICE:
                    Voice.append(info)
                case .ALARM:
                    Alarm.append(info)
                default:
                    break
            }
        }
    }
    
}

