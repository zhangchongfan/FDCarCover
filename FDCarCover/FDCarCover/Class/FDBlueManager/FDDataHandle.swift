//
//  FDDataHandle.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/23.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDDataHandle: NSObject {

    class func verifyAccountAndPasswordData() -> Data {
        
        var tbyte:[UInt8] = Array(repeatElement(0x00, count: 20))
        tbyte[0] = 0xB1
        tbyte[1] = 0x01
        
        let account = UserDefaults.standard.value(forKey: FDLastLoginAccount) as? String
        let password = UserDefaults.standard.value(forKey: FDLastLoginPassword) as? String
        guard let lastAccount = account,let lastPassword = password else {
            return Data(bytes: tbyte, count: tbyte.count)
        }
        tbyte[2] = UInt8(lastAccount.count)
        var index = 3
        for character in lastAccount {
            let acountStr = String(character)
            tbyte[index] = UInt8(acountStr)!
            index += 1
        }
        tbyte[index] = UInt8(lastPassword.count)
        for character in lastPassword {
            index += 1
            let passwordStr = String(character)
            tbyte[index] = UInt8(passwordStr)!
        }
        return Data(bytes: tbyte, count: tbyte.count)
    }
    
}
