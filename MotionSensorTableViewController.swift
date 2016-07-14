//
//  MotionSensorTableViewController.swift
//  快眠ZZZ
//
//  Created by 鶴田義子 on 2015/07/21.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


let strSensorExplain =
"眠りの浅くなった時にアラームが起動し、快い目覚めにしてくれます。\n\n振動感知機能は、睡眠時における寝返りの特徴から、アラーム設定時間の30分前から寝返りの振動を感知して眠りが浅い状態の時にアラームが起動して起こしてくれます。\n\n※振動が感知されない場合は、アラーム設定時間でアラームが起動します。\n※振動感知機能には、お使いの端末の加速度センサーを使用します。"


// 振動感知機能設定画面
class MotionSensorTableViewController: UITableViewController {
    
    @IBOutlet weak var sensorSwitch: UISwitch!
    
    var myData :MyData!
    
    @IBOutlet weak var SensorStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backgroundImage  = UIImage(named: "BackGround")
        tableView.backgroundColor = UIColor(patternImage: backgroundImage!)

        let yellow = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1.0)
        sensorSwitch.onTintColor = yellow
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sensorSwitch.on = myData.isWakeup_sensor
        SensorStatusLabel.text = sensorSwitch.on ? "ON" : "OFF"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
    @IBAction func valueChanged_sensor(sender: AnyObject) {
        
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // 設定
            myData.isWakeup_sensor = true
        } else {
            // 非設定
            myData.isWakeup_sensor = false
        }
    }
*/

    
    @IBAction func valueChanged_sensor(sender: AnyObject) {
        let switchVal = sender as! UISwitch
        if (switchVal.on) {
            // 設定
            myData.isWakeup_sensor = true
            SensorStatusLabel.text = "ON"
        } else {
            // 非設定
            myData.isWakeup_sensor = false
            SensorStatusLabel.text = "OFF"
        }
    }
    
    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        let titleText = sleeperTimer_kindValue[row]
//        var title = NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
//        
//        return title
//    }
//    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        self.myData.sleep_timeInterval = sleeperTimer_kindKey[row]
//    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if (section == 1) {
            
            let footerView = UIView(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 0))
            let label = UILabel(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 0))
            
            label.textAlignment = NSTextAlignment.Left
            label.font = UIFont.italicSystemFontOfSize(14)
            label.backgroundColor = UIColor.clearColor()
            label.textColor =  UIColor.whiteColor()
            label.numberOfLines = 0
            label.text = strSensorExplain
            label.sizeToFit()
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            footerView.frame = label.frame
            footerView.backgroundColor = UIColor.clearColor()
            footerView.addSubview(label)
            
            let view_constraint_1 = NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: footerView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            )
            let view_constraint_2 = NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: footerView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: -10
            )
            let view_constraint_3 = NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: footerView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 10
            )
            let view_constraint_4 = NSLayoutConstraint(
                item: label,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: footerView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: -10
            )
            
            //反映
            let constraints = [view_constraint_1, view_constraint_2, view_constraint_3, view_constraint_4]
            footerView.addConstraints(constraints)
            
            let heightFooterView = footerView.frame.height
            //NSLog("SetAlarmTableViewController footer view height == \(heightFooterView)")
            
            return footerView
            
        } else {
            
            return nil
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (section == 1) {
            return 220.0
        } else {
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        let cell = super.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
