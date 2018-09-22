//
//  FormatManager.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/8/25.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FormatManager: NSObject {
    static func justFormat(_ text: String?, minlength: NSInteger, maxlength: NSInteger) -> Bool {
        guard let inputMessage = text else {
            return false
        }
        if WYPHelper.justNumber(inputMessage) == false {//不是数字
            return false
        }
        if inputMessage.count < minlength {
            return false
        }
        if inputMessage.count > maxlength {
            return false
        }
        return true
    }
}
