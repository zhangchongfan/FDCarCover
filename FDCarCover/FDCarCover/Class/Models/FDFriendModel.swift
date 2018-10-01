//
//  FDFriendModel.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDFriendModel: NSObject {
    
    var account: String?
    var nick: String?
    var addstate: String?
    var friendagree: String?
    var meagree: String?
    var mesend: String?
 
    override init() {
        super.init()
        
    }
    
    init(_ dictionary: [String : Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("FDFriendModel key: \(key) 不存在")
    }
    
}
