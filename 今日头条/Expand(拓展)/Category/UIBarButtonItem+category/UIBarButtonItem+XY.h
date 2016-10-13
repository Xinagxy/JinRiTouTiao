//
//  UIBarButtonItem+XY.h
//  YiTong
//
//  Created by 尧的mac on 16/4/13.
//  Copyright © 2016年 xxy.icom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XY)
/**
 *  快速创建一个显示图片的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

/**
 *  快速创建一个显示文字的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithString:(NSString *)string selectedColor:(UIColor *)selectedColor target:(id)target action:(SEL)action;
@end
