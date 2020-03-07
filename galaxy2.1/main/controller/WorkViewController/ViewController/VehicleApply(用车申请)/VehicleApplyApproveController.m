//
//  VehicleApplyApproveController.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VehicleApplyApproveController.h"
#import "ChooseVehicleCarController.h"

@interface VehicleApplyApproveController ()

@end

@implementation VehicleApplyApproveController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[VehicleApplyFormData alloc]initWithStatus:3];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_flowCode=self.pushFlowCode;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeStatus=[self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    if (self.pushFlowGuid) {
        self.FormDatas.str_flowGuid = self.pushFlowGuid;
    }
    [self setTitle:nil backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self requestHasApp];
}

-(void)createDealBtns{
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==7) {
        [self createReCallBtn];
    }else if (self.FormDatas.int_comeStatus==3){
        [self saveAndSubmitBtn];
    }
}
//MARK:待审批按钮
-(void)saveAndSubmitBtn{
    if ([self.FormDatas.str_canEndorse isEqualToString:@"1"]) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf dockViewClick:1];
            }else if (index==1){
                [weakSelf dockViewClick:0];
            }else if (index==2){
                [weakSelf dockViewClick:2];
            }
        };
    }else{
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf dockViewClick:0];
            }else if (index==1){
                [weakSelf dockViewClick:2];
            }
        };
    }
}
//MARK:撤回按钮
-(void)createReCallBtn{
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf reCallBack:nil];
        }
    };
}
//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==7) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(@-50);
        }];
        
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }else{
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

//MARK:创建主视图
-(void)createMainView{

    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
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
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DepartCity=[[UIView alloc]init];
    _View_DepartCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DepartCity];
    [_View_DepartCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BackCity=[[UIView alloc]init];
    _View_BackCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackCity];
    [_View_BackCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DepartCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_VehicleDate=[[UIView alloc]init];
    _View_VehicleDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_VehicleDate];
    [_View_VehicleDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BackDate=[[UIView alloc]init];
    _View_BackDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackDate];
    [_View_BackDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VehicleStaff=[[UIView alloc]init];
    _View_VehicleStaff.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_VehicleStaff];
    [_View_VehicleStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InitialMileage=[[UIView alloc]init];
    _View_InitialMileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_InitialMileage];
    [_View_InitialMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleStaff.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_EndMileage=[[UIView alloc]init];
    _View_EndMileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_EndMileage];
    [_View_EndMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InitialMileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Mileage=[[UIView alloc]init];
    _View_Mileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Mileage];
    [_View_Mileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndMileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PteCarAllowance=[[UIView alloc]init];
    _View_PteCarAllowance.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_PteCarAllowance];
    [_View_PteCarAllowance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Mileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FuelBills=[[UIView alloc]init];
    _View_FuelBills.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_FuelBills];
    [_View_FuelBills mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PteCarAllowance.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Pontage=[[UIView alloc]init];
    _View_Pontage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Pontage];
    [_View_Pontage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FuelBills.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ParkingFee=[[UIView alloc]init];
    _View_ParkingFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ParkingFee];
    [_View_ParkingFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Pontage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherFee=[[UIView alloc]init];
    _View_OtherFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OtherFee];
    [_View_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ParkingFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalBudget=[[UIView alloc]init];
    _View_TotalBudget.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TotalBudget];
    [_View_TotalBudget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsPassNight=[[UIView alloc]init];
    _View_IsPassNight.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_IsPassNight];
    [_View_IsPassNight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalBudget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelForm= [[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0001"];;
    _View_TravelForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelForm];
    [_View_TravelForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsPassNight.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CarNo=[[UIView alloc]init];
    _View_CarNo.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CarNo];
    [_View_CarNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Driver=[[UIView alloc]init];
    _View_Driver.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Driver];
    [_View_Driver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CarNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DriverTel=[[UIView alloc]init];
    _View_DriverTel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DriverTel];
    [_View_DriverTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Driver.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Entourage=[[UIView alloc]init];
    _View_Entourage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Entourage];
    [_View_Entourage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DriverTel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_DispatcherReview=[[UIView alloc]init];
    _View_DispatcherReview.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DispatcherReview];
    [_View_DispatcherReview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Entourage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DispatcherReview.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
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
}

//MARK:-网络请求
//MARK:第一次打开表单和保存后打开表单接口
-(void)requestHasApp
{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:审批记录
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:11 IfUserCache:NO];
}
//MARK:打印链接
-(void)GoToPush{
    self.PrintfBtn.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas PrintLinkUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"====%@",responceDic);
    self.FormDatas.dict_resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        self.dockView.userInteractionEnabled=YES;
        self.PrintfBtn.userInteractionEnabled=YES;
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"resultCode"]] isEqualToString:@"1001"]) {
            [self updateAprovalProcess:self.FormDatas.str_flowGuid WithProcId:[NSString stringWithFormat:@"%@",responceDic[@"procId"]]];
        }else{
            NSString * error = [responceDic objectForKey:@"msg"];
            if (![error isKindOfClass:[NSNull class]]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            }
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self.FormDatas DealWithFormBaseData];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            [self requestApproveNote];
        }
            break;
        case 2:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            if ([NSString isEqualToNull:successRespone]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"撤回成功", nil)];
            }
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goToReSubmit) userInfo:nil repeats:NO];
        }
            break;
        case 3:
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
            break;
        case 10:
        {
            self.PrintfBtn.userInteractionEnabled=YES;
            NSDictionary *dict=self.FormDatas.dict_resultDict[@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                     @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                     @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                     @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                     @"flowCode":self.FormDatas.str_flowCode,
                                                                     @"requestor":self.FormDatas.personalData.Requestor
                                                                     }]];
                
            }
        }
            break;
        case 11:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        default:
            break;
    }
    
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    self.PrintfBtn.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:撤回跳到重新提交
-(void)goToReSubmit{
    self.dockView.userInteractionEnabled=YES;
    [self goToReSubmitWithModel:self.FormDatas];
}

