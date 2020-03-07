//
//  MyProcurementController.m
//  galaxy
//
//  Created by hfk on 16/4/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "MyProcurementController.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface MyProcurementController ()

@end

@implementation MyProcurementController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[MyProcureFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeStatus=[self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowCode];
    [self setTitle:dict[@"Title"] backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self getFormData];
}

-(void)createDealBtns{
    if (self.FormDatas.int_comeStatus==1||self.FormDatas.int_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf saveInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else if (self.FormDatas.int_comeStatus==3&&![self.FormDatas.str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf directInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf submitInfo];
            }
        };
    }
}

#pragma mark-创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
#pragma mark--创建主视图
-(void)createMainView{
    
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];

    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CostCenter=[[UIView alloc]init];
    _View_CostCenter.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CostCenter];
    [_View_CostCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project=[[UIView alloc]init];
    _View_Project.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostCenter.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier=[[UIView alloc]init];
    _View_Supplier.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_DetailsTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_DetailsTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_DetailsTable.delegate=self;
    _View_DetailsTable.dataSource=self;
    _View_DetailsTable.scrollEnabled=NO;
    _View_DetailsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails=[[UIView alloc]init];
    _View_AddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalMoney=[[UIView alloc]init];
    _View_TotalMoney.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalMoney];
    [_View_TotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayWay=[[UIView alloc]init];
    _View_PayWay.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayWay];
    [_View_PayWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalMoney.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayDate=[[UIView alloc]init];
    _View_PayDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayDate];
    [_View_PayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayWay.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
#pragma mark--网络部分
#pragma mark--第一次打开采购表单
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
#pragma mark--获取审批记录
-(void)requestApproveNote{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:7 IfUserCache:NO];
}

#pragma mark--请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    self.FormDatas.dict_resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            [self.FormDatas DealWithFormBaseData];
            if (self.FormDatas.int_comeStatus==3){
                [self requestApproveNote];
            }else{
                [self updateMainView];
                [self createDealBtns];
            }
        }
            break;
        case 1:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
            
        }
            break;
        case 3:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"result"]] forKey:@"TaskId"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goSubmitSuccessTo:) userInfo:dict repeats:NO];
        }
            break;
        case 7:
        {
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
        }
            break;
        case 10:
        {
            boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@",ip_web,[responceDic objectForKey:@"result"]]];
            bo.str_title = Custing(@"流程图", nil);
            [self.navigationController pushViewController:bo animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark---请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}

-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled=YES;
    NSString *goId=[[timer userInfo] objectForKey:@"TaskId"];
    if ([NSString isEqualToNull:goId]) {
        MyHasProcurementController *vc=[[MyHasProcurementController alloc]init];
        vc.FormDatas.str_taskId=goId;
        vc.FormDatas.str_procId=@"";
        vc.FormDatas.int_comeStatus=1;
        if (self.FormDatas.int_comeStatus==1) {
            vc.backIndex=@"0";
        }else{
            vc.backIndex=@"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark--视图更新
-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];

    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PurchaseType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CostCenterId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCostCenterViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_SupplierIdView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTotalMoneyViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PayMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayWayViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"DeliveryDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRemarkViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAttachImgViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:self.FormDatas.model_ApprovelPeoModel.fieldName];
                [self updateApproveViewWithModel:self.FormDatas.model_ApprovelPeoModel];
                [self.FormDatas.arr_UnShowmsArray removeObject:@"FirstHandlerUserName"];
            }
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCcPeopleViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }
    }
    if (self.FormDatas.bool_DetailsShow) {
        [self.FormDatas initProcureItemDate];
        [self.FormDatas.arr_UnShowmsArray removeObject:@"DetailList"];
        [self updateDetailsTableView];
        [self updateAddDetailsView];
    }
    
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    
    [self updateContentView];
    
    [self.FormDatas getEndShowArray];
}

#pragma mark--更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
#pragma mark--更新采购类型
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf TypeClick];
    }];
    [_View_Type addSubview:view];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_PurchaseType=model.fieldValue;
    }
}
#pragma mark--更新成本中心视图
-(void)updateCostCenterViewWithModel:(MyProcurementModel *)model{
    _txf_CostCenter=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CostCenter WithContent:_txf_CostCenter WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_CostCenter}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeCostCenter];
    }];
    [_View_CostCenter addSubview:view];
    
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_CostCenterId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}
#pragma mark--更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
    
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_ProjId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}

-(void)update_SupplierIdView:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_Supplier}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
    
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_SupplierId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}

