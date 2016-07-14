//
//  SetSleeperViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/08.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// PickerView用
let sleeperTimer_kindKey = [
    SleepTimeIntervalType.MIN15,
    SleepTimeIntervalType.MIN30,
    SleepTimeIntervalType.MIN45,
    SleepTimeIntervalType.MIN60,
    SleepTimeIntervalType.MIN75,
    SleepTimeIntervalType.MIN90,
]
let sleeperTimer_kindValue = [
    "15 分",
    "30 分",
    "45 分",
    "60 分",
    "75 分",
    "90 分"
]


// おやすみ設定画面
class SetSleeperViewController: UIViewController {

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var myData :MyData!
    var index :Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backgroundImage  = UIImage(named: "BackGround")
        view.backgroundColor = UIColor(patternImage: backgroundImage!)

        
        // myDataの読み込み
        let dum = MyData()
        myData = dum.load()

        if (myData.sleep_timeInterval != .NONE) {
            
            for (i, val) in enumerate(sleeperTimer_kindKey) {
                if (myData.sleep_timeInterval == val) {
                    index = i
                    break
                }
            }
            
            pickerView.selectRow(index, inComponent: 0, animated: true)
        } else {
            index = 0
        }
        volumeSlider.value = Float(myData.sleep_volume)
        
        let yellow = UIColor(red: 255.0, green: 255.0, blue: 0.0, alpha: 1.0)
        volumeSlider.minimumTrackTintColor = yellow
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        myData.save()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func valueChanged_slider(sender: AnyObject) {
        
        myData.sleep_volume = sender.value
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return sleeperTimer_kindValue.count
    }
    
//    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
//        
//        return sleeperTimer_kindValue[row]
//    }
//    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleText = sleeperTimer_kindValue[row]
        var title = NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myData.sleep_timeInterval = sleeperTimer_kindKey[row]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
