//
//  OtherReimViewController.m
//  galaxy
//
//  Created by hfk on 2016/11/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "OtherReimViewController.h"
#import "PayeesChooseViewController.h"
#import "ReimImportCustomViewController.h"

@interface OtherReimViewController ()

@end

@implementation OtherReimViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[OtherReimFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId = self.pushTaskId;
        self.FormDatas.str_procId = self.pushProcId;
        self.FormDatas.str_userId = self.pushUserId;
        self.FormDatas.int_comeStatus = [self.pushComeStatus integerValue];
        self.FormDatas.str_expenseCode = self.pushExpenseCode;
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCost:) name:@"ADDCOST" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCost:) name:@"EDITCOST" object:nil];

    if (self.pushFlowGuid) {
        if ([self.pushFlowGuid containsString:@"|"]) {
            NSDictionary *dict = self.userdatas.dict_XBAllFlowInfo[self.pushFlowGuid];
            self.FormDatas.str_expenseCode = [NSString stringWithFormat:@"%@",dict[@"expenseCode"]];
            self.FormDatas.str_expenseIcon = [NSString stringWithFormat:@"%@",dict[@"expenseIcon"]];;
            self.FormDatas.str_expenseType = [NSString stringWithFormat:@"%@",dict[@"expenseType"]];
            self.FormDatas.str_parentCode = [NSString stringWithFormat:@"%@",dict[@"expenseCatCode"]];
            NSArray *arr = [self.pushFlowGuid componentsSeparatedByString:@"|"];
            self.FormDatas.str_flowGuid = arr[0];
        }else{
            self.FormDatas.str_flowGuid = self.pushFlowGuid;
        }
    }
    [self setTitle:nil backButton:YES];

    if ([NSString isEqualToNull:self.FormDatas.str_expenseType]) {
        self.FormDatas.str_OtherReimNavTitle = [NSString stringWithFormat:@"%@",self.FormDatas.str_expenseType];
    }
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
    _View_Amount=[[UIView alloc]init];
    _View_Amount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized=[[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Amount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Detail=[[UIView alloc]init];
    _View_Detail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Detail];
    [_View_Detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
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
    _View_PayeeTable.backgroundColor=Color_WhiteWeak_Same_20;
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
    
    _View_EntertainApp=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0023"];
    _View_EntertainApp.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EntertainApp];
    [_View_EntertainApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VehicleSvcApp=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0024"];
    _View_VehicleSvcApp.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VehicleSvcApp];
    [_View_VehicleSvcApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EntertainApp.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FeeAppForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0012"];
    _View_FeeAppForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppForm];
    [_View_FeeAppForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleSvcApp.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Estimated = [[UIView alloc]init];
    _View_Estimated.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Estimated];
    [_View_Estimated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FeeAppForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_OverBud = [[UIView alloc]init];
    _View_OverBud.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OverBud];
    [_View_OverBud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Estimated.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StaffOutForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0016"];
    _View_StaffOutForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StaffOutForm];
    [_View_StaffOutForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OverBud.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StaffOutForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SpecialReqest=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0027"];
    _View_SpecialReqest.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SpecialReqest];
    [_View_SpecialReqest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EmployeeTrain=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0028"];
    _View_EmployeeTrain.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EmployeeTrain];
    [_View_EmployeeTrain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SpecialReqest.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_BorrowingForm=[[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0006"];
    _View_BorrowingForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BorrowingForm];
    [_View_BorrowingForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EmployeeTrain.bottom);
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
    
    _View_NoInvoice=[[UIView alloc]init];
    _View_NoInvoice.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_NoInvoice];
    [_View_NoInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Actual.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DocumentNum=[[UIView alloc]init];
    _View_DocumentNum.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_DocumentNum];
    [_View_DocumentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_NoInvoice.bottom);
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
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
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
    
}

//MARK:-网络请求
//打开表单和保存后打开表单接口
-(void)getFormData
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:5 IfUserCache:NO];
}
//获取是否有审批权限
-(void)requestGetApprovalAuthority
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":self.FormDatas.str_expenseCode,@"JobTitleCode":[NSString isEqualToNull:self.FormDatas.personalData.JobTitleCode]?self.FormDatas.personalData.JobTitleCode:@"",@"Amount":self.txf_Actual.text?[self.txf_Actual.text stringByReplacingOccurrencesOfString:@"," withString:@""]:(id)[NSNull null]};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",GETApprovalAuth];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache:NO];
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
            [self.FormDatas DealWithFormBaseData];
            if (self.FormDatas.str_OtherReimNavTitle) {
                self.navigationItem.title = self.FormDatas.str_OtherReimNavTitle;
            }
            if (self.FormDatas.int_comeStatus==3){
                [self requestApproveNote];
            }else{
                [self updateMainView];
                [self createDealBtns];
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
            self.FormDatas.str_IsApprovalAuthority=[NSString isEqualToNull:[self.FormDatas.dict_resultDict objectForKey:@"result"]]?[NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"result"]]:@"0";
            [self mainDataList];
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
        case 7:
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
        case  10:{
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        case 14:
            if ([self.FormDatas getVerifyBudegt]==0) {
                [self dealWithImagesArray];
            }else{
                [self showBudgetTab];
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
    if (self.FormDatas.int_comeStatus==1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled=YES;
    [self goSubmitSuccessToWithModel:self.FormDatas];
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
        if ([model.fieldName isEqualToString:@"TotalAmount"]) {
            self.FormDatas.str_lastAmount =self.FormDatas.str_amountTotal;
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCapitalizedAmountViewWithModel:model];
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
        }else if ([model.fieldName isEqualToString:@"EntertainAppNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEntertainAppViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"VehicleSvcAppNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateVehicleSvcAppViewWithModel:model];
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
                [self updateOverBudViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"StaffOutNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStaffOutNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePurchaseNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SpecialRequirementsNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSpecialRequirementsNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"EmployeeTrainingNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEmployeeTrainingNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"AdvanceNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBorrowFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LoanAmount"]){
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
        }else if ([model.fieldName isEqualToString:@"NoInvAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateNoInvAmountViewWithModel:model];
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
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Amount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Amount WithContent:_txf_Amount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_amountTotal}];
    [view setOtherHeight:40];
    [_View_Amount addSubview:view];
}
//MARK:更新金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNone Withmodel:model WithInfodict:@{@"value1":[NSString getChineseMoneyByString:self.FormDatas.str_amountTotal]}];
    [view setOtherHeight:40];
    [_View_Capitalized addSubview:view];
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
    _Imv_DetailClick.center=CGPointMake(Main_Screen_Width-25, 20);
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
    [_ReimShareMainView updateReimShareMainViewWith:self.FormDatas.arr_ShareForm WithData:self.FormDatas.arr_ShareData WithEditType:1 WithComePlace:3];
    
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
//MARK:更新业务招待视图
-(void)updateEntertainAppViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_EntertainNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_EntertainInfo=@"";
        self.FormDatas.str_EntertainNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainInfo],
                           @"Model":model
                           };
    [_View_EntertainApp updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_EntertainApp.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf EntertainClick];
    };
}
//MARK:更新车辆维修视图
-(void)updateVehicleSvcAppViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_VehicleSvcNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_VehicleSvcInfo=@"";
        self.FormDatas.str_VehicleSvcNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcInfo],
                           @"Model":model
                           };
    [_View_VehicleSvcApp updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_VehicleSvcApp.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf VehicleSvcClick];
    };
}

