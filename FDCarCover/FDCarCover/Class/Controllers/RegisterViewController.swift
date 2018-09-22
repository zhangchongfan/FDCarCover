//
//  RegisterViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/8/25.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var imeiTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var resetTextField: UITextField!
    
    var registerSuccess: ((_ account: String, _ password: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startRegister(_ sender: UIButton) {
//        MBProgressHUD.fd_show(withText: "註冊成功", mode: .text, add: self.view)
//        if let resgister = registerSuccess {
//            resgister(accountTextField.text!, passwordTextField.text!)
//        }
//        delay(1, closure: {
//            self.dismiss(animated: true, completion: nil)
//        })
//        return
        
        
        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }
        else if FormatManager.justFormat(accountTextField.text, minlength: 8, maxlength: 15) == false {//账号格式不正确
            MBProgressHUD.fd_show(withText: "賬號格式不正確", mode: .text, add: view)
        }
        else if FormatManager.justFormat(imeiTextField.text, minlength: 15, maxlength: 15) == false {
            MBProgressHUD.fd_show(withText: "IMEI碼格式不正確", mode: .text, add: view)
        }
        else if FormatManager.justFormat(passwordTextField.text, minlength: 4, maxlength: 4) == false {
            MBProgressHUD.fd_show(withText: "密碼格式不正確", mode: .text, add: view)
        }
        else if FormatManager.justFormat(resetTextField.text, minlength: 4, maxlength: 4) == false {
            MBProgressHUD.fd_show(withText: "確認密碼格式不正確", mode: .text, add: view)
        }
        else if resetTextField.text != passwordTextField.text {
            MBProgressHUD.fd_show(withText: "密碼輸入不一致", mode: .text, add: view)
        }else {
            serverManager.regist(withParams: registerParams(), success: {[weak self] (response) in
                self?.handleRegisterData(response)
            }, failre: {[weak self] in
                MBProgressHUD.fd_show(withText: "注册失败", mode: .text, add: self?.view)
            })
        }
    }
    
    //返回登入
    @IBAction func backLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //获取注册参数
    func registerParams() -> [String : String] {
        guard let account = accountTextField.text,
            let imei = imeiTextField.text,
            let password = passwordTextField.text
        else {
            return [:]
        }
        return [AccountKey: account, ImeiKey: imei, PasswordKey: password, CarTypeKey: "1"]
    }
    
    func handleRegisterData(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD.fd_show(withText: "服務器資料處理异常", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            MBProgressHUD.fd_show(withText: "註冊成功", mode: .text, add: self.view)
            if let resgister = registerSuccess {
                resgister(accountTextField.text!, passwordTextField.text!)
            }
            delay(1, closure: {
                self.dismiss(animated: true, completion: nil)
            })
        }else if status == "2" {
            MBProgressHUD.fd_show(withText: "帳號已存在", mode: .text, add: self.view)
        }else if status == "3" {
            MBProgressHUD.fd_show(withText: "IMEI已被其他帳號綁定", mode: .text, add: self.view)
        }else {
            MBProgressHUD.fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var length = 0
        if textField.isEqual(accountTextField) {
            length = 15;
        }
        else if textField.isEqual(imeiTextField) {
            length = 15;
        }
        else if textField.isEqual(passwordTextField) {
            length = 4;
        }
        else if textField.isEqual(resetTextField) {
            length = 4;
        }
        if textField.text?.count == length {
            if string.count == 0 {
                return true
            }
            return false
        }
        return true;
    }
}
