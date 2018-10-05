//
//  FDLocationInfo.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/8/26.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit
import CoreLocation
class FDLocationInfo: NSObject {
    var account: String?
    var time: String?
    var longitude: Double?
    var latitude: Double?
    var iotstate: Int?
    
    init(loacationInfo: [String : Any]) {
        self.time = loacationInfo["collectTime"] as? String
        self.longitude = Double(loacationInfo["longitude"] as! String)
        self.latitude = Double(loacationInfo["latitude"] as! String)
        if self.longitude == nil  {
            self.longitude = 0.0
        }
        if self.latitude == nil  {
            self.latitude = 0.0
        }
        self.iotstate = Int(loacationInfo["iotstate"] as! String)
    }
    
    static func saveLastMoveInfomation(_ time: String, account: String) {
        UserDefaults.standard.set(time, forKey: "IOTMoveTime" + account)
        UserDefaults.standard.synchronize()
    }
    
    static func isNewMoveLocation(_ newTime: String, account: String) -> Bool {
        let lastTime = UserDefaults.standard.string(forKey: "IOTMoveTime" + account)
        guard let time = lastTime else {
            return true
        }
        if newTime == time {
            return false
        }
        return true
    }
    
}
