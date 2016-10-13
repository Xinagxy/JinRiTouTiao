//
//  XYDetailsController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/19.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYDetailsController.h"
#import "Common.h"
#import "UIBarButtonItem+XY.h"
#import "XYNewCellModel.h"
#import "XYBottomView.h"
#import <SVProgressHUD.h>
@interface XYDetailsController ()<UIWebViewDelegate>


@property(nonatomic,strong)UIWebView *webView;
@end

@implementation XYDetailsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = YTColor(245, 245, 245);
    
    [self setupUI];
}

-(void)setupUI{
    
 
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"new_more_titlebar_28x28_" highIcon:@"new_more_titlebar_night_28x28_" target:self action:@selector(DetailClick)];
    
    
    UIWebView * wedView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-44)];
    // 适合屏幕大小
    [wedView setScalesPageToFit:YES];
    //可以打开连接
    wedView.dataDetectorTypes  = UIDataDetectorTypeAll;
    //是否自动播放
    wedView.mediaPlaybackRequiresUserAction = true;
    //设置是否使用内联播放器播放视频
    wedView.allowsInlineMediaPlayback = true;
    
    
    UIScrollView * scr = wedView.scrollView;
    scr.bounces = NO;
    
    
    NSURL * url = [NSURL URLWithString:self.detailModel.display_url];
    [wedView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:wedView];
    
    self.webView = wedView;
    self.webView.delegate = self;
    
    XYBottomView * bottom = [XYBottomView loadBottom];
    bottom.frame = CGRectMake(0, screen_height-44, screen_width, 44);
    bottom.backgroundColor = YTColor(236, 236, 236);
    bottom.commentCount = self.detailModel.comment_count;
    [self.view addSubview:bottom];
    

}

-(void)DetailClick{
    
    
    
}

-(void)setDetailModel:(XYNewCellModel *)detailModel{
    
    
    _detailModel = detailModel;
    
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            
               [SVProgressHUD showWithStatus:@"正在玩命加载......"];
        }); 
        
    });
   
    
 
    
}
//加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            
           [SVProgressHUD dismiss];
        });
        
    });
    
    
}

-(void)dealloc{
   [SVProgressHUD dismiss];
    [self.webView removeFromSuperview];
    self.webView = nil;
     YTLog(@"%@", self.webView);
    YTLog(@"%s", __func__);
}
@end
