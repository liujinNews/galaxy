//
//  RepaymentListViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/8/8.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "borrowModel.h"
#import "borrowViewCell.h"
#import "RepaymentListViewController.h"
#import "RepayMentRecordDetailController.h"

@interface RepaymentListViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSDictionary * repaymentDic;
@property (nonatomic,strong)NSMutableArray *recordArray;
@property (nonatomic,strong)NSString * totalAmount;
@property (nonatomic,strong)UILabel * totalLa;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * headerView;

@end

@implementation RepaymentListViewController

-(id)initWithType:(NSDictionary *)type Name:(NSString *)str{
    self = [super init];
    if (self) {
        self.status = str;
        if (![type isKindOfClass:[NSNull class]] && type != nil && type.count != 0){
            self.repaymentDic = type;
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestRepaymentInfoList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * nameStr = [NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"requestor"]];
    self.totalAmount = [NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"amount"]];

    if ([NSString isEqualToNull:nameStr]) {
        nameStr = [NSString stringWithFormat:@"%@%@",nameStr,Custing(@"账单", nil)];
    }else{
        nameStr = Custing(@"账单", nil);
    }
    [self setTitle:nameStr backButton:YES];
    self.recordArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self createHeaderView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];

    // Do any additional setup after loading the view.
}

-(void)createHeaderView {
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 110)];
    self.headerView.backgroundColor = [UIColor clearColor];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 75)];
    headView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.headerView addSubview:headView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
    lineView.backgroundColor = Color_GrayLight_Same_20;
    [headView addSubview:lineView];
    UIView *line1View=[[UIView alloc]initWithFrame:CGRectMake(0, 74.5, Main_Screen_Width, 0.5)];
    line1View.backgroundColor = Color_GrayLight_Same_20;
    [headView addSubview:line1View];
    
    
    UILabel * nameLa = [GPUtils createLable:CGRectMake(95, 5, Main_Screen_Width-190, 30) text:Custing(@"剩余应还款", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    nameLa.backgroundColor = [UIColor clearColor];
    [headView  addSubview:nameLa];
    
    self.totalLa = [GPUtils createLable:CGRectMake(95, 35, Main_Screen_Width-190, 30) text:@"0.00" font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentCenter];
    self.totalLa.backgroundColor = [UIColor clearColor];
    [headView  addSubview:self.totalLa];

    if ([NSString isEqualToNull:self.totalAmount]) {
        self.totalLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",self.totalAmount]]];
        
    }
    
    UIButton * repayBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width-95, 1, 80, 73) action:@selector(repaymentAllAmount:) delegate:self title:Custing(@"还款", nil) font:Font_Important_15_20 titleColor:Color_Orange_Weak_20];
    repayBtn.backgroundColor = [UIColor clearColor];
    [headView addSubview:repayBtn];
    
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, 5, 25)];
    blueView.backgroundColor = Color_Blue_Important_20;
    [self.headerView addSubview:blueView];
    UILabel * cateLa = [GPUtils createLable:CGRectMake(15, 85, Main_Screen_Width - 30, 25) text:Custing(@"账单明细", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    cateLa.backgroundColor = [UIColor clearColor];
    [self.headerView  addSubview:cateLa];
    [self.tableView addSubview:self.headerView];
}

-(void)repaymentAllAmount:(UIButton *)btn {
    NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"id"]],@"amount":[NSString stringWithFormat:@"%@",self.totalAmount],@"requestor":[NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"requestor"]],@"requestorUserId":[NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"requestorUserId"]]};
    RepayMentRecordDetailController *vc = [[RepayMentRecordDetailController alloc]init];
    vc.recordDict = parameters;
    vc.type = 1;
    vc.backIndex = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recordArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    borrowViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"borrowViewCell"];
    if (cell==nil) {
        cell=[[borrowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borrowViewCell"];
    }
    borrowModel *cellInfo = self.recordArray[indexPath.row];
    [cell configBorrowInfoListCellInfo:cellInfo];
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    borrowModel *cellInfo = self.recordArray[indexPath.row];
    NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%@",cellInfo.idd],@"amount":[NSString stringWithFormat:@"%@",cellInfo.amount],@"requestor":[NSString stringWithFormat:@"%@",cellInfo.requestor],@"reason":[NSString stringWithFormat:@"%@",cellInfo.reason],@"repayDate":[NSString stringWithFormat:@"%@",cellInfo.repayDate],@"requestorDate":[NSString stringWithFormat:@"%@",cellInfo.requestorDate],@"requestorUserId":[NSString stringWithFormat:@"%@",cellInfo.requestorUserId],@"LoanId":[NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"id"]],@"TaskId":[NSString stringWithFormat:@"%@",cellInfo.taskId],@"FlowCode":[NSString stringWithFormat:@"%@",cellInfo.flowCode]};
    
    RepayMentRecordDetailController *vc = [[RepayMentRecordDetailController alloc]init];
    vc.type = 2;
    vc.recordDict = parameters;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)requestRepaymentInfoList {//userloan/GetLoanDetails
    NSDictionary * dic =@{@"RequestorUserId":[NSString stringWithFormat:@"%@",[self.repaymentDic objectForKey:@"requestorUserId"]],@"PageIndex":@"1",@"PageSize":@"1000",@"OrderBy":@"Id",@"IsAsc":@""};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetLoanDetails] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum ==0) {
        NSDictionary *result = [responceDic objectForKey:@"result"];
        NSString * totalAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"totalAmount"]];
        if ([NSString isEqualToNull:totalAmount]) {
            self.totalLa.text = [NSString stringWithFormat:@"%@",[GPUtils transformNsNumber:[NSString stringWithFormat:@"%@",totalAmount]]];
            self.totalAmount = totalAmount;
            
        }
    }
    
    switch (serialNum) {
        case 0:
            [self.recordArray removeAllObjects];
            [borrowModel GetRepaymentListDictionary:responceDic Array:self.recordArray];
            break;
        default:
            break;
    }
    [self createNOdataView];
    
    [_tableView reloadData];
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

//MARK:创建无数据视图
-(void)createNOdataView{
    
    [_tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有账单明细哦", nil) hasData:(_recordArray.count!=0) hasError:NO reloadButtonBlock:nil];

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
