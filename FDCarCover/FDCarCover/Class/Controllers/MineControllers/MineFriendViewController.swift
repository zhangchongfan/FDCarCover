//
//  MineFriendViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineFriendViewController: MineBaseViewController {
    lazy var friendTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Width, height: Height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的好友"
        setFriendViewControllerUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfile()
    }
    
    func setFriendViewControllerUI() {
        view.addSubview(friendTableView)
        let rightNaviBtn = UIButton(type: .custom)
        rightNaviBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightNaviBtn.contentMode = .scaleAspectFill
        rightNaviBtn
            .setImage(UIImage(named:"add"), for: .normal)
        rightNaviBtn.addTarget(self, action: #selector(addFriend(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBtn)
    }
    
    func updateProfile() {
        //每次进来刷新下数据
        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }else {
            FDServerManager.share()?
                .getProfileWithParams(getInfoParams(), success: { [weak self] (response) in
                    self?.handleProfileResult(response)
                    }, failre: {[weak self] in
                        MBProgressHUD
                            .fd_show(withText: "獲取資訊失敗", mode: .text, add: self?.view)
                })
        }
    }
    
    func getInfoParams() -> [String : Any] {
        return [AccountKey: FDAcountInfo.lastLoginAccout() ?? "", CarTypeKey: "1"]
    }
    
    func handleProfileResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD
                .fd_show(withText: "獲取資訊失敗", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            //把更新的信息归档到本地
            accountInfo.updateProfile(data)
            accountInfo
                .archive(FDAcountInfo.lastLoginAccout()!)
            friendTableView.isHidden = accountInfo.friends?.count == 0
            MBProgressHUD
                .fd_show(withText: "獲取資訊成功", mode: .text, add: self.view)
            friendTableView.reloadData()
        }else {
            MBProgressHUD
                .fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
        
    }
    
    @objc func addFriend(_ sender: UIButton) {
        navigationController?
            .pushViewController(MineAddFriendViewController(nibName: "MineAddFriendViewController", bundle: Bundle.main), animated: true)
    }
    
}

extension MineFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountInfo.friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell?.accessoryType = .disclosureIndicator
            let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            lable.tag = 1
            lable.textAlignment = .right
            cell?.accessoryView = lable
        }
        let model = accountInfo.friends![indexPath.row]
        
        cell?.textLabel?.text = model.nick ?? model.account
        cell?.detailTextLabel?.text = (model.addstate == "3" && model.friendagree == "1" && model.meagree == "1") ? "你可以接受好友的車罩資訊" : "你當前不能接受好友的車罩資訊"
        let label = cell?.contentView.viewWithTag(1) as! UILabel
        if model.addstate == "3" {
            label.text = "已添加"
        }else if model.addstate == "2" {
            label.text = "等待對方同意"
        }else if model.addstate == "1" {
            label.text = "等待您接受"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: MineManagerFriendController = MineManagerFriendController()
        vc.friendModel = accountInfo.friends![indexPath.row]
        navigationController?
            .pushViewController(vc, animated: true)
    }
    
}
