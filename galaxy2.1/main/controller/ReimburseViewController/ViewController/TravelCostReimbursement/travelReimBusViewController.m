//
//  travelReimBusViewController.m
//  galaxy
//
//  Created by hfk on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "travelReimBusViewController.h"
#import "PayeesChooseViewController.h"
#import "ReimImportCustomViewController.h"
#import "NewAddressViewController.h"

@interface travelReimBusViewController ()

@end

@implementation travelReimBusViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[travelReimFormDate alloc]initWithStatus:1];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCost:) name:@"ADDCOST" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCost:) name:@"EDITCOST" object:nil];
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
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PrivateAmount=[[UIView alloc]init];
    _View_PrivateAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PrivateAmount];
    [_View_PrivateAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Detail=[[UIView alloc]init];
    _View_Detail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Detail];
    [_View_Detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PrivateAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DetailsTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_DetailsTable.delegate = self;
    _View_DetailsTable.dataSource = self;
    _View_DetailsTable.scrollEnabled = NO;
    _View_DetailsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Detail.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_PayeeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_PayeeTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_PayeeTable.delegate=self;
    _View_PayeeTable.dataSource=self;
    _View_PayeeTable.scrollEnabled=NO;
    _View_PayeeTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PayeeTable];
    [_View_PayeeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayeeAdd=[[UIView alloc]init];
    _View_PayeeAdd.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_PayeeAdd];
    [_View_PayeeAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayeeTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimShareMainView=[[ReimShareMainView alloc]init];
    _ReimShareMainView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_ReimShareMainView];
    [_ReimShareMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayeeAdd.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ClaimType=[[UIView alloc]init];
    _View_ClaimType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClaimType];
    [_View_ClaimType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareMainView.bottom);
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
    
    _View_TravelForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0001"];
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
    
    _View_RelevantDept = [[UIView alloc]init];
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
    
    _View_StaffOutForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0016"];;
    _View_StaffOutForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StaffOutForm];
    [_View_StaffOutForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBud.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VehicleForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0014"];;
    _View_VehicleForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VehicleForm];
    [_View_VehicleForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StaffOutForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BorrowingForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0006"];
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
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _View_Payee=[[UIView alloc]init];
    _View_Payee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Payee];
    [_View_Payee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DocumentNum.bottom);
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
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsDeptBearExps = [[UIView alloc]init];
    _View_IsDeptBearExps.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsDeptBearExps];
    [_View_IsDeptBearExps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsDeptBearExps.bottom);
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
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:5 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    self.FormDatas.dict_resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        self.dockView.userInteractionEnabled = YES;
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
        case 2:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
                self.FormDatas.SubmitData.CostShareApproval1 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval1"]];
                self.FormDatas.SubmitData.CostShareApproval2 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval2"]];
                self.FormDatas.SubmitData.CostShareApproval3 = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"costShareApproval3"]];
                [self getExpShareDates];
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
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
        }
            break;
        case 6:
        {
            if ([responceDic[@"result"] isKindOfClass:[NSArray class]]) {
                [self.FormDatas getSubmitExpShareDataWithDict:responceDic[@"result"]];
                [self.FormDatas contectData];
                if (self.FormDatas.int_SubmitSaveType==1) {
                    [self dealWithImagesArray];
                }else{
                    [self checkTravelReimSubmit];
                }
            }
        }
            break;
        case 10:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        case 14:
        {
            if ([self.FormDatas getVerifyBudegt]==0) {
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
    [self updateDetailView];
    [self updateDetailsTableView];
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    __weak typeof(self) weakSelf = self;
    _SubmitPersonalView.SubmitPersonalViewBackBlock = ^(id backObj) {
        [weakSelf clearPersonalData];
    };
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"SumAmount"]) {
            self.FormDatas.str_lastAmount =self.FormDatas.str_amountPrivate;
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePriveateAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClaimType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateClaimTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reason"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BnfId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBeneficiariesViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ClientId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateClientViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TravelNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTravelFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TravelType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateTravelTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RelevantDept"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateRelevantDeptViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FinancialSource"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateFinancialSourceViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FromDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateTravelDuringViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FromCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateFromCityViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ToCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateToCityViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FellowOfficers"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:(self.FormDatas.bool_editRelateTravelForm ? model.isRequired:@0) forKey:model.fieldName];
                [self updateTravelFellowOfficersViewWithModel:model];
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
                [self updateOverBudViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"StaffOutNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStaffOutNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"VehicleNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateVehicleNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"AdvanceNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBorrowFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LoanAmount"]){
            self.FormDatas.str_LoanTotalAmount =[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateLoanViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ActualAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateActualViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CorpPayAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCompanyAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTotalAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCapitalizedAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"NoInvAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateNoInvAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvLoanAmount"]){
            self.FormDatas.str_InvLoanAmount =[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvLoanAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvTotalAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvTotalAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvActualAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvActualAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCurrencyCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"NumberOfDocuments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateDocumentNumViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Payee"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayeeViewWithModel:model];
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
        }else if ([model.fieldName isEqualToString:@"BankName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankCityViewWithModel:model];
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
    
    
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    if (self.FormDatas.bool_ShareShow) {
        [self updateReimShareView];
    }
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    
    if (self.FormDatas.bool_ThirDetailsShow) {
        if (self.FormDatas.arr_ThirDetailsDataArray.count == 0) {
            PayeeDetails *model = [[PayeeDetails alloc]init];
            [self.FormDatas.arr_ThirDetailsDataArray addObject:model];
        }
        [self.FormDatas.arr_UnShowmsArray removeObject:@"ThirDetailList"];
        [self updateThirDetailsTableView];
        [self updateThirAddDetailsView];
    }
    
    [self updateContentView];
    [self.FormDatas getEndShowArray];

    //报销类型是否关联出差申请单
    if ([self.FormDatas.arr_isShowmsArray containsObject:@"ClaimType"]&&[self.FormDatas.arr_isShowmsArray containsObject:@"TravelNumber"]&&[NSString isEqualToNullAndZero:self.FormDatas.str_ClaimTypeId]&&self.FormDatas.arr_ClaimType.count>0) {
        for (ChooseCategoryModel *model in self.FormDatas.arr_ClaimType) {
            if ([[NSString stringWithFormat:@"%@",model.Id] isEqualToString:self.FormDatas.str_ClaimTypeId]) {
                self.FormDatas.bool_isReleTravel=[model.isRelation floatValue]==0?NO:YES;
                
            }
        }
    }
    
    if (self.FormDatas.arr_ClaimType.count>0&&[NSString isEqualToNull:self.FormDatas.str_ClaimType]&&[NSString isEqualToNull:self.FormDatas.str_ClaimTypeId]) {
        ChooseCategoryModel *ChooseModel;
        for (ChooseCategoryModel *model in self.FormDatas.arr_ClaimType) {
            if ([self.FormDatas.str_ClaimTypeId isEqualToString:[NSString stringWithFormat:@"%@",model.Id]]&&[self.FormDatas.str_ClaimType isEqualToString:[NSString stringWithFormat:@"%@",model.claimType]]) {
                ChooseModel=model;
            }
        }
        [self dealApproveViewWithModel:ChooseModel];
    }
}
//MARK:更新报销金额视图
-(void)updatePriveateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_PrivateAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PrivateAmount WithContent:_txf_PrivateAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_amountPrivate}];
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
    _Imv_DetailClick=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"skipImage"];
    _Imv_DetailClick.center=CGPointMake(Main_Screen_Width-12-10, 20);
    [_View_Detail addSubview:_Imv_DetailClick];
}
//MARK:更新明细详情视图
-(void)updateDetailsTableView{
    if (self.FormDatas.bool_isOpenDetail) {
        _Imv_DetailClick.image = [UIImage imageNamed:@"skipImage"];
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else if(self.FormDatas.bool_isOpenDetail == NO){
        _Imv_DetailClick.image = [UIImage imageNamed:@"share_Open"];
        float height = 46;
        for (AddDetailsModel *model in self.FormDatas.arr_sonItem) {
            height += [ExpenseSonListCell cellHeightWithModel:model];
        }
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        [_View_DetailsTable reloadData];
    }
}
//MARK:更新收款人明细
-(void)updateThirDetailsTableView{
    [_View_PayeeTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_ThirDetailsArray.count*42+27)*self.FormDatas.arr_ThirDetailsDataArray.count));
    }];
    [_View_PayeeTable reloadData];
}
//MARK:更新增加收款人按钮
-(void)updateThirAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_PayeeAdd withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        PayeeDetails *model1=[[PayeeDetails alloc]init];
        [weakSelf.FormDatas.arr_ThirDetailsDataArray addObject:model1];
        [weakSelf updateThirDetailsTableView];
    }];
    [_View_PayeeAdd addSubview:view];
}
//MARK:更新分摊视图
-(void)updateReimShareView{
    [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:1 WithComePlace:1];
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
}
//MARK:更新报销类型视图
-(void)updateClaimTypeViewWithModel:(MyProcurementModel *)model{
    _txf_ClaimType=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ClaimType WithContent:_txf_ClaimType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeClaimType];
    }];
    [_View_ClaimType addSubview:view];
    
    self.FormDatas.str_ClaimType=[NSString stringWithFormat:@"%@",model.fieldValue];
}
//MARK:更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:受益人
-(void)updateBeneficiariesViewWithModel:(MyProcurementModel *)model{
    _txf_Beneficiaries = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Beneficiaries WithContent:_txf_Beneficiaries WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_Beneficiaries}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf BeneficiariesClick];
    }];
    [_View_Beneficiaries addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_BeneficiariesId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
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
//MARK:更新客户视图
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    _txf_Client=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Client WithContent:_txf_Client WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ClientName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ClientClick];
    }];
    [_View_Client addSubview:view];
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}