//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];

    [_FormRelatedView initFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithBaseModel:self.FormDatas Withcontroller:self];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleType"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateVehicleTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DepartCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateDepartCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BackCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateBackCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateVehicleDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BackDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateBackDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleStaffId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateVehicleStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InitialMileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInitialMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EndMileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEndMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Mileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PteCarAllowance"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updatePteCarAllowanceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FuelBills"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateFuelBillsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Pontage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updatePontageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ParkingFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateParkingFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OtherFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateOtherFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalBudget"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTotalBudgetViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsPassNight"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateIsPassNightViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTravelFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CarNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCarNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Driver"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateDriverViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DriverTel"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateDriverTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Entourage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEntourageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DispatcherReview"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateDispatcherReviewViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    //MARK:私车公用补贴是否显示
    [self updatePteCarAllowanceViewHeight];
    [self updateContentView];
}
//MARK:原因
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Reason addSubview:view];
}
//MARK:更新类型
-(void)updateVehicleTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf TypeClick];
    }];
    [_View_Type addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_Type = model.fieldValue;
    }
}
//MARK:更新出发地
-(void)updateDepartCityViewWithModel:(MyProcurementModel *)model{
    _txf_DepartCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DepartCity WithContent:_txf_DepartCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DepartCity addSubview:view];
}
//MARK:更新目的地
-(void)updateBackCityViewWithModel:(MyProcurementModel *)model{
    _txf_BackCity=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackCity WithContent:_txf_BackCity WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BackCity addSubview:view];
}
//MARK:更新出发时间
-(void)updateVehicleDateViewWithModel:(MyProcurementModel *)model{
    _txf_VehicleDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_VehicleDate WithContent:_txf_VehicleDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_VehicleDate addSubview:view];
}
//MARK:更新返回时间
-(void)updateBackDateViewWithModel:(MyProcurementModel *)model{
    _txf_BackDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BackDate WithContent:_txf_BackDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BackDate addSubview:view];
}
//MARK:更新同车人员
-(void)updateVehicleStaffViewWithModel:(MyProcurementModel *)model{
    _txf_VehicleStaff = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_VehicleStaff WithContent:_txf_VehicleStaff WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_VehicleStaff}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        NSMutableArray *array = [NSMutableArray array];
        NSArray *idarr = [weakSelf.FormDatas.str_VehicleStaffId componentsSeparatedByString:@","];
        for (int i = 0 ; i<idarr.count ; i++) {
            NSDictionary *dic = @{@"requestorUserId":idarr[i]};
            [array addObject:dic];
        }
        contactVC.arrClickPeople =array;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio = @"2";
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
            }
            weakSelf.FormDatas.str_VehicleStaffId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
            weakSelf.FormDatas.str_VehicleStaff=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            weakSelf.txf_VehicleStaff.text=weakSelf.FormDatas.str_VehicleStaff;
        }];
        [self.navigationController pushViewController:contactVC animated:YES];
    }];
    [_View_VehicleStaff addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_VehicleStaffId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}

