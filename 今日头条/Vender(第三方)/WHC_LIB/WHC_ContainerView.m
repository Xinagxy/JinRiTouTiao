//
//  WHC_ContainerView.m
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
#import "WHC_ContainerView.h"
#import "WMNightManager.h"
#import "INBaseMethod.h"
#import "Common.h"
#define  KWHC_ContainerBarHeight     (40.0)                  //容器条高度
#define  KWHC_ButtonColumns          (4)                     //按钮列数
#define  KWHC_ButtonMargin           (25.0)                 //按钮边距
#define  KWHC_ButtonSpacing          (12.0)                 //按钮间距
#define  KWHC_LableMargin            (28.0)                  //标签边距
#define  KWHC_LableFontSize          (17.0)                  //标签字体大小
#define  KWHC_EditButtonWidth        (70.0)                  //编辑按钮宽度
#define  KWHC_EditButtonHeight       (30.0)                  //编辑按钮高度
#define  KWHC_ChannelButtonHeight    (30.0)                  //频道按钮高度
#define  KWHC_EditButtonTag          (100)                   //编辑按钮id
#define  KWHC_DropButtonTag          (101)                   //下拉按钮id
#define  KWHC_ShowAnimationDuring    (0.25)                  //编辑视图显示动画周期
#define  KWHC_ShowAlertMsg           (@"WHC:必须保留4项")      //保留项的限制提示

@interface WHC_ContainerView ()<UIScrollViewDelegate , WHC_ContainerBarDelegate , WHC_ContainerBarItemDelegate>{
    
    UIScrollView                       * _addScrollView;     //待添加滚动背部视图
    WHC_ContainerBar                   * _containerBar;      //顶部容器条
    WHC_ContainerBarParam              * _containerBarParam; //容器创建参数
    UIView                             * _editView;          //编辑菜单视图
    UIView                             * _addItemView;       //增加栏目视图
    UIView                             * _labView;           //标签
    UIButton                           * _dropBtn;           //下拉按钮
    UIButton                           * _editButton;        //编辑按钮
    UILabel                            * _promtLabel;        //提示文字
    UIImageView                        * _dropImageView;     //下拉图片
    NSInteger                            _currentPageIndex;  //当前页下标
    BOOL                                 _isClickSwitch;     //是否单击切换页
    BOOL                                 _isBigSwitch;       //是否进行大切换
    BOOL                                 _isAnimationMoving; //正在动画移动中
    BOOL                                 _canMoveBarItem;    //可移动项
    BOOL                                 _isTouchEnd;        //是否触摸结束
    BOOL                                 _isSelectedEditBtn; //是否選擇編輯按鈕
    BOOL                                 _isAddAnimation;    //正在执行添加动画
    BOOL                                 _isDeleteAnimation; //正在执行删除动画
    BOOL                                 _isClickDrop;       //是否点击下拉按钮
    BOOL                                 _isClickBarItem;    //是否点击进入频道按钮
    CGPoint                              _startPoint;        //长按开始点
    CGFloat                              _oldOffest;         //旧的偏移量
    NSInteger                            _moveBarItemIndex;  //可移动项的下标
    NSInteger                            _editRowCount;      //可编辑的行数
    NSInteger                            _clickItemBarIndex; //单击item下标
    WHC_ContainerBarItem               * _moveBarItem;       //可移动项
    
    NSMutableArray                     * _pointArr;          //编辑视图上Item坐标数组
    NSMutableArray                     * _addPointArr;       //增加视图上Item坐标数组
    NSMutableArray                     * _barItemArr;        //编辑视图上Item数组
    NSMutableArray                     * _addBarItemArr;     //增加视图上Item数组
}
@end
@implementation WHC_ContainerView

- (instancetype)initWithFrame:(CGRect)frame param:(WHC_ContainerBarParam*)param{
    NSParameterAssert(param);
    self = [super initWithFrame:frame];
    if(self){
        _containerBarParam = param;
        [self initUILayout];
    }
    return self;
}

- (void)setDelegate:(id<WHC_ContainerViewDelegate>)delegate{
    _delegate = delegate;
    [self addFirstContentViewToContainerView];
}

- (void)initUILayout{
    _isClickDrop = YES;
    _pointArr = [NSMutableArray new];
    _barItemArr = [NSMutableArray new];
    _addBarItemArr = [NSMutableArray new];
    _addPointArr = [NSMutableArray new];
    CGRect    containerBarRC = self.bounds;
    containerBarRC.size.height = KWHC_ContainerBarHeight;
    _containerBar = [[WHC_ContainerBar alloc]initWithFrame:containerBarRC param:_containerBarParam];
    _containerBar.delegate = self;
    [self addSubview:_containerBar];
    
    UIScrollView * containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, KWHC_ContainerBarHeight, self.width, self.height - KWHC_ContainerBarHeight)];
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.showsVerticalScrollIndicator = NO;
    containerView.delegate = self;
    containerView.pagingEnabled = YES;
    containerView.bounces = NO;
    //_editView = [self createEditView];
    
    [self addSubview:containerView];
    self.containerView = containerView;
}

