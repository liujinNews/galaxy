//
//  InvoiceAppNewController.m
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "InvoiceAppNewController.h"

@interface InvoiceAppNewController ()

@end

@implementation InvoiceAppNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[InvoiceAppFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId = self.pushTaskId;
        self.FormDatas.str_procId = self.pushProcId;
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

//MARK:创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
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
    
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvContent = [[UIView alloc]init];
    _View_InvContent.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvContent];
    [_View_InvContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvAmount = [[UIView alloc]init];
    _View_InvAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvAmount];
    [_View_InvAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvContent.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvType = [[UIView alloc]init];
    _View_InvType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvType];
    [_View_InvType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxRate = [[UIView alloc]init];
    _View_TaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxRate];
    [_View_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvDuring = [[UIView alloc]init];
    _View_InvDuring.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvDuring];
    [_View_InvDuring mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaxRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvExpectedDate = [[UIView alloc]init];
    _View_InvExpectedDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvExpectedDate];
    [_View_InvExpectedDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvDuring.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PlanPaymentDate = [[UIView alloc]init];
    _View_PlanPaymentDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PlanPaymentDate];
    [_View_PlanPaymentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvExpectedDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PlanPaymentDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractDate = [[UIView alloc]init];
    _View_ContractDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractDate];
    [_View_ContractDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EffectiveDate = [[UIView alloc]init];
    _View_EffectiveDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EffectiveDate];
    [_View_EffectiveDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpiryDate = [[UIView alloc]init];
    _View_ExpiryDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpiryDate];
    [_View_ExpiryDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EffectiveDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractAmount = [[UIView alloc]init];
    _View_ContractAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractAmount];
    [_View_ContractAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpiryDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoicedAmount = [[UIView alloc]init];
    _View_InvoicedAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoicedAmount];
    [_View_InvoicedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_UnbilledAmount = [[UIView alloc]init];
    _View_UnbilledAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_UnbilledAmount];
    [_View_UnbilledAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoicedAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiveBill = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0025"];
    _View_ReceiveBill.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiveBill];
    [_View_ReceiveBill mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_UnbilledAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceHistoryTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_InvoiceHistoryTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_InvoiceHistoryTable.delegate = self;
    _View_InvoiceHistoryTable.dataSource = self;
    _View_InvoiceHistoryTable.scrollEnabled = NO;
    _View_InvoiceHistoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_InvoiceHistoryTable];
    [_View_InvoiceHistoryTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiveBill.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceHistoryTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxNumber = [[UIView alloc]init];
    _View_TaxNumber.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxNumber];
    [_View_TaxNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankName = [[UIView alloc]init];
    _View_BankName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankName];
    [_View_BankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaxNumber.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount = [[UIView alloc]init];
    _View_BankAccount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Address = [[UIView alloc]init];
    _View_Address.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Address];
    [_View_Address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Tel = [[UIView alloc]init];
    _View_Tel.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Tel];
    [_View_Tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Address.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiverName = [[UIView alloc]init];
    _View_ReceiverName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiverName];
    [_View_ReceiverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Tel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiverTel = [[UIView alloc]init];
    _View_ReceiverTel.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiverTel];
    [_View_ReceiverTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiverName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiverAddress = [[UIView alloc]init];
    _View_ReceiverAddress.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiverAddress];
    [_View_ReceiverAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiverTel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiverPostCode = [[UIView alloc]init];
    _View_ReceiverPostCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiverPostCode];
    [_View_ReceiverPostCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiverAddress.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiverPostCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople = [[UIView alloc]init];
    _View_CcToPeople.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}

