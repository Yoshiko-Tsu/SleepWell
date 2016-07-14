//
//  MenuTableViewController.swift
//  SleepWell
//
//  Created by 鶴田義子 on 2015/07/23.
//  Copyright (c) 2015年 Yoshiko Tsuruta. All rights reserved.
//

import UIKit


// メニュー
class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 空行のセパレータを消す
        var v:UIView = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = super.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()

        return cell
    }

}
