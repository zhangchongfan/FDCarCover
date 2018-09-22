//
//  GBGCDAsyncSocketManager.swift
//  VeepooGBand
//
//  Created by 张冲 on 2018/8/23.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import Foundation

class GBGCDAsyncSocketManager: NSObject {
    
    lazy var clientSocket: GCDAsyncSocket = {
        return GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    }()
    
    var connect: Bool {
        return self.clientSocket.isConnected
    }
    
    var connectTimer: Timer?
    
    override init() {
        super.init()
        self.clientSocket.delegate = self
    }
    
    func connet() {
        do {
            try self.clientSocket.connect(toHost: "192.168.1.34", onPort: 12345, withTimeout: 5)
        } catch {
            print("连接服务器失败")
        }
    }
    
    func sendMessage(_ sendData: Data) {//发送数据
        let sendData = "hello".data(using: .utf8)
        self.clientSocket.write(sendData!, withTimeout: -1, tag: 0)
    }
    
    //开启定时器保持长连接
    func addTimer() {
        self.connectTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(longConnectToSocket), userInfo: nil, repeats: true)
        // 把定时器添加到当前运行循环,并且调为通用模式
        RunLoop.current.add(self.connectTimer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func longConnectToSocket() {
        // 发送固定格式的数据,指令@"longConnect"
        let version = "1.5.0"
        let data = version.data(using: .utf8)
        self.clientSocket.write(data!, withTimeout: -1, tag: 0)
    }
    
}

extension GBGCDAsyncSocketManager: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("连接主机对应端口\(sock),连接成功,host:\(host),port:\(port)")
//        // 连接成功开启定时器
        self.addTimer()
        // 连接后,可读取服务端的数据
        self.clientSocket.readData(withTimeout: -1, tag: 0)
//        self.connected = true;
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let readMessage = String(data: data, encoding: .utf8)
        print(readMessage)
        // 读取到服务端数据值后,能再次读取
        self.clientSocket.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接")
        self.clientSocket.delegate = nil;
//        self.clientSocket = nil;
//        self.connected = NO;
//        [self.connectTimer invalidate];
    }
    
}
