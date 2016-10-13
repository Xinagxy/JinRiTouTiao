//
//  XYConcrenModel.h
//  今日头条
//
//  Created by 尧的mac on 16/9/21.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYConcrenModel : NSObject

@property(nonatomic,strong)NSString *avatar_url;
@property(nonatomic,assign)NSInteger  concern_count;
@property(nonatomic,assign)NSString  *concern_id;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,assign)NSInteger concern_time ;

//额外
@property(nonatomic,assign)BOOL  flag;

//
//"avatar_url" = "http://p3.pstatp.com/thumb/5897/1756747038";
//"concern_count" = 73182;
//"concern_id" = 6213185675445930497;
//"concern_time" = 1473214928;
//"discuss_count" = 0;
//managing = 0;
//name = "\U7b14\U8bb0\U672c\U7535\U8111";
//"new_thread_count" = 0;
//newly = 1;
//"open_url" = "sslocal://concern?enter_from=click_concerned&gd_ext_json=%7B%22concern_id%22%3A+%226213185675445930497%22%2C+%22enter_from%22%3A+%22click_concerned%22%7D&cid=6213185675445930497";
//"sub_title" = "";

@end
