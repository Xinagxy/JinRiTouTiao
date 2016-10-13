//
//  XYTextCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYTextCell.h"
#import <UIImageView+WebCache.h>
#import "NSDate+MJ.h"
#import "NSString+XY.h"
@interface XYTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UIImageView *soureImage;
@property (weak, nonatomic) IBOutlet UILabel *Sourename;
@property (weak, nonatomic) IBOutlet UILabel *comentCount;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end

@implementation XYTextCell

- (void)awakeFromNib {
   self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setTextCellModel:(XYNewCellModel *)TextCellModel{
    
    
    _TextCellModel = TextCellModel;
    
    self.titleName.text = TextCellModel.title;
    
    //来源图片
    if(TextCellModel.media_info.avatar_url != nil){

        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:TextCellModel.media_info.avatar_url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
        
    }else{

        [self.soureImage sd_setImageWithURL:[NSURL URLWithString:TextCellModel.source_avatar] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
 
    }
    self.soureImage.layer.masksToBounds = YES;
    self.soureImage.layer.cornerRadius = CGRectGetWidth(self.soureImage.frame) / 2;
    
    
       self.Sourename.text = TextCellModel.source;
    
    NSString * string = nil;
    NSInteger  count =  TextCellModel.comment_count;
    if (count < 10000) {
        string = [NSString stringWithFormat:@"%ld评论",(long)count];
    }else{
        
        string = [NSString stringWithFormat:@"%f万评论",count/10000.0];
    }
    self.comentCount.text = string;
    
    
    self.time.text = [NSString Stringdate:TextCellModel.publish_time ];
    
   
}

@end
