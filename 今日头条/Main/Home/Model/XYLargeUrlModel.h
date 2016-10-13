//
//  XYLargeUrlModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/8.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYLargeUrlModel : NSObject

@property(nonatomic,assign)NSInteger  height;
@property(nonatomic,assign)NSInteger  width;

//视频图片
@property(nonatomic,strong)NSString *url;
@end
