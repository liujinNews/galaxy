//
//  DocumentSearchController.m
//  galaxy
//
//  Created by hfk on 2017/2/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "DocumentSearchController.h"

@interface DocumentSearchController ()
@property (nonatomic, strong) NSString *start_select_date;//开始时间
@property (nonatomic, strong) NSString *end_select_date;//结束时间
@property (nonatomic, strong) NSString *str_People;//当前选择的申请人
@property (nonatomic, strong) NSString *str_money_last;//最小金额
@property (nonatomic, strong) NSString *str_money_max;//最大金额
@property (nonatomic, strong) NSString *str_state;//当前选择的状态
@property (nonatomic, strong) NSString *str_Dept;//当前选择的部门
@property (nonatomic, strong) NSString *str_DeptId;//当前选择的部门
@property (nonatomic, strong) NSString *str_SeriaNo;//当前选择的单号
@property (nonatomic, strong) NSString *str_FlowGuid;//当前选择的Guid
@property (nonatomic, strong) NSString *str_TaskName;//当前选择的名称
@property (nonatomic, strong) NSString *str_BranchId;//当前选择的公司
@property (nonatomic, strong) NSString *str_CostCenterId;//当前选择的成本中心


@end

@implementation DocumentSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"单据查询", nil) backButton:YES];
    [self createFilter];
    [self initializeData];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _requestType=@"1";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
    if (![_requestType isEqualToString:@"1"]) {
            self.currPage=1;
            [self requestGetbudgetDocument];
    }
    _requestType=@"0";
}
#pragma mark 数据
//初始化数据
-(void)initializeData{
    _start_select_date = @"";
    
    _end_select_date = @"";
    
    _str_People = @"";
    _str_state = @"";
    _str_money_last = @"";
    _str_money_max = @"";
    self.resultArray = [NSMutableArray array];
    self.isLoading = NO;
    _str_Dept=@"";
    _str_DeptId=@"";
    _str_SeriaNo=@"";
    _str_FlowGuid=@"";
    _str_TaskName=@"";
}


-(void)createFilter
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"NavBarImg_AgentMyFilter":@"NavBarImg_MyFilter" target:self action:@selector(filterSubmit:)];
}
//MARK:筛选按钮点击事件
-(void)filterSubmit:(UIButton *)btn
{
    NSLog(@"筛选");
    FilterBaseViewController  *SubmitFilter=[[FilterBaseViewController alloc]initWithType:@"DocumentSearch"];
    _requestType=@"0";
    __weak typeof(self) weakSelf = self;
    SubmitFilter.block=^(NSDictionary *dict){
        weakSelf.start_select_date = dict[@"RequestorFromDate"];
        weakSelf.end_select_date = dict[@"RequestorToDate"];
        weakSelf.str_money_last = dict[@"StartAmount"];
        weakSelf.str_money_max = dict[@"EndAmount"];
        weakSelf.str_People = dict[@"Requestor"];
        weakSelf.str_state = dict[@"Status"];
        weakSelf.str_FlowGuid = dict[@"FlowGuid"];
        weakSelf.str_SeriaNo = dict[@"SerialNo"];
        weakSelf.str_DeptId = dict[@"RequestorDeptId"];
        weakSelf.str_Dept = dict[@"RequestorDept"];
        weakSelf.str_TaskName = dict[@"taskName"];
        weakSelf.str_BranchId = dict[@"branchId"];
        weakSelf.str_CostCenterId = dict[@"costCenterId"];
        };
    [self.navigationController pushViewController:SubmitFilter animated:YES];
}
#pragma mark 请求数据
//报销统计
-(void)requestGetbudgetDocument
{
    //type 0 差旅 1 日常
    self.isLoading = YES;
    NSDictionary *dic =@{@"RequestorFromDate":_start_select_date,@"RequestorToDate":_end_select_date,@"StartAmount":_str_money_last,@"EndAmount":_str_money_max,@"Requestor":_str_People,@"Status":![NSString isEqualToNull:_str_state]?@"0":[NSString stringWithFormat:@"%d",[_str_state intValue]],@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize": @"15",@"FlowGuid":_str_FlowGuid,@"SerialNo":_str_SeriaNo,@"RequestorDeptId":_str_DeptId,@"RequestorDept":_str_Dept,@"TaskName":_str_TaskName,@"BranchId":_str_BranchId,@"CostCenterId":_str_CostCenterId,};
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",analyDocumentSearch_V2] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

#pragma mark - delegate
//网络请求
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dic_requst = responceDic;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
    if (self.currPage == 1&&self.isLoading) {
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
        case 6:
            self.currPage=1;
            [self requestGetbudgetDocument];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"作废成功", nil)];
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)dealWithData
{
    NSDictionary *result = _dic_requst[@"result"];
    _totalPage = [result[@"totalPages"] integerValue];
    
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.resultArray addObject:model];
        }
    }
}
//下拉上拉
-(void)loadData
{
    [self requestGetbudgetDocument];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyApplyModel *model=(MyApplyModel *)self.resultArray[indexPath.section];
    return [MyApproveViewCell cellHeightWithObj:model];
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
    _cell=[tableView dequeueReusableCellWithIdentifier:@"MyApproveViewCell"];
    if (_cell==nil) {
        _cell=[[MyApproveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyApproveViewCell"];
    }
    _cell.tag=indexPath.row+400;
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
    
    [_cell configViewHasApproveWithModel:model];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}
//是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
    // 作废按钮
    UITableViewRowAction *abrogateRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"作废", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if ([model.status integerValue]==4&&[model.paymentStatus integerValue]!=1) {
            NSString *url=[NSString stringWithFormat:@"%@", CANCELLEDDelete];
            NSDictionary *parameters = @{@"TaskId":model.taskId,@"FlowCode":model.flowCode};
            [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:6 IfUserCache:NO];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"不能作废", nil) duration:2.0];
        }
    }];
    if ([model.status integerValue]==4&&[model.paymentStatus integerValue]!=1) {
        abrogateRowAction.backgroundColor = [UIColor redColor];
    }else{
        abrogateRowAction.backgroundColor = [UIColor grayColor];
    }
    return @[abrogateRowAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.pushModel=self.resultArray[indexPath.section];
    [self MyApproveSelect:self.pushModel WithIndex:2];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath

{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
        
    }
    
}
//MARK:创建无数据视图
-(void)createNOdataView{
    [self.tableView configBlankPage:EaseBlankNormalView hasTips:Custing(@"您还没有相关记录哦", nil) hasData:(self.resultArray.count!=0) hasError:NO reloadButtonBlock:nil];
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
