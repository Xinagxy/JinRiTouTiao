//
//  XYBottomView.m
//  今日头条
//
//  Created by 尧的mac on 16/9/20.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYBottomView.h"
#import "Common.h"
#import <UIKit/UIKit.h>
@interface XYBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *starCount;

@property (weak, nonatomic) IBOutlet UITextField *textFile;

@end

@implementation XYBottomView

-(void)awakeFromNib{
    
    self.textFile.layer.cornerRadius = 15;
    self.textFile.layer.masksToBounds = true;
    self.textFile.layer.borderColor = YTColor(220, 220, 220).CGColor;
    self.textFile.layer.borderWidth = 1.0;
    
    self.starCount.layer.cornerRadius = 8;
    self.starCount.layer.masksToBounds = true;
    [self.starCount sizeToFit];
}

+(instancetype)loadBottom{
    
  return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];  
    
    
}
-(void)setCommentCount:(NSInteger)commentCount{
    
    
    _commentCount = commentCount;
    
    self.starCount.text = [NSString stringWithFormat:@"%ld",commentCount];
    
    
}

@end
