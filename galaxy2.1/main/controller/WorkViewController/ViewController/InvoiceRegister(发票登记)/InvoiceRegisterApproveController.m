//
//  InvoiceRegisterApproveController.m
//  galaxy
//
//  Created by hfk on 2018/11/21.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "InvoiceRegisterApproveController.h"

@interface InvoiceRegisterApproveController ()

@end

@implementation InvoiceRegisterApproveController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[InvoiceRegisterFormData alloc]initWithStatus:3];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId = self.pushTaskId;
        self.FormDatas.str_procId = self.pushProcId;
        self.FormDatas.str_flowCode = self.pushFlowCode;
        self.FormDatas.str_userId = self.pushUserId;
        self.FormDatas.int_comeStatus = [self.pushComeStatus integerValue];
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
    
    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StoreApp = [[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0029"];
    _View_StoreApp.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StoreApp];
    [_View_StoreApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StoreApp.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceName = [[UIView alloc]init];
    _View_InvoiceName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceName];
    [_View_InvoiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceDate = [[UIView alloc]init];
    _View_InvoiceDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceDate];
    [_View_InvoiceDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceCode = [[UIView alloc]init];
    _View_InvoiceCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceCode];
    [_View_InvoiceCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceNo = [[UIView alloc]init];
    _View_InvoiceNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceNo];
    [_View_InvoiceNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceTitle = [[UIView alloc]init];
    _View_InvoiceTitle.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceTitle];
    [_View_InvoiceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceAmount = [[UIView alloc]init];
    _View_InvoiceAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceAmount];
    [_View_InvoiceAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceTitle.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceType];
    [_View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxRate = [[UIView alloc]init];
    _View_TaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxRate];
    [_View_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Tax = [[UIView alloc]init];
    _View_Tax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Tax];
    [_View_Tax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaxRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExclTax = [[UIView alloc]init];
    _View_ExclTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExclTax];
    [_View_ExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Tax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SendDate = [[UIView alloc]init];
    _View_SendDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SendDate];
    [_View_SendDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TrackingNo = [[UIView alloc]init];
    _View_TrackingNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TrackingNo];
    [_View_TrackingNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SendDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ReceivedDate = [[UIView alloc]init];
    _View_ReceivedDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceivedDate];
    [_View_ReceivedDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TrackingNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CheckResult = [[UIView alloc]init];
    _View_CheckResult.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CheckResult];
    [_View_CheckResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceivedDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CheckResult.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
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
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceRegAppInfo = [[MainReleSubInfoView alloc]initWithFlowCode:@"F0030"];
    _View_InvoiceRegAppInfo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceRegAppInfo];
    [_View_InvoiceRegAppInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
        
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceRegAppInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
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
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"StoreAppNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateStoreAppNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceTitle"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceTitleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateInvoiceTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTaxRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Tax"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTaxViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExclTax"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateExclTaxViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SendDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateSendDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TrackingNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTrackingNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceivedDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReceivedDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CheckResult"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCheckResultViewWithModel:model];
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
    if (self.FormDatas.array_invoiceRegAppInfo) {
        [_View_InvoiceRegAppInfo updateView:self.FormDatas.array_invoiceRegAppInfo];
        __weak typeof(self) weakSelf = self;
        _View_InvoiceRegAppInfo.serialNoBtnClickedBlock = ^(NSDictionary * _Nonnull dict) {
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:@"F0030"];
        };
    }
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    [self updateContentView];
}
//MARK:更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName],
                           @"Model":model
                           };
    [_View_ContractName updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ContractName.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        if (status == 1) {
            [weakSelf ContractClick];
        }else{
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
        }
    };
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}
//MARK:更新入库单视图
-(void)updateStoreAppNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_StoreAppNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_StoreAppInfo=@"";
        self.FormDatas.str_StoreAppNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StoreAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StoreAppInfo],
                           @"Model":model
                           };
    [_View_StoreApp updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_StoreApp.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        if (status == 1) {
            [weakSelf StoreAppFormClick];
        }else{
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
        }
    };
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}
//MARK:更新发票名称
-(void)updateInvoiceNameViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceName = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceName WithContent:_txf_InvoiceName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceName addSubview:view];
}
//MARK:更新发票日期视图
-(void)updateInvoiceDateViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvoiceDate WithContent:_txf_InvoiceDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceDate addSubview:view];
}
//MARK:更新发票代码
-(void)updateInvoiceCodeViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceCode WithContent:_txf_InvoiceCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceCode addSubview:view];
}
//MARK:更新发票号码
-(void)updateInvoiceNoViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceNo = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceNo WithContent:_txf_InvoiceNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceNo addSubview:view];
}
//MARK:更新发票抬头
-(void)updateInvoiceTitleViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceTitle = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceTitle WithContent:_txf_InvoiceTitle WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceTitle addSubview:view];
}
//MARK:更新发票金额
-(void)updateInvoiceAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceAmount = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceAmount WithContent:_txf_InvoiceAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_Tax.text=[NSString countTax:amount taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:amount with:weakSelf.txf_Tax.text]];
    }];
    [_View_InvoiceAmount addSubview:view];
}
//MARK:更新发票类型视图
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_InvoiceType = Model.Id;
            weakSelf.txf_InvoiceType.text = Model.Type;
            [weakSelf updateTaxRelectView];
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_InvoiceTypes;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_InvoiceType;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    if ([self.FormDatas.str_InvoiceType isEqualToString:@"2"]) {
        self.txf_InvoiceType.text = Custing(@"增值税普通发票", nil);
    }else if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"]){
        self.txf_InvoiceType.text = Custing(@"增值税专用发票", nil);
    } else{
        self.txf_InvoiceType.text = @"";
    }
    [_View_InvoiceType addSubview:view];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    
    _txf_TaxRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TaxRate WithContent:_txf_TaxRate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_TaxRate.text = Model.Type;
            weakSelf.txf_Tax.text= [NSString countTax:weakSelf.txf_InvoiceAmount.text taxrate:Model.Type];
            weakSelf.txf_ExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.txf_InvoiceAmount.text with:weakSelf.txf_Tax.text]];
        }];
        picker.typeTitle = Custing(@"税率(%)", nil);
        picker.DateSourceArray = self.FormDatas.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_TaxRate addSubview:view];
    if (![self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        [_View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _txf_TaxRate.text=@"";
    }
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    _txf_Tax = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Tax WithContent:_txf_Tax WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.txf_ExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.txf_InvoiceAmount.text with:amount]];
    }];
    [_View_Tax addSubview:view];
    if (![self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        [_View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _txf_Tax.text=@"";
    }
}

//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_ExclTax=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExclTax WithContent:_txf_ExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ExclTax addSubview:view];
    if (![self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        [_View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _txf_ExclTax.text=@"";
    }
}
-(void)updateTaxRelectView{
    NSInteger height = 0;
    if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        height = 60;
        self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.txf_InvoiceAmount.text with:self.txf_Tax.text]];
    }else{
        height = 0;
        _txf_TaxRate.text = @"";
        _txf_Tax.text = @"";
        _txf_ExclTax.text = @"";
    }
    if (_txf_TaxRate) {
        [_View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_Tax) {
        [_View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (_txf_ExclTax) {
        [_View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    
}
//MARK:更新寄出时间视图
-(void)updateSendDateViewWithModel:(MyProcurementModel *)model{
    _txf_SendDate = [[UITextField alloc]init];
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
        model.fieldValue = currStr;
    }
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_SendDate WithContent:_txf_SendDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_SendDate addSubview:view];
}
//MARK:更新快递单号
-(void)updateTrackingNoViewWithModel:(MyProcurementModel *)model{
    _txf_TrackingNo = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TrackingNo WithContent:_txf_TrackingNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TrackingNo addSubview:view];
}
//MARK:更新收到时间
-(void)updateReceivedDateViewWithModel:(MyProcurementModel *)model{
    _txf_ReceivedDate = [[UITextField alloc]init];
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
        model.fieldValue = currStr;
    }
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceivedDate WithContent:_txf_ReceivedDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceivedDate addSubview:view];
}
//MARK:更新核对结果
-(void)updateCheckResultViewWithModel:(MyProcurementModel *)model{
    _txf_CheckResult = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CheckResult WithContent:_txf_CheckResult WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CheckResult addSubview:view];
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
//MARK:更新备注
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
//MARK:更新图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
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
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Approve.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:修改合同
-(void)ContractClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"RelaContract"];
    vc.ChooseCategoryId = self.FormDatas.str_ContractAppNumber;
    vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_ContractAppNumber = model.taskId;
        weakSelf.FormDatas.str_ContractNo = model.contractNo;
        weakSelf.FormDatas.str_ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName]];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName]                               };
        [weakSelf.View_ContractName updateView:dict];

        weakSelf.FormDatas.personalData.ProjId = model.projId;
        weakSelf.FormDatas.personalData.ProjName = model.projName;
        weakSelf.txf_Project.text = model.projName;
        weakSelf.FormDatas.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.FormDatas.personalData.ProjMgr = model.projMgr;
    };
    [weakSelf.navigationController pushViewController:vc animated:YES];

}
//MARK:修改项目名称
-(void)ProjectClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId = self.FormDatas.personalData.ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ProjId = model.Id;
        weakSelf.FormDatas.personalData.ProjName = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text = weakSelf.FormDatas.personalData.ProjName;
        weakSelf.FormDatas.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.FormDatas.personalData.ProjMgr = model.projMgr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改入库单