- (UILabel *)createLable:(CGRect)frame txt:(NSString *)txt font:(UIFont *)font  {
    UILabel  * lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = txt;
    lab.font = font;
    return lab;
}

- (UIButton *)createButton:(CGRect)frame txt:(NSString *)txt tag:(NSInteger)tag{
    UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:txt forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
#pragma mark xxy 编辑按钮
    [btn setTitleColor:YTColor(255, 3, 3) forState:UIControlStateNormal];
    [btn setNightTColorN:YTColor(81, 50, 55)];
    [btn addTarget:self action:@selector(clickEditViewButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 15;
    btn.layer.borderWidth=1.0;
    btn.layer.borderColor = YTColor(255, 3, 3).CGColor;
    return btn;
}
- (UIView *)createEditView{
    UIView  * editView = [[UIView alloc]initWithFrame:self.bounds];
    editView.backgroundColor = YTColor(246, 246, 246);
    editView.nightBackgroundColor = YTColor(21, 21, 21);
    
    
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:editView];
    
    UILongPressGestureRecognizer     * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [editView addGestureRecognizer:longPressGesture];
    CGRect    rc = {KWHC_LableMargin, 64, 90, KWHC_ContainerBarHeight};
    UILabel *labView = [self createLable:rc txt:@"我的频道" font:[UIFont systemFontOfSize:19]];
    labView.textColor = [INBaseMethod getRGBColor:@"5c5c5c"];
    labView.nightTextColor = YTColor(77, 77, 77);
    [editView addSubview:labView];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(KWHC_LableMargin, CGRectGetMaxY(labView.frame)+1, screen_width-2*KWHC_ButtonMargin, 1.0)];
    line1.backgroundColor = YTColor(208, 208, 208);
    [editView addSubview:line1];
    
    
    
    rc = CGRectMake(CGRectGetMaxX(labView.frame), 64+11, 120, 20);
    UILabel *promt = [self createLable:rc txt:@"拖拽可以排序" font:[UIFont systemFontOfSize:12]];
    promt.textColor = [UIColor grayColor];
    promt.hidden = YES;
    [editView addSubview:promt];
    _promtLabel = promt;
    
    
    
    
    rc = CGRectMake(screen_width-KWHC_LableMargin-KWHC_EditButtonWidth, 70, KWHC_EditButtonWidth, KWHC_EditButtonHeight);
    _editButton = [self createButton:rc txt:@"编辑" tag:KWHC_EditButtonTag];
    [_editButton setTitle:@"完成"  forState:UIControlStateSelected];
    [editView addSubview:_editButton];
    
    
    
    
    _dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dropBtn.selected = YES;
    _dropBtn.frame = CGRectMake(0, 0, screen_width, KWHC_ContainerBarHeight+20);
    _dropBtn.tag = KWHC_DropButtonTag;
    _dropBtn.backgroundColor = YTColor(236, 236, 236);
    _dropBtn.nightBackgroundColor = YTColor(0, 0, 0);
    [_dropBtn addTarget:self action:@selector(clickEditViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:_dropBtn];
    _dropImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-KWHC_ButtonMargin-20, 30, 20, 20)];
    _dropImageView.image = [UIImage imageNamed:@"add_channels_close_20x20_"];
