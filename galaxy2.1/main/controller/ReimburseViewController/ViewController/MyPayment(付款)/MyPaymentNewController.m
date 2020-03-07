//
//  MyPaymentNewController.m
//  galaxy
//
//  Created by hfk on 2018/11/30.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MyPaymentNewController.h"
#import "SelectCardViewController.h"
#import "PayMentDetailLeadController.h"

@interface MyPaymentNewController ()

@end

@implementation MyPaymentNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[MyPaymentFormData alloc]initWithStatus:1];
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
//MARK:创建处理按钮
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
        make.top.left.right.equalTo(self.view);
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
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    _View_table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 200) style:UITableViewStylePlain];
    _View_table.delegate = self;
    _View_table.dataSource = self;
    _View_table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //申请类型
    _View_AppType=[[UIView alloc]init];
    _View_AppType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AppType];
    [_View_AppType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PaymentType = [[UIView alloc]init];
    _View_PaymentType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentType];
    [_View_PaymentType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AppType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelPay = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0009"];
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
    
    _View_PaymentDate = [[UIView alloc]init];
    _View_PaymentDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PaymentDate];
    [_View_PaymentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayMode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate = [[UIView alloc]init];
    _View_Cate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PaymentDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CateSubDesc = [[UIView alloc]init];
    _View_CateSubDesc.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_CateSubDesc];
    [_View_CateSubDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryView = [[UIView alloc]init];
    _CategoryView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CateSubDesc.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing = 1;
    _CategoryLayOut.minimumLineSpacing = 1;
    _CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _CategoryCollectView.delegate = self;
    _CategoryCollectView.dataSource = self;
    _CategoryCollectView.backgroundColor = Color_White_Same_20;
    _CategoryCollectView.scrollEnabled = NO;
    [_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [_CategoryView addSubview:_CategoryCollectView];
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpenseDesc = [[UIView alloc]init];
    _View_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpenseDesc];
    [_View_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
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

    _View_FeeAppForm = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0012"];
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
    
    _View_PurchaseForm = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBudReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    
    _View_RelateCont = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:nil];
    _View_RelateCont.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelateCont];
    [_View_RelateCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
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
    
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelateContPaid.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_ContractPayDetail = [[UIView alloc]init];
    _View_ContractPayDetail.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview: _View_ContractPayDetail];
    [_View_ContractPayDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContEffectiveDate = [[UIView alloc]init];
    _View_ContEffectiveDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ContEffectiveDate];
    [_View_ContEffectiveDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractPayDetail.bottom);
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
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
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
    //是否已扣款
    _View_IsPayment = [[UIView alloc]init];
    _View_IsPayment.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsPayment];
    [_View_IsPayment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IbanADDRESS.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RefInvoiceAmount = [[UIView alloc]init];
    _View_RefInvoiceAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RefInvoiceAmount];
    [_View_RefInvoiceAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsPayment.bottom);
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
    _ReimShareMainView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ReimShareMainView];
    [_ReimShareMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RefExclTax.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _PaymentExpDetailView = [[PaymentExpDetailView alloc]init];
    [self.contentView addSubview:_PaymentExpDetailView];
    [_PaymentExpDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareMainView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_HasInvoice = [[UIView alloc]init];
    _View_HasInvoice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_HasInvoice];
    [_View_HasInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PaymentExpDetailView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_NoInvReason = [[UIView alloc]init];
    _View_NoInvReason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_NoInvReason];
    [_View_NoInvReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HasInvoice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_NoInvReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
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
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsDeptBearExps.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_File = [[UIView alloc]init];
    _View_File.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_File];
    [_View_File mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_File.bottom);
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

    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
//MARK:网络部分
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:7 IfUserCache:NO];
}
//MARK:获取费用类别
-(void)requestCate{
    NSDictionary *parameters=@{@"Type":@"4"};
    [[GPClient shareGPClient]REquestByPostWithPath:GetAddCostNewCategry Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    [YXSpritesLoadingView dismiss];
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
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            if (self.FormDatas.int_comeStatus == 3){
                [self requestApproveNote];
            }else{
                [self updateMainView];
                [self createDealBtns];
                [self requestCate];
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
        case 2:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                self.FormDatas.SubmitData.CostShareApproval1 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval1"]];
                self.FormDatas.SubmitData.CostShareApproval2 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval2"]];
                self.FormDatas.SubmitData.CostShareApproval3 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval3"]];
                [self readySaveAndSubmit];
            }
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
        case 4:
        {
            NSString *tip = [self.FormDatas getProjsByCostcenterCheck:responceDic[@"result"]];
            if (tip) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:tip duration:2.0];
                self.dockView.userInteractionEnabled = YES;
                return;
            }else{
                [self getExpShareApprovalId];
            }
        }
            break;
        case 5:
        {
            [self.FormDatas dealWithCateDateWithType:1];
        }
            break;
        case 6:
        {
            [self.FormDatas dealContractFormsWithDict:responceDic];
            [self readySubmitAndSave];
        }
            break;
        case 7:
        {
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
            [self requestCate];
        }
            break;
        case 10:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        case 14:
        {
            if ([self.FormDatas getVerifyBudegt] == 0) {
                [self dealWithImagesArray];
            }else{
                [self showBudgetTab];
            }
        }
            break;
        default:
            break;
    }
    
}
//MARK:请求失败
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
    [self goSubmitSuccessToWithModel:self.FormDatas];
}
//MARK:显示超预算信息
-(void)showBudgetTab{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"超预算提示", nil) message:@"" canDismis:NO];
    alert.contentView = self.View_table;
    [self.View_table reloadData];
    [alert addButton:Button_OTHER withTitle:Custing(@"取消", nil) handler:^(JKAlertDialogItem *item) {
    }];
    self.dockView.userInteractionEnabled=YES;
    [alert show];
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
        }else if ([model.fieldName isEqualToString:@"ApplicationType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_AppTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PaymentTypId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePaymentTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PaymentNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePaymentNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]){
            self.FormDatas.str_lastAmount = [NSString isEqualToNull:self.FormDatas.str_lastAmount] ? self.FormDatas.str_lastAmount:[NSString stringIsExist:model.fieldValue];
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTotalAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCapitalizedViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCurrencyCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExchangeRateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
            self.FormDatas.str_lastAmount = [NSString stringIsExist:model.fieldValue];
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateLocalCyAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PayMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayModeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PaymentDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePaymentDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpenseTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpenseDescViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvoiceTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TaxRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTaxRateViewWithModel:model];
                [self.FormDatas.dict_reservedDic setValue:model.Description forKey:model.fieldName];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Tax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTaxViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExclTaxViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FeeAppNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateFeeAppFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEstimatedViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"OverBudReason"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateOverBudReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePurchaseNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RelateContNo"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRelateContViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RelateContTotalAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRelateContTotalViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RelateContAmountPaid"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRelateContPaidViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContEffectiveDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContEffectiveDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContExpiryDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContExpiryDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContPmtTyp"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContPmtTypViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjectActivityLv1Name"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectActivityView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BnfId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBnfIdViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClientName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateClientViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Beneficiary"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"VmsCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateVmsCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankHeadOffice"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankHeadOfficeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankAccount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankAccountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankOutlets"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankOutletsViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"DepositBank"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateDepositBankViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankCityViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanClientName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanClientNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanClientAddr"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanClientAddrViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanAccount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanAccountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanAddr"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanAddrViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanSwiftCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSwiftCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanNo"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanNoViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IbanADDRESS"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIbanADDRESSViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"IsPayment"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIsPaymentViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RefInvoiceAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRefInvoiceAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RefInvoiceType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRefInvoiceTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RefTaxRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRefTaxRateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RefTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRefTaxViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RefExclTax"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRefExclTaxViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"HasInvoice"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateHasInvoiceViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"NoInvReason"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateNoInvReasonView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAttachImgViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsDeptBearExps"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIsDeptBearExpsViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRemarkViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Files"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateFilesViewWithModel:model];
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
    
    //更新机票和燃油附加费合计
    [self updateAirlineFuelFeeView];

    if (self.FormDatas.bool_ShareShow) {
        [self updateReimShareView];
    }
    if (self.FormDatas.bool_DetailsShow) {
        [self updatePaymentExpDetailView];
    }

    //分批付款信息
    [self updateContractPayDetail];
    //更新发票类型和税额税率
    [self updateInvoiceTypeReleExpenseTypeViewWithType:1];
    //更新外币客户信息
    [self updateForeignCurrencyViews];
    //更新无发票原因
    [self checkShowNoInvReasonView];
    
    
    if (self.FormDatas.arr_noteDateArray.count >= 2 && self.FormDatas.int_comeStatus == 3) {
        [self updateNotesTableView];
    }
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }

    [self updateContentView];
    [self.FormDatas getEndShowArray];
  
}
//MARK:更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//申请类型数组
- (NSMutableArray *)arr_AppType{
    if (!_arr_AppType) {
        _arr_AppType = [NSMutableArray array];
        NSArray *idArr = [NSArray arrayWithObjects:@"0",@"1", nil];
        NSArray *typeArr = [NSArray arrayWithObjects:Custing(@"项目", nil),Custing(@"非项目", nil), nil];
        for (int i = 0 ; i < 2; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idArr[i];
            model.Type = typeArr[i];
            [_arr_AppType addObject:model];
        }
    }
    return _arr_AppType;
}
//MARK:更新申请类型
- (void)update_AppTypeViewWithModel:(MyProcurementModel *)model{
    for (STOnePickModel *pickModel in self.arr_AppType) {
        if ([model.fieldValue isEqualToString:pickModel.Id]) {
            model.fieldValue = pickModel.Type;
        }
    }
    _txf_AppType = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_AppType WithContent:_txf_AppType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc] init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_AppTypeId = Model.Id;
            weakSelf.str_AppTypeInfo = Model.Type;
            weakSelf.txf_AppType.text = Model.Type;
            weakSelf.FormDatas.str_ApplicationType = Model.Id;
        }];
        picker.typeTitle = Custing(@"申请类型", nil);
        picker.DateSourceArray = weakSelf.arr_AppType;
        [picker setContentMode:STPickerContentModeBottom];
        [picker UpdatePickUI];
        [picker show];
    }];
    [_View_AppType addSubview:view];
}
//MARK:付款类型
-(void)updatePaymentTypeViewWithModel:(MyProcurementModel *)model{
    
    _txf_PaymentType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_PaymentType WithContent:_txf_PaymentType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_PayType}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_PayTypeId;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_PayTypeId = model.Id;
            weakSelf.FormDatas.str_PayType = model.name;
            weakSelf.txf_PaymentType.text = model.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_PaymentType addSubview:view];
}
//MARK:更新关联付款单
-(void)updatePaymentNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_RelPaymentNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_RelPaymentNumber =@"";
        self.FormDatas.str_RelPaymentInfo =@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentInfo],
                           @"Model":model
                           };
    [_View_RelPay updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_RelPay.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf RelPaymentFormClick];
    };
}
//MARK:更新金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Amount = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Amount WithContent:_txf_Amount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:amount];
        NSString *local = [GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        local=[GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([weakSelf.FormDatas.str_InvoiceType isEqualToString:@"1"] && [weakSelf.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
    }];
    [_View_Amount addSubview:view];
}
//MARK:更新大写视图
-(void)updateCapitalizedViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Capitalized addSubview:view];
}
//MARK:更新币种视图
-(void)updateCurrencyCodeViewWithModel:(MyProcurementModel *)model{
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf changeCurrency];
    }];
    [_View_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text = self.FormDatas.str_Currency;
    }else{
        _txf_CurrencyCode.text = self.FormDatas.str_Currency;
    }
}
//MARK:更新汇率视图
-(void)updateExchangeRateViewWithModel:(MyProcurementModel *)model{
    _txf_ExchangeRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.FormDatas.str_ExchangeRate = exchange;
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
    }];
    [_View_ExchangeRate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_ExchangeRate = model.fieldValue;
    }else{
        _txf_ExchangeRate.text = [NSString stringWithFormat:@"%@",self.FormDatas.str_ExchangeRate];
    }
}
//MARK:更新本位币金额视图
-(void)updateLocalCyAmountViewWithModel:(MyProcurementModel *)model{
    _txf_LocalCyAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_LocalCyAmount addSubview:view];
}
//MARK:更新付款方式
-(void)updatePayModeViewWithModel:(MyProcurementModel *)model{
    _txf_PayMode = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_PayMode WithContent:_txf_PayMode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"payWay"];
        choose.ChooseCategoryArray = self.FormDatas.arr_PayCode;
        choose.ChooseCategoryId = self.FormDatas.str_PayCode;
        choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            if (array) {
                ChooseCategoryModel *model = array[0];
                weakSelf.FormDatas.str_PayCode = model.payCode;
                weakSelf.FormDatas.str_PayMode = model.payMode;
                weakSelf.txf_PayMode.text = model.payMode;
            }else{
                weakSelf.FormDatas.str_PayCode = @"";
                weakSelf.FormDatas.str_PayMode = @"";
                weakSelf.txf_PayMode.text = @"";
            }
        };
        [weakSelf.navigationController pushViewController:choose animated:YES];
    }];
    [_View_PayMode addSubview:view];
}
//MARK:更新期望付款日期
-(void)updatePaymentDateViewWithModel:(MyProcurementModel *)model{
    _txf_PaymentDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PaymentDate WithContent:_txf_PaymentDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PaymentDate addSubview:view];
}
//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Cate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_ExpenseCat, self.FormDatas.str_ExpenseType]]}];
    self.Imv_category = view.img_cate;
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.Imv_category = image;
        [weakSelf CateBtnClick:nil];
    }];
    [_View_Cate addSubview:view];
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_ExpenseCode = [NSString stringWithFormat:@"%@",model.fieldValue];
        [view setCateImg:self.FormDatas.str_ExpenseIcon];
    }
}
//MARK:更新费用类别下描述
-(void)updateCateSubDescView{
    if (!self.lab_CateSubDesc) {
        self.lab_CateSubDesc = [GPUtils createLable:CGRectMake(10, 9, Main_Screen_Width-24, 12) text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        [_View_CateSubDesc addSubview:self.lab_CateSubDesc];

    }
    NSInteger height = 0;
    if ([self.FormDatas.dict_CategoryParameter[@"isShowExpenseDesc"] floatValue] == 1 && [NSString isEqualToNull:self.FormDatas.str_CateSubDesc]) {
        height = 22;
        self.lab_CateSubDesc.text = [NSString stringWithFormat:@"%@",self.FormDatas.str_CateSubDesc];
        _View_CateSubDesc.clipsToBounds = NO;
    }else{
        height = 0;
        self.lab_CateSubDesc.text = @"";
        _View_CateSubDesc.clipsToBounds = YES;
    }
    [_View_CateSubDesc updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}
//MARK:更新费用描述
-(void)updateExpenseDescViewWithModel:(MyProcurementModel *)model{
    _txf_ExpenseDesc = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExpenseDesc WithContent:_txf_ExpenseDesc WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ExpenseDesc addSubview:view];
}
//MARK:更新发票类型视图
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_InvoiceTypeName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![weakSelf.FormDatas.str_InvoiceTypeCode isEqualToString:Model.Id]) {
                weakSelf.FormDatas.str_InvoiceType = Model.invoiceType;
                weakSelf.FormDatas.str_InvoiceTypeCode = Model.Id;
                weakSelf.FormDatas.str_InvoiceTypeName = Model.Type;
                weakSelf.txf_InvoiceType.text = Model.Type;
                [weakSelf updateInvoiceTypeReleExpenseTypeViewWithType:2];
            }
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_New_InvoiceTypes;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_InvoiceTypeCode;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_InvoiceType addSubview:view];
}