//MARK:起始里程
-(void)updateInitialMileageViewWithModel:(MyProcurementModel *)model{
    _txf_InitialMileage=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InitialMileage WithContent:_txf_InitialMileage WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_InitialMileage.keyboardType =UIKeyboardTypeDecimalPad;
    [_View_InitialMileage addSubview:view];
}
//MARK:预计结束里程
-(void)updateEndMileageViewWithModel:(MyProcurementModel *)model{
    _txf_EndMileage=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndMileage WithContent:_txf_EndMileage WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_EndMileage.keyboardType =UIKeyboardTypeDecimalPad;
    __weak typeof(self) weakSelf = self;
    [view setTextChangedBlock:^(NSString *text) {
        [weakSelf getPteCarAllowance];
    }];
    [_View_EndMileage addSubview:view];
}
//MARK:实际里程
-(void)updateMileageViewWithModel:(MyProcurementModel *)model{
    _txf_Mileage=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Mileage WithContent:_txf_Mileage WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_Mileage.keyboardType =UIKeyboardTypeDecimalPad;
    [_View_Mileage addSubview:view];
}
//MARK:私车公用补贴
-(void)updatePteCarAllowanceViewWithModel:(MyProcurementModel *)model{
    _txf_PteCarAllowance=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PteCarAllowance WithContent:_txf_PteCarAllowance WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PteCarAllowance addSubview:view];
}
//MARK:私车公用补贴显示
-(void)updatePteCarAllowanceViewHeight{
    [_View_PteCarAllowance updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(([self.FormDatas.str_TypeFlag isEqualToString:@"1"]&&self.txf_PteCarAllowance)?@60:@0);
    }];
}

-(void)getPteCarAllowance{
    
    if (([self.FormDatas.str_TypeFlag isEqualToString:@"1"]&&self.txf_PteCarAllowance)>0&&self.FormDatas.dict_stdSelfDrive) {
        if ([NSString isEqualToNull:_txf_EndMileage.text]) {
            if ([NSString isEqualToNullAndZero:self.FormDatas.dict_stdSelfDrive[@"amount"]]) {
                _txf_PteCarAllowance.text = [NSString stringWithFormat:@"%@",self.FormDatas.dict_stdSelfDrive[@"amount"]];
            }else{
                if ([self.FormDatas.dict_stdSelfDrive[@"stdSelfDriveDtoList"]isKindOfClass:[NSArray class]]) {
                    NSArray *arr = self.FormDatas.dict_stdSelfDrive[@"stdSelfDriveDtoList"];
                    if (arr.count>0) {
                        NSString *returnAmount = nil;
                        for (int i = 0; i<arr.count; i++) {
                            NSDictionary *dic = arr[i];
                            if ([[GPUtils decimalNumberSubWithString:_txf_EndMileage.text with:dic[@"mileageFrom"]]floatValue]>0&&[[GPUtils decimalNumberSubWithString:dic[@"mileageTo"] with:_txf_EndMileage.text]floatValue]>=0) {
                                returnAmount = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                            }
                        }
                        if (returnAmount) {
                            _txf_PteCarAllowance.text = returnAmount;
                        }else{
                            NSDictionary *dict = arr.lastObject;
                            _txf_PteCarAllowance.text = [NSString stringWithFormat:@"%@",dict[@"amount"]];
                        }
                    }
                }
            }
        }else{
            if ([NSString isEqualToNullAndZero:self.FormDatas.dict_stdSelfDrive[@"amount"]]) {
                _txf_PteCarAllowance.text = [NSString stringWithFormat:@"%@",self.FormDatas.dict_stdSelfDrive[@"amount"]];
            }else{
                if ([self.FormDatas.dict_stdSelfDrive[@"stdSelfDriveDtoList"]isKindOfClass:[NSArray class]]) {
                    NSArray *arr = self.FormDatas.dict_stdSelfDrive[@"stdSelfDriveDtoList"];
                    if (arr.count>0) {
                        NSDictionary *dict = arr[0];
                        _txf_PteCarAllowance.text = [NSString stringWithFormat:@"%@",dict[@"amount"]];
                    }
                }
            }
        }
    }
}

