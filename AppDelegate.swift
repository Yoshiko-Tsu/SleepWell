//
//  AppDelegate.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/02.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import AVFoundation


var helpData :HelpData!
var faqData :HelpData!
var playlistData :HelpData!


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 古いログファイル削除
        Log.checkAndDeleteLog()
        
        // ログファイル名セット
        Log.setFile()

        
        // スプラッシュの表示時間を伸ばす
        sleep(2)
        
        UserInfo.getIosVersion()
        UserInfo.getIosDevice()
        let ver = UserInfoLocalStorage.loadIosVersion()
        let dev = UserInfoLocalStorage.loadIosDevice()
        NSLog("iosVersion == \(ver)")
        NSLog("iosDevice == \(dev)")
        
        
        // ヘルプデータ他読み込み
        helpData = HelpData()
        helpData.makeData("Help")
        faqData = HelpData()
        faqData.makeData("FAQ")
        playlistData = HelpData()
        playlistData.makeData("PlayList")

        
        // 音源データ読み込み
        let soundSource :SoundSource = SoundSource.sharedInstance
        soundSource.makeData()
        
        
        // スリープタイマーの無効化
        UIApplication.sharedApplication().idleTimerDisabled = true
        NSLog("スリープタイマーの無効化［AppDelegate::didFinishLaunchingWithOptions］")
        
        // play Background
        let audioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &error)
        audioSession.setActive(true, error: nil)
        
        
        // iPhone 5s, iPod touch 5G --> 4 inch(640 x 1136)(320 x 568)
        // iPhone 6 --> 4.7 inch(750 x 1334)(375 x 667)
        // iPhone 6 Plus --> 5.5 inch(1080 x 1920)downsampling<--(1242 x 2208)(414 x 736)
        
        //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let display = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: display)
        var storyboard = UIStoryboard()
        if (UserInfo.is_iPhone6Plus()) {
            
            storyboard = UIStoryboard(name: "iPhone6Plus", bundle: nil)
        } else {
            
            if (UserInfo.is_iPhone6()) {
                
                storyboard = UIStoryboard(name: "iPhone6", bundle: nil)
            } else {
                
                storyboard = UIStoryboard(name: "iPhone5s", bundle: nil)
            }
        }
        let nextViewController = storyboard.instantiateInitialViewController() as! ECSlidingViewController
        
        self.window?.rootViewController = nextViewController
        self.window?.makeKeyAndVisible()

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        NSLog("アプリ閉じそうな時に呼ばれる")
        UIApplication.sharedApplication().idleTimerDisabled = true
        NSLog("スリープタイマーの無効化［AppDelegate::applicationWillResignActive］")
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        NSLog("フリックしてアプリを終了させた時に呼ばれる")
        UIApplication.sharedApplication().idleTimerDisabled = true
        NSLog("スリープタイマーの無効化［AppDelegate::applicationWillTerminate］")
    }


}

