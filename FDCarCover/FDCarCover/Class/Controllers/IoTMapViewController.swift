//
//  IoTMapViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/8/25.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class IoTMapViewController: UIViewController {

    var mapRouteView: MapRouteView?
    
    //目的地
    var destinationDict: [String:Double]?
    
    //0和2是使用属性destinationDict，2是车罩被移动，1是获取车罩当前位置
    var type: NSInteger = 0
    var iotRequestPramas: [String : String]?
    
    let walkBtn = UIButton(type: .custom)
    let driveBtn = UIButton(type: .custom)
    
    var hud: MBProgressHUD?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mapRouteView?.destination = destinationDict
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            title = "當前位置"
        }else {
            title = iotRequestPramas?[AccountKey]
        }
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setMapViewControllerUI()
        handleType()
    }
    
    @objc func rightNaviItemAction() {
        if mapRouteView?.destination == nil {
            MBProgressHUD.fd_show(withText: "沒有數據", mode: .text, add: view)
        }else {
            MapTool.shared().navigationAction(with: (mapRouteView?.destinationLocation(locationDict: (mapRouteView?.destination)!).coordinate)!, withENDName: "位置", tager: self)
        }
    }
    
    func setMapViewControllerUI() {
        mapRouteView = MapRouteView(frame: view.bounds)
        
        view.addSubview(mapRouteView!)
        
        let routeBtn = UIButton(type: .custom)
        routeBtn.frame = CGRect(x: 0, y: view.zc_height - 50, width: view.zc_width, height: 50)
        routeBtn.backgroundColor = AppColor
        routeBtn.setTitle("規劃路線", for: .normal)
        routeBtn.addTarget(self, action: #selector(routeBtnAction), for: .touchUpInside)
        view.addSubview(routeBtn)
        
        let reloadBtn = UIButton(type: .custom)
        reloadBtn.frame = CGRect(x: view.zc_width - 30, y: view.zc_height/2 - 30, width: 30, height: 30)
        reloadBtn.setBackgroundImage(UIImage(named: "reload"), for: .normal)
        reloadBtn.addTarget(self, action: #selector(reloadLocationAction), for: .touchUpInside)
        view.addSubview(reloadBtn)
        
        let backUserBtn = UIButton(type: .custom)
        backUserBtn.frame = CGRect(x: 0, y: view.zc_height/2 - 50, width: 50, height: 50)
        backUserBtn.setBackgroundImage(UIImage(named: "map_current"), for: .normal)
        backUserBtn.addTarget(self, action: #selector(backUserBtnAction), for: .touchUpInside)
        view.addSubview(backUserBtn)
        
        let naviRightBtn = UIButton(type: .custom)
        naviRightBtn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        naviRightBtn.setImage(UIImage(named: "navigation"), for: .normal)
        naviRightBtn.addTarget(self, action: #selector(rightNaviItemAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: naviRightBtn)
        
    }
    
    @objc func routeBtnAction() {
        if mapRouteView?.loadFinish == false {
            MBProgressHUD.fd_show(withText: "地圖正在加載中，請等待片刻!", mode: .text, add: view)
            return
        }
        let sheet = UIActionSheet(title: "請選擇尋車方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "步行", otherButtonTitles: "駕車")
        sheet.show(in: view)
    }
    
    @objc func backUserBtnAction() {
        if mapRouteView?.loadFinish == false {
            MBProgressHUD.fd_show(withText: "地圖正在加載中，請等待片刻!", mode: .text, add: view)
            return
        }
        mapRouteView?.followUserLocation()
    }
    
    @objc func reloadLocationAction() {
        handleType()
    }
}

extension IoTMapViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            return
        }
        
        if actionSheet.tag == 0 {
            if mapRouteView?.destination == nil {
                MBProgressHUD.fd_show(withText: "沒有數據", mode: .text, add: view)
            }else {
                mapRouteView?.startPlanningRoute(mode: buttonIndex == 0 ? .walk : .drive, result: {
                    
                })
            }
        }else if actionSheet.tag == 1 {
            
        }
    }
}

//处理服务器数据
extension IoTMapViewController {
    func handleType() {
        if type == 1 || type == 2 {//获取车罩最新位置
            hud = MBProgressHUD.fd_addIndeterminateHUD(to: self.view)
            hud?.labelText = "正在獲取數據"
            guard let serverManager = FDServerManager.share() else {
//                MBProgressHUD.fd_show(withText: "網絡异常，請檢查", mode: .text, add: view)
                hud?.labelText = "網絡异常，請檢查"
                hud?.hide(true, afterDelay: 1)
                return
            }
            if serverManager.netNormal == false {
                hud?.labelText = "網絡异常，請檢查"
                hud?.hide(true, afterDelay: 1)
            }else {
                var params = FDAcountInfo.obtainIoTLoactions(String(type), count: "1")
                if type == 2 {
                    params = iotRequestPramas!
                }
                
                if params.count == 0 {
                    hud?.labelText = "帳號沒有綁定IMEI碼"
                    hud?.hide(true, afterDelay: 1)
                    return
                }
                serverManager.iotLocations(withParams: params, success: {[weak self] (response) in
                        self?.handleLocations(response)
                    }, failre: {[weak self] in
                        self?.hud?.labelText = "獲取數據失敗"
                        self?.hud?.hide(true, afterDelay: 1)
                })
            }
        }
    }
    
    func handleLocations(_ responser: [AnyHashable : Any]?) {
        guard let data = responser else {
            hud?.labelText = "服務器資料處理异常"
            hud?.hide(true, afterDelay: 1)
            return
        }
        let status = data[StatusKey] as! String
        if status == "1" {
            guard let informations: [[String : Any]] = data[InformationsKey] as? [[String : Any]] else {
                hud?.labelText = "沒有數據"
                hud?.hide(true, afterDelay: 1)
                return
            }
            if informations.count > 0 {
                hud?.labelText = "獲取數據成功"
                let locationInfo = FDLocationInfo(loacationInfo: informations[0])
                let location = CLLocation(latitude: locationInfo.latitude ?? 0.0, longitude: locationInfo.longitude ?? 0.0)
                //22.574337764639846 113.86520047857351
                let chinaCoordinate = VPLocationConverter.wgs84(toGcj02: location.coordinate)
                mapRouteView?.destination = [Latitude: chinaCoordinate.latitude,Longitude: chinaCoordinate.longitude]
            }else {
                hud?.labelText = "沒有數據"
            }
        }else if status == "2" {
            hud?.labelText = "帳號不存在"
        }else if status == "3" {
//            hud?.labelText = "IMEI碼不存在"
            hud?.labelText = "沒有數據"
        }else {
            hud?.labelText = "服務器异常"
        }
        hud?.hide(true, afterDelay: 1)
    }
}
