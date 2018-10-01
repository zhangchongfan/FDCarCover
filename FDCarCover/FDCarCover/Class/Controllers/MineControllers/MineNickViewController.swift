//
//  MineNickViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineNickViewController: UIViewController {

    @IBOutlet weak var nickTextField: UITextField!
    let accountInfo: FDAcountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "昵稱"
        nickTextField.text = accountInfo.nick
    }
    
    @IBAction func saveNickAction(_ sender: UIButton) {
        if nickTextField.text == "" {
            MBProgressHUD.fd_show(withText: "請輸入昵稱", mode: .text, add: view)
            return
        }
        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }else {
            FDServerManager.share()?
                .updateProfile(withParams: updateProfileParams(), success: { [weak self] (response) in
                self?.handleUpdateNickResult(response)
            }, failre: {[weak self] in
                MBProgressHUD
                    .fd_show(withText: "更新失敗", mode: .text, add: self?.view)
            })
        }
    }
    
    func updateProfileParams() -> [String : String] {
        return [AccountKey: FDAcountInfo.lastLoginAccout() ?? "", NickKey: nickTextField.text ?? "", CarTypeKey: "1"]
    }
    
    
    func handleUpdateNickResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD
                .fd_show(withText: "更新失敗", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            //把更新的信息归档到本地
            accountInfo.nick = nickTextField.text
            accountInfo
                .archive(FDAcountInfo.lastLoginAccout()!)
            MBProgressHUD
                .fd_show(withText: "保存成功", mode: .text, add: self.view)
            delay(1) {
                self.navigationController?
                    .popViewController(animated: true)
            }
        }else {
            MBProgressHUD
                .fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension MineNickViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        let text = textField.text! as NSString
        let count = text.length
        if count > 20 && string.count > 0 {
            return false
        }
        return true
    }
    
}
