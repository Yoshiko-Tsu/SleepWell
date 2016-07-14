//
//  MyVibration.swift
//  Vibrate
//
//  Created by 鶴田義子 on 2015/07/31.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import AudioToolbox


class MyVibration: NSObject {
   
    var functionPointer: AudioServicesCompletionFunctionPointer?
    let soundIdRing = SystemSoundID(kSystemSoundID_Vibrate)

    
    override init() {
        super.init()
        
    }
    
    func vibrationStart() {
        
        var vself = self
        let userData = withUnsafePointer(&vself, {
            (ptr: UnsafePointer<MyVibration>) -> UnsafeMutablePointer<Void> in
            
            return unsafeBitCast(ptr, UnsafeMutablePointer<Void>.self)
        })
        
        self.functionPointer = AudioServicesCompletionFunctionPointer(systemSoundID: soundIdRing,
            block: {(systemSoundID: SystemSoundID, userData: UnsafeMutablePointer<Void>) -> () in
                // sound has ended, do your stuff here
                NSThread.sleepForTimeInterval(0.5)
                AudioServicesPlaySystemSound(self.soundIdRing)
            
            }, userData: userData)
        
        
        AudioServicesAddSystemSoundCompletion(soundIdRing, CFRunLoopGetMain(), kCFRunLoopCommonModes, AudioServicesCompletionFunctionPointer.completionHandler(), userData)

        AudioServicesPlaySystemSound(soundIdRing)
        
    }
    
    func vibrationStop() {
        
        AudioServicesRemoveSystemSoundCompletion(self.soundIdRing)
    }
    
    
}
