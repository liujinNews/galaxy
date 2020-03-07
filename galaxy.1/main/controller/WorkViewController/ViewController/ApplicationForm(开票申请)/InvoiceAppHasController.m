//
//  InvoiceAppHasController.m
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "InvoiceAppHasController.h"

@interface InvoiceAppHasController ()

@end

@implementation InvoiceAppHasController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[InvoiceAppFormData alloc]initWithStatus:2];
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
    
    _view_line2 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PlanPaymentDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
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
    
    _View_ReceiveBill = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0025"];
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
    
    _view_line3 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceHistoryTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
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
    
    _view_line4 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line4];
    [_view_line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Tel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiverName = [[UIView alloc]init];
    _View_ReceiverName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiverName];
    [_View_ReceiverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line4.bottom);
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

    _view_line5 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line5];
    [_view_line5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiverPostCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Payback = [[UIView alloc]init];
    _View_Payback.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Payback];
    [_View_Payback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line5.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaybackAccount = [[UIView alloc]init];
    _View_PaybackAccount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaybackAccount];
    [_View_PaybackAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Payback.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvNumber = [[UIView alloc]init];
    _View_InvNumber.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvNumber];
    [_View_InvNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaybackAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvDate = [[UIView alloc]init];
    _View_InvDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvDate];
    [_View_InvDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvNumber.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvFiles = [[UIView alloc]init];
    _View_InvFiles.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvFiles];
    [_View_InvFiles makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line6 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line6];
    [_view_line6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvFiles.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line6.bottom);
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
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
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
//MARK:获取开票历史
-(void)requestInvoiceHistory{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getInvoiceHistoryUrl] Parameters:[self.FormDatas getInvoiceHistoryParameter] Delegate:self SerialNum:8 IfUserCache:NO];
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
        case 8:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responceDic[@"result"];
                self.FormDatas.arr_InvoiceHistory = [NSMutableArray array];
                if ([dic[@"invoiceHistorys"] isKindOfClass:[NSArray class]] && [dic[@"invoiceHistorys"] count] > 0) {
                    [self.FormDatas.arr_InvoiceHistory addObjectsFromArray:dic[@"invoiceHistorys"]];
                    self.FormDatas.bool_isOpenInvoiceHistory = NO;
                    [self updateInvoiceHistoryTableView];
                }
            }
        }
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
    contactVC.itemType = 19;
    contactVC.menutype = 4;
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
    if (self.FormDatas.bool_isMgr && type == 2) {
        self.dockView.userInteractionEnabled = NO;
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        __weak typeof(self) weakSelf = self;
        [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_InvFilesTolArray WithUrl:Invoiceuploader WithBlock:^(id data, BOOL hasError) {
            [YXSpritesLoadingView dismiss];
            if (hasError) {
                weakSelf.dockView.userInteractionEnabled=YES;
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
            }else{
                weakSelf.FormDatas.dict_PayBack = @{@"Payback":weakSelf.FormDatas.str_IsPayBack,
                                                    @"PaybackAccount":[NSString isEqualToNull:weakSelf.txf_PaybackAccount.text] ? weakSelf.txf_PaybackAccount.text:(id)[NSNull null],
                                                    @"InvNumber":weakSelf.txf_InvNumber.text,
                                                    @"InvDate":weakSelf.txf_InvDate.text,
                                                    @"InvFiles":data
                                                    };
            [weakSelf readyDoneAndAgreeWithType:type];
            }
        }];
    }else{
        [self readyDoneAndAgreeWithType:type];
    }
}
-(void)readyDoneAndAgreeWithType:(NSInteger)type{
    examineViewController *vc = [[examineViewController alloc]init];
    vc.ProcId = self.FormDatas.str_procId;
    vc.TaskId = self.FormDatas.str_taskId;
    vc.FlowCode = self.FormDatas.str_flowCode;
    if (type == 0) {
        vc.Type=@"0";
    }else if (type == 1){
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
    self.dockView.userInteractionEnabled = NO;
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
        }else if ([model.fieldName isEqualToString:@"InvContent"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateInvContentViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateInvAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvType"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateInvTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateTaxRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvFromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateInvDuringViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvExpectedDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateInvExpectedDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PlanPaymentDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updatePlanPaymentDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateContractDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EffectiveDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateEffectiveDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpiryDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateExpiryDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateContractAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoicedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateInvoicedAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"UnbilledAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateUnbilledAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceiveBillNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateReceiveBillFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateClientView:model];
        }else if ([model.fieldName isEqualToString:@"TaxNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateTaxNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Address"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateAddressViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Tel"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceiverName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateReceiverNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceiverTel"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateReceiverTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceiverAddress"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateReceiverAddressViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ReceiverPostCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateReceiverPostCodeViewWithModel:model];
        }
        
        
        else if ([model.fieldName isEqualToString:@"Payback"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updatePaybackViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaybackAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updatePaybackAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateInvNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateInvDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvFiles"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateInvFilesViewWithModel:model];
        }
        
        
        
        
        
        
        
        
        
        else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line6 = 1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line6 = 1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line6 = 1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line6 = 1;
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
    if ([NSString isEqualToNullAndZero:self.FormDatas.str_ContractAppNumber]) {
        [self requestInvoiceHistory];
    }
    [self updateBottomView];
}
//MARK:更新理由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开票内容
-(void)updateInvContentViewWithModel:(MyProcurementModel *)model{
    [_View_InvContent addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InvContent updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开票金额
-(void)updateInvAmountViewWithModel:(MyProcurementModel *)model{
    [_View_InvAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票类型
-(void)updateInvTypeViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"增值税普通发票", nil);
    }else if ([[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"2"]){
        model.fieldValue = Custing(@"增值税专用发票", nil);
    }else{
        model.fieldValue = @"";
    }
    __weak typeof(self) weakSelf = self;
    [_View_InvType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税率
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    [_View_TaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开票周期
-(void)updateInvDuringViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.FormDatas.str_InvFromDate,self.FormDatas.str_InvToDate] WithCompare:@"-"];
    [_View_InvDuring addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InvDuring updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新期望开票日期
-(void)updateInvExpectedDateViewWithModel:(MyProcurementModel *)model{
    [_View_InvExpectedDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InvExpectedDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新预计付款日期
-(void)updatePlanPaymentDateViewWithModel:(MyProcurementModel *)model{
    [_View_PlanPaymentDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PlanPaymentDate updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新项目名称
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.ProjName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.ProjName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同签订日期
-(void)updateContractDateViewWithModel:(MyProcurementModel *)model{
    [_View_ContractDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContractDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同开始日期
-(void)updateEffectiveDateViewWithModel:(MyProcurementModel *)model{
    [_View_EffectiveDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_EffectiveDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同截止日期
-(void)updateExpiryDateViewWithModel:(MyProcurementModel *)model{
    [_View_ExpiryDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ExpiryDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同金额
-(void)updateContractAmountViewWithModel:(MyProcurementModel *)model{
    [_View_ContractAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ContractAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新已开票金额
-(void)updateInvoicedAmountViewWithModel:(MyProcurementModel *)model{
    [_View_InvoicedAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvoicedAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新未开票金额
-(void)updateUnbilledAmountViewWithModel:(MyProcurementModel *)model{
    [_View_UnbilledAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_UnbilledAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新收款单
-(void)updateReceiveBillFormViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ReceiveBillInfo],
                           @"Model":model
                           };
    [_View_ReceiveBill updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ReceiveBill.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新客户视图
-(void)updateClientView:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.personalData.ClientName];
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税号
-(void)updateTaxNumberViewWithModel:(MyProcurementModel *)model{
    [_View_TaxNumber addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_TaxNumber updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户银行
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    [_View_BankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新银行账户
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    [_View_BankAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新地址
-(void)updateAddressViewWithModel:(MyProcurementModel *)model{
    [_View_Address addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Address updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新电话
-(void)updateTelViewWithModel:(MyProcurementModel *)model{
    [_View_Tel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Tel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新收件人姓名
-(void)updateReceiverNameViewWithModel:(MyProcurementModel *)model{
    [_View_ReceiverName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ReceiverName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新电话号码
-(void)updateReceiverTelViewWithModel:(MyProcurementModel *)model{
    [_View_ReceiverTel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ReceiverTel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新地址
-(void)updateReceiverAddressViewWithModel:(MyProcurementModel *)model{
    [_View_ReceiverAddress addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ReceiverAddress updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新邮编
-(void)updateReceiverPostCodeViewWithModel:(MyProcurementModel *)model{
    [_View_ReceiverPostCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ReceiverPostCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否回款
-(void)updatePaybackViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.bool_isMgr) {
        _txf_Payback = [[UITextField alloc]init];
        SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Payback WithContent:_txf_Payback WithFormType:formViewSelect WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakSelf.FormDatas.str_IsPayBack = Model.Id;
                weakSelf.txf_Payback.text = Model.Type;
            }];
            picker.typeTitle = Custing(@"是否回款", nil);
            picker.DateSourceArray = weakSelf.FormDatas.arr_IsPayBack;
            STOnePickModel *model1 = [[STOnePickModel alloc]init];
            model1.Id = weakSelf.FormDatas.str_IsPayBack;
            picker.Model = model1;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
        if ([self.FormDatas.str_IsPayBack isEqualToString:@"1"]) {
            self.txf_Payback.text = Custing(@"已回款", nil);
        }else if ([self.FormDatas.str_IsPayBack isEqualToString:@"2"]){
            self.txf_Payback.text = Custing(@"未回款", nil);
        }else{
            self.txf_Payback.text = @"";
        }
        [_View_Payback addSubview:view];
    }else{
        if ([self.FormDatas.str_IsPayBack isEqualToString:@"1"]) {
            model.fieldValue = Custing(@"已回款", nil);
        }else if ([self.FormDatas.str_IsPayBack isEqualToString:@"2"]){
            model.fieldValue = Custing(@"未回款", nil);
        }else{
            model.fieldValue = @"";
        }
        [_View_Payback addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [self.View_Payback updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:回款金额
-(void)updatePaybackAccountViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.bool_isMgr) {
        _txf_PaybackAccount = [[GkTextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PaybackAccount WithContent:_txf_PaybackAccount WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        [_View_PaybackAccount addSubview:view];
    }else{
        [_View_PaybackAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
            [self.View_PaybackAccount updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:发票号码
-(void)updateInvNumberViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.bool_isMgr) {
        _txf_InvNumber = [[UITextField alloc]init];
        SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvNumber WithContent:_txf_InvNumber WithFormType:formViewEnterText WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        [_View_InvNumber addSubview:view];

    }else{
        [_View_InvNumber addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [self.View_InvNumber updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:开票日期
-(void)updateInvDateViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.bool_isMgr) {
        _txf_InvDate = [[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvDate WithContent:_txf_InvDate WithFormType:formViewSelectDate WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        [_View_InvDate addSubview:view];

    }else{
        [_View_InvDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [self.View_InvDate updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:发票
-(void)updateInvFilesViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view = [[EditAndLookImgView alloc]initWithBaseView:_View_InvFiles withEditStatus:self.FormDatas.bool_isMgr ? 1:2 withModel:model];
    view.maxCount = 5;
    [_View_InvFiles addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_InvFilesTolArray WithImgArray:self.FormDatas.arr_InvFilesImgArray];
}
//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[ReserverdLookMainView initArr:self.FormDatas.arr_FormMainArray view:_View_Reserved block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新备注
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
    EditAndLookImgView *view = [[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount = 5;
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
    if (_int_line3 == 1) {
        [_view_line3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line4 == 1) {
        [_view_line4 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line5 == 1) {
        [_view_line5 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line6 == 1) {
        [_view_line6 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
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
    cell.isOpen=self.FormDatas.bool_isOpenInvoiceHistory;
    if (cell.LookMore) {
        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)LookMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenInvoiceHistory = !self.FormDatas.bool_isOpenInvoiceHistory;
    [self updateInvoiceHistoryTableView];
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