//MARK:更新出差申请单视图
-(void)updateTravelFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_travelFormId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_travelFormInfo=@"";
        self.FormDatas.str_travelFormId=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo],
                           @"Model":model
                           };
    [_View_TravelForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_TravelForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf TravelFormClick];
    };
}

//MARK:更新出差类型
-(void)updateTravelTypeViewWithModel:(MyProcurementModel *)model{
    _txf_TravelType=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TravelType WithContent:_txf_TravelType WithFormType:self.FormDatas.bool_editRelateTravelForm ? formViewSelect:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BusinessType"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_travelTypeId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_travelType = model.travelType;
            weakSelf.txf_TravelType.text = model.travelType;
            weakSelf.FormDatas.str_travelTypeId = model.Id;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_travelType = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_TravelType addSubview:view];
}
//MARK:更新归口部门
-(void)updateRelevantDeptViewWithModel:(MyProcurementModel *)model{
    _txf_RelevantDept=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_RelevantDept WithContent:_txf_RelevantDept WithFormType:self.FormDatas.bool_editRelateTravelForm ? formViewSelect:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_relevantDeptId;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_relevantDept = model.name;
            weakSelf.txf_RelevantDept.text = model.name;
            weakSelf.FormDatas.str_relevantDeptId = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_relevantDept = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_RelevantDept addSubview:view];
}

//MARK:更新经费来源
-(void)updateFinancialSourceViewWithModel:(MyProcurementModel *)model{
    _txf_FinancialSource = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FinancialSource WithContent:_txf_FinancialSource WithFormType:self.FormDatas.bool_editRelateTravelForm ? formViewSelect:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_financialSource;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_financialSource = model.name;
            weakSelf.txf_FinancialSource.text = model.name;
            weakSelf.FormDatas.str_financialSourceId= model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_financialSource = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_FinancialSource addSubview:view];
}

//MARK:更新出差期间
-(void)updateTravelDuringViewWithModel:(MyProcurementModel *)model{
    _txf_FromDate=[[UITextField alloc]init];
    model.Description = Custing(@"出发时间",nil);
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_FromDate=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromDate WithContent:_txf_FromDate WithFormType:self.FormDatas.bool_editRelateTravelForm ? (self.FormDatas.int_travelTimeParams==1?formViewSelectDate:formViewSelectDateTime):formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_FromDate=selectTime;
    }];
    [_View_FromDate addSubview:view];
    

    _txf_ToDate=[[UITextField alloc]init];
    model.Description = Custing(@"返回时间",nil);
    SubmitFormView *view1=[[SubmitFormView alloc]initBaseView:_View_ToDate WithContent:_txf_ToDate WithFormType:self.FormDatas.bool_editRelateTravelForm ? (self.FormDatas.int_travelTimeParams==1?formViewSelectDate:formViewSelectDateTime):formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_ToDate}];
    [view1 setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_ToDate=selectTime;
    }];
    [_View_ToDate addSubview:view1];
}
//MARK:更新出发地
-(void)updateFromCityViewWithModel:(MyProcurementModel *)model{
    _txf_FromCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FromCity WithContent:_txf_FromCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        NewAddressViewController * address = [[NewAddressViewController alloc]init];
        address.status = @"2";
        address.Type = 1;
        address.isGocity = @"2";
        address.OnlyInternal = NO;
        [address setSelectAddressBlock:^(NSArray *array, NSString *start) {
            NSDictionary *dict = array[0];
            weakSelf.FormDatas.str_FromCityCode = [NSString stringWithIdOnNO:dict[@"cityCode"]];
            weakSelf.FormDatas.str_FromCity = [weakSelf.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dict[@"cityName"]]:[NSString stringWithIdOnNO:dict[@"cityNameEn"]];
            weakSelf.txf_FromCity.text = weakSelf.FormDatas.str_FromCity;
        }];
        [weakSelf.navigationController pushViewController:address animated:YES];
    }];
    [_View_FromCity addSubview:view];
}
//MARK:更新目的地
-(void)updateToCityViewWithModel:(MyProcurementModel *)model{
    _txf_ToCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ToCity WithContent:_txf_ToCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        NewAddressViewController * address = [[NewAddressViewController alloc]init];
        address.status = @"2";
        address.Type = 1;
        address.isGocity = @"2";
        address.OnlyInternal = NO;
        [address setSelectAddressBlock:^(NSArray *array, NSString *start) {
            NSDictionary *dict = array[0];
            weakSelf.FormDatas.str_ToCityCode = [NSString stringWithIdOnNO:dict[@"cityCode"]];
            weakSelf.FormDatas.str_ToCity = [weakSelf.userdatas.language isEqualToString:@"ch"]?[NSString stringWithIdOnNO:dict[@"cityName"]]:[NSString stringWithIdOnNO:dict[@"cityNameEn"]];
            weakSelf.txf_ToCity.text = weakSelf.FormDatas.str_ToCity;
        }];
        [weakSelf.navigationController pushViewController:address animated:YES];
    }];
    [_View_ToCity addSubview:view];
}
//MARK:更新出差同行人员
-(void)updateTravelFellowOfficersViewWithModel:(MyProcurementModel *)model{
    _txf_FellowOfficers=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FellowOfficers WithContent:_txf_FellowOfficers WithFormType:self.FormDatas.bool_editRelateTravelForm ? formViewSelect:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf EntourageClick];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_FellowOfficers=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_FellowOfficers addSubview:view];
}
//MARK:更新预估金额单视图
-(void)updateEstimatedViewWithModel:(MyProcurementModel *)model{
    _txf_Estimated=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Estimated WithContent:_txf_Estimated WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Estimated addSubview:view];
    