//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    __weak typeof(self) weakSelf = self;

    _txf_AirlineFuelFee = [[GkTextField alloc]init];
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"机票和燃油附加费合计", nil);
    model.isShow = @1;
    model.tips = Custing(@"请输入机票和燃油附加费合计", nil);
    model.fieldValue = self.FormDatas.str_AirlineFuelFee;
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_AirlineFuelFee WithContent:_txf_AirlineFuelFee WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_AirlineFuelFee addSubview:view];
    

    _txf_AirTicketPrice = [[GkTextField alloc]init];
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
    model1.tips = Custing(@"请输入票价(必填)", nil);
    model1.fieldValue = self.FormDatas.str_AirTicketPrice;
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_AirTicketPrice WithContent:_txf_AirTicketPrice WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model1 WithInfodict:nil];
    view1.AmountChangedBlock = ^(NSString *amount) {
        weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_FuelSurcharge.text] afterPoint:2];
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        local=[GPUtils getRoundingOffNumber:local afterPoint:2];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
    };
    [_View_AirTicketPrice addSubview:view1];
    
    
    _txf_DevelopmentFund = [[GkTextField alloc]init];
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
    model2.tips = Custing(@"请输入民航发展基金(必填)", nil);
    model2.fieldValue = self.FormDatas.str_DevelopmentFund;
    SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:_View_DevelopmentFund WithContent:_txf_DevelopmentFund WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model2 WithInfodict:nil];
    [_View_DevelopmentFund addSubview:view2];
    
    
    _txf_FuelSurcharge = [[GkTextField alloc]init];
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
    model3.tips = Custing(@"请输入燃油费附加费(必填)", nil);
    model3.fieldValue = self.FormDatas.str_FuelSurcharge;
    SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:_View_FuelSurcharge WithContent:_txf_FuelSurcharge WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model3 WithInfodict:nil];
    view3.AmountChangedBlock = ^(NSString *amount) {
        weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_AirTicketPrice.text] afterPoint:2];
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        local=[GPUtils getRoundingOffNumber:local afterPoint:2];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
    };
    [_View_FuelSurcharge addSubview:view3];
    
    _txf_OtherTaxes = [[GkTextField alloc]init];
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
    model4.tips = Custing(@"请输入其他税费(必填)", nil);
    model4.fieldValue = self.FormDatas.str_OtherTaxes;
    SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:_View_OtherTaxes WithContent:_txf_OtherTaxes WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model4 WithInfodict:nil];
    [_View_OtherTaxes addSubview:view4];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    _txf_TaxRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TaxRate WithContent:_txf_TaxRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
    }];
    [_View_TaxRate addSubview:view];
}
//MARK:更新税额视图
-(void)updateTaxViewWithModel:(MyProcurementModel *)model{
    _txf_Tax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Tax WithContent:_txf_Tax WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        NSString *local=[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        weakSelf.txf_ExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:amount]];
    }];
    [_View_Tax addSubview:view];
}
//MARK:更新不含税金额视图
-(void)updateExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_ExclTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ExclTax WithContent:_txf_ExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ExclTax addSubview:view];
}
//MARK:费用类别变化导致发票类型改变 type 1:填充数据 2选择后填充
-(void)updateInvoiceTypeReleExpenseTypeViewWithType:(NSInteger)type{
    NSInteger height = 0;
    if (!_txf_InvoiceType) {
        self.FormDatas.str_InvoiceType = @"0";
        height = 0;
    }else{
        if ([NSString isEqualToNull:self.FormDatas.str_ExpenseCode] && [self.FormDatas.arr_hasTaxExpense containsObject:self.FormDatas.str_ExpenseCode]) {
            height = 60;
            _txf_InvoiceType.text = self.FormDatas.str_InvoiceTypeName;
        }else{
            height = 0;
            self.FormDatas.str_InvoiceType = @"0";
            self.FormDatas.str_InvoiceTypeName = @"";
            self.FormDatas.str_InvoiceTypeCode = @"";
            _txf_InvoiceType.text = @"";
        }
    }
    [_View_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [self updateTaxRelectViewWithType:type];
}
//MARK:发票类型改变导致税额税率变化
-(void)updateTaxRelectViewWithType:(NSInteger)type{
    
    _View_TaxRate.userInteractionEnabled = YES;
    NSInteger height = 0;
    NSInteger heightAir = 0;
    if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"]) {
        if ([self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1005"]) {
            _View_TaxRate.userInteractionEnabled = NO;
            height = 60;
            if ([self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                heightAir = 60;
            }else{
                self.txf_AirlineFuelFee.text = @"";
                self.txf_AirTicketPrice.text = @"";
                self.txf_DevelopmentFund.text = @"";
                self.txf_FuelSurcharge.text = @"";
                self.txf_OtherTaxes.text = @"";
            }
            if (type == 1) {
                NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate] ? self.FormDatas.str_ExchangeRate:@"1.0000")];
                self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
            }else{
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", self.FormDatas.str_InvoiceTypeCode ];
                NSArray *filterArray1 = [self.FormDatas.arr_New_InvoiceTypes filteredArrayUsingPredicate:pred1];
                if (filterArray1.count > 0) {
                    STOnePickModel *model = filterArray1[0];
                    _txf_TaxRate.text = model.taxRate;
                    NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")];
                    local = [GPUtils getRoundingOffNumber:local afterPoint:2];
                    self.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:self.txf_AirTicketPrice.text with:self.txf_FuelSurcharge.text] afterPoint:2];
                    NSString *airLoc = [NSString stringWithFormat:@"%@",local];
                    if ([self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                    }
                    self.txf_Tax.text = [NSString countTax:airLoc taxrate:_txf_TaxRate.text];
                    self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
                }
            }
        }else{
            height = 60;
            NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate] ? self.FormDatas.str_ExchangeRate:@"1.0000")];
            self.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text]];
            self.txf_AirlineFuelFee.text = @"";
            self.txf_AirTicketPrice.text = @"";
            self.txf_DevelopmentFund.text = @"";
            self.txf_FuelSurcharge.text = @"";
            self.txf_OtherTaxes.text = @"";
        }
    }else{
        height = 0;
        _txf_TaxRate.text = @"";
        _txf_Tax.text = @"";
        _txf_ExclTax.text = @"";
        self.txf_AirlineFuelFee.text = @"";
        self.txf_AirTicketPrice.text = @"";
        self.txf_DevelopmentFund.text = @"";
        self.txf_FuelSurcharge.text = @"";
        self.txf_OtherTaxes.text = @"";
    }
    
    [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(heightAir);
    }];
    
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
//MARK:更新费用申请单视图
-(void)updateFeeAppFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_FeeAppNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_FeeAppNumber = @"";
        self.FormDatas.str_FeeAppInfo = @"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo],
                           @"Model":model
                           };
    [_View_FeeAppForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_FeeAppForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf FeeFormClick];
    };
}
//MARK:更新预估金额单视图
-(void)updateEstimatedViewWithModel:(MyProcurementModel *)model{
    _txf_Estimated = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Estimated WithContent:_txf_Estimated WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Estimated addSubview:view];
    self.FormDatas.str_EstimatedAmount = [NSString isEqualToNull:model.fieldValue] ? [[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"";

}
//MARK:更新超预算原因
-(void)updateOverBudReasonViewWithModel:(MyProcurementModel *)model{
    _txv_OverBudReason = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_OverBudReason WithContent:_txv_OverBudReason WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_OverBudReason addSubview:view];
}
//MARK:更新采购申请单视图
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_PurchaseNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_PurchaseInfo = @"";
        self.FormDatas.str_PurchaseNumber = @"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo],
                           @"Model":model
                           };
    [_View_PurchaseForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_PurchaseForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf PurchaseFormClick];
    };
}
//MARK:更新关联合同/申请单视图
-(void)updateRelateContViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_RelateContNo],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_RelateContInfo],
                           @"Model":model
                           };
    [_View_RelateCont updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_RelateCont.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"RelateContAndApply"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_RelateContNo;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_RelateContFlowCode = model.flowCode;
            weakSelf.FormDatas.str_RelateContNo = model.taskId;
            weakSelf.FormDatas.str_RelateContInfo = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName] WithCompare:@"/"];
            weakSelf.FormDatas.str_RelateContTotalAmount = model.totalAmount;
            weakSelf.txf_RelateContTotal.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_RelateContTotalAmount];
            weakSelf.FormDatas.str_RelateContAmountPaid = model.paidAmount;
            weakSelf.txf_RelateContPaid.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_RelateContAmountPaid];
            weakSelf.FormDatas.personalData.SupplierId = model.supplierId;
            weakSelf.FormDatas.personalData.SupplierName = model.supplierName;
            weakSelf.txf_Supplier.text = weakSelf.FormDatas.personalData.SupplierName;
            weakSelf.txf_BankAccount.text = model.bankAccount;
            weakSelf.txf_BankName.text = model.bankName;
            
            if ([NSString isEqualToNull:model.expenseCode] && ![model.expenseCode isEqualToString:weakSelf.FormDatas.str_ExpenseCode]) {
                weakSelf.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon] ? model.expenseIcon:@"15"];
                weakSelf.FormDatas.str_ExpenseType = model.expenseType;
                weakSelf.FormDatas.str_ExpenseCode = model.expenseCode;
                weakSelf.FormDatas.str_ExpenseIcon = model.expenseIcon;
                weakSelf.FormDatas.str_ExpenseCat = model.expenseCat;
                weakSelf.FormDatas.str_ExpenseCatCode = model.expenseCatCode;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                [weakSelf updateInvoiceTypeReleExpenseTypeViewWithType:2];
            }
            NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_RelateContNo],
                                   @"Value":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_RelateContInfo]                               };
            [weakSelf.View_RelateCont updateView:dict];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
