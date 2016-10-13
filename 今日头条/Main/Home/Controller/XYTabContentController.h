//
//  XYTabContentController.h
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMyModel.h"
@interface XYTabContentController : UITableViewController

@property(nonatomic,strong)XYMyModel *MyModel;
-(void)updateTitleItem:(NSInteger )model;
@end
