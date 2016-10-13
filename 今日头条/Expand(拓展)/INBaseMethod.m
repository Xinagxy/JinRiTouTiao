//
//  INBaseMethod.m
//  ImportintNews
//
//  Created by app on 15/12/20.
//  Copyright © 2015年 罗文. All rights reserved.
//

#import "INBaseMethod.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+MJ.h"
#import <sys/utsname.h>
//#import "INKeyChainStore.h"
#import <UIImageView+WebCache.h>

@implementation INBaseMethod
//加载图片
+(void)loadImageWithImg:(UIImageView *)imageView url:(NSString *)urlStr
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"302.jpg"] options:SDWebImageDownloaderLowPriority|SDWebImageDownloaderProgressiveDownload];
}

+(void)loadImageWithImg:(UIImageView *)imageView url:(NSString *)urlStr placeImg:(NSString *)placeImg
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeImg]];
}

//显示圈圈
+(void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:view animated:animated];
}

//隐藏圈圈
+(void)hideHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

//  错误的提示
+(void)showErrorWithStr:(NSString *)error toView:(UIView *)view
{
    [MBProgressHUD showError:error toView:view];
}

//错误的提示
+(void)showSuccessWithStr:(NSString *)success toView:(UIView *)view
{
    [MBProgressHUD showSuccess:success toView:view];
}

//判断有没有网络
//+(BOOL)connectionInternet
//{
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus ];
//    if (status == RealStatusNotReachable || status == RealStatusUnknown) {
//        return NO;
//    }
//    return YES;
//}

//获得当前网络状态
//+ (NSString *)getCurrentReachability
//{
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus ];
//    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
//    if (status == RealStatusViaWiFi) {
//        return @"WIFI";
//    }else if(accessType == WWANType4G){
//        return @"4G";
//    }else if(accessType == WWANType3G){
//        return @"3G";
//    }else if (accessType == WWANType2G){
//        return @"2G";
//    }else{
//        return @"noNet";
//    }
//}

//获得当前用户名状态
//+ (NSString *)getCurrentUserName
//{
//    NSString *userName = nil;
//    if ([[INUserDefaults objectForKey:AnonymousMan] isEqualToString:@"YES"]) {
//        userName = @"匿名评论者";
//    }else{
//        userName = [INUserDefaults objectForKey:kUserName];
//    }
//    return userName;
//}

//获得当前的字体大小
//+ (UIFont *)getCurrentFontSize
//{
//    NSString *fontSize = [[INUserDefaults objectForKey:CURRENTSETTING] objectForKey:@"currentFontSize"];
//    UIFont *font = nil;
//    if ([fontSize isEqualToString:@"0"]) {
//       font = minFontSize;
//    }else if ([fontSize isEqualToString:@"1"]){
//       font = middleFontSize;
//    }else{
//       font = maxFontSize;
//    }
//    return font;
//}
//获取缓存文件大小
//+ (NSString *)getCacheFileSize
//{
//    NSArray *subpaths = [INFileManager subpathsAtPath:INCacheDir];
//    long long totalSize = 0;
//    for (NSString *subpath in subpaths) {
//        NSString *fullpath = [INCacheDir stringByAppendingPathComponent:subpath];
//        BOOL dir = NO;
//        [INFileManager fileExistsAtPath:fullpath isDirectory:&dir];
//     if (dir == NO) {// 文件
//        totalSize += [[INFileManager attributesOfItemAtPath:fullpath error:nil][NSFileSize] longLongValue];
//       }
//    }
//    NSString *fileSize = [NSString stringWithFormat:@"%.2fM",totalSize/1024.00/1024.00];
//    
//    return fileSize;
//}
//获取系统当前版本
//+ (NSString *)getCurrentVersion
//{
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
//    
//    return [NSString stringWithFormat:@"v%@",currentVersion];
//}
////获取当前网络设置
//+ (NSString *)getCurrentNetSetting
//{
//    NSString *net = [[INUserDefaults objectForKey:CURRENTSETTING] objectForKey:@"currentNetSetting"];
//    NSString *netSetting = nil;
//    if (!net.intValue) {
//        netSetting = @"智能下图";
//    }else{
//        netSetting = @"不下载图";
//    }
//    return netSetting;
//}
//获得当前应用版本
+ (NSString *)getCurrentAppVersion
{
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
     NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
     return appCurVersion;
}
//获得当前手机类型(如iphone6)
+ (NSString *)getCurrentPhoneNumber
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6p";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6splus";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;

}
//16进制颜色转化为RGB
+ (UIColor *)getRGBColor:(NSString *)hexColor
{
    unsigned int red, green, blue;
        
    NSRange range;
        
    range. length = 2 ;
        
    range. location = 0 ;
        
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
        
    range. location = 2 ;
        
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
        
    range. location = 4 ;
        
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
        
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
   
}
////获取设备UUID
//+ (NSString *)getUUID
//{
//    NSString * strUUID = (NSString *)[INKeyChainStore load:@"com.company.app.usernamepassword"];
//    
//    //首次执行该方法时，uuid为空
//    if ([strUUID isEqualToString:@""] || !strUUID)
//    {
//        // 生成一个uuid的方法
//        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
//        strUUID =  [strUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        //将该uuid保存到keychain
//        [INKeyChainStore save:@"com.company.app.usernamepassword" data:strUUID];
//    }
//    return strUUID;
//
//}
+ (CGSize)sizeWithString:(NSString *)string maxSize:(CGSize)maxSize font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:maxSize//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