-(void)StoreAppFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"StoreApp"];
    vc.ChooseCategoryId = self.FormDatas.str_StoreAppNumber;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_StoreAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_StoreAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StoreAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StoreAppInfo]                               };
        [weakSelf.View_StoreApp updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改供应商
-(void)SupplierClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId = self.FormDatas.personalData.SupplierId;
    vc.dict_otherPars = @{@"DateType":self.FormDatas.str_SupplierParam};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.SupplierId = model.Id;
        weakSelf.FormDatas.personalData.SupplierName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text = weakSelf.FormDatas.personalData.SupplierName;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
    contactVC.itemType = 30;
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
    self.FormDatas.SubmitData.Reason = _txv_Reason.text;
    self.FormDatas.SubmitData.InvoiceName = _txf_InvoiceName.text;
    self.FormDatas.SubmitData.InvoiceDate = _txf_InvoiceDate.text;
    self.FormDatas.SubmitData.InvoiceCode = _txf_InvoiceCode.text;
    self.FormDatas.SubmitData.InvoiceNo = _txf_InvoiceNo.text;
    self.FormDatas.SubmitData.InvoiceTitle = _txf_InvoiceTitle.text;
    self.FormDatas.SubmitData.InvoiceAmount = [NSString isEqualToNull:_txf_InvoiceAmount.text] ? _txf_InvoiceAmount.text:@"";
    
    self.FormDatas.SubmitData.TaxRate = (_View_TaxRate.zl_height > 0 && [NSString isEqualToNull:_txf_TaxRate.text])?_txf_TaxRate.text:@"";
    
    if (_View_Tax.zl_height > 0 && self.txf_Tax) {
        self.FormDatas.SubmitData.Tax = self.txf_Tax.text;
    }else{
        self.FormDatas.SubmitData.Tax = [NSString countTax:self.FormDatas.SubmitData.InvoiceAmount taxrate:self.FormDatas.SubmitData.TaxRate];
    }
    self.FormDatas.SubmitData.ExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.SubmitData.InvoiceAmount with:self.FormDatas.SubmitData.Tax] afterPoint:2];
    self.FormDatas.SubmitData.SendDate = _txf_SendDate.text;
    self.FormDatas.SubmitData.TrackingNo = _txf_TrackingNo.text;
    self.FormDatas.SubmitData.ReceivedDate = _txf_ReceivedDate.text;
    self.FormDatas.SubmitData.CheckResult = _txf_CheckResult.text;
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
