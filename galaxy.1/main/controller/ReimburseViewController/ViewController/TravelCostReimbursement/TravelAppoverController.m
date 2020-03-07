//
//  TravelAppoverController.m
//  galaxy
//
//  Created by hfk on 2017/8/31.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "TravelAppoverController.h"

@interface TravelAppoverController ()

@end

@implementation TravelAppoverController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[travelReimFormDate alloc]initWithStatus:3];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_flowCode=self.pushFlowCode;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeStatus=[self.pushComeStatus integerValue];
        self.FormDatas.int_comeEditType = [self.pushComeEditType integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
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
    if (self.FormDatas.int_comeStatus==3){
        [self saveAndSubmitBtn];
    }else if (self.FormDatas.int_comeStatus==4){
        [self readlyPay];
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
//MARK:确认支付按钮
-(void)readlyPay
{
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"确认支付" , nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf dockViewClick:3];
        }
    };
}

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
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
   
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
    
    _View_table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 200) style:UITableViewStylePlain];
    _View_table.delegate = self;
    _View_table.dataSource = self;
    _View_table.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//MARK:创建主视图
-(void)createMainView{
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_PrivateAmount=[[UIView alloc]init];
    _View_PrivateAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PrivateAmount];
    [_View_PrivateAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CurrencySumView = [[BaseFormSumView alloc]init];
    _CurrencySumView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CurrencySumView];
    [_CurrencySumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PrivateAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CostCateSumView = [[BaseFormSumView alloc]init];
    _CostCateSumView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CostCateSumView];
    [_CostCateSumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CurrencySumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Detail=[[UIView alloc]init];
    _View_Detail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Detail];
    [_View_Detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CostCateSumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DetailsTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_DetailsTable.backgroundColor=Color_White_Same_20;
    _View_DetailsTable.delegate=self;
    _View_DetailsTable.dataSource=self;
    _View_DetailsTable.scrollEnabled=NO;
    _View_DetailsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Detail.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayeeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_PayeeTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_PayeeTable.delegate=self;
    _View_PayeeTable.dataSource=self;
    _View_PayeeTable.scrollEnabled=NO;
    _View_PayeeTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PayeeTable];
    [_View_PayeeTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimShareMainView = [[ReimShareMainView alloc]init];
    _ReimShareMainView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ReimShareMainView];
    [_ReimShareMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayeeTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimShareDeptSumView = [[BaseFormSumView alloc]init];
    _ReimShareDeptSumView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ReimShareDeptSumView];
    [_ReimShareDeptSumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareMainView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ClaimType = [[UIView alloc]init];
    _View_ClaimType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClaimType];
    [_View_ClaimType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareDeptSumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClaimType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Beneficiaries=[[UIView alloc]init];
    _View_Beneficiaries.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Beneficiaries];
    [_View_Beneficiaries mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Beneficiaries.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0001"];
    _View_TravelForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TravelForm];
    [_View_TravelForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelType=[[UIView alloc]init];
    _View_TravelType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TravelType];
    [_View_TravelType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelevantDept=[[UIView alloc]init];
    _View_RelevantDept.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelevantDept];
    [_View_RelevantDept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FinancialSource = [[UIView alloc]init];
    _View_FinancialSource.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FinancialSource];
    [_View_FinancialSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelevantDept.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromDate=[[UIView alloc]init];
    _View_FromDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromDate];
    [_View_FromDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FinancialSource.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToDate=[[UIView alloc]init];
    _View_ToDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToDate];
    [_View_ToDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromCity = [[UIView alloc]init];
    _View_FromCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromCity];
    [_View_FromCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToCity = [[UIView alloc]init];
    _View_ToCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToCity];
    [_View_ToCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_FellowOfficers=[[UIView alloc]init];
    _View_FellowOfficers.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FellowOfficers];
    [_View_FellowOfficers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Estimated=[[UIView alloc]init];
    _View_Estimated.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Estimated];
    [_View_Estimated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FellowOfficers.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_OverBud=[[UIView alloc]init];
    _View_OverBud.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OverBud];
    [_View_OverBud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Estimated.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StaffOutForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0016"];
    _View_StaffOutForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StaffOutForm];
    [_View_StaffOutForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBud.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VehicleForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0014"];;
    _View_VehicleForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VehicleForm];
    [_View_VehicleForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StaffOutForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BorrowingForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0006"];
    _View_BorrowingForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BorrowingForm];
    [_View_BorrowingForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Loan=[[UIView alloc]init];
    _View_Loan.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Loan];
    [_View_Loan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BorrowingForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Actual=[[UIView alloc]init];
    _View_Actual.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Actual];
    [_View_Actual mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Loan.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CompanyAmount=[[UIView alloc]init];
    _View_CompanyAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CompanyAmount];
    [_View_CompanyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Actual.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalAmount=[[UIView alloc]init];
    _View_TotalAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalAmount];
    [_View_TotalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CompanyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized=[[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_NoInvoice=[[UIView alloc]init];
    _View_NoInvoice.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_NoInvoice];
    [_View_NoInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvLoanAmount = [[UIView alloc]init];
    _View_InvLoanAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvLoanAmount];
    [_View_InvLoanAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_NoInvoice.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvTotalAmount = [[UIView alloc]init];
    _View_InvTotalAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvTotalAmount];
    [_View_InvTotalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvLoanAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvActualAmount = [[UIView alloc]init];
    _View_InvActualAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvActualAmount];
    [_View_InvActualAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvTotalAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvActualAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    
    _View_DocumentNum=[[UIView alloc]init];
    _View_DocumentNum.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_DocumentNum];
    [_View_DocumentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PmtMethodTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_PmtMethodTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_PmtMethodTable.delegate=self;
    _View_PmtMethodTable.dataSource=self;
    _View_PmtMethodTable.scrollEnabled=NO;
    _View_PmtMethodTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PmtMethodTable];
    [_View_PmtMethodTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DocumentNum.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PmtMethodAdd=[[UIView alloc]init];
    _View_PmtMethodAdd.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_PmtMethodAdd];
    [_View_PmtMethodAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PmtMethodTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SecDetailsTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_SecDetailsTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_SecDetailsTable.delegate=self;
    _View_SecDetailsTable.dataSource=self;
    _View_SecDetailsTable.scrollEnabled=NO;
    _View_SecDetailsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_SecDetailsTable];
    [_View_SecDetailsTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PmtMethodAdd.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Payee=[[UIView alloc]init];
    _View_Payee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Payee];
    [_View_Payee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SecDetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount=[[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Payee.bottom);
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
    
    _View_PmtMethod=[[UIView alloc]init];
    _View_PmtMethod.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PmtMethod];
    [_View_PmtMethod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_BudgetSubDate=[[UIView alloc]init];
    _View_BudgetSubDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BudgetSubDate];
    [_View_BudgetSubDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PmtMethod.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiptOfInv=[[UIView alloc]init];
    _View_ReceiptOfInv.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiptOfInv];
    [_View_ReceiptOfInv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BudgetSubDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _Reserved1View=[[UIView alloc]init];
    _Reserved1View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved1View];
    [_Reserved1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiptOfInv.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _Reserved2View=[[UIView alloc]init];
    _Reserved2View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved2View];
    [_Reserved2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved3View=[[UIView alloc]init];
    _Reserved3View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved3View];
    [_Reserved3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved2View .bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved4View=[[UIView alloc]init];
    _Reserved4View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved4View];
    [_Reserved4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved3View .bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved5View=[[UIView alloc]init];
    _Reserved5View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved5View];
    [_Reserved5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved4View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved6View=[[UIView alloc]init];
    _Reserved6View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved6View];
    [_Reserved6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved5View .bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved7View=[[UIView alloc]init];
    _Reserved7View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved7View];
    [_Reserved7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved6View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved8View=[[UIView alloc]init];
    _Reserved8View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved8View];
    [_Reserved8View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved7View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved9View=[[UIView alloc]init];
    _Reserved9View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved9View];
    [_Reserved9View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved8View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _Reserved10View=[[UIView alloc]init];
    _Reserved10View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_Reserved10View];
    [_Reserved10View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved9View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsDeptBearExps = [[UIView alloc]init];
    _View_IsDeptBearExps.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsDeptBearExps];
    [_View_IsDeptBearExps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved10View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsDeptBearExps.bottom);
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
    //预算
    _View_Budget=[[UIView alloc]init];
    _View_Budget.backgroundColor=Color_WhiteWeak_Same_20;
    _View_Budget.backgroundColor=Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_View_Budget];
    [_View_Budget makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _FormSignInfoView = [[FormSignInfoView alloc]init];
    [self.contentView addSubview:_FormSignInfoView];
    [_FormSignInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Budget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormSignInfoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
}
//MARK:-网络请求
//第一次打开表单和保存后打开表单接口
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
//MARK:验证预算
-(void)judgeBudget{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getApproveJudgeUrl] Parameters:[self.FormDatas getApproveJudgeParameter] Delegate:self SerialNum:14 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    self.FormDatas.dict_resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        self.PrintfBtn.userInteractionEnabled=YES;
        self.dockView.userInteractionEnabled=YES;
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
        case 14:
        {
            if ([self.FormDatas getVerifyBudegt]==0) {
                [self approveandpay];
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
    self.PrintfBtn.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}
-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];

    
    [_SubmitPersonalView initApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithSumbitBaseModel:self.FormDatas];

    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        
        if ([model.fieldName isEqualToString:@"SumAmount"]) {
            self.FormDatas.str_amountPrivate=[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updatePriveateAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"ClaimType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateClaimTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BnfId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBeneficiariesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateTravelFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateTravelTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelevantDept"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateRelevantDeptViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FinancialSource"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateFinancialSourceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateTravelDuringViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateFromCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ToCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateToCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FellowOfficers"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateTravelFellowOfficersViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateEstimatedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OverBudReason"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateOverBudViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"StaffOutNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateStaffOutNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateVehicleNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AdvanceNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBorrowFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LoanAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateLoanViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ActualAmount"]){
            self.FormDatas.str_amountActual=[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateActualViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CorpPayAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateCompanyAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
            self.FormDatas.str_amountTotal=[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            self.FormDatas.str_lastAmount =[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateTotalAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateCapitalizedAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"NoInvAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateNoInvAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvLoanAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateInvLoanAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvTotalAmount"]){
            self.FormDatas.str_InvTotalAmount = [NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvTotalAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"InvActualAmount"]){
            self.FormDatas.str_InvActualAmount = [NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateInvActualAmountViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCurrencyCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"NumberOfDocuments"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateDocumentNumViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Payee"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePayeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankOutlets"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankOutletsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PmtMethod"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePmtMethodViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BudgetSubDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&(self.FormDatas.int_comeEditType == 1 || self.FormDatas.int_comeEditType == 3 || self.FormDatas.int_comeEditType == 5 || self.FormDatas.int_comeEditType == 7)){
            [self updateBudgetSubDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsReceiptOfInv"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReceiptOfInvViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved1ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved2"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved2ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved3"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved3ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved4"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved4ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved5"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved5ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved6"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved6ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved7"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved7ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved8"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved8ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved9"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved9ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved10"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReserved10ViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsDeptBearExps"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateIsDeptBearExpsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            [self updateAttachImgViewWithModel:model];
        }else  if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateApproveViewWithModel:model];
        }
        
    }
    if (![self.FormDatas.arr_sonItem isKindOfClass:[NSNull class]]&&self.FormDatas.arr_sonItem.count!=0) {
        [self updateDetailView];
        [self updateDetailsTableView];
    }
    if (self.FormDatas.bool_isShowCurrencySum && self.FormDatas.arr_CurrencySum.count > 0) {
        [_CurrencySumView updateBaseFormSumViewWithData:self.FormDatas WithType:1];
    }
    if (self.FormDatas.arr_travelSum.count!=0) {
        [_CostCateSumView updateBaseFormSumViewWithData:self.FormDatas WithType:2];
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
    //    if (![_budgetInfoDict isKindOfClass:[NSNull class]]&&_budgetInfoDict.count>0) {
    //    }
    
    //签收记录
    if (self.FormDatas.dict_SignInfo) {
        [_FormSignInfoView updateView:self.FormDatas.dict_SignInfo];
    }
    //审批记录
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    //预算
    if (self.FormDatas.dict_budgetInfo && self.FormDatas.dict_budgetInfo.count > 0) {
           [self updateBudgetNote];
       }
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
  
    if (self.FormDatas.int_comeEditType == 2 || self.FormDatas.int_comeEditType == 3 || self.FormDatas.int_comeEditType == 6 || self.FormDatas.int_comeEditType == 7) {
        if (self.FormDatas.bool_SecDetailsShow) {
            if (self.FormDatas.arr_SecDetailsDataArray.count==0) {
                pmtMethodDetail *model=[[pmtMethodDetail alloc]init];
                [self.FormDatas.arr_SecDetailsDataArray addObject:model];
            }
            [self updateSecDetailsTableView];
            [self updateSecAddDetailsView];
        }
    }else{
        if (self.FormDatas.bool_SecDetailsShow&&self.FormDatas.arr_SecDetailsDataArray.count!=0) {
            [self updateSecLookDetailsTableView];
            [_View_SecDetailsTable reloadData];
        }
    }
    
    if (self.FormDatas.bool_ThirDetailsShow&&self.FormDatas.arr_ThirDetailsDataArray.count!=0) {
        [self updatePayeeTable];
        [_View_PayeeTable reloadData];
    }

    [self updateContentView];
}

//MARK:更新报销金额视图
-(void)updatePriveateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_PrivateAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PrivateAmount WithContent:_txf_PrivateAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [view setOtherHeight:40];
    [_View_PrivateAmount addSubview:view];
    

}
//MARK:更新明细点击视图
-(void)updateDetailView{
    [_View_Detail updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
    }];
    UILabel *title=[GPUtils createLable:CGRectMake(0,0,70, 16) text:Custing(@"报销明细", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title.center=CGPointMake(12+35, 20);
    [_View_Detail addSubview:title];
    
    UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width/2, 0, Main_Screen_Width/2, 40) action:@selector(LookDetailClick:) delegate:self];
    [_View_Detail addSubview:btn];
    
    _ImV_DetailClick=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    _ImV_DetailClick.center=CGPointMake(Main_Screen_Width-12-10, 20);
    [_View_Detail addSubview:_ImV_DetailClick];
}
//MARK:更新明细详情视图
-(void)updateDetailsTableView{
    if (self.FormDatas.bool_isOpenDetail==YES) {
        _ImV_DetailClick.image=[UIImage imageNamed:@"skipImage"];
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else if(self.FormDatas.bool_isOpenDetail==NO){
        _ImV_DetailClick.image=[UIImage imageNamed:@"share_Open"];
        NSInteger height=0;
        for (HasSubmitDetailModel *model in self.FormDatas.arr_sonItem) {
            height+=[travelHasSubmitCell cellHeightWithObj:model];
        }
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        [_View_DetailsTable reloadData];
    }
}
//MARK:更新收款人
-(void)updatePayeeTable{
    if (self.FormDatas.bool_ThirisOpenDetail) {
        NSInteger height=10;
        for (PayeeDetails *model in self.FormDatas.arr_ThirDetailsDataArray) {
            height=height+[ProcureDetailsCell PayeeDetailCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
        }
        [_View_PayeeTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        PayeeDetails *model=self.FormDatas.arr_ThirDetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell PayeeDetailCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
        [_View_PayeeTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}
//MARK:更新分摊视图
-(void)updateReimShareViewWithType:(NSInteger)type{
    if (type == 1) {
        [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:3 WithComePlace:1];
        __weak typeof(self) weakSelf = self;
        [_ReimShareMainView setReimDoneClickedBlock:^(NSInteger type, NSInteger comeplace ,ReimShareModel *model) {
            ReimShareController *vc=[[ReimShareController alloc]init];
            vc.delegate=weakSelf;
            vc.type=type;
            vc.comeplace=comeplace;
            vc.model=model;
            vc.ShareFormArray=weakSelf.FormDatas.arr_ShareForm;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        [_ReimShareDeptSumView updateBaseFormSumViewWithData:self.FormDatas WithType:3];
    }
}
//MARK:更新报销类型视图
-(void)updateClaimTypeViewWithModel:(MyProcurementModel *)model{
    _txf_ClaimType=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ClaimType WithContent:_txf_ClaimType WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ClaimType addSubview:view];
}
//MARK:更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新受益人视图
-(void)updateBeneficiariesViewWithModel:(MyProcurementModel *)model{
    _txf_Beneficiaries=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Beneficiaries WithContent:_txf_Beneficiaries WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_Beneficiaries}];
    [_View_Beneficiaries addSubview:view];
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ProjName}];
    [_View_Project addSubview:view];
}

//MARK:更新客户视图
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ClientName}];
    [_View_Client addSubview:view];
}

//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.SupplierName}];
    [_View_Supplier addSubview:view];
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
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}

//MARK:更新出差类型
-(void)updateTravelTypeViewWithModel:(MyProcurementModel *)model{
    _txf_TravelType=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelType WithContent:_txf_TravelType WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TravelType addSubview:view];
}
//MARK:更新归口部门
-(void)updateRelevantDeptViewWithModel:(MyProcurementModel *)model{
    _txf_RelevantDept=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_RelevantDept WithContent:_txf_RelevantDept WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_RelevantDept addSubview:view];
}
//MARK:更新经费来源
-(void)updateFinancialSourceViewWithModel:(MyProcurementModel *)model{
    _txf_FinancialSource = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FinancialSource WithContent:_txf_FinancialSource WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_FinancialSource addSubview:view];
}
//MARK:更新出差期间
-(void)updateTravelDuringViewWithModel:(MyProcurementModel *)model{
    _txf_FromDate=[[UITextField alloc]init];
    model.Description = Custing(@"出发时间",nil);
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromDate WithContent:_txf_FromDate WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_FromDate addSubview:view];
    
    _txf_ToDate=[[UITextField alloc]init];
    model.Description = Custing(@"返回时间",nil);
    SubmitFormView *view1=[[SubmitFormView alloc]initBaseView:_View_ToDate WithContent:_txf_ToDate WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_ToDate}];
    [_View_ToDate addSubview:view1];
}
//MARK:更新出发地
-(void)updateFromCityViewWithModel:(MyProcurementModel *)model{
    _txf_FromCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_FromCity addSubview:view];
}
//MARK:更新目的地
-(void)updateToCityViewWithModel:(MyProcurementModel *)model{
    _txf_ToCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ToCity WithContent:_txf_ToCity WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ToCity addSubview:view];
}