//MARK:更新费用申请单视图
-(void)updateFeeAppFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_FeeAppNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_FeeAppInfo=@"";
        self.FormDatas.str_FeeAppNumber=@"";
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
    _txf_Estimated=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Estimated WithContent:_txf_Estimated WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Estimated addSubview:view];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_EstimatedAmount=[[NSString stringWithFormat:@"%@",model.fieldValue] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
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
//MARK:更新采购申请单视图
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_PurchaseNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_PurchaseInfo=@"";
        self.FormDatas.str_PurchaseNumber=@"";
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
//MARK:更新特殊事项申请单视图
-(void)updateSpecialRequirementsNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_SpecialReqestNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_SpecialReqestInfo=@"";
        self.FormDatas.str_SpecialReqestNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestInfo],
                           @"Model":model
                           };
    [_View_SpecialReqest updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_SpecialReqest.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf SpecialReqestFormClick];
    };
}
//MARK:更新员工外出培训申请单视图
-(void)updateEmployeeTrainingNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_EmployeeTrainNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_EmployeeTrainInfo=@"";
        self.FormDatas.str_EmployeeTrainNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainInfo],
                           @"Model":model
                           };
    [_View_EmployeeTrain updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_EmployeeTrain.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf EmployeeTrainFormClick];
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
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountTotal with:self.FormDatas.str_LoanTotalAmount]floatValue]<0) {
        _txf_Actual.text=[GPUtils transformNsNumber:@"0"];
    }else{
        _txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountTotal with:self.FormDatas.str_LoanTotalAmount]];
    }
}
//MARK:更新无发票金额视图
-(void)updateNoInvAmountViewWithModel:(MyProcurementModel *)model{
    _txf_NoInvoice=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_NoInvoice WithContent:_txf_NoInvoice WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_NoInvAmount}];
    [_View_NoInvoice addSubview:view];
}
//MARK:更新单据数量视图
-(void)updateDocumentNumViewWithModel:(MyProcurementModel *)model{
    _txf_DocumentNum=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_DocumentNum WithContent:_txf_DocumentNum WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_DocumentNum addSubview:view];
}
//MARK:更新收款人视图
-(void)updatePayeeViewWithModel:(MyProcurementModel *)model{
    _txf_Payee=[[UITextField alloc]init];
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

//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_CcToPeople.bottom).offset(10);
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
    add.Type = 3;
    add.str_expenseCode = self.FormDatas.str_expenseCode;
    add.str_expenseIcon = self.FormDatas.str_expenseIcon;
    add.expenseType = self.FormDatas.str_expenseType;
    add.str_show_title = [NSString stringWithFormat:@"%@%@",self.FormDatas.str_expenseType,Custing(@"报销", nil)];
    add.Enabled_addAgain = 1;
    add.Enabled_Expense = 1;
    [self.navigationController pushViewController:add animated:YES];
}
//MARK:导入消费记录
-(void)importCustomClick:(UIButton *)btn{
    ReimImportCustomViewController *vc = [[ReimImportCustomViewController alloc]init];
    vc.dict_parameter = @{@"FlowCode":self.FormDatas.str_flowCode,
                          @"UserId":self.FormDatas.personalData.OperatorUserId,
                          @"OwnerUserId":self.FormDatas.personalData.OperatorUserId,
                          @"ExpenseCode":self.FormDatas.str_expenseCode,
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
    
    //费用申请单
    self.FormDatas.str_FeeAppInfo = @"";
    self.FormDatas.str_FeeAppNumber = @"";
    NSDictionary *feeDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                              @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo]
                              };
    [self.View_FeeAppForm updateView:feeDict];
    //业务招待费申请单
    self.FormDatas.str_EntertainInfo = @"";
    self.FormDatas.str_EntertainNumber = @"";
    NSDictionary *entertainDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainNumber],
                                    @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainInfo]
                                    };
    [self.View_EntertainApp updateView:entertainDict];
    //车辆维修申请单
    self.FormDatas.str_VehicleSvcInfo = @"";
    self.FormDatas.str_VehicleSvcNumber = @"";
    NSDictionary *vehicleSvcDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcNumber],
                                     @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcInfo]
                                     };
    [self.View_VehicleSvcApp updateView:vehicleSvcDict];
    //外出申请单
    self.FormDatas.str_StaffOutInfo = @"";
    self.FormDatas.str_StaffOutNumber = @"";
    NSDictionary *staffDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutNumber],
                                @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_StaffOutInfo]
                                };
    [self.View_StaffOutForm updateView:staffDict];
