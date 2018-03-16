//
//  LoginViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var autoLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let lastLoginAccount = UserDefaults.standard.value(forKey: FDLastLoginAccount) as? String
        pwdTextField.text = ""
        if lastLoginAccount != nil {
            accountTextField.text = lastLoginAccount
            rememberBtn.isSelected = UserDefaults.standard.bool(forKey: FDLastRememberPassword)
            autoLoginBtn.isSelected = UserDefaults.standard.bool(forKey: FDLastAutoLogin)
            if rememberBtn.isSelected {
                pwdTextField.text = UserDefaults.standard.value(forKey: FDLastLoginPassword) as? String
            }
        }
    }
    
    @IBAction func rememberPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func autoLoginAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func registAction(_ sender: UIButton) {
        if accountAndPasswordFormatCorrect() {
            if equalLastLoginAccount(account: accountTextField.text!) {//如果是上次的账号
                MBProgressHUD.fd_show(withText: "賬號已經被註冊", mode: .text, add: view)
                return
            }
            
            let alertView = UIAlertView(title: "提示", message: "是否確認註冊？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "確認")
            alertView.show()
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if accountAndPasswordFormatCorrect() {
            if !equalLastLoginAccount(account: accountTextField.text!) {//如果不是上次的账号
                MBProgressHUD.fd_show(withText: "賬號不正確", mode: .text, add: view)
                return
            }
            if !equalLastLoginPassword(password: pwdTextField.text!) {//如果不是上次的密码
                MBProgressHUD.fd_show(withText: "密碼不正確", mode: .text, add: view)
                return
            }
            registAndLoginSuccess()
        }
    }
    
    func accountAndPasswordFormatCorrect() -> Bool {
        
        if accountTextField.text?.count == 0 {
            MBProgressHUD.fd_show(withText: "請輸入賬號", mode: .text, add: view)
            accountTextField.becomeFirstResponder()
            return false
        }
        
        if !((accountTextField.text?.count)! >= 4 || (accountTextField.text?.count)! <= 11) {
            MBProgressHUD.fd_show(withText: "賬號格式不正確", mode: .text, add: view)
            accountTextField.becomeFirstResponder()
            return false
        }
        
        if pwdTextField.text?.count == 0 {
            MBProgressHUD.fd_show(withText: "請輸入密碼", mode: .text, add: view)
            pwdTextField.becomeFirstResponder()
            return false
        }
        
        if pwdTextField.text?.count != 4 {
            MBProgressHUD.fd_show(withText: "密码必须是4位有效数字", mode: .text, add: view)
            pwdTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func registAndLoginSuccess()  {
        UserDefaults.standard.set(accountTextField.text, forKey: FDLastLoginAccount)
        UserDefaults.standard.set(pwdTextField.text, forKey: FDLastLoginPassword)
        UserDefaults.standard.set(rememberBtn.isSelected, forKey: FDLastRememberPassword)
        UserDefaults.standard.set(autoLoginBtn.isSelected, forKey: FDLastAutoLogin)
        
        UserDefaults.standard.synchronize()
        AppDelegate.shareDelegate().setMainControllerForRoot()
    }
    
    func equalLastLoginAccount(account: String) -> Bool {
        let lastLoginAccount = UserDefaults.standard.value(forKey: FDLastLoginAccount) as? String
        
        if lastLoginAccount != nil {
            if lastLoginAccount == account {
                return true
            }
        }
        return false
    }
    
    func equalLastLoginPassword(password: String) -> Bool {
        let lastLoginPassword = UserDefaults.standard.value(forKey: FDLastLoginPassword) as? String
        
        if lastLoginPassword != nil {
            if lastLoginPassword == password {
                return true
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension LoginViewController: UITextFieldDelegate,UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            registAndLoginSuccess()
        }
    }
}


