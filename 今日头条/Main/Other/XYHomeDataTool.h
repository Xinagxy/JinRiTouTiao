//
//  XYHomeDataTool.h
//  今日头条
//
//  Created by 尧的mac on 16/9/14.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYhomeToolModel.h"
@interface XYHomeDataTool : NSObject

+(void)XYHomeParam:(XYhomeToolModel*)Params HomeURL:(NSString *)url  progress:(void (^)(NSProgress *downloadProgress))progress  success:(void(^)(id response))success failue:(void(^)(NSError *error))failue;
@end
