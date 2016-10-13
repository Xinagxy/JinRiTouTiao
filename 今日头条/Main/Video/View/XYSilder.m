//
//  XYSilder.m
//  今日头条
//
//  Created by 尧的mac on 16/9/23.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYSilder.h"
#import <UIKit/UIKit.h>
@implementation XYSilder
//返回滑块触摸大小
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value

{
    
    //y轴方向改变手势范围
    rect.origin.y= rect.origin.y-10;
    
    rect.size.height= rect.size.height+20;
    
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],0,0);
    
}




@end
