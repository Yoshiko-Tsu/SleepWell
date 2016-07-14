//
//  TopTableViewController.swift
//  PleasantSleep
//
//  Created by 鶴田義子 on 2015/07/02.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


class TopTableViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var orgView: UIView!         // blueView作成用のダミーView（大きさ取得用）
    @IBOutlet weak var sleeperSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmSetLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var sleepStatusLabel: UILabel!
    @IBOutlet weak var sensorStatusLabel: UILabel!
    
    var myData :MyData!
    var myHelpButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // スリープタイマーの無効化
        UIApplication.sharedApplication().idleTimerDisabled = true
        NSLog("スリープタイマーの無効化［TopTableViewController::viewDidLoad］")
        
        self.navigationController?.navigationBarHidden = false
        let helpImage = UIImage(named:"ic_help_white")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        myHelpButton = UIBarButtonItem(image: helpImage, style: UIBarButtonItemStyle.Plain, target: self, action: "pushMyHelp:")
        self.navigationItem.rightBarButtonItem = myHelpButton
        
        
        //
        let backgroundImage  = UIImage(named: "Home_BackGround")
        tableView.backgroundColor = UIColor(patternImage: backgroundImage!)
        headerView.backgroundColor = UIColor.clearColor()
        footerView.backgroundColor = UIColor.clearColor()
        
        
        // myDataの読み込み
        let dum = MyData()
        myData = dum.load()
        
        //
        sleeperSwitch.on = myData.isSleeper
        sleepStatusLabel.text = sleeperSwitch.on ? "ON" : "OFF"
        
        
        
        let yellow = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1.0)
        sleeperSwitch.onTintColor = yellow
        
        // Backボタン
        let backButtonItem = UIBarButtonItem(title: "ホーム", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displaySleepertitle()
        displayWakeup()
        displayStartButton()
        
        // 快適お目覚めタイマーON／OFF
        sensorStatusLabel.text = myData.isWakeup_sensor != nil && myData.isWakeup_sensor == true ? "ON" : "OFF"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        myData.save()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pushMyHelp(sender: UIButton) {
        
        let nav = self.storyboard?.instantiateViewControllerWithIdentifier("nav_Help") as! UINavigationController
        let nextView = nav.topViewController as! HelpViewController
        nextView.setHelpDataFlg = true
        nextView.myHelpData = helpData
        
        self.navigationController?.showViewController(nav, sender: nil)
    }
    
    
    // クラシック、サウンド、ヴォイスのボタン処理
    @IBAction func touchUpInside_Classic(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("nav_SelectSound") as! UINavigationController
        let nextViewController = nav.topViewController as! SelectSoundViewController
        
        nextViewController.myData = myData
        nextViewController.selectType = .ONE_SOUND
        nextViewController.selectSound = myData.sleep_sound
        
        nextViewController.soundType = SoundType.CLASSIC
        
        self.navigationController?.showViewController(nav, sender: nil)
    }
    @IBAction func touchUpInside_Sound(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("nav_SelectSound") as! UINavigationController
        let nextViewController = nav.topViewController as! SelectSoundViewController
        
        nextViewController.myData = myData
        nextViewController.selectType = .ONE_SOUND
        nextViewController.selectSound = myData.sleep_sound
        
        nextViewController.soundType = SoundType.SOUND
        
        self.navigationController?.showViewController(nav, sender: nil)
    }
    @IBAction func touchUpInside_Voice(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("nav_SelectSound") as! UINavigationController
        let nextViewController = nav.topViewController as! SelectSoundViewController
        
        nextViewController.myData = myData
        nextViewController.selectType = .ONE_SOUND
        nextViewController.selectSound = myData.sleep_sound
        
        nextViewController.soundType = SoundType.VOICE
        
        self.navigationController?.showViewController(nav, sender: nil)
    }
    //
    
    @IBAction func touchUpInside_Start(sender: AnyObject) {
        
        // タイマータイプ
        if (myData.isSleeper == true && myData.isWakeup == true) {
            myData.timerType = .BOTH
        } else if (myData.isSleeper == true && myData.isWakeup == false) {
            myData.timerType = .SLEEP
        } else if (myData.isSleeper == false && myData.isWakeup == true) {
            myData.timerType = .WAKEUP
        } else {
            myData.timerType = .NONE
        }

        
        // おやすみ画面へ
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("sleeeper_ID") as! SleeperViewController
        nextViewController.myData = myData
        if (myData.timerType == .SLEEP || myData.timerType == .BOTH) {
            nextViewController.nowTimerType = .SLEEP
        } else if (myData.timerType == .WAKEUP) {
            nextViewController.nowTimerType = .WAKEUP
        }
        
        self.showViewController(nextViewController, sender: self)
        
    }
    
    
    ////
    func displaySleepertitle() {
        
        if (myData.sleepSound_type == .PLAYLIST) {
            // プレイリスト
            if (myData.sleep_selectedIndex >= 0) {
                titleLabel.text = "　" + myData.playLists[myData.sleep_selectedIndex].name!
            } else {
                titleLabel.text = "　未選択"
                myData.sleepSound_type == .NONE
            }
        } else if (myData.sleepSound_type == .ONE_SOUND) {
            // サウンド
            
            if (!myData.sleep_sound.soundList.isEmpty) {
                titleLabel.numberOfLines = 2
                
                var categoryName :String
                
                switch (myData.sleep_sound.soundList[0].type) {
                case .CLASSIC:
                    categoryName = "　クラシック\n"
                case .SOUND:
                    categoryName = "　サウンド\n"
                case .VOICE:
                    categoryName = "　癒しのボイス\n"
                default:
                    categoryName = ""
                    break
                }
                titleLabel.text = categoryName + "　" + myData.sleep_sound.soundList[0].soundTitle
            }
        }
    }
    
    func displayWakeup() {
        
        alarmTimeLabel.text = String(format:"%02d", myData.wakeup_hour) + ":" + String(format:"%02d", myData.wakeup_min)
        alarmSetLabel.text = (myData.isWakeup == true) ? "ON" : "OFF"
    }
    
    func displayStartButton() {
        
        if (myData.isWakeup == false && myData.isSleeper == false) {
            
            // SleeperもWakeupもOFFの場合、反応しない
            startButton.enabled = false
            
        } else if (myData.isSleeper == true && (myData.playLists.count == 0 && myData.sleep_sound.soundList.count == 0)) {
            
            // SleeperがONで、音声が選択されていない場合、反応しない
            startButton.enabled = false
            
        } else if (myData.isSleeper == true && myData.sleepSound_type == .NONE) {
            
            // SleeperがONで、音声が選択されていない場合、反応しない
            startButton.enabled = false
            
        } else if (myData.isSleeper == true && (myData.sleepSound_type == .PLAYLIST && myData.sleep_selectedIndex == -1)) {
            
            // SleeperがONで、Playlistタイプで曲が選択されていない場合、反応しない
            startButton.enabled = false
            
        } else if (myData.isSleeper == true && (myData.sleepSound_type == .ONE_SOUND && myData.sleep_sound.soundList.count == 0)) {
            
            // SleeperがONで、ONE_SOUNDタイプで曲が選択されていない場合、反応しない
            startButton.enabled = false
            
        } else if (myData.isWakeup == true && myData.wakeup_sound.soundList.count == 0) {
            
            // WakeupがONで、音声が選択されていない場合、反応しない
            startButton.enabled = false
            
        } else {
            
            startButton.enabled = true
        }
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var nav :UINavigationController
        
        if (indexPath.row == 0) {
            
            // プレイリストを選択
            // プレイリストがまだカラか？
            if (myData.playLists.isEmpty) {
                
                // カラの場合　→　プレイリスト編集画面へ
                nav = storyboard.instantiateViewControllerWithIdentifier("nav_editPlayList") as! UINavigationController
                let nextViewController = nav.topViewController as! EditPlayListViewController
                
                var newPlayList = PlayList()
                newPlayList.makeNew(myData.playLists.count + 1)
                myData.playLists.append(newPlayList)
                
                nextViewController.myData = myData
                nextViewController.index = 0
                
            } else {
                
                // カラでない場合　→　プレイリスト画面へ
                nav = storyboard.instantiateViewControllerWithIdentifier("nav_playList") as! UINavigationController
                let nextViewController = nav.topViewController as! PlayListViewController
                
                nextViewController.myData = myData
                
            }
            self.navigationController?.showViewController(nav, sender: nil)
            
        } else if (indexPath.row == 1) {
            
            // アラーム設定画面へ
            nav = storyboard.instantiateViewControllerWithIdentifier("nav_setWakeup") as! UINavigationController
            let nextViewController = nav.topViewController as! SetAlarmTableViewController
            nextViewController.myData = myData
            self.navigationController?.showViewController(nav, sender: nil)
            
        } else if (indexPath.row == 2) {
            
            // 振動感知設定画面へ
            nav = storyboard.instantiateViewControllerWithIdentifier("nav_setMotionSenssor") as! UINavigationController
            let nextViewController = nav.topViewController as! MotionSensorTableViewController
            nextViewController.myData = myData
            self.navigationController?.showViewController(nav, sender: nil)
        }
        
    }
    ////
    
    
    @IBAction func switchSleeper(sender: AnyObject) {
        
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // sleeper設定
            myData.isSleeper = true
            sleepStatusLabel.text = "ON"
            
        } else {
            // sleeper非設定
            myData.isSleeper = false
            sleepStatusLabel.text = "OFF"
        }
        
        displayStartButton()
        
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue  segue.identifier == \(segue.identifier)");
        
        
        if (segue.identifier == "setWakeupID") {
            
            // アラーム設定画面へ
            let nav = segue.destinationViewController as! UINavigationController
            let nextViewController = nav.topViewController as! SetAlarmTableViewController
            nextViewController.myData = myData
            
        } else if (segue.identifier == "setMotionSenssorID") {
            
            // 振動感知設定画面へ
            let nav = segue.destinationViewController as! UINavigationController
            let nextViewController = nav.topViewController as! MotionSensorTableViewController
            nextViewController.myData = myData
            
        }
        
    }
    
}
