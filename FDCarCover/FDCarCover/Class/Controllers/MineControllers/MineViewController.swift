//
//  MineViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    lazy var dataSource: [String] = {
        let array = ["我的昵稱","我的IMEI碼","我的好友",]
        return array
    }()
    
    lazy var mineTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 75))
        tableView.tableFooterView = footView
        
        let exitBtn = UIButton(type: .custom)
        exitBtn.frame = CGRect(x: 20, y: 15, width: Width - 40, height: 45)
        exitBtn.setTitle("登 出", for: .normal)
        exitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        exitBtn.setBackgroundImage(UIImage(named: "confirm_btn"), for: .normal)
        exitBtn.addTarget(self, action: #selector(exitAction(_:)), for: .touchUpInside)
        footView.addSubview(exitBtn)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "設定"
        setMineViewControllerUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mineTableView.reloadData()
    }
    
    func setMineViewControllerUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(mineTableView)
    }
    
    //退出登录
    @objc func exitAction(_ sender: UIButton) {
        if FDBleManage.shareManager.connected {
            MBProgressHUD.fd_show(withText: "請先解綁設備", mode: .text, add: view)
            return
        }
        UserDefaults.standard.removeObject(forKey: FDLastAutoLogin)
        UserDefaults.standard.synchronize()
        FDPeripherModel.notAutoConnect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            AppDelegate.shareDelegate()
                .setLoginForRoot()
        }
    }

}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        
        let accountInfo: FDAcountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)!
        if indexPath.row == 0 {
            cell?.detailTextLabel?.text = accountInfo.nick
        }else if indexPath.row == 1 {
            let imeis = accountInfo.imeis ?? []
            if imeis.count > 0 {
                cell?.detailTextLabel?.text = imeis[0]
            }else {
                cell?.detailTextLabel?.text = "未綁定"
            }
        }else if indexPath.row == 2 {
            if let friends = accountInfo.friends {
                cell?.detailTextLabel?.text = "\(friends.count)人"
            }else {
                cell?.detailTextLabel?.text = "0人"
            }
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc: UIViewController = MineNickViewController(nibName: "MineNickViewController", bundle: Bundle.main)
        if indexPath.row == 1 {
            vc = MineImeiViewController(nibName: "MineImeiViewController", bundle: Bundle.main)
        }else if indexPath.row == 2 {
            vc = MineFriendViewController(nibName: "MineFriendViewController", bundle: Bundle.main)
        }
        navigationController?
            .pushViewController(vc, animated: true)
    }
    
}
