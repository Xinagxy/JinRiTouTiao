//
//  XYSetingModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/28.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSetingModel : NSObject


@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *rightTitle;
@property(nonatomic,assign)BOOL  isHiddenRightTitle;
@property(nonatomic,assign)BOOL  isHiddenLine;
@property(nonatomic,assign)BOOL  isHiddenArraw;
@property(nonatomic,assign)BOOL  isHiddenSwitch;
@end