//MARK:更新关联合同/申请总金额视图
-(void)updateRelateContTotalViewWithModel:(MyProcurementModel *)model{
    _txf_RelateContTotal = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RelateContTotal WithContent:_txf_RelateContTotal WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_RelateContTotal addSubview:view];
}
//MARK:更新关联合同/申请已付金额视图
-(void)updateRelateContPaidViewWithModel:(MyProcurementModel *)model{
    _txf_RelateContPaid = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RelateContPaid WithContent:_txf_RelateContPaid WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_RelateContPaid addSubview:view];
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
//MARK:更新合同下分期付款视图
-(void)updateContractPayDetail{
    
    if (!self.lab_ContractPayDetail) {
        self.lab_ContractPayDetail = [GPUtils createLable:CGRectMake(10, 9, Main_Screen_Width-24, 12) text:nil font:Font_Same_13_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        [_View_ContractPayDetail addSubview:self.lab_ContractPayDetail];
    }
    NSInteger height = 0;
    if (self.FormDatas.int_isContractPaymentMethod == 1 && self.FormDatas.model_ContractHas) {
        height = 22;
        self.lab_ContractPayDetail.text = [NSString stringWithFormat:@"%@ %@   %@ %@   %@ %@",Custing(@"批次:", nil),[NSString stringIsExist:self.FormDatas.model_ContractHas.no],Custing(@"付款日期:", nil),[NSString stringIsExist:self.FormDatas.model_ContractHas.payDateStr],Custing(@"付款金额:", nil),[GPUtils transformNsNumber:self.FormDatas.model_ContractHas.amount]];
        [self.lab_ContractPayDetail addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20,NSFontAttributeName: Font_Same_12_20} toStr:Custing(@"批次:", nil)];
        [self.lab_ContractPayDetail addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20,NSFontAttributeName: Font_Same_12_20} toStr:Custing(@"付款日期:", nil)];
        [self.lab_ContractPayDetail addAttrDict:@{NSForegroundColorAttributeName: Color_GrayDark_Same_20,NSFontAttributeName: Font_Same_12_20} toStr:Custing(@"付款金额:", nil)];
        _View_ContractPayDetail.clipsToBounds = NO;
    }else{
        height = 0;
        self.lab_ContractPayDetail.text = @"";
        _View_ContractPayDetail.clipsToBounds = YES;
    }
    
    [_View_ContractPayDetail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];

}
//MARK:合同开始日期
-(void)updateContEffectiveDateViewWithModel:(MyProcurementModel *)model{
    _txf_ContEffectiveDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ContEffectiveDate WithContent:_txf_ContEffectiveDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContEffectiveDate addSubview:view];
}
//MARK:合同截止日期
-(void)updateContExpiryDateViewWithModel:(MyProcurementModel *)model{
    _txf_ContExpiryDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContExpiryDate WithContent:_txf_ContExpiryDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContExpiryDate addSubview:view];
}
//MARK:合同付款方式
-(void)updateContPmtTypViewWithModel:(MyProcurementModel *)model{
    _txf_ContPmtTyp = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContPmtTyp WithContent:_txf_ContPmtTyp WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCategoryController *choose = [[ChooseCategoryController alloc]initWithType:@"NewPayWay"];
        choose.ChooseCategoryArray = weakSelf.FormDatas.arr_ContPay;
        choose.ChooseCategoryId = weakSelf.FormDatas.str_ContPmtTypId;
        __weak typeof(self) weakSelf = self;
        choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            if (array) {
                ChooseCategoryModel *model = array[0];
                weakSelf.txf_ContPmtTyp.text = model.name;
                weakSelf.FormDatas.str_ContPmtTyp = model.name;
                weakSelf.FormDatas.str_ContPmtTypId = model.Id;
            }else{
                weakSelf.txf_ContPmtTyp.text = @"";
                weakSelf.FormDatas.str_ContPmtTyp = @"";
                weakSelf.FormDatas.str_ContPmtTypId = @"";
            }
        };
        [weakSelf.navigationController pushViewController:choose animated:YES];
    }];
    [_View_ContPmtTyp addSubview:view];
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
//MARK:更新项目活动视图
-(void)updateProjectActivityView:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.FormDatas.personalData.ProjectActivityLv1Name,self.FormDatas.personalData.ProjectActivityLv2Name] WithCompare:@"/"];
    _txf_ProjActivity = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ProjActivity WithContent:_txf_ProjActivity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ProjActivitys"];
        vc.ChooseCategoryId = weakSelf.FormDatas.personalData.ProjectActivityLv2;
        if ([NSString isEqualToNullAndZero:weakSelf.FormDatas.personalData.ProjId]) {
            vc.dict_otherPars = @{@"PrjId":weakSelf.FormDatas.personalData.ProjId};
        }
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.personalData.ProjectActivityLv1 = model.id_Lv1;
            weakSelf.FormDatas.personalData.ProjectActivityLv1Name = model.name_Lv1;
            weakSelf.FormDatas.personalData.ProjectActivityLv2 = model.Id;
            weakSelf.FormDatas.personalData.ProjectActivityLv2Name = model.name;
            weakSelf.txf_ProjActivity.text = [GPUtils getSelectResultWithArray:@[model.name_Lv1,model.name] WithCompare:@"/"];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_ProjActivity addSubview:view];
}
//MARK:更新受益人视图
-(void)updateBnfIdViewWithModel:(MyProcurementModel *)model{
    _txf_Bnf = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Bnf WithContent:_txf_Bnf WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_BnfName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf BeneficiariesClick];
    }];
    [_View_Bnf addSubview:view];
}
//MARK:更新客户
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    _txf_Client = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
        vc.ChooseCategoryId = weakSelf.FormDatas.personalData.ClientId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.personalData.ClientId = model.Id;
            weakSelf.FormDatas.personalData.ClientName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.txf_Client.text = weakSelf.FormDatas.personalData.ClientName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_View_Client addSubview:view];
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
        vc.ChooseCategoryId = self.FormDatas.personalData.SupplierId;
        vc.dict_otherPars = @{@"DateType":self.FormDatas.str_SupplierParam};
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.personalData.SupplierId = model.Id;
            weakSelf.FormDatas.personalData.SupplierName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.txf_Supplier.text = weakSelf.FormDatas.personalData.SupplierName;
            weakSelf.txf_VMSCode.text = model.vmsCode;
            weakSelf.FormDatas.str_VmsCode = model.vmsCode;
            weakSelf.txf_BankAccount.text = model.bankAccount;
            weakSelf.txf_BankOutlets.text = model.bankOutlets;
            weakSelf.txf_BankName.text = model.depositBank;
            weakSelf.txf_BankCity.text = [GPUtils getSelectResultWithArray:@[model.bankProvince,model.bankCity] WithCompare:@"/"];
            
            weakSelf.FormDatas.str_BankNo = model.bankNo;
            weakSelf.FormDatas.str_BankCode = model.bankCode;
            weakSelf.FormDatas.str_DepositBank = model.depositBank;
            weakSelf.FormDatas.str_BankAccount = model.bankAccount;
            weakSelf.FormDatas.str_BankOutlets = model.bankOutlets;
            weakSelf.FormDatas.str_BankProvinceCode = model.bankProvinceCode;
            weakSelf.FormDatas.str_BankProvince = model.bankProvince;
            weakSelf.FormDatas.str_BankCityCode = model.bankCityCode;
            weakSelf.FormDatas.str_BankCity = model.bankCity;
            weakSelf.FormDatas.str_CNAPS = model.cnaps;

            weakSelf.txf_SwiftCode.text = model.swiftCode;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_View_Supplier addSubview:view];
}
//MARK:更新VmsCode
-(void)updateVmsCodeViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_VMSCode = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_VMSCode WithContent:_txf_VMSCode WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.TextChangedBlock = ^(NSString *text) {
        weakSelf.FormDatas.str_VmsCode = text;
    };
    [_View_VMSCode addSubview:view];
    _txf_VMSCode.keyboardType = UIKeyboardTypeEmailAddress;
}
//MARK:开户总行
-(void)updateBankHeadOfficeViewWithModel:(MyProcurementModel *)model{
    _txf_BankHeadOffice = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankHeadOffice WithContent:_txf_BankHeadOffice WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        SelectCardViewController *select = [[SelectCardViewController alloc]init];
        [select block:^(NSDictionary *dic) {
            if (dic != nil) {
                weakSelf.FormDatas.str_BankNo = dic[@"recBankNo"];
                weakSelf.txf_BankHeadOffice.text = dic[@"recBankName"];
            }
        }];
        [weakSelf.navigationController pushViewController:select animated:YES];
    }];
    [_View_BankHeadOffice addSubview:view];
}
//MARK:更新银行帐户
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_BankAccount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankAccount addSubview:view];
    _txf_BankAccount.keyboardType = UIKeyboardTypeEmailAddress;
}
//MARK:更新开户行网点
-(void)updateBankOutletsViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    _txf_BankOutlets = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankOutlets WithContent:_txf_BankOutlets WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ClearingBank"];
        vc.ChooseBankOutletsBlock = ^(NSMutableArray *array) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_BankOutlets.text = model.bankName;
            weakSelf.txf_BankName.text = model.clearingBank;
            weakSelf.txf_BankCity.text = [GPUtils getSelectResultWithArray:@[model.provinceName,model.cityName] WithCompare:@"/"];
            
            weakSelf.FormDatas.str_DepositBank = model.clearingBank;
            weakSelf.FormDatas.str_BankOutlets = model.bankName;
            weakSelf.FormDatas.str_BankNo = model.clearingBankNo;
            weakSelf.FormDatas.str_BankCode = model.clearingBankCode;
            weakSelf.FormDatas.str_BankProvinceCode = model.provinceCode;
            weakSelf.FormDatas.str_BankProvince = model.provinceName;
            weakSelf.FormDatas.str_CNAPS = model.bankNo;
            weakSelf.FormDatas.str_BankCityCode = model.cityCode;
            weakSelf.FormDatas.str_BankCity = model.cityName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    [_View_BankOutlets addSubview:view];
}
//MARK:更新开户行
-(void)updateDepositBankViewWithModel:(MyProcurementModel *)model{
    _txf_BankName = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankName WithContent:_txf_BankName WithFormType:formViewShowText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankName addSubview:view];
}
//MARK:更新开户行城市
-(void)updateBankCityViewWithModel:(MyProcurementModel *)model{
    _txf_BankCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankCity WithContent:_txf_BankCity WithFormType:formViewShowText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_BankProvince,self.FormDatas.str_BankCity] WithCompare:@"/"]}];
    [_View_BankCity addSubview:view];
}
//MARK:更新外币客户信息
-(void)updateIbanClientNameViewWithModel:(MyProcurementModel *)model{
    _txf_IbanClientName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanClientName WithContent:_txf_IbanClientName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanClientName addSubview:view];
}
-(void)updateIbanClientAddrViewWithModel:(MyProcurementModel *)model{
    _txf_IbanClientAddr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanClientAddr WithContent:_txf_IbanClientAddr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanClientAddr addSubview:view];
    
}
-(void)updateIbanNameViewWithModel:(MyProcurementModel *)model{
    _txf_IbanName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanName WithContent:_txf_IbanName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanName addSubview:view];
}
-(void)updateIbanAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_IbanAccount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanAccount WithContent:_txf_IbanAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanAccount addSubview:view];
    _txf_IbanAccount.keyboardType = UIKeyboardTypeEmailAddress;
}
-(void)updateIbanAddrViewWithModel:(MyProcurementModel *)model{
    _txf_IbanAddr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanAddr WithContent:_txf_IbanAddr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanAddr addSubview:view];
}
-(void)updateSwiftCodeViewWithModel:(MyProcurementModel *)model{
    _txf_SwiftCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SwiftCode WithContent:_txf_SwiftCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_SwiftCode addSubview:view];
}
-(void)updateIbanNoViewWithModel:(MyProcurementModel *)model{
    _txf_IbanNo = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanNo WithContent:_txf_IbanNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanNo addSubview:view];
}
-(void)updateIbanADDRESSViewWithModel:(MyProcurementModel *)model{
    _txf_IbanADDRESS = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanADDRESS WithContent:_txf_IbanADDRESS WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanADDRESS addSubview:view];
}
//是否已扣款数组
- (NSMutableArray *)arr_IsPayment{
    if (!_arr_IsPayment) {
        _arr_IsPayment = [NSMutableArray array];
        NSArray *idArr = [NSArray arrayWithObjects:@"0",@"1", nil];
        NSArray *typeArr = [NSArray arrayWithObjects:Custing(@"未扣款", nil),Custing(@"已扣款", nil), nil];
        for (int i = 0 ; i < idArr.count; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idArr[i];
            model.Type = typeArr[i];
            [_arr_IsPayment addObject:model];
        }
    }
    return _arr_IsPayment;
}
//MARK:更新是否已扣款
-(void)updateIsPaymentViewWithModel:(MyProcurementModel *)model{
    for (STOnePickModel *pickModel in self.arr_IsPayment) {
        if ([model.fieldValue isEqualToString:pickModel.Id]) {
            model.fieldValue = pickModel.Type;
        }
    }
    _txf_IsPayment = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsPayment WithContent:_txf_IsPayment WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc] init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_IsPayment = Model.Id;
            weakSelf.txf_IsPayment.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"是否已扣款", nil);
        picker.DateSourceArray = weakSelf.arr_IsPayment;
        [picker setContentMode:STPickerContentModeBottom];
        [picker UpdatePickUI];
        [picker show];
    }];
    [_View_IsPayment addSubview:view];
}
-(void)updateForeignCurrencyViews{
    self.FormDatas.bool_isForeign = NO;
    for (STOnePickModel *model in self.FormDatas.arr_CurrencyCode) {
        if ([model.Id isEqualToString:self.FormDatas.str_CurrencyCode] && [model.stdMoney floatValue]!=1) {
            self.FormDatas.bool_isForeign = YES;
        }
    }
    [_View_IbanClientName updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanClientName)?@60:@0));
    }];
    
    [_View_IbanClientAddr updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanClientAddr)?@60:@0));
    }];
    
    [_View_IbanName updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanName)?@60:@0));
    }];
    
    [_View_IbanAccount updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanAccount)?@60:@0));
    }];
    
    [_View_IbanAddr updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanAddr)?@60:@0));
    }];
    
    [_View_SwiftCode updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_SwiftCode)?@60:@0));
    }];
    
    [_View_IbanNo updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanNo)?@60:@0));
    }];
    
    [_View_IbanADDRESS updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_IbanADDRESS)?@60:@0));
    }];
}
//MARK:一张发票关联多个付款单相应视图
-(void)updateRefInvoiceAmountViewWithModel:(MyProcurementModel *)model{
    _txf_RefInvoiceAmount = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RefInvoiceAmount WithContent:_txf_RefInvoiceAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_RefTax.text = [NSString countTax:amount taxrate:[NSString isEqualToNull:self.txf_RefTaxRate.text]?self.txf_RefTaxRate.text:@"0"];
        weakSelf.txf_RefExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:amount with:weakSelf.txf_RefTax.text]];
    }];
    [_View_RefInvoiceAmount addSubview:view];
}
-(void)updateRefInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    _txf_RefInvoiceType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RefInvoiceType WithContent:_txf_RefInvoiceType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_RefInvoiceTypeName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_RefInvoiceType = Model.invoiceType;
            weakSelf.FormDatas.str_RefInvoiceTypeCode= Model.Id;
            weakSelf.FormDatas.str_RefInvoiceTypeName = Model.Type;
            weakSelf.txf_RefInvoiceType.text = Model.Type;
            [weakSelf updateRefTaxRelectView];
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_New_InvoiceTypes;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_RefInvoiceTypeCode;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_RefInvoiceType addSubview:view];
}
//MARK:ref发票类型改变导致税额税率变化
-(void)updateRefTaxRelectView{
    _View_RefTaxRate.userInteractionEnabled = YES;
    if ([self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1003"]||[self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1004"]||[self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1005"]) {
        _View_RefTaxRate.userInteractionEnabled = NO;
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", self.FormDatas.str_RefInvoiceTypeCode ];
        NSArray *filterArray1 = [self.FormDatas.arr_New_InvoiceTypes filteredArrayUsingPredicate:pred1];
        if (filterArray1.count > 0) {
            STOnePickModel *model = filterArray1[0];
            _txf_RefTaxRate.text = model.taxRate;
            self.txf_RefTax.text = [NSString countTax:self.txf_RefInvoiceAmount.text taxrate:self.txf_RefTaxRate.text];
            self.txf_RefExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.txf_RefInvoiceAmount.text with:self.txf_RefTax.text]];
        }
    }
}
-(void)updateRefTaxRateViewWithModel:(MyProcurementModel *)model{
    if ([self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1003"]||[self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1004"]||[self.FormDatas.str_RefInvoiceTypeCode isEqualToString:@"1005"]) {
        _View_RefTaxRate.userInteractionEnabled = NO;
    }
    _txf_RefTaxRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RefTaxRate WithContent:_txf_RefTaxRate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_RefTaxRate.text = [NSString stringWithIdOnNO:Model.Type];
            weakSelf.txf_RefTax.text = [NSString countTax:weakSelf.txf_RefInvoiceAmount.text taxrate:weakSelf.txf_RefTaxRate.text];
            weakSelf.txf_RefExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.txf_RefInvoiceAmount.text with:weakSelf.txf_RefTax.text]];
        }];
        picker.typeTitle = Custing(@"税率(%)", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_RefTaxRate addSubview:view];
}
-(void)updateRefTaxViewWithModel:(MyProcurementModel *)model{
    _txf_RefTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_RefTax WithContent:_txf_RefTax WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        weakSelf.txf_RefExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.txf_RefInvoiceAmount.text with:amount]];
    }];
    [_View_RefTax addSubview:view];
}
-(void)updateRefExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_RefExclTax = [[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_RefExclTax WithContent:_txf_RefExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_RefExclTax addSubview:view];
}
//MARK:更新分摊视图
-(void)updateReimShareView{
    [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:1 WithComePlace:4];
    __weak typeof(self) weakSelf = self;
    [_ReimShareMainView setReimDoneClickedBlock:^(NSInteger type, NSInteger comeplace ,ReimShareModel *model) {
        ReimShareController *vc = [[ReimShareController alloc]init];
        vc.delegate = weakSelf;
        vc.type = type;
        vc.comeplace = comeplace;
        vc.model = model;
        vc.ShareFormArray = weakSelf.FormDatas.arr_ShareForm;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//MARK:更新费用明细视图
-(void)updatePaymentExpDetailView{
    [_PaymentExpDetailView updatePaymentExpMainViewWithData:self.FormDatas.arr_DetailsDataArray WithEditType:1];
    __weak typeof(self) weakSelf = self;
    _PaymentExpDetailView.PaymentExpBackClickedBlock = ^(NSInteger type, NSInteger index, PaymentExpDetail * _Nonnull model) {
        //liu_s
        //type1新增2修改3删除4财务修改
        if (weakSelf.FormDatas.arr_DetailsDataArray.count > 0) {
            if (type == 1) {
                NSInteger maxNo = 0;
                for (PaymentExpDetail *currentModel in weakSelf.FormDatas.arr_DetailsDataArray) {
                    maxNo = [currentModel.PaymentOrderNo integerValue]>maxNo?[currentModel.PaymentOrderNo integerValue]:maxNo;
                }
                model.PaymentOrderNo = [NSString stringWithFormat:@"%ld",(long)(maxNo+1)];
            }
        }else{
            model.PaymentOrderNo = @"1";
        }
        NSString *paymentOrderNo = model.PaymentOrderNo;
        //liu_e
        if (type == 3) {
            if ([weakSelf.userdatas.multiCyPayment isEqualToString:@"1"]) {
                NSString *amount = @"0";
                for (PaymentExpDetail *pay in weakSelf.FormDatas.arr_DetailsDataArray) {
                    amount = [GPUtils decimalNumberAddWithString:amount with:pay.InvPmtAmount];
                }
                weakSelf.txf_Amount.text = [GPUtils getRoundingOffNumber:amount afterPoint:2];
                weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.txf_Amount.text];
                NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
                local = [GPUtils getRoundingOffNumber:local afterPoint:2];
                weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
                NSString *airLoc = [NSString stringWithFormat:@"%@",local];
                if ([weakSelf.FormDatas.str_InvoiceType isEqualToString:@"1"] && [weakSelf.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                    airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                }
                weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
                weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
            }
        }else{
            if (type == 1 && weakSelf.FormDatas.dict_PaymentExpDetailProj) {
                model.ProjId = [NSString stringWithIdOnNO:weakSelf.FormDatas.dict_PaymentExpDetailProj[@"id"]];
                model.ProjName = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",weakSelf.FormDatas.dict_PaymentExpDetailProj[@"no"]],[NSString stringWithFormat:@"%@",weakSelf.FormDatas.dict_PaymentExpDetailProj[@"projName"]]] WithCompare:@"/"];
                model.ProjMgrUserId = [NSString stringWithIdOnNO:weakSelf.FormDatas.dict_PaymentExpDetailProj[@"projMgrUserId"]];
                model.ProjMgr = [NSString stringWithIdOnNO:weakSelf.FormDatas.dict_PaymentExpDetailProj[@"projMgr"]];
            }
            PaymentExpDetailNewController *vc = [[PaymentExpDetailNewController alloc]init];
            vc.dict_parameter = @{
                                  @"CostCenterId":(weakSelf.FormDatas.bool_IsHasShowProject && [NSString isEqualToNull:weakSelf.FormDatas.personalData.CostCenterId])? weakSelf.FormDatas.personalData.CostCenterId:@"0"
                                  };
            //liu_s
            NSMutableArray *arruedMArr = [NSMutableArray array];
            for (AccruedDetailModel *accruedModel in weakSelf.FormDatas.arr_SecDetailsDataArray) {
                if ([accruedModel.paymentOrderNo isEqualToString:model.PaymentOrderNo]) {
                    [arruedMArr addObject:accruedModel];
                }
            }
            vc.accruedArr = arruedMArr;
            //liu_e
            vc.type = type;
            vc.PaymentExpDetail = [model copy];
            vc.arr_New_InvoiceTypes = weakSelf.FormDatas.arr_New_InvoiceTypes;
            vc.arr_show = weakSelf.FormDatas.arr_DetailsArray;
            vc.arr_CurrencyCode = weakSelf.FormDatas.arr_CurrencyCode;
            vc.dict_CurrencyCode = weakSelf.FormDatas.dict_CurrencyCodeParameter;
            vc.arr_TaxRates = weakSelf.FormDatas.arr_TaxRates;
            vc.isContractPaymentMethod = weakSelf.FormDatas.int_isContractPaymentMethod;
            vc.str_flowGuid = weakSelf.FormDatas.str_flowGuid;
            vc.PaymentExpDetailAddEditBlock = ^(PaymentExpDetail * _Nonnull model, NSInteger type,NSMutableArray *accruedArr) {
                if (type==1) {
                    [weakSelf.FormDatas.arr_DetailsDataArray addObject:model];
                    [weakSelf.FormDatas.arr_SecDetailsDataArray addObjectsFromArray:accruedArr];
                }else{
                    [weakSelf.FormDatas.arr_DetailsDataArray replaceObjectAtIndex:index withObject:model];
                    for (AccruedDetailModel *accReqDModel in weakSelf.FormDatas.arr_SecDetailsDataArray) {
                        if ([accReqDModel.paymentOrderNo isEqualToString:paymentOrderNo]) {
                            [weakSelf.FormDatas.arr_SecDetailsDataArray removeObject:accReqDModel];
                        }
                        [weakSelf.FormDatas.arr_SecDetailsDataArray addObjectsFromArray:accruedArr];
                    }
                }
                [weakSelf.PaymentExpDetailView updateTableView];
                
                if ([weakSelf.userdatas.multiCyPayment isEqualToString:@"1"] && weakSelf.FormDatas.arr_DetailsDataArray.count > 0) {
                    NSString *amount = @"0";
                    for (PaymentExpDetail *pay in weakSelf.FormDatas.arr_DetailsDataArray) {
                        amount = [GPUtils decimalNumberAddWithString:amount with:pay.InvPmtAmount];
                    }
                    weakSelf.txf_Amount.text = [GPUtils getRoundingOffNumber:amount afterPoint:2];
                    weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.txf_Amount.text];
                    NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
                    local = [GPUtils getRoundingOffNumber:local afterPoint:2];
                    weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
                    NSString *airLoc = [NSString stringWithFormat:@"%@",local];
                    if ([weakSelf.FormDatas.str_InvoiceType isEqualToString:@"1"] && [weakSelf.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                    }
                    weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
                    weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
                }
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    _PaymentExpDetailView.PaymentLeadClickedBlock = ^{//导入费用明细
        //type1新增2修改3删除4财务修改
        static NSInteger maxNo = 0;
        if (weakSelf.FormDatas.arr_DetailsDataArray.count > 0) {
            for (PaymentExpDetail *currentModel in weakSelf.FormDatas.arr_DetailsDataArray) {
                maxNo = [currentModel.PaymentOrderNo integerValue]>maxNo?[currentModel.PaymentOrderNo integerValue]:maxNo;
            }
        }
        NSMutableArray *array = [NSMutableArray array];
        for (PaymentExpDetail *model in weakSelf.FormDatas.arr_DetailsDataArray) {
            if ([NSString isEqualToNullAndZero:model.ExpId]) {
                [array addObject:[NSString stringWithFormat:@"%@",model.ExpId]];
            }
        }
        PayMentDetailLeadController *vc = [[PayMentDetailLeadController alloc]init];
        vc.dict_parameter = @{@"UserId":weakSelf.FormDatas.personalData.RequestorUserId,
                              @"OwnerUserId":weakSelf.FormDatas.personalData.OperatorUserId,
                              @"TaskId":[NSString isEqualToNull:weakSelf.FormDatas.str_taskId] ? weakSelf.FormDatas.str_taskId:@"0",
                              @"ExpIds":array,
                              };
        vc.importDetailBackBlock = ^(NSMutableArray * _Nonnull array) {
            for (PaymentExpDetail *pay in array) {
                maxNo = maxNo + 1;
                pay.PaymentOrderNo = [NSString stringWithFormat:@"%ld",(long)maxNo];
                [weakSelf.FormDatas.arr_DetailsDataArray addObject:pay];
            }
            [weakSelf.PaymentExpDetailView updateTableView];
            if ([weakSelf.userdatas.multiCyPayment isEqualToString:@"1"] && weakSelf.FormDatas.arr_DetailsDataArray.count > 0) {
                NSString *amount = @"0";
                for (PaymentExpDetail *pay in weakSelf.FormDatas.arr_DetailsDataArray) {
                    amount = [GPUtils decimalNumberAddWithString:amount with:pay.InvPmtAmount];
                }
                weakSelf.txf_Amount.text = [GPUtils getRoundingOffNumber:amount afterPoint:2];
                weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.txf_Amount.text];
                NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
                local = [GPUtils getRoundingOffNumber:local afterPoint:2];
                weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
                NSString *airLoc = [NSString stringWithFormat:@"%@",local];
                if ([weakSelf.FormDatas.str_InvoiceType isEqualToString:@"1"] && [weakSelf.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                    airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                }
                weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:weakSelf.txf_TaxRate.text]?weakSelf.txf_TaxRate.text:@"0"];
                weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
            }
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
//MARK:更新是否提交发票
-(void)updateHasInvoiceViewWithModel:(MyProcurementModel *)model{
    
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        model.fieldValue = Custing(@"否", nil);
        self.FormDatas.str_HasInvoice = @"0";
    }else{
        model.fieldValue = Custing(@"是", nil);
        self.FormDatas.str_HasInvoice = @"1";
    }
    _txf_HasInvoice = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_HasInvoice WithContent:_txf_HasInvoice WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_HasInvoice = Model.Id;
            weakSelf.txf_HasInvoice.text = Model.Type;
            [weakSelf checkShowNoInvReasonView];
        }];
        picker.typeTitle = Custing(@"本次付款是否提交发票", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_HasInvoice;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_HasInvoice addSubview:view];
}
//MARK:更新无发票要原因视图
-(void)updateNoInvReasonView:(MyProcurementModel *)model{
    _txf_NoInvReason = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_NoInvReason WithContent:_txf_NoInvReason WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_NoInvReason addSubview:view];
}
//MARK:修改付款是否需要提交发票导致无发票要原因视图
-(void)checkShowNoInvReasonView{
    NSInteger height = 0;
    if (_txf_NoInvReason && [self.FormDatas.str_HasInvoice isEqualToString:@"0"]) {
        height = 60;
    }
    [_View_NoInvReason mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    if (height == 0) {
        self.txf_NoInvReason.text = @"";
    }
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount = 10;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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
//MARK:更新是否本部门承担费用视图
-(void)updateIsDeptBearExpsViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        model.fieldValue = Custing(@"否", nil);
        self.FormDatas.str_IsDeptBearExps = @"0";
    }else{
        model.fieldValue = Custing(@"是", nil);
        self.FormDatas.str_IsDeptBearExps = @"1";
    }
    _txf_IsDeptBearExps = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_IsDeptBearExps WithContent:_txf_IsDeptBearExps WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_IsDeptBearExps = Model.Id;
            weakSelf.txf_IsDeptBearExps.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"是否本部门承担费用", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_IsDeptBearExps;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_IsDeptBearExps addSubview:view];
}
//MARK:更新备注
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新发票
-(void)updateFilesViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_File withEditStatus:1 withModel:model];
    view.maxCount = 10;
    [_View_File addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_TolfilesArray WithImgArray:self.FormDatas.arr_filesArray];
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
    //    [_View_CcToPeople addSubview:[[ExmineApproveView alloc]initWithBaseView:_View_CcToPeople Withmodel:model WithInfodict:@{@"array":self.FormDatas.arr_CcToArr}]];
    
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}
//MARK:更新报销政策视图
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
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}