#pragma mark--更新采购明细
-(void)updateDetailsTableView{
    [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_DetailsArray.count*42+27)*self.FormDatas.arr_DetailsDataArray.count));
    }];
    [_View_DetailsTable reloadData];
}
#pragma mark--更新采购增加按钮
-(void)updateAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_AddDetails withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf keyClose];
        DeatilsModel *model1=[[DeatilsModel alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
}
#pragma mark--更新采购合计金额
-(void)updateTotalMoneyViewWithModel:(MyProcurementModel *)model{
    _txf_TotalMoney=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalMoney WithContent:_txf_TotalMoney WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalMoney addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_TotalMoney=model.fieldValue;
    }
}
#pragma mark--更新采购支付方式
-(void)updatePayWayViewWithModel:(MyProcurementModel *)model{
    _txf_PayWay=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PayWay WithContent:_txf_PayWay WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf PayWayClick];
    }];
    [_View_PayWay addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_PayMode=model.fieldValue;
    }
}
#pragma mark--更新交付日期
-(void)updatePayDateViewWithModel:(MyProcurementModel *)model{
    _txf_PayDate=[[UITextField alloc]init];
    
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        model.fieldValue=currStr;
    }
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PayDate WithContent:_txf_PayDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PayDate addSubview:view];
}
#pragma mark--更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[[ReserverdMainView alloc]initArr:self.FormDatas.arr_FormMainArray isRequiredmsdic:self.FormDatas.dict_isRequiredmsdic reservedDic:self.FormDatas.dict_reservedDic UnShowmsArray:self.FormDatas.arr_UnShowmsArray view:_View_Reserved model:self.FormDatas.model_ReserverModel block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
#pragma mark--更新采购备注
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
#pragma mark--更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCont=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}

#pragma mark--审批记录
-(void)updateNotesTableView{
    __weak typeof(self) weakSelf = self;
    [_View_Note addSubview:[[FlowChartView alloc] init:self.FormDatas.arr_noteDateArray Y:10 HeightBlock:^(NSInteger height) {
        [weakSelf.View_Note addSubview:[weakSelf createLineView]];
        [weakSelf.View_Note updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height+10+15);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}
#pragma mark--更新采购审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_firstHanderPhotoGraph,@"value2":self.FormDatas.str_firstHandlerGender}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.View_ApproveImg=image;
        [self ApproveClick];
    }];
    [_View_Approve addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _txf_Approver.text=model.fieldValue;
        self.FormDatas.str_firstHanderName=model.fieldValue;
    }
}
#pragma mark--更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}

#pragma mark--更新报销政策视图
-(void)updateReimPolicyView{
    __weak typeof(self) weakSelf = self;
    ReimPolicyView *view=[[ReimPolicyView alloc]initWithFlowCode:self.FormDatas.str_flowCode withBodydict:self.FormDatas.dict_ReimPolicyDict withBaseViewHeight:^(NSInteger height, NSDictionary *date) {
        if ([date[@"location"]floatValue]==1) {
            [weakSelf.ReimPolicyDownView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }else{
            [weakSelf.ReimPolicyUpView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }
    }];
    view.clickBlock = ^(NSString *bodyUrl) {
        PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
        pdf.url =bodyUrl;
        [self.navigationController pushViewController:pdf animated:YES];
    };
    if ([self.FormDatas.dict_ReimPolicyDict[@"location"]floatValue]==1) {
        [_ReimPolicyDownView addSubview:view];
    }else{
        [_ReimPolicyUpView addSubview:view];
    }
}

#pragma mark--更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
}
#pragma mark--采购类型选择
-(void)TypeClick{
    NSLog(@"采购类型选择");
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"purchaseType"];
    choose.ChooseCategoryArray=self.FormDatas.arr_procureType;
    choose.ChooseCategoryId=self.FormDatas.str_PurchaseCode;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        if (array) {
            ChooseCategoryModel *model = array[0];
            weakSelf.FormDatas.str_PurchaseCode=[NSString stringWithFormat:@"%@",model.purchaseCode];
            weakSelf.FormDatas.str_PurchaseType=[NSString stringWithFormat:@"%@",model.purchaseType];
            weakSelf.txf_Type.text=[NSString stringWithFormat:@"%@",model.purchaseType];
        }else{
            weakSelf.FormDatas.str_PurchaseCode=@"";
            weakSelf.FormDatas.str_PurchaseType=@"";
            weakSelf.txf_Type.text=@"";
        }
    };
    [self.navigationController pushViewController:choose animated:YES];
}
#pragma mark--修改供应商
-(void)SupplierClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId=self.FormDatas.str_SupplierId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_SupplierId = model.Id;
        weakSelf.FormDatas.str_Supplier =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text =weakSelf.FormDatas.str_Supplier;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--选择支付方式
