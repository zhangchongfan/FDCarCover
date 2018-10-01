//
//  MainAddFriendViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineAddFriendViewController: MineBaseViewController {

    @IBOutlet weak var addFriendTaBleView: UITableView!
    
    let addFriendModel = FDAddFriendModel()
    
    lazy var addFriendTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 10, width: Width - 40, height: 40))
        textField.keyboardType = .numberPad
        textField.placeholder = "請輸入好友帳號"
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加好友"
        setAddFriendViewControllerUI()
    }

    func setAddFriendViewControllerUI() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 60))
        headerView.addSubview(addFriendTextField)
        headerView.backgroundColor = UIColor.white
        addFriendTaBleView.tableHeaderView = headerView
        
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: Width, height: 75))
        addFriendTaBleView.tableFooterView = footView
        
        let addBtn = UIButton(type: .custom)
        addBtn.frame = CGRect(x: 20, y: 15, width: Width - 40, height: 45)
        addBtn.setTitle("添 加", for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        addBtn.setBackgroundImage(UIImage(named: "confirm_btn"), for: .normal)
        addBtn.addTarget(self, action: #selector(addFriendAction(_:)), for: .touchUpInside)
        footView.addSubview(addBtn)
    }

    @objc func agreeAction(_ sender: UISwitch) {
        if sender.tag == 1 {
            addFriendModel.mesend = sender.isOn  ? "1" : "0"
        }else if sender.tag == 2 {
            addFriendModel.mereceive = sender.isOn  ? "1" : "0"
        }
    }
    
    @objc func addFriendAction(_ sender: UIButton) {
        if addFriendTextField.text?.count == 0 {
            MBProgressHUD.fd_show(withText: "請輸入賬號", mode: .text, add: view)
            return
        }
        
        if !((addFriendTextField.text?.count)! >= 4 || (addFriendTextField.text?.count)! <= 11) {
            MBProgressHUD.fd_show(withText: "賬號格式不正確", mode: .text, add: view)
            return
        }
        
        let friends = self.accountInfo.friends
        for friendModel in friends ?? [] {
            if friendModel.account == addFriendTextField.text {
                MBProgressHUD.fd_show(withText: "好友已經在清單中", mode: .text, add: view)
                return
            }
        }
        
        addFriendModel.friendaccount = addFriendTextField.text
        let params = addFriendModel.addParams()
        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }else {
            serverManager
                .friendmanager(withParams: params, success: {[weak self] (response) in
                self?.handleAddFriendResult(response)
                }, failre: {[weak self] in
                    MBProgressHUD
                        .fd_show(withText: "添加失敗", mode: .text, add: self?.view)
            })
        }
    }
    
    func handleAddFriendResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD
                .fd_show(withText: "添加失敗", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            //把更新的信息归档到本地
            MBProgressHUD
                .fd_show(withText: "添加成功", mode: .text, add: self.view)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MineAddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        let agreeSwitch = UISwitch()
        agreeSwitch.addTarget(self, action: #selector(addFriendAction(_:)), for: .valueChanged)
        agreeSwitch.isOn = true
        agreeSwitch.tag = indexPath.row
        cell.accessoryView = agreeSwitch
        let titles = ["好友接收我的車罩通知", "我接收好友的車罩通知"]
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension MineAddFriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        let text = textField.text! as NSString
        let count = text.length
        if count >= 11 && string.count > 0 {
            return false
        }
        return true
    }
}