//MARK:燃油费
-(void)updateFuelBillsViewWithModel:(MyProcurementModel *)model{
    _txf_FuelBills=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FuelBills WithContent:_txf_FuelBills WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_FuelBills addSubview:view];
}
//MARK:路桥费
-(void)updatePontageViewWithModel:(MyProcurementModel *)model{
    _txf_Pontage=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Pontage WithContent:_txf_Pontage WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_Pontage addSubview:view];
}
//MARK:停车费
-(void)updateParkingFeeViewWithModel:(MyProcurementModel *)model{
    _txf_ParkingFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ParkingFee WithContent:_txf_ParkingFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_ParkingFee addSubview:view];
}
//MARK:其他费用
-(void)updateOtherFeeViewWithModel:(MyProcurementModel *)model{
    _txf_OtherFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OtherFee WithContent:_txf_OtherFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_OtherFee addSubview:view];
}
//MARK:合计
-(void)updateTotalBudgetViewWithModel:(MyProcurementModel *)model{
    _txf_TotalBudget=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalBudget WithContent:_txf_TotalBudget WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalBudget addSubview:view];
}
//MARK:合计预算金额计算
-(void)getTotalBudgetAmount{
    NSString *totol = @"0";
    totol = [GPUtils decimalNumberAddWithString:self.txf_FuelBills.text with:self.txf_Pontage.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_ParkingFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_OtherFee.text];
    self.txf_TotalBudget.text = totol;
}

//MARK:更新是否用车视图
-(void)updateIsPassNightViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        self.FormDatas.str_IsPassNight = @"1";
        model.fieldValue=Custing(@"是", nil);
    }else{
        self.FormDatas.str_IsPassNight = @"0";
        model.fieldValue=Custing(@"否", nil);
    }
    _txf_IsPassNight=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsPassNight WithContent:_txf_IsPassNight WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf isPassNight];
    }];
    [_View_IsPassNight addSubview:view];
}

//MARK:更新出差申请单视图
-(void)updateTravelFormViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo],
                           @"Model":model
                           };
    [_View_TravelForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_TravelForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        if (status == 1) {
            [weakSelf travelNumberClick];
        }else{
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
        }
    };
}
//MARK:更新车辆视图
-(void)updateCarNoViewWithModel:(MyProcurementModel *)model{
    _txf_CarNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CarNo WithContent:_txf_CarNo WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CarSelect];
    }];
    [_View_CarNo addSubview:view];
}
//MARK:更新司机
-(void)updateDriverViewWithModel:(MyProcurementModel *)model{
    _txf_Driver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Driver WithContent:_txf_Driver WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Driver addSubview:view];
}
//MARK:更新司机
-(void)updateDriverTelViewWithModel:(MyProcurementModel *)model{
    _txf_DriverTel=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DriverTel WithContent:_txf_DriverTel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DriverTel addSubview:view];
}

//MARK:同行人员
-(void)updateEntourageViewWithModel:(MyProcurementModel *)model{
    _txf_Entourage = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Entourage WithContent:_txf_Entourage WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf EntourageClick];
    }];
    [_View_Entourage addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_Entourage=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}

//MARK:更新车辆评价
-(void)updateDispatcherReviewViewWithModel:(MyProcurementModel *)model{
    _txf_DispatcherReview=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DispatcherReview WithContent:_txf_DispatcherReview WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DispatcherReview addSubview:view];
}

//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[[ReserverdMainView alloc]initArr:self.FormDatas.arr_FormMainArray isRequiredmsdic:self.FormDatas.dict_isRequiredmsdic reservedDic:self.FormDatas.dict_reservedDic UnShowmsArray:self.FormDatas.arr_UnShowmsArray view:_View_Reserved model:self.FormDatas.model_ReserverModel block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view = [[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount = 5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}

//MARK:审批记录
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

//MARK:更新采购审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    model.Description=Custing(@"审批人", nil);
    model.fieldValue=@"";
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.View_ApproveImg=image;
        [self SecondApproveClick];
    }];
    [_View_Approve addSubview:view];
}


//MARK:更新底层视图
-(void)updateContentView{
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Approve.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}

//MARK:修改类型
-(void)TypeClick{
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"VehicleTyp"];
    choose.ChooseCategoryArray=nil;
    choose.ChooseCategoryId=self.FormDatas.str_TypeId;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.FormDatas.str_Type = model.name;
        weakSelf.FormDatas.str_TypeId = model.Id;
        weakSelf.FormDatas.str_TypeFlag = model.type;
        weakSelf.txf_Type.text = weakSelf.FormDatas.str_Type;
        [weakSelf updatePteCarAllowanceViewHeight];
        [weakSelf getPteCarAllowance];
    };
    [self.navigationController pushViewController:choose animated:YES];
}
//MARK:修改是否过夜
-(void)isPassNight{
    __weak typeof(self) weakSelf = self;
    STOnePickView *picker = [[STOnePickView alloc]init];
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_IsPassNight=Model.Id;
        weakSelf.txf_IsPassNight.text=Model.Type;
    }];
    picker.typeTitle=Custing(@"是否在外过夜", nil);
    picker.DateSourceArray=weakSelf.FormDatas.arr_IsOrNot;
    STOnePickModel *model1=[[STOnePickModel alloc]init];
    model1.Id=weakSelf.FormDatas.str_IsPassNight;
    picker.Model=model1;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:修改出差申请单