-(void)PayWayClick{
    NSLog(@"选择支付方式");
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"payWay"];
    choose.ChooseCategoryArray=self.FormDatas.arr_payWay;
    choose.ChooseCategoryId=self.FormDatas.str_PayCode;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        if (array) {
            ChooseCategoryModel *model = array[0];
            weakSelf.FormDatas.str_PayCode=[NSString stringWithFormat:@"%@",model.payCode];
            weakSelf.FormDatas.str_PayMode=[NSString stringWithFormat:@"%@",model.payMode];
            weakSelf.txf_PayWay.text=[NSString stringWithFormat:@"%@",model.payMode];
        }else{
            weakSelf.FormDatas.str_PayCode=@"";
            weakSelf.FormDatas.str_PayMode=@"";
            weakSelf.txf_PayWay.text=@"";
        } 
    };
    [self.navigationController pushViewController:choose animated:YES];
}
#pragma mark--修改成本中心
-(void)ChangeCostCenter{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
    vc.ChooseCategoryId=self.FormDatas.str_CostCenterId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_CostCenterId=model.Id;
        weakSelf.FormDatas.str_CostCenter=model.costCenter;
        weakSelf.txf_CostCenter.text=model.costCenter;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark--修改项目名称
-(void)ProjectClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId=self.FormDatas.str_ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_ProjId=model.Id;
        weakSelf.FormDatas.str_ProjName=[GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text=weakSelf.FormDatas.str_ProjName;
        weakSelf.FormDatas.str_ProjMgrId=model.projMgrUserId;
        weakSelf.FormDatas.str_ProjMgrName=model.projMgr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--审批人选择
-(void)ApproveClick{
    NSLog(@"审批人选择");
    [self keyClose];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_firstHanderId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople = array;
    contactVC.status = @"1";
    contactVC.menutype=3;
    contactVC.itemType =5;
    contactVC.Radio = @"1";
    contactVC.universalDelegate = self;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.txf_Approver.text=bul.requestor;
        self.FormDatas.str_firstHanderName=bul.requestor;
        self.FormDatas.str_firstHanderId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = [GPUtils transformToDictionaryFromString:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                self.FormDatas.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:self.FormDatas.str_firstHanderPhotoGraph]];
            }
        }else{
            if ([[NSString stringWithFormat:@"%d",bul.gender] isEqualToString:@"0"]) {
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Man"];
            }else{
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Woman"];
            }
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
#pragma mark--选择抄送人
-(void)CcPeopleClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_CcUsersId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.status = @"12";
    contactVC.isCleanSelf = YES;
    contactVC.arrClickPeople =array;
    contactVC.menutype=3;
    contactVC.itemType = 99;
    contactVC.Radio = @"2";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr=[NSMutableArray array];
        NSMutableArray *idArr=[NSMutableArray array];
        if (array.count>0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                }
            }
            weakSelf.FormDatas.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
            weakSelf.FormDatas.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            weakSelf.txf_CcToPeople.text=weakSelf.FormDatas.str_CcUsersName;
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}


