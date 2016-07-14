//
//  SelectSoundViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/07.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit
import AVFoundation


// 音源選択画面
class SelectSoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {

    @IBOutlet var allView: UIView!
    @IBOutlet weak var headerView: SelectSoundHeaderView!
    @IBOutlet weak var tableView: UITableView!

    var myData :MyData!
    var soundSource = SoundSource.sharedInstance
    var selectType :SelectSoundType = SelectSoundType.NONE
    var soundType :SoundType = SoundType.NONE
    var oneList :PlayList?
    var selectSound :PlayList?
    var localPlayList :PlayList!
    var sounds :[SoundInfo]!
    var cellHeights = Dictionary<Int, CGFloat>()

    @IBOutlet weak var SoundAndVoice: UIButton!
    var myAudioPlayer :MyAudioPlayer!
    var nowPlaying :AudioButton?
    var playingIndex = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()


        let backgroundImage  = UIImage(named: "BackGround")
        allView.backgroundColor = UIColor(patternImage: backgroundImage!)
        tableView.backgroundColor = UIColor.clearColor()
        headerView.configure()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        myAudioPlayer = MyAudioPlayer()

        
        if (selectType == .PLAYLIST) {
            localPlayList = oneList
        } else {
            localPlayList = selectSound
        }
        
        switch (soundType) {
        case .CLASSIC:
            sounds = soundSource.Classic
            self.navigationItem.title = "クラシック"
        case .SOUND:
            sounds = soundSource.Sound
            self.navigationItem.title = "サウンド"
        case .VOICE:
            sounds = soundSource.Voice
            self.navigationItem.title = "癒やしのボイス"
        case .ALARM:
            sounds = soundSource.Alarm
            self.navigationItem.title = "アラーム音"
            SoundAndVoice.setTitle("　アラーム音選択", forState: .Normal)
        default:
            break
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (soundType != .ALARM) {
            myData.save()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // TableViewを表示した時、一番下にスクロールしてしまうので
        // 先頭にスクロールする
        let section = NSIndexSet(index: 0)
        tableView.reloadSections(section, withRowAnimation: UITableViewRowAnimation.None)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func touchUpAudioButton(sender: AnyObject) {

        let pushButton = (sender as! AudioButton)
        
        if (nowPlaying == nil) {
            
            // Play
            nowPlaying = pushButton
            playingIndex = nowPlaying!.tag
            myAudioPlayer.setSound(sounds[playingIndex].fileName)
            myAudioPlayer.audioPlayer.delegate = self
            myAudioPlayer.play()
            pushButton.playNow()
        } else {
            
            // 押されたボタンと以前押されたボタンが同じか？
            if (pushButton == nowPlaying) {
                
                // Stop
                myAudioPlayer.stop()
                pushButton.stopNow()
                nowPlaying = nil
                playingIndex = -1
            } else {
                
                // Stop & Play
                myAudioPlayer.stop()
                nowPlaying!.stopNow()
                nowPlaying = pushButton
                
                playingIndex = nowPlaying!.tag
                myAudioPlayer.setSound(sounds[playingIndex].fileName)
                myAudioPlayer.audioPlayer.delegate = self
                myAudioPlayer.play()
                nowPlaying!.playNow()
            }
            
        }
    }
    
    
    @IBAction func valueChangedVolume(sender: AnyObject) {

        let volume = sender as! UISlider
        myAudioPlayer.setVolume(volume.value)
    }
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sounds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectSoundPrototypeCell", forIndexPath: indexPath) as! SelectSoundTableViewCell
        
        if (playingIndex == indexPath.row) {
            // play中
            cell.configureCell(sounds[indexPath.row], selected: true, index: indexPath.row)
        } else {
            cell.configureCell(sounds[indexPath.row], selected: false, index: indexPath.row)
        }
        
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        //cellHeights[indexPath.row] = cell.calcHeight()
        
        
        let bVal = localPlayList!.findSound(sounds[indexPath.row])
        if (bVal) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
//    // 行の高さを変える
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        if (cellHeights[indexPath.row] == nil) {
//            return CGFloat(0)
//        }
//        return cellHeights[indexPath.row]!
//    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selCell = tableView.cellForRowAtIndexPath(indexPath)
        let selId = indexPath.row

        let isCheck = localPlayList!.findSound(sounds[selId])
        
        if (selectType == .ONE_SOUND) {
            
            // サウンド設定時
            // 前の曲の選択を解除
            if (localPlayList!.soundList.isEmpty == false) {
                
                for (i, one) in enumerate(sounds) {
                    if (localPlayList!.soundList[0].id == one.id) {
                        
                        let oldNSIndex = NSIndexPath(forRow: i, inSection: 0)
                        let oldCell = tableView.cellForRowAtIndexPath(oldNSIndex)
                        oldCell?.accessoryType = .None
                    }
                }
                
                localPlayList.soundList.removeAll(keepCapacity: false)
            }
            
            localPlayList!.soundList.append(sounds[selId])
            selCell!.accessoryType = .Checkmark
            if (soundType != .ALARM) {
                myData.sleepSound_type = .ONE_SOUND
            }
            
        } else {

            // PlayList設定時
            if (isCheck == false) {
                
                //　localPlayListにない　→　追加
                if (localPlayList!.soundList.count == MAX_SOUNDS_NUM) {
                    
                    var alert = UIAlertView()
                    alert.title = "ご注意"
                    alert.message = "プレイリストに登録できる数は最大で\(MAX_SOUNDS_NUM)までです。\nそれ以降で選択をし直す場合は、現在選択しているものの中から１つを解除して、新たなサウンドを選択してください。"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    
                } else {
                    selCell!.accessoryType = .Checkmark
                    localPlayList!.soundList.append(sounds[selId])
                }
            } else {
                
                //　localPlayListにある　→　削除
                let nowIndx = localPlayList!.getIndexNo(sounds[selId])
                localPlayList!.soundList.removeAtIndex(nowIndx)
                selCell!.accessoryType = .None
            }
            myData.sleepSound_type = .PLAYLIST
        }
        
    }
    
    // AVAudioPlayerDelegate
    // 再生終了時処理
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        NSLog("SelectSoundViewController::audioPlayerDidFinishPlaying")
        
        if (nowPlaying != nil) {

            // Stop
            myAudioPlayer.stop()
            nowPlaying!.stopNow()
            nowPlaying = nil
            playingIndex = -1
        }
        
    }
    
}
