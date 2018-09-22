//
//  ZCNSObject+Dispatch.swift
//  VeepooGBand
//
//  Created by 张冲 on 2018/8/20.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import Foundation

extension NSObject {
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
