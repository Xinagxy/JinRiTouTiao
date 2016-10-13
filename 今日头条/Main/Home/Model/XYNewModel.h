//
//  XYNewModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYContentModel.h"
@interface XYNewModel : NSObject

@property(nonatomic,assign)BOOL  has_more_to_refresh;
@property(nonatomic,assign)NSInteger  login_status;

/**一个加载总数*/
@property(nonatomic,assign)NSInteger  total_number;



@property(nonatomic,strong)NSString *concern_info;
@end
