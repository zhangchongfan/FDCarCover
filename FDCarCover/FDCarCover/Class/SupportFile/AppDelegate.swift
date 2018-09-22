//
//  AppDelegate.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/16.
//  Copyright © 2018年 zhangchong. All rights reserved.
//
/*
 key:5b8b68def43e486f4b0000e4
 App Master Secret:s61u1deg7ccj5iafuptdstliozmczsfu
 */

let UMAppKey = "5b8b68def43e486f4b0000e4"
let UMSecret = "s61u1deg7ccj5iafuptdstliozmczsfu"
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locationManager: VPLocationManager?

    let serverManager = FDServerManager.share()
    
    var device: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configYM(launchOptions)
        window = UIWindow(frame: UIScreen.main.bounds)
        if FDAcountInfo.directLogin() {
            setMainControllerForRoot()
        }else {
             setLoginForRoot()
        }
        window?.makeKeyAndVisible()
        locationManager = VPLocationManager()
        return true
    }

    class func shareDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func setLoginForRoot() {
        window?.rootViewController = nil
        window?.rootViewController = FDBaseNavigationController(rootViewController: LoginViewController())
    }
    
    func setMainControllerForRoot() {
        window?.rootViewController = nil
        window?.rootViewController = FDBaseNavigationController(rootViewController: MainViewController())
    }
    
    func configYM(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        UMConfigure.initWithAppkey(UMAppKey, channel: "iOS")
        let string = UMConfigure.deviceIDForIntegration()
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            
        }
        let entity = UMessageRegisterEntity()
        entity.types = Int(UInt8(UMessageAuthorizationOptions.alert.rawValue) | UInt8(UMessageAuthorizationOptions.sound.rawValue) | UInt8(UMessageAuthorizationOptions.badge.rawValue))
        UMessage
            .registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
                if (granted) {
                    // 用户选择了接收Push消息
                }else{
                    // 用户拒绝接收Push消息
                }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let nsdataStr = NSData.init(data: deviceToken)
        device = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        UMessage.registerDeviceToken(deviceToken)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
