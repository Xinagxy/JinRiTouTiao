//
//  XYProgressView.m
//  今日头条
//
//  Created by 尧的mac on 16/9/22.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYProgressView.h"
#import <UIKit/UIKit.h>
@interface XYProgressView ()

@end
@implementation XYProgressView

+(instancetype)LoadProgressView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}
- (IBAction)fullButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    //放大
    if (sender.selected) {
        NSLog(@"sender.selected:%d",sender.selected);
        if([self.delegate respondsToSelector:@selector(ProgressView:addSelectFull:)]) {
            [self.delegate ProgressView:self addSelectFull:sender.selected];
        }
    }else{//放小
        if([self.delegate respondsToSelector:@selector(ProgressView:addSelectSmall:)]) {
            [self.delegate ProgressView:self addSelectSmall:sender.selected];
        }
    }

}

//滑块滑动监听事件
- (IBAction)sliderCahnger:(UISlider *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(ProgressView:andSilder:)]) {
    
        [self.delegate ProgressView:self andSilder:sender];
    }
}

-(void)awakeFromNib{
    [self.fullSrceenBut setImage:[UIImage imageNamed:@"video_fullscreen"] forState:UIControlStateNormal];
    [self.fullSrceenBut setImage:[UIImage imageNamed:@"video_minimize"] forState:UIControlStateSelected];
    [self.slider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
    

    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
    
    [self.slider addGestureRecognizer:tap];
}

-(void)taps:(UIGestureRecognizer*) getse{
    
    //
    
    CGPoint locationPoint = [getse locationInView:getse.view];
    
    CGFloat scale = locationPoint.x/self.slider.frame.size.width;
     NSLog(@"scale:%f",scale);
    
    if ([self.delegate respondsToSelector:@selector(ProgressView:andValue:)]) {
        
        
        [self.delegate ProgressView:self andValue:scale];
    }
    
    
    
}

@end