//    if (self.FormDatas.int_comeStatus==1&&[NSString isEqualToNull:self.FormDatas.str_EstimatedAmount]) {
//        _txf_Estimated.text=[GPUtils transformNsNumber:self.FormDatas.str_EstimatedAmount];
//    }else{
    self.FormDatas.str_EstimatedAmount =[_txf_Estimated.text stringByReplacingOccurrencesOfString:@"," withString:@""];
//    }
}
//MARK:更新超预算原因单视图
-(void)updateOverBudViewWithModel:(MyProcurementModel *)model{
    _txv_OverBud=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OverBud WithContent:_txv_OverBud WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_OverBud addSubview:view];
}
//MARK:更新外出申请单视图
-(void)updateStaffOutNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_StaffOutNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_StaffOutInfo=@"";
        self.FormDatas.str_StaffOutNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutInfo],
                           @"Model":model
                           };
    [_View_StaffOutForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_StaffOutForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf StaffOutFormClick];
    };
}
//MARK:更新用车申请单视图
-(void)updateVehicleNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_VehicleNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_VehicleInfo=@"";
        self.FormDatas.str_VehicleNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleInfo],
                           @"Model":model
                           };
    [_View_VehicleForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_VehicleForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf VehicleFormClick];
    };
}
//MARK:更新借款单视图
-(void)updateBorrowFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_AdvanceId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_AdvanceInfo=@"";
        self.FormDatas.str_AdvanceId=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceInfo],
                           @"Model":model
                           };
    [_View_BorrowingForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_BorrowingForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf BorrowingFormClick];
    };
}
//MARK:更新减借款视图
-(void)updateLoanViewWithModel:(MyProcurementModel *)model{
    _txf_Loan=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Loan WithContent:_txf_Loan WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Loan addSubview:view];
    self.FormDatas.str_LoanTotalAmount =[self.txf_Loan.text stringByReplacingOccurrencesOfString:@"," withString:@""];
}
//MARK:更新应付金额视图
-(void)updateActualViewWithModel:(MyProcurementModel *)model{
    _txf_Actual=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Actual WithContent:_txf_Actual WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Actual addSubview:view];
    
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountPrivate with:self.FormDatas.str_LoanTotalAmount]floatValue]<0) {
        _txf_Actual.text=[GPUtils transformNsNumber:@"0"];
    }else{
        _txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountPrivate with:self.FormDatas.str_LoanTotalAmount]];
    }
}

//MARK:更新公司合计金额视图
-(void)updateCompanyAmountViewWithModel:(MyProcurementModel *)model{
    _txf_CompanyAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CompanyAmount WithContent:_txf_CompanyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_amountCompany}];
    [_View_CompanyAmount addSubview:view];
}

//MARK:更新合计金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_TotalAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalAmount WithContent:_txf_TotalAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_amountTotal}];
    [_View_TotalAmount addSubview:view];
}
//MARK:更新金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[NSString getChineseMoneyByString:self.FormDatas.str_amountTotal]}];
    [_View_Capitalized addSubview:view];
}
//MARK:更新无发票金额视图
-(void)updateNoInvAmountViewWithModel:(MyProcurementModel *)model{
    _txf_NoInvoice=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_NoInvoice WithContent:_txf_NoInvoice WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_NoInvAmount}];
    [_View_NoInvoice addSubview:view];
}
//MARK:更新付款冲销减借款视图
-(void)updateInvLoanAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvLoanAmount = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvLoanAmount WithContent:_txf_InvLoanAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvLoanAmount addSubview:view];
    self.FormDatas.str_InvLoanAmount =[self.txf_InvLoanAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
}
//MARK:更新付款报销总额视图
-(void)updateInvTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvTotalAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvTotalAmount WithContent:_txf_InvTotalAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_InvTotalAmount}];
    [_View_InvTotalAmount addSubview:view];
}
//MARK:更新付款应付金额视图
-(void)updateInvActualAmountViewWithModel:(MyProcurementModel *)model{
    _txf_InvActualAmount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvActualAmount WithContent:_txf_InvActualAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvActualAmount addSubview:view];
    
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount]floatValue] < 0) {
        _txf_InvActualAmount.text = [GPUtils transformNsNumber:@"0"];
    }else{
        _txf_InvActualAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount]];
    }
}
//MARK:更新币种视图
-(void)updateCurrencyCodeViewWithModel:(MyProcurementModel *)model{
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [self keyClose];
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_CurrencyCode = Model.Id;
            weakSelf.FormDatas.str_Currency = Model.Type;
            weakSelf.txf_CurrencyCode.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"币种", nil);
        picker.DateSourceArray = self.FormDatas.arr_CurrencyCode;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = [NSString isEqualToNull: self.FormDatas.str_CurrencyCode]?self.FormDatas.str_CurrencyCode:@"";
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
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
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DocumentNum WithContent:_txf_DocumentNum WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DocumentNum addSubview:view];
}
//MARK:更新收款人视图
-(void)updatePayeeViewWithModel:(MyProcurementModel *)model{
    _txf_Payee = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Payee WithContent:_txf_Payee WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        PayeesChooseViewController *vc=[[PayeesChooseViewController alloc]init];
        vc.PayeesChooseBlock = ^(ChooseCateFreModel *model) {
            weakSelf.txf_Payee.text = model.payee;
            weakSelf.txf_BankAccount.text = [NSString getSecretBankAccount:model.bankAccount];
            weakSelf.txf_BankName.text = model.depositBank;
            weakSelf.txf_BankOutlets.text = model.bankOutlets;
            weakSelf.txf_BankCity.text = [GPUtils getSelectResultWithArray:@[model.bankProvince,model.bankCity] WithCompare:@"/"];
            
            weakSelf.FormDatas.str_Payee = model.payee;
            weakSelf.FormDatas.str_BankAccount = model.bankAccount;
            weakSelf.FormDatas.str_BankName = model.depositBank;
            weakSelf.FormDatas.str_BankOutlets = model.bankOutlets;
            weakSelf.FormDatas.str_BankNo = model.bankNo;
            weakSelf.FormDatas.str_BankCode = model.bankCode;
            weakSelf.FormDatas.str_BankProvinceCode = model.bankProvinceCode;
            weakSelf.FormDatas.str_BankProvince = model.bankProvince;
            weakSelf.FormDatas.str_BankCityCode = model.bankCityCode;
            weakSelf.FormDatas.str_BankCity = model.bankCity;
            weakSelf.FormDatas.str_CNAPS = model.cnaps;
            weakSelf.FormDatas.str_CredentialType = model.credentialType;
            weakSelf.FormDatas.str_IdentityCardId = model.identityCardId;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_Payee addSubview:view];
}
//MARK:更新银行帐号视图
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    self.FormDatas.str_BankAccount = [NSString stringIsExist:model.fieldValue];
    _txf_BankAccount = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewBankAccount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.viewClickedBackBlock = ^(id object) {
        self.FormDatas.str_BankAccount = object;
    };
    [_View_BankAccount addSubview:view];
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
        
            weakSelf.FormDatas.str_BankName = model.clearingBank;
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
//MARK:更新供应商开户行
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
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsDeptBearExps WithContent:_txf_IsDeptBearExps WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
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
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=10;
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
//MARK:明细查看按钮被点击
-(void)LookDetailClick:(UIButton *)btn{
    NSLog(@"明细按钮点击");
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [self updateDetailsTableView];
}

