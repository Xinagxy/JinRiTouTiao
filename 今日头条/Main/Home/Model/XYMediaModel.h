//
//  XYMediaModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMediaModel : NSObject

//电影来源图片
@property(nonatomic,strong)NSString *avatar_url;

@property(nonatomic,strong)NSString *name;


@property(nonatomic,assign)NSInteger  user_verified;


@property(nonatomic,assign)NSInteger  media_id;
@end
