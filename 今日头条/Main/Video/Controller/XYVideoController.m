
//
//  XYVideoController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYVideoController.h"
#import "XYRequestTool.h"
#import <MJRefresh.h>
#import "Common.h"
#import <MJExtension.h>
#import "XYVideoModel.h"
#import <SVProgressHUD.h>
#import "XYVideoDetailsController.h"
#import "UIView+Extension.h"
#import "XYSearchVideoViewController.h"
@interface XYVideoController ()<UIScrollViewDelegate>


@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableArray *videoArr;


@property (nonatomic ,weak) UIButton *selectBut;



/**
 *  存储按钮
 */
@property(nonatomic,strong)NSMutableArray *buttonArr;
@end

@implementation XYVideoController

-(NSMutableArray *)buttonArr{
    
    if (_buttonArr == nil) {
        
        _buttonArr = [NSMutableArray array];
    }
    
    return _buttonArr;
}

-(NSMutableArray *)videoArr{
    
    if (_videoArr == nil) {
        
        
        _videoArr = [NSMutableArray array];
    }
    
    return _videoArr;
    
}


-(void)viewWillAppear:(BOOL)animated{
    
       self.navigationController.navigationBarHidden = true;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    view.backgroundColor = YTColor(225, 223, 225);
    [self.view addSubview:view];

 
    [self setupData];

}

//视频标题内容
-(void)setupData{
    
    NSDictionary * params = @{
                              @"device_id" : @"6096495334",
                              @"version_code" : @"5.6",
                              @"iid" : @"5034850950",
                              @"device_platform" : @"iphone",
                              @"os_version" : @"8.0"
                                     
                            };
   XYWeakSelf(self);
   [XYRequestTool getDataURL:VideoURL params:params progress:^(NSProgress *downloadProgress) {
       
   } success:^(id response) {
       
//       YTLog(@"%@",response[@"data"]);
       
       NSMutableArray * temp = [NSMutableArray array];
       // 添加推荐标题
       NSDictionary * dict = @{@"category": @"video", @"name": @"推荐"};
       XYVideoModel * model =  [XYVideoModel mj_objectWithKeyValues:dict];
       [weakself.videoArr addObject:model];
       [temp addObjectsFromArray:weakself.videoArr];

       
       NSArray * arr =  [XYVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
       [temp addObjectsFromArray:arr];
       
       
       [weakself initializeUI:temp];
       
   } failue:^(NSError *error) {
       
       [SVProgressHUD showErrorWithStatus:@"请求失败"];
   }];
    
    
}

-(void)initializeUI:(NSMutableArray *)videoArr{
    
    for (XYVideoModel * model in videoArr) {
         XYVideoDetailsController * videoDetail = [[XYVideoDetailsController alloc] init];
         videoDetail.title = model.name;
        
         videoDetail.videoModel =model;
        [self addChildViewController:videoDetail];
        
    }
    
    [self setupScrollView];
 
    [self setupTitlesView];
    
    
}

//创建scrollView 将子控制的Tabview添加到scrollView上
-(void)setupScrollView{
    
    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = false;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, screen_width, screen_height-60-44)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = true;
    scrollView.contentSize = CGSizeMake((self.childViewControllers.count) * screen_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    
    
   
}


-(void)setupTitlesView{
    
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screen_width-40, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.showsHorizontalScrollIndicator = NO;
    view.bounces = NO;
    [self.view addSubview:view];
    
    // 视频标签按钮个数
    NSInteger count =self.childViewControllers.count;
    
    CGFloat heightBut = view.height;
    CGFloat widhtBut = 60;
    view.contentSize = CGSizeMake(count * widhtBut, 0);
    for (int i = 0 ; i < count; i++) {
        
        UIButton * titleBut = [[UIButton alloc] init];
        titleBut.frame =CGRectMake(i * widhtBut, 0, widhtBut, heightBut);
      
        [titleBut setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
         titleBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleBut setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        titleBut.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleBut addTarget:self action:@selector(TitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:titleBut];
        
        [self.buttonArr addObject:titleBut];
        self.selectBut = titleBut;
    }
    
     // 默认点击第一个的按钮
    
    UIButton * firstButton=  self.buttonArr.firstObject;
    [firstButton.titleLabel sizeToFit];
    [self TitleClick:firstButton];
    
    
    
    
    UIButton * searchBut = [[UIButton alloc] initWithFrame:CGRectMake(screen_width-40, 20, 40, 40)];
    
    [searchBut setImage:[UIImage imageNamed:@"search_topic_24x24_"] forState:UIControlStateNormal];
    [searchBut addTarget:self action:@selector(searchData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBut];
}


-(void)searchData:(UIButton *)send{
    
    
    [self.navigationController pushViewController:[[XYSearchVideoViewController alloc] init] animated:true];
}


-(void)TitleClick:(UIButton *)send{
    
    // 控制按钮选中状态
    self.selectBut.selected = false;
    send.selected = true;
    self.selectBut = send;

    
    
    //scrollView滚动到指定位置
   CGPoint offset =  self.scrollView.contentOffset;
   //位置乘宽  等于需要偏移位置
    offset.x = screen_width* [self.buttonArr indexOfObject:send];
    
    [self.scrollView setContentOffset:offset animated:true];
    
}

#pragma mark UIScrollViewDelegate
/**
 当滚动动画完毕的时候调用   执行该setContentOffset方法调用
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
    NSInteger  index =  scrollView.contentOffset.x/scrollView.width;
   
    XYVideoDetailsController * videoDetail = self.childViewControllers[index];
    
    videoDetail.view.frame  = scrollView.bounds;
    
    //添加控制器view到scrollView
    [scrollView addSubview:videoDetail.view];
}

/**
 * 当减速完毕的时候调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger  index =  scrollView.contentOffset.x/scrollView.width;
    
    NSLog(@"index:%ld",index);
    
    //拖动view对应的按钮
    UIButton * indexBut =  self.buttonArr[index];
    [self TitleClick:indexBut];
    
}
@end