//MARK:全选消费记录按钮
-(void)SelectAllClick:(UIButton *)btn{
    NSLog(@"全选消费记录按钮");
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checked MATCHES %@", @"0"];
    NSArray* tempArr = [self.FormDatas.arr_sonItem filteredArrayUsingPredicate:predicate];
    for (AddDetailsModel *model in self.FormDatas.arr_sonItem) {
        model.checked = tempArr.count > 0 ? @"1":@"0";
    }
    [self dealShowAmountData];
    [_View_DetailsTable reloadData];
}
//MARK:添加消费记录
-(void)addCustomClick:(UIButton *)btn{
    NSLog(@"添加消费记录");
    [self keyClose];
    NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
    add.dict_parameter = @{@"UserId":self.FormDatas.personalData.OperatorUserId,
                           @"OwnerUserId":self.FormDatas.personalData.OperatorUserId,
                           @"CostCenterId":(self.FormDatas.bool_IsHasShowProject && [NSString isEqualToNull:self.FormDatas.personalData.CostCenterId])? self.FormDatas.personalData.CostCenterId:@"0",
                           @"Requestor":self.FormDatas.personalData.Requestor,
                          };
    add.Action = 1;
    add.Type = 1;
    add.Enabled_Expense = 1;
    add.Enabled_addAgain = 1;
    [self.navigationController pushViewController:add animated:YES];
}
//MARK:导入消费记录
-(void)importCustomClick:(UIButton *)btn{
    ReimImportCustomViewController *vc = [[ReimImportCustomViewController alloc]init];
    vc.dict_parameter = @{@"FlowCode":self.FormDatas.str_flowCode,
                          @"UserId":self.FormDatas.personalData.OperatorUserId,
                          @"OwnerUserId":self.FormDatas.personalData.OperatorUserId,
                          @"ExpUsers":[self.FormDatas getTravel_Daily_OtherReimImportExpJson]
                          };
    __weak typeof(self) weakSelf = self;
    vc.importCustomBackBlock = ^(NSArray * _Nonnull array) {
        [weakSelf.FormDatas travel_daily_otherReimAddCost:array];
        [weakSelf dealShowAmountData];
        [weakSelf updateDetailsTableView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改申请人相关数据清空
-(void)clearPersonalData{
    //出差申请单清空
    self.FormDatas.str_travelFormInfo = @"";
    self.FormDatas.str_travelFormId = @"";
    self.FormDatas.str_travel_FromDate=@"";
    self.FormDatas.str_travel_ToDate=@"";
    self.FormDatas.str_FromCityCode=@"";
    self.FormDatas.str_FromCity=@"";
    self.txf_FromCity.text = @"";
    self.FormDatas.str_ToCityCode=@"";
    self.FormDatas.str_ToCity=@"";
    self.txf_ToCity.text = @"";
    self.FormDatas.str_FromDate=@"";
    self.txf_FromDate.text=@"";
    self.FormDatas.str_ToDate=@"";
    self.txf_ToDate.text=@"";
    self.FormDatas.str_FellowOfficersId=@"";
    self.FormDatas.str_FellowOfficers=@"";
    self.txf_FellowOfficers.text =@"";
    self.FormDatas.str_travelTypeId = @"";
    self.FormDatas.str_travelType = @"";
    self.txf_TravelType.text = @"";
    self.FormDatas.str_relevantDeptId = @"";
    self.FormDatas.str_relevantDept = @"";
    self.txf_RelevantDept.text = @"";
    self.FormDatas.str_financialSourceId = @"";
    self.FormDatas.str_financialSource = @"";
    self.txf_FinancialSource.text = @"";
    self.FormDatas.str_EstimatedAmount = @"0";
    self.FormDatas.str_travelFormMoney = @"0";
    self.FormDatas.str_InvtravelFormMoney = @"0";
    self.txf_Estimated.text = nil;
    NSDictionary *travelDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                                 @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo]
                                 };
    [self.View_TravelForm updateView:travelDict];
    //外出申请单
    self.FormDatas.str_StaffOutInfo = @"";
    self.FormDatas.str_StaffOutNumber = @"";
    NSDictionary *staffDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutNumber],
                                @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutInfo]
                                };
    [self.View_StaffOutForm updateView:staffDict];
    //用车申请单
    self.FormDatas.str_VehicleInfo = @"";
    self.FormDatas.str_VehicleNumber = @"";
    NSDictionary *vehicleDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleNumber],
                                  @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleInfo]
                                  };
    [self.View_VehicleForm updateView:vehicleDict];
    //借款单
    self.FormDatas.str_AdvanceMoney = @"0";
    self.FormDatas.str_InvAdvanceMoney = @"0";
    self.FormDatas.str_AdvanceInfo = @"";
    self.FormDatas.str_AdvanceId = @"";
    NSDictionary *advanceDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceId],
                                  @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceInfo]
                                  };
    [self.View_BorrowingForm updateView:advanceDict];
    
    //消费明细
    [self.FormDatas.arr_sonItem removeAllObjects];
    [self updateDetailsTableView];

    //处理金额相关数据
    [self.FormDatas dealWithAdvanceOrTravelFormMoney];
    self.txf_Loan.text = [GPUtils transformNsNumber:self.FormDatas.str_LoanTotalAmount];
    self.txf_InvLoanAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_InvLoanAmount];
    [self dealShowAmountData];
}

