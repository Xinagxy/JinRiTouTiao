//
//  XYhomeController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYhomeController.h"
#import "WHC_ContainerView.h"
#import "XYTabContentController.h"
#import "XYHomeTabController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "Common.h"
#import "XYMyModel.h"
#import "XYHomeDataTool.h"
#import <SVProgressHUD.h>
@interface XYhomeController ()<WHC_ContainerViewDelegate>
//我的栏目
@property(nonatomic,strong)NSMutableArray *modelArr;
//推荐栏目
@property(nonatomic,strong)NSArray *recommenArr;
//控制器数组
@property(nonatomic,strong)NSMutableArray *arrController;

//第一栏数据
@property(nonatomic,strong)NSMutableArray *fristArr;

//第二栏数据
@property(nonatomic,strong)NSMutableArray *twoArr;


@property(nonatomic,assign)NSInteger  Flag;

@property(nonatomic,strong)NSMutableArray *totalNum;
@end

@implementation XYhomeController

-(NSMutableArray *)totalNum{
    
    if (_totalNum == nil) {
        
        _totalNum = [NSMutableArray array];
    }
    return _totalNum;
}

-(NSArray *)recommenArr{
    
    if (_recommenArr == nil) {
        
        _recommenArr = [NSArray array];
    }
    
    return _recommenArr;
}
-(NSMutableArray *)modelArr{
    
    if (_modelArr == nil) {
        
        _modelArr = [NSMutableArray array];
    }
    
    return _modelArr;
    
}
-(NSMutableArray *)arrController{
    
    
    if (_arrController == nil) {
        
        _arrController  = [NSMutableArray array];
    }
    
    return _arrController;
}

-(NSMutableArray *)fristArr{
    
    if (_fristArr == nil) {
        
        _fristArr  = [NSMutableArray array];
    }
    
    return _fristArr;
    
}

-(NSMutableArray *)twoArr{
    
    if (_twoArr == nil) {
        
        _twoArr  = [NSMutableArray array];
    }
    
    return _twoArr;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBarHidden = true;
    [self initdata];
    
}

-(void)setTitleName{
    
   YTLog(@"标题个数：%ld   推荐个数：%ld",self.fristArr.count,self.twoArr.count);
    WHC_ContainerBarParam * param =  [WHC_ContainerBarParam getWHC_ContainerViewParamWithTitles:self.fristArr laterTitlesArr:self.twoArr];
    param.isSegmentLine = NO;
    param.isFootLine = NO;
    param.isHeaderLine = NO;

    
    WHC_ContainerView  * containerView = [[WHC_ContainerView alloc]initWithFrame:CGRectMake(0.0,20.0,self.view.width,self.view.height) param:param];
    containerView.delegate = self;
    [self.view addSubview:containerView];
    
    
   
    //将导航栏变为红色
    UIView * view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    view.backgroundColor = YTColor(213, 14, 29);
    [self.view addSubview:view];
}


-(void)initdata{
    //我的频道数据
    XYWeakSelf(self);
    XYhomeToolModel * toolModel = [[XYhomeToolModel alloc] init];
    toolModel.device_id = @"6096495334";
    toolModel.aid = @"13";
    toolModel.iid = @"5034850950";
    
    [XYHomeDataTool XYHomeParam:toolModel HomeURL:MYURL progress:^(NSProgress *downloadProgress) {
        
    } success:^(id response) {
       
        weakself.modelArr = (NSMutableArray *) response;
        [weakself.totalNum addObjectsFromArray:weakself.modelArr];
        for (XYMyModel * model in response) {
           NSString * titleName =  model.name;
           [weakself.fristArr addObject:titleName];
        }
        //推荐栏目数据
        [XYHomeDataTool XYHomeParam:toolModel HomeURL:RecommenURL progress:^(NSProgress *downloadProgress) {
        } success:^(id response) {
            
            weakself.recommenArr = (NSMutableArray *) response;
            [weakself.totalNum addObjectsFromArray:weakself.recommenArr];
            for (XYMyModel * model in response) {
                NSString * titleName =  model.name;
                [weakself.twoArr addObject:titleName];
            }
            
            [weakself setTitleName];
            
        } failue:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];
        
    } failue:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

}

#pragma mark - WHC_ContainerViewDelegate -
- (NSArray *)whc_ContainerView:(WHC_ContainerView *)containerView updateContainerViewLayoutWithTitlesArr:(NSArray *)titlesArr{
    
    for (NSInteger i = 0; i < self.arrController.count;) {
        XYHomeTabController  * Conview = self.arrController[i];
        [Conview.view removeFromSuperview];
        //把控制器从数组中删除
        [self.arrController removeObject:Conview];
        Conview.view = nil;
        [Conview removeFromParentViewController];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * arr = [NSMutableArray array];
    
    //第一步 将name作为key   category作为value存储在数组中
    for (int i = 0; i < titlesArr.count ; i++) {
        XYMyModel * model = self.totalNum[i];
        
        [dict setValue:model.category forKey:model.name];
    }
     [arr addObject:dict];

  
   
    for (int i = 0; i < titlesArr.count ; i++) {
         //第二步  替换
        for (NSString * arrName in [arr[0] allKeys]) {
            
            if ([arrName isEqualToString:titlesArr[i]]) {
                
                XYHomeTabController * test = [[XYHomeTabController alloc] init];
                if (self.totalNum) {
        #warning 这里获取到数据model后，  传递每个标签类型(id,类型)，然后在TestViewController控制器中进行判断设置相应的数
                    test.MyModel = [arr[0] objectForKey:arrName];
                    [self addChildViewController:test];
                    [self.arrController addObject:test];
                }
            }
        }
        
    }

    return self.arrController;
}
- (void)whc_ContainerView:(WHC_ContainerView *)containerView loadContentForCurrentView:(UIViewController *)currentView currentIndex:(NSInteger)index{
        [(XYTabContentController *)currentView updateTitleItem:index];
}
/**
 *  白色状态栏
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    
    
    return UIStatusBarStyleLightContent;
    
}
@end