//    //用车申请单
//    self.FormDatas.str_VehicleInfo = @"";
//    self.FormDatas.str_VehicleNumber = @"";
//    NSDictionary *vehicleDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleNumber],
//                                  @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleInfo]
//                                  };
//    [self.View_VehicleForm updateView:vehicleDict];
    //采购申请单
    self.FormDatas.str_PurchaseInfo = @"";
    self.FormDatas.str_PurchaseNumber = @"";
    NSDictionary *purchaseDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                                   @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo]
                                   };
    [self.View_PurchaseForm updateView:purchaseDict];
    //超标特殊事项
    self.FormDatas.str_SpecialReqestInfo = @"";
    self.FormDatas.str_SpecialReqestNumber = @"";
    NSDictionary *specialReqestDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestNumber],
                                        @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestInfo]
                                        };
    [self.View_SpecialReqest updateView:specialReqestDict];
    //员工外出培训申请单
    self.FormDatas.str_EmployeeTrainInfo = @"";
    self.FormDatas.str_EmployeeTrainNumber = @"";
    NSDictionary *employeeDict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainNumber],
                                   @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainInfo]
                                   };
    [self.View_EmployeeTrain updateView:employeeDict];
    //借款单
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
    self.FormDatas.str_EstimatedAmount = @"0";
    self.txf_Estimated.text=[GPUtils transformNsNumber:self.FormDatas.str_EstimatedAmount];
    self.FormDatas.str_LoanTotalAmount = @"0";
    self.txf_Loan.text=[GPUtils transformNsNumber:self.FormDatas.str_LoanTotalAmount];
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
        weakSelf.txf_ClaimType.text=weakSelf.FormDatas.str_ClaimType;
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
//MARK:修改业务招待单
-(void)EntertainClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"EntertainApp"];
    vc.ChooseCategoryId=self.FormDatas.str_EntertainNumber;
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
        weakSelf.FormDatas.str_EntertainInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_EntertainNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        weakSelf.txf_Estimated.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EntertainInfo]                               };
        [weakSelf.View_EntertainApp updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改车辆维修
-(void)VehicleSvcClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"VehicleSvcApp"];
    vc.ChooseCategoryId=self.FormDatas.str_VehicleSvcNumber;
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
        weakSelf.FormDatas.str_VehicleSvcInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_VehicleSvcNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        weakSelf.txf_Estimated.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_VehicleSvcInfo]                               };
        [weakSelf.View_VehicleSvcApp updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:修改费用申请单
-(void)FeeFormClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId=self.FormDatas.str_FeeAppNumber;
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
        weakSelf.txf_Estimated.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_EstimatedAmount];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo]                               };
        [weakSelf.View_FeeAppForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
//MARK:修改采购申请单
-(void)PurchaseFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"PurchaseNumber"];
    vc.ChooseCategoryId=self.FormDatas.str_PurchaseNumber;
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
        weakSelf.FormDatas.str_PurchaseInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_PurchaseNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo]                               };
        [weakSelf.View_PurchaseForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改特殊事项申请单
-(void)SpecialReqestFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"SpecialReqest"];
    vc.ChooseCategoryId=self.FormDatas.str_SpecialReqestNumber;
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
        weakSelf.FormDatas.str_SpecialReqestInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_SpecialReqestNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_SpecialReqestInfo]                               };
        [weakSelf.View_SpecialReqest updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改员工外出申请单
-(void)EmployeeTrainFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"EmployeeTrain"];
    vc.ChooseCategoryId=self.FormDatas.str_EmployeeTrainNumber;
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
        weakSelf.FormDatas.str_EmployeeTrainInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_EmployeeTrainNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_EmployeeTrainInfo]                               };
        [weakSelf.View_EmployeeTrain updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改借款单
-(void)BorrowingFormClick{
    [self keyClose];
    BorrowingFormChooseController *choose=[[BorrowingFormChooseController alloc]init];
    choose.ChooseCategoryId=self.FormDatas.str_AdvanceId;
    choose.dict_otherPars = @{@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    choose.ChooseBorrowFormBlock = ^(NSMutableArray *array, NSString *reversalType) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_LoanTotalAmount = @"0";
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
            weakSelf.FormDatas.str_LoanTotalAmount = [GPUtils decimalNumberAddWithString:model.advanceAmount with:weakSelf.FormDatas.str_LoanTotalAmount];
        }
        weakSelf.FormDatas.str_AdvanceInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_AdvanceId = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        weakSelf.txf_Loan.text=[GPUtils transformNsNumber:weakSelf.FormDatas.str_LoanTotalAmount];
        if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountTotal with:self.FormDatas.str_LoanTotalAmount]floatValue]<0) {
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:@"0"];
        }else{
            weakSelf.txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:weakSelf.FormDatas.str_amountTotal with:weakSelf.FormDatas.str_LoanTotalAmount]];
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
    contactVC.itemType = 99;
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
    NSDictionary *dic = [dict objectForKey:@"info"];
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
    }else if (tableView==_View_PayeeTable){
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
    if (tableView == _View_DetailsTable) {
        AddDetailsModel *model = (AddDetailsModel *)self.FormDatas.arr_sonItem[indexPath.row];
        return [ExpenseSonListCell cellHeightWithModel:model];
    }else  if (tableView == _View_table){
        return 40;
    }else if (tableView == _View_PayeeTable){
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
            add.Type = 3;
            add.check = model.checked;
            add.Enabled_Expense = 1;
            add.Enabled_addAgain = 1;
            add.str_show_title = [NSString stringWithFormat:@"%@%@",weakSelf.FormDatas.str_expenseType,Custing(@"报销", nil)];
            add.str_expenseCode = weakSelf.FormDatas.str_expenseCode;
            add.str_expenseIcon = weakSelf.FormDatas.str_expenseIcon;
            add.expenseType = weakSelf.FormDatas.str_expenseType;
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
    _View_DetailsHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 46)];
    _View_DetailsHead.backgroundColor=Color_Orange_Weak_20;
    
    _Imv_AllSecect = [GPUtils createImageViewFrame:CGRectMake(0,0,18,18) imageName:@"MyApprove_Select"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checked MATCHES %@", @"0"];
    NSArray* tempArr = [self.FormDatas.arr_sonItem filteredArrayUsingPredicate:predicate];
    if (self.FormDatas.arr_sonItem.count == 0 || tempArr.count > 0) {
        _Imv_AllSecect.image = [UIImage imageNamed:@"MyApprove_UnSelect"];
    }
    _Imv_AllSecect.center=CGPointMake(23, 23);
    [_View_DetailsHead addSubview:_Imv_AllSecect];
    UILabel *selectAll=[GPUtils createLable:CGRectMake(45, 0, 70, 46) text:Custing(@"全选", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
    [_View_DetailsHead addSubview:selectAll];
    UIButton *selectAllBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 116, 46)];
    [selectAllBtn addTarget:self action:@selector(SelectAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [_View_DetailsHead addSubview:selectAllBtn];
    
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
//    line.hidden = YES;
//    line1.hidden = YES;
//    AddBtn.hidden = YES;
//    LoadBtn.hidden = YES;
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
    _txf_Amount.text=[GPUtils transformNsNumber:self.FormDatas.str_amountTotal];
    _txf_Capitalized.text=[NSString getChineseMoneyByString:_txf_Amount.text];
    _txf_NoInvoice.text=[GPUtils transformNsNumber:self.FormDatas.str_NoInvAmount];
    if ([[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountTotal with:self.FormDatas.str_LoanTotalAmount]floatValue]<0) {
        _txf_Actual.text=[GPUtils transformNsNumber:@"0"];
    }else{
        _txf_Actual.text=[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:self.FormDatas.str_amountTotal with:self.FormDatas.str_LoanTotalAmount]];
    }
}
//MARK:通知释放
- (void)dealloc
{
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
    if (!self.FormDatas.str_IsApprovalAuthority) {
        [self requestGetApprovalAuthority];
    }else{
        [self mainDataList];
    }
}
//MARK:直送操作
-(void)directInfo
{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    if (!self.FormDatas.str_IsApprovalAuthority) {
        [self requestGetApprovalAuthority];
    }else{
        [self mainDataList];
    }
}
//MARK:-提交保存数据处理
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    [self.FormDatas getSubmitSaveIdString];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str=[self.FormDatas testModel];
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
    if (self.FormDatas.bool_IsHasShowProject && (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3) && [NSString isEqualToNullAndZero:self.FormDatas.personalData.CostCenterId]) {
        
        [[GPClient shareGPClient]REquestByPostWithPath:XB_ProjsByCostcenter Parameters:[self.FormDatas getProjsByCostcenterParam] Delegate:self SerialNum:7 IfUserCache:NO];
    }else{
        [self getExpShareApprovalId];
    }}

