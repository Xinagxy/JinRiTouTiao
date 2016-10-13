//
//  XYVideoCell.h
//  今日头条
//
//  Created by 尧的mac on 16/9/20.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYNewCellModel;
@class XYMyVideoCell;

@protocol XYMyVideoCellDelegate <NSObject>

-(void)MyVideoCell:(XYMyVideoCell *)cell andImage:(UIButton *)image;

@end

@interface XYMyVideoCell : UITableViewCell

@property(nonatomic,strong)XYNewCellModel *videoCellModel;

@property (nonatomic ,weak) id<XYMyVideoCellDelegate> delegate;


//背景按钮
@property (weak, nonatomic) IBOutlet UIButton *backImage;

@property (weak, nonatomic) IBOutlet UIButton *playBut;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *playTime;

//加载转圈圈
@property (weak, nonatomic) IBOutlet UIImageView *LoadImage;
@end
