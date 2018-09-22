//
//  WYPHelper.m
//  WYPHealthyThird
//
//  Created by 张冲 on 16/6/29.
//  Copyright © 2016年 veepoo. All rights reserved.
//

#import "WYPHelper.h"

@implementation WYPHelper

//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile
{
    /**
     * 手机号码
     * 移动：134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,1709,171,176,185,186
     * 电信：133,134,153,1700,177,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString * CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[0]|7[8]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,1709,171,176,185,186
     */
    NSString * CU = @"^1(3[0-2]|4[5]|5[56]|709|7[1]|7[6]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,1700,177,180,181,189
     */
    NSString * CT = @"^1(3[34]|53|77|700|8[019])\\d{8}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//邮箱判断
+ (BOOL) justEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//密码
+ (BOOL) justPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^([a-zA-Z0-9]|[._-]){6,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//数字
+ (BOOL)justNumber:(NSString *)number{
    NSString *emailRegex = @"^[0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:number];
}

//获取文字的宽度
+(CGFloat)widthOfString:(NSString *)string font:(NSInteger)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

//获取文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(NSInteger)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

+ (BOOL)is12Hour{
    //判断手机是12小时制还是24小时制
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsARange = [formatString rangeOfString:@"a"];
    BOOL isAMPM = containsARange.location != NSNotFound;//yes 代表12小时制
    return isAMPM;
}

/**
 获取保留k位小数点的数字,不进行四舍五入

 @param x 要转换的float
 @param k 保留几位小数点
 @return 返回保留k位小数点的float
 */
+ (double)reservedDecimalWithFloat:(double)x decimalNumber:(int)k {
    int y = x * pow(10, k);
    return 1.0 * y / pow(10, k);
}

+ (NSArray *)change12HourWithHour:(NSInteger)h minute:(NSInteger)m {
    NSInteger hour = 0;
    NSInteger minute = m;
    NSInteger timeZone = 0;//上午还是下午 0代表上午 1代表下午
    if (h >= 12 && h != 24) {
        hour = h == 12 ? 12 : h - 12;
        timeZone = 1;
    }else {
        hour = h == 0|| h == 24 ? 12 : h;
    }
    return @[@(hour),@(minute),@(timeZone)];
}

+ (NSArray *)change24HourWithHour:(NSInteger)h minute:(NSInteger)m timeZone:(NSInteger)zone {
    NSInteger hour = 0;
    NSInteger minute = m;
    if (zone == 0) {
        hour = h == 12 ? 0 : h;
        
    }else {
        hour = h == 12 ? 12 : h + 12;
    }
    return @[@(hour),@(minute)];
}

+ (NSString *)change12HourStringWith24HourString:(NSString *)text24 {
    NSInteger hour = [[text24 componentsSeparatedByString:@":"][0] integerValue];
    NSInteger minute = [[text24 componentsSeparatedByString:@":"][1] integerValue];
    NSArray *array12 = [WYPHelper change12HourWithHour:hour minute:minute];
    return [NSString stringWithFormat:@"%02ld:%02ld%@",(long)[array12[0] integerValue],(long)[array12[1] integerValue],[array12[2] integerValue] == 0 ? @"am" : @"pm"];
}

+ (NSString *)changeStringWithTimeString:(NSString *)timeString AddTimeInterval:(NSInteger)timeInterval {
    NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
    NSInteger totalMinute = [timeArray[0] integerValue] * 60 + [timeArray[1] integerValue];
    totalMinute += timeInterval;
    NSString *changeTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)(totalMinute/60),(long)(totalMinute%60)];
    return changeTimeString;
}

//获取当前系统的国家编号 如中国是86
+ (NSString *)getCurrentSytemZone {
    NSLocale *locale = [NSLocale currentLocale];
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* keyCode=[locale objectForKey:NSLocaleCountryCode];
    NSString* currentSystemCode=[dictCodes objectForKey:keyCode];
//    NSString* defaultCountryName=[locale displayNameForKey:NSLocaleCountryCode value:keyCode];
    return currentSystemCode;
}
@end