//MARK:修改报销类型
-(void)ChangeClaimType{
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"ClaimType"];
    choose.ChooseCategoryArray=self.FormDatas.arr_ClaimType;
    choose.ChooseCategoryId=self.FormDatas.str_ClaimTypeId;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.FormDatas.str_ClaimTypeId=[NSString stringWithFormat:@"%@",model.Id];
        weakSelf.FormDatas.str_ClaimType=[NSString stringWithFormat:@"%@",model.claimType];
        weakSelf.txf_ClaimType.text=self.FormDatas.str_ClaimType;
        if ([weakSelf.FormDatas.arr_isShowmsArray containsObject:@"ClaimType"]&&[weakSelf.FormDatas.arr_isShowmsArray containsObject:@"TravelNumber"]&&[NSString isEqualToNullAndZero:weakSelf.FormDatas.str_ClaimTypeId]) {
            weakSelf.FormDatas.bool_isReleTravel=[model.isRelation floatValue]==0?NO:YES;
        }
        [weakSelf dealApproveViewWithModel:model];
    };
    [self.navigationController pushViewController:choose animated:YES];
}
//MARK:修改受益人
-(void)BeneficiariesClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"11";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_BeneficiariesId componentsSeparatedByString:@","];
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
        weakSelf.FormDatas.str_BeneficiariesId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_Beneficiaries=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_Beneficiaries.text=weakSelf.FormDatas.str_Beneficiaries;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
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
//MARK:修改客户
-(void)ClientClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId = self.FormDatas.personalData.ClientId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ClientId = model.Id;
        weakSelf.FormDatas.personalData.ClientName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Client.text = weakSelf.FormDatas.personalData.ClientName;
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
        weakSelf.FormDatas.personalData.SupplierName =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text = weakSelf.FormDatas.personalData.SupplierName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:修改出差申请单
-(void)TravelFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"travelForm"];
    vc.ChooseCategoryId = self.FormDatas.str_travelFormId;
    vc.isMultiSelect = YES; vc.dict_otherPars=@{@"Type":self.FormDatas.str_TravelStatus,@"UserId":self.FormDatas.personalData.RequestorUserId,@"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_EstimatedAmount = @"0";
        weakSelf.FormDatas.str_travelFormMoney = @"0";
        self.FormDatas.str_InvtravelFormMoney = @"0";
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
            weakSelf.FormDatas.str_EstimatedAmount = [GPUtils decimalNumberAddWithString:model.estimatedAmount with:weakSelf.FormDatas.str_EstimatedAmount];
            weakSelf.FormDatas.str_travelFormMoney = [GPUtils decimalNumberAddWithString:model.advanceAmount with:weakSelf.FormDatas.str_travelFormMoney];
            weakSelf.FormDatas.str_InvtravelFormMoney = [GPUtils decimalNumberAddWithString:model.localCyAmount with:weakSelf.FormDatas.str_InvtravelFormMoney];
        }
        weakSelf.FormDatas.str_travelFormInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_travelFormId = [GPUtils getSelectResultWithArray:Id WithCompare:@","];

        if (array.count > 1) {
            self.FormDatas.bool_NeedCostDate = NO;
        }
        if (array.count == 1) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_travel_FromDate=model.fromDate;
            weakSelf.FormDatas.str_travel_ToDate=model.toDate;
            weakSelf.FormDatas.str_FromCityCode=model.fromCityCode;
            weakSelf.FormDatas.str_FromCity=model.fromCity;
            weakSelf.txf_FromCity.text = model.fromCity;
            weakSelf.FormDatas.str_ToCityCode=model.toCityCode;
            weakSelf.FormDatas.str_ToCity=model.toCity;
            weakSelf.txf_ToCity.text = model.toCity;
            weakSelf.FormDatas.str_FromDate=model.fromDateStr;
            weakSelf.txf_FromDate.text=model.fromDateStr;
            weakSelf.FormDatas.str_ToDate=model.toDateStr;
            weakSelf.txf_ToDate.text=model.toDateStr;
            weakSelf.FormDatas.str_FellowOfficersId=model.fellowOfficersId;
            weakSelf.FormDatas.str_FellowOfficers=model.fellowOfficers;
            weakSelf.txf_FellowOfficers.text =model.fellowOfficers;
            weakSelf.FormDatas.str_travelTypeId = model.travelTypeId;
            weakSelf.FormDatas.str_travelType = model.travelType;
            weakSelf.txf_TravelType.text = model.travelType;
            weakSelf.FormDatas.str_relevantDeptId = model.relevantDeptId;
            weakSelf.FormDatas.str_relevantDept = model.relevantDept;
            weakSelf.txf_RelevantDept.text = model.relevantDept;
            weakSelf.FormDatas.str_financialSourceId = model.financialSourceId;
            weakSelf.FormDatas.str_financialSource = model.financialSource;
            weakSelf.txf_FinancialSource.text = model.financialSource;
        }else{
            weakSelf.FormDatas.str_travel_FromDate=@"";
            weakSelf.FormDatas.str_travel_ToDate=@"";
            weakSelf.FormDatas.str_FromCityCode=@"";
            weakSelf.FormDatas.str_FromCity=@"";
            weakSelf.txf_FromCity.text = @"";
            weakSelf.FormDatas.str_ToCityCode=@"";
            weakSelf.FormDatas.str_ToCity=@"";
            weakSelf.txf_ToCity.text = @"";
            weakSelf.FormDatas.str_FromDate=@"";
            weakSelf.txf_FromDate.text=@"";
            weakSelf.FormDatas.str_ToDate=@"";
            weakSelf.txf_ToDate.text=@"";
            weakSelf.FormDatas.str_FellowOfficersId=@"";
            weakSelf.FormDatas.str_FellowOfficers=@"";
            weakSelf.txf_FellowOfficers.text =@"";
            weakSelf.FormDatas.str_travelTypeId = @"";
            weakSelf.FormDatas.str_travelType = @"";
            weakSelf.txf_TravelType.text = @"";
            weakSelf.FormDatas.str_relevantDeptId = @"";
            weakSelf.FormDatas.str_relevantDept = @"";
            weakSelf.txf_RelevantDept.text = @"";
            weakSelf.FormDatas.str_financialSourceId = @"";
            weakSelf.FormDatas.str_financialSource = @"";
            weakSelf.txf_FinancialSource.text = @"";
        }
        weakSelf.txf_Estimated.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        [weakSelf.FormDatas dealWithAdvanceOrTravelFormMoney];
        weakSelf.txf_Loan.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_LoanTotalAmount];
        weakSelf.txf_InvLoanAmount.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_InvLoanAmount];
        if ([[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_amountPrivate with:weakSelf.FormDatas.str_LoanTotalAmount]floatValue]<0) {
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:@"0"];
        }else{
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_amountPrivate with:weakSelf.FormDatas.str_LoanTotalAmount]];
        }
        if ([[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_InvTotalAmount with:weakSelf.FormDatas.str_InvLoanAmount]floatValue]<0) {
            weakSelf.txf_InvActualAmount.text = [GPUtils transformNsNumber:@"0"];
        }else{
            weakSelf.txf_InvActualAmount.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_InvTotalAmount with:weakSelf.FormDatas.str_InvLoanAmount]];
        }
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo]                               };
        [weakSelf.View_TravelForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:修改同行人员
-(void)EntourageClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"3";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_FellowOfficersId componentsSeparatedByString:@","];
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
        weakSelf.FormDatas.str_FellowOfficersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_FellowOfficers=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_FellowOfficers.text=weakSelf.FormDatas.str_FellowOfficers;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:修改外出申请单
