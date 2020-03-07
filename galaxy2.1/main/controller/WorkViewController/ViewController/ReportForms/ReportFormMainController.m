//
//  ReportFormMainController.m
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ReportFormMainController.h"
#import "ReportFormMainModel.h"
#import "ReportFormMainCell.h"

//ZF项目费用统计
#import "ZFProjectStatViewController.h"

//部门费用统计
#import "departmentStatViewController.h"
//费用统计
#import "CostStatisticsViewController.h"
//员工费用统计
#import "PersonnelStatViewController.h"
//员工动态
#import "PersonnelDynViewController.h"
//请假统计
#import "askLeavelStatisticsViewController.h"
//物品领用统计
#import "ArticlesUsingRegistrationViewController.h"

//预算统计
#import "BudgetStatViewController.h"
//报销统计
#import "ApplyStatViewController.h"
//项目费用统计
#import "ProjectStatViewController.h"
//费用单据查询
#import "DocumentSearchController.h"
//采购统计
#import "ProcurementStatisticController.h"

@interface ReportFormMainController ()<FormTableViewCellDelegate,FormTableViewCellDataSource>
//已经打开下拉菜单的单元格
@property (strong, nonatomic) ReportFormMainCell *openedFormCell;
//已经打开下拉菜单的单元格的位置
@property (strong, nonatomic) NSIndexPath *openedFormCellIndex;
@property(nonatomic,strong)ReportFormMainCell *cell;
/**
 *  图表数据字典
 */
@property(nonatomic,strong)NSMutableArray *FormChartDataArray;
@end

@implementation ReportFormMainController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"报表", nil) backButton:YES ];
    self.view.backgroundColor=Color_White_Same_20;
    [self createTableView];
    _requestType=@"1";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [self requestReportFormData];
    }
    _requestType=@"0";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=Color_White_Same_20;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-10);
    }];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_isLoading) {
            return;
        }
        [weakSelf loadData];
    }];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [_tableView.mj_header beginRefreshing];
}

//MARK:请求报表数据
-(void)requestReportFormData{
    NSString *url=[NSString stringWithFormat:@"%@", GetReportMainData_V1];
    _isLoading = YES;
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求费用统计
-(void)requestCostStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetCostStatisticsChart];
    NSDictionary *parameters = @{@"IsGetMon":@1};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求预算统计
-(void)requestBudgetStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetBudgetStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    
}
//MARK:请求报销统计
-(void)requestApplyStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetApplyStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求项目费用统计
-(void)requestProjectCostStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetProjectCostStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:请求员工费用统计
-(void)requestEmployeeCostStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetEmployeeCostStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:请求费用单据查询
-(void)requestFormSearch{
    NSString *url=[NSString stringWithFormat:@"%@", GetFormSearchChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:请求员工动向
-(void)requestEmployeeTrend{
    NSString *url=[NSString stringWithFormat:@"%@", GetEmployeeTrendChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:请求请假统计
-(void)requestAskingLeaveStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetAskingLeaveStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:6 IfUserCache:NO];
}
//MARK:请求采购统计
-(void)requestProcurementStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetProcurementStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:7 IfUserCache:NO];
}
//MARK:请求物品领用统计
-(void)requestArticleConsumeStatistics{
    NSString *url=[NSString stringWithFormat:@"%@", GetArticleStatisticsChart];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //    NSLog(@"resDic:%@",responceDic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            [_tableView.mj_header endRefreshing];
        }else{
            [_tableView.mj_header endRefreshing];
        }
        return;
    }
    _resultDict=responceDic;
    if (serialNum!=0) {
        NSDictionary *dict=_resultDict[@"result"];
        if ([dict isKindOfClass:[NSNull class]]) {
            return;
        }
    }
    switch (serialNum) {
        case 0:
            _resultArray=[NSMutableArray array];
            self.openedFormCell = nil;
            self.openedFormCellIndex = nil;
            [ReportFormMainModel getReportFormMainDataByDictionary:_resultDict Array:_resultArray];
            //修改下载的状态
            _isLoading = NO;
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
            break;
        case 1://费用统计,预算统计,报销统计
            [self dealWithChartDataOneStyle];
            [self refreshChartCell];
            break;
        case 2://项目费用统计
            [self dealWithChartDataTwoStyle];
            [self refreshChartCell];
            break;
        case 3://员工费用统计
            [self dealWithChartDataThreeStyle];
            [self refreshChartCell];
            break;
        case 4://费用单据查询
            [self dealWithChartDataFourStyle];
            [self refreshChartCell];
            break;
        case 5://员工动向
            [self dealWithChartDataFiveStyle];
            [self refreshChartCell];
            break;
        case 6://请假统计
            [self dealWithChartDataSixStyle];
            [self refreshChartCell];
            break;
        case 7://采购统计
            [self dealWithChartDataSevenStyle];
            [self refreshChartCell];
            break;
        default:
            break;
    }
}

