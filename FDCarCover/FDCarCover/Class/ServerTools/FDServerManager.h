//
//  FDServerManager.h
//  FDCarCover
//
//  Created by 张冲 on 2018/8/25.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface FDServerManager : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus currentNetWorkStatus;

@property (nonatomic, assign) BOOL netNormal;

+(instancetype)share;

- (void)registWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)loginWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failur;

- (void)resetPasswordWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)justAccountExistWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)iotLocationsWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;


- (void)updateLocationWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)pairIMEIWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)getProfileWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)updateProfileWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

- (void)friendmanagerWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure;

@end
