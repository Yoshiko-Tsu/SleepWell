//
//  MyDatePicker.swift
//  快眠ZZZ
//
//  Created by 鶴田義子 on 2015/07/22.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// 現在は時分のみ出力
// storyboard上でUIPickerViewを作成して使用

let FakeEndlessNumber = 10

class MyDatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    let hours :[Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
//    let minuts :[String] = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    
    var hour :Int = 0 {
        didSet {
            //            selectRow(find(hours, hour)!, inComponent: 0, animated: false)
            selectRow(hour, inComponent: 0, animated: false)
        }
    }
    var minute :Int = 0 {
        didSet {
            selectRow(minute, inComponent: 1, animated: false)
            //            let min = String(format:"%02d", minute)
            //            selectRow(find(minuts, min)!, inComponent: 1, animated: false)
        }
    }
//    var hour :Int = 0
//    var minute :Int = 0
    var textColor :UIColor!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        
        self.delegate = self
        self.dataSource = self
    }
    
    func setDate(date :NSDate) {
        
        let hour = MyDate.apartFromNSDate(.Hour, date: date)
        var min = MyDate.apartFromNSDate(.Minute, date: date)
//        let amari = min % 5
//        min = min - amari
        
        self.hour = hour
        self.minute = min
    }
    
    func setTitleColor(color :UIColor) {
        
        textColor = color
        
    }
    
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        //        var text :String!
        //        switch component {
        //        case 0:
        //            text = "\(hours[row])"
        //        case 1:
        //            text = minuts[row]
        //        default:
        //            text = ""
        //        }
//        let text = String(format:"%02d", row)
//        var orgRow :Int!
//        switch component {
//        case 0:
//            orgRow = row % 24
//        case 1:
//            orgRow = row % 60
//        default:
//            orgRow = 0
//        }
//        let text = String(format:"%02d", orgRow)
        let text = String(format:"%02d", row)
        
        // 文字の色を変える
        var textString = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:textColor])
        
        return textString
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
//            return hours.count
            //return 24 * FakeEndlessNumber
            return 24
        case 1:
//            return minuts.count
            //return 60 * FakeEndlessNumber
            return 60
        default:
            return 0
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.hour = self.selectedRowInComponent(0)
        self.minute = self.selectedRowInComponent(1)
//        let min = self.minuts[self.selectedRowInComponent(1)]
//        self.minute = min.toInt()!
        
/*
        var orgRow :Int!
        switch component {
        case 0:
            orgRow = row % 24
            self.hour = orgRow
        case 1:
            orgRow = row % 60
            self.minute = orgRow
        default:
            orgRow = 0
        }
        selectRow(orgRow, inComponent: component, animated: false)
*/
    }
    
}
