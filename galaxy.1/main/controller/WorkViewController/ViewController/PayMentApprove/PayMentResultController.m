//
//  PayMentResultController.m
//  galaxy
//
//  Created by hfk on 2017/6/2.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PayMentResultController.h"
#import "PayMentResultCell.h"
@interface PayMentResultController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation PayMentResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"支付结果", nil) backButton:NO];
    [self createOtherBackWithTag:1];
    self.backCount=2;
    
//    NSArray *array=@[@{
//                         @"actionResultType":@"0",
//                         @"flowCode":@"F0009",
//                         @"flowGuid":@"7E692997-D119-45A7-9DC2-BE6E2BC104BC",
//                         @"procId":@"0",
//                         @"resultCode":@"0",
//                         @"resultMessage":@"支付成功",
//                         @"resultType":@"0",
//                         @"serialNo":@"56814",
//                         @"taskId":@"55751",
//                         @"taskName":@"张三的申请单据曹参了"
//                         },
//                     @{
//                         @"actionResultType":@"0",
//                         @"flowCode":@"F0010",
//                         @"flowGuid":@"7E692997-D119-45A7-9DC2-BE6E2BC104BC",
//                         @"procId":@"0",
//                         @"resultCode":@"0",
//                         @"resultMessage":@"支付成功",
//                         @"resultType":@"0",
//                         @"serialNo":@"56815",
//                         @"taskId":@"55741",
//                         @"taskName":@"张三的申请单据CC爱上张三的申请单据CC爱上张三的申请单据CC爱上张三的申请单据CC爱上张三的申请单据CC爱上"
//                         }
//                     ];
//    _dateArray=[NSMutableArray arrayWithArray:array];
    
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}
//MARK:创建tableView
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dateArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PayMentResultCell cellHeightWithObj:_dateArray[indexPath.section]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayMentResultCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PayMentResultCell"];
    if (cell==nil) {
        cell=[[PayMentResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMentResultCell"];
    }
    cell.dict=self.dateArray[indexPath.section];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
