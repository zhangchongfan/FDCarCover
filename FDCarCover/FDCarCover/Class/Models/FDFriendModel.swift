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
    var imeis: [String]?
    
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
        imeis = dictionary[ImeisKey] as? [String]
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
    
    func iotLocationParams(_ type: String) -> [String : String]? {
        if meagree == "1" && friendagree == "1" {
            if let iotImeis = imeis {
                if iotImeis.count > 0 {
                    let params = [AccountKey: account!,
                                  ImeiKey: iotImeis[0],
                                  DataTypeKey: type,
                                  CarTypeKey: "1",
                                  LocationCountKey: "1"
                    ]
                    return params
                }
            }
        }
        return nil
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("FDFriendModel key: \(key) 不存在")
    }
    
}