//MARK:更新出差同行人员
-(void)updateTravelFellowOfficersViewWithModel:(MyProcurementModel *)model{
    _txf_FellowOfficers=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FellowOfficers WithContent:_txf_FellowOfficers WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_FellowOfficers addSubview:view];
}
//MARK:更新预估金额单视图
-(void)updateEstimatedViewWithModel:(MyProcurementModel *)model{
    _txf_Estimated=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Estimated WithContent:_txf_Estimated WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Estimated addSubview:view];
}
//MARK:更新超预算原因单视图
-(void)updateOverBudViewWithModel:(MyProcurementModel *)model{
    _txv_OverBud=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OverBud WithContent:_txv_OverBud WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_OverBud addSubview:view];
}
//MARK:更新外出申请单视图
-(void)updateStaffOutNumberViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutInfo],
                           @"Model":model
                           };
    [_View_StaffOutForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_StaffOutForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新用车申请单视图
-(void)updateVehicleNumberViewWithModel:(MyProcurementModel *)model{

    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleInfo],
                           @"Model":model
                           };
    [_View_VehicleForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_VehicleForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新借款单视图
-(void)updateBorrowFormViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceInfo],
                           @"Model":model
                           };
    [_View_BorrowingForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_BorrowingForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新减借款视图
-(void)updateLoanViewWithModel:(MyProcurementModel *)model{
    _txf_Loan=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Loan WithContent:_txf_Loan WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Loan addSubview:view];
}
//MARK:更新应付金额视图
-(void)updateActualViewWithModel:(MyProcurementModel *)model{
    _txf_Actual=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Actual WithContent:_txf_Actual WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Actual addSubview:view];
}
//MARK:更新公司合计金额视图
-(void)updateCompanyAmountViewWithModel:(MyProcurementModel *)model{
    _txf_CompanyAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CompanyAmount WithContent:_txf_CompanyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CompanyAmount addSubview:view];
    self.FormDatas.str_amountCompany=[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
}
//MARK:更新合计金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_TotalAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalAmount WithContent:_txf_TotalAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalAmount addSubview:view];
}
//MARK:更新报销金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Capitalized addSubview:view];
}
//MARK:更新无发票金额视图
-(void)updateNoInvAmountViewWithModel:(MyProcurementModel *)model{
    _txf_NoInvoice=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_NoInvoice WithContent:_txf_NoInvoice WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_NoInvoice addSubview:view];
    self.FormDatas.str_NoInvAmount=[NSString isEqualToNull:model.fieldValue]?[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""]:@"0";
}

