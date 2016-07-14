//
//  HelpData.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/27.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import Foundation


enum HelpFormatType: Int
{
    case NONE = 0
    case ITEM_2 = 1
    case ITEM_3 = 2
}

struct HelpFormatStruct {
    
    var item :String?
    var question :String!
    var anser :String!
    
    init(item :String?,
        question :String!,
        anser :String!) {
            
            if (item != nil) {
                self.item = item
            }
            self.question = question
            self.anser = anser
            
    }
}


class HelpData :NSObject {
    
    var title :String!
    var type :HelpFormatType
    var lists :[HelpFormatStruct]!
    
    
    override init() {
        title = ""
        type = .NONE
        lists = []
        
        super.init()
    }
    
    
    func readData(fileName :String) -> [Dictionary<String, String>] {
        
        let filePath :String = NSBundle.mainBundle().pathForResource(fileName, ofType: "csv")!
        let data = CsvFile.readToString(filePath)
        
        var body :[Dictionary<String, String>] = []
        body = splitData(data)
        
        return body
    }
    
    func splitData(data :String) -> [Dictionary<String, String>] {
        
        var lines :[[String]] = []
        var i = 0
        var keyCount = 0
        data.enumerateLines { (line, stop) -> () in
            //println(line)
            let item: [String] = split( line, allowEmptySlices: true, isSeparator: { $0 == "," } )
            //println(item)
            
            if (i == 0) {
                // Key行
                keyCount = item.count
            }
            
            if (item.count < keyCount) {
                
                // データが途中で切れている可能性がある
                var preline = lines.removeLast()
                var lastData = preline.removeLast()
                
                if (item != []) {
                    lastData = lastData + "\r" + item.first!
                } else {
                    lastData = lastData + "\r"
                }
                //println(lastData)
                preline.append(lastData)
                lines.append(preline)
            } else {
                
                lines.append(item)
            }
            
            i++
        }
        
        
        // ヘッダーからキーを取得
        let keys :[String] = lines.first!
        lines.removeAtIndex(0)
        
        
        // ボディ
        var body :[Dictionary<String, String>] = []
        for oneLine in lines {
            
            var indx = 0
            var oneDict: [String: String] = Dictionary()
            for cell in oneLine {
                
                var str = cell
                
                // もともとのデータが、”"で囲まれている可能性がある
                if (cell.hasPrefix("\"")) {
                    
                     str = str.substringFromIndex(advance(str.startIndex,1))
                    let len = count(str)
                    str = str.substringToIndex(advance(str.startIndex, len - 1))
                }
                
                oneDict[keys[indx]] = str
                indx++
            }
            
            body.append(oneDict)
        }
        
        return body
    }
    
    
    func makeData(fileName :String) {
        
        let dictData :[Dictionary<String, String>] = readData(fileName)
        
        var type :HelpFormatType = .NONE
        if (fileName == "FAQ") {
            self.type = .ITEM_3
        } else {
            self.type = .ITEM_2
        }
        self.title = fileName
        
        for data in dictData {
            
            var help = HelpFormatStruct(item: data["item"], question: data["question"], anser: data["anser"])
            lists.append(help)
        }
    }
        
}

