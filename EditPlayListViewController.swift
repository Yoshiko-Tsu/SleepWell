//
//  EditPlayListViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/03.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// プレイリスト編集画面
class EditPlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    
    @IBOutlet var allView: UIView!
    @IBOutlet weak var tableView: SBGestureTableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var playListTitle_textField: UITextField!
    
    
    //let trashIcon = FAKIonIcons.iosTrashIconWithSize(48)
    var myHelpButton: UIBarButtonItem!
    var trashIcon :UIImage!
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    var showKeyboard = false

    var myData :MyData!
    var index :Int!
    var oneList :PlayList!
    var oldSoundCounts = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backgroundImage  = UIImage(named: "BackGround")
        allView.backgroundColor = UIColor(patternImage: backgroundImage!)
        tableView.backgroundColor = UIColor.clearColor()
        headerView.backgroundColor = UIColor.clearColor()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let helpImage = UIImage(named:"ic_help_white")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        myHelpButton = UIBarButtonItem(image: helpImage, style: UIBarButtonItemStyle.Plain, target: self, action: "pushMyHelp:")
        self.navigationItem.rightBarButtonItem = myHelpButton
        
        //
        myData.save()
        oneList = myData.playLists[index]
        
        playListTitle_textField.text = oneList.name
        playListTitle_textField.delegate = self
        playListTitle_textField.returnKeyType = UIReturnKeyType.Done

        
        // SBGestureTableView用設定
        //trashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        trashIcon = UIImage(named:"ic_delete_white")?.imageWithRenderingMode(
            UIImageRenderingMode.AlwaysTemplate)
        
        tableView.didMoveCellFromIndexPathToIndexPathBlock = {(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void in
            
            // NSMutableArray : 読み書きOK（参照型）
            // Array : （非参照型）
            var nsMuArray = NSMutableArray(array: self.oneList.soundList)
            nsMuArray.exchangeObjectAtIndex(toIndexPath.row, withObjectAtIndex: fromIndexPath.row)
            self.oneList.soundList = Array(nsMuArray) as! [SoundInfo]
            self.myData.save()
        }
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            self.oneList.soundList.removeAtIndex(indexPath!.row)
            self.myData.save()
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }

        // TableView高さ
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
    
        var keyboardToolbar = UIToolbar()
        keyboardToolbar.frame = CGRectMake(0, 0, allView.frame.width, 50)
        keyboardToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.Done, target: self, action: "resignKeyboard")],
            animated: false)
        playListTitle_textField.inputAccessoryView = keyboardToolbar
        
        // 空行のセパレータを消す
        var v:UIView = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v
        self.tableView.tableHeaderView = v
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        myData.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resignKeyboard() {

        playListTitle_textField.resignFirstResponder()
    }
    
    func pushMyHelp(sender: UIButton) {
        
        let nav = self.storyboard?.instantiateViewControllerWithIdentifier("nav_Help") as! UINavigationController
        let nextView = nav.topViewController as! HelpViewController
        nextView.setHelpDataFlg = true
        nextView.myHelpData = playlistData
        
        self.navigationController?.showViewController(nav, sender: nil)
    }

    
    // UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // カーソルの色を変更
        textField.tintColor = UIColor.blackColor()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text + string
        let num = count(str.utf16)
        if (num > 20) {
            let alert = UIAlertView()
            alert.title = "タイトルエラー"
            alert.message = "タイトルは20文字以内で入力してください。"
            alert.addButtonWithTitle("OK")
            alert.show()
            playListTitle_textField.text = textField.text
            return false
        } else {
            oneList.name = str
            self.myData.save()
            return true
        }
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        oneList.name = textField.text
        self.myData.save()
        return true
    }
    //
    

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return oneList.soundList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditPlayListPrototypeCell", forIndexPath: indexPath) as! EditPlayListTableViewCell
        
//        let size = CGSizeMake(48, 48)
//        cell.rightAction = SBGestureTableViewCellAction(icon: trashIcon.imageWithSize(size), color: UIColor.redColor(), fraction: 0.3, didTriggerBlock: removeCellBlock)
        cell.rightAction = SBGestureTableViewCellAction(icon: trashIcon, color: UIColor.redColor(), fraction: 0.3, didTriggerBlock: removeCellBlock)
        
        
        cell.configureCell(oneList.soundList[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue  segue.identifier == \(segue.identifier)");
        
        let nav = segue.destinationViewController as! UINavigationController
        let nextViewController = nav.topViewController as! SelectSoundViewController
        
        oldSoundCounts = oneList.soundList.count
        nextViewController.myData = myData
        nextViewController.oneList = oneList
        nextViewController.selectType = .PLAYLIST

        myData.sleepSound_type = .PLAYLIST
        
        if (segue.identifier == "selectClassicID") {
            
            nextViewController.soundType = SoundType.CLASSIC
            
        } else if (segue.identifier == "selectSoundID") {
            
            nextViewController.soundType = SoundType.SOUND
            
        } else if (segue.identifier == "selectVoiceID") {
            
            nextViewController.soundType = SoundType.VOICE
            
        }
    }

}
