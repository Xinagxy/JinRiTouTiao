//
//  XYHomeTabController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/14.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYHomeTabController.h"
#import "XYRequestTool.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "Common.h"
#import "XYMyModel.h"
#import "XYContentModel.h"
#import "XYNewCellModel.h"
#import <MJExtension.h>
#import "UIImage+Extension.h"

#import "XYCommonCell.h"
#import "XYSingleImageCell.h"
#import "XYTextCell.h"
#import "XYVideoCell.h"
#import "UIView+Extension.h"
#import "WHC_ContainerView.h"
#import "WHC_ContainerBar.h"
#import <SVProgressHUD.h>
#import "XYDetailsController.h"
@interface XYHomeTabController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *CellModelArr;


@property(nonatomic,assign)NSTimeInterval  lastRefreshTime;
@end

@implementation XYHomeTabController
-(NSMutableArray *)CellModelArr{
    
    if (_CellModelArr == nil) {
        
        _CellModelArr = [NSMutableArray array];
    }
    
    return _CellModelArr;
}
- (void)viewDidLoad {
     [super viewDidLoad];
    
    
     [self setupTableView];

     [self setRefreshData];
}
//初始化数据
-(void)setRefreshData{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(steUpData)];
    self.tableView.mj_header.automaticallyChangeAlpha = true; //根据拖拽比例自动切换透
    [self.tableView.mj_header beginRefreshing];
    

// 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationController.navigationBarHidden = true;
    
}
- (void)setupTableView{
    NSLog(@"先创建控制器，，然后得到类型%@  ",self.MyModel);
    self.view.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.4];
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0, screen_width, screen_height-60-44);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    //注册四种cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYCommonCell class]) bundle:nil] forCellReuseIdentifier:CommonCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSingleImageCell class]) bundle:nil] forCellReuseIdentifier:SingleImageCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYTextCell class]) bundle:nil] forCellReuseIdentifier:TextCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYVideoCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];
}


- (void)steUpData{
    
    
    NSDictionary * params = @{ @"device_id" : @"6096495334",
                               @"category" : self.MyModel,
                               @"iid" : @"5034850950" };
       XYWeakSelf(self);
    [XYRequestTool getDataURL:NewURL params:params progress:^(NSProgress *downloadProgress) {
        
    } success:^(id response) {
       weakself.lastRefreshTime = [NSDate new].timeIntervalSince1970;

        NSArray * conArr =   [XYContentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//        YTLog(@"加载数据：%ld",conArr.count);
        NSMutableArray * mutabArray = [NSMutableArray array];
        for (XYContentModel * contentModel in conArr) {
//                        NSData * data =  [contentModel.content mj_JSONData];
//                        NSDictionary * dict =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                        YTLog(@"%@",dict);
            
            //json字符串转模型
            XYNewCellModel * model =  [XYNewCellModel  mj_objectWithKeyValues:contentModel.content];
            [mutabArray addObject:model];
        }
        
        //mutabArray是新数据
        //self.array是旧数据
        NSMutableArray * tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:mutabArray];
        [tempArray addObjectsFromArray:weakself.CellModelArr];
        
        weakself.CellModelArr = tempArray;
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        // 显示最新的数量(给用户一些友善的提示)
        [weakself showNewStatusCount:(int)mutabArray.count];
    } failue:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
//    NSLog(@"加载页面数据");
    
}


-(void)loadMoreData{
    
    
    NSDictionary * params = @{ @"device_id" : @"6096495334",
                               @"category" : self.MyModel,
                               @"iid" : @"5034850950",
                               @"last_refresh_sub_entrance_interval" : @(self.lastRefreshTime)};
    
    YTLog(@"上次刷新时间：%@", @(self.lastRefreshTime));
    XYWeakSelf(self);
    [XYRequestTool getDataURL:NewURL params:params progress:^(NSProgress *downloadProgress) {
    } success:^(id response) {
        
        NSMutableArray * mutabArray = [NSMutableArray array];
        NSArray * conArr =   [XYContentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        
        for (XYContentModel * contentModel in conArr) {
        
            //json字符串转模型
            XYNewCellModel * model =  [XYNewCellModel  mj_objectWithKeyValues:contentModel.content];
            [mutabArray addObject:model];
        }
        
        //mutabArray是新数据
        [weakself.CellModelArr addObjectsFromArray:mutabArray];

        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
       
    } failue:^(NSError *error) {
       
          [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

    
    
    
}


#pragma mark 显示最新加载数据
- (void)showNewStatusCount:(int)count
{

      // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    [self.navigationController.view insertSubview:btn atIndex:1];
    // 2.设置图片和文字
    btn.backgroundColor = YTColor(215, 233, 246);
    [btn setTitleColor:YTColor(91, 162, 207) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat: @"今日头条推荐引擎有%d条刷新", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"暂无更新，请休息一会儿" forState:UIControlStateNormal];
    
        self.tableView.mj_footer.hidden = true;
    }
    
    btn.frame = CGRectMake(0, 60, screen_width, 35);
    btn.hidden = true;

    // UIViewAnimationOptionCurveEaseInOut  先慢后快     delay延迟加载
    [UIView animateWithDuration:1.0 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
         btn.hidden = NO;
     

    } completion:^(BOOL finished) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [btn removeFromSuperview];
        });
        
        
    }];
}


#pragma mark 传递模型数据
-(void)setMyModel:(NSString *)MyModel{
    
    _MyModel = MyModel;
    
}


//切换不同数据
-(void)updateTitleItem:(NSInteger)model{

    
    YTLog(@"%ld",model);
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.CellModelArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //一系列的判断 加载对应的cell
    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    //多图cell
    if(newModel.image_list.count > 0){
        
        XYCommonCell * imagescell =   [tableView dequeueReusableCellWithIdentifier:CommonCell];
        
        imagescell.NewCellModel = newModel;
        return  imagescell;
    }else{
        
        //只有一张
        if(newModel.has_image){
            XYSingleImageCell * singleCell =   [tableView dequeueReusableCellWithIdentifier:SingleImageCell];
            singleCell.SingleCellModel = newModel;
            return  singleCell;
            
        }else{
            
            if(newModel.has_video){
                XYVideoCell * videoCell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
                videoCell.videoCellModel = newModel;
                return  videoCell;
            }else{
            XYTextCell * textcell =   [tableView dequeueReusableCellWithIdentifier:TextCell];
            
            textcell.TextCellModel = newModel;
            return  textcell;
            }
        }
        
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    XYDetailsController * Details = [[XYDetailsController alloc] init];
    Details.detailModel = newModel;
    [self.navigationController pushViewController:Details animated:true];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //一系列的判断 加载对应的cell
    
    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];

    return  newModel.cellHeight;
}

/**
 *  白色状态栏
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    
    
    return UIStatusBarStyleLightContent;
    
}
@end
