//
//  SetAlarmTableViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/08.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// おはよう設定画面
class SetAlarmTableViewController: UITableViewController {
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var alarmTime_datePicker: MyDatePicker!
    @IBOutlet weak var alarmSoundLabel: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var minVolImage: UIImageView!
    @IBOutlet weak var maxVolImage: UIImageView!
    
    @IBOutlet weak var alarmSettingLabel: UILabel!
    @IBOutlet weak var snoozeSettingLabel: UILabel!
    @IBOutlet weak var vibrationSettingLabel: UILabel!
    
    @IBOutlet weak var alarmSettingCell: UITableViewCell!
    @IBOutlet weak var timerSettingCell: UITableViewCell!
    @IBOutlet weak var soundSettingCell: UITableViewCell!
    @IBOutlet weak var snoozeSettingCell: UITableViewCell!
    @IBOutlet weak var vibrationSettingCell: UITableViewCell!
    @IBOutlet weak var volumeSettingCell: UITableViewCell!
    
    var myData :MyData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backgroundImage  = UIImage(named: "BackGround")
        tableView.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        if(tableView.respondsToSelector(Selector("setSeparatorInset:"))){
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if(tableView.respondsToSelector(Selector("setLayoutMargins:"))){
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        if(alarmSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            alarmSettingCell.layoutMargins = UIEdgeInsetsZero
        }
        if(timerSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            timerSettingCell.layoutMargins = UIEdgeInsetsZero
        }
        if(soundSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            soundSettingCell.layoutMargins = UIEdgeInsetsZero
        }
        if(snoozeSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            snoozeSettingCell.layoutMargins = UIEdgeInsetsZero
        }
        if(vibrationSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            vibrationSettingCell.layoutMargins = UIEdgeInsetsZero
        }
        if(volumeSettingCell.respondsToSelector(Selector("setLayoutMargins:"))){
            volumeSettingCell.layoutMargins = UIEdgeInsetsZero
        }

        let yellow = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1.0)
        alarmSwitch.onTintColor = yellow
        snoozeSwitch.onTintColor = yellow
        vibrationSwitch.onTintColor = yellow
        volumeSlider.minimumTrackTintColor = yellow
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        myData.wakeup_hour = alarmTime_datePicker.hour
        myData.wakeup_min = alarmTime_datePicker.minute
        
        myData.save()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
    }
    
    func configure() {
        
        alarmSwitch.on = myData.isWakeup
        alarmSettingLabel.text = alarmSwitch.on ? "ON" : "OFF"
        
        alarmTime_datePicker.setTitleColor(UIColor.whiteColor())
        let dumNSDate = MyDate.timeSerial(myData.wakeup_hour, minute: myData.wakeup_min, second: 0)
        alarmTime_datePicker.setDate(dumNSDate)
        
        if (!myData.wakeup_sound.soundList.isEmpty) {
            alarmSoundLabel.text = myData.wakeup_sound.soundList[0].soundTitle
        }
        
        snoozeSwitch.on = myData.isWakeup_snooze
        snoozeSettingLabel.text = snoozeSwitch.on ? "ON" : "OFF"
        
        vibrationSwitch.on = myData.isWakeup_vibration
        vibrationSettingLabel.text = vibrationSwitch.on ? "ON" : "OFF"
        
        volumeSlider.value = Float(myData.wakeup_volume)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func valueChanged_alarm(sender: AnyObject) {
        
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // 設定
            myData.isWakeup = true
            alarmSettingLabel.text = "ON"
        } else {
            // 非設定
            myData.isWakeup = false
            alarmSettingLabel.text = "OFF"
        }
    }
    
    //    @IBAction func touchDown_alarmTime(sender: AnyObject) {
    //
    //        var datePicker = ActionSheetDatePicker(title: "起床時間", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), target: self, action: "datePicked:", origin: sender.superview)
    //
    //
    //        datePicker.minuteInterval = 5
    //        datePicker.showActionSheetPicker()
    //
    //        alarmTime_textField.resignFirstResponder()
    //    }
    
    
//    @IBAction func valueChanged_alarmTime(sender: AnyObject) {
//        
//        let dateVal = sender as! UIDatePicker
//        let hour = MyDate.apartFromNSDate(.Hour, date: dateVal.date)
//        let min = MyDate.apartFromNSDate(.Minute, date: dateVal.date)
//    }
    
    
    //    @IBAction func valueChanged_sensor(sender: AnyObject) {
    //
    //        let switchVal = sender as! UISwitch
    //        if (switchVal.on) {
    //            // 設定
    //            myData.isWakeup_sensor = true
    //        } else {
    //            // 非設定
    //            myData.isWakeup_sensor = false
    //        }
    //    }
    
    @IBAction func valueChanged_snooze(sender: AnyObject) {
        
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // 設定
            myData.isWakeup_snooze = true
            snoozeSettingLabel.text = "ON"
        } else {
            // 非設定
            myData.isWakeup_snooze = false
            snoozeSettingLabel.text = "OFF"
        }
    }
    
    @IBAction func valueChanged_vibration(sender: AnyObject) {
        
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // 設定
            myData.isWakeup_vibration = true
            vibrationSettingLabel.text = "ON"
        } else {
            // 非設定
            myData.isWakeup_vibration = false
            vibrationSettingLabel.text = "OFF"
        }
    }
    
    @IBAction func valueChangedSlider(sender: AnyObject) {
        
        let val = sender as! UISlider
        myData.wakeup_volume = val.value
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        return 7
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = super.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        //make the background color light blue
        header.contentView.backgroundColor = UIColor(red: 221/255, green: 240/255, blue: 255/255, alpha: 1.0)
        
        //make the text white
        header.textLabel.textColor = UIColor(red: 79/255, green: 96/255, blue: 173/255, alpha: 1.0)
        
        //make the header transparent
        header.alpha = 1
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue  segue.identifier == \(segue.identifier)");
        
        
        if (segue.identifier == "selectAlarmID") {

            let nav = segue.destinationViewController as! UINavigationController
            let nextViewController = nav.topViewController as! SelectSoundViewController
            nextViewController.selectType = .ONE_SOUND
            nextViewController.selectSound = myData.wakeup_sound

            nextViewController.soundType = SoundType.ALARM
        }
    }
    
}
