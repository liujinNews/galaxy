//
//  RemittanceHasController.m
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "RemittanceHasController.h"

@interface RemittanceHasController ()

@end

@implementation RemittanceHasController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[RemittanceFormData alloc]initWithStatus:2];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId = self.pushTaskId;
        self.FormDatas.str_procId = self.pushProcId;
        self.FormDatas.str_flowCode = self.pushFlowCode;
        self.FormDatas.str_userId = self.pushUserId;
        self.FormDatas.int_comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex && self.pushBackIndex) {
            self.backIndex = self.pushBackIndex;
        }
    }
    if (self.pushFlowGuid) {
        self.FormDatas.str_flowGuid = self.pushFlowGuid;
    }
    [self setTitle:nil backButton:YES];
    [self createScrollView];
    [self requestHasApp];
}

-(void)createDealBtns{
    __weak typeof(self) weakSelf = self;
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus==8){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil),Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }else if (index==1){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus==9){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }
        };
    }else if (self.FormDatas.int_comeStatus==3){
        if ([self.FormDatas.str_canEndorse isEqualToString:@"1"]) {
            [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
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
            self.dockView.btnClickBlock = ^(NSInteger index) {
                if (index==0){
                    [weakSelf dockViewClick:0];
                }else if (index==1){
                    [weakSelf dockViewClick:2];
                }
            };
        }
    }
}
//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==7||self.FormDatas.int_comeStatus==8||self.FormDatas.int_comeStatus==9) {
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
    [self createContentView];
    [self createMainView];
}
-(void)createContentView{
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
    
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line1 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_ContractAmount = [[UIView alloc]init];
    _View_ContractAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractAmount];
    [_View_ContractAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankName = [[UIView alloc]init];
    _View_BankName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankName];
    [_View_BankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount = [[UIView alloc]init];
    _View_BankAccount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SettlementStatus = [[UIView alloc]init];
    _View_SettlementStatus.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SettlementStatus];
    [_View_SettlementStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ProjectProgress = [[UIView alloc]init];
    _View_ProjectProgress.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ProjectProgress];
    [_View_ProjectProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SettlementStatus.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ClaimAmount = [[UIView alloc]init];
    _View_ClaimAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClaimAmount];
    [_View_ClaimAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ProjectProgress.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized = [[UIView alloc]init];
    _View_Capitalized.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClaimAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_TotalReceivables = [[UIView alloc]init];
    _View_TotalReceivables.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalReceivables];
    [_View_TotalReceivables mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalDeduction = [[UIView alloc]init];
    _View_TotalDeduction.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalDeduction];
    [_View_TotalDeduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalReceivables.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AccumulativeInvoice = [[UIView alloc]init];
    _View_AccumulativeInvoice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AccumulativeInvoice];
    [_View_AccumulativeInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalDeduction.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_FormalityCompliance = [[UIView alloc]init];
    _View_FormalityCompliance.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FormalityCompliance];
    [_View_FormalityCompliance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccumulativeInvoice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ApprovalAmount = [[UIView alloc]init];
    _View_ApprovalAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ApprovalAmount];
    [_View_ApprovalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FormalityCompliance.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ApprovalCapitalized = [[UIView alloc]init];
    _View_ApprovalCapitalized.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ApprovalCapitalized];
    [_View_ApprovalCapitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ApprovalAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaymentAmount = [[UIView alloc]init];
    _View_PaymentAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentAmount];
    [_View_PaymentAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ApprovalCapitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaymentCapitalized = [[UIView alloc]init];
    _View_PaymentCapitalized.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentCapitalized];
    [_View_PaymentCapitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaymentAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line2 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaymentCapitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople = [[UIView alloc]init];
    _View_CcToPeople.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
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
    
    _View_RemittanceAppInfo = [[MainReleSubInfoView alloc]initWithFlowCode:@"F0032"];
    _View_RemittanceAppInfo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RemittanceAppInfo];
    [_View_RemittanceAppInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceRegAppInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SettlementSlipInfo = [[MainReleSubInfoView alloc]initWithFlowCode:@"F0031"];
    _View_SettlementSlipInfo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SettlementSlipInfo];
    [_View_SettlementSlipInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RemittanceAppInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SettlementSlipInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
//MARK:网络请求
//MARK:第一次打开表单和保存后打开表单接口
-(void)requestHasApp{
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
    self.FormDatas.dict_resultDict = responceDic;
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
        case 1:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
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
-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:撤回跳到重新提交
-(void)goToReSubmit{
    self.dockView.userInteractionEnabled=YES;
    [self goToReSubmitWithModel:self.FormDatas];
}
//MARK:审批人点击
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
    contactVC.itemType = 32;
    contactVC.menutype=4;
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

//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.ProcId=self.FormDatas.str_procId;
    vc.TaskId=self.FormDatas.str_taskId;
    vc.FlowCode=self.FormDatas.str_flowCode;
    if (type==0) {
        vc.Type=@"0";
    }else if (type==1){
        vc.Type=@"1";
    }else if (type==2){
        vc.Type = @"2";
        [self.FormDatas contectHasDataWithTableName:[self.FormDatas getTableName]];
        vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回操作
-(void)reCallBack{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:催办操作
-(void)goUrge{
    NSLog(@"催办操作");
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas urgeUrl] Parameters:[self.FormDatas urgeParameters] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateContractAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SettlementStatus"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateSettlementStatusViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjectProgress"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateProjectProgressViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClaimAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateClaimAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalReceivables"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateTotalReceivablesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalDeduction"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateTotalDeductionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AccumulativeInvoice"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateAccumulativeInvoiceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FormalityCompliance"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateFormalityComplianceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateApprovalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalCapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateApprovalCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaymentAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updatePaymentAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaymentCapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updatePaymentCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line2 = 1;
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
    if (self.FormDatas.array_remittanceAppInfo) {
        [_View_RemittanceAppInfo updateView:self.FormDatas.array_remittanceAppInfo];
        __weak typeof(self) weakSelf = self;
        _View_RemittanceAppInfo.serialNoBtnClickedBlock = ^(NSDictionary * _Nonnull dict) {
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:@"F0032"];
        };
    }
    if (self.FormDatas.array_settlementSlipInfo) {
        [_View_SettlementSlipInfo updateView:self.FormDatas.array_settlementSlipInfo];
        __weak typeof(self) weakSelf = self;
        _View_SettlementSlipInfo.serialNoBtnClickedBlock = ^(NSDictionary * _Nonnull dict) {
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:@"F0031"];
        };
    }
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    
    [self updateBottomView];
}
//MARK:更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新合同金额
-(void)updateContractAmountViewWithModel:(MyProcurementModel *)model{
    [_View_ContractAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ContractAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.ProjName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.ProjName]:@"";
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户行视图
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    [_View_BankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新银行帐号视图
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    [_View_BankAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新结算状态
-(void)updateSettlementStatusViewWithModel:(MyProcurementModel *)model{
    [_View_SettlementStatus addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_SettlementStatus updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新工程进度
-(void)updateProjectProgressViewWithModel:(MyProcurementModel *)model{
    [_View_ProjectProgress addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ProjectProgress updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新本次申领金额
-(void)updateClaimAmountViewWithModel:(MyProcurementModel *)model{
    [_View_ClaimAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ClaimAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新大写视图
-(void)updateCapitalizedViewWithModel:(MyProcurementModel *)model{
    [_View_Capitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Capitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新累计已收款（含已扣）
-(void)updateTotalReceivablesViewWithModel:(MyProcurementModel *)model{
    [_View_TotalReceivables addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_TotalReceivables updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新累计已扣款
-(void)updateTotalDeductionViewWithModel:(MyProcurementModel *)model{
    [_View_TotalDeduction addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_TotalDeduction updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新累计提供发票（含本次）
-(void)updateAccumulativeInvoiceViewWithModel:(MyProcurementModel *)model{
    [_View_AccumulativeInvoice addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_AccumulativeInvoice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新手续合规性
-(void)updateFormalityComplianceViewWithModel:(MyProcurementModel *)model{
    [_View_FormalityCompliance addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_FormalityCompliance updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新审批金额
-(void)updateApprovalAmountViewWithModel:(MyProcurementModel *)model{
    [_View_ApprovalAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ApprovalAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新审批大写视图
-(void)updateApprovalCapitalizedViewWithModel:(MyProcurementModel *)model{
    [_View_ApprovalCapitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ApprovalCapitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额
-(void)updatePaymentAmountViewWithModel:(MyProcurementModel *)model{
    [_View_PaymentAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_PaymentAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款金额大写视图
-(void)updatePaymentCapitalizedViewWithModel:(MyProcurementModel *)model{
    [_View_PaymentCapitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PaymentCapitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[ReserverdLookMainView initArr:self.FormDatas.arr_FormMainArray view:_View_Reserved block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购备注
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_CcToPeople addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CcToPeople updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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
//MARK:更新底层视图
-(void)updateBottomView{
    if (_int_line1 == 1) {
        [_view_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line2 == 1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
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
