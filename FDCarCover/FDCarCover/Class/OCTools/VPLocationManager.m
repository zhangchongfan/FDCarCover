//
//  VPVPLocationManager.m
//  WYPHealthyThird
//
//  Created by 张冲 on 2017/12/19.
//  Copyright © 2017年 veepoo. All rights reserved.
//

#import "VPLocationManager.h"

@implementation VPLocationManager

+ (instancetype)shareLocationManager {
    static VPLocationManager *locationManager = nil;
    if (!locationManager) {
        locationManager = [[VPLocationManager alloc]init];
    }
    return locationManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.running = NO;
        [self configureLocationManager];
    }
    return self;
}

- (void)configureLocationManager {
    if (![CLLocationManager locationServicesEnabled]){//不支持定位服务
        return;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.pausesLocationUpdatesAutomatically = NO;//不自动暂停
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;//不需要移动都可以刷新需要设置成NONE
    if (@available(iOS 9.0, *)) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //[_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
}

//判断定位权限是否被拒绝
- (BOOL)locationIsDenied {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
}

- (void)startLocation:(void(^)(CLLocation *location, CGFloat horizon))locationResult {
    self.locationBlock = locationResult;
    [self.locationManager startUpdatingLocation];
}

//开始定位,不带回调
- (void)startLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = locations[0];
    self.recentLocation = currentLocation;
    CGFloat horizonValue = currentLocation.horizontalAccuracy;
    if (self.locationBlock) {
        self.locationBlock(currentLocation, horizonValue);
    }
    if ([self.delegate respondsToSelector:@selector(locationUpdate:horizontalAccuracy:)]) {
        [self.delegate locationUpdate:currentLocation horizontalAccuracy:horizonValue];
    }
}

@end
