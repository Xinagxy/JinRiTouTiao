//
//  XYVideoDetailsController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/20.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYVideoDetailsController.h"
#import "Common.h"
#import "XYVideoModel.h"
#import <MJRefresh.h>
#import "XYRequestTool.h"
#import "XYContentModel.h"
#import <MJExtension.h>
#import "XYNewCellModel.h"
#import "XYMyVideoCell.h"
#import <SVProgressHUD.h>

#import "UIView+Extension.h"
#import "XYPlayView.h"
#import <KRVideoPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import "XYDetailsController.h"

#import "View+MASAdditions.h"
#import "XYSilder.h"
@interface XYVideoDetailsController ()<UITableViewDelegate,UITableViewDataSource,XYMyVideoCellDelegate>

@property(nonatomic,weak)UITableView * tableView;


@property(nonatomic,strong)NSMutableArray *CellModelArr;
@property(nonatomic,assign)NSTimeInterval  lastRefreshTime;


@property(nonatomic,strong)XYMyVideoCell *myVideoCell;


@property(nonatomic,strong)XYPlayView *PlayView;

@property(nonatomic,assign)NSInteger  selectRow;
@end

@implementation XYVideoDetailsController

-(NSMutableArray *)CellModelArr{
    
    if (_CellModelArr == nil) {
        
        _CellModelArr = [NSMutableArray array];
    }
    
    return _CellModelArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"FullScreenButtonNotification" object:nil];
    
    [self setTableView];
    
    
    [self getRefreshData];
    
    
    YTLog(@"videoModel.category:%@",self.videoModel.category);
    

}

-(void)fullScreenBtnClick:(NSNotification *)notice{
   NSString * falg =  notice.object;
    [self.PlayView removeFromSuperview];
    if (falg.boolValue == 1) {
        
        [self setNeedsStatusBarAppearanceUpdate];
        self.PlayView.transform = CGAffineTransformIdentity;
        self.PlayView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.PlayView.frame = CGRectMake(0, 0, screen_width, screen_height);
        self.PlayView.PlayerLayer.frame =  CGRectMake(0,0, screen_height,screen_width);
        
        
        
        [self.PlayView.XYView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.PlayView).with.offset(0);
            make.width.mas_equalTo(screen_height);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(screen_width-40);

        }];
        [self.PlayView.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(screen_width/2-20);
            make.width.mas_equalTo(40);
            make.left.mas_equalTo(screen_height/2-20);
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.PlayView];
        

    }else{
       
        [UIView animateWithDuration:0.3 animations:^{
            
           self.PlayView.transform = CGAffineTransformIdentity;
           
           self.PlayView.frame = self.myVideoCell.backImage.bounds;
           self.PlayView.PlayerLayer.frame =  self.PlayView.bounds;
           
           [self.myVideoCell.backImage addSubview:self.PlayView];
           
           //显示在最前面
           [self.myVideoCell.backImage bringSubviewToFront:self.PlayView];
           [self.PlayView.XYView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.PlayView).with.offset(0);
               make.right.equalTo(self.PlayView).with.offset(0);
               make.height.mas_equalTo(40);
               make.bottom.equalTo(self.PlayView).with.offset(0);
           }];
           [self.PlayView.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.height.mas_equalTo(40);
               make.top.mas_equalTo(self.myVideoCell.backImage.height/2-20);
               make.width.mas_equalTo(40);
               make.left.mas_equalTo(screen_width/2-20);
               
           }];

       } completion:^(BOOL finished) {
           [self setNeedsStatusBarAppearanceUpdate];
           

       }];
    }
}




-(void)setTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0, screen_width, screen_height-60-44);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYMyVideoCell class]) bundle:nil] forCellReuseIdentifier:MyVideCell];
    [self.view addSubview:tableView];
    
  
    self.tableView = tableView;
    
    

}