-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason=self.txv_Reason.text;
    self.FormDatas.SubmitData.NumberOfDocuments =_txf_DocumentNum.text;
    self.FormDatas.SubmitData.TotalAmount = [NSString notRounding:self.FormDatas.str_amountTotal afterPoint:2];
    self.FormDatas.SubmitData.CapitalizedAmount = [NSString getChineseMoneyByString:self.FormDatas.SubmitData.TotalAmount];
    self.FormDatas.SubmitData.ActualAmount = [NSString isEqualToNull:_txf_Actual.text]?[_txf_Actual.text stringByReplacingOccurrencesOfString:@"," withString:@""]:[self.FormDatas dealWithAcutual];
    self.FormDatas.SubmitData.NoInvAmount=[NSString isEqualToNull:_txf_NoInvoice.text]?[_txf_NoInvoice.text stringByReplacingOccurrencesOfString:@"," withString:@""]:@"";
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
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:dailyImgLoad WithBlock:^(id data, BOOL hasError) {
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

//MARK:保存
-(void)requestAppSave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:self.FormDatas.str_submitId WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:第一次提交验证
-(void)checkTravelReimSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getCheckSubmitUrl] Parameters:[self.FormDatas GetCheckSubmitWithAmount:_txf_Amount.text WithExpIds:self.FormDatas.str_submitId otherParameters:[self.FormDatas getCheckSubmitOtherPar]] Delegate:self SerialNum:14 IfUserCache:NO];
}
//MARK:验证完成提交
-(void)requestAppSubmit{
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
