//
//  XYVideoCell.m
//  今日头条
//
//  Created by 尧的mac on 16/9/20.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYMyVideoCell.h"
#import "XYNewCellModel.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
@interface XYMyVideoCell ()



@property (weak, nonatomic) IBOutlet UIImageView *soureImage;
@property (weak, nonatomic) IBOutlet UIButton *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *playCount;

@property (weak, nonatomic) IBOutlet UILabel *soureName;




@end
@implementation XYMyVideoCell


- (IBAction)backImageBut:(UIButton *)sender {
     self.playBut.selected = !self.playBut.selected;
    if ([self.delegate respondsToSelector:@selector(MyVideoCell:andImage:)]) {
        
        
        [self.delegate MyVideoCell:self andImage:sender];
    }
    
}

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.backImage.userInteractionEnabled = true;
    
   
}


-(void)setVideoCellModel:(XYNewCellModel *)videoCellModel{
    
    _videoCellModel = videoCellModel;
    
    self.title.text = videoCellModel.title;
    
   
    [self.backImage sd_setBackgroundImageWithURL:[NSURL URLWithString:videoCellModel.middle_image.url]  forState:UIControlStateNormal];
    
    
    [self.soureImage sd_setImageWithURL:[NSURL URLWithString:videoCellModel.media_info.avatar_url]  placeholderImage:[UIImage imageNamed:@"hot_allshare_night_60x60_"]];
    self.soureImage.layer.masksToBounds = true;
    self.soureImage.layer.cornerRadius = CGRectGetWidth(self.soureImage.frame) / 2;

    

    self.soureName.text = videoCellModel.source;
    
    
    NSString * string = nil;
    NSInteger  count =  videoCellModel.comment_count;
    if (count < 10000) {
        if (count == 0) {
             string = [NSString stringWithFormat:@""];
        }else{
        string = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }else{
        
        string = [NSString stringWithFormat:@"%.1f万",count/10000.0];
    }
    
    [self.commentCount setTitle:string forState:UIControlStateNormal];

    
    
    //播放次数
    NSString * playstring = nil;
    NSInteger  playcount =  videoCellModel.video_detail_info.video_watch_count;
    if (playcount < 10000) {
      
            playstring = [NSString stringWithFormat:@"%ld次播放",(long)playcount];
        
    }else{
        
        playstring = [NSString stringWithFormat:@"%.1f万次播放",playcount/10000.0];
    }
    
    self.playCount.text =playstring;
    
    
    //时长
    self.playTime.text = [NSString stringWithFormat:@"%02ld:%02ld",videoCellModel.video_duration/60,videoCellModel.video_duration%60];
    
}


- (IBAction)play:(id)sender {
    
    
}

- (IBAction)more:(id)sender {
    
    
    
}



@end