//MARK:更新付款冲销减借款视图
-(void)updateInvLoanAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvLoanAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvLoanAmount WithContent:_txf_InvLoanAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvLoanAmount addSubview:view];
}
//MARK:更新付款报销总额视图
-(void)updateInvTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvTotalAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvTotalAmount WithContent:_txf_InvTotalAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvTotalAmount addSubview:view];
}
//MARK:更新付款应付金额视图
-(void)updateInvActualAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvActualAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvActualAmount WithContent:_txf_InvActualAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvActualAmount addSubview:view];
}
//MARK:更新币种视图
-(void)updateCurrencyCodeViewWithModel:(MyProcurementModel *)model{
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text = self.FormDatas.str_Currency;
    }else{
        _txf_CurrencyCode.text = self.FormDatas.str_Currency;
    }
}
//MARK:更新单据数量视图
-(void)updateDocumentNumViewWithModel:(MyProcurementModel *)model{
    _txf_DocumentNum=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DocumentNum WithContent:_txf_DocumentNum WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DocumentNum addSubview:view];
}
//MARK:更新结算信息明细
-(void)updateSecDetailsTableView{
    [_View_PmtMethodTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_SecDetailsArray.count*42+27)*self.FormDatas.arr_SecDetailsDataArray.count));
    }];
    [_View_PmtMethodTable reloadData];
}
//MARK:更新增加按钮
-(void)updateSecAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_PmtMethodAdd withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        pmtMethodDetail *model1=[[pmtMethodDetail alloc]init];
        [weakSelf.FormDatas.arr_SecDetailsDataArray addObject:model1];
        [weakSelf updateSecDetailsTableView];
    }];
    [_View_PmtMethodAdd addSubview:view];
}
//MARK:更新结算信息
-(void)updateSecLookDetailsTableView{
    if (self.FormDatas.bool_SecisOpenDetail) {
        NSInteger height=10;
        for (pmtMethodDetail *model in self.FormDatas.arr_SecDetailsDataArray) {
            height=height+[ProcureDetailsCell PmtMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
        }
        [_View_SecDetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        pmtMethodDetail *model=self.FormDatas.arr_SecDetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell PmtMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
        [_View_SecDetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}
//MARK:更新收款人视图
-(void)updatePayeeViewWithModel:(MyProcurementModel *)model{
    _txf_Payee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Payee WithContent:_txf_Payee WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Payee addSubview:view];
}
//MARK:更新银行账号视图
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString getSecretBankAccount:model.fieldValue];
    _txf_BankAccount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankAccount addSubview:view];
}
//MARK:更新开户行网点
-(void)updateBankOutletsViewWithModel:(MyProcurementModel *)model{
    _txf_BankOutlets = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankOutlets WithContent:_txf_BankOutlets WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankOutlets addSubview:view];
}
//MARK:更新开户行
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
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
//MARK:更新结算方式
-(void)updatePmtMethodViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.int_comeEditType == 2 || self.FormDatas.int_comeEditType == 3 || self.FormDatas.int_comeEditType == 6 || self.FormDatas.int_comeEditType == 7) {
        model.isOnlyRead=@"0";
        _txf_PmtMethod=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PmtMethod WithContent:_txf_PmtMethod WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model) {
            [weakSelf PmtMethodClick];
        }];
        [_View_PmtMethod addSubview:view];

    }else{
        _txf_PmtMethod=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PmtMethod WithContent:_txf_PmtMethod WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        [_View_PmtMethod addSubview:view];
    }
}
//MARK:更新预算核算日视图
-(void)updateBudgetSubDateViewWithModel:(MyProcurementModel *)model{
    model.isOnlyRead=@"0";
    _txf_BudgetSubDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BudgetSubDate WithContent:_txf_BudgetSubDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_BudgetSubDate.textColor=Color_Blue_Important_20;
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_BudgetSubDate=selectTime;
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_beforeBudgetSubDate=[NSString stringWithFormat:@"%@",model.fieldValue];
        self.FormDatas.str_BudgetSubDate=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_BudgetSubDate addSubview:view];
}
//MARK:更新是否收发票视图
-(void)updateReceiptOfInvViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        self.FormDatas.str_ReceiptOfInv=@"0";
        model.fieldValue=Custing(@"未收到", nil);
    }else{
        self.FormDatas.str_ReceiptOfInv=@"1";
        model.fieldValue=Custing(@"收到", nil);
    }
    _txf_ReceiptOfInv=[[UITextField alloc]init];
    if (self.FormDatas.bool_ReceiptOfInv&&(self.FormDatas.int_comeEditType == 1 || self.FormDatas.int_comeEditType == 3 || self.FormDatas.int_comeEditType == 5 || self.FormDatas.int_comeEditType == 7)) {
        model.isOnlyRead=@"0";
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ReceiptOfInv WithContent:_txf_ReceiptOfInv WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
//        _txf_ReceiptOfInv.textColor=Color_Blue_Important_20;
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            [weakSelf changeReceiptOfInv];
        }];
        [_View_ReceiptOfInv addSubview:view];
    }else{
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ReceiptOfInv WithContent:_txf_ReceiptOfInv WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        [_View_ReceiptOfInv addSubview:view];
    }
}
//MARK:更新自定义字段
-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    _Reserved1TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved1View WithContent:_Reserved1TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved1View addSubview:view];
}
-(void)updateReserved2ViewWithModel:(MyProcurementModel *)model{
    _Reserved2TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved2View WithContent:_Reserved2TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved2View addSubview:view];
}
-(void)updateReserved3ViewWithModel:(MyProcurementModel *)model{
    _Reserved3TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved3View WithContent:_Reserved3TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved3View addSubview:view];
}
-(void)updateReserved4ViewWithModel:(MyProcurementModel *)model{
    _Reserved4TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved4View WithContent:_Reserved4TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved4View addSubview:view];
}
-(void)updateReserved5ViewWithModel:(MyProcurementModel *)model{
    _Reserved5TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved5View WithContent:_Reserved5TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved5View addSubview:view];
}
-(void)updateReserved6ViewWithModel:(MyProcurementModel *)model{
    _Reserved6TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved6View WithContent:_Reserved6TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved6View addSubview:view];
}
-(void)updateReserved7ViewWithModel:(MyProcurementModel *)model{
    _Reserved7TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved7View WithContent:_Reserved7TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved7View addSubview:view];
}
-(void)updateReserved8ViewWithModel:(MyProcurementModel *)model{
    _Reserved8TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved8View WithContent:_Reserved8TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved8View addSubview:view];
}
-(void)updateReserved9ViewWithModel:(MyProcurementModel *)model{
    _Reserved9TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved9View WithContent:_Reserved9TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved9View addSubview:view];
}
-(void)updateReserved10ViewWithModel:(MyProcurementModel *)model{
    _Reserved10TF=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_Reserved10View WithContent:_Reserved10TF WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_Reserved10View addSubview:view];
}
//MARK:更新是否本部门承担费用视图
-(void)updateIsDeptBearExpsViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue=Custing(@"是", nil);
    }else{
        model.fieldValue=Custing(@"否", nil);
    }
    _txf_IsDeptBearExps = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsDeptBearExps WithContent:_txf_IsDeptBearExps WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IsDeptBearExps addSubview:view];
}
//MARK:更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Remark addSubview:view];
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    _txf_CcToPeople=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CcToPeople addSubview:view];
}


