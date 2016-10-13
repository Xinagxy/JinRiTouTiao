//
//  Common.h
//  仿今日头条ScrollView
//
//  Created by 尧的mac on 16/5/25.
//  Copyright © 2016年 xxy.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define YTLog(...) NSLog(__VA_ARGS__)
#else
#define YTLog(...)
#endif


//rgb颜色
#define YTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define YTNotificationCenter [NSNotificationCenter defaultCenter]


//沙盒文件
#define UserPath  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0]
#define pathData  [UserPath stringByAppendingPathComponent:@"数据.plist"]
// 屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

// 存储用户名  密码
#define INUserDefaults [NSUserDefaults standardUserDefaults]


// 图片比例缩放
#define setImageScale(imageView,rect)  imageView.frame =rect; \
imageView.transform =CGAffineTransformScale(imageView.transform, 0.5f, 0.5f); \
imageView.x = rect.origin.x;\
imageView.y = rect.origin.y;\



//通知中心
#define XYNotificationCenter [NSNotificationCenter defaultCenter]

//弱引用
#define XYWeakSelf(type)  __weak typeof(type) weak##type = type;


//我的栏目url
#define MYURL @"http://lf.snssdk.com/article/category/get_subscribed/v1/?"

//推荐栏目URL
#define RecommenURL @"https://lf.snssdk.com/article/category/get_extra/v1/?"

//新闻内容URL
#define NewURL @"http://lf.snssdk.com/api/news/feed/v39/?"

//视频
#define VideoURL @"http://lf.snssdk.com/video_api/get_category/v1/?"

//关心
#define ConCernURL @"http://lf.snssdk.com/concern/v1/concern/list/"
//cell  ID
#define CommonCell @"XYCommonCell"
#define SingleImageCell @"XYSingleImageCell"
#define TextCell @"XYTextCell"
#define VideoCell @"XYVideoCell"

#define ConcernCell @"ConcernCell"
#define AddConcernViewCell @"AddConcernViewCell"

#define SetingViewCell @"SetingViewCell"

#define ViewCell @"MineViewCell"
#define MyVideCell @"MyVideoCell"
// 用于通知  UIKIT_EXTERN等同于 extern
UIKIT_EXTERN NSString * const YTUserRememberLoginAccount;
UIKIT_EXTERN NSString * const YTUserRememberLoginPass;










