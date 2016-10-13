//
//  XYSearchVideoViewController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/21.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYSearchVideoViewController.h"

#import "UIBarButtonItem+XY.h"

@interface XYSearchVideoViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation XYSearchVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationController.navigationBarHidden = NO;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView.frame = CGRectMake(40, 20, 300, 40);
    self.navigationItem.titleView = _searchBar;
    
    [_searchBar becomeFirstResponder];
    
    
    _searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:@"搜索" selectedColor:nil target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back_os7" highIcon:@"navigationbar_back_highlighted_os7" target:self action:@selector(colse)];

}


-(void)search{
    
    
    
}
-(void)colse{
    
    [self.navigationController popViewControllerAnimated:true];
    
}

#pragma mark - UISerachBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return true;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar endEditing:true];
}
@end
