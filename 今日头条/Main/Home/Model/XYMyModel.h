//
//  XYMyModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMyModel : NSObject
#pragma mark 我的频道模型数据

//频道类别
@property(nonatomic,strong)NSString *category;
//关注id
@property(nonatomic,strong)NSString*concern_id;
/**
 频道名字
 */
@property(nonatomic,strong)NSString *name;

//cell类型
@property(nonatomic,assign)NSInteger  type;

@end
