//
//  XYSetingController.m
//  今日头条
//
//  Created by 尧的mac on 16/9/28.
//  Copyright © 2016年 sagacityidea.icom. All rights reserved.
//

#import "XYSetingController.h"
#import "Common.h"
#import "XYSetingViewCell.h"
#import "XYSetingModel.h"
#import <MJExtension.h>

#import "UIBarButtonItem+XY.h"
@interface XYSetingController ()

@property(nonatomic,strong)NSMutableArray *itmeArr;

@end



@implementation XYSetingController


-(NSMutableArray *)itmeArr{
    
    if (!_itmeArr) {
        
        _itmeArr = [NSMutableArray array];
    }
    
    return _itmeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"设置";
    
    
    [self loadPlist];
    // 设置 UI
    [self setupUI];
   
}

-(void)loadPlist{
    
    
      NSString * path = [[NSBundle mainBundle] pathForResource:@"XYSettingPlist" ofType:@"plist"];
    
      NSArray * arr =  [NSArray arrayWithContentsOfFile:path];
      for (NSArray * contentArr in arr) {
        
        
       NSArray * temp =  [XYSetingModel mj_objectArrayWithKeyValuesArray:contentArr];
        
        [self.itmeArr addObject:temp];
    }
}

-(void)setupUI{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:
                    CGRectMake(0, 64, screen_width, screen_height-64-44) style:UITableViewStyleGrouped];;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = YTColor(236, 236, 236);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XYSetingViewCell" bundle:nil] forCellReuseIdentifier:SetingViewCell];
    
    UIView * footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor redColor];
    footerView.frame = CGRectMake(0, 0, screen_width, 200);
    self.tableView.tableFooterView = footerView;
  
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:@"意见反馈" selectedColor:[UIColor blackColor] target:self action:@selector(SubmitIdea)];
    
}

-(void)SubmitIdea{
    
    
    YTLog(@"SubmitIdea");
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

     return self.itmeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
     NSArray * arr =   self.itmeArr[section];
    
     return arr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == self.itmeArr.count-1) {
        return 0;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * arr =   self.itmeArr[indexPath.section];
    XYSetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetingViewCell];
    
    cell.setingModel = arr[indexPath.row];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