#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.FormDatas.arr_DetailsDataArray.count;
}
// 返回参数2指定分组的行数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FormDatas.arr_DetailsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
    if (cell==nil) {
        cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
    }
    [cell configCellWithModel:self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
    
    cell.IndexPath=indexPath;
    [cell.NameTextField addTarget:self action:@selector(NametextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.NameTextField.tag=100+indexPath.section;
    cell.NameTextField.delegate = self;
    if (cell.NameBtn) {
        __weak typeof(self) weakSelf = self;
        [cell setNameCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
            [weakSelf keyClose];
            DeatilsModel *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
            if (!modelD) {
                DeatilsModel *modelD=[[DeatilsModel alloc]init];
                [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
            }
            ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"PurchaseItems"];
            vc.ChooseCategoryId=modelD.ItemId;
            vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                ChooseCateFreModel *model = array[0];
                modelD.ItemId = model.purId;
                modelD.ItemCatId = model.purItemCatId;
                modelD.ItemCatName = model.purItemCatName;
                modelD.Size = model.purSize;
                modelD.Name = [GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];
                modelD.Brand=model.purBrand;
                modelD.Unit = model.purUnit;
                [weakSelf.View_DetailsTable reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    [cell.BrandTextField addTarget:self action:@selector(BrandtextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.BrandTextField.tag=100+indexPath.section;
    cell.BrandTextField.delegate = self;

    [cell.SizeTextField addTarget:self action:@selector(SizetextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.SizeTextField.tag=100+indexPath.section;
    cell.SizeTextField.delegate = self;
    
    [cell.QtyTextField addTarget:self action:@selector(QtytextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.QtyTextField.tag=10000+indexPath.section;
    cell.QtyTextField.delegate = self;
    
    [cell.UnitTextField addTarget:self action:@selector(UnittextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.UnitTextField.tag=1+indexPath.section;
    cell.UnitTextField.delegate = self;
    
    [cell.AmountTF addTarget:self action:@selector(AmounttextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.AmountTF.tag=160+indexPath.section;
    cell.AmountTF.delegate = self;

    [cell.PriceTextField addTarget:self action:@selector(PricetextChange:) forControlEvents:UIControlEventEditingChanged];
    cell.PriceTextField.tag=1000+indexPath.section;
    cell.PriceTextField.delegate = self;
    
    [cell.RemarkTextField addTarget:self action:@selector(RemarkxtChange:) forControlEvents:UIControlEventEditingChanged];
    cell.RemarkTextField.tag=100+indexPath.section;
    cell.RemarkTextField.delegate = self;
    
    if (cell.SupplierBtn) {
        __weak typeof(self) weakSelf = self;
        [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
            [weakSelf keyClose];
            DeatilsModel *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
            if (!modelD) {
                DeatilsModel *modelD=[[DeatilsModel alloc]init];
                [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
            }
            ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
            vc.ChooseCategoryId=modelD.SupplierId;
            vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                ChooseCateFreModel *model = array[0];
                modelD.SupplierId = model.Id;
                modelD.SupplierName=[GPUtils getSelectResultWithArray:@[model.code,model.name]];
                tf.text =modelD.SupplierName;
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self createHeadViewWithSection:section];
    return _View_head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}
#pragma mark---textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ((textField.tag>=1000&&textField.tag<=1051)||(textField.tag>=160&&textField.tag<=210))  //判断是否时我们想要限定的那个输入框
    {
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
        
    }else if (textField.tag>=10000&&textField.tag<=10051){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        //        if ((match == 1||[string isEqualToString:@""])&&self.ExchangeChangedBlock) {
        //            self.ExchangeChangedBlock(toBeString);
        //        }
        return match!= 0;
    }else if (textField.tag>=1&&textField.tag<=51){
        if ([toBeString length] >10) { //如果输入框内容大于12
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
    }else if (textField.tag>=100&&textField.tag<=150){
        if ([toBeString length] >255) {
            textField.text = [toBeString substringToIndex:255];
            return NO;
        }
    }
    return YES;
}

#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _View_head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_head addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor blackColor];
    [_View_head addSubview:titleLabel];
    
    UILabel *lab_select=[GPUtils createLable:CGRectMake(Main_Screen_Width-12-150, 0, 150, 27) text:Custing(@"选择采购申请模板", nil) font:Font_Same_14_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
    __weak typeof(self) weakSelf = self;
    [lab_select bk_whenTapped:^{
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"PurchaseItemTpls"];
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            if (weakSelf.FormDatas.arr_DetailsDataArray.count==1) {
                DeatilsModel *model=weakSelf.FormDatas.arr_DetailsDataArray[0];
                if (model.Name==nil&&model.Size==nil&&model.Unit==nil&&model.Price==nil) {
                    [weakSelf.FormDatas.arr_DetailsDataArray removeAllObjects];
                }
            }
            for (ChooseCateFreModel *model in array) {
                DeatilsModel *modelD=[[DeatilsModel alloc]init];
                modelD.ItemId = model.purId;
                modelD.ItemCatId = model.purItemCatId;
                modelD.ItemCatName = model.purItemCatName;
                modelD.Size = model.purSize;
                modelD.Name = [GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];
                modelD.Brand=model.purBrand;
                modelD.Unit = model.purUnit;
                modelD.TplId=model.purTplId;
                modelD.TplName=model.purTplName;
                [weakSelf.FormDatas.arr_DetailsDataArray addObject:modelD];
            }
            [weakSelf updateDetailsTableView];
            [weakSelf.View_DetailsTable reloadData];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    lab_select.userInteractionEnabled=YES;
    lab_select.hidden=YES;
    [_View_head addSubview:lab_select];
    
    if (self.FormDatas.arr_DetailsDataArray.count==1) {
        titleLabel.text=Custing(@"采购明细", nil);
        if (self.FormDatas.bool_PurchaseTpl) {
            lab_select.hidden=NO;
        }
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购明细", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_View_head addSubview:deleteBtn];
        }else{
            if (self.FormDatas.bool_PurchaseTpl) {
                lab_select.hidden=NO;
            }
        }
    }
    _View_head.backgroundColor=Color_White_Same_20;
}

#pragma mark--采购明细详情填写
-(void)NametextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Name=text.text;
    }else{
        model.Name=text.text;
    }
}
-(void)BrandtextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Brand=text.text;
    }else{
        model.Brand=text.text;
    }
}
-(void)SizetextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Size=text.text;
    }else{
        model.Size=text.text;
    }
}
-(void)QtytextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-10000];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-10000];
        model.Qty=text.text;
    }else{
        model.Qty=text.text;
    }
    model.Price=[GPUtils decimalNumberMultipWithString:model.Qty with:model.Amount];
    [self.FormDatas getTotolAmount];
    [self.View_DetailsTable reloadData];
    NSInteger j=0;
    for (int i=0; i<self.FormDatas.arr_DetailsArray.count; i++) {
        MyProcurementModel *model=self.FormDatas.arr_DetailsArray[i];
        if ([model.fieldName isEqualToString:@"Qty"]) {
            j=i;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:text.tag-10000];
    DeatilsViewCell *cell = [self.View_DetailsTable cellForRowAtIndexPath:indexPath];
    [cell.QtyTextField becomeFirstResponder];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
}
-(void)UnittextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1];
        model.Unit=text.text;
    }else{
        model.Unit=text.text;
    }
}
-(void)AmounttextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-160];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-160];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
    model.Price=[GPUtils decimalNumberMultipWithString:model.Qty with:model.Amount];
    [self.FormDatas getTotolAmount];
    [self.View_DetailsTable reloadData];
    NSInteger j=0;
    for (int i=0; i<self.FormDatas.arr_DetailsArray.count; i++) {
        MyProcurementModel *model=self.FormDatas.arr_DetailsArray[i];
        if ([model.fieldName isEqualToString:@"Amount"]) {
            j=i;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:text.tag-160];
    DeatilsViewCell *cell = [self.View_DetailsTable cellForRowAtIndexPath:indexPath];
    [cell.AmountTF becomeFirstResponder];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
}
-(void)PricetextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Price=text.text;
    }else{
        model.Price=text.text;
    }
    [self.FormDatas getTotolAmount];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
}
-(void)RemarkxtChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Remark=text.text;
    }else{
        model.Remark=text.text;
    }
}
#pragma mark--删除明细
-(void)deleteDetails:(UIButton *)btn{
    
    [self keyClose];
    NSLog(@"删除明细");
    _Aler_deleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除采购明细", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    _Aler_deleteDetils.tag=btn.tag-1200;
    [_Aler_deleteDetils show];
    
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView==_Aler_deleteDetils) {
            [self.FormDatas.arr_DetailsDataArray removeObjectAtIndex:alertView.tag];
            [self.FormDatas getTotolAmount];
            [self.View_DetailsTable reloadData];
            _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
            [self updateDetailsTableView];
        }
    }
}


