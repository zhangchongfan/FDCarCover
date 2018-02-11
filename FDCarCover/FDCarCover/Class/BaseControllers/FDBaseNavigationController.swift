//
//  FDBaseNavigationController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/1/19.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class FDBaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