-(void)getRefreshData{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(steUpData)];
    self.tableView.mj_header.automaticallyChangeAlpha = true; //根据拖拽比例自动切换透
    [self.tableView.mj_header beginRefreshing];
    

    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
}

- (void)steUpData{

    NSDictionary * params = @{ @"device_id" : @"6096495334",
                               @"category" : self.videoModel.category,
                               @"iid" : @"5034850950" };
    XYWeakSelf(self);
    [XYRequestTool getDataURL:NewURL params:params progress:^(NSProgress *downloadProgress) {
        
    } success:^(id response) {
        weakself.lastRefreshTime = [NSDate new].timeIntervalSince1970;
        
        
        NSArray * conArr =   [XYContentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        //        YTLog(@"加载数据：%ld",conArr.count);
        NSMutableArray * mutabArray = [NSMutableArray array];
        for (XYContentModel * contentModel in conArr) {
//                NSData * data =  [contentModel.content mj_JSONData];
//                NSDictionary * dict =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            YTLog(@"dict：%@",dict);
//
            //json字符串转模型
            XYNewCellModel * model =  [XYNewCellModel  mj_objectWithKeyValues:contentModel.content];
            [mutabArray addObject:model];
        }
        
        //mutabArray是新数据
        //CellModelArr是旧数据
        NSMutableArray * tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:mutabArray];
        [tempArray addObjectsFromArray:weakself.CellModelArr];
//
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
                               @"category" : self.videoModel.category,
                               @"iid" : @"5034850950",
                               @"last_refresh_sub_entrance_interval" : @(self.lastRefreshTime)};
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

-(void)setVideoModel:(XYVideoModel *)videoModel{
    
    _videoModel = videoModel;
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.CellModelArr.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    
    XYMyVideoCell * cell =   [tableView dequeueReusableCellWithIdentifier:MyVideCell];
    cell.delegate  = self;
    cell.videoCellModel = newModel;
    
    self.selectRow  = indexPath.row;
    
#warning 作用等同于didEndDisplayingCell代理
    if (![self.tableView.visibleCells containsObject:self.myVideoCell]) {

        self.myVideoCell.playBut.hidden = NO;
        self.myVideoCell.playBut.selected = NO;
        self.myVideoCell.title.hidden = NO;
        self.myVideoCell.playTime.hidden = NO;
        
        //释放播放器
        [self.PlayView.PlayerLayer removeFromSuperlayer];
        self.PlayView.PlayerLayer = nil;
        
        [self.PlayView.Player.currentItem cancelPendingSeeks];
        [self.PlayView.Player.currentItem.asset cancelLoading];
        self.PlayView.Player = nil;
        [self.PlayView removeFromSuperview];

    }
    return cell;
}
//在这个cell（XYMyVideoCell）结束展示的时候  解决视频播放cell重用问题
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(XYMyVideoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    
//    NSLog(@"%@", cell.backImage.subviews);
//    
//    //    XYMyVideoCell *cell =
//    if (cell.backImage.subviews) {
//        NSLog(@"%@", cell.backImage.subviews.firstObject);
//        
//        cell.playBut.hidden = NO;
//        cell.playBut.selected = NO;
//        cell.title.hidden = NO;
//        cell.playTime.hidden = NO;
//        XYPlayView *PlayView = (XYPlayView *)cell.backImage.subviews.firstObject;
//        [PlayView.Player.currentItem cancelPendingSeeks];
//        [PlayView.Player.currentItem.asset cancelLoading];
//        [PlayView  removeFromSuperview];
//        
//    }
//    
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    XYDetailsController * Details = [[XYDetailsController alloc] init];
    Details.detailModel = newModel;
    [self.navigationController pushViewController:Details animated:true];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //一系列的判断 加载对应的cell  任性了
    
//    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
//    
    return  300;
}



#pragma mark XYMyVideoCellDelegate

-(void)MyVideoCell:(XYMyVideoCell *)cell andImage:(UIButton *)image{
    
    
    
    if (self.myVideoCell != nil) {
       //上一次选中的cell
        self.myVideoCell.playBut.hidden = NO;
        self.myVideoCell.playBut.selected = NO;
        self.myVideoCell.title.hidden = NO;
        self.myVideoCell.playTime.hidden = NO;
        
    
        self.myVideoCell.LoadImage.hidden = YES;
        
        
        //释放播放器
        [self.PlayView.PlayerLayer removeFromSuperlayer];
        self.PlayView.PlayerLayer = nil;
        
        [self.PlayView.Player.currentItem cancelPendingSeeks];
        [self.PlayView.Player.currentItem.asset cancelLoading];
        self.PlayView.Player = nil;
        [self.PlayView removeFromSuperview];

    }
    //当前播放的cell
    cell.playBut.hidden = true;
    cell.title.hidden = true;
    cell.playTime.hidden = true;


    
     //1：设置播放器大小
    XYPlayView * playView =  [[XYPlayView alloc] initWithFrame:image.bounds];
     //1.1:监听播放完毕事件
    [XYNotificationCenter addObserver:self selector:@selector(playFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:playView.playitem];
  
    AVPlayerItem * item =  [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0817/57b3bc156c6ef_wpd.mp4"]];
    //指定播放器url
    playView.playitem = item;
    
    //KVO 监听status属性
    [playView.playitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playView.playitem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //2：将播放器添加到view上
    [image addSubview:playView];
    
    self.PlayView = playView;
    //3：这个是蒙盖的回调  传递蒙盖对象
    [self.PlayView setCoverButtonClosure:^(UIButton *cover) {
       
        cell.title.hidden = !cover.selected;
    }];
    
    
    [self addAnimation:cell.LoadImage];
    self.myVideoCell = cell;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString: @"status"]) {
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
        
        switch (status) {
            case AVPlayerStatusReadyToPlay:
                
                YTLog(@"开始播放");
                
                self.myVideoCell.LoadImage.hidden = YES;
                break;
                
            case AVPlayerStatusFailed:
                YTLog(@"错误");
                
                [SVProgressHUD showErrorWithStatus:@"加载不了视频"];

                break;
            default:
                
                break;
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.PlayView.playitem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        [self.PlayView.XYView.CacheProgress setProgress:timeInterval/totalDuration animated:YES];
    }
    
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.PlayView.Player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    // 计算缓冲总进度
    return CMTimeGetSeconds(timeRange.start)+CMTimeGetSeconds(timeRange.duration);
}


-(void)addAnimation:(UIImageView * )loadImage{
    
    loadImage.hidden = NO;
    
    
   CABasicAnimation * animation  =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1;
    // 绕 z 轴旋转 180°
    animation.toValue =  [NSNumber numberWithFloat:M_PI *2.0];
    animation.cumulative = true;
    animation.repeatCount = HUGE_VALF;
    //结束动画不要移除
    animation.removedOnCompletion = false;
    //最新效果
    animation.fillMode = kCAFillModeForwards;
    //匀速
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [loadImage.layer addAnimation:animation forKey:nil];

}



-(void)playFinish:(NSNotification *)noti{
    
    YTLog(@"播放完成");
    
    [XYNotificationCenter removeObserver:self];
    [self.PlayView.playitem removeObserver:self forKeyPath:@"status"];
    [self.PlayView.playitem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //释放播放器
    [self.PlayView.Player.currentItem cancelPendingSeeks];
    [self.PlayView.Player.currentItem.asset cancelLoading];
    [self.PlayView removeFromSuperview];
    
    self.myVideoCell.playBut.hidden = NO;
    self.myVideoCell.playBut.selected = NO;
    self.myVideoCell.title.hidden = NO;
    self.myVideoCell.playTime.hidden = NO;
    
}
-(void)dealloc{
    
    
    YTLog(@"%s",__func__);
}
@end
