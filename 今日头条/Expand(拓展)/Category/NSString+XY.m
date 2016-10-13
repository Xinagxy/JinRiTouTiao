//
//  NSString+XY.m
//  今日头条
//
//  Created by 尧的mac on 16/9/19.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "NSString+XY.h"
#import "NSDate+MJ.h"
#import <UIKit/UIKit.h>
@implementation NSString (XY)

+(NSString *)Stringdate:(NSInteger)time{
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    //    从1970-1-1 00:00:00开始   多少秒后的时间
    NSDate  *localeDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    if (localeDate.isToday) {
        //     获得与当前时间的差距
        if(localeDate.deltaWithNow.hour>=1){
            //时间
            return  [NSString stringWithFormat:@"%ld小时前",localeDate.deltaWithNow.hour];
        }else if (localeDate.deltaWithNow.minute>=1){
            //时间
            return [NSString stringWithFormat:@"%ld分钟前",localeDate.deltaWithNow.minute];
        }else{
            return @"刚刚";
        }
    }else if(localeDate.isYesterday){//昨天
        
        fmt.dateFormat = @"昨天 HH:mm";
        return  [fmt stringFromDate:localeDate];
        
    }else if (localeDate.isThisYear){//今年
        
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:localeDate];
    }else{
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:localeDate];
    }
    
}


+(CGSize)getTextSize:(NSString *)text andFloat:(CGFloat)textFloat{
    
      return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFloat]} context:nil].size;
    
    
    
}
@end