-(void)StaffOutFormClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"StaffOut"];
    vc.ChooseCategoryId=self.FormDatas.str_StaffOutNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_StaffOutInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_StaffOutNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutInfo]                               };
        [weakSelf.View_StaffOutForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改用车申请单
-(void)VehicleFormClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"VehicleForm"];
    vc.ChooseCategoryId=self.FormDatas.str_VehicleNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_VehicleInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_VehicleNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleInfo]                               };
        [weakSelf.View_VehicleForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改借款单
-(void)BorrowingFormClick{
    [self keyClose];
    BorrowingFormChooseController *choose = [[BorrowingFormChooseController alloc]init];
    choose.ChooseCategoryId = self.FormDatas.str_AdvanceId;
    choose.str_ReversalType = self.FormDatas.str_ReversalType;
    choose.dict_otherPars = @{@"UserId":self.FormDatas.personalData.RequestorUserId,
                              @"FlowCode":self.FormDatas.str_flowCode,
                              @"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    choose.ChooseBorrowFormBlock = ^(NSMutableArray *array, NSString *reversalType) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_AdvanceMoney = @"0";
        weakSelf.FormDatas.str_InvAdvanceMoney = @"0";
        weakSelf.FormDatas.str_ReversalType = reversalType;
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
            weakSelf.FormDatas.str_AdvanceMoney = [GPUtils decimalNumberAddWithString:model.amount with:weakSelf.FormDatas.str_AdvanceMoney];
            weakSelf.FormDatas.str_InvAdvanceMoney = [GPUtils decimalNumberAddWithString:model.originalCurrencyAmt with:weakSelf.FormDatas.str_InvAdvanceMoney];

        }
        weakSelf.FormDatas.str_AdvanceInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_AdvanceId = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        [weakSelf.FormDatas dealWithAdvanceOrTravelFormMoney];
        weakSelf.txf_Loan.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_LoanTotalAmount];
        weakSelf.txf_InvLoanAmount.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_InvLoanAmount];
        if ([[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_amountPrivate with:weakSelf.FormDatas.str_LoanTotalAmount]floatValue]<0) {
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:@"0"];
        }else{
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_amountPrivate with:weakSelf.FormDatas.str_LoanTotalAmount]];
        }
        if ([[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_InvTotalAmount with:weakSelf.FormDatas.str_InvLoanAmount]floatValue]<0) {
            weakSelf.txf_InvActualAmount.text=[GPUtils transformNsNumber:@"0"];
        }else{
            weakSelf.txf_InvActualAmount.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_InvTotalAmount with:weakSelf.FormDatas.str_InvLoanAmount]];
        }
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceId],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceInfo]                               };
        [weakSelf.View_BorrowingForm updateView:dict];
        
    };
    [self.navigationController pushViewController:choose animated:YES];
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
    contactVC.menutype=3;
    contactVC.itemType = 2;
    contactVC.Radio = @"1";
    contactVC.universalDelegate = self;
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
//MARK:记一笔增加返回
-(void)addCost:(NSNotification *)not{
    NSDictionary *dict = not.userInfo;
    NSDictionary *dic=[dict objectForKey:@"info"];
    [self.FormDatas travel_daily_otherReimAddCost:dic];
    [self dealShowAmountData];
    [self updateDetailsTableView];
}
//MARK:记一笔修改返回
-(void)editCost:(NSNotification *)not{
    NSDictionary *dict = not.userInfo;
    NSDictionary *dic=[dict objectForKey:@"info"];
    [self.FormDatas travel_daily_otherReimEditCost:dic];
    [self dealShowAmountData];
    [_View_DetailsTable reloadData];
}

-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}

