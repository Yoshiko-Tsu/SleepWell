//
//  WakeupViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/15.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


//let WAKEUP_SOUND_INTERVAL = 15      // めざましが鳴り続ける時間
let WAKEUP_SOUND_INTERVAL = 3      // めざましが鳴り続ける時間      for test
let WAKEUP_SNOOZE_INTERVAL = 3      // スヌーズ間隔

// おはよう画面
class WakeupViewController: MyAlarmViewController, MyAlarmViewControllerDelegate {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var stopSlider: UISlider!
    
    var sleeperWakeupManager :MyAudioPlayerManager!
    var wakeup_hour :Int!
    var wakeup_min :Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.myAlarmVC_delegate = self
        self.navigationController?.navigationBarHidden = true
        
        // 表示
        let backgroundImage  = UIImage(named: "Wakeup")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        clockLabel.text = clock_hour + ":" + clock_min
        configSlider()

        if (myData.isWakeup_snooze == false) {
            
            snoozeButton.hidden = true
        }
        
        // 目覚まし用のタイマー値
        wakeup_hour = myData.wakeup_hour
        wakeup_min = myData.wakeup_min
        
    }

    
    func configSlider() {
        
        let frame = stopImage.frame
        stopSlider.frame = CGRectMake(0.0, 0.0, frame.width, frame.height)
        NSLog("Label width == \(frame.width)  height == \(frame.height)")
        
        let clearImage  = UIImage(named: "ClearImage")
        stopSlider.setMaximumTrackImage(clearImage, forState: UIControlState.Normal)
        stopSlider.setMinimumTrackImage(clearImage, forState: UIControlState.Normal)
        
        stopSlider.setThumbImage(UIImage(named: "slider_arrow"), forState: UIControlState.Normal)
        
        stopSlider.minimumValue = 0.0
        stopSlider.maximumValue = 1.0
        stopSlider.value = 0.01
        
        stopSlider.addTarget(self, action: "touchUpInside_stopSlider:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    @IBAction func touchUpInside_snoozeButton(sender: AnyObject) {

        // 音をとめる
        if (sleeperWakeupManager != nil) {
            sleeperWakeupManager.stopPlayMusic()
            sleeperWakeupManager = nil
        }
        wakeupManager.stopDecidedTimer()
        wakeupManager.stopIntervalTimer()
        
        
        // もう１度、目覚まし用のタイマーセット
        wakeup_min = wakeup_min + WAKEUP_SNOOZE_INTERVAL
        wakeupManager.setDecidedTimer(wakeup_hour, min: wakeup_min)
    }
    
    
    // STOP用slider
    func touchUpInside_stopSlider(sender : UISlider) {
        let slider = sender
        
        if (slider.value >= 0.95) {
            slider.enabled = false
            
            // 音をとめる
            if (sleeperWakeupManager != nil) {
                sleeperWakeupManager.stopPlayMusic()
                sleeperWakeupManager = nil
            }
            wakeupManager.stopPlayMusic()
            
            if (clockTimer != nil) {
                clockTimer.invalidate()
                clockTimer = nil
            }
            
            // Top画面へ
            toTopViewController()
            
        } else {
            sender.setValue(0.01, animated: false)
        }
    }
    @IBAction func valueChanged_slider(sender: AnyObject) {
        /*
        let slider = sender as! UISlider
        if (slider.value >= 0.95) {
            
            slider.enabled = false
            
            // 音をとめる
            if (sleeperWakeupManager != nil) {
                sleeperWakeupManager.stopPlayMusic()
                sleeperWakeupManager = nil
            }
            wakeupManager.stopPlayMusic()
            
            if (clockTimer != nil) {
                clockTimer.invalidate()
                clockTimer = nil
            }
            
            // Top画面へ
            toTopViewController()
        }
        */
    }
    
    
    func changeClockTimer() {
        
        clockLabel.text = clock_hour + ":" + clock_min
        view.reloadInputViews()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
