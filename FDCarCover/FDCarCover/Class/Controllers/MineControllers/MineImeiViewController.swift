//
//  MineImeiViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineImeiViewController: MineBaseViewController {

    @IBOutlet weak var imeiTextField: UITextField!
    @IBOutlet weak var pairBtn: UIButton!
    @IBOutlet weak var unpairBtn: UIButton!
    
    var pairImeis = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "IMEI碼設定"
        let imeis = self.accountInfo.imeis ?? []
        if imeis.count == 0 {
            unpairBtn.isHidden = true
            pairBtn.setTitle("綁 定", for: .normal)
            self.imeiTextField.text = ""
        }else {
            unpairBtn.isHidden = false
            pairBtn.setTitle("確認修改", for: .normal)
            self.imeiTextField.text = imeis[0]
        }
    }
    
    @IBAction func pairAction(_ sender: UIButton) {
        oprationImei(true)
    }
    
    @IBAction func unpairAction(_ sender: UIButton) {
        oprationImei(false)
    }
    
    func oprationImei(_ pair: Bool) {
        pairImeis = pair
        if pair {
            if imeiTextField.text == "" {
                MBProgressHUD.fd_show(withText: "請輸入要綁定的IMEI碼", mode: .text, add: view)
                return
            }
            if FormatManager
                .justFormat(imeiTextField.text, minlength: 15, maxlength: 15) == false {
                MBProgressHUD.fd_show(withText: "IMEI碼格式不正確", mode: .text, add: view)
                return
            }
        }

        guard let serverManager = FDServerManager.share() else {
            MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
            return
        }
        
        if serverManager.netNormal == false {
            MBProgressHUD.fd_show(withText: "網絡异常", mode: .text, add: view)
        }else {
            FDServerManager.share()?
                .updateProfile(withParams: updateImeisParams(pair), success: { [weak self] (response) in
                    self?.handleUpdateImeisResult(response)
                    }, failre: {[weak self] in
                        MBProgressHUD
                            .fd_show(withText: "操作失败", mode: .text, add: self?.view)
                })
        }
        
    }
    
    func updateImeisParams(_ pair: Bool) -> [String : Any] {
        if pair {
            return [AccountKey: FDAcountInfo.lastLoginAccout() ?? "", ImeisKey: [imeiTextField.text ?? ""], CarTypeKey: "1"]
        }
        return [AccountKey: FDAcountInfo.lastLoginAccout() ?? "", ImeisKey: [], CarTypeKey: "1"]
    }
    
    
    func handleUpdateImeisResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            MBProgressHUD
                .fd_show(withText: "操作失败", mode: .text, add: self.view)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            //把更新的信息归档到本地
            accountInfo.imeis = pairImeis ? [imeiTextField.text ?? ""] : nil
            accountInfo
                .archive(FDAcountInfo.lastLoginAccout()!)
            MBProgressHUD
                .fd_show(withText: pairImeis ? "綁定成功" : "解綁成功", mode: .text, add: self.view)
        }else {
            MBProgressHUD
                .fd_show(withText: "服務器异常", mode: .text, add: self.view)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension MineImeiViewController: UITextFieldDelegate {
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
        if count >= 15 && string.count > 0 {
            return false
        }
        return true
    }
    
}
