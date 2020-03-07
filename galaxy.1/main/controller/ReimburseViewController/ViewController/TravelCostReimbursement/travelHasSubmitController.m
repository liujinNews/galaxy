//
//  travelHasSubmitController.m
//  galaxy
//
//  Created by hfk on 16/5/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "travelHasSubmitController.h"

@interface travelHasSubmitController ()


@end

@implementation travelHasSubmitController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[travelReimFormDate alloc]initWithStatus:2];
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
    }else if (self.FormDatas.int_comeStatus==4){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"确认支付" , nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf dockViewClick:3];
            }
        };
    }
}

//MARK:操作完成后回来刷新
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==4||self.FormDatas.int_comeStatus==7||self.FormDatas.int_comeStatus==8||self.FormDatas.int_comeStatus==9) {
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
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Requestor=[[UIView alloc]init];
    _View_Requestor.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Requestor];
    [_View_Requestor makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom).offset(@10);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PriveateAmount=[[UIView alloc]init];
    _View_PriveateAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PriveateAmount];
    [_View_PriveateAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Requestor.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LoanAmount=[[UIView alloc]init];
    _View_LoanAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LoanAmount];
    [_View_LoanAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PriveateAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ActualAmount=[[UIView alloc]init];
    _View_ActualAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ActualAmount];
    [_View_ActualAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LoanAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_CompanyAmount=[[UIView alloc]init];
    _View_CompanyAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CompanyAmount];
    [_View_CompanyAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ActualAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalAmount=[[UIView alloc]init];
    _View_TotalAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalAmount];
    [_View_TotalAmount makeConstraints:^(MASConstraintMaker *make) {
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
    [_View_NoInvoice makeConstraints:^(MASConstraintMaker *make) {
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
    
    _CurrencySumView = [[BaseFormSumView alloc]init];
    _CurrencySumView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CurrencySumView];
    [_CurrencySumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CostCateSumView = [[BaseFormSumView alloc]init];
    _CostCateSumView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_CostCateSumView];
    [_CostCateSumView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CurrencySumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CustomTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_CustomTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_CustomTable.delegate=self;
    _View_CustomTable.dataSource=self;
    _View_CustomTable.scrollEnabled=NO;
    _View_CustomTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_CustomTable];
    [_View_CustomTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CostCateSumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayeeTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_PayeeTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_PayeeTable.delegate = self;
    _View_PayeeTable.dataSource = self;
    _View_PayeeTable.scrollEnabled = NO;
    _View_PayeeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PayeeTable];
    [_View_PayeeTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CustomTable.bottom);
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
    
    _view_line1=[[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimShareDeptSumView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ClaimType=[[UIView alloc]init];
    _View_ClaimType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClaimType];
    [_View_ClaimType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClaimType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line2=[[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Beneficiaries=[[UIView alloc]init];
    _View_Beneficiaries.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Beneficiaries];
    [_View_Beneficiaries makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
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

    _View_TravelForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0001"];
    _View_TravelForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TravelForm];
    [_View_TravelForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelType=[[UIView alloc]init];
    _View_TravelType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TravelType];
    [_View_TravelType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelevantDept=[[UIView alloc]init];
    _View_RelevantDept.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelevantDept];
    [_View_RelevantDept makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FinancialSource = [[UIView alloc]init];
    _View_FinancialSource.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FinancialSource];
    [_View_FinancialSource makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelevantDept.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromDate=[[UIView alloc]init];
    _View_FromDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromDate];
    [_View_FromDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FinancialSource.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToDate=[[UIView alloc]init];
    _View_ToDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToDate];
    [_View_ToDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromCity = [[UIView alloc]init];
    _View_FromCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromCity];
    [_View_FromCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToCity = [[UIView alloc]init];
    _View_ToCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToCity];
    [_View_ToCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FellowOfficers=[[UIView alloc]init];
    _View_FellowOfficers.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FellowOfficers];
    [_View_FellowOfficers makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Estimated=[[UIView alloc]init];
    _View_Estimated.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Estimated];
    [_View_Estimated makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FellowOfficers.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OverBud=[[UIView alloc]init];
    _View_OverBud.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OverBud];
    [_View_OverBud makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Estimated.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StaffOutForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0016"];
    _View_StaffOutForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StaffOutForm];
    [_View_StaffOutForm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBud.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_VehicleForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0014"];;
    _View_VehicleForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VehicleForm];
    [_View_VehicleForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StaffOutForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BorrowForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0006"];;
    _View_BorrowForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BorrowForm];
    [_View_BorrowForm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DocumentNum=[[UIView alloc]init];
    _View_DocumentNum.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_DocumentNum];
    [_View_DocumentNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BorrowForm.bottom);
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
        make.top.equalTo(self.View_DocumentNum.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line3=[[UIView alloc]init];
    [self.contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SecDetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Payee=[[UIView alloc]init];
    _View_Payee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Payee];
    [_View_Payee makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount=[[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount makeConstraints:^(MASConstraintMaker *make) {
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
    
    _view_line4=[[UIView alloc]init];
    [self.contentView addSubview:_view_line4];
    [_view_line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PmtMethod.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceiptOfInv=[[UIView alloc]init];
    _View_ReceiptOfInv.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceiptOfInv];
    [_View_ReceiptOfInv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line4.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceiptOfInv.bottom);
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
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Budget=[[UIView alloc]init];
    _View_Budget.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Budget];
    [_View_Budget makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
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
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormSignInfoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
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
                [[GPAlertView sharedAlertView]showAlertText:self WithText:@"撤回成功"];
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
            self.PrintfBtn.userInteractionEnabled = YES;
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

//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];

    [self updateRequestorView];
    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:1];
    
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"SumAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_RequestorLine=1;
            [self updatePriveateAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LoanAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateLoanAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ActualAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateActualAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CorpPayAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateCompanyAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateTotalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateCapitalizedAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"NoInvAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateNoInvAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvLoanAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateInvLoanAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvTotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateInvTotalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvActualAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateInvActualAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_RequestorLine=1;
            [self updateCurrencyCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClaimType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1=1;
            [self updateClaimTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1=1;
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BnfId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateBeneficiariesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateTravelFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateTravelTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelevantDept"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateRelevantDeptViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FinancialSource"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateFinancialSourceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateTravelDuringViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateFromCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ToCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateToCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FellowOfficers"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateTravelFellowOfficersViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateEstimatedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OverBudReason"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateOverBudViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"StaffOutNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateStaffOutNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateVehicleNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"AdvanceNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateBorrowFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"NumberOfDocuments"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2=1;
            [self updateDocumentNumViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Payee"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3=1;
            [self updatePayeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3=1;
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankOutlets"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateBankOutletsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateBankCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PmtMethod"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line3=1;
            [self updatePmtMethodViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsReceiptOfInv"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4=1;
            [self updateReceiptOfInvViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4=1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsDeptBearExps"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4=1;
            [self updateIsDeptBearExpsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4=1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line4=1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line4=1;
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==4) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    if (![self.FormDatas.arr_sonItem isKindOfClass:[NSNull class]]&&self.FormDatas.arr_sonItem.count!=0) {
        _int_RequestorLine = 1;
        [self updateCustomTableView];
    }
    if (self.FormDatas.bool_isShowCurrencySum && self.FormDatas.arr_CurrencySum.count > 0) {
        _int_RequestorLine = 1;
        [_CurrencySumView updateBaseFormSumViewWithData:self.FormDatas WithType:1];
    }
    if (self.FormDatas.arr_travelSum.count!=0) {
        _int_RequestorLine = 1;
        [_CostCateSumView updateBaseFormSumViewWithData:self.FormDatas WithType:2];
    }
    //分摊数据显示
    if (self.FormDatas.bool_ShareShow == YES) {
        if (self.FormDatas.int_ShareShowModel == 1) {
            if (self.FormDatas.arr_ShareDeptSumData.count > 0) {
                _int_RequestorLine = 1;
                [self updateReimShareViewWithType:2];
            }
        }else{
            if (self.FormDatas.arr_ShareData.count > 0) {
                _int_RequestorLine = 1;
                [self updateReimShareViewWithType:1];
            }
        }
    }

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
    
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    
    if (self.FormDatas.bool_SecDetailsShow&&self.FormDatas.arr_SecDetailsDataArray.count!=0) {
        [self updateSecDetailsTableView];
        [_View_SecDetailsTable reloadData];
    }
    
    if (self.FormDatas.bool_ThirDetailsShow&&self.FormDatas.arr_ThirDetailsDataArray.count!=0) {
        [self updatePayeeTable];
        [_View_PayeeTable reloadData];
    }
    
    [self updateBottomView];
}
//MARK:更新申请人视图
-(void)updateRequestorView{
    [_View_Requestor updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
    }];
    
    UIImageView *requestorImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 11, 58, 58)];
    if ([NSString isEqualToNull:self.FormDatas.personalData.RequestorPhotoGraph]) {
        [requestorImage sd_setImageWithURL:[NSURL URLWithString:self.FormDatas.personalData.RequestorPhotoGraph]];
    }else{
        if (![NSString isEqualToNull:self.FormDatas.personalData.RequestorGender]||[[NSString stringWithFormat:@"%@",self.FormDatas.personalData.RequestorGender]isEqualToString:@"0"]) {
            requestorImage.image=[UIImage imageNamed:@"Message_Man"];
        }else{
            requestorImage.image=[UIImage imageNamed:@"Message_Woman"];
        }
    }
    requestorImage.backgroundColor=Color_form_TextFieldBackgroundColor;
    requestorImage.layer.masksToBounds=YES;
    requestorImage.layer.cornerRadius = 29.0f;
    [_View_Requestor addSubview:requestorImage];
    
    UILabel *nameLabel = [GPUtils createLable:CGRectMake(88, 10, 150, 60) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    nameLabel.numberOfLines=0;
    [_View_Requestor addSubview:nameLabel];
    
    if ([NSString isEqualToNull:self.FormDatas.personalData.Requestor]) {
        nameLabel.text=self.FormDatas.personalData.Requestor;
    }
    
    CGSize size = [NSString sizeWithText:[NSString stringWithFormat:@"%@%@",Custing(@"   单号:", nil),self.FormDatas.str_SerialNo] font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, 20)];
    
    UILabel *numberTitle=[GPUtils createLable:CGRectMake(Main_Screen_Width-size.width-10,25,size.width+20, 25) text:Custing(@"   单号:", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    if ([NSString isEqualToNull:self.FormDatas.str_SerialNo]) {
        numberTitle.text=[NSString stringWithFormat:@"%@%@",Custing(@"   单号:", nil),self.FormDatas.str_SerialNo];
    }
    numberTitle.layer.cornerRadius = 12.5;
    numberTitle.layer.masksToBounds = YES;
    numberTitle.layer.borderWidth = 0.5;
    numberTitle.layer.borderColor = Color_GrayDark_Same_20.CGColor;
    [_View_Requestor addSubview:numberTitle];
    [_View_Requestor addSubview:[XBHepler creation_State_Lab:self.FormDatas.str_noteStatus]];
}
//MARK:更新报销金额
-(void)updatePriveateAmountViewWithModel:(MyProcurementModel *)model{
    [_View_PriveateAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_PriveateAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];

}
//MARK:更新减借款
-(void)updateLoanAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_LoanAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_LoanAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新应付金额
-(void)updateActualAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ActualAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_ActualAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新公司合计金额
-(void)updateCompanyAmountViewWithModel:(MyProcurementModel *)model{
    [_View_CompanyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_CompanyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合计金额
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    [_View_TotalAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_TotalAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新报销金额大写
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Capitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Capitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新无发票金额
-(void)updateNoInvAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    
    [_View_NoInvoice addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_NoInvoice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新付款冲销减借款视图
-(void)updateInvLoanAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_InvLoanAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_InvLoanAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款报销总额视图
-(void)updateInvTotalAmountViewWithModel:(MyProcurementModel *)model{
    [_View_InvTotalAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_InvTotalAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款应付金额视图
-(void)updateInvActualAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_InvActualAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_InvActualAmount updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新报销明细
-(void)updateCustomTableView{
    
    NSInteger height=0;
    if (self.FormDatas.arr_sonItem.count<=4||self.FormDatas.bool_isOpenDetail) {
        for (HasSubmitDetailModel *model in self.FormDatas.arr_sonItem) {
            height+=[travelHasSubmitCell cellHeightWithObj:model];
        }
        [_View_CustomTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(30+height));
        }];
    }else{
        for (int i=0; i<4; i++) {
            HasSubmitDetailModel *model=self.FormDatas.arr_sonItem[i];
            height+=[travelHasSubmitCell cellHeightWithObj:model];
        }
        [_View_CustomTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height+30));
        }];
    }
    [_View_CustomTable reloadData];
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
//MARK:更新分摊明细
-(void)updateReimShareViewWithType:(NSInteger)type{
    if (type == 1) {
        [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:2 WithComePlace:1];
    }else{
        [_ReimShareDeptSumView updateBaseFormSumViewWithData:self.FormDatas WithType:3];
    }
}
-(void)updateClaimTypeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ClaimType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ClaimType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新报销事由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新受益人
-(void)updateBeneficiariesViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_Beneficiaries]?[NSString stringWithFormat:@"%@",self.FormDatas.str_Beneficiaries]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Beneficiaries addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Beneficiaries updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新客户名称
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.ClientName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.ClientName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商名称
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.SupplierName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.SupplierName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出差申请单
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

//MARK:出差类型
-(void)updateTravelTypeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_TravelType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_TravelType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:归口部门
-(void)updateRelevantDeptViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_RelevantDept addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_RelevantDept updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:经费来源
-(void)updateFinancialSourceViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_FinancialSource addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FinancialSource updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:出差期间
-(void)updateTravelDuringViewWithModel:(MyProcurementModel *)model{
    model.Description = Custing(@"出发时间",nil);
    __weak typeof(self) weakSelf = self;
    [_View_FromDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FromDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    model.Description = Custing(@"返回时间",nil);
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_ToDate]?[NSString stringWithFormat:@"%@",self.FormDatas.str_ToDate]:@"";
    [_View_ToDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ToDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出发地
-(void)updateFromCityViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_FromCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FromCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新目的地
-(void)updateToCityViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ToCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ToCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:同行人员
-(void)updateTravelFellowOfficersViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_FellowOfficers addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FellowOfficers updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新预估金额视图
-(void)updateEstimatedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Estimated addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [weakSelf.View_Estimated updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新超预算原因单视图
-(void)updateOverBudViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_OverBud addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_OverBud updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新外出单请单
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

//MARK:更新借款单请单
-(void)updateBorrowFormViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_AdvanceInfo],
                           @"Model":model
                           };
    [_View_BorrowForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_BorrowForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}

//MARK:更新单据数量
-(void)updateDocumentNumViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_DocumentNum addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_DocumentNum updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新结算信息
-(void)updateSecDetailsTableView{
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

//MARK:更新收款人
-(void)updatePayeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Payee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Payee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新银行账号
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString getSecretBankAccount:model.fieldValue];
    __weak typeof(self) weakSelf = self;
    [_View_BankAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_BankAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户行网点
-(void)updateBankOutletsViewWithModel:(MyProcurementModel *)model{
    [_View_BankOutlets addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankOutlets updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
}
//MARK:更新开户行
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    [_View_BankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
//MARK:更新结算方式
-(void)updatePmtMethodViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_PmtMethod addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_PmtMethod updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
//        _Lab_ReceiptOfInv.textColor=Color_Blue_Important_20;
        _Lab_ReceiptOfInv.userInteractionEnabled=YES;
        [_Lab_ReceiptOfInv bk_whenTapped:^{
            [weakSelf changeReceiptOfInv];
        }];
    }
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
//MARK:更新图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount = 10;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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
//MARK:更新报销审批人
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
//MARK:更新底层视图
-(void)updateBottomView{
    if (_int_RequestorLine==1) {
        [_View_Requestor addSubview:[self createLineViewOfHeight_ByTitle:79.5]];
    }
    if (_int_line1==1) {
        [_view_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line2==1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line3==1) {
        [_view_line3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line4==1) {
        [_view_line4 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
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
//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    if ((type==2||type==3)&&self.FormDatas.bool_needSure) {
        for (HasSubmitDetailModel *model in self.FormDatas.arr_sonItem) {
            if ([model.hasSured isEqualToString:@"0"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请确认超标费用明细", nil) duration:1.0];
                return;
            }
        }
    }
    if (type == 3) {
        if ([self.userdatas.isOnlinePay isEqualToString:@"1"]) {
            PayMentDetailController *batch=[[PayMentDetailController alloc]init];
            MyApplyModel *model=[[MyApplyModel alloc]init];
            model.taskId=self.FormDatas.str_taskId;
            model.procId=self.FormDatas.str_procId;
            batch.batchPayArray=[NSMutableArray arrayWithObject:model];
            [self.navigationController pushViewController:batch animated:YES];
        }else{
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSLog(@"确认支付");
            self.dockView.userInteractionEnabled=NO;
            [self.FormDatas contectHasPayDataWithTableName:[self.FormDatas getTableName]];
            [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSinglePayUrl] Parameters:[self.FormDatas SinglePayFormWithComment:@"" WithAdvanceNumber:self.FormDatas.str_AdvanceId WithExpIds:@"" WithMainForm:nil WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
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
        }else if (type==2){
            vc.Type = @"2";
            [self.FormDatas contectHasDataWithTableName:[self.FormDatas getTableName]];
            vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
            vc.AdvanceNumber=self.FormDatas.str_AdvanceId;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//MARK:撤回操作
-(void)reCallBack{
    NSLog(@"撤回操作");
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
}

//MARK:催办操作
-(void)goUrge{
    NSLog(@"催办操作");
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas urgeUrl] Parameters:[self.FormDatas urgeParameters] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:-tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _View_CustomTable) {
        return self.FormDatas.arr_sonItem.count;
    }else if (tableView ==_View_SecDetailsTable){
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }else if (tableView==_View_PayeeTable){
        return self.FormDatas.arr_ThirDetailsDataArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _View_CustomTable) {
        HasSubmitDetailModel *model=self.FormDatas.arr_sonItem[indexPath.row];
        return [travelHasSubmitCell cellHeightWithObj:model];
    }else if (tableView ==_View_SecDetailsTable){
        pmtMethodDetail *model=self.FormDatas.arr_SecDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell PmtMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
    }else if (tableView==_View_PayeeTable){
        PayeeDetails *model=self.FormDatas.arr_ThirDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell PayeeDetailCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _View_CustomTable) {
        return 30;
    }else if (tableView ==_View_SecDetailsTable||tableView ==_View_PayeeTable){
        return 10;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _View_CustomTable) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 30)];
        UILabel *title=[GPUtils createLable:CGRectMake(12,0,180,30) text:Custing(@"报销明细", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        if (self.FormDatas.arr_sonItem.count>1) {
            title.text=[NSString stringWithFormat:@"%@  (%lu)",Custing(@"报销明细", nil),(unsigned long)self.FormDatas.arr_sonItem.count];
        }
        [view addSubview:title];
        if (![self.FormDatas.arr_sonItem isKindOfClass:[NSNull class]]&&self.FormDatas.arr_sonItem.count>4) {
            CGSize size = [(self.FormDatas.bool_isOpenDetail ?Custing(@"收起", nil):Custing(@"展开", nil)) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat titleWidth=size.width;
            CGFloat imageWidth = 14;
            CGFloat btnWidth = titleWidth +imageWidth+24;
            UIButton *btn=[GPUtils createButton:CGRectMake(Main_Screen_Width-btnWidth, 0, btnWidth, 30) action:@selector(LookCustomMore:) delegate:self title:self.FormDatas.bool_isOpenDetail?Custing(@"收起", nil):Custing(@"展开", nil) font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
            [btn setImage:[UIImage imageNamed:self.FormDatas.bool_isOpenDetail?@"work_Close":@"work_Open"] forState:UIControlStateNormal];
            [view addSubview:btn];
        }
        return view;
    }else if (tableView ==_View_SecDetailsTable||tableView ==_View_PayeeTable){
        if (section==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
            view.backgroundColor=Color_White_Same_20;
            return view;
        }
    }
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _View_CustomTable) {
        travelHasSubmitCell *cell=[tableView dequeueReusableCellWithIdentifier:@"travelHasSubmitCell"];
        if (cell==nil) {
            cell=[[travelHasSubmitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"travelHasSubmitCell"];
        }
        [cell configViewWithArray:self.FormDatas.arr_sonItem withIndex:indexPath.row withNeedSure:self.FormDatas.bool_needSure withComePlace:@"travel"];
        if (cell.btn_Sure) {
            [cell.btn_Sure addTarget:self action:@selector(SureClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_Sure.tag=200+indexPath.row;
        }
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
    return  [UITableViewCell new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _View_CustomTable) {
        HasSubmitDetailModel *model=(HasSubmitDetailModel*)self.FormDatas.arr_sonItem[indexPath.row];
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


//MARK:查看更多明细
-(void)LookCustomMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [self updateCustomTableView];
}

-(void)Budget:(UIButton *)btn{
    BudgetInfoController *vc=[[BudgetInfoController alloc]init];
    vc.budgetInfoDict=self.FormDatas.dict_budgetInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SureClick:(UIButton *)btn{
    HasSubmitDetailModel *model=(HasSubmitDetailModel*)self.FormDatas.arr_sonItem[btn.tag-200];
    if ([model.hasSured isEqualToString:@"1"]) {
        model.hasSured=@"0";
    }else if ([model.hasSured isEqualToString:@"0"]){
        model.hasSured=@"1";
    }
    [_View_CustomTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:btn.tag-200 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)changeReceiptOfInv{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_ReceiptOfInv=Model.Id;
        weakSelf.Lab_ReceiptOfInv.text=Model.Type;
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
    [self updateSecDetailsTableView];
}
-(void)ThirLookMore:(UIButton *)btn{
    self.FormDatas.bool_ThirisOpenDetail=!self.FormDatas.bool_ThirisOpenDetail;
    [btn setImage: self.FormDatas.bool_ThirisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_ThirisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updatePayeeTable];
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