//修改关联付款单
-(void)RelPaymentFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"PaymentApp"];
    vc.ChooseCategoryId = self.FormDatas.str_RelPaymentNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars = @{@"Type":self.FormDatas.str_RelatedPaymentType,@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_RelPaymentInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_RelPaymentNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_RelPaymentInfo]                               };
        [weakSelf.View_RelPay updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改币种
-(void)changeCurrency{
    [self keyClose];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_CurrencyCode = Model.Id;
        weakSelf.FormDatas.str_Currency = Model.Type;
        weakSelf.txf_CurrencyCode.text = Model.Type;
        weakSelf.txf_ExchangeRate.text = Model.exchangeRate;
        weakSelf.FormDatas.str_ExchangeRate = Model.exchangeRate;
        NSString *local = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
        NSString *airLoc = [NSString stringWithFormat:@"%@",local];
        if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"] && [self.FormDatas.str_InvoiceTypeCode isEqualToString:@"1004"]) {
            airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        }
        weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:[NSString isEqualToNull:self.txf_TaxRate.text]?self.txf_TaxRate.text:@"0"];
        weakSelf.txf_ExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_Tax.text]];
        [weakSelf updateForeignCurrencyViews];
    }];
    picker.typeTitle = Custing(@"币种", nil);
    picker.DateSourceArray = self.FormDatas.arr_CurrencyCode;
    STOnePickModel *model = [[STOnePickModel alloc]init];
    model.Id = [NSString isEqualToNull: self.FormDatas.str_CurrencyCode]?self.FormDatas.str_CurrencyCode:@"";
    picker.Model = model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:费用类别点击
