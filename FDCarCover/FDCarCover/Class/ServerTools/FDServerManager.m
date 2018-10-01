//
//  FDServerManager.m
//  FDCarCover
//
//  Created by 张冲 on 2018/8/25.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import "FDServerManager.h"


//static NSString *BaseUrl = @"http://www.sweetcar.cn/api/funrockcar";
static NSString *BaseUrl = @"http://119.23.227.180/api/funrockcar";

static NSString *RegisterUrl = @"register";
static NSString *LoginUrl = @"login";
static NSString *ResetPasswordUrl = @"resetpassword";
static NSString *AccountIsExistUrl = @"justaccountexist";
static NSString *IOTLocationsUrl = @"iotlocations";
static NSString *IOTPostLocationUrl = @"iotinformation";
static NSString *PairIMEIUrl = @"bindingimei";
static NSString *UpdateProfileUrl = @"updateuserinfo";

@interface FDServerManager()

@property (nonatomic, strong) AFHTTPSessionManager *afnManager;

@end

@implementation FDServerManager

+ (instancetype)share {
    static FDServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FDServerManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.afnManager = [[AFHTTPSessionManager alloc]init];
//        self.afnManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.afnManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.afnManager
//        .responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [self monitorNetWorkChange];
    }
    return self;
}

- (BOOL)netNormal {
    return self.currentNetWorkStatus > 0;
}

- (void)monitorNetWorkChange{//开始检测当前网络的变化
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    __weak typeof(self) weakSelf = self;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.currentNetWorkStatus = status;
    }];
}

- (void)registWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:RegisterUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)loginWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:LoginUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)updateProfileWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:UpdateProfileUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)resetPasswordWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:ResetPasswordUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)justAccountExistWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:AccountIsExistUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)iotLocationsWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:IOTLocationsUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)updateLocationWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:IOTPostLocationUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)pairIMEIWithParams:(NSDictionary *)params success:(void(^)(NSDictionary *result))sucess failre:(void(^)(void))failure {
    NSString *requestUrl = [self requestURLWithUrl:PairIMEIUrl];
    [self.afnManager POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (NSString *)requestURLWithUrl:(NSString *)url {
    return [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
}

@end







