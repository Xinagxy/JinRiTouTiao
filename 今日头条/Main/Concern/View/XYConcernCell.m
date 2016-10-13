//
//  XYConcernCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/21.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYConcernCell.h"
#import <UIImageView+WebCache.h>
#import "XYConcrenModel.h"
@interface XYConcernCell ()

@property (weak, nonatomic) IBOutlet UIImageView *concernImage;
@property (weak, nonatomic) IBOutlet UILabel *concerName;

@property (weak, nonatomic) IBOutlet UILabel *concernCount;
@property (weak, nonatomic) IBOutlet UIButton *concrenBut;

@end
@implementation XYConcernCell

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellStyleDefault;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    
    
}

-(void)setConcrenModel:(XYConcrenModel *)concrenModel{
    
    _concrenModel = concrenModel;
    [self.concernImage sd_setImageWithURL:[NSURL URLWithString:concrenModel.avatar_url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
    
    self.concerName.text = concrenModel.name;
    
    NSString * string = nil;
    NSInteger  count =  concrenModel.concern_count;
    if (count < 10000) {
            string = [NSString stringWithFormat:@"%ld人关注",(long)count];
        
    }else{
        
        string = [NSString stringWithFormat:@"%.1f万人关注",count/10000.0];
    }
    

    self.concernCount.text = string;
    
    if (concrenModel.flag == YES) {
       
        [self.concrenBut setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else{
        [self.concrenBut setTitle:@"关注" forState:UIControlStateNormal];

    }
    
}


@end