//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [_resultArray removeAllObjects];
    _tableView.userInteractionEnabled=YES;
    _isLoading=NO;
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    
}
//MARK:解析报表数据
//费用统计,预算统计,报销统计
-(void)dealWithChartDataOneStyle{
    NSDictionary *dict=_resultDict[@"result"];
    _FormChartDataArray=[NSMutableArray array];
    NSArray *Xarray=dict[@"days"];
    NSArray *Yarray=dict[@"qtys"];
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//项目费用统计
-(void)dealWithChartDataTwoStyle{
    NSDictionary *dict=_resultDict[@"result"];
    _FormChartDataArray=[NSMutableArray array];
    NSArray *Xarray=dict[@"days"];
    NSArray *Yarray=dict[@"amounts"];
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//员工费用统计
-(void)dealWithChartDataThreeStyle{
    _FormChartDataArray=[NSMutableArray array];
    NSArray *array=_resultDict[@"result"];
    NSMutableArray *Xarray=[NSMutableArray array];
    NSMutableArray *Yarray=[NSMutableArray array];
    for (NSDictionary *dict in array) {
        [Xarray addObject:dict[@"requestor"]];
        [Yarray addObject:dict[@"totalAmount"]];
    }
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//费用单据查询
-(void)dealWithChartDataFourStyle{
    NSDictionary *dict=_resultDict[@"result"];
    _FormChartDataArray=[NSMutableArray array];
    NSArray *Xarray=dict[@"days"];
    NSArray *Yarray=dict[@"counts"];
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//员工动向
-(void)dealWithChartDataFiveStyle{
    _FormChartDataArray=[NSMutableArray array];
    NSArray *array=_resultDict[@"result"];
    NSMutableArray *Xarray=[NSMutableArray array];
    NSMutableArray *Yarray=[NSMutableArray array];
    for (NSDictionary *dict in array) {
        [Xarray addObject:dict[@"name"]];
        [Yarray addObject:dict[@"qty"]];
    }
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//请假统计
-(void)dealWithChartDataSixStyle{
    _FormChartDataArray=[NSMutableArray array];
    NSArray *array=_resultDict[@"result"];
    NSMutableArray *Xarray=[NSMutableArray array];
    NSMutableArray *Yarray=[NSMutableArray array];
    for (NSDictionary *dict in array) {
        [Xarray addObject:dict[@"name"]];
        [Yarray addObject:dict[@"qty"]];
    }
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}
//采购统计
-(void)dealWithChartDataSevenStyle{
    NSDictionary *dict=_resultDict[@"result"];
    _FormChartDataArray=[NSMutableArray array];
    NSArray *Xarray=dict[@"days"];
    NSArray *Yarray=dict[@"amts"];
    [_FormChartDataArray addObject:Xarray];
    [_FormChartDataArray addObject:Yarray];
}


//MARK:刷新ChartCell
-(void)refreshChartCell{
    _tableView.userInteractionEnabled=YES;
    [_tableView reloadRowsAtIndexPaths:@[self.openedFormCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView scrollToRowAtIndexPath:self.openedFormCellIndex
                      atScrollPosition:UITableViewScrollPositionNone
                              animated:YES];
}

//MARK:tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _resultArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 8)];
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
    if ((self.openedFormCell != nil)&&
        (self.openedFormCell.isOpenForm = YES)&&
        (self.openedFormCellIndex.section == indexPath.section))
    {
        return 225.0;
    }else
    {
        return 90.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell=[tableView dequeueReusableCellWithIdentifier:@"ReportFormMainCell"];
    if (_cell==nil) {
        _cell=[[ReportFormMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReportFormMainCell"];
    }
    _cell.delegate = self;
    _cell.dataSource = self;
    _cell.MarkIndex=indexPath.section;
    [_cell configViewWithModel:_resultArray[indexPath.section]];
    if ((self.openedFormCell != nil)&&
        (self.openedFormCell.isOpenForm = YES)&&
        (self.openedFormCellIndex.section ==indexPath.section)){
        [_cell buildChartViewWithModel:_resultArray[indexPath.section]];
    }
    return _cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.openedFormCell != nil)&&
        (self.openedFormCell.isOpenForm = YES)&&
        (self.openedFormCellIndex.section ==indexPath.section))
    {
        //如果点的是同一个cell关闭下拉菜单并且不刷新新的cell
        self.openedFormCell = nil;
        [_tableView reloadRowsAtIndexPaths:@[self.openedFormCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.openedFormCellIndex = nil;
        return;
    }
    self.openedFormCell =[_tableView cellForRowAtIndexPath:indexPath];
    self.openedFormCellIndex =indexPath;
    [self getChartDataWith:indexPath];
}

-(void)getChartDataWith:(NSIndexPath *)index{
    ReportFormMainModel *model=_resultArray[index.section];
    _tableView.userInteractionEnabled=NO;
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if ([model.code isEqualToString:@"001"]) {
        [self requestCostStatistics];
    }else if ([model.code isEqualToString:@"002"]){
        [self requestBudgetStatistics];
    }else if ([model.code isEqualToString:@"003"]){
        [self requestApplyStatistics];
    }else if ([model.code isEqualToString:@"004"]){
        [self requestProjectCostStatistics];
    }else if ([model.code isEqualToString:@"005"]){
        [YXSpritesLoadingView dismiss];
        _FormChartDataArray=[NSMutableArray array];
        [_FormChartDataArray addObject:model.Xarray];
        [_FormChartDataArray addObject:model.Yarray];
        [self refreshChartCell];
    }else if ([model.code isEqualToString:@"006"]){
        [self requestEmployeeCostStatistics];
    }else if ([model.code isEqualToString:@"007"]){
        [self requestFormSearch];
    }else if ([model.code isEqualToString:@"008"]){
        [self requestEmployeeTrend];
    }else if ([model.code isEqualToString:@"009"]){
        [self requestAskingLeaveStatistics];
    }else if ([model.code isEqualToString:@"010"]){
        [self requestProcurementStatistics];
    }else if ([model.code isEqualToString:@"011"]){
        [self requestArticleConsumeStatistics];
    }else{
        [YXSpritesLoadingView dismiss];
        _tableView.userInteractionEnabled=YES;
        self.openedFormCell=nil;
        self.openedFormCellIndex=nil;
    }
}
-(void)loadData{
    [self requestReportFormData];
}

#pragma mark - FormtableViewCellDataSource

- (NSMutableArray *)dataSourceForFormItem
{
    return _FormChartDataArray;
}
#pragma mark -FormTableViewCellDelegate
-(void)FormTableViewCell:(ReportFormMainCell *)FormTableViewCell didSeletedFormItemAtIndex:(NSInteger)Index{
    if ((self.openedFormCell != nil)&&
        (self.openedFormCell.isOpenForm = YES)&&
        (self.openedFormCellIndex.section == FormTableViewCell.MarkIndex))
    {
        self.openedFormCell = nil;
        [_tableView reloadRowsAtIndexPaths:@[self.openedFormCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.openedFormCellIndex = nil;
    }
    
    switch (Index)
    {
        case 1:
        {
            NSLog(@"费用统计");
            CostStatisticsViewController * cost = [[CostStatisticsViewController alloc]init];
            [self.navigationController pushViewController:cost animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"预算统计");
            BudgetStatViewController *budg = [[BudgetStatViewController alloc]init];
            [self.navigationController pushViewController:budg animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"报销统计");
            ApplyStatViewController *apply = [[ApplyStatViewController alloc]init];
            [self.navigationController pushViewController:apply animated:YES];
        }
            break;
        case 4:
        {
            ProjectStatViewController *pro = [[ProjectStatViewController alloc]init];
            [self.navigationController pushViewController:pro animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"员工费用统计");
            PersonnelStatViewController * personnal = [[PersonnelStatViewController alloc]init];
            [self.navigationController pushViewController:personnal animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"费用单据查询");
            DocumentSearchController *doc = [[DocumentSearchController alloc]init];
            [self.navigationController pushViewController:doc animated:YES];
        }
            break;
        case 7:
        {
            NSLog(@"员工动向");
            PersonnelDynViewController * personnal = [[PersonnelDynViewController alloc]init];
            [self.navigationController pushViewController:personnal animated:YES];
        }
            break;
        case 8:
        {
            NSLog(@"请假统计");
            askLeavelStatisticsViewController * personnal = [[askLeavelStatisticsViewController alloc]init];
            [self.navigationController pushViewController:personnal animated:YES];
        }
            break;
        case 9:
        {
            NSLog(@"采购统计");
            ProcurementStatisticController *pro = [[ProcurementStatisticController alloc]init];
            [self.navigationController pushViewController:pro animated:YES];
        }
            break;
        case 10:
        {
            NSLog(@"物品领用统计");
            ArticlesUsingRegistrationViewController * personnal = [[ArticlesUsingRegistrationViewController alloc]init];
            [self.navigationController pushViewController:personnal animated:YES];
        }
            break;
        case 11:
        {
            NSLog(@"部门费用统计");
            departmentStatViewController * personnal = [[departmentStatViewController alloc]init];
            [self.navigationController pushViewController:personnal animated:YES];
            
        }
            break;
        default:
            break;
    }
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
