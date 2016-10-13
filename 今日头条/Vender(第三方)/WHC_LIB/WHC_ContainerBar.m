//
//  WHC_ContainerBar.m
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

#import "WHC_ContainerBar.h"
#import "Common.h"
#import "INBaseMethod.h"
#import "WMNightManager.h"
#define KWHC_TitleMargin   20.0                  //标题文字边距
#define KWHC_DropImageSize (15.0)                //下拉图片尺寸
#define KWHC_AnimatedDuring (0.2)                //游标移动动画周期
@implementation WHC_ContainerBarParam

+ (WHC_ContainerBarParam *)getWHC_ContainerViewParamWithTitles:(NSMutableArray*)titlesArr laterTitlesArr:(NSMutableArray *)laterTitlesArr{
    WHC_ContainerBarParam  * param = [WHC_ContainerBarParam new];
    if(titlesArr == nil){
        titlesArr =  [NSMutableArray new];
    }
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:KWHC_ContainerConfigurationKey];
    if(dict && dict.count > 0){
        NSMutableArray  * tempTitlesArr = [dict[KWHC_ContainerTitlesArrKey] mutableCopy];
        NSMutableArray  * tempLaterTitlesArr = [dict[KWHC_ContainerLaterTitlesArrKey] mutableCopy];
        
        if(tempLaterTitlesArr.count + tempTitlesArr.count < titlesArr.count + laterTitlesArr.count){
            NSMutableString * strTempTitles = [NSMutableString new];
            NSMutableString * strTempLatertTitles = [NSMutableString new];
            for (NSString * txt in tempTitlesArr) {
                [strTempTitles appendString:txt];
            }
            for (NSString * txt in tempLaterTitlesArr) {
                [strTempLatertTitles appendString:txt];
            }
            for (NSString * txt in titlesArr) {
                if(![strTempTitles containsString:txt] && ![strTempLatertTitles containsString:txt]){
                    [tempLaterTitlesArr addObject:txt];
                }
            }
            for (NSString * txt in laterTitlesArr) {
                if(![strTempTitles containsString:txt] && ![strTempLatertTitles containsString:txt]){
                    [tempLaterTitlesArr addObject:txt];
                }
            }
            [WHC_ContainerBar saveContainerBarTitlesArr:tempTitlesArr laterTitlesArr:tempLaterTitlesArr];
        }
        param.titlesArr = [tempTitlesArr mutableCopy];
        param.laterTitlesArr = [tempLaterTitlesArr mutableCopy];
    }else{
        param.titlesArr = [titlesArr mutableCopy];
        param.laterTitlesArr = [laterTitlesArr mutableCopy];
    }
    param.mustSaveItemCount = 1;
    param.fontSize = 17.0;
    param.focusFontSize = 17.0;
    param.focusFontColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    param.fontColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    param.visableCursor = NO;
    param.cursorMargin = 3.0;
    //param.cursorColor = [UIColor orangeColor];
    param.cursorHeight = 3.0;
    param.defaultFocusItem = 0;
    param.isHeaderLine = NO;
    param.isFootLine = NO;
    //param.headerLineColor = [UIColor clearColor];
    //param.footLineColor = [UIColor grayColor];
    //param.segmentLineColor = param.footLineColor;
    // param.lineWidth = 0.5;
    param.isSegmentLine = NO;
    param.segmentLineMargin = 0.0;
    return param;
}

@end

@interface WHC_ContainerBar ()<WHC_ContainerBarItemDelegate>
{
    WHC_ContainerBarParam             * _containerBarParam;          //容器参数
    UIScrollView                      * _containerBarItemView;       //容器项
    UIButton                          * _dropBtn;                    //编辑按钮
    UIImageView                       * _dropImageView;              //下拉图片
    UIView                            * _cursorView;                 //游标
    NSInteger                           _barItemCount;               //项的总数
    NSInteger                           _currentBarItemIndex;        //当前选项下标
    CGFloat                             _barItemWidth;               //item宽度
    CGFloat                             _currentCursorX;             //当前游标x
    NSInteger                           _pageIndex;                  //页下标
    BOOL                                _isLeft;                     //是否点击左边
    BOOL                                _isFristBarItem;             //是否是第一个item
    BOOL                                _isClickBarItem;             //是否点击item切换
}
@end

@implementation WHC_ContainerBar

