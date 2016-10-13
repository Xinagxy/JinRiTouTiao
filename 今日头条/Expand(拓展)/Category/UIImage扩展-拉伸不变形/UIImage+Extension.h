//
//  UIImage+Extension.h
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;

+(UIImage *)resizableImage:(NSString *)name left:(CGFloat )left top:(CGFloat)top;


/**
 *  按指定大小剪切
 */

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size;
@end