#pragma mark 夜间模式图片
//    _dropImageView.nightImage = [UIImage imageNamed:@"close_night"];
    
    [_dropBtn addSubview:_dropImageView];
    
    
    
    _editRowCount = [self calcRowCount];
    //    CGFloat        addItemViewY = (_editRowCount + 1) * KWHC_ContainerBarHeight + (KWHC_ContainerBarHeight - KWHC_EditButtonHeight) / 2.0+64;
    CGFloat addItemViewY = 64 + 40 + _editRowCount *KWHC_ButtonSpacing + _editRowCount * KWHC_ChannelButtonHeight + 25;
    
    CGRect         addItemViewRC = {0.0, addItemViewY, self.width, self.height - addItemViewY};
    _addItemView = [[UIView alloc]initWithFrame:addItemViewRC];
    _addItemView.backgroundColor = editView.backgroundColor;
    _addItemView.nightBackgroundColor = YTColor(21, 21, 21);
    [editView addSubview:_addItemView];
    
    
    
    CGRect labViewRC = {KWHC_LableMargin, 0.0, self.width, KWHC_ContainerBarHeight};
    
    UILabel  * lab = [self createLable:labViewRC txt:@"添加更多栏目" font:[UIFont systemFontOfSize:19] ];
    lab.textColor = labView.textColor;
    lab.nightTextColor = YTColor(77, 77, 77);
    [_addItemView addSubview:lab];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(KWHC_LableMargin, CGRectGetMaxY(lab.frame)+1, self.width-2*KWHC_ButtonMargin, 1.0)];
    line2.backgroundColor = YTColor(208, 208, 208);
    [_addItemView addSubview:line2];
    
    
    CGRect    addScrollViewRC = {0.0, KWHC_ContainerBarHeight, self.width, _addItemView.height - KWHC_ContainerBarHeight};
    _addScrollView = [[UIScrollView alloc]initWithFrame:addScrollViewRC];
    _addScrollView.showsHorizontalScrollIndicator = NO;
    _addScrollView.showsVerticalScrollIndicator = YES;
    _addScrollView.contentSize = _addScrollView.size;
    [_addItemView addSubview:_addScrollView];
    return editView;
}
- (NSInteger)calcRowCount{
    NSInteger  count = _containerBarParam.titlesArr.count;
    NSInteger  rowCount = count / KWHC_ButtonColumns + ((count % KWHC_ButtonColumns) != 0 ? 1 : 0);
    return rowCount;
}
- (void)clearMemoryArr:(NSArray *)array{
    if(array){
        for (NSInteger i = 0; i < array.count; i++) {
            NSObject * object = array[i];
            if([object isKindOfClass:[UIView class]]){
                [((UIView *)object) removeFromSuperview];
            }
            object = nil;
        }
    }
}

- (void)addFirstContentViewToContainerView
{
    if(_delegate && [_delegate respondsToSelector:@selector(whc_ContainerView:updateContainerViewLayoutWithTitlesArr:)]){
        _containerBarParam.viewArr = [[_delegate whc_ContainerView:self updateContainerViewLayoutWithTitlesArr:_containerBarParam.titlesArr] mutableCopy];
    }
    if (_containerBarParam.viewArr) {
        UIViewController *vc = [_containerBarParam.viewArr firstObject];
        vc.view.xy = CGPointMake(0.0, 0.0);
        vc.view.size = CGSizeMake(self.width, _containerView.height);
        [_containerView addSubview:vc.view];
        [_delegate whc_ContainerView:self loadContentForCurrentView:vc currentIndex:0];
        _containerView.contentSize = CGSizeMake(_containerBarParam.viewArr.count * self.width, 0.0);
    }
}
- (void)addContentViewToContainerView:(ItemChangeState)state{
    if(_delegate && [_delegate respondsToSelector:@selector(whc_ContainerView:updateContainerViewLayoutWithTitlesArr:)]){
        if(_containerBarParam.viewArr){
            for(NSInteger i = 0; i < _containerBarParam.viewArr.count; i++){
                UIViewController * contentView = _containerBarParam.viewArr[i];
                if([_containerView.subviews containsObject:contentView.view]){
                    [contentView.view removeFromSuperview];
                }
                contentView = nil;
            }
            [_containerBarParam.viewArr removeAllObjects];
        }
    }
    _containerBarParam.viewArr = [[_delegate whc_ContainerView:self updateContainerViewLayoutWithTitlesArr:_containerBarParam.titlesArr] mutableCopy];
    
    if(_containerBarParam.viewArr){
        NSInteger  viewCount = _containerBarParam.viewArr.count;
        for (NSInteger i = 0; i < viewCount; i++) {
            UIViewController * contentView = _containerBarParam.viewArr[i];
            contentView.view.tag = i + 1;
            //            contentView.view.xy = CGPointMake(i * self.width, 0.0);
            //            contentView.view.size = CGSizeMake(self.width, _containerView.height);
            //            [_containerView addSubview:contentView.view];
        }
        _containerView.contentSize = CGSizeMake(viewCount * self.width, 0.0);
        if(_currentPageIndex > _containerBarParam.viewArr.count - 1){
            _currentPageIndex = _containerBarParam.viewArr.count - 1;
        }
        //[_containerView setContentOffset:CGPointMake(_currentPageIndex * self.width, 0.0) animated:NO];
    }
    if (state == ItemOrderChange || state == ItemRemove || state == ItemAdd) {
        [_containerBar updateContainerClickIndex:_currentPageIndex];
    }else if(state == ItemTap){
        [_containerBar updateContainerClickIndex:_clickItemBarIndex];
    }
    //if(_isClickDrop){
    // [_containerBar updateContainer];
    //}else{
    
    //}
    //_isClickDrop = YES;
}
//初始化定制视图内的按钮
- (CGFloat)layoutBarItemToView:(UIView *)view titleArr:(NSArray *)titleArr barItemArr:(NSMutableArray *)barItemArr pointArr:(NSMutableArray *)pointArr yConst:(CGFloat)yConst style:(WHCBarItemStyle)style{
    CGFloat   btnWidth = (self.width-2*KWHC_ButtonMargin - (KWHC_ButtonColumns - 1) * KWHC_ButtonSpacing) / (CGFloat)KWHC_ButtonColumns;
    NSInteger count = titleArr.count;
    NSInteger rowCount = count / KWHC_ButtonColumns + ((count % KWHC_ButtonColumns) != 0 ? 1 : 0);
    CGFloat margin = 0;
    CGFloat spacing = 0;
    if (view == _editView) {
        margin = 64;
        spacing = 40;
    }
    for (NSInteger i = 0; i < rowCount; i++) {
        for (NSInteger j = 0; j < KWHC_ButtonColumns; j++) {
            CGRect  itemBtnRC = {KWHC_ButtonMargin+KWHC_ButtonSpacing*j+ btnWidth * j, KWHC_ButtonSpacing * (i + 1) + spacing+margin+KWHC_EditButtonHeight*i, btnWidth , KWHC_EditButtonHeight};
            NSInteger  index = i * KWHC_ButtonColumns + j;
            if(index < count){
                WHC_ContainerBarItem  * itemBtn = [[WHC_ContainerBarItem alloc]initWithFrame:itemBtnRC Style:style];
                itemBtn.delegate = self;
                itemBtn.title = titleArr[index];
                itemBtn.normalTitleColor = [UIColor blackColor];
                itemBtn.normalNightTitleColor = YTColor(92, 92, 92);
                itemBtn.normalNightBackgroundColor = YTColor(28, 28, 28);
                itemBtn.normalFontSize = _containerBarParam.fontSize;
                itemBtn.index = index;
                itemBtn.tag = index + 1;
                [view addSubview:itemBtn];
                [barItemArr addObject:itemBtn];
                [pointArr addObject:@[@(itemBtn.center.x),@(itemBtn.center.y)]];
                
                
#pragma mark xxy 默认选择第一个按钮
                if (index == 0 && view == _editView) {
                    itemBtn.normalTitleColor = YTColor(255, 0, 0);
                    itemBtn.normalNightTitleColor = YTColor(97, 50, 56);
                }
            }
        }
    }
    return [[pointArr lastObject][1] floatValue] + KWHC_EditButtonHeight;
}
//记录当前用户的选择
+ (void)saveContainerBarTitlesArr:(NSArray *)titlesArr laterTitlesArr:(NSArray *)laterTitlesArr{
    [WHC_ContainerBar saveContainerBarTitlesArr:titlesArr laterTitlesArr:laterTitlesArr];
}

