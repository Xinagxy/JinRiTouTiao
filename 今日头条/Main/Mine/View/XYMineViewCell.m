//
//  XYMineViewCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/27.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYMineViewCell.h"
#import "XYMineModel.h"

@interface XYMineViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *MineName;
@property (weak, nonatomic) IBOutlet UILabel *MinelibName;

@end
@implementation XYMineViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMineModel:(XYMineModel *)MineModel{
    
    _MineModel = MineModel;
    
    
    self.MineName.text = MineModel.title;
     self.MinelibName.text = MineModel.subtitle;
    
    
}

@end
