//
//  NSString+XY.h
//  今日头条
//
//  Created by 尧的mac on 16/9/19.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (XY)

+(NSString *)Stringdate:(NSInteger)time;


+(CGSize)getTextSize:(NSString *)text andFloat:(CGFloat)textFloat;
@end