- (instancetype)initWithFrame:(CGRect)frame param:(WHC_ContainerBarParam*)param{
    NSParameterAssert(param);
    self = [super initWithFrame:frame];
    if(self){
        _containerBarParam = param;
        [self initUILayout];
    }
    return self;
}

- (void)updateContainerBarItemView{
    for (UIView * view in _containerBarItemView.subviews) {
        if([view isKindOfClass:[WHC_ContainerBarItem class]] ||
           [view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    _barItemCount = _containerBarParam.titlesArr.count;
    _barItemWidth = [self calcBarItemTitleWidth];
    CGFloat   replaceBarItemWidth = _containerBarItemView.width / (CGFloat)_barItemCount;
    _barItemWidth = _barItemWidth < replaceBarItemWidth ? replaceBarItemWidth : _barItemWidth;
    for (NSInteger i = 0; i < _barItemCount; i++) {
        CGFloat barItemHeight = self.height;
        CGFloat barItemY = 0.0;
        if(_containerBarParam.isFootLine){
            barItemHeight -= _containerBarParam.lineWidth;
        }
        if(_containerBarParam.isHeaderLine){
            barItemY = _containerBarParam.lineWidth;
            barItemHeight -= _containerBarParam.lineWidth;
        }
        if(_containerBarParam.isFootLine && _containerBarParam.isHeaderLine){
            barItemHeight -= _containerBarParam.lineWidth * 2.0;
        }
        CGFloat x = i * _barItemWidth;
        if(_containerBarParam.isSegmentLine){
            x = i * _barItemWidth + i * _containerBarParam.lineWidth;
        }
        CGRect  barItemRC = {x, barItemY, _barItemWidth , barItemHeight};
        WHC_ContainerBarItem * barItem = [[WHC_ContainerBarItem alloc]initWithFrame:barItemRC];
        barItem.delegate = self;
        barItem.index = i;
        barItem.title = _containerBarParam.titlesArr[i];
        barItem.normalFontSize = _containerBarParam.fontSize;
        barItem.normalTitleColor = _containerBarParam.fontColor;
        barItem.selectedFontSize = _containerBarParam.focusFontSize;
        barItem.selectedTitleColor = _containerBarParam.focusFontColor;
#pragma mark xxy
        if(_containerBarParam.defaultFocusItem == i){
            barItem.selected = YES;
        }else{
            barItem.selected = NO;
        }
        if(_containerBarParam.isSegmentLine && i < _barItemCount - 1){
            UILabel * segmentLineLab = [[UILabel alloc]initWithFrame:CGRectMake((i + 1) * _barItemWidth + i * _containerBarParam.lineWidth, _containerBarParam.segmentLineMargin, _containerBarParam.lineWidth, self.height - _containerBarParam.segmentLineMargin * 2.0)];
            segmentLineLab.backgroundColor = _containerBarParam.segmentLineColor;
            [_containerBarItemView addSubview:segmentLineLab];
        }
        [_containerBarItemView addSubview:barItem];
    }
    if(_containerBarParam.visableCursor){
        if(_cursorView){
            [_cursorView removeFromSuperview];
            _cursorView = nil;
        }
        _currentCursorX = _containerBarParam.cursorMargin;
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(_currentCursorX, self.height - _containerBarParam.cursorHeight, _barItemWidth - _containerBarParam.cursorMargin * 2.0, _containerBarParam.cursorHeight)];
        _cursorView.backgroundColor = _containerBarParam.cursorColor;
        [_containerBarItemView addSubview:_cursorView];
    }
    [_containerBarItemView setContentSize:CGSizeMake(_barItemWidth * _barItemCount, 0.0)];
    if(_containerBarParam.isSegmentLine){
        [_containerBarItemView setContentSize:CGSizeMake(_barItemWidth * _barItemCount + (_barItemCount - 1) * _containerBarParam.lineWidth, 0.0)];
    }
}
- (void)initUILayout{
#pragma mark xxy 背景色
    self.backgroundColor =YTColor(213,14, 29);
//    self.nightBackgroundColor = [UIColor blackColor];
    
    _currentBarItemIndex = _containerBarParam.defaultFocusItem;
    if(_containerBarParam.isHeaderLine){
        UILabel  * headerLineLab = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.width, _containerBarParam.lineWidth)];
        headerLineLab.backgroundColor = _containerBarParam.headerLineColor;
        [self addSubview:headerLineLab];
    }
    
    CGRect   containerBarItemViewRC = self.bounds;
    if(_containerBarParam.isHeaderLine){
        containerBarItemViewRC.origin.y = _containerBarParam.lineWidth;
        containerBarItemViewRC.size.height = self.height - _containerBarParam.lineWidth;
    }
    containerBarItemViewRC.size.width = self.width - KWHC_DropBtn_Width;
    _containerBarItemView = [[UIScrollView alloc]initWithFrame:containerBarItemViewRC];
    _containerBarItemView.showsHorizontalScrollIndicator = NO;
    _containerBarItemView.showsVerticalScrollIndicator = NO;
    
    if(_containerBarParam.isFootLine){
        _containerBarItemView.height = self.height - _containerBarParam.lineWidth;
        if(_containerBarParam.isHeaderLine){
            _containerBarItemView.height = self.height - _containerBarParam.lineWidth * 2.0;
        }
        UILabel  * footLineLab = [[UILabel alloc]initWithFrame:CGRectMake(0.0, _containerBarItemView.maxY, self.width, _containerBarParam.lineWidth)];
        footLineLab.backgroundColor = _containerBarParam.footLineColor;
        [self addSubview:footLineLab];
    }
    
    [self updateContainerBarItemView];
    [self addSubview:_containerBarItemView];
    CGFloat  dropBtnY = 0.0;
    if(_containerBarParam.isHeaderLine){
        dropBtnY = _containerBarParam.lineWidth;
    }
    _dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dropBtn.frame = CGRectMake(_containerBarItemView.maxX, dropBtnY, KWHC_DropBtn_Width, _containerBarItemView.height);
    #pragma mark  xxy
    _dropBtn.backgroundColor = YTColor(213,14, 29);
    [_dropBtn setImage:[UIImage imageNamed:@"add_channel_titlbar_16x16_"] forState:UIControlStateNormal];
    [_dropBtn setAdjustsImageWhenHighlighted:NO];
    [_dropBtn addTarget:self action:@selector(clickDropBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dropBtn];
}
+ (void)saveContainerBarTitlesArr:(NSArray *)titlesArr laterTitlesArr:(NSArray *)laterTitlesArr{
    //save configuration
    NSUserDefaults  * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary    * dict = @{KWHC_ContainerTitlesArrKey:titlesArr,
                               KWHC_ContainerLaterTitlesArrKey:laterTitlesArr};
    [ud setObject:dict forKey:KWHC_ContainerConfigurationKey];
    [ud synchronize];
}

- (CGFloat)calcBarItemTitleWidth{
    CGFloat  barItemWidth = 0.0;
    __weak typeof(self) sf  = self;
    
    CGFloat (^titleWidth)(NSString*) = ^(NSString* strTitle){
        
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        
//        CGSize  titleSize = [strTitle sizeWithFont:[UIFont boldSystemFontOfSize:_containerBarParam.focusFontSize] constrainedToSize:sf.size];
    CGSize  titleSize = [INBaseMethod sizeWithString:strTitle maxSize:sf.frame.size font:[UIFont systemFontOfSize:_containerBarParam.focusFontSize]];
//#pragma clang diagnostic pop
        
        return titleSize.width;
    };
    
    for (NSInteger i = 0; i < _barItemCount; i++) {
        NSString  * strTitle = _containerBarParam.titlesArr[i];
        CGFloat     strTitleWidth = titleWidth(strTitle);
        if(barItemWidth < strTitleWidth){
            barItemWidth = strTitleWidth;
        }
    }
    return barItemWidth + KWHC_TitleMargin;
}

- (void)clickDropBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    if(_delegate && [_delegate respondsToSelector:@selector(whc_ContainerBar:clickDrop:)]){
        [_delegate whc_ContainerBar:self clickDrop:sender];
    }
}