-(void)CateBtnClick:(UIButton *)btn{
    [self keyClose];
    if (self.FormDatas.arr_CategoryArr.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    NSString *CateLevel = self.FormDatas.dict_CategoryParameter[@"CateLevel"];
    if ([CateLevel isEqualToString:@"1"]) {
        [self updateCateGoryView];
    }else if ([CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray = self.FormDatas.arr_CategoryArr;
        CostCateNewSubModel *model = [[CostCateNewSubModel alloc]init];
        model.expenseCode = self.FormDatas.str_ExpenseCode;
        pickerArea.CateModel = model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        pickerArea.str_flowCode=@"F0009";
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            [weakSelf keyClose];
            if (![secondModel.expenseCode isEqualToString:weakSelf.FormDatas.str_ExpenseCode]) {
                weakSelf.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.FormDatas.str_ExpenseType = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.FormDatas.str_ExpenseCode = secondModel.expenseCode;
                weakSelf.FormDatas.str_ExpenseIcon = secondModel.expenseIcon;
                weakSelf.FormDatas.str_ExpenseCat = secondModel.expenseCat;
                weakSelf.FormDatas.str_ExpenseCatCode = secondModel.expenseCatCode;
                weakSelf.FormDatas.str_CateSubDesc = secondModel.expenseDesc;
                weakSelf.FormDatas.str_AccountItemCode = secondModel.accountItemCode;
                weakSelf.FormDatas.str_AccountItem = [GPUtils getSelectResultWithArray:@[secondModel.accountItemCode,secondModel.accountItem] WithCompare:@"/"];
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
                [weakSelf updateCateSubDescView];
                [weakSelf updateInvoiceTypeReleExpenseTypeViewWithType:2];
            }
        }];
        [pickerArea show];
    }else if([CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = self.FormDatas.arr_CategoryArr;
        ex.str_CateLevel = CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseCode isEqualToString:weakSelf.FormDatas.str_ExpenseCode]) {
                weakSelf.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.FormDatas.str_ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.FormDatas.str_ExpenseCode = model.expenseCode;
                weakSelf.FormDatas.str_ExpenseIcon = model.expenseIcon;
                weakSelf.FormDatas.str_ExpenseCat = model.expenseCat;
                weakSelf.FormDatas.str_ExpenseCatCode = model.expenseCatCode;
                weakSelf.FormDatas.str_CateSubDesc = model.expenseDesc;
                weakSelf.FormDatas.str_AccountItemCode = model.accountItemCode;
                weakSelf.FormDatas.str_AccountItem = [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem] WithCompare:@"/"];
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                [weakSelf updateCateSubDescView];
                [weakSelf updateInvoiceTypeReleExpenseTypeViewWithType:2];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}
