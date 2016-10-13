//
//  AppDelegate.m
//  今日头条
//
//  Created by 尧的mac on 16/9/5.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "AppDelegate.h"
#import "XYTabController.h"
#import "AdvertiseView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    
    //去向
    self.window.rootViewController = [[XYTabController alloc] init];
    [self.window makeKeyAndVisible];


    AdvertiseView * adver = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
    //这里应该是请求获取的路径
    adver.filePath = @"http://imgsrc.baidu.com/forum/w%3D580/sign=5d67856da6cc7cd9fa2d34d109002104/bca6169b033b5bb53822be7e33d3d539b400bcc8.jpg";
    [adver show];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
