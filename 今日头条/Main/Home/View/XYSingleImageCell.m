//
//  XYSingleImageCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYSingleImageCell.h"
#import "XYImageURLModel.h"
#import <UIImageView+WebCache.h>
#import "NSDate+MJ.h"
#import "NSString+XY.h"
@interface XYSingleImageCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;


@property (weak, nonatomic) IBOutlet UIImageView *soureImage;
@property (weak, nonatomic) IBOutlet UILabel *soureName;

@property (weak, nonatomic) IBOutlet UILabel *comentCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imageName;

@end

@implementation XYSingleImageCell

- (void)awakeFromNib {
   self.selectionStyle = UITableViewCellSelectionStyleNone;}



-(void)setSingleCellModel:(XYNewCellModel *)SingleCellModel{
    
    
    _SingleCellModel = SingleCellModel;
   
    
    self.titleName.text = SingleCellModel.title;
    
    [self.imageName sd_setImageWithURL:[NSURL URLWithString:SingleCellModel.middle_image.url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
    //来源图片
    if(SingleCellModel.media_info.avatar_url != nil){
        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:SingleCellModel.media_info.avatar_url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
     }else{
        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:SingleCellModel.source_avatar]     placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    }
    self.soureImage.layer.masksToBounds = YES;
    self.soureImage.layer.cornerRadius = CGRectGetWidth(self.soureImage.frame) / 2;

    
    
    
    
    self.soureName.text = SingleCellModel.source;
    
    NSString * string = nil;
    NSInteger  count =  SingleCellModel.comment_count;
    if (count < 10000) {
        string = [NSString stringWithFormat:@"%ld评论",(long)count];
    }else{
        
        string = [NSString stringWithFormat:@"%f万评论",count/10000.0];
    }
    
    self.comentCount.text = string;
    
    
    
     self.time.text = [NSString Stringdate:SingleCellModel.publish_time ];
    
    
}
@end
