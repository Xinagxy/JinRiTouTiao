//
//  XYTabController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYTabController.h"
#import "XYNavController.h"
#import "Common.h"
#import "XYhomeController.h"
#import "XYConcernController.h"
#import "XYMineController.h"
#import "XYVideoController.h"
@interface XYTabController ()

@end

@implementation XYTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    YTLog(@"卧槽，，启动页还没走呢！你就来找我呢");
    UITabBar * tab =  [UITabBar appearance];
    
    //文字颜色
    tab.tintColor = YTColor(246, 88, 88);
    
    [self addController];
    
}

-(void)addController{
    
    [self addTabBarItem:[[XYhomeController alloc] init] title:@"首页" image:@"home_tabbar_22x22_" selectImage:@"home_tabbar_press_22x22_"];
    [self addTabBarItem:[[XYVideoController alloc] init] title:@"视频" image:@"video_tabbar_22x22_" selectImage:@"video_tabbar_press_22x22_"];
    [self addTabBarItem:[[XYConcernController alloc] init] title:@"关注" image:@"newcare_tabbar_22x22_" selectImage:@"newcare_tabbar_press_22x22_"];
    [self addTabBarItem:[[XYMineController alloc] init] title:@"我的" image:@"mine_tabbar_22x22_" selectImage:@"mine_tabbar_press_22x22_"];
    
}
-(void)addTabBarItem:(UIViewController * )controller title:(NSString *)titleitem image:(NSString *)image
         selectImage:(NSString *)selectImage{

     controller.title = titleitem;
     controller.tabBarItem.image =[UIImage imageNamed:image];
     controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
     XYNavController * nav =  [[XYNavController alloc] initWithRootViewController:controller];
     [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
