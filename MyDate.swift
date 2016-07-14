//
//  MyDate.swift
//  testMotion_1
//
//  Created by 鶴田義子 on 2015/06/25.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


enum Interval: String {
    case Year = "yyyy"
    case Month = "MM"
    case Day = "dd"
    case Hour = "HH"
    case Minute = "mm"
    case Second = "ss"
}

final class MyDate {

    // 指定した間隔を加算した日時(NSDate)を返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  number : 追加する日時間隔を整数で指定します
    //           正の数を指定すれば未来の日時を取得できます
    //           負の数を指定すれば過去の日時を取得できます
    //  date : 元の日時を NSDate で指定します
    //
    //      let d = dateAdd(.Month,6,NSDate())  // 半年後
    //        let date1 = dateAdd(.Day,3,NSDate())   // 現在より3日後
    //        let date2 = dateAdd(.Day,5,NSDate())   // 現在より5日後
    //        let calendar = NSCalendar.currentCalendar()
    //        var comp: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: date1, toDate: date2, options:nil)
    //        let d = comp.day                       // 差は2日
    class func dateAdd(interval: Interval, number: Int, date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        var comp = NSDateComponents()
        switch interval {
        case .Year:
            comp.year = number
        case .Month:
            comp.month = number
        case .Day:
            comp.day = number
        case .Hour:
            comp.hour = number
        case .Minute:
            comp.minute = number
        case .Second:
            comp.second = number
        default:
            comp.day = 0
        }
        return calendar.dateByAddingComponents(comp, toDate: date, options: nil)!
    }

    
    // 2つの日時の間隔を整数型の値で返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  date1,date2 : 間隔を計算する2つの日時を指定します
    //           date1よりdate2が前なら負の値を返します
    //
    //        let date1 = dateAdd(.Hour,8,NSDate())  // 8時間後
    //        let date2 = dateAdd(.Day,1,NSDate())   // 1日後
    //        let d = dateDiff(.Hour,date1,date2)    // 差は16時間    
    class func dateDiff(interval: Interval, date1: NSDate, date2: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        switch interval {
        case .Year:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitYear,
                fromDate: date1, toDate: date2, options:nil)
            return comp.year
        case .Month:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitMonth,
                fromDate: date1, toDate: date2, options:nil)
            return comp.month
        case .Day:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitDay,
                fromDate: date1, toDate: date2, options:nil)
            return comp.day
        case .Hour:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitHour,
                fromDate: date1, toDate: date2, options:nil)
            return comp.hour
        case .Minute:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitMinute,
                fromDate: date1, toDate: date2, options:nil)
            return comp.minute
        case .Second:
            var comp: NSDateComponents =
            calendar.components(NSCalendarUnit.CalendarUnitSecond,
                fromDate: date1, toDate: date2, options:nil)
            return comp.second
        default:
            return 0
        }
    }
    

    // 指定の時、分、秒に対応する時刻(NSDate)を返します
    // パラメータ
    //  hour : 時を0～23の整数型(Integer)で指定します
    //  minute : 分を整数型(Integer)で指定します
    //  second : 秒を整数型(Integer)で指定します
    //  各パラメータの値が範囲外のときはパラメータの値にしたがって加算されます
    //
    //        timeSerial(22,25,00)  // 10:25 PM
    //        timeSerial(11,-6,00)  // 10:54 AM
    class func timeSerial(hour: Int, minute: Int, second: Int) -> NSDate {
        var comp = NSDateComponents()
        comp.hour = hour
        comp.minute = minute
        comp.second = second
        var cal = NSCalendar.currentCalendar()
        var time = cal.dateFromComponents(comp)
        return time!
    }
    
    
    class func apartFromNSDate(interval: Interval, date :NSDate) -> Int {

        let calendar = NSCalendar.currentCalendar()
        let component :NSDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        
        switch interval {
        case .Year:
            return component.year
        case .Month:
            return component.month
        case .Day:
            return component.day
        case .Hour:
            return component.hour
        case .Minute:
            return component.minute
        case .Second:
            return component.second
        default:
            return 0
        }
    }
    
    class func apartFromNSDateStr(interval: Interval, date :NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let component :NSDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        
        switch interval {
        case .Year:
            return String(component.year)
        case .Month:
            return String(format:"%02d", component.month)
        case .Day:
            return String(format:"%02d", component.day)
        case .Hour:
            return String(format:"%02d", component.hour)
        case .Minute:
            return String(format:"%02d", component.minute)
        case .Second:
            return String(format:"%02d", component.second)
        default:
            return ""
        }
    }
    
    
    // 分の単位をくり上げる
    class func moveupMinits(date :NSDate, minInterval :Int) -> NSDate {
        
        let orgMin = apartFromNSDate(.Minute, date: date)
        let reminder = orgMin % minInterval
        
        if (reminder != 0) {
            
            let dateNew = dateAdd(.Minute, number: (minInterval - reminder), date: date)
            return dateNew
        } else {
        
            return date
        }
    }
    
    
    // 指定時間までの秒数の取得
    class func toDesignatedTime(alarmHour :Int, alarmMin :Int) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        let calendar = NSCalendar.currentCalendar()
        
        // NSDateはGMTで日時を管理
        let now = NSDate()
        NSLog("now == " + dateFormatter.stringFromDate(now))
        
        
        // 明日
        let tommorow :NSDate = calendar.dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: now, options: nil)!
        let compoTommorow :NSDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: tommorow)
        NSLog("tommorow == " + dateFormatter.stringFromDate(tommorow))
        
        // 明日orあさっての起床時間（仮）
        var designateTime = calendar.dateBySettingHour(alarmHour, minute: alarmMin, second: 0, ofDate: tommorow, options: nil)
        NSLog("designateTime == " + dateFormatter.stringFromDate(designateTime!))

        
        // 今と起床時間（仮）までの差を秒単位で取得
        var diff = dateDiff(.Second, date1: now, date2: designateTime!)
        NSLog("1day（second） == " + "\(24 * 3600)")
        NSLog("diff（second） == " + "\(diff)")
        
        
        // 明日になるように調整
        while (diff > 24 * 3600) {
            
            diff = diff - 24 * 3600
            designateTime = calendar.dateByAddingUnit(.CalendarUnitDay, value: -1, toDate: designateTime!, options: nil)
            NSLog("designateTime（調整済み） == " + dateFormatter.stringFromDate(designateTime!))
        }
        
        return designateTime!
    }

    
    // 指定時間までの秒数の取得
    class func toDesignatedTime_second(alarmHour :Int, alarmMin :Int) -> Int {

        let now = NSDate()
        let designateTime = toDesignatedTime(alarmHour, alarmMin: alarmMin)
        
        // 今と起床時間（仮）までの差を秒単位で取得
        var diff = dateDiff(.Second, date1: now, date2: designateTime)
        NSLog("1day（second） == " + "\(24 * 3600)")
        NSLog("diff（second） == " + "\(diff)")
        
        
        // 明日になるように調整
        while (diff > 24 * 3600) {
            
            diff = diff - 24 * 3600
        }
        
        return diff
    }
    
    
    
}

