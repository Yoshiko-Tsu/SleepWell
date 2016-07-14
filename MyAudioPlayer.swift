//
//  MyAudioPlayer.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/26.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation
import AVFoundation


class MyAudioPlayer :NSObject {
    
    var audioPlayer :AVAudioPlayer!
    private var soundTitle :String!
    private var soundPath :NSURL!
    
    private var title :String!
    private var album :String!
    private var artist :String!
    private var artwork :UIImage?
    private var playTime :Double!
    
    
    override init() {
        super.init()
        
        audioPlayer = AVAudioPlayer()
    }
    
    
    func setSound(name :String) {
        
        let filePath :String = NSBundle.mainBundle().pathForResource(name, ofType: "")!
        soundPath = NSURL(fileURLWithPath: filePath)!
        
        var audioError:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: soundPath, error: &audioError)
        
        if let error = audioError {
            NSLog("Error \(error.localizedDescription)")
        }
        
        audioPlayer.prepareToPlay()
        
    }
    
    func getMetaData() {
        
        let asset : AVAsset = AVURLAsset(URL: soundPath, options: nil)
        let metadata : Array = asset.commonMetadata
        
        
        for item in metadata {
            switch item.commonKey as String {
            case AVMetadataCommonKeyTitle:
                // タイトル取得
                title = item.stringValue
            case AVMetadataCommonKeyAlbumName:
                // アルバム名取得
                album = item.stringValue
            case AVMetadataCommonKeyArtist:
                // アーティスト名取得
                artist = item.stringValue
            case AVMetadataCommonKeyArtwork:
                // アートワーク取得
                //if let artworkData = item.value as? NSDictionary {
                if let artworkData = item as? NSDictionary {
                    // iOS7まではNSDirectory型が返却される
                    artwork = UIImage(data:artworkData["data"] as! NSData)
                } else {
                    // iOS8からはNSData型が返却される
                    artwork = UIImage(data:item.dataValue)
                }
                break
            default:
                break
            }
        }
//        NSLog("getMetaData::title == \(title)")

        
        let cmtime :CMTime = asset.duration
        playTime = Double(cmtime.value) / Double(cmtime.timescale)
        
//        NSLog("cmtime.value == \(cmtime.value)\tcmtime.timescale == \(cmtime.timescale)")
//        NSLog("sec == \(playTime)")
    }
    
    func getPlayTime() -> Double {
        
        return playTime
    }
    
    
    func play() {
        
        audioPlayer.play()
    }
    
    func replay() {
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func stop() {
        
        audioPlayer.stop()
    }
    
    func playOrPause() {
        
        if (audioPlayer.playing) {
            
            audioPlayer.pause()
        } else {
            
            audioPlayer.play()
        }
    }

    
    func setVolume(val :Float) {
        audioPlayer.volume = val
    }
        
    func setSoundTitle(title :String) {
        soundTitle = title
    }

    func titlePrint() {
        NSLog("soundTitle == \(soundTitle)")
    }
}