//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:3 withModel:model];
    view.maxCount = 10;
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
//MARK:超预算记录
-(void)updateBudgetNote{
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Budget WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNoneLine WithString:Custing(@"查看预算详情", nil) WithTips:nil WithInfodict:nil];
    view.lab_title.textColor=Color_Orange_Weak_20;
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf Budget:nil];
    }];
    [_View_Budget addSubview:view];
}
-(void)Budget:(UIButton *)btn{
    BudgetInfoController *vc=[[BudgetInfoController alloc]init];
    vc.budgetInfoDict=self.FormDatas.dict_budgetInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:更新报销审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    model.isOnlyRead=@"0";
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

//MARK:修改结算方式
-(void)PmtMethodClick{
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
            weakSelf.txf_PmtMethod.text=[NSString stringWithFormat:@"%@",model.payMode];
        }else{
            weakSelf.FormDatas.str_PayCode=@"";
            weakSelf.FormDatas.str_PayMode=@"";
            weakSelf.txf_PmtMethod.text=@"";
        }
    };

    [self.navigationController pushViewController:choose animated:YES];
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
    contactVC.itemType = 2;
    contactVC.menutype=4;
    contactVC.universalDelegate = self;
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

//MARK:0:退单 1加签 2同意 3支付
-(void)dockViewClick:(NSInteger)type{
    if (type==2||type==3) {
        
        NSString *str1 = [self.FormDatas testApporveEditModel];
        if ([NSString isEqualToNull:str1]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str1 duration:2.0];
            self.dockView.userInteractionEnabled = YES;
            return;
        }
        if (type==2) {
            self.FormDatas.int_SubmitSaveType=1;
        }else{
            self.FormDatas.int_SubmitSaveType=2;
        }
        NSString *str=[self.FormDatas ApproveAgreeWithPayJudge];
        if (str) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            return;
        }else{
            self.dockView.userInteractionEnabled=NO;
            [self judgeBudget];
        }

    }else{
        examineViewController *vc=[[examineViewController alloc]init];
        vc.ProcId=self.FormDatas.str_procId;
        vc.TaskId=self.FormDatas.str_taskId;
        vc.FlowCode=self.FormDatas.str_flowCode;
        if (type==0) {
            vc.Type=@"0";
            vc.AdvanceNumber=self.FormDatas.str_AdvanceId;
        }else if (type==1){
            vc.Type=@"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)approveandpay{
    self.dockView.userInteractionEnabled=YES;
    if (self.FormDatas.int_SubmitSaveType==1) {
        examineViewController *vc=[[examineViewController alloc]init];
        vc.ProcId=self.FormDatas.str_procId;
        vc.TaskId=self.FormDatas.str_taskId;
        vc.FlowCode=self.FormDatas.str_flowCode;
        vc.Type = @"2";
        [self.FormDatas contectHasDataWithTableName:[self.FormDatas getTableName]];
        vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
        vc.AdvanceNumber=self.FormDatas.str_AdvanceId;
        vc.dic_AgreeAmount=self.FormDatas.dict_JudgeAmount;
        vc.str_CommonField=[self.FormDatas getCommonField];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.FormDatas.int_SubmitSaveType==2){
        if ([self.userdatas.isOnlinePay isEqualToString:@"1"]) {
            PayMentDetailController *batch=[[PayMentDetailController alloc]init];
            MyApplyModel *model=[[MyApplyModel alloc]init];
            model.procId=self.FormDatas.str_procId;
            model.taskId=self.FormDatas.str_taskId;
            batch.dic_AgreeAmount=self.FormDatas.dict_JudgeAmount;
            batch.batchPayArray=[NSMutableArray arrayWithObject:model];
            batch.flowCode=self.FormDatas.str_flowCode;
            [self.navigationController pushViewController:batch animated:YES];
        }else{
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSLog(@"确认支付");
            self.dockView.userInteractionEnabled=NO;
            [self.FormDatas contectHasPayDataWithTableName:[self.FormDatas getTableName]];
            [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSinglePayUrl] Parameters:[self.FormDatas SinglePayFormWithComment:@"" WithAdvanceNumber:self.FormDatas.str_AdvanceId WithExpIds:@"" WithMainForm:self.FormDatas.dict_JudgeAmount WithCommonField:[self.FormDatas getCommonField]] Delegate:self SerialNum:1 IfUserCache:NO];
        }
    }
}

