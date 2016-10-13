//
//  XYMineHeadView.m
//  今日头条
//
//  Created by 尧的mac on 16/9/27.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYMineHeadView.h"
#import <UIKit/UIKit.h>
#import "View+MASAdditions.h"

#import "UIView+Extension.h"
#import "XYMineController.h"
#import "XYLogController.h"
#import "XYSetingController.h"
@interface XYMineHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *moreLogn;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation XYMineHeadView


-(void)awakeFromNib{
    
    self.moreLogn.layer.masksToBounds = true;
    self.moreLogn.layer.cornerRadius = 20;
    
    [self.moreLogn addTarget:self action:@selector(Otherlogn) forControlEvents:UIControlEventTouchUpInside];

}

//其他登录方式
-(void)Otherlogn{
    
    
   XYMineController * mineCon =  (XYMineController*)[self viewController];
    
    [mineCon.navigationController pushViewController:[[XYLogController alloc] init] animated:YES];
    
}

+(instancetype)loadMineHeadView{
    
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)iphoe:(id)sender {
    
    
}

- (IBAction)weixin:(id)sender {
    
    
}

- (IBAction)qqlogn:(id)sender {
    
    
}
- (IBAction)weibo:(id)sender {
    
    
}
- (IBAction)otherLon:(id)sender {
    
    
}
- (IBAction)collect:(id)sender {
    
    
    
}
- (IBAction)night:(id)sender {
    
    
    
}
- (IBAction)setting:(id)sender {
    
    XYMineController * mineCon =  (XYMineController*)[self viewController];
    
    [mineCon.navigationController pushViewController:[[XYSetingController alloc] init] animated:YES];
    
    
    
}

-(void)setFrame:(CGRect)frame{
    
    
    frame.origin.y -= 20;
    [super setFrame:frame];

}

@end
