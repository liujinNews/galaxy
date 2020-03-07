//
//  financialOrgnViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "BudgetSettingViewController.h"
#import "travelTypeViewController.h"
#import "procurementTypeViewController.h"
#import "travealPolicyViewController.h"
#import "currencyViewController.h"
#import "projectManagementViewController.h"
#import "costCenterViewController.h"
#import "BorrowRecordViewController.h"

#import "financialOrgnViewController.h"
#import "CostClassesController.h"
#import "costCenterCell.h"
#import "PayCompanyViewController.h"
#import "ClientViewController.h"

@interface financialOrgnViewController ()<UITableViewDelegate,UITableViewDataSource,GPClientDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * finanicalArray;
@property (nonatomic,strong)NSString * paramValue;
@property (nonatomic,strong)NSString * hrsStr;
@property (nonatomic,strong)NSString * forStandStr;
@property (nonatomic,strong)NSString * releaseStr;

@end

@implementation financialOrgnViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if ([self.releaseStr isEqualToString:@"0"]) {
        [self requestParameterSettings];
//        [self requestHRStandardParameterSettings];
//        [self requestStdParamsGetParameterSettings];
    }
//    else if ([self.releaseStr isEqualToString:@"1"]) {
//        [self requestParameterSettings];
//    }else if ([self.releaseStr isEqualToString:@"2"]) {
//        [self requestHRStandardParameterSettings];
//        [self requestStdParamsGetParameterSettings];
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.releaseStr = @"0";
  
    self.finanicalArray = @[
                            @[@{@"financialImage":@"CostClasses",@"financialType":Custing(@"费用类别", nil)},@{@"financialImage":@"BudgetSetting",@"financialType":Custing(@"预算管理", nil)},@{@"financialImage":@"hstandardIcon",@"financialType":Custing(@"报销标准", nil)},@{@"financialImage":@"cityLevel",@"financialType":Custing(@"城市级别", nil)}],
                            
                            @[@{@"financialImage":@"gongys",@"financialType":Custing(@"供应商", nil)},@{@"financialImage":@"client",@"financialType":Custing(@"客户", nil)},@{@"financialImage":@"projectManagement",@"financialType":Custing(@"项目", nil)},],
                            @[@{@"financialImage":@"Currency",@"financialType":Custing(@"币种", nil)},@{@"financialImage":@"TravelType",@"financialType":Custing(@"出差类型", nil)},@{@"financialImage":@"procurementWay",@"financialType":Custing(@"采购类型", nil)},@{@"financialImage":@"payoffWay",@"financialType":Custing(@"支付方式", nil)}]
                            ];
    
    [self setTitle:Custing(@"财务管理", nil) backButton:YES];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.finanicalArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemArray = self.finanicalArray[section];
    return [itemArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    costCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"costCenterCell"];
    if (cell==nil) {
        cell=[[costCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCenterCell"];
    }
    NSArray *arr=[NSArray arrayWithArray:self.finanicalArray[indexPath.section]];
    [cell configFinancialOrgnTypeCellInfo:arr WithIndex:indexPath.row];
    return cell;
}

//当前行点击事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.releaseStr = @"5";
    NSString *name = self.finanicalArray[indexPath.section][indexPath.row][@"financialType"];
    if ([name isEqualToString:Custing(@"员工借款", nil)]) {
        [self pushBorrowRecordVC];
    }else if ([name isEqualToString:Custing(@"费用类别", nil)]){
        CostClassesController *costVC=[[CostClassesController alloc]init];
        [self.navigationController pushViewController:costVC animated:YES];
    }else if ([name isEqualToString:Custing(@"币种", nil)]){
        self.releaseStr = @"0";
        [self pushCurrencyVC];
    }else if ([name isEqualToString:Custing(@"项目", nil)]){
        [self pushProjectManagement];
    }else if ([name isEqualToString:Custing(@"报销标准", nil)]){
//        self.releaseStr = @"2";
        [self pushHRStandard];
    }else if ([name isEqualToString:Custing(@"采购类型", nil)]){
        [self pushProcurementType];
    }else if ([name isEqualToString:Custing(@"支付方式", nil)]){
        [self pushpayoffWay];
    }else if ([name isEqualToString:Custing(@"出差类型", nil)]){
        [self pushTravelType];
    }else if ([name isEqualToString:Custing(@"预算管理", nil)]){
        [self pushBudgetSetVC];
    }else if ([name isEqualToString:Custing(@"城市级别", nil)]){
        [self pushCityLeavealSetVC];
    }else if ([name isEqualToString:Custing(@"供应商", nil)]){
        [self pushPayCompany];
    }else if ([name isEqualToString:Custing(@"客户", nil)]){
        [self pushClient];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)pushCityLeavealSetVC{
    BudgetSettingViewController *exp = [[BudgetSettingViewController alloc]init];
    exp.statusStr = @"cityLeavel";
    [self.navigationController pushViewController:exp animated:YES];
}

-(void)pushBudgetSetVC{
    BudgetSettingViewController *exp = [[BudgetSettingViewController alloc]init];
    exp.statusStr = @"budgetSet";
    [self.navigationController pushViewController:exp animated:YES];
}


-(void)pushBorrowRecordVC{
    BorrowRecordViewController * borrow = [[BorrowRecordViewController alloc]init];
    [self.navigationController pushViewController: borrow animated:YES];
}

-(void)pushCurrencyVC{
    currencyViewController * currency = [[currencyViewController alloc]initWithType:self.paramValue];
    [self.navigationController pushViewController:currency animated:YES];
}

-(void)pushProjectManagement{
    projectManagementViewController * project = [[projectManagementViewController alloc]init];
    [self.navigationController pushViewController:project animated:YES];
}

-(void)pushHRStandard{
//    travealPolicyViewController * hrs = [[travealPolicyViewController alloc]init];
//    [self.navigationController pushViewController:hrs animated:YES];
    BudgetSettingViewController *exp = [[BudgetSettingViewController alloc]init];
    exp.statusStr = @"HRStandard";
    [self.navigationController pushViewController:exp animated:YES];
}

-(void)pushProcurementType{
    procurementTypeViewController * procurement = [[procurementTypeViewController alloc]initWithType:@"procurrement"];
    [self.navigationController pushViewController:procurement animated:YES];
}

-(void)pushpayoffWay{
    procurementTypeViewController * procurement = [[procurementTypeViewController alloc]initWithType:@"payoffWay"];
    [self.navigationController pushViewController:procurement animated:YES];
}

-(void)pushTravelType{
    travelTypeViewController * procurement = [[travelTypeViewController alloc]initWithType:@"travelType"];
    [self.navigationController pushViewController:procurement animated:YES];
}

-(void)pushPayCompany{
    PayCompanyViewController *pay = [[PayCompanyViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}

-(void)pushClient{
    ClientViewController *Client = [[ClientViewController alloc]init];
    [self.navigationController pushViewController:Client animated:YES];
}


//请求参数
-(void)requestParameterSettings{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",getexpparam] Parameters:@{@"ParamName":@"UseCurrency"} Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

////请求参数
//-(void)requestHRStandardParameterSettings{
//    
//    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetParam] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
//    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
//    
//}
//


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    if (serialNum ==0) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }
        if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
            self.paramValue = [NSString stringWithFormat:@"%@",[result objectForKey:@"paramValue"]];
        }
    }
    
//    if (serialNum ==1) {
//        NSString * result = [responceDic objectForKey:@"result"];
//        if (![NSString isEqualToNull:result]) {
//            return;
//        }else{
//            self.hrsStr = [NSString stringWithFormat:@"%@",result];
//        }
//        
//    }
//    
//    if (serialNum ==2) {
//        NSString * result = [responceDic objectForKey:@"result"];
//        if (![NSString isEqualToNull:result]) {
//            return;
//        }else{
//            self.forStandStr = [NSString stringWithFormat:@"%@",result];
//        }
//        
//    }
    switch (serialNum) {
        case 0://
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];    
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
