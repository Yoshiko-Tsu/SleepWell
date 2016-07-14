//
//  HelpViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/27.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


class HelpViewController: UIViewController {

    @IBOutlet var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orgView: UIView!
    
    
    var myHelpData :HelpData!
    var setHelpDataFlg = false
    var viewList :[MyHelpView] = []
    var setFlg = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backgroundImage  = UIImage(named: "BackGround")
        backView.backgroundColor = UIColor(patternImage: backgroundImage!)
        scrollView.backgroundColor = UIColor.clearColor()
        orgView.backgroundColor = UIColor.clearColor()
        
        
        var pointY: CGFloat = 0.0
        
        // FAQ画面は、ECSlidingSegueで繋がっているため、データの受け渡しをしていない
        if (setHelpDataFlg == false) {
            
            myHelpData = faqData
        }
        
        for data in myHelpData.lists {
            
            var oneView = MyHelpView.instance()
            oneView.config(data)
            oneView.backgroundColor = UIColor.clearColor()
            
            orgView.addSubview(oneView)
            viewList.append(oneView)
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        if (setFlg == false) {
            
            setScroll()
        }
    }
    
    
    func setScroll() {

        setFlg = true
        
        
        let bounds = backView.bounds       // 現在の画面の大きさ

        var viewHeightList :[CGFloat] = []

        // 先に高さのみ計算
        var allHeight: CGFloat = 0.0
        for oneView in viewList {
            
            let viewHeight = oneView.calcViewHeight(bounds.width)
            allHeight = allHeight + viewHeight
            
            viewHeightList.append(viewHeight)
        }
        // 大きさ決定
        orgView.frame = CGRectMake(0, 0, bounds.width, allHeight)

        
        // AutoLayout解除
        orgView.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        // 各viewの大きさ調整
        var pointY: CGFloat = 0.0
        for (i, oneView) in enumerate(viewList) {
            
            oneView.frame = CGRectMake(0, pointY, bounds.width, viewHeightList[i])
            pointY = pointY + viewHeightList[i]

        }

        //　実際の画面の大きさ（ナビゲーションバーの大きさ分ちいさい）
        let screenHeight = bounds.height - 64.0
        
        if (screenHeight > pointY) {
        
            scrollView.scrollEnabled = false
        } else {
            
            scrollView.scrollEnabled = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