//MARK:网络部分
//MARK:第一次打开表单
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:7 IfUserCache:NO];
}
//MARK:获取开票历史(1表单进入不覆盖显示的值 2选择后覆盖选择值)
-(void)requestInvoiceHistoryWithType:(NSInteger)type{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getInvoiceHistoryUrl] Parameters:[self.FormDatas getInvoiceHistoryParameter] Delegate:self SerialNum:type == 1 ? 8:9 IfUserCache:NO];
}
//MARK:请求成功
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
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self.FormDatas DealWithFormBaseData];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
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
        case 8:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                [self updateSelectContract:responceDic[@"result"] withType:serialNum];
            }
        }
            break;
        case 9:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                [self updateSelectContract:responceDic[@"result"] withType:serialNum];
            }
        }
            break;
        case 10:
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
    self.dockView.userInteractionEnabled = YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)goBackTo{
    self.dockView.userInteractionEnabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled = YES;
    [self goSubmitSuccessToWithModel:self.FormDatas];
}
-(void)updateSelectContract:(NSDictionary *)dic withType:(NSInteger)type{
    if (dic) {
        if (type == 9) {
            self.FormDatas.personalData.ProjId = [NSString stringWithIdOnNO:dic[@"projId"]];
            self.FormDatas.personalData.ProjName = [NSString stringWithIdOnNO:dic[@"projName"]];
            self.FormDatas.personalData.ProjMgrUserId = [NSString stringWithIdOnNO:dic[@"projMgrUserId"]];
            self.FormDatas.personalData.ProjMgr = [NSString stringWithIdOnNO:dic[@"projMgr"]];
            self.txf_Project.text = self.FormDatas.personalData.ProjName;
            self.txf_ContractDate.text = [NSString stringWithIdOnNO:dic[@"contractDate"]];
            self.txf_EffectiveDate.text = [NSString stringWithIdOnNO:dic[@"effectiveDate"]];
            self.txf_ExpiryDate.text = [NSString stringWithIdOnNO:dic[@"expiryDate"]];
            self.txf_ContractAmount.text = [GPUtils transformNsNumber:dic[@"contractAmount"]];
            self.txf_InvoicedAmount.text = [GPUtils transformNsNumber:dic[@"invoiceAmount"]];
            self.txf_UnbilledAmount.text = [GPUtils transformNsNumber:dic[@"noInvoiceAmount"]];
            self.FormDatas.personalData.ClientId = [NSString stringWithIdOnNO:dic[@"clientId"]];
            self.FormDatas.personalData.ClientName = [NSString stringWithIdOnNO:dic[@"clientName"]];
            self.txf_Client.text = self.FormDatas.personalData.ClientName;
            self.txf_TaxNumber.text = [NSString stringWithIdOnNO:dic[@"taxNumber"]];
            self.txf_BankName.text = [NSString stringWithIdOnNO:dic[@"bankName"]];
            self.txf_BankAccount.text = [NSString stringWithIdOnNO:dic[@"bankAccount"]];
            self.txf_Address.text = [NSString stringWithIdOnNO:dic[@"address"]];
            self.txf_Tel.text = [NSString stringWithIdOnNO:dic[@"tel"]];
            self.txf_ReceiverName.text = [NSString stringWithIdOnNO:dic[@"receiverName"]];
            self.txf_ReceiverTel.text = [NSString stringWithIdOnNO:dic[@"receiverTel"]];
            self.txf_ReceiverAddress.text = [NSString stringWithIdOnNO:dic[@"receiverAddress"]];
            self.txf_ReceiverPostCode.text = [NSString stringWithIdOnNO:dic[@"receiverPostCode"]];
        }
        self.FormDatas.arr_InvoiceHistory = [NSMutableArray array];
        if ([dic[@"invoiceHistorys"] isKindOfClass:[NSArray class]]) {
            [self.FormDatas.arr_InvoiceHistory addObjectsFromArray:dic[@"invoiceHistorys"]];
        }
        self.FormDatas.bool_isOpenInvoiceHistory = NO;
        if (self.FormDatas.arr_InvoiceHistory.count > 0) {
            [self updateInvoiceHistoryTableView];
        }else{
            [_View_InvoiceHistoryTable updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_View_InvoiceHistoryTable reloadData];
        }
    }
}