- (WHC_ContainerBarItem *)barItemWithIndex:(NSInteger)index{
    WHC_ContainerBarItem  * item = nil;
    for (WHC_ContainerBarItem * itemBar in _containerBarItemView.subviews) {
        if([itemBar isKindOfClass:[WHC_ContainerBarItem class]] && index == itemBar.index){
            item = itemBar;
            break;
        }
    }
    return item;
}

- (void)resetBarItemStateMaxIndex:(NSUInteger)index oriX:(CGFloat)oriX{
    NSInteger  count = index - 1;
    NSInteger  i = 0;
    if(oriX < 0.0){
    WHC:
        for (i = 0; i < count; i++) {
            
            WHC_ContainerBarItem * barItem = [self barItemWithIndex:i];
            [barItem dynamicChangeBackgroudColor:_containerBarParam.itemBarNBackgroudColor];
            [barItem dynamicChangeTextColor:_containerBarParam.fontColor];
            [barItem dynamicChangeTextSize:[UIFont boldSystemFontOfSize:_containerBarParam.fontSize]];
        }
    }else if(oriX > 0){
        count = _containerBarParam.titlesArr.count;
        //        i = index;
        goto WHC;
    }
}

- (void)beginDynamicChangeStateOffsetX:(CGFloat)offsetX pageIndex:(NSInteger)pageIndex oriX:(CGFloat)oriX{
    if(_containerBarParam.visableCursor ){
        _currentCursorX = _cursorView.x;
    }
    [self resetBarItemStateMaxIndex:offsetX / self.width + 1 oriX:oriX];
}

