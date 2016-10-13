//
//  XYTabContentController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYTabContentController.h"
#import "XYRequestTool.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "Common.h"
#import "XYMyModel.h"
#import "XYNewModel.h"
#import "XYContentModel.h"
#import "XYNewCellModel.h"
#import <MJExtension.h>


#import "XYCommonCell.h"
#import "XYSingleImageCell.h"
#import "XYTextCell.h"
#import "XYVideoCell.h"
#import "UIView+Extension.h"
@interface XYTabContentController ()<UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,strong)NSMutableArray *CellModelArr;


@end

@implementation XYTabContentController
-(NSMutableArray *)CellModelArr{
    
    if (_CellModelArr == nil) {
        
        _CellModelArr = [NSMutableArray array];
    }
    
    
    return _CellModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"先创建控制器，，然后得到类型%@  名字%@",self.MyModel.category,self.MyModel.name);

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self RegisterCell];
    [self setUpData];
    
    
}

-(void)RegisterCell{
    
 
    //不要自动调整inset
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-64-44);
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   


    //注册四种cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYCommonCell class]) bundle:nil] forCellReuseIdentifier:CommonCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSingleImageCell class]) bundle:nil] forCellReuseIdentifier:SingleImageCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYTextCell class]) bundle:nil] forCellReuseIdentifier:TextCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYVideoCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];
}


//初始化数据
-(void)setUpData{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(steupData)];
    self.tableView.mj_header.automaticallyChangeAlpha = true; //根据拖拽比例自动切换透
    [self.tableView.mj_header beginRefreshing];
    
    
    
    // 上拉刷新 loadMoredata
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}


- (void)steupData{
    
    
    NSLog(@"得到类型%@  名字%@",self.MyModel.category,self.MyModel.name);
    
    NSDictionary * params = @{ @"device_id" : @"6096495334",
                             @"category" : self.MyModel.category,
                             @"iid" : @"5034850950" };
    [XYRequestTool getDataURL:NewURL params:params progress:^(NSProgress *downloadProgress) {
        
     } success:^(id response) {
     
    
       NSArray * conArr =   [XYContentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        for (XYContentModel * contentModel in conArr) {
//            NSData * data =  [contentModel.content mj_JSONData];
//            NSDictionary * dict =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            YTLog(@"%@",dict);
        
            //json字符串转模型
           XYNewCellModel * model =  [XYNewCellModel  mj_objectWithKeyValues:contentModel.content];
            [self.CellModelArr addObject:model];
        }
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
    } failue:^(NSError *error) {
        
    }];
     NSLog(@"加载页面数据");
    
}


-(void)loadMoreData{
    
    

    
    
    
}



#pragma mark 传递模型数据
-(void)setMyModel:(XYMyModel *)MyModel{
    
    _MyModel = MyModel;
    
}


//切换不同数据
-(void)updateTitleItem:(NSInteger)model{
    
     [self.tableView.mj_header beginRefreshing];
    
    [self.tableView layoutIfNeeded];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.CellModelArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //一系列的判断 加载对应的cell
    
    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    //多图cell
    if(newModel.image_list.count > 0){
        
       XYCommonCell * imagescell =   [tableView dequeueReusableCellWithIdentifier:CommonCell];
      
       imagescell.NewCellModel = newModel;
       
       return  imagescell;
    }else{
        
        //只有一张
        if(newModel.has_image){
            
            
            XYSingleImageCell * singleCell =   [tableView dequeueReusableCellWithIdentifier:SingleImageCell];
            
            singleCell.SingleCellModel = newModel;
            
            return  singleCell;
            
            
        }else{
            
            
            XYTextCell * textcell =   [tableView dequeueReusableCellWithIdentifier:TextCell];
            
            textcell.TextCellModel = newModel;
            
            return  textcell;
        }
        
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //一系列的判断 加载对应的cell
    
    XYNewCellModel * newModel  =  self.CellModelArr[indexPath.row];
    //多图cell
    if(newModel.image_list.count > 0){
        
       return  200;
    }else{
        
        //只有一张
        if(newModel.has_image){
            
    
            
            return  120;
            
            
        }else{
      
            
            return  100;
        }
        
    }
    

}
@end

