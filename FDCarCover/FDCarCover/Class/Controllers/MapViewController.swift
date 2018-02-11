//
//  MapViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/19.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    var mapRouteView: MapRouteView?
    
    //目的地
    var destinationDict: [String:Double]?
    
    let walkBtn = UIButton(type: .custom)
    let driveBtn = UIButton(type: .custom)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapRouteView?.destination = destinationDict
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        setMapViewControllerUI()
    }
    
    @objc func rightNaviItemAction() {
        MapTool.shared().navigationAction(with: (mapRouteView?.destinationLocation(locationDict: destinationDict!).coordinate)!, withENDName: "位置", tager: self)
    }

    func setMapViewControllerUI() {
        mapRouteView = MapRouteView(frame: view.bounds)
        
        view.addSubview(mapRouteView!)
        
        let routeBtn = UIButton(type: .custom)
        routeBtn.frame = CGRect(x: 0, y: view.zc_height - 50, width: view.zc_width, height: 50)
        routeBtn.backgroundColor = AppColor
        routeBtn.setTitle("规划路线", for: .normal)
        routeBtn.addTarget(self, action: #selector(routeBtnAction), for: .touchUpInside)
        view.addSubview(routeBtn)
        
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
            MBProgressHUD.fd_show(withText: "地图正在加载中，请等待片刻!", mode: .text, add: view)
            return
        }
        let sheet = UIActionSheet(title: "请选择寻车方式", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "步行", otherButtonTitles: "驾车")
        sheet.show(in: view)
    }

    @objc func backUserBtnAction() {
        if mapRouteView?.loadFinish == false {
            MBProgressHUD.fd_show(withText: "地图正在加载中，请等待片刻!", mode: .text, add: view)
            return
        }
        mapRouteView?.followUserLocation()
    }
}

extension MapViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            return
        }
        
        if actionSheet.tag == 0 {
            mapRouteView?.startPlanningRoute(mode: buttonIndex == 0 ? .walk : .drive, result: {
                
            })
        }else if actionSheet.tag == 1 {
            
        }
    }
}