//+ (NSArray *)readContainerBarTitlesArr{
//    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:KWHC_ContainerConfigurationKey];
//    NSArray      * titlesArr = nil;
//    if(dict && dict.count > 0){
//        titlesArr = dict[KWHC_ContainerTitlesArrKey];
//    }
//    return titlesArr;
//}
//
//+ (NSArray *)readContainerBarLaterTitlesArr{
//    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:KWHC_ContainerConfigurationKey];
//    NSArray      * laterTitlesArr = nil;
//    if(dict && dict.count > 0){
//        laterTitlesArr = dict[KWHC_ContainerLaterTitlesArrKey];
//    }
//    return laterTitlesArr;
//}
- (void)clickEditViewButton:(UIButton*)sender{
    sender.selected = !sender.selected;
    NSInteger  tag = sender.tag;
    if(tag == KWHC_DropButtonTag){
        //if(!sender.selected){
        if(_isSelectedEditBtn){
            [self clickEditViewButton:_editButton];
        }
        [WHC_ContainerView saveContainerBarTitlesArr:_containerBarParam.titlesArr laterTitlesArr:_containerBarParam.laterTitlesArr];
        
        _editView.alpha = 1.0;
        [UIView animateWithDuration:KWHC_ShowAnimationDuring delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _editView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_editView removeFromSuperview];
            
        }];
        //}
    }else if (tag == KWHC_EditButtonTag){
        _isSelectedEditBtn = sender.selected;
        if(_isSelectedEditBtn){
            for (WHC_ContainerBarItem * itemBar in _editView.subviews) {
                if([itemBar isKindOfClass:[WHC_ContainerBarItem class]]){
                    _promtLabel.hidden = NO;
                    [itemBar startEdit:1];
                }
            }
        }else{
            for (WHC_ContainerBarItem * itemBar in _editView.subviews) {
                if([itemBar isKindOfClass:[WHC_ContainerBarItem class]]){
                    _promtLabel.hidden = YES;
                    [itemBar stopEdit];
                }
            }
        }
    }
}
- (NSInteger)longPressBarItemIndex:(CGPoint)point{
    int index = -1;
    for (WHC_ContainerBarItem * barItem in _editView.subviews) {
        if([barItem isKindOfClass:[WHC_ContainerBarItem class]] &&
           CGRectContainsPoint(barItem.frame, point)){
            index = (int)barItem.index;
            break;
        }
    }
    return index;
}
//频道名重新排序
- (void)saveTitlesArrWithBarItemArr:(NSArray *)barItemArr{
    [_containerBarParam.titlesArr removeAllObjects];
    for (WHC_ContainerBarItem * barItem in barItemArr) {
        [_containerBarParam.titlesArr addObject:barItem.title];
    }
}
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture{
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _isTouchEnd = NO;
            _canMoveBarItem = NO;
            CGPoint longPressPoint = [longPressGesture locationInView:longPressGesture.view];
            _moveBarItemIndex = [self longPressBarItemIndex:longPressPoint];
            if(_moveBarItemIndex > 0){
                _canMoveBarItem = YES;
                [self clickEditViewButton:_editButton];
                _moveBarItem = ((WHC_ContainerBarItem*)_barItemArr[_moveBarItemIndex]);
                _startPoint = _moveBarItem.center;
                [_editView bringSubviewToFront:_moveBarItem];
            }
            _addItemView.hidden = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if(_canMoveBarItem){
                CGPoint  currentPoint = [longPressGesture locationInView:longPressGesture.view];
                _moveBarItem.center = currentPoint;
                if(_isAnimationMoving) return;
                NSInteger  currentBarItemIndex = [self longPressBarItemIndex:currentPoint];
                if(currentBarItemIndex > 0){
                    _isAnimationMoving = YES;
                    [UIView animateWithDuration:KWHC_ShowAnimationDuring delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         if(currentBarItemIndex > _moveBarItemIndex){
                                             for (NSInteger i = currentBarItemIndex; i > _moveBarItemIndex; i--) {
                                                 WHC_ContainerBarItem  * barItem = ((WHC_ContainerBarItem*)_barItemArr[i]);
                                                 CGPoint  frontBarItemCenter = CGPointZero;
                                                 NSArray * point = _pointArr[i - 1];
                                                 frontBarItemCenter = CGPointMake([point[0] floatValue], [point[1] floatValue]);
                                                 if(i == _moveBarItemIndex + 1){
                                                     NSArray  * startPoint = _pointArr[_moveBarItemIndex];
                                                     frontBarItemCenter = CGPointMake([startPoint[0] floatValue], [startPoint[1] floatValue]);
                                                 }
                                                 barItem.center = frontBarItemCenter;
                                             }
                                         }else if (currentBarItemIndex < _moveBarItemIndex){
                                             if (currentBarItemIndex == 0) return;
                                             for (NSInteger i = currentBarItemIndex; i < _moveBarItemIndex; i++) {
                                                 WHC_ContainerBarItem  * barItem = ((WHC_ContainerBarItem*)_barItemArr[i]);
                                                 CGPoint  nextBarItemCenter = CGPointZero;
                                                 NSArray * point = _pointArr[i + 1];
                                                 nextBarItemCenter = CGPointMake([point[0] floatValue], [point[1] floatValue]);
                                                 if(i == _moveBarItemIndex - 1){
                                                     NSArray  * startPoint = _pointArr[_moveBarItemIndex];
                                                     nextBarItemCenter = CGPointMake([startPoint[0] floatValue], [startPoint[1] floatValue]);
                                                 }
                                                 barItem.center = nextBarItemCenter;
                                             }
                                         }
                                     } completion:^(BOOL finished) {
                                         if (currentBarItemIndex == 0)return;
                                         [_barItemArr exchangeObjectAtIndex:_moveBarItemIndex withObjectAtIndex:currentBarItemIndex];
                                         if (_currentPageIndex == _moveBarItemIndex) {
                                             _currentPageIndex  = currentBarItemIndex;
                                         }else if(_currentPageIndex == currentBarItemIndex){
                                             _currentPageIndex  = _moveBarItemIndex;
                                         }
                                         
                                         if(currentBarItemIndex > _moveBarItemIndex){
                                             for (NSInteger i = _moveBarItemIndex; i < currentBarItemIndex - 1; i++) {
                                                 [_barItemArr exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                                             }
                                         }else if (currentBarItemIndex < _moveBarItemIndex){
                                             for (NSInteger i = _moveBarItemIndex; i > currentBarItemIndex + 1; i--) {
                                                 
                                                 [_barItemArr exchangeObjectAtIndex:i withObjectAtIndex:(i - 1 < 0 ? 0 : i - 1)];
                                                 
                                             }
                                         }
                                         for (NSInteger i = 0; i < _barItemArr.count; i++) {
                                             
                                             WHC_ContainerBarItem  * barItem = ((WHC_ContainerBarItem*)_barItemArr[i]);
                                             barItem.index = i;
                                         }
                                         NSArray  * currentPoint = _pointArr[currentBarItemIndex];
                                         
                                         _startPoint = CGPointMake([currentPoint[0] floatValue], [currentPoint[1] floatValue]);
                                         if(_isTouchEnd && (_startPoint.x != _moveBarItem.center.x ||
                                                            _startPoint.y != _moveBarItem.center.y)){
                                             _moveBarItem.center = _startPoint;
                                             [self saveTitlesArrWithBarItemArr:_barItemArr];
                                         }
                                         _moveBarItemIndex = currentBarItemIndex;
                                         
                                         _isAnimationMoving = NO;
                                     }];
                    
                }
                
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            _moveBarItem.center = _startPoint;
            _addItemView.hidden = NO;
            _isTouchEnd = YES;
            [self saveTitlesArrWithBarItemArr:_barItemArr];//频道名重新排序
            [self addContentViewToContainerView:ItemOrderChange];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isClickSwitch = NO;
    _oldOffest = scrollView.contentOffset.x;
    _currentPageIndex = floor((scrollView.contentOffset.x - scrollView.width / 2.0) / scrollView.width) + 1;
    CGPoint  ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
    #pragma mark xxy
    if (_oldOffest == 0) {
        return;
    }else{
    [_containerBar beginDynamicChangeStateOffsetX:scrollView.contentOffset.x pageIndex:_currentPageIndex oriX:ori.x];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_isClickBarItem) {
        if(!_isClickSwitch){
            CGPoint ori = [scrollView.panGestureRecognizer velocityInView:scrollView];
            NSLog(@"ori-------%f",ori.x);
            [_containerBar dynamicChangeStateOffsetX:scrollView.contentOffset.x oriX:ori.x];
        }
        if ([[scrollView class] isSubclassOfClass:[UITableView class]])return;
        
        NSInteger currentPageIndex = scrollView.contentOffset.x > _oldOffest ? floor((scrollView.contentOffset.x-1) / scrollView.width)+1 :floor((scrollView.contentOffset.x) / scrollView.width) ;
        
        if ( currentPageIndex == scrollView.contentSize.width/scrollView.width) return;
        if( currentPageIndex != _currentPageIndex){
            if(_delegate && [_delegate respondsToSelector:@selector(whc_ContainerView:loadContentForCurrentView:currentIndex:)]){
                UIViewController  * contentView = _containerBarParam.viewArr[ currentPageIndex];
                contentView.view.frame = CGRectMake(( currentPageIndex)*self.width, 0, self.width, self.height);
                [_containerView addSubview:contentView.view];
                [_delegate whc_ContainerView:self loadContentForCurrentView:contentView currentIndex: currentPageIndex];
            }
        }
    }
    _isClickBarItem = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([[scrollView class] isSubclassOfClass:[UITableView class]])return;
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x) / scrollView.width) ;
    _currentPageIndex = currentPageIndex;
