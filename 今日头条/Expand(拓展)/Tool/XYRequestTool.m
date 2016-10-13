//
//  XYRequestTool.m
//  今日头条
//
//  Created by 尧的mac on 16/9/7.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYRequestTool.h"
#import <AFNetworking.h>
@implementation XYRequestTool


+(void)getDataURL:(NSString *)url params:(id)params progress:(void (^)(NSProgress *downloadProgress))progress  success:(void(^)(id response))success failue:(void(^)(NSError *error))failue{
     NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict = params;
    AFHTTPSessionManager * manager  = [AFHTTPSessionManager manager];
    // 设置接收类型的type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript",@"text/html", nil];
   //  设置超时时间
    manager.requestSerializer.timeoutInterval = 12.f;
    [manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
     
        //下载进度回调
        progress(downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 转化为NSDictionary
//        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         //成功回调
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败的回调
        failue(error);
    }];
    
    
    

    
}


+(void)postDataURL:(NSString *)url params:(NSDictionary *)params  progress:(void (^)(NSProgress *downloadProgress))progress success:(void(^)(NSDictionary *response))success failue:(void(^)(NSError *error))failue{
    
    
    
    AFHTTPSessionManager * manager  = [AFHTTPSessionManager manager];
    
    // 设置接收类型的type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //  设置超时时间
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //下载进度回调
        progress(uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 转化为NSDictionary
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //成功回调
        success(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //失败的回调
        failue(error);
    }];
}

@end
