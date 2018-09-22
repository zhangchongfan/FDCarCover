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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func rememberPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func autoLoginAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func registAction(_ sender: UIButton) {
        let registerController = RegisterViewController()
        registerController.registerSuccess = {[weak self] account, password  in
            self?.accountTextField.text = account
            self?.pwdTextField.text = ""
        }
        self .present(registerController, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
//        if UIScreen.main.bounds.size.width == 320 {//调试
//            guard let serverManager = FDServerManager.share() else {
//                MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
//                return
//            }
//            
//            let params = [
//                "imei":"123456789123456","sim":"0952010210","time":"20180910073959","longitude":"121.276053","latitude":"30.189263","iotstate":"2","type":"1"
//            ]
//            serverManager.updateLocation(withParams: params, success: {[weak self] (response) in
//                MBProgressHUD.fd_show(withText: "更新位置成功", mode: .text, add: self?.view)
//            }, failre: {[weak self] in
//                MBProgressHUD.fd_show(withText: "更新位置失败", mode: .text, add: self?.view)
//            })
//            return
//        }
        if accountAndPasswordFormatCorrect() {
            guard let serverManager = FDServerManager.share() else {
                MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
                return
            }
            
            guard AppDelegate.shareDelegate().device != nil else {
                MBProgressHUD.fd_show(withText: "網絡异常，資訊獲取失敗", mode: .text, add: view)
                return
            }
            
            if serverManager.netNormal == false {
                MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
            }else {
                serverManager.login(withParams: loginRequestParams(), success: {[weak self] (response) in
                        self?.handleLoginData(response)
                    }, failre: {[weak self] in
                        MBProgressHUD.fd_show(withText: "登入失败", mode: .text, add: self?.view)
                })
            }
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
            MBProgressHUD.fd_show(withText: "密碼必須是4比特有效數字", mode: .text, add: view)
            pwdTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func loginRequestParams() -> [String : String] {
        guard let account = accountTextField.text,
            let password = pwdTextField.text,
            let token = AppDelegate.shareDelegate().device
            else {
                return [:]
        }
        return [AccountKey: account, PasswordKey: password, CarTypeKey: "1",DeviceToken:token]
    }
    
    func handleLoginData(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD.fd_show(withText: "服務器資料處理异常", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            MBProgressHUD.fd_show(withText: "登入成功", mode: .text, add: self.view)
            //信息归档
            let userInfo = FDAcountInfo(data)
            userInfo.archive(accountTextField.text!)
            loginSuccess()
        }else if status == "2" {
            MBProgressHUD.fd_show(withText: "帳號不存在", mode: .text, add: self.view)
        }else if status == "3" {
            MBProgressHUD.fd_show(withText: "密碼錯誤", mode: .text, add: self.view)
        }else {
            MBProgressHUD.fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
    }
    
    func loginSuccess()  {
        UserDefaults.standard.set(accountTextField.text, forKey: FDLastLoginAccount)
        UserDefaults.standard.set(pwdTextField.text, forKey: FDLastLoginPassword)
        UserDefaults.standard.set(rememberBtn.isSelected, forKey: FDLastRememberPassword)
        UserDefaults.standard.set(autoLoginBtn.isSelected, forKey: FDLastAutoLogin)
        UserDefaults.standard.synchronize()
        AppDelegate.shareDelegate().setMainControllerForRoot()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension LoginViewController: UITextFieldDelegate,UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            loginSuccess()
        }
    }
}


