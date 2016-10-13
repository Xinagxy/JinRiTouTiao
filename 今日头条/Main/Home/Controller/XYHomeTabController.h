//
//  XYHomeTabController.h
//  今日头条
//
//  Created by 尧的mac on 16/9/14.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMyModel.h"
@interface XYHomeTabController : UIViewController
@property(nonatomic,strong)NSString *MyModel;
-(void)updateTitleItem:(NSInteger )model;
@end