//MARK:视图更新
-(void)updateMainView{
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvContent"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvContentViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvAmount"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvType"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TaxRate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTaxRateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvFromDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvDuringViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvExpectedDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvExpectedDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PlanPaymentDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePlanPaymentDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"EffectiveDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEffectiveDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpiryDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpiryDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractAmount"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvoicedAmount"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvoicedAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"UnbilledAmount"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateUnbilledAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiveBillNumber"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiveBillFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClientId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateClientView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TaxNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTaxNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankAccount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankAccountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Address"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAddressViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Tel"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTelViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiverName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiverNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiverTel"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiverTelViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiverAddress"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiverAddressViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceiverPostCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceiverPostCodeViewWithModel:model];
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
    if (self.FormDatas.arr_noteDateArray.count >= 2 && self.FormDatas.int_comeStatus == 3) {
        [self updateNotesTableView];
    }
    if ([NSString isEqualToNullAndZero:self.FormDatas.str_ContractAppNumber]) {
        [self requestInvoiceHistoryWithType:1];
    }
    [self updateContentView];
    [self.FormDatas getEndShowArray];
}
//MARK:更新理由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txf_Reason = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txf_Reason WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新开票内容
-(void)updateInvContentViewWithModel:(MyProcurementModel *)model{
    _txf_InvContent = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvContent WithContent:_txf_InvContent WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvContent addSubview:view];
}
//MARK:更新开票金额
-(void)updateInvAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvAmount = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvAmount WithContent:_txf_InvAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvAmount addSubview:view];
}
//MARK:更新发票类型
-(void)updateInvTypeViewWithModel:(MyProcurementModel *)model{
    _txf_InvType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvType WithContent:_txf_InvType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_InvoiceType = Model.Id;
            weakSelf.txf_InvType.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_InvoiceType;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_InvoiceType;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        self.txf_InvType.text = Custing(@"增值税普通发票", nil);
    }else if ([self.FormDatas.str_InvoiceType isEqualToString:@"2"]){
        self.txf_InvType.text = Custing(@"增值税专用发票", nil);
    } else{
        self.txf_InvType.text = @"";
    }
    [_View_InvType addSubview:view];
}
//MARK:更新税率
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    _txf_TaxRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TaxRate WithContent:_txf_TaxRate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_TaxRate.text = [NSString stringWithIdOnNO:Model.Type];
        }];
        picker.typeTitle = Custing(@"税率(%)", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_TaxRate addSubview:view];
}
//MARK:更新开票周期
-(void)updateInvDuringViewWithModel:(MyProcurementModel *)model{
    _txf_InvDuring = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvDuring WithContent:_txf_InvDuring WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_InvFromDate,self.FormDatas.str_InvToDate] WithCompare:@"-"]}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"开始时间", nil) Type:1 Date:self.FormDatas.str_InvFromDate];
        [view setSTblock:^(NSString *date) {
            weakSelf.FormDatas.str_InvFromDate = date;
            STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"结束时间", nil) Type:1 Date:self.FormDatas.str_InvToDate];
            [view setSTblock:^(NSString *date) {
                weakSelf.FormDatas.str_InvToDate = date;
                weakSelf.txf_InvDuring.text = [GPUtils getSelectResultWithArray:@[weakSelf.FormDatas.str_InvFromDate,weakSelf.FormDatas.str_InvToDate] WithCompare:@"-"];
            }];
            [view show];
        }];
        [view show];
    }];
    [_View_InvDuring addSubview:view];
}
//MARK:更新期望开票日期
-(void)updateInvExpectedDateViewWithModel:(MyProcurementModel *)model{
    _txf_InvExpectedDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvExpectedDate WithContent:_txf_InvExpectedDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvExpectedDate addSubview:view];
}
//MARK:更新预计付款日期
-(void)updatePlanPaymentDateViewWithModel:(MyProcurementModel *)model{
    _txf_PlanPaymentDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_PlanPaymentDate WithContent:_txf_PlanPaymentDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PlanPaymentDate addSubview:view];
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
        [weakSelf ContractClick];
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
//MARK:更新合同签订日期
-(void)updateContractDateViewWithModel:(MyProcurementModel *)model{
    _txf_ContractDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ContractDate WithContent:_txf_ContractDate WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContractDate addSubview:view];
}
//MARK:更新合同开始日期
-(void)updateEffectiveDateViewWithModel:(MyProcurementModel *)model{
    _txf_EffectiveDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_EffectiveDate WithContent:_txf_EffectiveDate WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_EffectiveDate addSubview:view];
}
//MARK:更新合同截止日期
-(void)updateExpiryDateViewWithModel:(MyProcurementModel *)model{
    _txf_ExpiryDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ExpiryDate WithContent:_txf_ExpiryDate WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ExpiryDate addSubview:view];
}
//MARK:更新合同金额
-(void)updateContractAmountViewWithModel:(MyProcurementModel *)model{
    _txf_ContractAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ContractAmount WithContent:_txf_ContractAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContractAmount addSubview:view];
}

//MARK:更新已开票金额
-(void)updateInvoicedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvoicedAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvoicedAmount WithContent:_txf_InvoicedAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoicedAmount addSubview:view];
}

