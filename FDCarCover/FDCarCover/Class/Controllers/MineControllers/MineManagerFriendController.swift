//
//  MineManagerFriendController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineManagerFriendController: UIViewController {

    var friendModel: FDFriendModel = FDFriendModel()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: 15, width: Width - 40, height: 45)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        btn.setBackgroundImage(UIImage(named: "confirm_btn"), for: .normal)
        btn.addTarget(self, action: #selector(saveFriendAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var mineTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 75))
        tableView.tableFooterView = footView
        footView.addSubview(saveBtn)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "好友設定"
        setMineManagerFriendControllerUI()
    }
    
    func setMineManagerFriendControllerUI() {
        saveBtn.setTitle(friendModel.addstate == "3" ? "確認修改" : "添加好友", for: .normal)
    }

    @objc func saveFriendAction(_ sender: UIButton) {
    
    }
}

extension MineManagerFriendController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = ["好友账号","好友昵称","好友车罩信息是否对我公开","好友接收我的車罩通知","我接收好友的車罩通知"]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = titles[indexPath.row]
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = friendModel.account
        }else if indexPath.row == 1 {
            cell.detailTextLabel?.text = friendModel.nick
        }else if indexPath.row == 2 {
            cell.detailTextLabel?.text = friendModel.friendagree == "1" ? "是" : "否"
        }else if indexPath.row == 3 {
            let agreeSwitch = UISwitch()
            agreeSwitch.isOn = friendModel.meagree == "1"
            cell.accessoryView = agreeSwitch
        }else if indexPath.row == 4 {
            let agreeSwitch = UISwitch()
            agreeSwitch.isOn = friendModel.mesend == "1"
            cell.accessoryView = agreeSwitch
        }
        
        return UITableViewCell()
    }
    
}
