//
//  FDAcountInfo.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDAcountInfo: NSObject, NSCoding {
    
    
    var userID: String? = nil
    var imeis: [String]? = nil
    var expirationDate: String?
    var accessToken: String?
    var nick: String?
    var friends: [FDFriendModel]?
    
    override init() {
        super.init()
    }
    
    init(_ userInfo: [AnyHashable : Any]) {
        self.userID = userInfo[UserIDKey] as? String
        self.imeis = userInfo[ImeisKey] as? [String]
        self.expirationDate = userInfo[ExpirationDateKey] as? String
        self.accessToken = userInfo[AccessTokenKey] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userID = aDecoder.decodeObject(forKey: "userID") as? String
        self.imeis = aDecoder.decodeObject(forKey: "imeis") as? [String]
        self.expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? String
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        self.nick = aDecoder.decodeObject(forKey: "nick") as? String
        if self.nick == nil || self.nick?.count == 0 {
            self.nick = FDAcountInfo.lastLoginAccout()
        }
    }
    
    func updateProfile(_ userInfo: [AnyHashable : Any]) {
        self.imeis = userInfo[ImeisKey] as? [String]
        self.nick = userInfo[NickKey] as? String
        var friends: [FDFriendModel] = []
        let friendArray = userInfo[FriendsKey] as? [[String : Any]]
        for dict in friendArray ?? [] {
            let friendModel = FDFriendModel(dict)
            friends.append(friendModel)
        }
        self.friends = friends
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.imeis, forKey: "imeis")
        aCoder.encode(self.expirationDate, forKey: "expirationDate")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.nick, forKey: "nick")
    }
    
    static func unarchive(_ fileName: String) -> FDAcountInfo? {
        let homePath = NSHomeDirectory()
        let infoPath = homePath + "/Library/Caches/" + fileName + ".archive"
        let accoutInfo = NSKeyedUnarchiver
            .unarchiveObject(withFile: infoPath)
        return accoutInfo as? FDAcountInfo
    }
    
    func archive(_ fileName: String) {
        let homePath = NSHomeDirectory()
        let infoPath = homePath + "/Library/Caches/" + fileName + ".archive"
        NSKeyedArchiver.archiveRootObject(self, toFile: infoPath)
    }
    
    //App直接登录
    static func directLogin() -> Bool {
        if FDAcountInfo.autoLogin() {
            let accountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)
            if accountInfo?.expirationDate != "" {
                return true
            }
        }
        return false
    }
    
    //上次登录的账号
    static func autoLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: FDLastAutoLogin)
    }
    
    //上次登录的账号
    static func lastLoginAccout() -> String? {
        return UserDefaults.standard.string(forKey: FDLastLoginAccount)
    }
    
    //上次登录的密码
    static func lastLoginPassword() -> String? {
        return UserDefaults.standard.string(forKey: FDLastLoginPassword)
    }
    
    static func obtainIoTLoactions(_ type: String, count: String) -> [String : String] {
        let accountInfo: FDAcountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)!
        guard let imeis = accountInfo.imeis else {
            return [:]
        }
        if imeis.count == 0 {
            return [:]
        }
//        return [AccountKey: FDAcountInfo.lastLoginAccout()!,
//                ImeiKey: "123456789123456",
//                DataTypeKey: type,
//                LocationCountKey: count,
//                CarTypeKey: "1"
//        ]
        return [AccountKey: FDAcountInfo.lastLoginAccout()!,
                ImeiKey: imeis[0],
                DataTypeKey: type,
                LocationCountKey: count,
                CarTypeKey: "1"
                ]
    }
    
    static func obtainPairParams(_ type: String) -> [String : String] {
        let accountInfo: FDAcountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)!
        guard let imeis = accountInfo.imeis else {
            return [:]
        }
        //        return [AccountKey: FDAcountInfo.lastLoginAccout()!,
        //                ImeiKey: "123456789123456",
        //                DataTypeKey: type,
        //                LocationCountKey: count,
        //                CarTypeKey: "1"
        //        ]
        return [AccountKey: FDAcountInfo.lastLoginAccout()!,
                ImeiKey: imeis[0],
                PairOperatoin: type,
                CarTypeKey: "1"
        ]
    }
}
