//
//  XYMineController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYMineController.h"

#import "XYMineViewCell.h"
#import <MJExtension.h>
#import "UIView+Extension.h"
#import "XYMineHeadView.h"
#import "XYMineModel.h"
#import "Common.h"
#import "View+MASAdditions.h"

@interface XYMineController ()


@property(nonatomic,strong)NSArray *arr;

@property(nonatomic,strong)XYMineHeadView *headView;
@end

@implementation XYMineController
-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = true;
    self.headView.backImage.contentMode = UIViewContentModeScaleToFill;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
     NSString * plist =  [[NSBundle mainBundle ]pathForResource:@"XYMyCell" ofType:@"plist"];
     NSArray * arr=   [NSArray arrayWithContentsOfFile:plist];
    
     self.arr =[XYMineModel mj_objectArrayWithKeyValuesArray:arr];
    
    // 设置 UI
    [self setupUI];
    
    
}

-(void)setupUI{
    self.tableView.backgroundColor = YTColor(236, 236, 236);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"XYMineViewCell" bundle:nil] forCellReuseIdentifier:ViewCell];
    
//    UIView * footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor redColor];
//    footerView.height = 10;
//    self.tableView.tableFooterView = footerView;
    
    XYMineHeadView *headView = [XYMineHeadView loadMineHeadView];
    headView.frame =CGRectMake(0, 0, 375,260);
    
    self.tableView.tableHeaderView  = headView;
    
    self.headView = headView;
    
    
    self.tableView.rowHeight = 50;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 20, 0);
    self.tableView.bounces = NO;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   NSArray * array=  self.arr[section];
    return array.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * array=  self.arr[indexPath.section];
    
    XYMineModel *model = array[indexPath.row];
    
    XYMineViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:ViewCell];
    
    cell.MineModel =model;
    
    return cell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
}



//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
//   CGFloat offset_Y =  scrollView.contentOffset.y;
//    
//    NSLog(@"offset_Y:%f",offset_Y);
//    CGRect rect =  self.headView.backImage.frame;
//
//    if (offset_Y < 0) {
//        rect.origin.y =offset_Y;
//        rect.size.height = 260 - offset_Y;
//
//        self.headView.backImage.frame = rect;
//    }
//}

/**
 *  白色状态栏
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    
    
    return UIStatusBarStyleLightContent;
    
}


@end
