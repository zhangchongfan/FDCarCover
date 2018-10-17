//
//  FDUpdateProfile.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/2.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDUpdateProfile: NSObject {

    static func updateProfile() {
        FDServerManager.share()?
            .getProfileWithParams(getInfoParams(), success: { (response) in
            handleProfileResult(response)
        }, failre: {
            print("获取个人信息失败")
        })
    }
    
    static func getInfoParams() -> [String : Any] {
        return [AccountKey: FDAcountInfo.lastLoginAccout()!, CarTypeKey: "1"]
    }
    
    static func handleProfileResult(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            let accountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout() ?? "")
            //把更新的信息归档到本地
            accountInfo?.updateProfile(data)
            accountInfo?
                .archive(FDAcountInfo.lastLoginAccout()!)
            print("获取个人信息成功")
        }else {
            print("获取个人信息失败")
        }
    }
    
}
