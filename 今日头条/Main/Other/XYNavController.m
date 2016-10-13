//
//  XYNavController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYNavController.h"
#import "UIView+Extension.h"
#import "Common.h"
@interface XYNavController ()

@end

@implementation XYNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
   
}

- (void)colse:(UIButton *)but {
    
    [self popViewControllerAnimated:YES];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count>0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        //子类的优先级高于本类中的leftBarButtonItem设置，
        UIButton * custom =  [UIButton buttonWithType:UIButtonTypeCustom];
        [custom setImage:[UIImage imageNamed:@"navigationbar_back_os7"] forState:UIControlStateNormal];
        
        [custom setImage:[UIImage imageNamed:@"navigationbar_back_highlighted_os7"] forState:UIControlStateHighlighted];
        custom.size = CGSizeMake(80, 25);
        custom.contentEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
        [custom addTarget:self action:@selector(colse:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:custom];
        
        
    }
    
    [super pushViewController:viewController animated:animated];
    
    
}

@end