//MARK:-tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView == _View_DetailsTable||tableView == _View_table) {
        return 1;
    }else if (tableView == _View_PayeeTable){
        return self.FormDatas.arr_ThirDetailsDataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _View_DetailsTable) {
        return 46;
    }else if (tableView == _View_PayeeTable){
        return 27;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _View_DetailsTable) {
        [self createDetailHeadView];
        return _View_DetailsHead;
    }else if (tableView == _View_PayeeTable){
        [self createPayeeHeadViewWithSection:section];
        return _View_PayeeHead;
    }
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, Main_Screen_Width, 0.01);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _View_DetailsTable) {
        return self.FormDatas.arr_sonItem.count;
    }else if (tableView == _View_table) {
        return self.FormDatas.arr_table.count;
    }else if (tableView == _View_PayeeTable){
        return self.FormDatas.arr_ThirDetailsArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_DetailsTable) {
        AddDetailsModel *model = (AddDetailsModel *)self.FormDatas.arr_sonItem[indexPath.row];
        return [ExpenseSonListCell cellHeightWithModel:model];
    }else  if (tableView==_View_table){
        return 40;
    }else if (tableView==_View_PayeeTable){
        return 42;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _View_DetailsTable) {
        ExpenseSonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseSonListCell"];
        if (cell == nil) {
            cell = [[ExpenseSonListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseSonListCell"];
        }
        AddDetailsModel *model = (AddDetailsModel *)self.FormDatas.arr_sonItem[indexPath.row];
        [cell configCellWithModel:model withHasLine:(indexPath.row != self.FormDatas.arr_sonItem.count - 1)];
        __weak typeof(self) weakSelf = self;
        cell.expClickedBlock = ^{
            [weakSelf keyClose];
            weakSelf.FormDatas.index_item = indexPath.row;
            NewAddCostViewController *add = [[NewAddCostViewController alloc]init];
            add.dict_parameter = @{@"UserId":weakSelf.FormDatas.personalData.OperatorUserId,
                                   @"OwnerUserId":weakSelf.FormDatas.personalData.OperatorUserId,
                                   @"ProcId":weakSelf.FormDatas.str_procId,
                                   @"FlowGuid":weakSelf.FormDatas.str_flowGuid,
                                   @"CostCenterId":(self.FormDatas.bool_IsHasShowProject && [NSString isEqualToNull:self.FormDatas.personalData.CostCenterId])? self.FormDatas.personalData.CostCenterId:@"0",
                                   @"Requestor":self.FormDatas.personalData.Requestor,
                                   };
            add.Id = [model.Id integerValue];
            add.Type = 1;
            add.check = model.checked;
            add.Enabled_Expense = 1;
            add.Enabled_addAgain = 1;
            add.Action = 2;
            [weakSelf.navigationController pushViewController:add animated:YES];
        };
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
    }else if (tableView==_View_PayeeTable){
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        [cell configPayeeDeatilCellWithModel:self.FormDatas.arr_ThirDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_ThirDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_ThirDetailsArray.count WithIndex:indexPath.row];
        cell.IndexPath=indexPath;

        if (cell.NameBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setNameCellClickedBlock:^(NSIndexPath *index, UITextField *tf) {
                PayeeDetails *modelD=[weakSelf.FormDatas.arr_ThirDetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    PayeeDetails *modelD=[[PayeeDetails alloc]init];
                    [weakSelf.FormDatas.arr_ThirDetailsDataArray insertObject:modelD atIndex:index.section];
                }
                PayeesChooseViewController *vc=[[PayeesChooseViewController alloc]init];
                vc.PayeesChooseBlock = ^(ChooseCateFreModel *model) {
                    modelD.Payee = model.payee;
                    modelD.CredentialType = model.credentialType;
                    modelD.IdentityCardId = model.identityCardId;
                    modelD.BankAccount = model.bankAccount;
                    modelD.DepositBank = model.depositBank;
                    modelD.BankOutlets = model.bankOutlets;
                    modelD.BankNo = model.bankNo;
                    modelD.BankCode = model.bankCode;
                    modelD.CNAPS = model.cnaps;
                    modelD.BankProvinceCode = model.bankProvinceCode;
                    modelD.BankProvince = model.bankProvince;
                    modelD.BankCityCode = model.bankCityCode;
                    modelD.BankCity = model.bankCity;
                    [weakSelf.View_PayeeTable reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        
        [cell.SizeTextField addTarget:self action:@selector(DepositBankChange:) forControlEvents:UIControlEventEditingChanged];
        cell.SizeTextField.tag=100+indexPath.section;
        cell.SizeTextField.delegate = self;
    
        if (cell.SupplierBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                PayeeDetails *modelD=[weakSelf.FormDatas.arr_ThirDetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    PayeeDetails *modelD=[[PayeeDetails alloc]init];
                    [weakSelf.FormDatas.arr_ThirDetailsDataArray insertObject:modelD atIndex:index.section];
                }
                ChangePhoneNumController *change = [[ChangePhoneNumController alloc]init];
                change.type = 2;
                __weak typeof(self) weakSelf = self;
                change.numDataChangeBlock = ^(NSString *numData, NSInteger type) {
                    modelD.BankAccount = numData;
                    tf.text = [NSString getSecretBankAccount:numData];
                };
                [weakSelf.navigationController pushViewController:change animated:YES];
            }];
        }
        
        [cell.AmountTF addTarget:self action:@selector(AmountChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag=160+indexPath.section;
        cell.AmountTF.delegate = self;
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self keyClose];
    if (tableView == _View_DetailsTable) {
        AddDetailsModel *model = (AddDetailsModel *)self.FormDatas.arr_sonItem[indexPath.row];
        model.checked = [model.checked isEqualToString:@"1"] ? @"0":@"1";
        [self dealShowAmountData];
        [self.View_DetailsTable reloadData];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView == _View_DetailsTable;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:Custing(@"删除", nil)  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.FormDatas.arr_sonItem removeObjectAtIndex:indexPath.row];
        [self dealShowAmountData];
        [self updateDetailsTableView];
    }];
    return @[deleteRowAction];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    return UITableViewCellEditingStyleDelete;//删除cell
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete) {
    }
}
-(void)dealApproveViewWithModel:(ChooseCategoryModel *)model{
    if ([self.FormDatas.model_ApprovalMode.isShow floatValue]==0) {
        if ([model.setApprover floatValue]==1) {
            self.FormDatas.model_ApprovelPeoModel.Description=Custing(@"审批人", nil);
            [self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:@"FirstHandlerUserName"];
            for(UIView *view in [_View_Approve subviews]){
                [view removeFromSuperview];
            }
            [self updateApproveViewWithModel:self.FormDatas.model_ApprovelPeoModel];
            [self.FormDatas.arr_isShowmsArray removeObject:@"FirstHandlerUserName"];
            [self.FormDatas.arr_isShowmsArray addObject:@"FirstHandlerUserName"];
        }else{
            [self.FormDatas.dict_isRequiredmsdic setValue:@"0" forKey:@"FirstHandlerUserName"];
            for(UIView *view in [_View_Approve subviews]){
                [view removeFromSuperview];
            }
            [_View_Approve updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.FormDatas.str_firstHanderName=@"";
            self.FormDatas.str_firstHanderId=@"";
        }
    }
}
//MARK:分摊返回
-(void)ReimShareData:(ReimShareModel *)model WithType:(NSInteger)type{
    if (type==1) {
        [self.FormDatas.arr_ShareData addObject:model];
    }
    [_ReimShareMainView updateMainView];
}
//MARK:创建详情头视图
-(void)createDetailHeadView{
    
    _View_DetailsHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 46)];
    _View_DetailsHead.backgroundColor=Color_Orange_Weak_20;

    _Imv_AllSecect = [GPUtils createImageViewFrame:CGRectMake(0,0,18,18) imageName:@"MyApprove_Select"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checked MATCHES %@", @"0"];
    NSArray* tempArr = [self.FormDatas.arr_sonItem filteredArrayUsingPredicate:predicate];
    if (self.FormDatas.arr_sonItem.count == 0 || tempArr.count > 0) {
        _Imv_AllSecect.image = [UIImage imageNamed:@"MyApprove_UnSelect"];
    }

    _Imv_AllSecect.center = CGPointMake(23, 23);
    [_View_DetailsHead addSubview:_Imv_AllSecect];
    UILabel *selectAll = [GPUtils createLable:CGRectMake(45, 0, 70, 46) text:Custing(@"全选", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    [_View_DetailsHead addSubview:selectAll];
    UIButton *selectAllBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 116, 46)];
    [selectAllBtn addTarget:self action:@selector(SelectAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [_View_DetailsHead addSubview:selectAllBtn];
    
//    UIImageView *Add=[GPUtils createImageViewFrame:CGRectMake(0, 0, 20, 20) imageName:@"share_AddCustom"];
//    Add.center=CGPointMake(Main_Screen_Width/2+23, 23);
//    [_View_DetailsHead addSubview:Add];
    CGFloat width = (Main_Screen_Width - 116)/2;
    UIButton *AddBtn = [GPUtils createButton:CGRectMake(116, 0, width, 46) action:@selector(addCustomClick:) delegate:self title:Custing(@"添加费用明细", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [_View_DetailsHead addSubview:AddBtn];

    UIButton *LoadBtn = [GPUtils createButton:CGRectMake(116+width, 0, width, 46) action:@selector(importCustomClick:) delegate:self title:Custing(@"导入费用明细", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [_View_DetailsHead addSubview:LoadBtn];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(115, 0, 1, 46)];
    line.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_View_DetailsHead addSubview:line];

    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(115+width, 0, 1, 46)];
    line1.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_View_DetailsHead addSubview:line1];
    
//    if (self.FormDatas.bool_IsNotShowAddExpense) {
//        line.hidden = YES;
//        line1.hidden = YES;
//        AddBtn.hidden = YES;
//        LoadBtn.hidden = YES;
//    }
}

-(void)createPayeeHeadViewWithSection:(NSInteger)section{
    _View_PayeeHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_PayeeHead addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_PayeeHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_ThirDetailsDataArray.count==1) {
        titleLabel.text=Custing(@"收款人", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"收款人", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=3200+section;
            [_View_PayeeHead addSubview:deleteBtn];
        }
    }
    _View_PayeeHead.backgroundColor=Color_White_Same_20;
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    NSString *title;
    if (btn.tag>=3200){
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除收款人", nil),(long)(btn.tag-3200+1)];
    }
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:nil message:title cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"删除",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (btn.tag>=3200) {
                [weakSelf.FormDatas.arr_ThirDetailsDataArray removeObjectAtIndex:btn.tag-3200];
                [weakSelf updateThirDetailsTableView];
            }
        }
    }];
}
//MARK:明细详情填写
-(void)DepositBankChange:(UITextField *)text{
    PayeeDetails *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        PayeeDetails *model=[[PayeeDetails alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.DepositBank=text.text;
    }else{
        model.DepositBank=text.text;
    }
}
-(void)AmountChange:(UITextField *)text{
    PayeeDetails *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-160];
    if (!model) {
        PayeeDetails *model=[[PayeeDetails alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-160];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
}
//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField.tag>=160&&textField.tag<=210)  //判断是否时我们想要限定的那个输入框
    {
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
        
    }else if (textField.tag>=100&&textField.tag<=150){
        if ([toBeString length] >255) {
            textField.text = [toBeString substringToIndex:255];
            return NO;
        }
    }else if (textField.tag>=1000&&textField.tag<=1050){
        if ([toBeString length] >100) {
            textField.text = [toBeString substringToIndex:100];
            return NO;
        }
    }
    return YES;
}

//MARK:金额相关视图数据
-(void)dealShowAmountData{
    [self.FormDatas getTravel_Daily_OtherReimTotalAmount];
    _txf_PrivateAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_amountPrivate];
    _txf_CompanyAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_amountCompany];
    _txf_TotalAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_amountTotal];
    _txf_Capitalized.text = [NSString getChineseMoneyByString:_txf_TotalAmount.text];
    _txf_NoInvoice.text = [GPUtils transformNsNumber:self.FormDatas.str_NoInvAmount];
    _txf_InvLoanAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_InvLoanAmount];
    _txf_InvTotalAmount.text = [GPUtils transformNsNumber:self.FormDatas.str_InvTotalAmount];
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountPrivate with:self.FormDatas.str_LoanTotalAmount]floatValue]<0) {
        _txf_Actual.text=[GPUtils transformNsNumber:@"0"];
    }else{
        _txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountPrivate with:self.FormDatas.str_LoanTotalAmount]];
    }
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount]floatValue]<0) {
        _txf_InvActualAmount.text = [GPUtils transformNsNumber:@"0"];
    }else{
        _txf_InvActualAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount]];
    }
}
//MARK:通知释放
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
//MARK:数据的保存
-(void)saveInfo{
    [self keyClose];
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
}
//MARK:数据的提交
-(void)submitInfo
{
    [self keyClose];
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo
{
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
    [self.FormDatas getSubmitSaveIdString];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str = [self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            if ([str isEqualToString:Custing(@"请选择费用明细", nil)]) {
                UIAlertView* alertView = [[UIAlertView alloc]
                                          initWithTitle:str message:nil delegate:self cancelButtonTitle:Custing(@"确认", nil) otherButtonTitles:nil];
                [alertView show] ;
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            }
            self.dockView.userInteractionEnabled=YES;
            return;
        }
    }
    if (self.FormDatas.bool_IsHasShowProject && (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3) && [NSString isEqualToNullAndZero :self.FormDatas.personalData.CostCenterId]) {

        [[GPClient shareGPClient]REquestByPostWithPath:XB_ProjsByCostcenter Parameters:[self.FormDatas getProjsByCostcenterParam] Delegate:self SerialNum:4 IfUserCache:NO];
    }else{
        [self getExpShareApprovalId];
    }
}
-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason=self.txv_Reason.text;
    self.FormDatas.SubmitData.NumberOfDocuments =_txf_DocumentNum.text;
    self.FormDatas.SubmitData.SumAmount=[NSString notRounding:self.FormDatas.str_amountPrivate afterPoint:2];
    self.FormDatas.SubmitData.CorpPayAmount=[NSString notRounding:self.FormDatas.str_amountCompany afterPoint:2];
    self.FormDatas.SubmitData.TotalAmount=[NSString notRounding:self.FormDatas.str_amountTotal afterPoint:2];
    self.FormDatas.SubmitData.CapitalizedAmount=[NSString getChineseMoneyByString:self.FormDatas.SubmitData.TotalAmount];
    self.FormDatas.SubmitData.ActualAmount=[NSString isEqualToNull:_txf_Actual.text]?[_txf_Actual.text stringByReplacingOccurrencesOfString:@"," withString:@""]:[self.FormDatas dealWithAcutual];
    self.FormDatas.SubmitData.NoInvAmount=[NSString isEqualToNull:_txf_NoInvoice.text]?[_txf_NoInvoice.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"";
    
    self.FormDatas.SubmitData.InvTotalAmount = [NSString notRounding:self.FormDatas.str_InvTotalAmount afterPoint:2];
    self.FormDatas.SubmitData.InvActualAmount = [NSString isEqualToNull:_txf_InvActualAmount.text]?[_txf_InvActualAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]:([[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount]floatValue] < 0 ? @"0.00":([GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_InvTotalAmount with:self.FormDatas.str_InvLoanAmount] afterPoint:2]));

    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
    self.FormDatas.SubmitData.OverBudReason=_txv_OverBud.text;
    //修改超预算必填判断
    if ([self.FormDatas.SubmitData.EstimatedAmount floatValue]>0) {
        [[GPUtils decimalNumberSubWithString:self.FormDatas.SubmitData.TotalAmount with:self.FormDatas.SubmitData.EstimatedAmount]floatValue]>0?[self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:@"OverBudReason"]:[self.FormDatas.dict_isRequiredmsdic setValue:@"0" forKey:@"OverBudReason"];
    }
}
//MARK:获取分摊审批者Id
-(void)getExpShareApprovalId{
    [[GPClient shareGPClient]REquestByPostWithPath:GETCOSTSHAREAPPROVALID Parameters:[self.FormDatas getExpShareApprovalIdParam] Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:获取分摊信息
-(void)getExpShareDates{
    [[GPClient shareGPClient]REquestByPostWithPath:GETEXPSHAREDATE Parameters:[self.FormDatas getExpShareInfoParam] Delegate:self SerialNum:6 IfUserCache:NO];
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
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


//* @param RequestorUserId操作用户ID  (创建界面时获取）
//* @param FlowGuid        操作标示 （创建界面时获取）
//* @param FlowCode        操作表单type（创建界面时获取“F0001-出差申请 F0002 - 差旅报销         F0003 日常报销”）
//*ActionLinkName动作名称(“提交”) （类型string）提交/保存
//* @param TaskId          流程ID 默认0
//* @param FormData        表单数据（JSON）
//* @param comment         意见 （在对表单操作［审批。。］时候）空
//* @param ExpIds    消费记录ID  “89,100”
//RequestorUserId/FlowGuid/FlowCode/ActionLinkName//TaskId //FormData//ExpIds//Comment
//差旅报销保存
-(void)requestAppSave
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:第一次提交验证
-(void)checkTravelReimSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getCheckSubmitUrl] Parameters:[self.FormDatas GetCheckSubmitWithAmount:self.FormDatas.str_amountPrivate WithExpIds:self.FormDatas.str_submitId otherParameters:[self.FormDatas getCheckSubmitOtherPar]] Delegate:self SerialNum:14 IfUserCache:NO];
}
//MARK:验证完成提交
-(void)requestAppSubmit
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:[self.FormDatas SubmitFormDateWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:[self.FormDatas getCommonField]] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.str_CommonField=[self.FormDatas getCommonField];
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:[self.FormDatas SubmitFormAgainWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:[self.FormDatas getCommonField]] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.str_CommonField=[self.FormDatas getCommonField];
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

