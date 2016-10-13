//
//  XYNewCellModel.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYNewCellModel.h"
#import <MJExtension.h>
#import "XYLargeUrlModel.h"
#import <UIKit/UIKit.h>
#import "Common.h"
@implementation XYNewCellModel

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{@"image_list" : @"XYImageURLModel",
           
             };
}


-(NSInteger)cellHeight{
    
    CGSize size =  [self.title boundingRectWithSize:CGSizeMake(screen_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    
    //这些数字就是固定约束值
    //多图cell
    if(self.image_list.count > 0){
    
        return  10+size.height+105+10*2+20+10+5;
    }else{
        
        //只有一张
        if(self.has_image){
            
            if (25+22+size.height>10+75) {
                
                return 25+22+size.height+25;
            }else{
               return  10+75+18;
            }
    
        }else{
            if (self.has_video) {
                
                return 200+10*2+size.height+20+20;
            }else{
                
                return  10+size.height+20+22+15;
            }
        }
        
    }
    
}
@end
