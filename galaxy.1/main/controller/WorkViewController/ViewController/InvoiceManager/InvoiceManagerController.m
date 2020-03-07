//
//  InvoiceManagerController.m
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "InvoiceManagerController.h"

@interface InvoiceManagerController ()<GPClientDelegate>

@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)NSDictionary *search_parameter;//请求参数
@end

@implementation InvoiceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"发票管家", nil) backButton:YES ];
    [self createSearch];
    [self updateTableView];
}
//MARK:创建编辑筛选按钮
-(void)createSearch{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(search:)];
}
-(void)updateTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"InvoiceManagerCell" bundle:nil] forCellReuseIdentifier:@"InvoiceManagerCell"];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark 添加网络数据

//MARK:发票管家列表
-(void)requestInvoiceList{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",GETXBINVOICE];
    NSDictionary *parameters;
    if (!self.search_parameter) {
        parameters = @{
                       @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],
                       @"PageSize": @"15",
                       @"StartTime":@"",
                       @"EndTime":@"",
                       @"InvoiceCode":@"",
                       @"InvoiceNumber":@"",
                       @"PurchaserName":@"",
                       @"SalesName":@"",
                       @"InvoiceType":@"0",
                       @"Status":@"0",
                       @"ExpenseCode":@""
                       };
    }else{
        parameters = @{
                       @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],
                       @"PageSize":@"15",
                       @"StartTime":self.search_parameter[@"StartTime"],
                       @"EndTime":self.search_parameter[@"EndTime"],
                       @"InvoiceCode":self.search_parameter[@"InvoiceCode"],
                       @"InvoiceNumber":self.search_parameter[@"InvoiceNumber"],
                       @"PurchaserName":self.search_parameter[@"PurchaserName"],
                       @"SalesName":self.search_parameter[@"SalesName"],
                       @"InvoiceType":self.search_parameter[@"InvoiceType"],
                       @"Status":self.search_parameter[@"Status"],
                       @"ExpenseCode":self.search_parameter[@"ExpenseCode"],
                       @"Source":self.search_parameter[@"Source"]

                       };
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    
//    self.isLoading = YES;
//    NSString *url=[NSString stringWithFormat:@"%@",WorksubmitGetcreatedbyme];
//    NSDictionary *parameters;
//    if (!self.search_parameter) {
//        parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@12,@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"TaskName":@""};
//    }
//    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [responceDic objectForKey:@"msg"];
        self.isLoading=NO;
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        return;
    }
    //下拉刷新
    if (self.currPage == 1) {
        [self.resultArray removeAllObjects];
    }
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}
//MARK:数据处理
-(void)dealWithData
{
//    InvoiceManagerModel *model=[[InvoiceManagerModel alloc]init];
//    model.purchaserName=@"a公司";
//    model.purchaserTaxNo=@"abc1211323";
//    model.salesName=@"上海麦当劳食品有限公司";
//    model.amountTax=@"200";
//    model.totalTax=@"15";
//    model.billingDate=@"2017/11/11";
//    model.invoiceCode=@"333333333";
//    model.invoiceNumber=@"11112222";
//    model.invoiceType=@"1";
//
//
//    model.totalAmount=@"88888888.99";
//    model.flowCode=@"F0002";
//    model.expenseType=@"餐费";
//    model.expenseIcon=@"02";
//    model.expenseCat=@"日常";
//    model.taskId=@"73869";
//    [self.resultArray addObject:model];
//
//    InvoiceManagerModel *model1=[[InvoiceManagerModel alloc]init];
//    model1.purchaserName=@"a爱是撒奥所公司";
//    model1.purchaserTaxNo=@"hjjhashjjhsaabc1211323";
//    model1.salesName=@"上海汉堡王食品有限公司";
//    model1.amountTax=@"3300";
//    model1.totalTax=@"150";
//    model1.billingDate=@"2017/12/13";
//    model1.invoiceCode=@"7817812781";
//    model1.invoiceNumber=@"891929281";
//    model1.invoiceType=@"2";
//
//
//    model1.totalAmount=@"777777.99";
//    model1.flowCode=@"F0003";
//    model1.expenseType=@"电话费";
//    model1.expenseIcon=@"03";
//    model1.expenseCat=@"日常";
//    model1.taskId=@"7500";
//    [self.resultArray addObject:model1];
    
    
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            InvoiceManagerModel *model=[[InvoiceManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            InvoiceManagerModel *model=[[InvoiceManagerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceManagerModel *model=self.resultArray[indexPath.section];
    return [InvoiceManagerCell cellHeightWithObj:model];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceManagerCell *cell=[tableView dequeueReusableCellWithIdentifier:@"InvoiceManagerCell"];
    if (cell==nil) {
        cell=[[InvoiceManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvoiceManagerCell"];
    }
    InvoiceManagerModel *model=self.resultArray[indexPath.section];
    [cell configCellWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceManagerModel *model=self.resultArray[indexPath.section];
    InvoiceMangerDetailController *vc=[[InvoiceMangerDetailController alloc]init];
    vc.model_InvoiceDetail=model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadData{
    [self requestInvoiceList];
}
//MARK:查询按钮点击事件
-(void)search:(UIButton *)btn{
    NSLog(@"查询");
    InvoiceManSearchController *vc=[[InvoiceManSearchController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.SearchClickedBlock = ^(NSDictionary *parameters) {
        self.currPage=1;
        weakSelf.search_parameter=parameters;
        [weakSelf requestInvoiceList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:创建无数据视图
-(void)createNOdataView{
    NSString *tips;
    if (self.search_parameter) {
        tips=Custing(@"您还没有相关数据哦", nil);
    }else{
        tips=Custing(@"您还没有发票哦", nil);
    }
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:tips hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
