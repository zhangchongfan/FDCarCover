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
    
    lazy var mesendSwitch: UISwitch = {
        let s = UISwitch()
        s.tag = 1
        s.addTarget(self, action: #selector(meagreeAction(_:)), for: .valueChanged)
        return s
    }()
    
    lazy var mereceiveSwitch: UISwitch = {
        let s = UISwitch()
        s.tag = 2
        s.addTarget(self, action: #selector(meagreeAction(_:)), for: .valueChanged)
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "好友設定"
        setMineManagerFriendControllerUI()
    }
    
    func setMineManagerFriendControllerUI() {
        saveBtn.setTitle(friendModel.addstate == "3" ? "確認修改" : "添加好友", for: .normal)
        view.addSubview(mineTableView)
    }

    @objc func meagreeAction(_ sender: UISwitch) {
        
    }
    
    @objc func saveFriendAction(_ sender: UIButton) {
        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }else {
            serverManager
                .friendmanager(withParams: friendManagerParams(), success: {[weak self] (response) in
                    self?.handleFriendManagerResult(response)
                    }, failre: {[weak self] in
                        MBProgressHUD
                            .fd_show(withText: "操作失敗", mode: .text, add: self?.view)
                })
        }
    }
    
    func friendManagerParams() -> [String : String] {
        return [AccountKey: FDAcountInfo.lastLoginAccout()!,
                FriendAccountKey: friendModel.account!,
                FriendOperationKey: friendModel.addstate == "1" ? "2" : "4",
                FriendMeSendKey: mesendSwitch.isOn ? "1" : "0",
                FriendMeReceiveKey: mereceiveSwitch.isOn ? "1" : "0",
                CarTypeKey: "1"]
        
    }
    
    
    func handleFriendManagerResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD
                .fd_show(withText: "操作失敗", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            //把更新的信息归档到本地
            MBProgressHUD
                .fd_show(withText: "操作成功", mode: .text, add: self.view)
            delay(1) {
                self.navigationController?
                    .popViewController(animated: true)
            }
        }else if status == "3" {
            MBProgressHUD
                .fd_show(withText: "好友帳號不存在", mode: .text, add: self.view)
        }else {
            MBProgressHUD
                .fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
        
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
        let titles = ["好友账号","好友昵称","好友车罩信息是否对我公开","允許好友接收我的車罩通知","允許我接收好友的車罩通知"]
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
            mesendSwitch.isOn = friendModel.mesend == "1"
            cell.accessoryView = mesendSwitch
        }else if indexPath.row == 4 {
            mereceiveSwitch.isOn = friendModel.meagree == "1"
            cell.accessoryView = mereceiveSwitch
        }
        
        return cell
    }
    
}