#pragma mark xxy
    if (currentPageIndex == 0) {
        return;
    }else{
    [_containerBar endDynamicChangeStateOffsetX:scrollView.contentOffset.x currentPageIndex:currentPageIndex];
    }
}

#pragma mark - WHC_ContainerBarDelegate -
- (void)whc_ContainerBar:(WHC_ContainerBar *)whcContainerBar clickIndex:(NSInteger)index animated:(BOOL)animated{
    
    _isClickSwitch = YES;
    _isBigSwitch = YES;
    
    [_containerView setContentOffset:CGPointMake(index * whcContainerBar.width, 0.0) animated:NO];
    UIViewController *vc = _containerBarParam.viewArr[index];
    vc.view.frame = CGRectMake(index * whcContainerBar.width, 0, screen_width, screen_width);
    [_delegate whc_ContainerView:self loadContentForCurrentView:vc currentIndex:index];
    _currentPageIndex = index;
    [_containerView addSubview:vc.view];
    
}



- (void)whc_ContainerBar:(WHC_ContainerBar *)whcContainerBar clickDrop:(UIButton*)sender{
    
    [self clearMemoryArr:_addBarItemArr];
    [self clearMemoryArr:_addPointArr];
    [self clearMemoryArr:_barItemArr];
    [self clearMemoryArr:_pointArr];
    [_addBarItemArr removeAllObjects];
    [_addPointArr removeAllObjects];
    [_barItemArr removeAllObjects];
    [_pointArr removeAllObjects];
    
    _editView = [self createEditView];
    [self layoutBarItemToView:_editView titleArr:_containerBarParam.titlesArr barItemArr:_barItemArr pointArr:_pointArr yConst:(KWHC_ContainerBarHeight - KWHC_EditButtonHeight) / 2.0 style:EDIT_SHOW];
    CGFloat sumHeight = [self layoutBarItemToView:_addScrollView titleArr:_containerBarParam.laterTitlesArr barItemArr:_addBarItemArr pointArr:_addPointArr yConst:-KWHC_EditButtonHeight style:ADD_SHOW];
    if(sumHeight > _addScrollView.contentSize.height){
        _addScrollView.contentSize = CGSizeMake(_addScrollView.width, sumHeight);
    }
    [UIView animateWithDuration:KWHC_ShowAnimationDuring delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _editView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - WHC_ContainerBarItemDelegate -
- (void)whcContainerBarItem:(WHC_ContainerBarItem*)barItem clickIndex:(NSInteger)index animated:(BOOL)animated{
    if(_isAddAnimation){
        return;
    }
    if([_barItemArr containsObject:barItem]){
        _isClickDrop = NO;
        _clickItemBarIndex = index;
//        _isClickBarItem = YES;
        //[_containerBar updateContainerClickIndex:_clickItemBarIndex];
        [self addContentViewToContainerView:ItemTap];
        [self clickEditViewButton:_dropBtn];
    }else{
        _isAddAnimation = YES;
        [barItem removeFromSuperview];
        barItem.center = CGPointMake(barItem.center.x, barItem.center.y + _addItemView.y + KWHC_ContainerBarHeight + (KWHC_ContainerBarHeight - KWHC_EditButtonHeight) - _addScrollView.contentOffset.y);
        [_editView addSubview:barItem];
        BOOL       isAddRow = NO;
        BOOL       isDecRow = ((_addBarItemArr.count % KWHC_ButtonColumns) == 1 ? YES : NO);
        NSInteger  count = _barItemArr.count;
        _editRowCount = [self calcRowCount];
        CGPoint  centerPoint = CGPointZero;
        if(count < _editRowCount * KWHC_ButtonColumns){
            NSArray  * lastPoint = [_pointArr lastObject];
            centerPoint = CGPointMake([lastPoint[0] floatValue] + barItem.width + KWHC_ButtonSpacing , [lastPoint[1] floatValue]);
        }else{
            isAddRow = YES;
            if(count > 0){
                NSArray  * lastPoint = _pointArr[count - KWHC_ButtonColumns];
                centerPoint = CGPointMake([lastPoint[0] floatValue] , [lastPoint[1] floatValue]  + barItem.height + KWHC_ButtonMargin / 2.0);
            }else{
                centerPoint = CGPointMake(KWHC_ButtonMargin + barItem.width / 2.0, KWHC_ContainerBarHeight + KWHC_ButtonMargin / 4.0 + barItem.height / 2.0);
            }
        }
        [UIView animateWithDuration:KWHC_ShowAnimationDuring animations:^{
            
            barItem.center = centerPoint;
            
        }completion:^(BOOL finished) {
            [barItem setItemStyle:EDIT_SHOW];
            if(_isSelectedEditBtn){
                [barItem startEdit:2];
            }
            barItem.index = _barItemArr.count;
            [_barItemArr addObject:barItem];
            [_pointArr addObject:@[@(barItem.center.x),@(barItem.center.y)]];
            CGFloat  incrementHeight = barItem.height + KWHC_ButtonMargin / 2.0;
            
            [UIView animateWithDuration:KWHC_ShowAnimationDuring animations:^{
                if(isAddRow){
                    _addItemView.center = CGPointMake(_addItemView.center.x, _addItemView.center.y + incrementHeight);
                    _addItemView.height -= incrementHeight;
                    _addScrollView.height -= incrementHeight;
                }
                for(NSInteger i = index; i < _addBarItemArr.count - 1; i++){
                    WHC_ContainerBarItem  * barItem = _addBarItemArr[i + 1];
                    NSArray    *   pointArr = _addPointArr[i];
                    if(isAddRow){
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }else{
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }
                }
                if(isAddRow){
                    for (NSInteger i = 0; i < index; i++) {
                        WHC_ContainerBarItem  * barItem = _addBarItemArr[i];
                        NSArray    *   pointArr = _addPointArr[i];
                        barItem.center = CGPointMake([pointArr[0] floatValue], [pointArr[1] floatValue]);
                    }
                }
            }completion:^(BOOL finished) {
                if(isDecRow){
                    _addScrollView.contentSize = CGSizeMake(_addScrollView.width, _addScrollView.contentSize.height - incrementHeight);
                }
                [_containerBarParam.titlesArr addObject:[NSString stringWithString:barItem.title]];
                [_containerBarParam.laterTitlesArr removeObjectAtIndex:index];
                [_addBarItemArr removeObjectAtIndex:index];
                [_addPointArr removeAllObjects];
                for (NSInteger i = 0; i < _addBarItemArr.count; i++) {
                    WHC_ContainerBarItem  * barItem = _addBarItemArr[i];
                    barItem.index = i;
                    [_addPointArr addObject:@[@(barItem.center.x),@(barItem.center.y)]];
                }
                _isAddAnimation = NO;
                [self addContentViewToContainerView:ItemAdd];
            }];
        }];
    }
}

- (void)whcContainerBarItem:(WHC_ContainerBarItem *)barItem clickDeleteBtn:(UIButton*)sender index:(NSInteger)index{
    
    if(_isDeleteAnimation){
        return;
    }
    [barItem stopEdit];
    _isDeleteAnimation = YES;
    [_editView bringSubviewToFront:barItem];
    BOOL       isDecRow = ((_barItemArr.count % KWHC_ButtonColumns != 1) ? NO : YES);
    BOOL       isAddRow = ((_addBarItemArr.count % KWHC_ButtonColumns == 0) ? YES : NO);
    if(_addBarItemArr.count == 0){
        isAddRow = NO;
    }
    CGPoint    barItemCenter = CGPointMake(KWHC_ButtonMargin + barItem.width / 2.0, _addItemView.y + KWHC_ContainerBarHeight  + KWHC_ButtonSpacing);
    NSInteger  count = _addBarItemArr.count;
    NSInteger  remainder = count % KWHC_ButtonColumns;
    NSArray  * lastPoint = [_addPointArr lastObject];
    
    if(remainder != 0){
        [_addPointArr addObject:@[@([lastPoint[0] floatValue] + barItem.width + KWHC_ButtonSpacing), lastPoint[1]]];
    }else{
        if(count == 0){
            [_addPointArr addObject:@[@(KWHC_ButtonMargin + barItem.width / 2.0), @((barItem.height + 30) / 2.0)]];
        }else{
            [_addPointArr addObject:@[@(KWHC_ButtonMargin + barItem.width / 2.0), @([lastPoint[1] floatValue] + barItem.height + KWHC_ButtonSpacing)]];
        }
    }
    CGFloat  incrementHeight = barItem.height + KWHC_ButtonSpacing;
    [UIView animateWithDuration:KWHC_ShowAnimationDuring animations:^{
        if(isDecRow){
            _addItemView.center = CGPointMake(_addItemView.center.x, _addItemView.center.y - incrementHeight);
            _addItemView.height += incrementHeight;
            _addScrollView.height += incrementHeight;
            barItem.center = CGPointMake(barItemCenter.x, barItemCenter.y - incrementHeight);
        }else{
            barItem.center = barItemCenter;
        }
        for (NSInteger i = count - 1; i >= 0; i--) {
            WHC_ContainerBarItem  * tempBarItem = _addBarItemArr[i];
            NSArray  * tempBarItemPoint = _addPointArr[i + 1];
            tempBarItem.center = CGPointMake([tempBarItemPoint[0] floatValue], [tempBarItemPoint[1] floatValue]);
        }
        for (NSInteger i = index + 1; i < _barItemArr.count; i++) {
            WHC_ContainerBarItem  * tempBarItem = _barItemArr[i];
            NSArray  * tempBarItemPoint = _pointArr[i - 1];
            tempBarItem.center = CGPointMake([tempBarItemPoint[0] floatValue], [tempBarItemPoint[1] floatValue]);
        }
        
    }completion:^(BOOL finished) {
        if(isAddRow){
            _addScrollView.contentSize = CGSizeMake(_addScrollView.width, _addScrollView.contentSize.height + incrementHeight);
        }
        [barItem setItemStyle:ADD_SHOW];
        [barItem removeFromSuperview];
        [_pointArr removeAllObjects];
        [_barItemArr removeObjectAtIndex:index];
        [_containerBarParam.titlesArr removeObjectAtIndex:index];
        [_containerBarParam.laterTitlesArr insertObject:barItem.title atIndex:0];
        for (NSInteger i = 0; i < _barItemArr.count; i++) {
            WHC_ContainerBarItem  * tempBarItem = _barItemArr[i];
            tempBarItem.index = i;
            [_pointArr addObject:@[@(tempBarItem.center.x),@(tempBarItem.center.y)]];
        }
        barItem.center = CGPointMake(barItem.center.x, KWHC_ContainerBarHeight - KWHC_EditButtonHeight  + KWHC_ButtonSpacing+5);
        [_addScrollView addSubview:barItem];
        [_addBarItemArr insertObject:barItem atIndex:0];
        for (NSInteger i = 0; i < _addBarItemArr.count; i++) {
            WHC_ContainerBarItem  * tempBarItem = _addBarItemArr[i];
            tempBarItem.index = i;
        }
        _isDeleteAnimation = NO;
        if (index == _currentPageIndex) {
            _currentPageIndex = 0;
        }
        [self addContentViewToContainerView:ItemRemove];
    }];
}

- (void)removeFromView
{
    [self removeFromSuperview];
}



@end
