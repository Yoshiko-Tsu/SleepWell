//
//  MyHelpView.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/27.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


let fontSize_Question = 18
let fontSize_Anser = 14

class MyHelpView: UIView {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var anserTextView: UITextView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var constraint_viewTop_questioTop: NSLayoutConstraint!
    @IBOutlet weak var constraint_questioBottom_lineTop: NSLayoutConstraint!
    @IBOutlet weak var constraint_lineBottom_anserTop: NSLayoutConstraint!
    @IBOutlet weak var constraint_anserBottom_viewBottom: NSLayoutConstraint!

    
    @IBOutlet weak var constraint_questionHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_anserHeight: NSLayoutConstraint!
    
    
    class func instance() -> MyHelpView {
        
        return UINib(nibName: "MyHelpView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MyHelpView
    }
    
    
    func config(data :HelpFormatStruct) {
        
        questionTextView.text = data.question
        anserTextView.text = data.anser
        
        // 色の設定など
        questionTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize_Question))
        questionTextView.textAlignment = NSTextAlignment.Left
        questionTextView.editable = false
        
        anserTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize_Anser))
        anserTextView.textAlignment = NSTextAlignment.Left
        anserTextView.editable = false

    }
    
    func calcViewHeight(width :CGFloat) -> CGFloat {

        // 質問エリア
        var oldText1 = questionTextView.text
        oldText1 = oldText1 + "\r"      // 多分、高さ計算が正確でないのだと思う
        let questioHeight = heightForStringDrawing(oldText1, font: UIFont.systemFontOfSize(CGFloat(fontSize_Question)), myWidth: width)
        
        questionTextView.text = ""

        questionTextView.frame = CGRectMake(0, 0, width, CGFloat.max)
        questionTextView.text = oldText1
        questionTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize_Question))
        questionTextView.textColor = UIColor.whiteColor()
        questionTextView.backgroundColor = UIColor.clearColor()

        questionTextView.frame = CGRectMake(0, 0, width, questioHeight)
        

        // 答えエリア
        // 高さを計算
        var oldText2 = anserTextView.text
        if (!oldText2.hasSuffix("\r")) {

            oldText2 = oldText2 + "\r\r"
        } else {

            oldText2 = oldText2 + "\r"
        }
        let anserHeight = heightForStringDrawing(oldText2, font: UIFont.systemFontOfSize(CGFloat(fontSize_Anser)), myWidth: width)
        
        // textの再設定
        anserTextView.text = ""
        
        anserTextView.frame = CGRectMake(0, 0, width, CGFloat.max)
        anserTextView.text = oldText2
        anserTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize_Anser))
        anserTextView.textColor = UIColor.whiteColor()
        anserTextView.backgroundColor = UIColor.clearColor()
        
        anserTextView.frame = CGRectMake(0, 0, width, anserHeight)
        

        let question_Height = questionTextView.frame.height
        let anser_Height = anserTextView.frame.height
        constraint_questionHeight.constant = question_Height
        constraint_questionHeight.priority = 750
        constraint_anserHeight.constant = anser_Height
        constraint_anserHeight.priority = 750
        
        let height = constraint_viewTop_questioTop.constant +
            question_Height +
            constraint_questioBottom_lineTop.constant +
            constraint_lineBottom_anserTop.constant +
            anser_Height +
            constraint_anserBottom_viewBottom.constant
        
        return height
    }

    
    func heightForStringDrawing(myString: String, font :UIFont, myWidth: CGFloat) -> CGFloat
    {
        var myString2 = myString
        let textStorage = NSTextStorage(string: myString2)
        textStorage.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, textStorage.length))

//        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
//        textStyle.lineBreakMode = .ByWordWrapping
//        let textFontAttributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: textStyle]
//        textStorage.addAttributes(textFontAttributes, range: NSMakeRange(0, textStorage.length))
        
        var textContainer = NSTextContainer(size: CGSizeMake(myWidth, CGFloat.max))
        var layoutManager = NSLayoutManager()

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.glyphRangeForTextContainer(textContainer)
        let height = layoutManager.usedRectForTextContainer(textContainer).size.height

        
        return height
    }
    
}