-(void)showBudgetTab{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"超预算提示", nil) message:@"" canDismis:NO];
    alert.contentView = _View_table;
    [_View_table reloadData];
    [alert addButton:Button_OTHER withTitle:Custing(@"取消", nil) handler:^(JKAlertDialogItem *item) {
    }];
    self.dockView.userInteractionEnabled=YES;
    [alert show];
}

//MARK:明细查看按钮被点击
-(void)LookDetailClick:(UIButton *)btn{
    NSLog(@"明细按钮点击");
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [self updateDetailsTableView];
}

//MARK:-tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_View_PmtMethodTable) {
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_View_DetailsTable) {
        return self.FormDatas.arr_sonItem.count;
    }else if (tableView==_View_table) {
        return self.FormDatas.arr_table.count;
    }else if (tableView ==_View_SecDetailsTable){
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }else if (tableView ==_View_PmtMethodTable){
        return self.FormDatas.arr_SecDetailsArray.count;
    }else if (tableView==_View_PayeeTable){
        return self.FormDatas.arr_ThirDetailsDataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_View_DetailsTable) {
        HasSubmitDetailModel *model=self.FormDatas.arr_sonItem[indexPath.row];
        return [travelHasSubmitCell cellHeightWithObj:model];
    }else  if (tableView==_View_table){
        return 40;
    }else if (tableView ==_View_SecDetailsTable){
        pmtMethodDetail *model=self.FormDatas.arr_SecDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell PmtMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
    }else if (tableView ==_View_PmtMethodTable){
        return 42;
    }else if (tableView==_View_PayeeTable){
        PayeeDetails *model=self.FormDatas.arr_ThirDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell PayeeDetailCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView ==_View_SecDetailsTable){
        return 10;
    }else if (tableView ==_View_PmtMethodTable){
        return 27;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView ==_View_SecDetailsTable){
        if (section==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
            view.backgroundColor=Color_White_Same_20;
            return view;
        }
    }else if (tableView ==_View_PmtMethodTable){
        [self createPmtMethodHeadWithSection:section];
        return _View_PmtMethodHead;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_DetailsTable) {
        travelHasSubmitCell *cell=[tableView dequeueReusableCellWithIdentifier:@"travelHasSubmitCell"];
        if (cell==nil) {
            cell=[[travelHasSubmitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"travelHasSubmitCell"];
        }
        [cell configViewWithArray:self.FormDatas.arr_sonItem withIndex:indexPath.row withNeedSure:self.FormDatas.bool_needSure withComePlace:@"travel"];
        if (cell.btn_Sure) {
            [cell.btn_Sure addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Sure.tag=200+indexPath.row;
        }
        cell.backgroundColor=Color_form_TextFieldBackgroundColor;
        return cell;
    }else if (tableView==_View_table) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text =self.FormDatas.arr_table[indexPath.row];
        cell.textLabel.font = Font_Same_14_20;
        return cell;
    }else if (tableView ==_View_SecDetailsTable){
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configPmtMethodCellWithArray:self.FormDatas.arr_SecDetailsArray withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_SecDetailsDataArray.count] ;
        if (cell.LookMore) {
            [cell.LookMore addTarget:self action:@selector(SecLookMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if (tableView ==_View_PmtMethodTable){
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        cell.IndexPath=indexPath;
        [cell configPmtMethodDeatilCellWithModel:self.FormDatas.arr_SecDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_SecDetailsArray.count WithIndex:indexPath.row];

        [cell.AmountTF addTarget:self action:@selector(AmountChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag = 1000+indexPath.section;
        cell.AmountTF.delegate = self;
        
        [cell.PriceTextField addTarget:self action:@selector(ExchangeRateChange:) forControlEvents:UIControlEventEditingChanged];
        cell.PriceTextField.tag = 100+indexPath.section;
        cell.PriceTextField.delegate = self;

        //币种
        if (cell.SupplierBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                pmtMethodDetail *modelD=[weakSelf.FormDatas.arr_SecDetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    pmtMethodDetail *modelD=[[pmtMethodDetail alloc]init];
                    [weakSelf.FormDatas.arr_SecDetailsDataArray insertObject:modelD atIndex:index.section];
                }
                STOnePickView *picker = [[STOnePickView alloc]init];
                [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                    modelD.Currency = Model.Type;
                    modelD.ExchangeRate = Model.exchangeRate;
                    [weakSelf.View_PmtMethodTable reloadData];
                }];
                picker.typeTitle=Custing(@"币种", nil);
                picker.DateSourceArray=[NSMutableArray arrayWithArray:self.FormDatas.arr_CurrencyCode];
                STOnePickModel *model=[[STOnePickModel alloc]init];
                model.Id=[NSString isEqualToNull: modelD.Currency]?modelD.Currency:@"";
                picker.Model=model;
                [picker UpdatePickUI];
                [picker setContentMode:STPickerContentModeBottom];
                [picker show];
            }];
        }
        //结算方式
        if (cell.NameBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setNameCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                pmtMethodDetail *modelD=[weakSelf.FormDatas.arr_SecDetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    pmtMethodDetail *modelD=[[pmtMethodDetail alloc]init];
                    [weakSelf.FormDatas.arr_SecDetailsDataArray insertObject:modelD atIndex:index.section];
                }
                ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"payWay"];
                choose.ChooseCategoryArray=weakSelf.FormDatas.arr_payWay;
                choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    if (array) {
                        ChooseCategoryModel *model = array[0];
                        modelD.PmtMethod = [NSString stringWithFormat:@"%@",model.payMode];
                        tf.text = modelD.PmtMethod;
                    }else{
                        modelD.PmtMethod = @"";
                        tf.text = @"";
                    }
                };
                [self.navigationController pushViewController:choose animated:YES];
            }];
        }
        return cell;
    }else if (tableView ==_View_PayeeTable){
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configPayeeDetailCellWithArray:self.FormDatas.arr_ThirDetailsArray withDetailsModel:self.FormDatas.arr_ThirDetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_ThirDetailsDataArray.count] ;
        if (cell.LookMore) {
            [cell.LookMore addTarget:self action:@selector(ThirLookMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_DetailsTable) {
        HasSubmitDetailModel *model=self.FormDatas.arr_sonItem[indexPath.row];
        if (self.FormDatas.int_comeEditType == 1 || self.FormDatas.int_comeEditType == 3 || self.FormDatas.int_comeEditType == 4 || self.FormDatas.int_comeEditType == 5 || self.FormDatas.int_comeEditType == 6 || self.FormDatas.int_comeEditType == 7) {
            __weak typeof(self) weakSelf = self;
            NewAddCostApproveViewController *vc=[[NewAddCostApproveViewController alloc]init];
            vc.dict_parameter = @{@"UserId":self.FormDatas.personalData.OperatorUserId,
                                  @"OwnerUserId":self.FormDatas.personalData.OperatorUserId,
                                  @"ProcId":self.FormDatas.str_procId,
                                  @"FlowGuid":self.FormDatas.str_flowGuid
                                   };
            vc.int_comeEditType = self.FormDatas.int_comeEditType;
            vc.model=model;
            vc.bool_IsAllowModCostCgyOrInvAmt = self.FormDatas.bool_IsAllowModCostCgyOrInvAmt;
            vc.indexPath=indexPath;
            vc.ProcId=self.FormDatas.str_procId;
            vc.ClaimType=@"1";
            [vc setBlock:^(HasSubmitDetailModel *model,NSIndexPath *indexPath){
                model.isEdit=@"1";
                NSString *exchange = model.amount;
                model.amount = model.localCyAmount;
                model.localCyAmount = exchange;
            
                NSString *loan = [GPUtils decimalNumberSubWithString:model.amount with:[weakSelf.FormDatas.arr_ApprovBefoEditExpense[indexPath.row] valueForKey:@"amount"]];
                NSString *Invloan = [GPUtils decimalNumberSubWithString:model.invPmtAmount with:[weakSelf.FormDatas.arr_ApprovBefoEditExpense[indexPath.row] valueForKey:@"invPmtAmount"]];
                
                if ([[NSString stringWithFormat:@"%@",model.hasInvoice]floatValue]==0) {
                    weakSelf.FormDatas.str_NoInvAmount =[[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_NoInvAmount with:loan] floatValue]>0?[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_NoInvAmount with:loan]:@"0";
                }
                weakSelf.FormDatas.str_amountTotal = [GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountTotal with:loan];
                weakSelf.FormDatas.str_InvTotalAmount = [GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_InvTotalAmount with:Invloan];

                if ([[NSString stringWithFormat:@"%@",model.payTypeId]isEqualToString:@"2"]) {
                    weakSelf.FormDatas.str_amountCompany =[[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountCompany with:loan] floatValue]>0?[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountCompany with:loan]:@"0";
                }else{
                    weakSelf.FormDatas.str_amountPrivate =[[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountPrivate with:loan] floatValue]>0?[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountPrivate with:loan]:@"0";
                    weakSelf.FormDatas.str_amountActual =[[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountActual with:loan] floatValue]>0?[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_amountActual with:loan]:@"0";
                }
                weakSelf.FormDatas.str_InvActualAmount = [[GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_InvActualAmount with:Invloan] floatValue] > 0 ? [GPUtils decimalNumberAddWithString:weakSelf.FormDatas.str_InvActualAmount with:Invloan]:@"0";

                weakSelf.txf_PrivateAmount.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_amountPrivate];
                weakSelf.txf_Actual.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_amountActual];
                weakSelf.txf_InvActualAmount.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_InvActualAmount];
                weakSelf.txf_CompanyAmount.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_amountCompany];
                weakSelf.txf_TotalAmount.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_amountTotal];
                weakSelf.txf_InvTotalAmount.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_InvTotalAmount];
                weakSelf.txf_Capitalized.text=[NSString getChineseMoneyByString:weakSelf.txf_TotalAmount.text];
                weakSelf.txf_NoInvoice.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_NoInvAmount];
                [weakSelf.FormDatas.arr_ApprovBefoEditExpense[indexPath.row] setValue:model.amount forKey:@"amount"];
                [weakSelf.FormDatas.arr_ApprovBefoEditExpense[indexPath.row] setValue:model.invPmtAmount forKey:@"invPmtAmount"];

                if (self.FormDatas.bool_needSure&&[NSString isEqualToNull:model.overStd]&&[model.overStd floatValue]>0) {
                    model.hasSured=@"0";
                }else{
                    model.hasSured=@"1";
                }
                [weakSelf.FormDatas getHasSubmitDetailModelSubContent:model];
                [weakSelf updateDetailsTableView];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NewLookAddCostViewController *add = [[NewLookAddCostViewController alloc]init];
            add.dict_parameter = @{@"UserId":self.FormDatas.personalData.OperatorUserId,
                                   @"OwnerUserId":self.FormDatas.personalData.OperatorUserId,
                                   @"ProcId":self.FormDatas.str_procId,
                                   @"FlowGuid":self.FormDatas.str_flowGuid,
                                   @"Requestor":self.FormDatas.personalData.Requestor,
                                   };
            add.TaskId = model.taskId;
            add.Type = 1;
            add.Action = 3;
            add.GridOrder = model.gridOrder;
            add.dateSource = model.dataSource;
            add.model_has = model;
            [self.navigationController pushViewController:add animated:YES];
        }
    }
}

