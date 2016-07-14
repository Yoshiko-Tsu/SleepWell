//
//  BlueView.swift
//  ECSwiftSlidingViewController
//
//  Created by 鶴田義子 on 2015/07/29.
//  Copyright (c) 2015年 Mihael Isaev inc. All rights reserved.
//

import UIKit

class BlurView: UIView {

    var topView :UIView!
    var myBlurView :UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    

    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
    }
    
    func blurViewController(topView :UIView) {
        
        self.topView = topView
         //NSLog("X: %f", topView.frame.origin.x)
        
        if (topView.frame.origin.x >= 15) {
            setBlurView(topView.frame.origin.x)
        } else {
            deleteBlurView()
        }
    }

    
    func setBlurView(offset :CGFloat) {
        
        if (myBlurView == nil) {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            myBlurView = UIVisualEffectView(effect: blurEffect)
            myBlurView.frame = topView.bounds
            //myBlurView.alpha = 0.1
            topView.addSubview(myBlurView)
        }
        
    }
    
    func deleteBlurView() {
        
        if (myBlurView != nil) {
            myBlurView.removeFromSuperview()
            myBlurView = nil
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
}
