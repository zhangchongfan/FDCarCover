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
        account = dictionary[AccountKey] as? String
        nick = dictionary[NickKey] as? String
        addstate = dictionary[FriendAddStateKey] as? String
        friendagree = dictionary["friendagree"] as? String
        meagree = dictionary["meagree"] as? String
        mesend = dictionary["mesend"] as? String
//        self.setValuesForKeys(dictionary)
    }

    func dictionary() -> [String : String] {
        return [
            AccountKey: account ?? "",
            NickKey: nick ?? "",
            FriendAddStateKey: addstate ?? "",
            "friendagree": friendagree ?? "",
            "meagree": meagree ?? "",
            "mesend": mesend ?? ""
        ]
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("FDFriendModel key: \(key) 不存在")
    }
    
}
