//
//  VPVPLocationManager.h
//  WYPHealthyThird
//
//  Created by 张冲 on 2017/12/19.
//  Copyright © 2017年 veepoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <CoreLocation/CoreLocation.h>

@protocol VPLocationManagerDelegate <NSObject>

- (void)locationUpdate:(CLLocation *)location horizontalAccuracy:(CGFloat)horizon;

@end

@interface VPLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<VPLocationManagerDelegate>delegate;

@property (nonatomic, strong) CLLocationManager *locationManager;

//最近一次定位地址
@property (nonatomic, strong) CLLocation *recentLocation;

//定位回调
@property (nonatomic, copy) void(^locationBlock)(CLLocation *location , CGFloat horizon);

//是否处于运动模式
@property (nonatomic, assign) BOOL running;

+ (instancetype)shareLocationManager;

//判断定位权限是否被拒绝
- (BOOL)locationIsDenied;

//开始定位
- (void)startLocation:(void(^)(CLLocation *location, CGFloat horizon))locationResult;

//开始定位,不带回调
- (void)startLocation;
//停止定位
- (void)stopLocation;

@end
