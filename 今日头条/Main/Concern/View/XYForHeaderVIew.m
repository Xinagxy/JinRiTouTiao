//
//  XYForHeaderVIew.m
//  今日头条
//
//  Created by 尧的mac on 16/9/21.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYForHeaderVIew.h"
#import "Common.h"

@interface XYForHeaderVIew ()

@property(nonatomic,weak)UILabel * textlabel;

@end
@implementation XYForHeaderVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

-(void)setText:(NSString *)text{
    
    _text = text;
    
    self.textlabel.text = text;
    
}
-(void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIView * redview = [[UIView alloc] initWithFrame:CGRectMake(10, 4, 3, 20)];
    redview.backgroundColor = YTColor(241, 94, 91);
    redview.layer.cornerRadius = 2;
    redview.layer.masksToBounds = true;
    [self addSubview:redview];
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_width, 10)];
    textLabel.font = [UIFont systemFontOfSize:14];
    
    self.textlabel = textLabel;
    
    [self addSubview:textLabel];
    
}
@end