- (void)dynamicChangeStateOffsetX:(CGFloat)offsetX oriX:(CGFloat)oriX{
    
    if(YES){
        _isLeft = NO;
        CGFloat sumItemWidth = _barItemWidth;
        if(_containerBarParam.isSegmentLine){
            sumItemWidth = _barItemWidth + ((_barItemCount - 1) * _containerBarParam.lineWidth) / (CGFloat)_barItemCount;
        }
        CGFloat localOffsetX = offsetX * (sumItemWidth / self.width);
        int pageIndex = offsetX / self.width + 1;
        if(pageIndex <= 0){
            _isFristBarItem = YES;
            pageIndex = 1;
        }else{
            _isFristBarItem = NO;
        }
        _pageIndex = pageIndex - 1;
        float percent = fabs((localOffsetX - sumItemWidth * (pageIndex - 1)) / sumItemWidth);
        if(oriX < 0){
            _isLeft = YES;
        }else if (oriX > 0){
            _isLeft = NO;
        }
        if(_isLeft && ((int)offsetX % (int)self.width) == 0){
            percent = 1.0;
            if(pageIndex > 1){
                pageIndex -= 1;
            }
        }
        if(_containerBarParam.visableCursor){
            _cursorView.x = localOffsetX + _containerBarParam.cursorMargin;
        }
        #pragma mark xxy 当前标题
        WHC_ContainerBarItem  * currentBarItem = [self barItemWithIndex:pageIndex - 2];
        CGFloat    ts_red , ts_green , ts_blue , ts_alpha,
        tn_red , tn_green , tn_blue , tn_alpha;
        
        [_containerBarParam.fontColor getRed:&tn_red green:&tn_green blue:&tn_blue alpha:&tn_alpha];
        [_containerBarParam.focusFontColor getRed:&ts_red green:&ts_green blue:&ts_blue alpha:&ts_alpha];
        
        CGFloat color_rate = percent;
        
        
//        UIColor * currentTxtColor = [UIColor colorWithRed:ts_red * (1.0 - color_rate) + tn_red * color_rate
//                                                    green:ts_green * (1.0 - color_rate) + tn_green * color_rate
//                                                     blue:ts_blue * (1.0 - color_rate) + tn_blue * color_rate
//                                                    alpha:ts_alpha];
#pragma mark xxy
        [currentBarItem dynamicChangeTextColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [currentBarItem dynamicChangeTextSize:[UIFont boldSystemFontOfSize:_containerBarParam.focusFontSize * (1.0 - color_rate) + _containerBarParam.fontSize * color_rate]];
        if(!_isLeft && _isFristBarItem){
            return;
        }
        
#pragma mark xxy 下一个标题
        WHC_ContainerBarItem  * unknownBarItem = [self barItemWithIndex:pageIndex-1];
        
//        UIColor * unknownTxtColor = [UIColor colorWithRed:tn_red * (1.0 - color_rate) + ts_red * color_rate
//                                                    green:tn_green * (1.0 - color_rate) + ts_green * color_rate
//                                                     blue:tn_blue * (1.0 - color_rate) + ts_blue * color_rate
//                                                    alpha:tn_alpha];
        
        [unknownBarItem dynamicChangeTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        [unknownBarItem dynamicChangeTextSize:[UIFont boldSystemFontOfSize:_containerBarParam.fontSize * (1.0 - color_rate) + _containerBarParam.focusFontSize * color_rate]];
    }
}
- (void)endDynamicChangeStateOffsetX:(CGFloat)offsetX currentPageIndex:(NSInteger)currentPageIndex{
    if(_containerBarParam.visableCursor){
        _currentCursorX = _cursorView.x;
    }
    CGFloat sumItemWidth = _barItemWidth;
    if(_containerBarParam.isSegmentLine){
        sumItemWidth = _barItemWidth + ((_barItemCount - 1) * _containerBarParam.lineWidth) / (CGFloat)_barItemCount;
    }
    _currentBarItemIndex = currentPageIndex;
    NSInteger startOffsetIndex = (_containerBarItemView.width / sumItemWidth) / 2.0;
    CGFloat localOffsetX = offsetX * (sumItemWidth / self.width) - sumItemWidth * startOffsetIndex;
    if(localOffsetX < 0){
        localOffsetX = 0.0;
    }else if (_containerBarItemView.contentSize.width - _containerBarItemView.width < localOffsetX){
        localOffsetX = _containerBarItemView.contentSize.width - _containerBarItemView.width;
    }
    [_containerBarItemView setContentOffset:CGPointMake(localOffsetX, 0.0) animated:YES];
}

- (void)updateContainer{
    if(_currentBarItemIndex > _containerBarParam.titlesArr.count - 1){
        _currentBarItemIndex = _containerBarParam.titlesArr.count - 1;
    }
    [self updateContainerClickIndex:_currentBarItemIndex];
}

- (void)updateContainerClickIndex:(NSInteger)index{
    [self updateContainerBarItemView];
    WHC_ContainerBarItem  * tempBarItem = nil;
    for (WHC_ContainerBarItem  * item in _containerBarItemView.subviews) {
        if([item isKindOfClass:[WHC_ContainerBarItem class]]){
            if(item.index == index){
                tempBarItem = item;
            }
        }
    }
    [self whcContainerBarItem:tempBarItem clickIndex:index animated:YES];
}

#pragma mark - WHC_ContainerBarItemDelegate -
- (void)whcContainerBarItem:(WHC_ContainerBarItem*)barItem clickIndex:(NSInteger)index animated:(BOOL)animated{
    if(_delegate && [_delegate respondsToSelector:@selector(whc_ContainerBar:clickIndex: animated:)]){
        [_delegate whc_ContainerBar:self clickIndex:index animated:animated];
    }
    _currentBarItemIndex = index;
    for (WHC_ContainerBarItem * item in _containerBarItemView.subviews) {
        if([item isKindOfClass:[WHC_ContainerBarItem class]]){
            item.selected = NO;
        }
    }
    barItem.selected = YES;
    CGRect cursorViewRC = CGRectZero;
    if(_containerBarParam.visableCursor){
        cursorViewRC = _cursorView.frame;
        cursorViewRC.origin.x = barItem.maxX - _cursorView.width - _containerBarParam.cursorMargin;
    }
    NSInteger startOffsetIndex = (_containerBarItemView.width / (CGFloat)barItem.width) / 2.0;
    if(index < startOffsetIndex){
        index = startOffsetIndex;
    }else if (index == _containerBarParam.titlesArr.count - 1){
        index = _containerBarParam.titlesArr.count - startOffsetIndex;
    }
    CGFloat offsetX = (index - startOffsetIndex) * barItem.width;
    CGFloat availableOffsetX = _containerBarItemView.contentSize.width - _containerBarItemView.width;
    if(offsetX > availableOffsetX){
        offsetX = availableOffsetX;
    }else if (offsetX < 0.0){
        offsetX = 0.0;
    }
    CGFloat  animatedDuring = KWHC_AnimatedDuring;
    if(!animated){
        animatedDuring = 0.0;
    }
    [UIView animateWithDuration:animatedDuring animations:^{
        if(_containerBarParam.visableCursor){
            _cursorView.frame = cursorViewRC;
        }
        [_containerBarItemView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }completion:^(BOOL finished) {
        if(_containerBarParam.visableCursor){
            _currentCursorX = _cursorView.x;
        }
    }];
    
}

@end
