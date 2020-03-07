//
//  FlowBaseViewController.m
//  galaxy
//
//  Created by hfk on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface FlowBaseViewController ()
@property(nonatomic,strong)NSString *type;
@end

@implementation FlowBaseViewController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        _type=type;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.resultArray = [NSMutableArray array];
    self.isLoading = NO;
    self.currPage = 1;
}

//创建表格
- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44);
        make.left.width.bottom.equalTo(self.view);
    }];
    self.tableView.backgroundColor=Color_White_Same_20;
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
   
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isLoading) {
            return;
        }
        weakSelf.currPage = 1;
        weakSelf.refreshStatus=@"1";
        [weakSelf loadData];
    }];
    _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currPage++;
        weakSelf.refreshStatus=@"2";
        [weakSelf loadData];
    }];
    if (![_type isEqualToString:@"0"]) {
        //        [self performBlock:^{
           [self.tableView.mj_header beginRefreshing];
        //        } afterDelay:0.3];
    }

   
    
    
}

-(void)loadData
{
    NSLog(@"子类必须实现方法%s",__FUNCTION__);
}

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)requestGetReCallProcId{


}
-(void)requestJudgeRecall{

}
-(void)requestJudgeAppoverEdit{
}

-(void)MyApplySelect:(MyApplyModel *)model WithIndex:(NSInteger)index{
    [self dealWithControllerWithStr:[NSString stringWithFormat:@"%@",model.flowCode]];
    if (index==0) {
        NSString *status=[NSString stringWithFormat:@"%@",self.pushModel.status];
        if ([status isEqualToString:@"6"]) {
            [self requestGetReCallProcId];
        }else if ([status isEqualToString:@"2"]){
            if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:self.pushModel.flowCode]) {
               
                NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:self.pushModel.flowGuid][@"Title"];
                NSDictionary *dict = @{@"flowGuid":self.pushModel.flowGuid,@"taskId":self.pushModel.taskId,@"procId":self.pushModel.procId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@3};
                RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],self.pushController,[[NSString transformToJsonWithOutEnter:dict] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                vc.str_flowCode = self.pushModel.flowCode;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                Class cls = NSClassFromString(self.pushController);
                UIViewController *vc = [[cls alloc] init];
                vc.pushTaskId = [NSString stringWithFormat:@"%@",self.pushModel.taskId];
                vc.pushProcId = [NSString stringWithFormat:@"%@",self.pushModel.procId];
                vc.pushUserId = [NSString stringWithFormat:@"%@",self.pushModel.requestorUserId];
                vc.pushExpenseCode = [NSString stringWithFormat:@"%@",self.pushModel.expenseCode];
                vc.pushComeStatus = @"3";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [self requestJudgeRecall];
        }
    }else if(index==1){
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:self.pushModel.flowCode]) {
            NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:self.pushModel.flowGuid][@"Title"];
            NSDictionary *dict = @{@"flowGuid":self.pushModel.flowGuid,@"taskId":self.pushModel.taskId,@"procId":self.pushModel.procId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@2};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],self.pushController,[[NSString transformToJsonWithOutEnter:dict] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = self.pushModel.flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            Class cls = NSClassFromString(self.pushController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId = [NSString stringWithFormat:@"%@",self.pushModel.taskId];
            vc.pushProcId = [NSString stringWithFormat:@"%@",self.pushModel.procId];
            vc.pushUserId = [NSString stringWithFormat:@"%@",self.pushModel.requestorUserId];
            //        vc.pushFlowGuid = [NSString stringWithFormat:@"%@",self.pushModel.flowGuid];
            vc.pushExpenseCode = [NSString stringWithFormat:@"%@",self.pushModel.expenseCode];
            vc.pushComeStatus = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)dealWithReCallWithCall:(NSDictionary *)dict{
    if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:self.pushModel.flowCode]) {
        NSNumber *pageType = @1;
        NSNumber *canUrge = @0;
        if ([dict[@"type"]floatValue] == 1) {
            if ([dict[@"hasCall"] floatValue] == 1&&[dict[@"canUrge"]floatValue] == 1) {
                pageType = @2;
                canUrge = @1;
            }else if ([dict[@"hasCall"] floatValue] == 1&&[dict[@"canUrge"]floatValue] != 1){
                pageType = @2;
                canUrge = @0;
            }else if ([dict[@"hasCall"] floatValue] != 1&&[dict[@"canUrge"]floatValue] == 1){
                pageType = @1;
                canUrge = @1;
            }else{
                pageType = @1;
                canUrge = @0;
            }
        }else{
            if ([dict[@"hasCall"] floatValue] == 1) {
                pageType = @5;
                canUrge = @0;
            }else{
                pageType = @1;
                canUrge = @0;
            }
        }
        NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:self.pushModel.flowGuid][@"Title"];
        NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"rowData":@{@"taskId":self.pushModel.taskId,@"procId":self.pushModel.procId,@"flowGuid":self.pushModel.flowGuid,@"flowCode":self.pushModel.flowCode,@"pageType":pageType,@"canUrge":canUrge}};

        RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        vc.str_flowCode = self.pushModel.flowCode;
        [self.navigationController pushViewController:vc animated:YES];        
    }else{
        Class cls = NSClassFromString(self.pushHasController);
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId = [NSString stringWithFormat:@"%@",self.pushModel.taskId];
        vc.pushProcId = [NSString stringWithFormat:@"%@",self.pushModel.procId];
        vc.pushUserId = [NSString stringWithFormat:@"%@",self.pushModel.requestorUserId];
        vc.pushFlowCode = [NSString stringWithFormat:@"%@",self.pushModel.flowCode];
        vc.pushExpenseCode = [NSString stringWithFormat:@"%@",self.pushModel.expenseCode];
        //    vc.pushFlowGuid = [NSString stringWithFormat:@"%@",self.pushModel.flowGuid];
        if ([dict[@"type"]floatValue] == 1) {
            if ([dict[@"hasCall"] floatValue] == 1&&[dict[@"canUrge"]floatValue] == 1) {
                vc.pushComeStatus = @"8";
            }else if ([dict[@"hasCall"] floatValue] == 1&&[dict[@"canUrge"]floatValue] != 1){
                vc.pushComeStatus = @"2";
            }else if ([dict[@"hasCall"] floatValue] != 1&&[dict[@"canUrge"]floatValue] == 1){
                vc.pushComeStatus = @"9";
            }else{
                vc.pushComeStatus = @"1";
            }
        }else{
            vc.pushComeStatus = [dict[@"hasCall"] floatValue] == 1 ? @"7":@"5";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)dealWithHasReCalled{
    if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:self.pushModel.flowCode]) {
        NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:self.pushModel.flowGuid][@"Title"];
        NSDictionary *dict1 = @{@"flowGuid":self.pushModel.flowGuid,@"taskId":self.pushModel.taskId,@"procId":self.pushModel.procId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@4};
        RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],self.pushController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        vc.str_flowCode = self.pushModel.flowCode;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        Class cls = NSClassFromString(self.pushController);
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId = [NSString stringWithFormat:@"%@",self.pushModel.taskId];
        vc.pushProcId = [NSString stringWithFormat:@"%@",self.pushModel.procId];
        vc.pushUserId = [NSString stringWithFormat:@"%@",self.pushModel.requestorUserId];
        vc.pushExpenseCode = [NSString stringWithFormat:@"%@",self.pushModel.expenseCode];
        //    vc.pushFlowGuid = [NSString stringWithFormat:@"%@",self.pushModel.flowGuid];
        vc.pushComeStatus = @"4";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)MyApproveSelect:(MyApplyModel *)model WithIndex:(NSInteger)index{
    //index 0待审批 1已审批
    [self dealWithControllerWithStr:[NSString stringWithFormat:@"%@",model.flowCode]];
    if (index==0) {
        [self requestJudgeAppoverEdit];
    }else if (index==1){
        [self requestJudgeRecall];
    }else{
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:model.flowCode]) {
            NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:model.flowGuid][@"Title"];
            NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"rowData":@{@"taskId":model.taskId,@"procId":model.procId,@"flowGuid":model.flowGuid,@"flowCode":model.flowCode,@"pageType":@1,@"canUrge":@0}};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = model.flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            Class cls = NSClassFromString(self.pushHasController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId = [NSString stringWithFormat:@"%@",model.taskId];
            vc.pushProcId = [NSString stringWithFormat:@"%@",model.procId];
            vc.pushFlowCode = [NSString stringWithFormat:@"%@",model.flowCode];
            vc.pushUserId = [NSString stringWithFormat:@"%@",model.requestorUserId];
            //        vc.pushFlowGuid = [NSString stringWithFormat:@"%@",model.flowGuid];
            vc.pushExpenseCode = [NSString stringWithFormat:@"%@",model.expenseCode];
            vc.pushComeStatus = @"5";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)MyPaySelect:(MyApplyModel *)model WithIndex:(NSInteger)index{
    [self dealWithControllerWithStr:[NSString stringWithFormat:@"%@",model.flowCode]];
    if (index==0) {
        [self requestJudgeAppoverEdit];
    }else{
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:model.flowCode]) {
            NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:model.flowGuid][@"Title"];
            NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"rowData":@{@"taskId":model.taskId,@"procId":model.procId,@"flowGuid":model.flowGuid,@"flowCode":model.flowCode,@"pageType":@1,@"canUrge":@0}};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = model.flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            Class cls = NSClassFromString(self.pushHasController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId = [NSString stringWithFormat:@"%@",model.taskId];
            vc.pushProcId = [NSString stringWithFormat:@"%@",model.procId];
            vc.pushFlowCode = [NSString stringWithFormat:@"%@",model.flowCode];
            vc.pushUserId = [NSString stringWithFormat:@"%@",model.requestorUserId];
            //        vc.pushFlowGuid = [NSString stringWithFormat:@"%@",model.flowGuid];
            vc.pushExpenseCode = [NSString stringWithFormat:@"%@",model.expenseCode];
            vc.pushComeStatus=@"6";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)MyApproveRemind:(NSDictionary *)dict{

    NSString* status=[NSString stringWithFormat:@"%@",dict[@"status"]];
    NSString* flowCode=[NSString stringWithFormat:@"%@",dict[@"flowCode"]];
    NSString* taskId=[NSString stringWithFormat:@"%@",dict[@"taskId"]];
    NSString* procId=[NSString stringWithFormat:@"%@",dict[@"procId"]];
    NSString* userId=[NSString stringWithFormat:@"%@",dict[@"userId"]];
    NSString* flowGuid=[NSString stringWithFormat:@"%@",dict[@"flowGuid"]];
    NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:flowGuid][@"Title"];
    [self dealWithControllerWithStr:flowCode];
    if ([status isEqualToString:@"1"]||[status isEqualToString:@"100"]) {
        [self requestJudgeAppoverEdit];
    }else if ([status isEqualToString:@"2"]){
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
            NSDictionary *dict1 = @{@"flowGuid":flowGuid,@"taskId":taskId,@"procId":procId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"pageType":@3};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5New],self.pushController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = flowCode;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            Class cls = NSClassFromString(self.pushController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId=taskId;
            vc.pushProcId=procId;
            vc.pushFlowCode=flowCode;
            vc.pushUserId=userId;
            vc.pushComeStatus=@"3";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([status isEqualToString:@"6"]){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"已被撤回" duration:1.0];
        return;
    }else{
        if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:flowCode]) {
            NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"rowData":@{@"taskId":taskId,@"procId":procId,@"flowGuid":flowGuid,@"flowCode":flowCode,@"pageType":@1,@"canUrge":@0}};
            RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
            vc.str_flowCode = flowCode;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            Class cls = NSClassFromString(self.pushHasController);
            UIViewController *vc = [[cls alloc] init];
            vc.pushTaskId=taskId;
            vc.pushProcId=procId;
            vc.pushFlowCode=flowCode;
            vc.pushUserId=userId;
            vc.pushComeStatus=@"5";
            //        vc.pushCall=@"0";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)dealWithAppoverEdit:(NSString *)comeEditType WithStatus:(NSInteger)ApprovePay{
    if ([[VoiceDataManger sharedManager]isH5FlowFormWithFlowCode:self.pushModel.flowCode]) {
        NSDictionary *flowName = [VoiceDataManger getFlowShowInfo:self.pushModel.flowGuid][@"Title"];
        NSDictionary *dict1 = @{@"cid":self.userdatas.companyId,@"token":self.userdatas.token,@"flowName":flowName,@"userId":self.userdatas.userId,@"rowData":@{@"taskId":self.pushModel.taskId,@"procId":self.pushModel.procId,@"flowGuid":self.pushModel.flowGuid,@"flowCode":self.pushModel.flowCode,@"pageType":ApprovePay == 1 ? @3:@4,@"canUrge":@0,@"isEditType":[NSNumber numberWithInteger:[comeEditType integerValue]]}};
        RootFlowWebViewController *vc = [[RootFlowWebViewController alloc]initWithUrl:[NSString stringWithFormat:@"%@%@%@",[UrlKeyManager getFormH5URL:XB_FormH5Has],self.pushHasController,[[NSString transformToJsonWithOutEnter:dict1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        vc.str_flowCode = self.pushModel.flowCode;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        Class cls;
        if ([comeEditType floatValue] >= 1 && [comeEditType floatValue] <= 7) {
            cls = NSClassFromString(self.pushAppoverEditController);
        }else{
            cls = NSClassFromString(self.pushHasController);
        }
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId=[NSString stringWithFormat:@"%@",self.pushModel.taskId];
        vc.pushProcId=[NSString stringWithFormat:@"%@",self.pushModel.procId];
        vc.pushFlowCode=[NSString stringWithFormat:@"%@",self.pushModel.flowCode];
        vc.pushUserId=[NSString stringWithFormat:@"%@",self.pushModel.requestorUserId];
        //    vc.pushFlowGuid=[NSString stringWithFormat:@"%@",self.pushModel.flowGuid];
        vc.pushExpenseCode=[NSString stringWithFormat:@"%@",self.pushModel.expenseCode];
        vc.pushComeEditType=comeEditType;
        vc.pushComeStatus=ApprovePay==1?@"3":@"4";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)dealWithControllerWithStr:(NSString *)str{
   NSDictionary *dict=[[VoiceDataManger sharedManager]getControllerNameWithFlowCode:str];
    self.pushController=dict[@"pushController"];
    self.pushHasController=dict[@"pushHasController"];
    self.pushAppoverEditController=dict[@"pushAppoverEditController"];
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
