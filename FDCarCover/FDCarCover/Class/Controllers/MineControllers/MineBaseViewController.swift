//
//  MineBaseViewController.swift
//  FDCarCover
//
//  Created by 张冲 on 2018/10/1.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

import UIKit

class MineBaseViewController: UIViewController {

    let accountInfo: FDAcountInfo = FDAcountInfo.unarchive(FDAcountInfo.lastLoginAccout()!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
}
