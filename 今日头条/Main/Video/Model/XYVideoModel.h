//
//  XYVideoModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/20.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYVideoModel : NSObject

//category = "subv_funny";
//flags = 0;
//"icon_url" = "";
//name = "\U9017\U6bd4\U5267";
//"tip_new" = 0;
//type = 4;
//"web_url" = "";
/**
 *  类别
 */
@property(nonatomic,strong)NSString *category;
/**
 *  图片
 */
@property(nonatomic,strong)NSString *icon_url;
/**
 *  链接
 */
@property(nonatomic,strong)NSString *web_url;

@property(nonatomic,strong)NSString *name;
//类型
@property(nonatomic,assign)NSInteger  type;
@end
