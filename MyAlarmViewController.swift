//
//  MyAlarmViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/15.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


protocol MyAlarmViewControllerDelegate: class {
    
    func changeClockTimer()
}


// おやすみ、おはよう画面のsuper class
class MyAlarmViewController: UIViewController, MyAudioPlayerManagerDelegate, MyDeviceMotionDelegate {

    var myData :MyData!
    var nowTimerType :AppTimerType!
    var sleepManager :MyAudioPlayerManager!
    var wakeupManager :MyAudioPlayerManager!
    var oneFlg_Sleep = false
    var oneFlg_Wakeup = false
    var oneFlg_MoveWakeup = false
    
    var clockTimer :NSTimer! = nil
    var clockDate :NSDate!
    var clock_hour :String!
    var clock_min :String!
    let dateFormatter = NSDateFormatter()

    var motionTimer :NSTimer! = nil
    var motionManager: MyMotionManager!
    
    var myAlarmVC_delegate :MyAlarmViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle

        
        if (nowTimerType == AppTimerType.SLEEP && (myData.timerType == .SLEEP || myData.timerType == .BOTH)) {

            // おやすみ用のサウンドセット
            setSleepManager()
            sleepManager.startPlayMusic()
        }
        if (myData.timerType == .WAKEUP || myData.timerType == .BOTH) {

            // 目覚まし用のタイマーセット
            // AppTimerType.SLEEPの場合　→　画面遷移用のタイマーセット
            setWakeupManager()
            wakeupManager.setDecidedTimer(myData.wakeup_hour, min: myData.wakeup_min)
            
            // 振動探知設定
            if (myData.isWakeup_sensor == true) {
                setMotion()
            }
        }
        
        
        // 時刻表示用タイマーの秒調整
        clockDate = NSDate()
        let now_sec = MyDate.apartFromNSDate(.Second, date: clockDate)
        let adustTimer = NSTimer.scheduledTimerWithTimeInterval(Double(60 - now_sec), target: self, selector: "adustTime", userInfo: nil, repeats: false)
        NSLog("clockTimer == " + dateFormatter.stringFromDate(clockDate))
        