//MARK:更新未开票金额
-(void)updateUnbilledAmountViewWithModel:(MyProcurementModel *)model{
    _txf_UnbilledAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_UnbilledAmount WithContent:_txf_UnbilledAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_UnbilledAmount addSubview:view];
}
//MARK:更新收款单
-(void)updateReceiveBillFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_ReceiveBillNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_ReceiveBillInfo = @"";
        self.FormDatas.str_ReceiveBillNumber = @"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillInfo],
                           @"Model":model
                           };
    [_View_ReceiveBill updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ReceiveBill.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf ReceiveBillClick];
    };
}
//MARK:更新客户视图
-(void)updateClientView:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ClientName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ClientClick];
    }];
    [_View_Client addSubview:view];
}
//MARK:更新税号
-(void)updateTaxNumberViewWithModel:(MyProcurementModel *)model{
    _txf_TaxNumber = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TaxNumber WithContent:_txf_TaxNumber WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_TaxNumber.keyboardType = UIKeyboardTypeEmailAddress;
    [_View_TaxNumber addSubview:view];
}
//MARK:更新开户银行
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    _txf_BankName = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankName WithContent:_txf_BankName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankName addSubview:view];
}
//MARK:更新银行账户
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_BankAccount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_BankAccount.keyboardType = UIKeyboardTypeEmailAddress;
    [_View_BankAccount addSubview:view];
}
//MARK:更新地址
-(void)updateAddressViewWithModel:(MyProcurementModel *)model{
    _txf_Address = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Address WithContent:_txf_Address WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Address addSubview:view];
}
//MARK:更新电话
-(void)updateTelViewWithModel:(MyProcurementModel *)model{
    _txf_Tel = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Tel WithContent:_txf_Tel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_Tel.keyboardType = UIKeyboardTypeEmailAddress;
    [_View_Tel addSubview:view];
}
//MARK:更新收件人姓名
-(void)updateReceiverNameViewWithModel:(MyProcurementModel *)model{
    _txf_ReceiverName = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceiverName WithContent:_txf_ReceiverName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceiverName addSubview:view];
}
//MARK:更新电话号码
-(void)updateReceiverTelViewWithModel:(MyProcurementModel *)model{
    _txf_ReceiverTel = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceiverTel WithContent:_txf_ReceiverTel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_ReceiverTel.keyboardType = UIKeyboardTypeEmailAddress;
    [_View_ReceiverTel addSubview:view];
}
//MARK:更新地址
-(void)updateReceiverAddressViewWithModel:(MyProcurementModel *)model{
    _txf_ReceiverAddress = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceiverAddress WithContent:_txf_ReceiverAddress WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceiverAddress addSubview:view];
}
//MARK:更新邮编
-(void)updateReceiverPostCodeViewWithModel:(MyProcurementModel *)model{
    _txf_ReceiverPostCode = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceiverPostCode WithContent:_txf_ReceiverPostCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceiverPostCode addSubview:view];
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
    _txv_Remark = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新图片
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
//MARK:更新审批人
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
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_CcToPeople.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:修改合同
-(void)ContractClick{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ContractsV3"];
    vc.ChooseCategoryId = weakSelf.FormDatas.str_ContractAppNumber;
    vc.dict_otherPars = @{@"Type":@"2",@"FlowGuid":self.FormDatas.str_flowGuid};
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_ContractAppNumber = model.taskId;
        weakSelf.FormDatas.str_ContractNo = model.contractNo;
        weakSelf.FormDatas.str_ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName] WithCompare:@"/"];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_ContractAppNumber],
                               @"Value":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_ContractName]                               };
        [weakSelf.View_ContractName updateView:dict];
        [weakSelf requestInvoiceHistoryWithType:2];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
//MARK:修改收款单申请单
-(void)ReceiveBillClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ReceiveBill"];
    vc.ChooseCategoryId = self.FormDatas.str_ReceiveBillNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars = @{@"Type":self.FormDatas.str_ReceiveBillStatus};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_ReceiveBillInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_ReceiveBillNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillInfo]                               };
        [weakSelf.View_ReceiveBill updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改客户
-(void)ClientClick{
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId=self.FormDatas.personalData.ClientId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ClientId = model.Id;
        weakSelf.FormDatas.personalData.ClientName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Client.text = weakSelf.FormDatas.personalData.ClientName;
        weakSelf.txf_TaxNumber.text = model.invTaxpayerID;
        weakSelf.txf_BankName.text = model.invBankName;
        weakSelf.txf_BankAccount.text = model.invBankAccount;
        weakSelf.txf_Address.text = model.invAddress;
        weakSelf.txf_Tel.text = model.invTelephone;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:审批人选择
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
    contactVC.menutype = 3;
    contactVC.itemType = 19;
    contactVC.Radio = @"1";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.txf_Approver.text=bul.requestor;
        weakSelf.FormDatas.str_firstHanderName=bul.requestor;
        weakSelf.FormDatas.str_firstHanderId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                weakSelf.FormDatas.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.FormDatas.str_firstHanderPhotoGraph]];
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
    contactVC.arrClickPeople = array;
    contactVC.menutype = 3;
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
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}

