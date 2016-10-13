//
//  WHC_ContainerBarItem.m
//  WHC_ ContainerView
//
//  Created by 吴海超 on 15/5/15.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//
/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "WHC_ContainerBarItem.h"
#import "WMNightManager.h"
#import "Common.h"
#define KWHC_DeleteButtonSize (12.0)          //删除按钮尺寸
#define KWHC_RotateAngle (1.5)                //编辑时抖动角度
#define KWHC_RotateDuring (0.1)               //编辑时抖动周期
#define KWHC_BadgeSize    (20.0)
@interface WHC_ContainerBarItem (){
    
    UIButton              * _barItemBtn;      //选项按钮
    UIButton              * _deleteBtn;       //删除按钮
    WHCBarItemStyle         _itemStyle;       //按钮样式
}

@end

@implementation WHC_ContainerBarItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initUILayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Style:(WHCBarItemStyle)style{
    self = [super initWithFrame:frame];
    if(self){
        _itemStyle = style;
        [self initUILayout];
    }
    return self;
}

- (void)initSet{
    #pragma mark xxy
     _barItemBtn.backgroundColor = YTColor(236, 236, 236);
    
#pragma mark 夜间模式
//    [_barItemBtn setNightBackImageN:[UIImage imageNamed:@"backgroundView_night"]];
}

- (void)initUILayout{
    self.backgroundColor = [UIColor clearColor];
    _barItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _barItemBtn.frame = self.bounds;
    [_barItemBtn addTarget:self action:@selector(clickBarItem:) forControlEvents:UIControlEventTouchUpInside];
    _barItemBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_barItemBtn];
    if(_itemStyle == ADD_SHOW ||
       _itemStyle == EDIT_SHOW){
        [self initSet];
        if(_itemStyle == EDIT_SHOW){
            [self addDeleteButton];
        }
    }
}

- (void)addDeleteButton{
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(self.frame.size.width - KWHC_DeleteButtonSize,  -1.0, KWHC_DeleteButtonSize, KWHC_DeleteButtonSize);
    _deleteBtn.backgroundColor = [UIColor grayColor];
    _deleteBtn.layer.cornerRadius = KWHC_DeleteButtonSize / 2.0;
    _deleteBtn.layer.masksToBounds = YES;
    [_deleteBtn setTitle:@"×" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    //    [_deleteBtn setEnlargeEdgeWithTop:0 right:0 bottom:KWHC_DeleteButtonSize left:self.frame.size.width];
    
    [_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
//    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _deleteBtn.frame = self.bounds;
//    _deleteBtn.backgroundColor = [UIColor clearColor];
//    [_deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_deleteBtn];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_deleteBtn.width-KWHC_DeleteButtonSize*0.5, -2, KWHC_DeleteButtonSize, KWHC_DeleteButtonSize)];
//    imageView.image = [UIImage imageNamed:@"delete"];
//    [_deleteBtn addSubview:imageView];
//    _deleteBtn.hidden = YES;
}

#pragma mark - propertyOverride -

- (void)setItemStyle:(WHCBarItemStyle)style{
    _itemStyle = style;
    if(_itemStyle == EDIT_SHOW){
        if(_deleteBtn){
            if (![self.subviews containsObject:_deleteBtn]) {
                [self addSubview:_deleteBtn];
            }
        }else{
            [self addDeleteButton];
        }
    }else{
        if(_deleteBtn){
            if([self.subviews containsObject:_deleteBtn]){
                [_deleteBtn removeFromSuperview];
                
            }
            _deleteBtn = nil;
        }
    }
}

- (void)setTitle:(NSString *)title{
    if(title == nil){
        title = @"";
    }
    _title = nil;
    _title = title;
    [_barItemBtn setTitle:_title forState:UIControlStateNormal];
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    _barItemBtn.tag = index;
}

- (void)setNormalFontSize:(CGFloat)normalFontSize{
    _normalFontSize = normalFontSize;
    _barItemBtn.titleLabel.font = [UIFont systemFontOfSize:_normalFontSize];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor = nil;
    _normalTitleColor = normalTitleColor;
    [_barItemBtn setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setNormalNightTitleColor:(UIColor *)normalNightTitleColor{
    _normalNightTitleColor = nil;
    _normalNightTitleColor = normalNightTitleColor;
    [_barItemBtn setNightTColorN:normalNightTitleColor];
}

- (void)setNormalNightBackgroundColor:(UIColor *)normalNightBackgroundColor{
    _normalNightBackgroundColor = nil;
    _normalNightBackgroundColor = normalNightBackgroundColor;
    [_barItemBtn setNightBackgroundColor:normalNightBackgroundColor];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = nil;
    _selectedTitleColor = selectedTitleColor;
}

- (void)dynamicChangeBackgroudColor:(UIColor *)color{
    _barItemBtn.backgroundColor = color;
}

- (void)dynamicChangeTextColor:(UIColor *)color{
    [_barItemBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)dynamicChangeTextSize:(UIFont *)font{
    _barItemBtn.titleLabel.font = font;
}
- (void)startEdit:(NSInteger)type{
    if (type == 1) {
        if (_barItemBtn.tag == 0) {
            _deleteBtn.hidden = YES;
        }else{
            [self animation];
        }
    }else{
        [self animation];
    }
}
- (void)animation
{
    _deleteBtn.hidden = NO;
    double (^angle)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    CABasicAnimation * ba = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ba.fromValue = @(angle(-KWHC_RotateAngle));
    ba.toValue = @(angle(KWHC_RotateAngle));
    ba.repeatCount = MAXFLOAT;
    ba.duration = KWHC_RotateDuring;
    ba.autoreverses = YES;
    [self.layer addAnimation:ba forKey:nil];
}
- (void)stopEdit{
    _deleteBtn.hidden = YES;
    [self.layer removeAllAnimations];
}
#pragma mark - barItemAction -
- (void)clickBarItem:(UIButton*)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(whcContainerBarItem:clickIndex: animated:)]){
        [_delegate whcContainerBarItem:self clickIndex:sender.tag animated:NO];
    }
}
- (void)clickDeleteBtn:(UIButton*)sender{
    sender.tag = _index;
    if(_delegate && [_delegate respondsToSelector:@selector(whcContainerBarItem:clickDeleteBtn: index:)]){
        [_delegate whcContainerBarItem:self clickDeleteBtn:sender index:_index];
    }
}
#pragma mark - other -
- (void)setSelected:(BOOL)selected{
    if(selected){
        [self dynamicChangeTextSize:[UIFont boldSystemFontOfSize:_selectedFontSize]];
        [self dynamicChangeTextColor:_selectedTitleColor];
    }else{
        [self dynamicChangeTextSize:[UIFont boldSystemFontOfSize:_normalFontSize]];
        [self dynamicChangeTextColor:_normalTitleColor];
    }
}
- (BOOL)selected{
    return _barItemBtn.selected;
}
@end