        clock_hour = MyDate.apartFromNSDateStr(.Hour, date: clockDate)
        clock_min = MyDate.apartFromNSDateStr(.Minute, date: clockDate)
        
    }

    func setSleepManager() {
        
        var sounds :[SoundInfo] = []
        sleepManager = MyAudioPlayerManager()
        sleepManager.myAudioManager_delegate = self

        // おやすみ曲
        if (myData.sleepSound_type == .ONE_SOUND) {
            
            // サウンド
            sounds.append(myData.sleep_sound.soundList[0])
        } else {
            
            // PlayList
            let onePlay = myData.playLists[myData.sleep_selectedIndex]
            for one in onePlay.soundList {
                sounds.append(one)
            }
        }
        // 曲設定
        sleepManager.setVolume(myData.sleep_volume)   // ボリュームを先に設定しないと、音がでない
        sleepManager.makePlayList(sounds)
        
        // タイマー値設定
        sleepManager.setTimeInterval(myData.sleep_timeInterval.rawValue)
    }
    
    func setWakeupManager() {

        var sounds :[SoundInfo] = []
        wakeupManager = MyAudioPlayerManager()
        wakeupManager.myAudioManager_delegate = self
        
        // 目覚まし曲
        sounds.append(myData.wakeup_sound.soundList[0])
        // 曲設定
        wakeupManager.setVolume(myData.wakeup_volume)   // ボリュームを先に設定しないと、音がでない
        wakeupManager.makePlayList(sounds)

        // バイブレーション設定
        wakeupManager.setVibration(myData.isWakeup_vibration)
        
        
        // タイマー値設定
        wakeupManager.setTimeInterval(WAKEUP_SOUND_INTERVAL)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if (clockTimer != nil) {
            clockTimer.invalidate()
            clockTimer = nil
        }
        if (motionTimer != nil) {
            motionTimer.invalidate()
            motionTimer = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func adustTime() {
        
        // 時刻用タイマー設定
        clockDate = NSDate()
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(Double(60), target: self, selector: "clockTimer_Min", userInfo: nil, repeats: true)
    }
    
    
    func clockTimer_Min() {
        
        clockDate = NSDate()
        NSLog("clockTimer == " + dateFormatter.stringFromDate(clockDate))
        
        clock_hour = MyDate.apartFromNSDateStr(.Hour, date: clockDate)
        clock_min = MyDate.apartFromNSDateStr(.Minute, date: clockDate)
        
        myAlarmVC_delegate?.changeClockTimer()
    }

    
    // 目覚まし時間になったら、呼ばれる
    func intervalTimerStart() {
        
        // 目覚まし画面へ
        if (!oneFlg_MoveWakeup) {
            
            // 音をとめる
            if (sleepManager != nil) {
                sleepManager.stopPlayMusic()
                sleepManager = nil
            }
            
            oneFlg_MoveWakeup = true    // １度、遷移したら、しない
            toWakeupViewController()
        }
    }
    
    // timerが終了した（設定時間の間、曲が鳴り終わった）場合、呼ばれる
    func intervalTimerStop() {
        
        if (myData.timerType == .BOTH) {
            
            if (nowTimerType == AppTimerType.WAKEUP && myData.isWakeup_snooze == false) {
                // Top画面へ
                toTopViewController()
            } else {
                nowTimerType = AppTimerType.WAKEUP
            }
        } else {
            
            if (nowTimerType == AppTimerType.WAKEUP && myData.isWakeup_snooze == true) {
                // 画面移動しない
                
            } else {
                // Top画面へ
                toTopViewController()
            }
        }

    }

    
    func toWakeupViewController() {
        
        if (!oneFlg_Sleep) {
            
            oneFlg_Sleep = true     // 複数回、呼ばれるのを防止
            
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("wakeup_ID") as! WakeupViewController
            nextViewController.myData = myData
            nextViewController.nowTimerType = .WAKEUP
            nextViewController.sleeperWakeupManager = self.wakeupManager
            
            self.showViewController(nextViewController, sender: self)
        }
        
    }
    
    func toTopViewController() {
        
        if (!oneFlg_Wakeup) {
            
            oneFlg_Wakeup = true     // 複数回、呼ばれるのを防止
            
            var storyboard = UIStoryboard()
            if (UserInfo.is_iPhone6Plus()) {
                
                storyboard = UIStoryboard(name: "iPhone6Plus", bundle: nil)
            } else {
                
                if (UserInfo.is_iPhone6()) {
                    
                    storyboard = UIStoryboard(name: "iPhone6", bundle: nil)
                } else {
                    
                    storyboard = UIStoryboard(name: "iPhone5s", bundle: nil)
                }
            }
            let nextViewController = storyboard.instantiateInitialViewController() as! ECSlidingViewController
            
            self.showViewController(nextViewController, sender: self)
        }
    }
    
    
    // 振動探知設定
    func setMotion() {
        
        // 振動探知起動のNSDateを作成
        // 起床時間より、MOTION_START_INTERVAL分前
        let preTime = MyDate.dateAdd(Interval.Minute, number: MOTION_START_INTERVAL * -1, date: wakeupManager.decidedNSDate)
        NSLog("振動探知起動時間 == " + dateFormatter.stringFromDate(preTime))
        
        
        // 決められた時間までの秒数を取得
        let now = NSDate()
        let diff = MyDate.dateDiff(.Second, date1: now, date2: preTime)
        
        // 振動探知起動時間までのタイマーセット
        motionTimer = NSTimer.scheduledTimerWithTimeInterval(Double(diff), target: self, selector: "toStartMotion", userInfo: nil, repeats: false)
        
    }
    
    func toStartMotion() {
        
        motionManager = MyMotionManager(interval: MOTION_INTERVAL)
        
        motionManager.deviceMotion.MyDeviceMotion_delegate = self
        motionManager.startMotion()
        
        NSLog("振動探知　START !!!!!")
    }
    
    func myDeviceMotionStop() {
        
        NSLog("!!!!! 振動探知　STOP ")
        if (motionTimer != nil) {
            motionTimer.invalidate()
            motionTimer = nil
        }
        
        wakeupManager.startPlayMusic()
    }
}
