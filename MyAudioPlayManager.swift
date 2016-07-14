//
//  MyAudioPlayManager.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/15.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox


@objc protocol MyAudioPlayerManagerDelegate: class {
    
    optional func intervalTimerStart()
    optional func intervalTimerStop()
}


class MyAudioPlayerManager :NSObject, AVAudioPlayerDelegate {
    
    private var playList :[MyAudioPlayer] = []
    private var index = 0
    private var intervalTime = 0
    private var volume :Float = 0.0
    private var delegateFlg = false
    private var vibrationFlg = false
    private var myVibration :MyVibration? = nil
    
    var intervalTimer :NSTimer! = nil
    private var decidedTimer :NSTimer! = nil
    var decidedNSDate :NSDate!
    
    
    var myAudioManager_delegate :MyAudioPlayerManagerDelegate?
    
    
    override init() {
        super.init()
        
    }
    
    
    func setTimeInterval(interval :Int) {
        
        // second単位
        intervalTime = interval * 60
        
    }
    
    func setDelegateFlg(val :Bool) {
        
        delegateFlg = val
    }
    
    func setVibration(val :Bool) {
        
        vibrationFlg = val
        myVibration = MyVibration()
    }
    
    func setVolume(val :Float) {
        
        volume = val
    }
    
    func makePlayList(lists :[SoundInfo]) {
        
        for sound in lists {
            
            var onePlayer = MyAudioPlayer()
            onePlayer.setSound(sound.fileName)
            onePlayer.setSoundTitle(sound.soundTitle)
            onePlayer.setVolume(volume)
            onePlayer.getMetaData()
            
            onePlayer.audioPlayer.delegate = self
            
            playList.append(onePlayer)
        }
    }

    
    // AVAudioPlayerDelegate
    // 再生終了時処理
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        NSLog("MyAudioPlayerManager::audioPlayerDidFinishPlaying")
        
        
        //　何曲目のplayerか
        for (i, one) in enumerate(playList) {
            
            if (player == one.audioPlayer) {
                
                // 今の曲を止める
                index = i
                playList[index].stop()
                
                NSLog("STOP Sound")
                playList[index].titlePrint()
                
                
                if (playList.count == index + 1) {
                    index = 0
                } else {
                    index = i + 1
                }
                
                // 次の曲をかける
                playList[index].play()
                
                NSLog("START Sound")
                playList[index].titlePrint()
                break
            }
        }
    }
    
    
    // 決められた時間に音がなる
    func setDecidedTimer(hour :Int, min :Int) {
        
        if (decidedTimer != nil) {
            decidedTimer.invalidate()
            decidedTimer = nil
        }
        
        // inputの時間分のNSDateを作成
        decidedNSDate = MyDate.toDesignatedTime(hour, alarmMin: min)

        
        // 決められた時間までの秒数を取得
        let now = NSDate()
        let diff = MyDate.dateDiff(.Second, date1: now, date2: decidedNSDate)
        
        // 決められた時間までのタイマーセット
        delegateFlg = true
        decidedTimer = NSTimer.scheduledTimerWithTimeInterval(Double(diff), target: self, selector: "startPlayMusic", userInfo: nil, repeats: false)
        
    }
    
    
    func startPlayMusic() {
        
        if (decidedTimer != nil) {
            decidedTimer.invalidate()
            decidedTimer = nil
        }
        if (intervalTimer != nil) {
            intervalTimer.invalidate()
            intervalTimer = nil
        }
        
        // 音を止めるタイマーセット
        intervalTimer = NSTimer.scheduledTimerWithTimeInterval(Double(intervalTime), target: self, selector: "stopIntervalTimer", userInfo: nil, repeats: false)

        if (delegateFlg) {
            // 他の画面へ移動
            myAudioManager_delegate?.intervalTimerStart!()
        }
        
        // １曲目スタート
        index = 0
        playList[index].play()
        NSLog("START Sound")
        playList[index].titlePrint()
        
        // バイブレーション
        if (vibrationFlg) {
            
            myVibration!.vibrationStart()
        }
    }
    
    
    func stopIntervalTimer() {
        
        stopPlayMusic()

        if (intervalTimer != nil) {
            intervalTimer.invalidate()
            intervalTimer = nil
        }
        // 他の画面へ移動
        myAudioManager_delegate?.intervalTimerStop!()
    }
    
    func stopPlayMusic() {
        
        if (decidedTimer != nil) {
            decidedTimer.invalidate()
            decidedTimer = nil
        }
        if (intervalTimer != nil) {
            intervalTimer.invalidate()
            intervalTimer = nil
        }
        playList[index].stop()

        // バイブレーション
        if (vibrationFlg) {
            myVibration!.vibrationStop()
        }
    }
    
    func stopDecidedTimer() {
        
        if (decidedTimer != nil) {
            decidedTimer.invalidate()
            decidedTimer = nil
        }
    }
}


