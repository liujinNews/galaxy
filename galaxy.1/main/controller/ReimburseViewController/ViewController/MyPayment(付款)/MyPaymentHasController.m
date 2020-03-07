//
//  MyPaymentHasController.m
//  galaxy
//
//  Created by hfk on 2018/11/30.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MyPaymentHasController.h"

@interface MyPaymentHasController ()

@end

@implementation MyPaymentHasController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[MyPaymentFormData alloc]initWithStatus:2];
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
        self.FormDatas.int_comeEditType = [self.pushComeEditType integerValue];
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
    if (self.FormDatas.int_comeStatus == 2 || self.FormDatas.int_comeStatus == 7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus == 8){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil),Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }else if (index==1){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus == 9){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }
        };
    }else if (self.FormDatas.int_comeStatus == 3){
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
    }else if (self.FormDatas.int_comeStatus == 4){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"确认支付" , nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf dockViewClick:3];
            }
        };
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
    
    if (self.FormDatas.int_comeStatus == 2 || self.FormDatas.int_comeStatus == 3 || self.FormDatas.int_comeStatus == 4 || self.FormDatas.int_comeStatus == 7 || self.FormDatas.int_comeStatus == 8 || self.FormDatas.int_comeStatus == 9) {
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
    _ReimPolicyUpView = [[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom).offset(@10);
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
    [_View_Reason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaymentType = [[UIView alloc]init];
    _View_PaymentType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentType];
    [_View_PaymentType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_RelPay = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0009"];
    _View_RelPay.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelPay];
    [_View_RelPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaymentType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount = [[UIView alloc]init];
    _View_Amount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelPay.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized = [[UIView alloc]init];
    _View_Capitalized.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Amount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayMode = [[UIView alloc]init];
    _View_PayMode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayMode];
    [_View_PayMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayBankName = [[UIView alloc]init];
    _View_PayBankName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayBankName];
    [_View_PayBankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayMode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaymentDate = [[UIView alloc]init];
    _View_PaymentDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentDate];
    [_View_PaymentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayBankName.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_line2 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaymentDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate = [[UIView alloc]init];
    _View_Cate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpenseDesc = [[UIView alloc]init];
    _View_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDesc];
    [_View_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceType];
    [_View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpenseDesc.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AirTicketPrice = [[UIView alloc]init];
    _View_AirTicketPrice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AirTicketPrice];
    [_View_AirTicketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DevelopmentFund = [[UIView alloc]init];
    _View_DevelopmentFund.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_DevelopmentFund];
    [_View_DevelopmentFund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirTicketPrice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FuelSurcharge = [[UIView alloc]init];
    _View_FuelSurcharge.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FuelSurcharge];
    [_View_FuelSurcharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DevelopmentFund.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherTaxes = [[UIView alloc]init];
    _View_OtherTaxes.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OtherTaxes];
    [_View_OtherTaxes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FuelSurcharge.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AirlineFuelFee = [[UIView alloc]init];
    _View_AirlineFuelFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AirlineFuelFee];
    [_View_AirlineFuelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherTaxes.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxRate = [[UIView alloc]init];
    _View_TaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxRate];
    [_View_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirlineFuelFee.bottom);
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
    
    _View_FeeAppForm = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0012"];
    _View_FeeAppForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppForm];
    [_View_FeeAppForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Estimated = [[UIView alloc]init];
    _View_Estimated.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Estimated];
    [_View_Estimated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FeeAppForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OverBudReason = [[UIView alloc]init];
    _View_OverBudReason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OverBudReason];
    [_View_OverBudReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Estimated.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBudReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseDetail = [[PurAndContractDetailView alloc]initWithFlowCode:@"F0005"];
    [self.contentView addSubview: _View_PurchaseDetail];
    [_View_PurchaseDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelateCont = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:nil];
    _View_RelateCont.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelateCont];
    [_View_RelateCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseDetail.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelateContTotal = [[UIView alloc]init];
    _View_RelateContTotal.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_RelateContTotal];
    [_View_RelateContTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelateCont.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelateContPaid = [[UIView alloc]init];
    _View_RelateContPaid.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_RelateContPaid];
    [_View_RelateContPaid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelateContTotal.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelateContPaid.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractDetail = [[PurAndContractDetailView alloc]initWithFlowCode:@"F0013"];
    [self.contentView addSubview: _View_ContractDetail];
    [_View_ContractDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_ContEffectiveDate = [[UIView alloc]init];
    _View_ContEffectiveDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ContEffectiveDate];
    [_View_ContEffectiveDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractDetail.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContExpiryDate = [[UIView alloc]init];
    _View_ContExpiryDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ContExpiryDate];
    [_View_ContExpiryDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContEffectiveDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContPmtTyp = [[UIView alloc]init];
    _View_ContPmtTyp.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContPmtTyp];
    [_View_ContPmtTyp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContExpiryDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContPmtTyp.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ProjActivity = [[UIView alloc]init];
    _View_ProjActivity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ProjActivity];
    [_View_ProjActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Bnf = [[UIView alloc]init];
    _View_Bnf.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Bnf];
    [_View_Bnf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ProjActivity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Bnf.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_line3 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VMSCode = [[UIView alloc]init];
    _View_VMSCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VMSCode];
    [_View_VMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankHeadOffice = [[UIView alloc]init];
    _View_BankHeadOffice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankHeadOffice];
    [_View_BankHeadOffice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VMSCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount = [[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankHeadOffice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankOutlets = [[UIView alloc]init];
    _View_BankOutlets.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankOutlets];
    [_View_BankOutlets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankName = [[UIView alloc]init];
    _View_BankName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankName];
    [_View_BankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankOutlets.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankCity = [[UIView alloc]init];
    _View_BankCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankCity];
    [_View_BankCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankName.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanClientName = [[UIView alloc]init];
    _View_IbanClientName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanClientName];
    [_View_IbanClientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanClientAddr = [[UIView alloc]init];
    _View_IbanClientAddr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanClientAddr];
    [_View_IbanClientAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanClientName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanName = [[UIView alloc]init];
    _View_IbanName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanName];
    [_View_IbanName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanClientAddr.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanAccount = [[UIView alloc]init];
    _View_IbanAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanAccount];
    [_View_IbanAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanAddr = [[UIView alloc]init];
    _View_IbanAddr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanAddr];
    [_View_IbanAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SwiftCode = [[UIView alloc]init];
    _View_SwiftCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SwiftCode];
    [_View_SwiftCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanAddr.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanNo = [[UIView alloc]init];
    _View_IbanNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanNo];
    [_View_IbanNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SwiftCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanADDRESS = [[UIView alloc]init];
    _View_IbanADDRESS.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanADDRESS];
    [_View_IbanADDRESS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefInvoiceAmount = [[UIView alloc]init];
    _View_RefInvoiceAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefInvoiceAmount];
    [_View_RefInvoiceAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanADDRESS.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefInvoiceType = [[UIView alloc]init];
    _View_RefInvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefInvoiceType];
    [_View_RefInvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefInvoiceAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefTaxRate = [[UIView alloc]init];
    _View_RefTaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefTaxRate];
    [_View_RefTaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefInvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefTax = [[UIView alloc]init];
    _View_RefTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefTax];
    [_View_RefTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefTaxRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefExclTax = [[UIView alloc]init];
    _View_RefExclTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefExclTax];
    [_View_RefExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _ReimShareMainView = [[ReimShareMainView alloc]init];
    [self.contentView addSubview:_ReimShareMainView];
    [_ReimShareMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimShareDeptSumView = [[BaseFormSumView alloc]init];
    _ReimShareDeptSumView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ReimShareDeptSumView];
    [_ReimShareDeptSumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareMainView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _PaymentExpDetailView = [[PaymentExpDetailView alloc]init];
    [self.contentView addSubview:_PaymentExpDetailView];
    [_PaymentExpDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareDeptSumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line4 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line4];
    [_view_line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PaymentExpDetailView.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_HasInvoice = [[UIView alloc]init];
    _View_HasInvoice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_HasInvoice];
    [_View_HasInvoice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line4.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_NoInvReason = [[UIView alloc]init];
    _View_NoInvReason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_NoInvReason];
    [_View_NoInvReason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HasInvoice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_NoInvReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiptOfInv = [[UIView alloc]init];
    _View_ReceiptOfInv.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_ReceiptOfInv];
    [_View_ReceiptOfInv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AccountItem = [[UIView alloc]init];
    _View_AccountItem.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_AccountItem];
    [_View_AccountItem makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiptOfInv.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_line5 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line5];
    [_view_line5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line5.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsDeptBearExps = [[UIView alloc]init];
    _View_IsDeptBearExps.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsDeptBearExps];
    [_View_IsDeptBearExps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsDeptBearExps.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople = [[UIView alloc]init];
    _View_CcToPeople.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_File = [[UIView alloc]init];
    _View_File.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_File];
    [_View_File makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Budget = [[UIView alloc]init];
    _View_Budget.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Budget];
    [_View_Budget makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_File.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Budget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormSignInfoView = [[FormSignInfoView alloc]init];
    [self.contentView addSubview:_FormSignInfoView];
    [_FormSignInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormSignInfoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimPolicyDownView = [[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        self.dockView.userInteractionEnabled=YES;
        self.PrintfBtn.userInteractionEnabled=YES;
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"resultCode"]] isEqualToString:@"1001"]) {
            [self updateAprovalProcess:self.FormDatas.str_flowGuid WithProcId:[NSString stringWithFormat:@"%@",responceDic[@"procId"]]];
        }else{
            NSString * error = [responceDic objectForKey:@"msg"];
            //        NSLog(@"%@",error);
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
//MARK:返回
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
    contactVC.itemType = 9;
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
//0:退单 1加签 2同意 3支付
-(void)dockViewClick:(NSInteger)type{
    if (type == 3) {
        if ([self.userdatas.isOnlinePay isEqualToString:@"1"]) {
            PayMentDetailController *batch = [[PayMentDetailController alloc]init];
            MyApplyModel *model=[[MyApplyModel alloc]init];
            model.taskId = self.FormDatas.str_taskId;
            model.procId = self.FormDatas.str_procId;
            batch.batchPayArray = [NSMutableArray arrayWithObject:model];
            [self.navigationController pushViewController:batch animated:YES];
        }else{
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            self.dockView.userInteractionEnabled=NO;
            [self.FormDatas contectHasPayDataWithTableName:[self.FormDatas getTableName]];
            [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSinglePayUrl] Parameters:[self.FormDatas SinglePayFormWithComment:@"" WithAdvanceNumber:@"" WithExpIds:@"" WithMainForm:nil WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
        }
    }else{
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
            vc.FeeAppNumber = self.FormDatas.str_FeeAppNumber;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//MARK:撤回操作
-(void)reCallBack{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas  reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:催办操作
-(void)goUrge{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas urgeUrl] Parameters:[self.FormDatas urgeParameters] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    //是否显示发票类型
    BOOL showInvoiceType = [NSString isEqualToNull:self.FormDatas.str_ExpenseCode] && [self.FormDatas.arr_hasTaxExpense containsObject:self.FormDatas.str_ExpenseCode];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaymentTypId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updatePaymentTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaymentNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updatePaymentNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateTotalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1 = 1;
            [self updateCurrencyCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1 = 1;
            [self updateExchangeRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1 = 1;
            [self updateLocalCyAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PayMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1 = 1;
            [self updatePayModeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PayBankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1 = 1;
            [self updatePayBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PaymentDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1 = 1;
            [self updatePaymentDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateExpenseTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateExpenseDesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&showInvoiceType) {
            _int_line2 = 1;
            [self updateInvoiceTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&showInvoiceType&&[self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateTaxRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Tax"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&showInvoiceType&&[self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateTaxViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExclTax"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&showInvoiceType&&[self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
            _int_line2 = 1;
            [self updateExclTaxViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FeeAppNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateFeeAppFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateEstimatedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OverBudReason"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateOverBudReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePurchaseNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelateContNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateRelateContViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelateContTotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateRelateContTotalViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelateContAmountPaid"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateRelateContPaidViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContEffectiveDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateContEffectiveDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContExpiryDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateContExpiryDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContPmtTyp"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateContPmtTypViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjectActivityLv1Name"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateProjectActivityView:model];
        }else if ([model.fieldName isEqualToString:@"BnfId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateBnfIdViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Beneficiary"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3 = 1;
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VmsCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3 = 1;
            [self updateVmsCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankHeadOffice"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3 = 1;
            [self updateBankHeadOfficeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3 = 1;
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankOutlets"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateBankOutletsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DepositBank"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateDepositBankViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateBankCityViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanClientName"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanClientNameViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanClientAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanClientAddrViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanName"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanNameViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanAccountViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanAddrViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanSwiftCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateSwiftCodeViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanNoViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IbanADDRESS"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign) {
            _int_line3 = 1;
            [self updateIbanADDRESSViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"RefInvoiceAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateRefInvoiceAmountViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"RefInvoiceType"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateRefInvoiceTypeViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"RefTaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateRefTaxRateViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"RefTax"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateRefTaxViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"RefExclTax"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3 = 1;
            [self updateRefExclTaxViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"HasInvoice"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateHasInvoiceViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"NoInvReason"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&[self.FormDatas.str_HasInvoice isEqualToString:@"0"]) {
            _int_line4 = 1;
            [self updateNoInvReasonView:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line4 = 1;
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsReceiptOfInv"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateReceiptOfInvViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AccountItem"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4 = 1;
            [self updateAccountItemView:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsDeptBearExps"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateIsDeptBearExpsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line5 = 1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Files"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_TolfilesArray.count!=0){
            _int_line5 = 1;
            [self updateFilesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==4) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    
    //更新机票和燃油附加费合计
    if (showInvoiceType && [self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
        [self updateAirlineFuelFeeView];
    }

    //采购付款详情
    if (self.FormDatas.arr_paymentPurDetails && self.FormDatas.arr_paymentPurDetails.count > 0) {
        [_View_PurchaseDetail updateViewWithData:self.FormDatas];
    }
    //合同付款详情
    if (self.FormDatas.arr_paymentContDetailDtoList && self.FormDatas.arr_paymentContDetailDtoList.count > 0) {
        [_View_ContractDetail updateViewWithData:self.FormDatas];
    }
    
    //分摊数据显示
    if (self.FormDatas.bool_ShareShow == YES) {
        if (self.FormDatas.int_ShareShowModel == 1) {
            if (self.FormDatas.arr_ShareDeptSumData.count > 0) {
                [self updateReimShareViewWithType:2];
            }
        }else{
            if (self.FormDatas.arr_ShareData.count > 0) {
                [self updateReimShareViewWithType:1];
            }
        }
    }
    //费用明细显示
    if (self.FormDatas.arr_DetailsDataArray && self.FormDatas.arr_DetailsDataArray.count != 0 && self.FormDatas.bool_DetailsShow) {
        [self updatePaymentExpDetailView];
    }
    //预算视图
    if (self.FormDatas.dict_budgetInfo && self.FormDatas.dict_budgetInfo.count > 0) {
        [self updateBudgetNote];
    }
    //签收记录
    if (self.FormDatas.dict_SignInfo) {
        [_FormSignInfoView updateView:self.FormDatas.dict_SignInfo];
    }
    //审批记录
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    //报销政策
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    [self updateBottomView];
    
}
//MARK:更新事由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:付款类型
-(void)updatePaymentTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_PayType];
    __weak typeof(self) weakSelf = self;
    [_View_PaymentType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_PaymentType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新关联付款单
-(void)updatePaymentNumberViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentInfo],
                           @"Model":model
                           };
    [_View_RelPay updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_RelPay.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Amount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Amount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新大写视图
-(void)updateCapitalizedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Capitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Capitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新币种视图
-(void)updateCurrencyCodeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_Currency];
    __weak typeof(self) weakSelf = self;
    [_View_CurrencyCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CurrencyCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新汇率视图
-(void)updateExchangeRateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:2 block:^(NSInteger height) {
        [weakSelf.View_ExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新本位币
-(void)updateLocalCyAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款方式
-(void)updatePayModeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_PayMode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_PayMode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款银行
-(void)updatePayBankNameViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_PayBankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_PayBankName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新期望付款日期
-(void)updatePaymentDateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_PaymentDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_PaymentDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.FormDatas.str_ExpenseCat,self.FormDatas.str_ExpenseType]];
    __weak typeof(self) weakSelf = self;
    [_View_Cate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Cate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用类别描述
-(void)updateExpenseDesViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ExpenseDesc addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ExpenseDesc updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票类型
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = self.FormDatas.str_InvoiceTypeName;
    __weak typeof(self) weakSelf = self;
    [_View_InvoiceType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"机票和燃油附加费合计", nil);
    model.isShow = @1;
    model.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_AirlineFuelFee];
    [_View_AirlineFuelFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
    model1.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_AirTicketPrice];
    [_View_AirTicketPrice addSubview:[XBHepler creation_Lable:[UILabel new] model:model1 Y:0 block:^(NSInteger height) {
        [self.View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
    model2.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_DevelopmentFund];
    [_View_DevelopmentFund addSubview:[XBHepler creation_Lable:[UILabel new] model:model2 Y:0 block:^(NSInteger height) {
        [self.View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
    model3.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_FuelSurcharge];
    [_View_FuelSurcharge addSubview:[XBHepler creation_Lable:[UILabel new] model:model3 Y:0 block:^(NSInteger height) {
        [self.View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
    model4.fieldValue = [NSString stringWithIdOnNO:self.FormDatas.str_OtherTaxes];
    [_View_OtherTaxes addSubview:[XBHepler creation_Lable:[UILabel new] model:model4 Y:0 block:^(NSInteger height) {
        [self.View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_TaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Tax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_Tax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用申请单请单
-(void)updateFeeAppFormViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo],
                           @"Model":model
                           };
    [_View_FeeAppForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_FeeAppForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新预估金额单视图
-(void)updateEstimatedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Estimated addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_Estimated updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新超预算原因
-(void)updateOverBudReasonViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_OverBudReason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_OverBudReason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购单请单
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo],
                           @"Model":model
                           };
    [_View_PurchaseForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_PurchaseForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}

//MARK:更新关联合同/申请单视图
-(void)updateRelateContViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_RelateContNo],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_RelateContInfo],
                           @"Model":model
                           };
    _View_RelateCont.flowCode = self.FormDatas.str_RelateContFlowCode;
    [_View_RelateCont updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_RelateCont.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}

//MARK:更新关联合同/申请总金额视图
-(void)updateRelateContTotalViewWithModel:(MyProcurementModel *)model{
    [_View_RelateContTotal addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_RelateContTotal updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新关联合同/申请已付金额视图
-(void)updateRelateContPaidViewWithModel:(MyProcurementModel *)model{
    [_View_RelateContPaid addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_RelateContPaid updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:合同开始日期
-(void)updateContEffectiveDateViewWithModel:(MyProcurementModel *)model{
    [_View_ContEffectiveDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContEffectiveDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:合同截止日期
-(void)updateContExpiryDateViewWithModel:(MyProcurementModel *)model{
    [_View_ContExpiryDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContExpiryDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:合同付款方式
-(void)updateContPmtTypViewWithModel:(MyProcurementModel *)model{
    [_View_ContPmtTyp addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContPmtTyp updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
//MARK:更新项目活动视图
-(void)updateProjectActivityView:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.FormDatas.personalData.ProjectActivityLv1Name,self.FormDatas.personalData.ProjectActivityLv2Name] WithCompare:@"/"];
    __weak typeof(self) weakSelf = self;
    [_View_ProjActivity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ProjActivity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新受益人
-(void)updateBnfIdViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.str_BnfName]?[NSString stringWithFormat:@"%@",self.FormDatas.str_BnfName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Bnf addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Bnf updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新客户
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新VmsCode
-(void)updateVmsCodeViewWithModel:(MyProcurementModel *)model{
    [_View_VMSCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_VMSCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户行总行视图
-(void)updateBankHeadOfficeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_BankHeadOffice addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BankHeadOffice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新银行帐户
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (self.FormDatas.bool_isCashier) {
        self.FormDatas.str_BankAccount = [NSString stringWithIdOnNO:model.fieldValue];
        SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:[[UITextField alloc]init] WithFormType:formViewEnterText WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        view.TextChangedBlock = ^(NSString *text) {
            weakSelf.FormDatas.str_BankAccount = text;
        };
        [_View_BankAccount addSubview:view];
    }else{
        [_View_BankAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_BankAccount updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:更新开户行网点
-(void)updateBankOutletsViewWithModel:(MyProcurementModel *)model{
    [_View_BankOutlets addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankOutlets updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户行视图
-(void)updateDepositBankViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    if (self.FormDatas.bool_isCashier) {
        self.FormDatas.str_DepositBank = [NSString stringWithIdOnNO:model.fieldValue];
        SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankName WithContent:[[UITextField alloc]init] WithFormType:formViewEnterText WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
        view.TextChangedBlock = ^(NSString *text) {
            weakSelf.FormDatas.str_DepositBank = text;
        };
        [_View_BankName addSubview:view];
    }else{
        [_View_BankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
            [weakSelf.View_BankName updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }]];
    }
}
//MARK:更新开户行城市
-(void)updateBankCityViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.FormDatas.str_BankProvince,self.FormDatas.str_BankCity] WithCompare:@"/"];
    [_View_BankCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:Iban相关视图
-(void)updateIbanClientNameViewWithModel:(MyProcurementModel *)model{
    [_View_IbanClientName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanClientName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanClientAddrViewWithModel:(MyProcurementModel *)model{
    [_View_IbanClientAddr addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanClientAddr updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanNameViewWithModel:(MyProcurementModel *)model{
    [_View_IbanName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanAccountViewWithModel:(MyProcurementModel *)model{
    [_View_IbanAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanAddrViewWithModel:(MyProcurementModel *)model{
    [_View_IbanAddr addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanAddr updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateSwiftCodeViewWithModel:(MyProcurementModel *)model{
    [_View_SwiftCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_SwiftCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanNoViewWithModel:(MyProcurementModel *)model{
    [_View_IbanNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateIbanADDRESSViewWithModel:(MyProcurementModel *)model{
    [_View_IbanADDRESS addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanADDRESS updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:一张发票关联多个付款单相应视图
-(void)updateRefInvoiceAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_RefInvoiceAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_RefInvoiceAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateRefInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = self.FormDatas.str_RefInvoiceTypeName;
    __weak typeof(self) weakSelf = self;
    [_View_RefInvoiceType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_RefInvoiceType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateRefTaxRateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_RefTaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_RefTaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateRefTaxViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_RefTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_RefTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateRefExclTaxViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_RefExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_RefExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新分摊明细
-(void)updateReimShareViewWithType:(NSInteger)type{
    if (type == 1) {
        [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:2 WithComePlace:4];
    }else{
        [_ReimShareDeptSumView updateBaseFormSumViewWithData:self.FormDatas WithType:3];
    }
}
//MARK:更新费用明细视图
-(void)updatePaymentExpDetailView{
    [_PaymentExpDetailView updatePaymentExpMainViewWithData:self.FormDatas.arr_DetailsDataArray WithEditType:2];
    __weak typeof(self) weakSelf = self;
    _PaymentExpDetailView.PaymentExpBackClickedBlock = ^(NSInteger type, NSInteger index, PaymentExpDetail * _Nonnull model) {
        PaymentExpDetailHasController *vc = [[PaymentExpDetailHasController alloc]init];
        vc.PaymentExpDetail = [model copy];
        vc.arr_show = weakSelf.FormDatas.arr_DetailsArray;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
//MARK:更新是否有发票
-(void)updateHasInvoiceViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        model.fieldValue = Custing(@"否", nil);
    }else{
        model.fieldValue = Custing(@"是", nil);
    }
    __weak typeof(self) weakSelf = self;
    [_View_HasInvoice addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_HasInvoice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新无发票要原因视图
-(void)updateNoInvReasonView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_NoInvReason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_NoInvReason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount = 10;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}
//MARK:更新是否收发票
-(void)updateReceiptOfInvViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        self.FormDatas.str_ReceiptOfInv=@"0";
        model.fieldValue=Custing(@"未收到", nil);
    }else{
        self.FormDatas.str_ReceiptOfInv=@"1";
        model.fieldValue=Custing(@"收到", nil);
    }
    _Lab_ReceiptOfInv =[[UILabel alloc]init];
    __weak typeof(self) weakSelf = self;
    [_View_ReceiptOfInv addSubview:[XBHepler creation_Lable:_Lab_ReceiptOfInv model:model Y:0 block:^(NSInteger height) {
        [self.View_ReceiptOfInv updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    if (self.FormDatas.bool_ReceiptOfInv) {
        UIImageView *img_des=[[UIImageView alloc]init];
        img_des.image=[UIImage imageNamed:@"skipImage"];
        [_View_ReceiptOfInv addSubview:img_des];
        [img_des makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.View_ReceiptOfInv.right).offset(@-12);
            make.size.equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(self.View_ReceiptOfInv.centerY);
        }];
        _Lab_ReceiptOfInv.userInteractionEnabled=YES;
        [_Lab_ReceiptOfInv bk_whenTapped:^{
            [weakSelf changeReceiptOfInv];
        }];
    }
}
//MARK:更新辅助核算视图
-(void)updateAccountItemView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_AccountItem addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_AccountItem updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新是否本部门承担费用视图
-(void)updateIsDeptBearExpsViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue=Custing(@"是", nil);
    }else{
        model.fieldValue=Custing(@"否", nil);
    }
    [_View_IsDeptBearExps addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IsDeptBearExps updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新发票
-(void)updateFilesViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view = [[EditAndLookImgView alloc]initWithBaseView:_View_File withEditStatus:2 withModel:model];
    view.maxCount = 10;
    [_View_File addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_TolfilesArray WithImgArray:self.FormDatas.arr_filesArray];
}
//MARK:超预算记录
-(void)updateBudgetNote{
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Budget WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNoneLine WithString:Custing(@"查看预算详情", nil) WithTips:nil WithInfodict:nil];
    view.lab_title.textColor = Color_Orange_Weak_20;
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf Budget:nil];
    }];
    [_View_Budget addSubview:view];
}
//MARK:更新借款审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    model.Description = Custing(@"审批人", nil);
    model.fieldValue = @"";
    _txf_Approver = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
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
//MARK:更新报销政策视图
-(void)updateReimPolicyView{
    __weak typeof(self) weakSelf = self;
    ReimPolicyView *view = [[ReimPolicyView alloc]initWithFlowCode:self.FormDatas.str_flowCode withBodydict:self.FormDatas.dict_ReimPolicyDict withBaseViewHeight:^(NSInteger height, NSDictionary *date) {
        if ([date[@"location"]floatValue] == 1) {
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
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}

//MARK:是否收到发票
-(void)changeReceiptOfInv{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_ReceiptOfInv=Model.Id;
        weakSelf.Lab_ReceiptOfInv.text = Model.Type;
    }];
    picker.typeTitle=Custing(@"是否收到发票", nil);
    picker.DateSourceArray = self.FormDatas.arr_ReceiptOfInv;
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[self.FormDatas.str_ReceiptOfInv floatValue]==1 ? @"1":@"0";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:预算详情
-(void)Budget:(UIButton *)btn{
    BudgetInfoController *vc=[[BudgetInfoController alloc]init];
    vc.budgetInfoDict=self.FormDatas.dict_budgetInfo;
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
