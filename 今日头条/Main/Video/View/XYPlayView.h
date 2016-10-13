//
//  XYPlayView.h
//  今日头条
//
//  Created by 尧的mac on 16/9/22.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XYProgressView.h"
@interface XYPlayView : UIView

/**
 *  参数  url等参数
 */
@property(nonatomic,strong)AVPlayerItem *playitem;
/**
 *  播放器
 */
@property(nonatomic,strong)AVPlayer *Player;

/**
 *  播放按钮
 */
@property(nonatomic,strong)UIButton *playButton;
/**
 *  添加AVPlayer的容器
 */
@property(nonatomic,strong)AVPlayerLayer *PlayerLayer;


/**
 *  进度条界面
 */
@property(nonatomic,strong)XYProgressView *XYView;


@property(copy,nonatomic)void(^coverButtonClosure)(UIButton* coverBut);
@end