#pragma mark--保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"采购保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
    
}
#pragma mark--提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"采购提交操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
#pragma mark--直送操作
-(void)directInfo{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    [self mainDataList];
}
#pragma mark---提交保存数据处理
//拼接数据
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    if (self.FormDatas.int_SubmitSaveType==1) {
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }else if (self.FormDatas.int_SubmitSaveType==2||self.FormDatas.int_SubmitSaveType==3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:1.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }else{
            [self.FormDatas contectData];
            [self dealWithImagesArray];
        }
    }
}
-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason=_txv_Reason.text;
    self.FormDatas.SubmitData.DeliveryDate=_txf_PayDate.text;
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
}
#pragma mark--处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.FormDatas.str_imageDataString=data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf readySubmitAndSave];
        }
    }];
}

-(void)readySubmitAndSave{
    if (self.FormDatas.int_SubmitSaveType==1) {
        [self requestAppSave];
    }else if(self.FormDatas.int_SubmitSaveType==2){
        if (self.FormDatas.int_comeStatus==3) {
            [self requestAppbackSubmit];
        }else if (self.FormDatas.int_comeStatus==4){
            [self requestAppReCallSubmit];
        }else{
            [self requestAppSubmit];
        }
    }else if (self.FormDatas.int_SubmitSaveType ==3){
        [self requestDirect];
    }
}
#pragma mark--保存
-(void)requestAppSave
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
#pragma mark--提交
-(void)requestAppSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:[self.FormDatas SubmitFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
#pragma mark--退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:[self.FormDatas SubmitFormAgainWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
#pragma mark--直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
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