+ (NSArray *)getLangugeAndCountryID
{
    NSString *preferredLang = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    // 1.zh-Hans
    if ([preferredLang hasPrefix:@"zh-Hans"]) {
        return @[@"zh_CN",@"110",@"中国"];
    }
    // 2.zh-Hant-TW
    else if ([preferredLang hasPrefix:@"zh-Hant"]) {
        return @[@"zh_TW",@"11071",@"中国台湾"];
    }
    // 3.en
    else if ([preferredLang hasPrefix:@"en"]) {
        return @[@"en_US",@"313",@"美国"];
    }
    // 4.es
    else if ([preferredLang hasPrefix:@"es"]) {
        return @[@"es_ES",@"250",@"西班牙"];
    }
    // 5.ru
    else if ([preferredLang hasPrefix:@"ru"]) {
        return @[@"ru_RU",@"219",@"俄罗斯"];
    }
    // 6.ar_ER
    else if ([preferredLang hasPrefix:@"ar"]) {
        return @[@"ar_SA",@"152",@"沙特阿拉伯"];
    }
    // 7.pt_PT
    else if ([preferredLang hasPrefix:@"pt"]) {
        return @[@"pt_PT",@"420",@"巴西"];
    }
    // 8.id_ID
    else if ([preferredLang hasPrefix:@"in"]) {
        return @[@"in_ID",@"124",@"印度尼西亚"];
    }
    // 9.ms
    else if ([preferredLang hasPrefix:@"ms"]) {
        return @[@"ms_MY",@"121",@"马来西亚"];
    }
    // 10.ja
    else if ([preferredLang hasPrefix:@"ja"]) {
        return @[@"ja_JP",@"114",@"日本"];
    }
    // 11.de
    else if ([preferredLang hasPrefix:@"de"]) {
        return @[@"de_DE",@"224",@"德国"];
    }
    // 12.ko
    else if ([preferredLang hasPrefix:@"ko"]) {
        return @[@"ko_KR",@"113",@"韩国"];
    }
    // 13.fr
    else if ([preferredLang hasPrefix:@"fr"]) {
        return @[@"fr_FR",@"247",@"法国"];
    }
    // 14.vi
    else if ([preferredLang hasPrefix:@"vi"]) {
        return @[@"vi_VN",@"115",@"越南"];
    }
    // 15.it_IT
    else if ([preferredLang hasPrefix:@"it"]) {
        return @[@"it_IT",@"253",@"意大利"];
    }
    // 16.th
    else if ([preferredLang hasPrefix:@"th"]) {
        return @[@"th_TH",@"118",@"泰国"];
    }
    // 17.hi-IN
    else if ([preferredLang hasPrefix:@"hi"]) {
        return @[@"hi_IN",@"128",@"印度"];
    }
    // 18.sw
    else if ([preferredLang hasPrefix:@"sw"]) {
        return @[@"sw_SW",@"545",@"肯尼亚"];
    }
    // 19.nl
    else if ([preferredLang hasPrefix:@"nl"]) {
        return @[@"nl_NL",@"270",@"荷兰"];
    }
    // 20.pl
    else if ([preferredLang hasPrefix:@"pl"]) {
        return @[@"pl_PL",@"265",@"波兰"];
    }
    return @[@"en_US",@"313",@"美国"];
}
+ (NSString *)returnLocalStr:(NSString *)languge{
    if (!languge.length) {
        return nil;
    }
    else if ([languge isEqualToString:@"zh_CN"]) {
        return  @"zh-Hans";
    }
    // 2.zh-Hant-TW
    else if ([languge isEqualToString:@"zh_TW"]) {
        return  @"zh-Hant-TW";
    }
    // 6.ar_ER
    else if ([languge hasPrefix:@"ar"]) {
        return  @"ar-ER";
    }
    // 7.pt_PT
    else if ([languge hasPrefix:@"pt"]) {
        return  @"pt-PT";
    }
    // 8.id_ID
    else if ([languge hasPrefix:@"in"]) {
        return  @"id-ID";
    }
    // 15.it-IT
    else if ([languge hasPrefix:@"it"]) {
        return  @"it-IT";
    }
    // 17.hi-IN
    else if ([languge hasPrefix:@"hi"]) {
        return  @"hi-IN";
    }
    return [languge substringToIndex:2];
}
/**
 *  判断是否打开推送
 */
+ (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}
@end
