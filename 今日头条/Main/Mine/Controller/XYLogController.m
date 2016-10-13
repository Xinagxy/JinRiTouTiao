//
//  XYLogController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/28.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYLogController.h"

@interface XYLogController ()

@end

@implementation XYLogController
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
