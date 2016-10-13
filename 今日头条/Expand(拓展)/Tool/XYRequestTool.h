//
//  XYRequestTool.h
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRequestTool : NSObject
/**
 *  get请求
 *
 *  @param url     请求路径
 *  @param params  参数
 *  @param progress  下载进度
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)getDataURL:(NSString *)url params:(id)params progress:(void (^)(NSProgress *downloadProgress))progress  success:(void(^)(id response))success failue:(void(^)(NSError *error))failue;

/**
 *  post请求
 *
 *  @param url     请求路径
 *  @param params  参数
 *  @param progress  下载进度
 *  @param success 成功回调
 *  @param error   失败回调
 */
+(void)postDataURL:(NSString *)url params:(NSDictionary *)params  progress:(void (^)(NSProgress *downloadProgress))progress success:(void(^)(NSDictionary *response))success failue:(void(^)(NSError *error))failue;
@end
