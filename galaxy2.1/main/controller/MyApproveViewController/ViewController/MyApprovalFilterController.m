//
//  MyApprovalFilterController.m
//  galaxy
//
//  Created by hfk on 16/8/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyApprovalFilterController.h"
#define pageNum (Main_Screen_Height-NavigationbarHeight)/80+6
@interface MyApprovalFilterController ()<GPClientDelegate>
//0待审批 1已审批 2抄送给我  3待支付 4已支付  5单据查询  6支付进度筛选
@property (nonatomic,assign)NSInteger  approvalStatus;
@property (assign, nonatomic)NSInteger totalPage;//系统分页数
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)MyApproveViewCell *cell;
@property(nonatomic,strong)NSString *requestType;//区分viewwillapper是否请求数据
@property(nonatomic,strong)UIButton *leftBackBtn;

@end

@implementation MyApprovalFilterController
-(id)initWithType:(NSInteger)type{
    self=[super init];
    if (self) {
        self.approvalStatus=type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"筛选结果", nil) backButton:YES];
    _requestType=@"1";
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//MARK:操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (![_requestType isEqualToString:@"1"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        self.currPage=1;
        if (self.approvalStatus==0){
            [self requestWaitApproval];
        }else if (self.approvalStatus==1){
            [self requestHasApproval];
        }else if (self.approvalStatus==2){
            [self requestCCTOME];
        }else if (self.approvalStatus==3){
            [self requestWaitPay];
        }else if (self.approvalStatus==4){
            [self requestHasPay];
        }else if (self.approvalStatus==5){
            [self requestGetbudgetDocument];
        }else if (self.approvalStatus==6){
            [self requestPayProgress];
        }
    }
    _requestType=@"0";
}
//MARK:待审批数据处理
-(void)requestWaitApproval
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalWAITAPPROVAL];

    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"TaskName":@"",@"Requestor":_dict_Parameters[@"applyPeople"],@"FlowGuid":_dict_Parameters[@"flowGuid"],@"serialNo":_dict_Parameters[@"serialNo"],@"branchId":_dict_Parameters[@"branchId"],@"RequestorDept":_dict_Parameters[@"RequestorDept"]};
    //    NSLog(@"1111111111111%@",parameters);
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:审批完成
-(void)requestHasApproval
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalHASAPPROVAL];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"Requestor":_dict_Parameters[@"applyPeople"],@"Status":_dict_Parameters[@"status"],@"FlowGuid":_dict_Parameters[@"flowGuid"],@"RequestorFromDate":_dict_Parameters[@"startTime"],@"RequestorToDate":_dict_Parameters[@"endTime"],@"serialNo":_dict_Parameters[@"serialNo"],@"TaskName":_dict_Parameters[@"taskName"],@"branchId":_dict_Parameters[@"branchId"],@"FinishDateS":_dict_Parameters[@"finishDateS"],@"FinishDateE":_dict_Parameters[@"finishDateE"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:抄送给我
-(void)requestCCTOME
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",WorkapprovalCCTOME];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"Requestor":_dict_Parameters[@"applyPeople"],@"Status":_dict_Parameters[@"status"],@"FlowGuid":_dict_Parameters[@"flowGuid"],@"RequestorFromDate":_dict_Parameters[@"startTime"],@"RequestorToDate":_dict_Parameters[@"endTime"],@"serialNo":_dict_Parameters[@"serialNo"],@"TaskName":_dict_Parameters[@"taskName"]};//,@"branchId":_dict_Parameters[@"branchId"]
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:待支付数据
-(void)requestWaitPay{
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",approvalWAITPAY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"Requestor":_dict_Parameters[@"applyPeople"],@"FlowGuid":_dict_Parameters[@"flowGuid"],@"serialNo":_dict_Parameters[@"serialNo"],@"branchId":_dict_Parameters[@"branchId"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:已支付数据
-(void)requestHasPay{
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",approvalHASPAY];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"OrderBy":@"TaskId",@"IsAsc":@"desc",@"TaskName":@"",@"Requestor":_dict_Parameters[@"applyPeople"],@"Status":_dict_Parameters[@"status"],@"FlowGuid":_dict_Parameters[@"flowGuid"],@"RequestorFromDate":_dict_Parameters[@"startTime"],@"RequestorToDate":_dict_Parameters[@"endTime"],@"serialNo":_dict_Parameters[@"serialNo"],@"branchId":_dict_Parameters[@"branchId"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:单据查询
-(void)requestGetbudgetDocument{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.isLoading = YES;
    NSDictionary *dic =@{@"RequestorFromDate":_dict_Parameters[@"startTime"],@"RequestorToDate":_dict_Parameters[@"endTime"],@"StartAmount":_dict_Parameters[@"startAmount"],@"EndAmount":_dict_Parameters[@"endAmount"],@"Requestor":_dict_Parameters[@"applyPeople"],@"Status":_dict_Parameters[@"status"],@"OrderBy":@"RequestorDate",@"IsAsc":@"desc",@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"FlowCode":_dict_Parameters[@"flowCode"],@"SerialNo":_dict_Parameters[@"serialNo"],@"RequestorDeptId":_dict_Parameters[@"deptId"],@"RequestorDept":_dict_Parameters[@"dept"],@"TaskName":_dict_Parameters[@"taskName"]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",analyDocumentSearch_V2] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:支付进度
-(void)requestPayProgress{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    //修改下载的状态
    self.isLoading = YES;
    NSString *url=[NSString stringWithFormat:@"%@",PAYProgress];
    NSDictionary *parameters = @{@"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.currPage],@"PageSize":@15,@"Status":_dict_Parameters[@"status"]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:审批人是否能编辑页面
-(void)requestJudgeAppoverEdit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",ApproverEdit];
    NSDictionary *parameters = @{@"ProcId":[NSString stringWithFormat:@"%@",self.pushModel.procId],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId]};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
}
//MARK:判断是否有撤回
-(void)requestJudgeRecall{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...", nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",JudgeRecall];
    NSDictionary *parameters = @{@"FlowCode":[NSString stringWithFormat:@"%@",self.pushModel.flowCode],@"TaskId": [NSString stringWithFormat:@"%@",self.pushModel.taskId],@"RecallType":@"2"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:数据下载完成
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
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
    if (self.currPage ==1&&serialNum==0) {
        [self.resultArray removeAllObjects];
    }
    
    //    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    switch (serialNum) {
        case 0:
            [self dealWithData];
            [self createNOdataView];
            self.tableView.userInteractionEnabled=YES;
            //修改下载的状态
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
            break;
        case 2:
        {
            if (![_resultDict[@"result"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dict=_resultDict[@"result"];
                [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",dict[@"resultMessage"]] duration:2.0];
            }
        }
            break;
        case 3:
        {
            NSString *result=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_resultDict[@"result"]]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"]]:@"";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:result duration:2.0];
        }
            break;
        case 4:
            [self dealWithAppoverEdit:[NSString isEqualToNull:_resultDict[@"result"]]?[NSString stringWithFormat:@"%@",_resultDict[@"result"]]:@"0" WithStatus:self.approvalStatus == 3 ? 2:1];
            break;
        case 5:{
            NSDictionary *dict = @{@"type":@"2",
                                   @"hasCall":[[NSString stringWithFormat:@"%@",_resultDict[@"result"]]isEqualToString:@"1"] ? @"1":@"0"
                                   };
            [self dealWithReCallWithCall:dict];
        }
            break;
        default:
            break;
    }
}

//MARK:数据处理
-(void)dealWithData
{
    NSDictionary *result=_resultDict[@"result"];
    _totalPage=[result[@"totalPages"] integerValue] ;
    if (self.currPage<=_totalPage) {
        NSArray *array=result[@"items"];
        for (NSDictionary *dict in array) {
            if (_approvalStatus==6) {
                PayMentProModel *model=[[PayMentProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }else{
                MyApplyModel *model=[[MyApplyModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }
        }
    }else{
        NSArray *array=nil;
        for (NSDictionary *dict in array) {
            if (_approvalStatus==6) {
                PayMentProModel *model=[[PayMentProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }else{
                MyApplyModel *model=[[MyApplyModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.resultArray addObject:model];
            }
        }
    }
}
//MARK:数据请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    [self.resultArray removeAllObjects];
    self.isLoading=NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}
-(void)loadData{
    if (self.approvalStatus==0) {
        [self requestWaitApproval];
    }else if (self.approvalStatus==1){
        [self requestHasApproval];
    }else if (self.approvalStatus==2){
        [self requestCCTOME];
    }else if (self.approvalStatus==3){
        [self requestWaitPay];
    }else if (self.approvalStatus==4){
        [self requestHasPay];
    }else if (self.approvalStatus==5){
        [self requestGetbudgetDocument];
    }else if (self.approvalStatus==6){
        [self requestPayProgress];
    }
}
//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resultArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_approvalStatus==6) {
        return [PayMentProCell cellHeightWithObj:self.resultArray[indexPath.section]];
    }else{
        MyApplyModel *model=(MyApplyModel *)self.resultArray[indexPath.section];
        return  [MyApproveViewCell cellHeightWithObj:model];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_approvalStatus==6) {
        PayMentProCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PayMentProCell"];
        if (cell==nil) {
            cell=[[PayMentProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayMentProCell"];
        }
        cell.model=self.resultArray[indexPath.section];
        return cell;
    }else{
        _cell=[tableView dequeueReusableCellWithIdentifier:@"MyApproveViewCell"];
        if (_cell==nil) {
            _cell=[[MyApproveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyApproveViewCell"];
        }
        MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
        if (self.approvalStatus==0||self.approvalStatus==3||self.approvalStatus==4) {
            [_cell configViewNotApproveWithModel:model];
        }else if(self.approvalStatus==1||self.approvalStatus==2||self.approvalStatus==5){
            [_cell configViewHasApproveWithModel:model];
        }
        return _cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_approvalStatus==6) {
        PayMentProModel *model=self.resultArray[indexPath.section];
        [self dealWithPayWithModel:model];
    }else{
        self.pushModel=self.resultArray[indexPath.section];
        if (self.approvalStatus==0||self.approvalStatus==1||self.approvalStatus==2) {
            [self MyApproveSelect:self.pushModel WithIndex:self.approvalStatus];
        }else if (self.approvalStatus==3){
            [self MyPaySelect:self.pushModel WithIndex:0];
        }else if (self.approvalStatus==4){
            [self MyPaySelect:self.pushModel WithIndex:1];
        }else if (self.approvalStatus==5){
            [self MyApproveSelect:self.pushModel WithIndex:2];
        }
    }
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.approvalStatus==5) {
        return YES;
    }else{
        return NO;
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyApplyModel *model=(MyApplyModel  *)self.resultArray[indexPath.section];
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

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
    }
}

//MARK:支付处理
-(void)dealWithPayWithModel:(PayMentProModel *)model{
    NSString *status=[NSString stringWithFormat:@"%@",model.status];
    if ([status isEqualToString:@"0"]||[status isEqualToString:@"1"]||[status isEqualToString:@"2"]||[status isEqualToString:@"11"]||[status isEqualToString:@"12"]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url;
        if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"1"]) {
            url=[NSString stringWithFormat:@"%@",PAYQuerySingle];
        }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"2"]){
            url=[NSString stringWithFormat:@"%@",PAYQueryMulti];
        }else if ([[NSString stringWithFormat:@"%@",model.type] isEqualToString:@"3"]){
            url=[NSString stringWithFormat:@"%@",PAYQueryDisMulti];
        }
        NSDictionary *parameters = @{@"OrderSerialNo":[NSString stringWithFormat:@"%@",model.serialNo]};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    }else if ([status isEqualToString:@"3"]||[status isEqualToString:@"5"]||[status isEqualToString:@"6"]||[status isEqualToString:@"7"]||[status isEqualToString:@"8"]||[status isEqualToString:@"9"]||[status isEqualToString:@"10"]){
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",PAYAGAIN];
        NSDictionary *parameters = @{@"TaskId":[NSString stringWithFormat:@"%@",model.taskId]};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
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
