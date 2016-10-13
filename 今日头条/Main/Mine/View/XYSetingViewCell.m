//
//  XYSetingViewCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/28.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYSetingViewCell.h"
#import "XYSetingModel.h"
@interface XYSetingViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftText;
@property (weak, nonatomic) IBOutlet UILabel *rightText;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (weak, nonatomic) IBOutlet UISwitch *setSwitch;

@property (weak, nonatomic) IBOutlet UIView *line;


@end
@implementation XYSetingViewCell

- (void)awakeFromNib {

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setSetingModel:(XYSetingModel *)setingModel{
    
    _setingModel = setingModel;
    
    self.leftText.text = setingModel.title;
    self.rightText.text = setingModel.rightTitle;
    
    self.arrow.hidden = setingModel.isHiddenArraw;
    self.setSwitch.hidden = setingModel.isHiddenSwitch;
    self.line.hidden = setingModel.isHiddenLine;
    self.rightText.hidden = setingModel.isHiddenRightTitle;

    
    
}

- (IBAction)Switch:(id)sender {
    
    
}


@end
