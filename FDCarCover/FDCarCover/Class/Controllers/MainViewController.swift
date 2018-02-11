//
//  MainViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/16.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    lazy var locationManager: VPLocationManager = { () -> VPLocationManager in
        return VPLocationManager()
    }()
    
    let bleManager = FDBleManage.shareManager
    
    var deviceList = [FDPeripherModel]()
    
    @IBOutlet var deviceBackView: UIView!
    
    @IBOutlet var deviceView: UIView!
    
    @IBOutlet var deviceTableView: UITableView!
    
    
    @IBOutlet var selectDeviceBtn: UIButton!
    
    @IBOutlet var tipLabel: UILabel!
    
    @IBOutlet var operationBtns: [UIButton]!
    
    @IBOutlet weak var angleBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configuringBle()
        setControllerUI()
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    func setControllerUI()  {
        deviceBackView.backgroundColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 0.5)
        let rightNaviBtn = UIButton(type: .custom)
        rightNaviBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightNaviBtn.setImage(UIImage(named:"sing_out"), for: .normal)
        rightNaviBtn.addTarget(self, action: #selector(signOutAction(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBtn)
    }
    
    @objc func signOutAction(_ sender: UIButton) {
        if bleManager.connected {
            MBProgressHUD.fd_show(withText: "请先解绑设备", mode: .text, add: view)
            return
        }
        UserDefaults.standard.removeObject(forKey: FDLastAutoLogin)
        UserDefaults.standard.synchronize()
        FDPeripherModel.notAutoConnect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            AppDelegate.shareDelegate().setLoginForRoot()
        }
    }
    
    
    @IBAction func choiceDeviceOrDisconnect(_ sender: UIButton) {
        if bleManager.connected {
            bleManager.disconnectPeripheral()
            MBProgressHUD.fd_show(withText: "设备已解绑", mode: .text, add: view)
        } else {
            scanDevice()
            deviceBackView.isHidden = false
        }
    }
    
    @IBAction func hideListView(_ sender: UIButton) {
        bleManager.scanResult = nil
        deviceBackView.isHidden = true
    }
    
    @IBAction func operationAction(_ sender: UIButton) {
        if !bleManager.connected {//未连接
            MBProgressHUD.fd_show(withText: "设备未连接", mode: .text, add: view).hide(true, afterDelay: 1.0)
            return
        }
        let cmd: [UInt8] = [0xA1, UInt8(sender.tag)]
        let confData = Data(bytes: cmd, count: cmd.count)
        print(confData)
        bleManager.writeValue(data: confData)
        if sender.tag == 1 {//记录当前的定位
            getCurrentLocation()
        }
        if sender.tag != 5 {
            updateOperationBtnsState(tag: sender.tag)
        }else {
            sender.isSelected = true
        }
    }
    
    @IBAction func seekCar(_ sender: UIButton) {
        let locationDict:[String:Double]? = UserDefaults.standard.value(forKey: FDLastLocation) as? [String : Double]
        if locationDict == nil {
            MBProgressHUD.fd_show(withText: "没有停车记录", mode: .text, add: view).hide(true, afterDelay: 1.0)
            return
        }
        
        let mapViewController = MapViewController()
        mapViewController.destinationDict = locationDict
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func updateOperationBtnsState(tag: Int) {
        for btn in operationBtns {
            btn.isSelected = btn.tag == tag;
        }
    }
    
    func configuringBle() {
        //监听手机蓝牙的变化
        
        bleManager.bleDidUpdateState = { [unowned self](bleState) in
            switch bleState {
            case .poweredOn:
                //手机蓝牙开启
                break
            case .poweredOff:
                //手机蓝牙关闭
                self.disconnected()
                break
            default:
                //手机蓝牙关闭
                self.disconnected()
                break
            }
        }
        
        bleManager.bleConnectState = { [unowned self](connectState) in
            switch connectState {
            case .connected:
                //连接成功
                break
            case .foundService:
                //发现服务
                self.connected()
                break
            case .connectFailure:
                //连接失败
                self.disconnected()
                break
            case .disconnected:
                //蓝牙断开
                self.disconnected()
                break
            case .poweredOff:
                //手机蓝牙没打开
                break
            default:
                //手机蓝牙关闭
                break
            }
        }
        
        bleManager.receivePeripheralDataUpdate = { [unowned self](receiveData) in
            var receiveBytes:[UInt8] = Array(repeatElement(0x00, count: 20))
            receiveData.copyBytes(to: &receiveBytes, count: receiveBytes.count)
            if receiveBytes[0] == 0xB1 {
                if receiveBytes[1] == 1 {//账号和密码校准成功
                    self.verifySuccess()
                }else if receiveBytes[1] == 2 {//账号校准失败
                    self.verifyFailure()
                }else if receiveBytes[1] == 3 {//密码校准失败
                    self.verifyFailure()
                }else if receiveBytes[1] == 4 {//主机清除密码
                    self.deviceUnpair()
                }else {//账号和密码校准失败
                    self.verifyFailure()
                }
            }
            
            if receiveBytes[0] == 0xB2 {//receiveBytes[1] == 2是读取，3是主机主动上报
                self.updateOperationBtnsState(tag: Int(receiveBytes[2]))
                self.angleBtn.isSelected = receiveBytes[3] == 1
            }
            
        }
    }
    
    func scanDevice() {
        deviceList.removeAll()
        self.deviceTableView.reloadData()
        bleManager.startScan { [unowned self](peripheralModel) in
            if !self.deviceBackView.isHidden {
                self.deviceList.append(peripheralModel)
                self.deviceTableView.reloadData()
            }
        }
    }

    func connected() {
        hideListView(UIButton())
        selectDeviceBtn.isSelected = true
        tipLabel.text = (bleManager.connectPeripherModel?.name)! + "已绑定"
        MBProgressHUD.fd_show(withText: "已绑定设备", mode: .text, add: view)
        //先要发送一条校验的账号,账号和密码
        let verifyData: Data = FDDataHandle.verifyAccountAndPasswordData()
        bleManager.writeValue(data: verifyData)
    }
    
    func disconnected() {
        selectDeviceBtn.isSelected = false
        tipLabel.text = "设备未绑定"
        for btn in operationBtns {
            btn.isSelected = false
        }
    }
    
    func verifySuccess() {//账号和密码校准成功
        //读取设备状态
        let cmd: [UInt8] = [0xB2, 0x02]
        let confData = Data(bytes: cmd, count: cmd.count)
        bleManager.writeValue(data: confData)
    }
    
    func verifyFailure() {//账号和密码校准失败
        bleManager.disconnectPeripheral()
        let alertView = UIAlertView(title: "提示", message: "账号验证失败，是否重新注册账号？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.tag = 1
        alertView.show()
    }
    
    func deviceUnpair() {//设备解除绑定
        bleManager.disconnectPeripheral()
        let alertView = UIAlertView(title: "提示", message: "主机已解除绑定，您需要重新注册账号", delegate: self, cancelButtonTitle: "我知道了")
        alertView.tag = 2
        alertView.show()
    }
    
    func getCurrentLocation() {
        UserDefaults.standard.removeObject(forKey: FDLastLocation)
        if locationManager.locationIsDenied() {
            let alertView = UIAlertView(title: "提示", message: "GPS定位权限未打开,无法获取您的停车位置,是否前往设置?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "前往")
            alertView.tag = 0
            alertView.show()
            return
        }
        locationManager.startLocation { [unowned self](location, horizon) in
            let chinaCoordinate = VPLocationConverter.wgs84(toGcj02: (location?.coordinate)!)
            let latitude = chinaCoordinate.latitude
            let longitude = chinaCoordinate.longitude
            let locationDict = [Latitude:latitude, Longitude:longitude]
            UserDefaults.standard.set(locationDict, forKey: FDLastLocation)
            UserDefaults.standard.synchronize()
            self.locationManager.stopLocation()
        }
    }
    
    func clearAccoutAndPassword() {//清除账号和密码
        UserDefaults.standard.removeObject(forKey: FDLastLoginAccount)
        UserDefaults.standard.removeObject(forKey: FDLastLoginPassword)
        UserDefaults.standard.removeObject(forKey: FDLastRememberPassword)
        UserDefaults.standard.removeObject(forKey: FDLastAutoLogin)
        UserDefaults.standard.synchronize()
    }
    
    deinit {
        print("deinit")
    }
}

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheralModel = deviceList[indexPath.row];
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = "名字:" + peripheralModel.name
        cell?.detailTextLabel?.text = "RSSI:" + String(describing: peripheralModel.rssi!)
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheralModel = deviceList[indexPath.row];
        if bleManager.connected {
            bleManager.disconnectPeripheral()
        }
        bleManager.connectPeripheral(peripheralModel: peripheralModel)
    }
    
}

extension MainViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 && alertView.tag == 0 {//前往设置GPS权限
            let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(settingUrl!) {
                UIApplication.shared.openURL(settingUrl!)
            }
        }
        
        if buttonIndex == 1 && alertView.tag == 1 {//重新注册
            clearAccoutAndPassword()
            AppDelegate.shareDelegate().setLoginForRoot()
        }
        
        if buttonIndex == 0 && alertView.tag == 2 {//重新注册
            clearAccoutAndPassword()
            AppDelegate.shareDelegate().setLoginForRoot()
        }
        
    }
}


