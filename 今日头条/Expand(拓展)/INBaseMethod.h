//
//  INBaseMethod.h
//  ImportintNews
//
//  Created by app on 15/12/20.
//  Copyright © 2015年 罗文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface INBaseMethod : NSObject
//加载网络图片的方法
+(void)loadImageWithImg:(UIImageView*)imageView  url:(NSString*)urlStr;

//加载网络图片 自定义的占位图
+(void)loadImageWithImg:(UIImageView*)imageView  url:(NSString*)urlStr placeImg:(NSString*)placeImg;

//显示圈圈
+(void)showHUDAddedTo:(UIView*)view animated:(BOOL)animated;
//隐藏圈圈
+(void)hideHUDAddedTo:(UIView*)view animated:(BOOL)animated;

//错误提示
+(void)showErrorWithStr:(NSString*)error toView:(UIView*)view;
//正确的提示
+(void)showSuccessWithStr:(NSString*)success toView:(UIView*)view;

//判断有没有网络
//+(BOOL)connectionInternet;
//获得当前网络状态
+(NSString *)getCurrentReachability;
//获得当前的字体大小
+ (UIFont *)getCurrentFontSize;
//获得当前用户名状态
+ (NSString *)getCurrentUserName;
//获取缓存文件大小
+ (NSString *)getCacheFileSize;
//获取系统当前版本
+ (NSString *)getCurrentVersion;
//获取当前网络设置
+ (NSString *)getCurrentNetSetting;
//获得当前应用版本
+ (NSString *)getCurrentAppVersion;
//获得当前手机类型(如iphone6)
+ (NSString *)getCurrentPhoneNumber;
//获取设备UUID
+ (NSString *)getUUID;
//16进制颜色转化为RGB
+ (UIColor *)getRGBColor:(NSString *)hexColor;
//根据文字计算尺寸
+ (CGSize)sizeWithString:(NSString *)string maxSize:(CGSize)maxSize font:(UIFont *)font;
/**
 *  获取语言
 */
+ (NSArray *)getLangugeAndCountryID;
/**
 *  获取local语言
 */
+ (NSString *)returnLocalStr:(NSString *)languge;
/**
 *  判断是否打开推送
 */
+ (BOOL)isAllowedNotification;
@end
