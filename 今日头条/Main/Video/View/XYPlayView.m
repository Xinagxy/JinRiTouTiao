//
//  XYPlayView.m
//  今日头条
//
//  Created by 尧的mac on 16/9/22.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYPlayView.h"
#import <UIKit/UIKit.h>
#import "XYProgressView.h"
#import "UIView+Extension.h"
//rgb颜色
#define YTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface XYPlayView ()<XYProgressViewDelegate>



//定时器
@property(nonatomic,strong)NSTimer * progressTimer;



/**
 *  底部进度条
 */
@property(nonatomic,strong)UIProgressView *progressView;


/**
 *  覆盖按钮  点击这个蒙盖时，就隐藏底部进度条界面和播放按钮，  再次点击就显示
 */

@property(nonatomic,strong)UIButton *coverButton;



@end

@implementation XYPlayView


/**
 *  底部进度条界面，，这里需要解决的是点击底部界面会走背景图片点击事件的bug
 *
 *  @return
 */
-(XYProgressView *)XYView{
    
    if (!_XYView){
        _XYView = [XYProgressView LoadProgressView];
        
        _XYView.hidden = true;
        _XYView.delegate = self;
        _XYView.frame = CGRectMake(0, self.height-40, self.width, 40);
        
       
    }
    return _XYView;
    
}

-(UIProgressView *)progressView{
    
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.hidden = true;
        // 设置走过的颜色
        
        _progressView.progressTintColor = YTColor(246, 68, 64);

        // 设置未走过的颜色
        _progressView.trackTintColor = [UIColor lightGrayColor];
        
        _progressView.frame = CGRectMake(0, self.height, self.width, 8);
    }
    
    return _progressView;
}

-(NSTimer *)progressTimer{
    
    
    if (!_progressTimer) {
        
        _progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    
    return _progressTimer;
}

-(AVPlayer *)Player{
    
    
    if(!_Player){
        
        _Player = [[AVPlayer alloc] init];
    }
    
    return _Player;
}
-(AVPlayerLayer *)PlayerLayer{
    
    
    if(!_PlayerLayer){
        
        _PlayerLayer = [[AVPlayerLayer alloc] init];
    }
    
    return _PlayerLayer;
}


-(UIButton *)playButton{
    
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        _playButton.hidden = true;
        [_playButton setImage:[UIImage imageNamed:@"new_play_video_60x60_"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"new_pause_video_60x60_"] forState:UIControlStateSelected];
        _playButton.selected = true;
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       
        _playButton.x = self.width/2 -20;
        _playButton.y = self.height/2 -20;
        _playButton.width = 40;
        _playButton.height = 40;

    }

    return _playButton;
}


-(UIButton *)coverButton{
    
    if (!_coverButton) {
    
        _coverButton = [[UIButton alloc] init];
        _coverButton.backgroundColor = [UIColor clearColor];
        [_coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _coverButton.frame = self.bounds;

    }
    
    return _coverButton;
    
}

//点击播放事件
-(void)playButtonClick:(UIButton *)send{
    
    send.selected = !send.selected;
    //播放
    if (send.selected) {
        
        [self.Player play];
        
        [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];

    } else {
        
        [self.Player pause];
        //移除定时器
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}




#pragma mark  覆盖事件
-(void)coverButtonClick:(UIButton *)send{
    
    send.selected = !send.selected;
    
    self.playButton.hidden = !send.selected;
    
    self.XYView.hidden = !send.selected;
    
    self.progressView.hidden =!self.XYView.hidden;
    //Block传值
    self.coverButtonClosure(send);
}




-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
       NSLog(@"图片大小：%@",NSStringFromCGRect(frame));
        self.backgroundColor = [UIColor clearColor];
        // 布局 UI
        [self setupUI];
    
    }
    
    return self;
    
}




-(void)setupUI{
    
    //添加进度条
    [self addSubview:self.progressView];
    
    //要将视频层添加至AVPlayerLayer中，这样才能将视频显示出来
    self.PlayerLayer.player = self.Player;
    [self.layer addSublayer:self.PlayerLayer];
    
    
    //蒙盖
    [self addSubview:self.coverButton];
    //添加按钮
    [self addSubview:self.playButton];
    //添加底部的进度条
    [self addSubview:self.XYView];
    
    
}


//传递AVPlayerItem值
-(void)setPlayitem:(AVPlayerItem *)playitem{
    
    
    _playitem = playitem;
   //  切换视频
    [self.Player replaceCurrentItemWithPlayerItem:playitem];
    
    //播放
    [self.Player play];
    

    // 添加定时器
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    

    
    self.PlayerLayer.frame = self.layer.bounds;
    self.PlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}


//每秒走一次
-(void)updateProgress{
    
    //视频当前时间
    NSInteger currentTime =  CMTimeGetSeconds([self.Player currentTime]);
    self.XYView.currentTimeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",currentTime/60,currentTime%60];
    
    //视频总时长
    NSInteger time =  CMTimeGetSeconds(self.playitem.duration);
    self.XYView.totalTimeLable.text =[NSString stringWithFormat:@"%02ld:%02ld",time/60,time%60];

    
    //滑块进度
    self.XYView.slider.value = CMTimeGetSeconds([self.Player currentTime]) / time;
    
    //进度条
    self.progressView.progress =CMTimeGetSeconds([self.Player currentTime]) / time;
}





-(void)SilderCommonValue:(CGFloat)value{
    
    // 处理耗时操作的代码块...
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //总时长乘以拖动的比值
        CGFloat tiem =  CMTimeGetSeconds(self.playitem.duration) * value;
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playitem seekToTime:CMTimeMake(tiem,1) completionHandler:^(BOOL finished) {
                
                if(self.playButton.selected == YES){
                    
                    [self.Player play];
                    
                }else{
                    
                    [self.Player pause];
                    [self updateProgress];
                }
            }];
        });
    });
}

#pragma mark XYProgressViewDelegate  滑块拖动监听事件
//拖动
-(void)ProgressView:(XYProgressView *)ProgressView andSilder:(UISlider *)silder{
    
    [self SilderCommonValue:(CGFloat)silder.value];
    
}
//点击
-(void)ProgressView:(XYProgressView *)ProgressView andValue:(CGFloat)silderValue{
    
    [self SilderCommonValue:silderValue];
}

-(void)ProgressView:(XYProgressView *)ProgressView addSelectFull:(BOOL)addSelect{
    
      [[NSNotificationCenter defaultCenter] postNotificationName:@"FullScreenButtonNotification" object:@(addSelect)];
    
}

-(void)ProgressView:(XYProgressView *)ProgressView addSelectSmall:(BOOL)addSelectSmall{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"FullScreenButtonNotification" object:@(addSelectSmall)];
   

    
}

@end
