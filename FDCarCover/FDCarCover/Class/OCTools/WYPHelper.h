//
//  WYPHelper.h
//  WYPHealthyThird
//
//  Created by 张冲 on 16/6/29.
//  Copyright © 2016年 veepoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WYPHelper : NSObject

//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile;

//邮箱判断
+ (BOOL) justEmail:(NSString *)email;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//数字
+ (BOOL) justNumber:(NSString *)number;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(NSInteger)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(NSInteger)font width:(CGFloat)width;


/**
 判断系统是12小时制还是24小时制

 @return YES 代表12小时制 NO 代表24小时制
 */
+ (BOOL)is12Hour;

/**
 获取保留k位小数点的数字
 
 @param x 要转换的double
 @param k 保留几位小数点
 @return 返回保留k位小数点的double
 */
+ (double)reservedDecimalWithFloat:(double)x decimalNumber:(int)k ;


/**
 24小时转化12小时时间制式

 @param h 24小时的hour
 @param m 24小时的minute
 @return 返回一个12小时制式的小时 分钟 和 上午还是下午
 */
+ (NSArray *)change12HourWithHour:(NSInteger)h minute:(NSInteger)m ;


/**
 12小时转换成24小时

 @param h 12小时的hour
 @param m 12小时的minute
 @param zone 12小时的上午还是下午
 @return 返回24小时的hour和minute
 */
+ (NSArray *)change24HourWithHour:(NSInteger)h minute:(NSInteger)m timeZone:(NSInteger)zone;

+ (NSString *)change12HourStringWith24HourString:(NSString *)text24;

+ (NSString *)changeStringWithTimeString:(NSString *)timeString AddTimeInterval:(NSInteger)timeInterval;

//获取当前系统的国家编号 如中国是86
+ (NSString *)getCurrentSytemZone;
@end
