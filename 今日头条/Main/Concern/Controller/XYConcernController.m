//
//  XYConcernController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/6.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYConcernController.h"
#import "XYRequestTool.h"
#import "Common.h"
#import <MJRefresh.h>
#import "XYConcrenModel.h"
#import <MJExtension.h>


#import "XYAddConcernViewCell.h"
#import "XYConcernCell.h"
#import "XYConcrenModel.h"
#import "XYForHeaderVIew.h"
@interface XYConcernController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,weak)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray *concernArr;

@property(nonatomic,strong)NSMutableArray *possibleArr;


@property(nonatomic,assign)NSInteger  offset;
@end

@implementation XYConcernController

-(NSMutableArray *)concernArr{
    
    if (!_concernArr) {
        _concernArr = [NSMutableArray array];
    }
    return _concernArr;
}

-(NSMutableArray *)possibleArr{
    
    if (!_possibleArr) {
        _possibleArr = [NSMutableArray array];
    }
    
    return _possibleArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
      // 上拉和下拉加载数据
    [self setupRefresh];
    
    
}

-(void)setupUI{
    
    self.offset = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
#warning 设置为UITableViewStyleGrouped的话，组头就会跟着滑动   否则就一直停留在原地
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height-64-44) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.backgroundColor = YTColor(225, 223, 225);
    tableView.rowHeight = 67;
    
    tableView.tableFooterView = [[UIView alloc]init];
    
    //注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYAddConcernViewCell class]) bundle:nil] forCellReuseIdentifier:AddConcernViewCell];
    
     [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYConcernCell class]) bundle:nil] forCellReuseIdentifier:ConcernCell];
    


    [self.view addSubview:tableView];

    self.tableView = tableView;

    
    
}
-(void)setupRefresh{
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = true;
    [self.tableView.mj_header beginRefreshing];
    
    
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    
    
}

-(void)LoadData{
    
    XYWeakSelf(self);
    NSDictionary * params = @{@"iid" : @"5034850950",
                              @"count" : @(20),
                              @"offset" : @(0),
                              @"type" : @"manage"
                              
                              };
    [XYRequestTool getDataURL:ConCernURL params:params  progress:^(NSProgress *downloadProgress) {
        
    } success:^(id response) {
        
       NSMutableArray * tempconcernArr = [NSMutableArray array];
       NSMutableArray * temppossibleArr = [NSMutableArray array];
       NSArray *ConcrenModel =  [XYConcrenModel mj_objectArrayWithKeyValuesArray:response[@"concern_list"]];
        for (XYConcrenModel * model in ConcrenModel) {
            
            (model.concern_time != 0) ? [tempconcernArr addObject:model] : [temppossibleArr addObject:model];
        }
        
        NSMutableArray * temp1Array = [NSMutableArray array];
        [temp1Array addObjectsFromArray:tempconcernArr];
        [temp1Array addObjectsFromArray:weakself.concernArr];
        
        //每次刷新之后的总第一组的数据
         weakself.concernArr = temp1Array;
        
        
        NSMutableArray * temp2Array = [NSMutableArray array];
        [temp2Array addObjectsFromArray:temppossibleArr];
        [temp2Array addObjectsFromArray:weakself.possibleArr];
             //每次刷新之后的总第二组的数据
        weakself.possibleArr = temp2Array;
        
        
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];

    } failue:^(NSError *error) {
        
    }];
    
}

-(void)loadMoreData{

    XYWeakSelf(self);
    NSDictionary * params = @{@"iid" : @"5034850950",
                              @"count" : @(20),
                              @"offset" : @(self.offset),
                              @"type" : @"recommend"
                              
                              };
    [XYRequestTool getDataURL:ConCernURL params:params  progress:^(NSProgress *downloadProgress) {
        
    } success:^(id response) {
        
        NSMutableArray * tempconcernArr = [NSMutableArray array];
        NSMutableArray * temppossibleArr = [NSMutableArray array];
        NSArray *ConcrenModel =  [XYConcrenModel mj_objectArrayWithKeyValuesArray:response[@"concern_list"]];
        self.offset = [response[@"offset"] integerValue];
        for (XYConcrenModel * model in ConcrenModel) {
            
            (model.concern_time != 0) ? [tempconcernArr addObject:model] : [temppossibleArr addObject:model];
        }
        
      //每次刷新更多之后的总第一组的数据
        [weakself.concernArr addObjectsFromArray:tempconcernArr];
        
      //每次刷新更多之后的总第二组的数据
        [weakself.possibleArr addObjectsFromArray:temppossibleArr];
        
        
    
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failue:^(NSError *error) {
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        
        if ( self.concernArr.count == 0) {
            return 1;
        }else{
        return self.concernArr.count;
        }
    }else{
        
        return self.possibleArr.count;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 28)];
//    view.backgroundColor = [UIColor whiteColor];
//    UIView * redview = [[UIView alloc] initWithFrame:CGRectMake(10, 4, 3, 20)];
//    redview.backgroundColor = YTColor(241, 94, 91);
//    redview.layer.cornerRadius = 2;
//    redview.layer.masksToBounds = true;
//    [view addSubview:redview];
//    
//    
//    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, screen_width, 10)];
//    text.font = [UIFont systemFontOfSize:14];
//    [view addSubview:text];
    
   XYForHeaderVIew * footView =  [[XYForHeaderVIew alloc] init];
    if (section == 0) {
        footView.text = @"正在关心";
      
        return footView;
    }else{
        
          footView.text = @"可能关心";
        return footView;
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 28;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
        
        if ( self.concernArr.count == 0) {
          
          XYAddConcernViewCell * addCell = [tableView dequeueReusableCellWithIdentifier:AddConcernViewCell forIndexPath:indexPath];
            
            return addCell;
        }else{
            XYConcrenModel * model =  self.concernArr[indexPath.row];
            XYConcernCell * concernCell = [tableView dequeueReusableCellWithIdentifier:ConcernCell forIndexPath:indexPath];
            model.flag = YES;
            concernCell.concrenModel = model;
            return concernCell;
        }
    }else{
        XYConcrenModel * model =  self.possibleArr[indexPath.row];
        XYConcernCell * concernCell = [tableView dequeueReusableCellWithIdentifier:ConcernCell forIndexPath:indexPath];
          model.flag = NO;
        concernCell.concrenModel = model;
        return concernCell;

    
    }
    
}

@end
