//
//  XYNewCellModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMediaImageModel.h"
#import "XYMediaModel.h"
#import "XYVideodeailsMode.h"
@interface XYNewCellModel : NSObject
/**
 *  评论数
 */
@property(nonatomic,assign)NSInteger  comment_count;
/**
 链接 视频、图片、文章
 */
@property(nonatomic,strong)NSString *display_url;
/**
 文章标题
 */
@property(nonatomic,strong)NSString *title;


/**
 视频来源 source_avatar
 */
@property(nonatomic,strong)NSString *media_name;

/**
 发布时间behot_time
 */
@property(nonatomic,assign)NSInteger publish_time;



/**
 来源 source_avatar
 */
@property(nonatomic,strong)NSString *source;
/**
 来源 图片
 */
@property(nonatomic,strong)NSString *source_avatar;

/**
 图片个数  判断个数展示cell
 */
@property(nonatomic,assign)NSInteger  gallary_image_count;

/**
 *  图片数组 数组中装着XYImageURLModel模型
 */
@property(nonatomic,strong)NSArray *image_list;



/**
 *  视频信息 模型中装着字典数据
 */
@property(nonatomic,strong)XYMediaModel *media_info;



/**
 *  视频图片  模型中装着字典数据
 */
@property(nonatomic,strong)XYMediaImageModel *middle_image;

/**
 * 视频信息
 */
@property(nonatomic,strong)XYVideodeailsMode *video_detail_info;

/**
 * 视频时长
 */
@property(nonatomic,assign)NSInteger video_duration;
//判断是视频还是图片
@property(nonatomic,assign)BOOL  has_image;
@property(nonatomic,assign)BOOL  has_m3u8_video;
@property(nonatomic,assign)BOOL  has_mp4_video;
@property(nonatomic,assign)BOOL  has_video;

@property(nonatomic,strong)NSString *keywords;

//额外数据 cell高
@property(nonatomic,assign)NSInteger  cellHeight;


/**
"aggr_type" = 1;
"article_sub_type" = 0;
"article_type" = 0;
"article_url" = "http://www.fawan.com/Article/fwkx/2016/09/07/366519.html";
"ban_comment" = 0;
"behot_time" = 1473225352;
"bury_count" = 0;
"cell_flag" = 299;
"cell_layout_style" = 1;
city = "\U5317\U4eac";
"comment_count" = 0;
cursor = 1473225352000;
"digg_count" = 0;
"display_title" = " ";
"display_url" = "http://toutiao.com/group/6327432922421494018/";
"gallary_image_count" = 0;
"group_id" = 6327432922421494018;
"has_image" = 0;
"has_m3u8_video" = 0;
 "has_mp4_video" = 0;
 "has_video" = 0;
 hot = 0;
 "ignore_web_transform" = 1;
 "image_list" =     (
 );
 "is_subscribe" = 0;
 "item_id" = 6327438365469704706;
 keywords = "\U4e94\U8def\U5c45\U7ad9,\U540e\U5382\U6751,\U5de5\U7a0b,\U5206\U949f\U5bfa\U6865,\U4e2d\U5173\U6751";
 level = 0;
 "like_count" = 0;
 "media_info" =     {
 "avatar_url" = "http://p9.pstatp.com/large/6cb000e855215f269b4";
 "media_id" = 6681273088;
 name = "\U6cd5\U5236\U665a\U62a5";
 "user_verified" = 0;
 };
 "media_name" = "\U6cd5\U5236\U665a\U62a5";
 "natant_level" = 0;
 "preload_web" = 2;
 "publish_time" = 1473219935;
 "reback_flag" = 0;
 "repin_count" = 1;
 "share_url" = "http://toutiao.com/group/6327432922421494018/?iid=5034850950&app=news_article";
 source = "\U6cd5\U5236\U665a\U62a5";
 "source_icon_style" = 4;
 "source_open_url" = "sslocal://media_account?media_id=6681273088";
 tag = "news_society";
 "tag_id" = 6327432922421494018;
 tip = 0;
 title = "\U5317\U90ca\U519c\U573a\U6865\U660e\U5e74\U6709\U671b\U52a8\U5de5\U6539\U9020\U758f\U5835";
 url = "http://www.fawan.com/Article/fwkx/2016/09/07/366519.html";
 "user_like" = 0;
*/




@end
