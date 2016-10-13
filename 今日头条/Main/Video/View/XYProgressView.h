//
//  XYProgressView.h
//  今日头条
//
//  Created by 尧的mac on 16/9/22.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYProgressView;
@protocol XYProgressViewDelegate <NSObject>

-(void)ProgressView:(XYProgressView *)ProgressView andSilder:(UISlider *)silder;

-(void)ProgressView:(XYProgressView *)ProgressView andValue:(CGFloat)silderValue;


-(void)ProgressView:(XYProgressView *)ProgressView addSelectFull:(BOOL)addSelect;
-(void)ProgressView:(XYProgressView *)ProgressView addSelectSmall:(BOOL)addSelectSmall;
@end

@interface XYProgressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIProgressView *CacheProgress;


@property (weak, nonatomic) IBOutlet UIButton *fullSrceenBut;
+(instancetype)LoadProgressView;


@property (nonatomic ,weak) id<XYProgressViewDelegate> delegate;
@end