//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField.tag>=1000&&textField.tag<=1250){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (textField.tag>=100 && textField.tag<=250){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0-9]{0,5})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }
    return YES;
}

//MARK:分摊返回
-(void)ReimShareData:(ReimShareModel *)model WithType:(NSInteger)type{
    [_ReimShareMainView updateMainView];
}
-(void)SureClick:(UIButton *)btn{
    HasSubmitDetailModel *model=(HasSubmitDetailModel*)self.FormDatas.arr_sonItem[btn.tag-200];
    if ([model.hasSured isEqualToString:@"1"]) {
        model.hasSured=@"0";
    }else if ([model.hasSured isEqualToString:@"0"]){
        model.hasSured=@"1";
    }
    [_View_DetailsTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:btn.tag-200 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)changeReceiptOfInv{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_ReceiptOfInv=Model.Id;
        weakSelf.txf_ReceiptOfInv.text=Model.Type;
    }];
    picker.typeTitle=Custing(@"是否收到发票", nil);
    picker.DateSourceArray=[NSMutableArray arrayWithArray:self.FormDatas.arr_ReceiptOfInv];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[self.FormDatas.str_ReceiptOfInv floatValue]==1?@"1":@"0";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}

//MARK:查看更多结算方式
-(void)SecLookMore:(UIButton *)btn{
    self.FormDatas.bool_SecisOpenDetail=!self.FormDatas.bool_SecisOpenDetail;
    [btn setImage: self.FormDatas.bool_SecisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_SecisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updateSecLookDetailsTableView];
}
-(void)ThirLookMore:(UIButton *)btn{
    self.FormDatas.bool_ThirisOpenDetail=!self.FormDatas.bool_ThirisOpenDetail;
    [btn setImage: self.FormDatas.bool_ThirisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_ThirisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updatePayeeTable];
}
#pragma mar-创建tableView头视图
-(void)createPmtMethodHeadWithSection:(NSInteger)section{
    _View_PmtMethodHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_PmtMethodHead addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_PmtMethodHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_SecDetailsDataArray.count==1) {
        titleLabel.text=Custing(@"结算信息", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"结算信息", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=2200+section;
            [_View_PmtMethodHead addSubview:deleteBtn];
        }
    }
    _View_PmtMethodHead.backgroundColor=Color_White_Same_20;
}

-(void)AmountChange:(UITextField *)text{
    pmtMethodDetail *model=[self.FormDatas.arr_SecDetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        pmtMethodDetail *model=[[pmtMethodDetail alloc]init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
}
-(void)ExchangeRateChange:(UITextField *)text{
    pmtMethodDetail *model=[self.FormDatas.arr_SecDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        pmtMethodDetail *model=[[pmtMethodDetail alloc]init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.ExchangeRate=text.text;
    }else{
        model.ExchangeRate=text.text;
    }
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    [self keyClose];
    NSString *title;
    if (btn.tag>=2200) {
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除结算信息", nil),(long)(btn.tag-2200+1)];
    }
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:@"" message:title cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"删除",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (btn.tag>=2200) {
                [weakSelf.FormDatas.arr_SecDetailsDataArray removeObjectAtIndex:btn.tag-2200];
                [weakSelf updateSecDetailsTableView];
            }
        }
    }];
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
