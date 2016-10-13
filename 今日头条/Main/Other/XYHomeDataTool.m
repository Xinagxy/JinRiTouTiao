//
//  XYHomeDataTool.m
//  今日头条
//
//  Created by 尧的mac on 16/9/14.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XYHomeDataTool.h"
#import <MJExtension.h>
#import "XYRequestTool.h"
#import "XYMyModel.h"
@implementation XYHomeDataTool

+(void)XYHomeParam:(XYhomeToolModel*)Params HomeURL:(NSString *)url  progress:(void (^)(NSProgress *downloadProgress))progress  success:(void(^)(id response))success failue:(void(^)(NSError *error))failue{
    
//    Params.mj_keyValues  模型转字典
    [XYRequestTool getDataURL:url params:Params.mj_keyValues progress:^(NSProgress *downloadProgress) {
        
         NSLog(@"param = %@",Params.mj_keyValues);
         progress(downloadProgress);
    } success:^(NSDictionary *response) {
        
        NSMutableArray * arr = [XYMyModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        success(arr);
        
    } failue:^(NSError *error) {
        failue(error);
    }];

    
    
}
@end
