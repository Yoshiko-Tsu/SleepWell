//
//  SleeperViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/15.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// おやすみ画面
class SleeperViewController: MyAlarmViewController, MyAlarmViewControllerDelegate {
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cancelImage: UIImageView!
    @IBOutlet weak var cancelSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.myAlarmVC_delegate = self
        self.navigationController?.navigationBarHidden = true

        // 表示
        let backgroundImage  = UIImage(named: "Sleeper")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)

        clockLabel.text = clock_hour + ":" + clock_min
        configSlider()
        if (myData.isWakeup == true) {
            infoLabel.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).CGColor
            infoLabel.layer.borderWidth = 1.0
            infoLabel.text = "起床時間　　　　" + String(format:"%02d", myData.wakeup_hour) + ":" + String(format:"%02d", myData.wakeup_min)
        }


    }

    
    func configSlider() {
        
        let frame = cancelImage.frame
        cancelSlider.frame = CGRectMake(0.0, 0.0, frame.width, frame.height)
        NSLog("Label width == \(frame.width)  height == \(frame.height)")
        
        let clearImage  = UIImage(named: "ClearImage")
        cancelSlider.setMaximumTrackImage(clearImage, forState: UIControlState.Normal)
        cancelSlider.setMinimumTrackImage(clearImage, forState: UIControlState.Normal)
        
        cancelSlider.setThumbImage(UIImage(named: "slider_arrow"), forState: UIControlState.Normal)
        
        cancelSlider.minimumValue = 0.0
        cancelSlider.maximumValue = 1.0
        cancelSlider.value = 0.01
        
        cancelSlider.addTarget(self, action: "touchUpInside_cancelSlider:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // キャンセル用slider
    func touchUpInside_cancelSlider(sender : UISlider) {
        let slider = sender
        
        if (slider.value >= 0.95) {
            slider.enabled = false
            
            if (sleepManager != nil) {
                sleepManager.stopPlayMusic()
            }
            if (wakeupManager != nil) {
                wakeupManager.stopDecidedTimer()
            }
            
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