-(void)updateCateGoryView{
    self.FormDatas.bool_isOpenCate = !self.FormDatas.bool_isOpenCate;
    if (self.FormDatas.bool_isOpenCate) {
        NSInteger categoryRows = [self.FormDatas.dict_CategoryParameter[@"categoryRows"] integerValue];
        if (categoryRows == 0) {
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }else{
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*categoryRows)+10));
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*categoryRows)+10));
            }];
        }
        [_CategoryCollectView reloadData];
    }else{
        [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
//MARK:修改费用申请单
-(void)FeeFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId = self.FormDatas.str_FeeAppNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_EstimatedAmount = @"0";
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
            weakSelf.FormDatas.str_EstimatedAmount = [GPUtils decimalNumberAddWithString:model.localCyAmount with:weakSelf.FormDatas.str_EstimatedAmount];
        }
        weakSelf.FormDatas.str_FeeAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_FeeAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        weakSelf.txf_Estimated.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo]                               };
        [weakSelf.View_FeeAppForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改采购申请单
-(void)PurchaseFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"PurchaseNumber"];
    vc.ChooseCategoryId = self.FormDatas.str_PurchaseNumber;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_PurchaseInfo = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"];
        weakSelf.FormDatas.str_PurchaseNumber = [NSString stringWithIdOnNO:model.taskId];
        weakSelf.FormDatas.str_PurAmount = [NSString stringWithIdOnNO:model.totalAmount];
        if ([NSString isEqualToNull:model.totalAmount] && [NSString isEqualToNull:model.paidAmount]) {
            weakSelf.FormDatas.str_PurOverAmount = [GPUtils decimalNumberSubWithString:model.totalAmount with:model.paidAmount];
        }
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo]                               };
        [weakSelf.View_PurchaseForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改合同
-(void)ContractClick{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:self.FormDatas.int_isContractPaymentMethod == 1 ? @"ContractsIs":@"Contracts"];
    vc.ChooseCategoryId = self.FormDatas.str_ContractAppNumber;
    vc.dict_otherPars = @{@"Type":@"2",@"FlowGuid":self.FormDatas.str_flowGuid};
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.model_ContractHas = model;
        
        weakSelf.FormDatas.str_ContractAppNumber = model.taskId;
        weakSelf.FormDatas.str_ContractNo = model.contractNo;
        weakSelf.FormDatas.str_ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName]];
        weakSelf.FormDatas.str_ContractAmount = model.totalAmount;
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_ContractAppNumber],
                               @"Value":[NSString stringWithIdOnNO:weakSelf.FormDatas.str_ContractName]                               };
        [weakSelf.View_ContractName updateView:dict];
        
        weakSelf.txf_ContEffectiveDate.text = model.effectiveDateStr;
        weakSelf.txf_ContExpiryDate.text = model.expiryDateStr;
        weakSelf.FormDatas.str_ContPmtTypId = model.payCode;
        weakSelf.FormDatas.str_ContPmtTyp = model.payMode;
        weakSelf.txf_ContPmtTyp.text = model.payMode;
        
        weakSelf.FormDatas.personalData.SupplierName = model.partyB;
        weakSelf.FormDatas.personalData.SupplierId = model.partyBId;
        weakSelf.txf_Supplier.text = model.partyB;
        weakSelf.txf_BankAccount.text = model.bankAccount;
        weakSelf.txf_BankName.text = model.bankName;
        weakSelf.txf_IbanClientName.text = model.clientName;
        weakSelf.txf_IbanClientAddr.text = model.clientAddr;
        weakSelf.txf_IbanName.text = model.ibanName;
        weakSelf.txf_IbanAccount.text = model.ibanAccount;
        weakSelf.txf_IbanAddr.text = model.ibanAddr;
        weakSelf.txf_SwiftCode.text = model.swiftCode;
        weakSelf.txf_IbanNo.text = model.ibanNo;
        weakSelf.txf_IbanADDRESS.text = model.ibanADDRESS;
        weakSelf.FormDatas.str_ContractOverAmount = [GPUtils decimalNumberSubWithString:model.totalAmount with:model.paidAmount];
        
        if (self.FormDatas.int_isContractPaymentMethod == 1) {
            [weakSelf updateContractPayDetail];
        }
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
//MARK:修改受益人
-(void)BeneficiariesClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"11";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_BnfId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople = array;
    contactVC.menutype = 2;
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
        weakSelf.FormDatas.str_BnfId = [GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_BnfName = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_Bnf.text = weakSelf.FormDatas.str_BnfName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:审批人选择
-(void)ApproveClick{
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
    contactVC.itemType = 9;
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
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}

//MARK:tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_View_table) {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_View_table) {
        return self.FormDatas.arr_table.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_table){
        return 40;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (tableView==_View_table) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text =self.FormDatas.arr_table[indexPath.row];
        cell.textLabel.font = Font_Same_14_20;
        return cell;
    }
    return [[UITableViewCell alloc]init];
}
//MARK:UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 10);
    }
    return CGSizeZero;
}
//MARK:CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _CategoryCollectView) {
        return self.FormDatas.arr_CategoryArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _CategoryCollectView) {
        _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
        [_cell configWithArray:self.FormDatas.arr_CategoryArr withRow:indexPath.row];
        return _cell;
    }
    return [UICollectionViewCell new];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _CategoryCollectView) {
        [self keyClose];
        CostCateNewModel *model = self.FormDatas.arr_CategoryArr[indexPath.row];
        if (![model.expenseCode isEqualToString:self.FormDatas.str_ExpenseCode]) {
            self.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
            self.FormDatas.str_ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
            self.FormDatas.str_ExpenseCode = model.expenseCode;
            self.FormDatas.str_ExpenseIcon = model.expenseIcon;
            self.FormDatas.str_ExpenseCat = model.expenseCat;
            self.FormDatas.str_ExpenseCatCode = model.expenseCatCode;
            self.FormDatas.str_CateSubDesc = model.expenseDesc;
            self.FormDatas.str_AccountItemCode = model.accountItemCode;
            self.FormDatas.str_AccountItem = [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem] WithCompare:@"/"];
            self.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            [self updateCateSubDescView];
            [self updateCateGoryView];
            [self updateInvoiceTypeReleExpenseTypeViewWithType:2];
        }else{
            [self updateCateGoryView];
        }
    }
}
//MARK:分摊返回
-(void)ReimShareData:(ReimShareModel *)model WithType:(NSInteger)type{
    if (type == 1) {
        [self.FormDatas.arr_ShareData addObject:model];
    }
    [_ReimShareMainView updateMainView];
}
//MARK:数据的保存
-(void)saveInfo{
    [self keyClose];
    self.dockView.userInteractionEnabled = NO;
    self.FormDatas.int_SubmitSaveType = 1;
    [self mainDataList];
}
//MARK:数据的提交
-(void)submitInfo{
    [self keyClose];
    self.dockView.userInteractionEnabled = NO;
    self.FormDatas.int_SubmitSaveType = 2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled = NO;
    self.FormDatas.int_SubmitSaveType = 3;
    [self mainDataList];
}
//MARK:提交保存数据处理
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    [self.FormDatas getSubmitSaveIdString];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str = [self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled = YES;
            return;
        }
    }
    if (self.FormDatas.bool_IsHasShowProject && (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3) && [NSString isEqualToNullAndZero:self.FormDatas.personalData.CostCenterId]) {
        
        [[GPClient shareGPClient]REquestByPostWithPath:XB_ProjsByCostcenter Parameters:[self.FormDatas getProjsByCostcenterParam] Delegate:self SerialNum:4 IfUserCache:NO];
    }else{
        [self getExpShareApprovalId];
    }
}
-(void)configModelOtherData{
    
    self.FormDatas.SubmitData.Reason = self.txv_Reason.text;
    self.FormDatas.SubmitData.ApplicationType = self.FormDatas.str_ApplicationType;
    self.FormDatas.SubmitData.IsPayment = self.FormDatas.str_IsPayment;
    self.FormDatas.SubmitData.LocalCyAmount = _txf_Amount.text;
    self.FormDatas.SubmitData.CapitalizedAmount = [NSString getChineseMoneyByString:self.FormDatas.SubmitData.LocalCyAmount];
    NSString *LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate] ? self.FormDatas.str_ExchangeRate:@"1.0000")];
    LocalCyAmount = [GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    self.FormDatas.SubmitData.TotalAmount = LocalCyAmount;
    self.FormDatas.SubmitData.PaymentDate = _txf_PaymentDate.text;
    self.FormDatas.SubmitData.ExpenseDesc = _txf_ExpenseDesc.text;
    self.FormDatas.SubmitData.AirlineFuelFee = (_View_AirlineFuelFee.zl_height > 0 && [NSString isEqualToNull:_txf_AirlineFuelFee.text]) ?_txf_AirlineFuelFee.text:@"";
    self.FormDatas.SubmitData.AirTicketPrice = (_View_AirTicketPrice.zl_height > 0 && [NSString isEqualToNull:_txf_AirTicketPrice.text]) ?_txf_AirTicketPrice.text:@"";
    self.FormDatas.SubmitData.DevelopmentFund = (_View_DevelopmentFund.zl_height > 0 && [NSString isEqualToNull:_txf_DevelopmentFund.text]) ?_txf_DevelopmentFund.text:@"";
    self.FormDatas.SubmitData.FuelSurcharge = (_View_FuelSurcharge.zl_height > 0 && [NSString isEqualToNull:_txf_FuelSurcharge.text]) ?_txf_FuelSurcharge.text:@"";
    self.FormDatas.SubmitData.OtherTaxes = (_View_OtherTaxes.zl_height > 0 && [NSString isEqualToNull:_txf_OtherTaxes.text]) ?_txf_OtherTaxes.text:@"";

    self.FormDatas.SubmitData.TaxRate = (_View_TaxRate.zl_height > 0 && [NSString isEqualToNull:_txf_TaxRate.text]) ?_txf_TaxRate.text:@"";
    if (_View_Tax.zl_height > 0 && self.txf_Tax) {
        self.FormDatas.SubmitData.Tax = self.txf_Tax.text;
    }else{
        self.FormDatas.SubmitData.Tax = [NSString countTax:LocalCyAmount taxrate:self.FormDatas.SubmitData.TaxRate];
    }
    self.FormDatas.SubmitData.ExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:LocalCyAmount with:self.FormDatas.SubmitData.Tax] afterPoint:2];
    self.FormDatas.SubmitData.OverBudReason = _txv_OverBudReason.text;
    self.FormDatas.SubmitData.ContEffectiveDate = _txf_ContEffectiveDate.text;
    self.FormDatas.SubmitData.ContExpiryDate = _txf_ContExpiryDate.text;
    self.FormDatas.SubmitData.BankHeadOffice = _txf_BankHeadOffice.text;
    
    self.FormDatas.SubmitData.IbanClientName= self.View_IbanClientName.zl_height > 0 ? self.txf_IbanClientName.text:@"";
    self.FormDatas.SubmitData.IbanClientAddr= self.View_IbanClientAddr.zl_height > 0 ? self.txf_IbanClientAddr.text:@"";
    self.FormDatas.SubmitData.IbanName= self.View_IbanName.zl_height > 0 ? self.txf_IbanName.text:@"";
    self.FormDatas.SubmitData.IbanAccount= self.View_IbanAccount.zl_height > 0 ? self.txf_IbanAccount.text:@"";
    self.FormDatas.SubmitData.IbanAddr= self.View_IbanAddr.zl_height > 0 ? self.txf_IbanAddr.text:@"";
    self.FormDatas.SubmitData.IbanSwiftCode= self.View_SwiftCode.zl_height > 0 ? self.txf_SwiftCode.text:@"";
    self.FormDatas.SubmitData.IbanNo = self.View_IbanNo.zl_height > 0 ? self.txf_IbanNo.text:@"";
    self.FormDatas.SubmitData.IbanADDRESS = self.View_IbanADDRESS.zl_height > 0 ? self.txf_IbanADDRESS.text:@"";

    self.FormDatas.SubmitData.RefInvoiceAmount = self.txf_RefInvoiceAmount .text;
    self.FormDatas.SubmitData.RefTaxRate = self.txf_RefTaxRate.text;
    self.FormDatas.SubmitData.RefTax = self.txf_RefTax.text;;
    self.FormDatas.SubmitData.RefExclTax = [self.txf_RefExclTax.text stringByReplacingOccurrencesOfString:@"," withString:@""];;
    self.FormDatas.SubmitData.NoInvReason = self.View_NoInvReason.zl_height > 0 ? self.txf_NoInvReason.text:@"";
    
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
    
    //修改超预算必填判断
    if ([self.FormDatas.SubmitData.EstimatedAmount floatValue]>0) {
        [[GPUtils decimalNumberSubWithString:self.FormDatas.SubmitData.TotalAmount with:self.FormDatas.SubmitData.EstimatedAmount]floatValue]>0 ? [self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:@"OverBudReason"]:[self.FormDatas.dict_isRequiredmsdic setValue:@"0" forKey:@"OverBudReason"];
    }
}
//MARK:获取分摊审批者Id
-(void)getExpShareApprovalId{
    [[GPClient shareGPClient]REquestByPostWithPath:GETCOSTSHAREAPPROVALID Parameters:[self.FormDatas getExpShareApprovalIdParam] Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:准备提交保存
-(void)readySaveAndSubmit{
    [self.FormDatas contectData];
    if (self.FormDatas.int_SubmitSaveType == 1) {
        [self dealWithImagesArray];
    }else if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        [self checkTravelReimSubmit];
    }
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
        if (hasError) {
            [YXSpritesLoadingView dismiss];
            weakSelf.dockView.userInteractionEnabled = YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.FormDatas.str_imageDataString = data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf dealWithFilesArray];
        }
    }];
}
//MARK:处理附件数组
-(void)dealWithFilesArray{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_TolfilesArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled = YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            [weakSelf.FormDatas addAttFileInfoWithKey:@"Files" withData:data];
            if (weakSelf.FormDatas.int_isContractPaymentMethod == 1 && weakSelf.FormDatas.model_ContractHas) {
                [weakSelf requestGetContractForms];
            }else{
                [weakSelf readySubmitAndSave];
            }
        }
    }];
}
//MARK:获取合同相关信息
-(void)requestGetContractForms{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getContractFormsUrl] Parameters:[self.FormDatas getContractFormsParame] Delegate:self SerialNum:6 IfUserCache:NO];
}
//MARK:保存提交操作
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
-(void)requestAppSave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.FormDatas SaveFormDateWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:@""]];
    if (self.FormDatas.bool_isSameContract) {
        [dict setObject:self.FormDatas.SubmitData.LocalCyAmount forKey:@"Amount"];
        [dict setObject:self.FormDatas.model_ContractHas.gridOrder forKey:@"ContGridOrder"];
        [dict setObject:self.FormDatas.model_ContractHas.taskId forKey:@"ContractNumber"];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:第一次提交验证
-(void)checkTravelReimSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getCheckSubmitUrl] Parameters:[self.FormDatas GetCheckSubmitWithAmount:self.FormDatas.SubmitData.TotalAmount WithExpIds:@"" otherParameters:[self.FormDatas getCheckSubmitOtherPar]] Delegate:self SerialNum:14 IfUserCache:NO];
}
//MARK:验证完成提交
-(void)requestAppSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.FormDatas SubmitFormDateWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:[self.FormDatas getCommonField]]];
    if (self.FormDatas.bool_isSameContract) {
        [dict setObject:self.FormDatas.SubmitData.LocalCyAmount forKey:@"Amount"];
        [dict setObject:self.FormDatas.model_ContractHas.gridOrder forKey:@"ContGridOrder"];
        [dict setObject:self.FormDatas.model_ContractHas.taskId forKey:@"ContractNumber"];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:dict Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas = self.FormDatas;
    vc.str_CommonField = [self.FormDatas getCommonField];
    if (self.FormDatas.bool_isSameContract) {
        vc.bool_AddPars = YES;
        vc.str_PayAmount = self.FormDatas.SubmitData.LocalCyAmount;
        vc.str_PayContGridOrder = self.FormDatas.model_ContractHas.gridOrder;
        vc.str_PayContractNumber = self.FormDatas.model_ContractHas.taskId;
    }
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.FormDatas SubmitFormAgainWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:[self.FormDatas getCommonField]]];
    if (self.FormDatas.bool_isSameContract) {
        [dict setObject:self.FormDatas.SubmitData.LocalCyAmount forKey:@"Amount"];
        [dict setObject:self.FormDatas.model_ContractHas.gridOrder forKey:@"ContGridOrder"];
        [dict setObject:self.FormDatas.model_ContractHas.taskId forKey:@"ContractNumber"];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:dict Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas = self.FormDatas;
    vc.str_CommonField = [self.FormDatas getCommonField];
    if (self.FormDatas.bool_isSameContract) {
        vc.bool_AddPars = YES;
        vc.str_PayAmount = self.FormDatas.SubmitData.LocalCyAmount;
        vc.str_PayContGridOrder = self.FormDatas.model_ContractHas.gridOrder;
        vc.str_PayContractNumber = self.FormDatas.model_ContractHas.taskId;
    }
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
