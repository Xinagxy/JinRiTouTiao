//
//  XYVideoCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYVideoCell.h"
#import <UIImageView+WebCache.h>
#import "NSDate+MJ.h"
#import "NSString+XY.h"
@interface XYVideoCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *sourceImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation XYVideoCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setVideoCellModel:(XYNewCellModel *)videoCellModel{
    
    _videoCellModel = videoCellModel;
    
    
    self.title.text = videoCellModel.title;
    
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:videoCellModel.middle_image.url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    
    //来源图片
    if(videoCellModel.media_info.avatar_url != nil){
        [self.sourceImage sd_setImageWithURL:[NSURL URLWithString:videoCellModel.media_info.avatar_url] placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    }else{
        [self.sourceImage sd_setImageWithURL:[NSURL URLWithString:videoCellModel.source_avatar]     placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    }
    self.sourceImage.layer.masksToBounds = YES;
    self.sourceImage.layer.cornerRadius = CGRectGetWidth(self.sourceImage.frame) / 2;
    
    
    

    self.name.text = videoCellModel.source;
    
    
    
    NSString * string = nil;
    NSInteger  count =  videoCellModel.comment_count;
    if (count < 10000) {
        string = [NSString stringWithFormat:@"%ld评论",(long)count];
    }else{
        
        string = [NSString stringWithFormat:@"%f万评论",count/10000.0];
    }
    self.comment.text = string;
    
    
    self.time.text = [NSString Stringdate:videoCellModel.publish_time ];

    
}



- (IBAction)videoButton:(id)sender {
    
   
    
    
    
    
}

@end