-(void)travelNumberClick{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"travelForm"];
    vc.ChooseCategoryId=weakSelf.FormDatas.str_travelFormId;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":self.FormDatas.str_TravelStatus,
                     @"UserId":self.FormDatas.personalData.RequestorUserId,
                     @"FlowGuid":self.FormDatas.str_flowGuid};
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_travelFormInfo=[GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_travelFormId=[GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo]                               };
        [weakSelf.View_TravelForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改车辆
-(void)CarSelect{
    ChooseVehicleCarController *vc =[[ChooseVehicleCarController alloc]init];
    vc.bool_HasManager = YES;
    vc.str_taskId = self.FormDatas.str_taskId;
    __weak typeof(self) weakSelf = self;
    vc.chooseCarBlock = ^(NSDictionary *dict) {
        weakSelf.FormDatas.str_CarDes = [NSString stringWithIdOnNO:dict[@"carDesc"]];
        weakSelf.txf_CarNo.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"carNo"]],[NSString stringWithFormat:@"%@",dict[@"carModel"]]] WithCompare:@"/"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改同行人员
-(void)EntourageClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"3";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_EntourageId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople =array;
    contactVC.menutype=2;
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
        }
        weakSelf.FormDatas.str_EntourageId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_Entourage=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_Entourage.text=weakSelf.FormDatas.str_Entourage;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//MARK:选择抄送人
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
        }
        weakSelf.FormDatas.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_CcToPeople.text=weakSelf.FormDatas.str_CcUsersName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(void)SecondApproveClick{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_twoHandeId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"1";
    contactVC.Radio = @"1";
    contactVC.arrClickPeople = array;
    contactVC.menutype=4;
    contactVC.itemType = 14;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        self.FormDatas.str_twoApprovalName = bul.requestor;
        self.FormDatas.str_twoHandeId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.txf_Approver.text= bul.requestor;
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
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

//MARK:撤回操作
-(void)reCallBack:(id)btn{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
    
}

//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    if (type == 2) {
        [self.FormDatas inModelHasApproveContent];
        [self configModelOtherData];
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }else{
        examineViewController *vc=[[examineViewController alloc]init];
        vc.ProcId=self.FormDatas.str_procId;
        vc.TaskId=self.FormDatas.str_taskId;
        vc.FlowCode=self.FormDatas.str_flowCode;
        vc.Type=[NSString stringWithFormat:@"%ld",(long)type];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)configModelOtherData{
    
    self.FormDatas.SubmitData.Reason=_txv_Reason.text;
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
    self.FormDatas.SubmitData.CarNo = _txf_CarNo.text;
    self.FormDatas.SubmitData.Driver = _txf_Driver.text;
    self.FormDatas.SubmitData.DriverTel = _txf_DriverTel.text;
    self.FormDatas.SubmitData.Mileage = _txf_Mileage.text;
    self.FormDatas.SubmitData.DepartCity = _txf_DepartCity.text;
    self.FormDatas.SubmitData.BackCity = _txf_BackCity.text;
    self.FormDatas.SubmitData.VehicleDate = _txf_VehicleDate.text;
    self.FormDatas.SubmitData.BackDate = _txf_BackDate.text;
    self.FormDatas.SubmitData.InitialMileage = _txf_InitialMileage.text;
    self.FormDatas.SubmitData.EndMileage = _txf_EndMileage.text;
    self.FormDatas.SubmitData.PteCarAllowance = _txf_PteCarAllowance.text;
    self.FormDatas.SubmitData.FuelBills = _txf_FuelBills.text;
    self.FormDatas.SubmitData.Pontage = _txf_Pontage.text;
    self.FormDatas.SubmitData.ParkingFee = _txf_ParkingFee.text;
    self.FormDatas.SubmitData.OtherFee = _txf_OtherFee.text;
    self.FormDatas.SubmitData.TotalBudget = _txf_TotalBudget.text;
    self.FormDatas.SubmitData.DispatcherReview = _txf_DispatcherReview.text;
}
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:AdvanceLoadImage WithBlock:^(id data, BOOL hasError) {
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
    examineViewController *vc=[[examineViewController alloc]init];
    vc.ProcId=self.FormDatas.str_procId;
    vc.TaskId=self.FormDatas.str_taskId;
    vc.FlowCode=self.FormDatas.str_flowCode;
    vc.Type=@"2";
    vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
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
