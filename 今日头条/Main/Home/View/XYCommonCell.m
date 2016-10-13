//
//  XYCommonCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYCommonCell.h"
#import <UIImageView+WebCache.h>
#import "XYImageURLModel.h"
#import "NSDate+MJ.h"
#import "NSString+XY.h"
@interface XYCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *fristImage;

@property (weak, nonatomic) IBOutlet UIImageView *midImage;
@property (weak, nonatomic) IBOutlet UIImageView *lastImage;
@property (weak, nonatomic) IBOutlet UIImageView *soureImage;
@property (weak, nonatomic) IBOutlet UILabel *soureName;
@property (weak, nonatomic) IBOutlet UILabel *comentCount;
@property (weak, nonatomic) IBOutlet UILabel *time;



@end

@implementation XYCommonCell

- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    
}


-(void)setNewCellModel:(XYNewCellModel *)NewCellModel{
    
    
    _NewCellModel = NewCellModel;

    self.titleName.text = NewCellModel.title;
    XYImageURLModel * urlModel =NewCellModel.image_list[0];
    [self.fristImage sd_setImageWithURL:[NSURL URLWithString:urlModel.url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
      XYImageURLModel * urlModel1 =NewCellModel.image_list[1];
    [self.midImage sd_setImageWithURL:[NSURL URLWithString:urlModel1.url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
    XYImageURLModel * urlModel2 =NewCellModel.image_list[2];
    [self.lastImage sd_setImageWithURL:[NSURL URLWithString:urlModel2.url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
    //来源图片
    if(NewCellModel.media_info.avatar_url != nil){
        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:NewCellModel.media_info.avatar_url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
       
    }else{
        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:NewCellModel.source_avatar]     placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    }
    self.soureImage.layer.masksToBounds = YES;
    self.soureImage.layer.cornerRadius = CGRectGetWidth(self.soureImage.frame) / 2;
    
    
    
    
    self.soureName.text = NewCellModel.source;
    
    NSString * string = nil;
    NSInteger  count =  NewCellModel.comment_count;
    if (count < 10000) {
        string = [NSString stringWithFormat:@"%ld评论",(long)count];
    }else{
        
        string = [NSString stringWithFormat:@"%f万评论",count/10000.0];
    }

    self.comentCount.text = string;

    
    
    self.time.text = [NSString Stringdate:NewCellModel.publish_time ];

}


@end
