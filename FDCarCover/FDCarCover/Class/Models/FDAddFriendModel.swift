//
//  FDAddFriendModel.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDAddFriendModel: NSObject,Codable {

    var account: String?
    var friendaccount: String?
    var operation: String?
    var mesend: String?
    var mereceive: String?
    var type: String?

    
    override init() {
        super.init()
        account = FDAcountInfo.lastLoginAccout()
        friendaccount = nil
        operation = "1"
        mesend = "1"
        mereceive = "1"
        type = "1"
    }
    
    func addParams() -> [String : Any] {
        return ["account": account!,"friendaccount": friendaccount!,"operation": operation!,"mesend": mesend!,"mereceive": mereceive!,"type": type!]
    }
    
}