//MARK:更新开票历史
-(void)updateInvoiceHistoryTableView{
    if (self.FormDatas.bool_isOpenInvoiceHistory) {
        NSInteger height = 10;
        for (NSDictionary *dict in self.FormDatas.arr_InvoiceHistory) {
            height = height+[ProcureDetailsCell ApplicationFormHistoryCellHeightWithDict:dict];
        }
        [_View_InvoiceHistoryTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        NSDictionary *dict = self.FormDatas.arr_InvoiceHistory[0];
        NSInteger height = 10+[ProcureDetailsCell ApplicationFormHistoryCellHeightWithDict:dict];
        [_View_InvoiceHistoryTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
    [_View_InvoiceHistoryTable reloadData];
}
//MARK: UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.FormDatas.arr_InvoiceHistory.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.FormDatas.arr_InvoiceHistory[indexPath.row];
    return [ProcureDetailsCell ApplicationFormHistoryCellHeightWithDict:dict];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        return [UIView new];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
    if (cell==nil) {
        cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
    }
    NSDictionary *dict = self.FormDatas.arr_InvoiceHistory[indexPath.row];
    [cell configApplicationFormHistoryDetailCellWithDict:dict withindex:indexPath.row withCount:self.FormDatas.arr_InvoiceHistory.count];
    cell.isOpen = self.FormDatas.bool_isOpenInvoiceHistory;
    if (cell.LookMore) {
        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)LookMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenInvoiceHistory = !self.FormDatas.bool_isOpenInvoiceHistory;
    [self updateInvoiceHistoryTableView];
}
//MARK:保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
}
//MARK:提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"提交操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
-(void)directInfo{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    [self mainDataList];
}
//MARK:提交保存数据处理
//拼接数据
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }
    }
    [self.FormDatas contectData];
    [self dealWithImagesArray];
    
}
-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason = _txf_Reason.text;
    self.FormDatas.SubmitData.InvContent = _txf_InvContent.text;
    self.FormDatas.SubmitData.InvAmount = _txf_InvAmount.text;
    self.FormDatas.SubmitData.TaxRate = _txf_TaxRate.text;
    self.FormDatas.SubmitData.InvExpectedDate = _txf_InvExpectedDate.text;
    self.FormDatas.SubmitData.PlanPaymentDate = _txf_PlanPaymentDate.text;
    self.FormDatas.SubmitData.ContractDate = _txf_ContractDate.text;
    self.FormDatas.SubmitData.EffectiveDate = _txf_EffectiveDate.text;
    self.FormDatas.SubmitData.ExpiryDate = _txf_ExpiryDate.text;
    self.FormDatas.SubmitData.ContractAmount = [NSString isEqualToNullAndZero:_txf_ContractAmount.text] ? [_txf_ContractAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
    self.FormDatas.SubmitData.InvoicedAmount = [NSString isEqualToNullAndZero:_txf_InvoicedAmount.text] ? [_txf_InvoicedAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
    self.FormDatas.SubmitData.UnbilledAmount = [NSString isEqualToNullAndZero:_txf_UnbilledAmount.text] ? [_txf_UnbilledAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
    self.FormDatas.SubmitData.TaxNumber = _txf_TaxNumber.text;
    self.FormDatas.SubmitData.BankName = _txf_BankName.text;
    self.FormDatas.SubmitData.BankAccount = _txf_BankAccount.text;
    self.FormDatas.SubmitData.Address = _txf_Address.text;
    self.FormDatas.SubmitData.Tel = _txf_Tel.text;
    self.FormDatas.SubmitData.ReceiverName = _txf_ReceiverName.text;
    self.FormDatas.SubmitData.ReceiverTel = _txf_ReceiverTel.text;
    self.FormDatas.SubmitData.ReceiverAddress = _txf_ReceiverAddress.text;
    self.FormDatas.SubmitData.ReceiverPostCode = _txf_ReceiverPostCode.text;
    self.FormDatas.SubmitData.Remark = _txv_Remark.text;
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:CommontLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.FormDatas.str_imageDataString = data;
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

//MARK:保存
-(void)requestAppSave
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:提交
-(void)requestAppSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:[self.FormDatas SubmitFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:[self.FormDatas SubmitFormAgainWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=2;
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
