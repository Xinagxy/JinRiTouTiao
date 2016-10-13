//Created by 尧的mac on 16/6/13.
//Copyright © 2016年 sagacityidea.icom. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

//获取View对应控制器
- (UIViewController *)viewController;


/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;

/**
 *  设置一张被缩放的图片 只是改变了大小
 *
 *  @param imageView 图片
 *  @param rect      大小
 */
-(void)setImageScale:(UIImageView *)imageView andFram:(CGRect)rect;
@end
