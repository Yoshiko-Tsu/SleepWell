//
//  PlayListViewController.swift
//  PleasantSleep
//
//  Created by 鶴田義子 on 2015/07/02.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// プレイリスト画面
class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var allView: UIView!
    @IBOutlet weak var tableView: SBGestureTableView!
    var myAddButton: UIBarButtonItem!
    var trashIcon :UIImage!
    let selectImage = UIImage(named: "Playlist_Select")
    let selectedImage = UIImage(named: "Playlist_Selected")
    
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!

    var myData :MyData!
    var preSelected: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backgroundImage  = UIImage(named: "BackGround")
        allView.backgroundColor = UIColor(patternImage: backgroundImage!)
        tableView.backgroundColor = UIColor.clearColor()

        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        // ナビゲーションバーの右ボタンを作成
        let addIcon = UIImage(named:"ic_add")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        myAddButton = UIBarButtonItem(image: addIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "addPlayList:")
//        // Barの右に配置するボタンを配列に格納する.
//        let myRightButtons = [myHelpButton, myAddButton]
//        // Barの右側に複数配置する.
//        self.navigationItem.setRightBarButtonItems(myRightButtons as [AnyObject]?, animated: false)
        self.navigationItem.rightBarButtonItem = myAddButton
        
        
        trashIcon = UIImage(named:"ic_delete_white")?.imageWithRenderingMode(
            UIImageRenderingMode.AlwaysTemplate)

        tableView.didMoveCellFromIndexPathToIndexPathBlock = {(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void in
            
            // NSMutableArray : 読み書きOK（参照型）
            // Array : （非参照型）
            var nsMuArray = NSMutableArray(array: self.myData.playLists)
            nsMuArray.exchangeObjectAtIndex(toIndexPath.row, withObjectAtIndex: fromIndexPath.row)
            self.myData.playLists = Array(nsMuArray) as! [PlayList]
        }
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            // 選択中のindexを修正
            if (self.myData.sleep_selectedIndex >= 0) {
                
                if(self.myData.sleep_selectedIndex == indexPath?.row) {
                    
                    self.myData.sleep_selectedIndex = -1
                } else if (self.myData.sleep_selectedIndex > indexPath?.row) {
                        
                    self.myData.sleep_selectedIndex = self.myData.sleep_selectedIndex -  1
                }
            }
            self.myData.playLists.removeAtIndex(indexPath!.row)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
    
        preSelected = myData.sleep_selectedIndex

        
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
    }

    
    @IBAction func touchUpInside_selectButton(sender: AnyObject) {
        
        NSLog("PlayListViewController::touchUpInside_selectButton")
        
        let button = sender as! UIButton
        let index = button.tag
        
        if (myData.playLists[index].soundList.count == 0) {
            
            var alert = UIAlertView()
            alert.title = "ご注意"
            alert.message = "このプレイリストには、音源が設定されていませんので、選択できません。"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        
        // 選択したindexを保存
        myData.sleep_selectedIndex = index
        myData.sleepSound_type = .PLAYLIST
        button.setImage(selectedImage, forState: .Normal)

        if (preSelected >= 0) {
            
            // 現在選択中を解除
            let selectNSIndex = NSIndexPath(forRow: preSelected, inSection: 0)
            let selectCell = tableView.cellForRowAtIndexPath(selectNSIndex) as! PlayListTableViewCell
            selectCell.selectButton.setImage(selectImage, forState: .Normal)
        }
        
        preSelected = index
        tableView.reloadData()
    }
    
    
    
    func addPlayList(sender: AnyObject) {
        
        if (myData.playLists.count == MAX_PLAYLIST_NUM) {
            
            var alert = UIAlertView()
            alert.title = "ご注意"
            alert.message = "プレイリストの数は最大\(MAX_PLAYLIST_NUM)つまでです。\nそれ以降は、既に作成したプレイリストを編集してご使用ください。"
            alert.addButtonWithTitle("OK")
            alert.show()
            
        } else {
            var newPlayList = PlayList()
            newPlayList.makeNew(myData.playLists.count + 1)
            myData.playLists.append(newPlayList)
            
            let newIndexPath = NSIndexPath(forRow: myData.playLists.count - 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myData.playLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayListPrototypeCell", forIndexPath: indexPath) as! PlayListTableViewCell
        
        cell.rightAction = SBGestureTableViewCellAction(icon: trashIcon, color: UIColor.redColor(), fraction: 0.3, didTriggerBlock: removeCellBlock)
        
        if (myData.sleep_selectedIndex == indexPath.row) {
            // 選択中
            cell.configureCell(myData.playLists[indexPath.row], selected: true, index: indexPath.row)
        } else {
            cell.configureCell(myData.playLists[indexPath.row], selected: false, index: indexPath.row)
        }

        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue  segue.identifier == \(segue.identifier)")
        
        if (segue.identifier == "editPlayListID") {
            
            // データ保存
            myData.save()
            
            let nav = segue.destinationViewController as! UINavigationController
            let nextViewController = nav.topViewController as! EditPlayListViewController
            
            let cell = sender as? PlayListTableViewCell
            let index: NSIndexPath = self.tableView.indexPathForCell(cell!)!
            nextViewController.myData = myData
            nextViewController.index = index.row
        }
        
    }

}
