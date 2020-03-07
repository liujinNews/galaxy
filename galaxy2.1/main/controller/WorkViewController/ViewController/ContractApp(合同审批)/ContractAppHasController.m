//
//  ContractAppHasController.m
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ContractAppHasController.h"

@interface ContractAppHasController ()

@end

@implementation ContractAppHasController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[ContractAppFormData alloc]initWithStatus:2];
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
        self.FormDatas.int_comeEditType = [self.pushComeEditType integerValue];
        self.FormDatas.int_comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
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
//初始化是否使用标准模版数组
- (NSMutableArray *)array_IsStdConTemplate{
    if (_array_IsStdConTemplate == nil) {
        _array_IsStdConTemplate = [NSMutableArray array];
        for (int i = 0 ; i < 2 ; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            if (i == 0) {
                model.Id = @"1";
                model.Type = @"是";
            }else{
                model.Id = @"0";
                model.Type = @"否";
            }
            [_array_IsStdConTemplate addObject:model];
        }
    }
    return _array_IsStdConTemplate;
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
            make.width.equalTo(self.view);
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

    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom).offset(@10);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line1=[[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContNo = [[UIView alloc]init];
    _View_ContNo.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContNo];
    [_View_ContNo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContName = [[UIView alloc]init];
    _View_ContName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContName];
    [_View_ContName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //描述
    _View_Description = [[UIView alloc]init];
    _View_Description.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Description];
    [_View_Description makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate = [[UIView alloc]init];
    _View_Cate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Description.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RelCont = [[UIView alloc]init];
    _View_RelCont.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelCont];
    [_View_RelCont makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RelCont.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContType = [[UIView alloc]init];
    _View_ContType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContType];
    [_View_ContType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //是否使用标准模版视图
    _view_StdConTemplate = [[UIView alloc]init];
    _view_StdConTemplate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_view_StdConTemplate];
    [_view_StdConTemplate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount = [[UIView alloc]init];
    _View_Amount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_StdConTemplate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized = [[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Amount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
//    会签人员
    _View_ApprovalPersonnel=[[UIView alloc]init];
    _View_ApprovalPersonnel.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_View_ApprovalPersonnel];
    [_View_ApprovalPersonnel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractDate = [[UIView alloc]init];
    _View_ContractDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractDate];
    [_View_ContractDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ApprovalPersonnel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EffectiveDate = [[UIView alloc]init];
    _View_EffectiveDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EffectiveDate];
    [_View_EffectiveDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpiryDate = [[UIView alloc]init];
    _View_ExpiryDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExpiryDate];
    [_View_ExpiryDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EffectiveDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayCode = [[UIView alloc]init];
    _View_PayCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayCode];
    [_View_PayCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpiryDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_MoneyOrderRate = [[UIView alloc]init];
    _View_MoneyOrderRate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_MoneyOrderRate];
    [_View_MoneyOrderRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ContractCopies = [[UIView alloc]init];
    _View_ContractCopies.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractCopies];
    [_View_ContractCopies makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MoneyOrderRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReleContract = [[FormChildTableView alloc]init];
    [self.contentView addSubview:_View_ReleContract];
    [_View_ReleContract makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractCopies.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _view_line2 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReleContract.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_PartyA = [[UIView alloc]init];
    _View_PartyA.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyA];
    [_View_PartyA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyAStaff = [[UIView alloc]init];
    _View_PartyAStaff.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyAStaff];
    [_View_PartyAStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyA.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyATel = [[UIView alloc]init];
    _View_PartyATel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyATel];
    [_View_PartyATel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyAStaff.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyB = [[UIView alloc]init];
    _View_PartyB.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyB];
    [_View_PartyB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyATel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyBAddr = [[UIView alloc]init];
    _View_PartyBAddr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyBAddr];
    [_View_PartyBAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyB.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyBPostCode = [[UIView alloc]init];
    _View_PartyBPostCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyBPostCode];
    [_View_PartyBPostCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyBAddr.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyBStaff = [[UIView alloc]init];
    _View_PartyBStaff.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyBStaff];
    [_View_PartyBStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyBPostCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PartyBTel = [[UIView alloc]init];
    _View_PartyBTel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyBTel];
    [_View_PartyBTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyBStaff.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankName = [[UIView alloc]init];
    _View_BankName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankName];
    [_View_BankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PartyBTel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount = [[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceTitle = [[UIView alloc]init];
    _View_InvoiceTitle.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceTitle];
    [_View_InvoiceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceType];
    [_View_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceTitle.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TaxRate = [[UIView alloc]init];
    _View_TaxRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TaxRate];
    [_View_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvoiceType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ClientName = [[UIView alloc]init];
    _View_ClientName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClientName];
    [_View_ClientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TaxRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ClientAddr = [[UIView alloc]init];
    _View_ClientAddr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ClientAddr];
    [_View_ClientAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClientName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IbanName = [[UIView alloc]init];
    _View_IbanName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IbanName];
    [_View_IbanName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ClientAddr.bottom);
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
    
    _View_BankNo = [[UIView alloc]init];
    _View_BankNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankNo];
    [_View_BankNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SwiftCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankADDRESS = [[UIView alloc]init];
    _View_BankADDRESS.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankADDRESS];
    [_View_BankADDRESS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TermTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_TermTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_TermTable.delegate=self;
    _View_TermTable.dataSource=self;
    _View_TermTable.scrollEnabled=NO;
    _View_TermTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_TermTable];
    [_View_TermTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankADDRESS.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayModeTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_PayModeTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_PayModeTable.delegate=self;
    _View_PayModeTable.dataSource=self;
    _View_PayModeTable.scrollEnabled=NO;
    _View_PayModeTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PayModeTable];
    [_View_PayModeTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TermTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    //费用类别明细
//    _View_ExpTypeTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    _View_ExpTypeTable.backgroundColor=Color_WhiteWeak_Same_20;
//    _View_ExpTypeTable.delegate=self;
//    _View_ExpTypeTable.dataSource=self;
//    _View_ExpTypeTable.scrollEnabled=NO;
//    _View_ExpTypeTable.separatorStyle=UITableViewCellSeparatorStyleNone;
//    [self.contentView addSubview:_View_ExpTypeTable];
//    [_View_ExpTypeTable makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.View_PayModeTable.bottom);
//        make.left.right.equalTo(self.contentView);
//    }];
    
    _View_ConYearExpTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_ConYearExpTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_ConYearExpTable.delegate = self;
    _View_ConYearExpTable.dataSource = self;
    _View_ConYearExpTable.scrollEnabled = NO;
    _View_ConYearExpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_ConYearExpTable];
    [_View_ConYearExpTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayModeTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line3 = [[UIView alloc]init];
    [self.contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ConYearExpTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople = [[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractReleInfo = [[FormChildTableView alloc]init];
    [self.contentView addSubview:_View_ContractReleInfo];
    [_View_ContractReleInfo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractReleInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
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
-(void)requestHasApp{
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
    self.PrintfBtn.userInteractionEnabled=YES;
    self.dockView.userInteractionEnabled=YES;
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
    contactVC.itemType = 13;
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
        vc.str_CommonField=[self.FormDatas getCommonField];
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
//MARK:查看更多明细
-(void)LookMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [btn setImage: self.FormDatas.bool_isOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_isOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updateTermTableView];
}
-(void)SecLookMore:(UIButton *)btn{
    self.FormDatas.bool_SecisOpenDetail=!self.FormDatas.bool_SecisOpenDetail;
    [btn setImage: self.FormDatas.bool_SecisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_SecisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updatePayModeTableView];
}

-(void)ThirLookMore:(UIButton *)btn{
    self.FormDatas.bool_ThirisOpenDetail = !self.FormDatas.bool_ThirisOpenDetail;
    [btn setImage: self.FormDatas.bool_ThirisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_ThirisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updateContractYearExpTableView];
}
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    [_FormRelatedView initOnlyApproveFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithBaseModel:self.FormDatas];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"ContractNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Description"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateDecriptionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateExpenseTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelateContNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateRelateContractViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1=1;
            [self updatePurchaseNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractTypId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsStandardContractTemplate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1=1;
            [self update_StdConTemplateView:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateTotalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateCurrencyCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateExchangeRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateLocalCyAmountViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"OtherApprover"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line1=1;
            [self updateApprovalViewWithModel_tr:model];
        }else if ([model.fieldName isEqualToString:@"ContractDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EffectiveDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateEffectiveDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpiryDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateExpiryDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PayCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updatePayCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"MoneyOrderRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateMoneyOrderRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractCopies"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractCopiesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyA"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyAViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyAStaff"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyAStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyATel"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyATelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyB"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyBViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBAddress"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyBAddressViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBPostCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyBPostCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBStaff"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyBStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBTel"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updatePartyBTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceTitle"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateInvoiceTitleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateInvoiceTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            _int_line2 = 1;
            [self updateTaxRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientName"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateClientNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateClientAddrViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanName"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateIbanNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateIbanAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateIbanAddrViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SwiftCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateSwiftCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateBankNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankADDRESS"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.bool_isForeign){
            _int_line2 = 1;
            [self updateBankADDRESSViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line3=1;
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    
    if (self.FormDatas.bool_DetailsShow&&self.FormDatas.arr_DetailsDataArray.count!=0) {
        [self updateTermTableView];
        [_View_TermTable reloadData];
    }
    if (self.FormDatas.bool_SecDetailsShow&&self.FormDatas.arr_SecDetailsDataArray.count!=0) {
        [self updatePayModeTableView];
        [_View_PayModeTable reloadData];
    }
    
    //更新费用类别明细
//    if (self.FormDatas.bool_FouDetailsShow&&self.FormDatas.arr_FouDetailsDataArray.count!=0) {
//           [self updateExpTypeTableView];
//           [_View_ExpTypeTable reloadData];
//       }
    
    //更新合同审批新增年度费用明细
    if (self.FormDatas.bool_ThirDetailsShow && self.FormDatas.arr_ThirDetailsDataArray.count != 0) {
        [self updateContractYearExpTableView];
        [_View_ConYearExpTable reloadData];
    }
    
    if (self.FormDatas.arr_RelateCont.count>0) {
        [self.View_ReleContract updateReletContractViewWithArray:self.FormDatas.arr_RelateCont];
        __weak typeof(self) weakSelf = self;
        [self.View_ReleContract setCellClick:^(NSString *taskId) {
            [weakSelf LookViewLinkToFormWithTaskId:taskId WithFlowCode:@"F0013"];
        }];
    }
    if (self.FormDatas.arr_ContractReleInfo.count>0) {
        [self.View_ContractReleInfo updateContractReletInfoViewWithArray:self.FormDatas.arr_ContractReleInfo];
        __weak typeof(self) weakSelf = self;
        [self.View_ContractReleInfo setCellClick:^(NSString *taskId) {
            [weakSelf LookViewLinkToFormWithTaskId:taskId WithFlowCode:@"F0019"];
        }];
    }
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    [self updateBottomView];
    
}

//MARK:更新合同编号视图
-(void)updateContractNoViewWithModel:(MyProcurementModel *)model{
    [_View_ContNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同名称视图
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    [_View_ContName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新描述视图
- (void)updateDecriptionViewWithModel:(MyProcurementModel *)model{
    [_View_Description addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Description updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新关联合同
-(void)updateRelateContractViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_RelateContName] ? [NSString stringWithFormat:@"%@",self.FormDatas.str_RelateContName]:@"";
    UILabel *label=[[UILabel alloc]init];
    __weak typeof(self) weakSelf = self;
    [_View_RelCont addSubview:[XBHepler creation_Lable:label model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_RelCont updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    label.textColor=Color_Blue_Important_20;
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:^{
        [weakSelf LookViewLinkToFormWithTaskId:weakSelf.FormDatas.str_RelateContId WithFlowCode:@"F0013"];
    }];
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
//MARK:更新合同类型视图
-(void)updateContractTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_ContType] ? [NSString stringWithFormat:@"%@",self.FormDatas.str_ContType]:@"";
    [_View_ContType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新是否使用标准模版
-(void)update_StdConTemplateView:(MyProcurementModel *)model{
    self.str_StdConTemplate = [NSString isEqualToNull:model.fieldValue]?[NSString stringWithFormat:@"%@",model.fieldValue]:@"1";
    for (STOnePickModel *model1 in self.array_IsStdConTemplate) {
        if ([self.str_StdConTemplate isEqualToString:model1.Id]) {
            model.fieldValue=model1.Type;
        }
    }
    _lab_StdConTemplate =[UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_StdConTemplate addSubview:[XBHepler creation_Lable:_lab_StdConTemplate model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_StdConTemplate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];

}
//MARK:更新合同金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    [_View_Amount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Amount updateConstraints:^(MASConstraintMaker *make) {
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
//MARK:更新币种视图
-(void)updateCurrencyCodeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_Currency]?[NSString stringWithFormat:@"%@",self.FormDatas.str_Currency]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_CurrencyCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CurrencyCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新汇率视图
-(void)updateExchangeRateViewWithModel:(MyProcurementModel *)model{
    [_View_ExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:2 block:^(NSInteger height) {
        [self.View_ExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新本位币金额视图
-(void)updateLocalCyAmountViewWithModel:(MyProcurementModel *)model{
    [_View_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新会签人员试图
-(void)updateApprovalViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ApprovalPersonnel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ApprovalPersonnel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新签订日期视图
-(void)updateContractDateViewWithModel:(MyProcurementModel *)model{
    [_View_ContractDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContractDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同有效期视图
-(void)updateEffectiveDateViewWithModel:(MyProcurementModel *)model{
    [_View_EffectiveDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_EffectiveDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同截止日期视图
-(void)updateExpiryDateViewWithModel:(MyProcurementModel *)model{
    [_View_ExpiryDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ExpiryDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新付款方式视图
-(void)updatePayCodeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_PayMode]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PayMode]:@"";
    [_View_PayCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PayCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同汇票比例视图
-(void)updateMoneyOrderRateViewWithModel:(MyProcurementModel *)model{
    [_View_MoneyOrderRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_MoneyOrderRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新签订份数视图
-(void)updateContractCopiesViewWithModel:(MyProcurementModel *)model{
    [_View_ContractCopies addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ContractCopies updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新我方单位名称视图
-(void)updatePartyAViewWithModel:(MyProcurementModel *)model{
    [_View_PartyA addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyA updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新负责人视图
-(void)updatePartyAStaffViewWithModel:(MyProcurementModel *)model{
    [_View_PartyAStaff addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyAStaff updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新电话视图
-(void)updatePartyATelViewWithModel:(MyProcurementModel *)model{
    [_View_PartyATel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyATel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新对方单位名称视图
-(void)updatePartyBViewWithModel:(MyProcurementModel *)model{
    [_View_PartyB addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyB updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新地址视图
-(void)updatePartyBAddressViewWithModel:(MyProcurementModel *)model{
    [_View_PartyBAddr addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyBAddr updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新邮编视图
-(void)updatePartyBPostCodeViewWithModel:(MyProcurementModel *)model{
    [_View_PartyBPostCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyBPostCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新联系人视图
-(void)updatePartyBStaffViewWithModel:(MyProcurementModel *)model{
    [_View_PartyBStaff addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyBStaff updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新电话视图
-(void)updatePartyBTelViewWithModel:(MyProcurementModel *)model{
    [_View_PartyBTel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_PartyBTel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新开户银行视图
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    [_View_BankName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新银行账号视图
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    [_View_BankAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新发票抬头视图
-(void)updateInvoiceTitleViewWithModel:(MyProcurementModel *)model{
    [_View_InvoiceTitle addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InvoiceTitle updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票类型视图
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"2"]) {
        model.fieldValue = Custing(@"增值税普通发票", nil);
    }else if ([[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"1"]){
        model.fieldValue = Custing(@"增值税专用发票", nil);
    }else{
        model.fieldValue = @"";
    }
    [_View_InvoiceType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新税率视图
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    [_View_TaxRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:客户名称更新
-(void)updateClientNameViewWithModel:(MyProcurementModel *)model{
    [_View_ClientName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ClientName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
}
//MARK:客户地址更新
-(void)updateClientAddrViewWithModel:(MyProcurementModel *)model{
    [_View_ClientAddr addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_ClientAddr updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:银行名称更新
-(void)updateIbanNameViewWithModel:(MyProcurementModel *)model{
    [_View_IbanName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:IBAN/银行账号更新
-(void)updateIbanAccountViewWithModel:(MyProcurementModel *)model{
    [_View_IbanAccount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanAccount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:IBAN/银行地址更新
-(void)updateIbanAddrViewWithModel:(MyProcurementModel *)model{
    [_View_IbanAddr addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IbanAddr updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:IBAN/银行SwiftCode更新
-(void)updateSwiftCodeViewWithModel:(MyProcurementModel *)model{
    [_View_SwiftCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_SwiftCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:BankNo更新
-(void)updateBankNoViewWithModel:(MyProcurementModel *)model{
    [_View_BankNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:BankADDRESS更新
-(void)updateBankADDRESSViewWithModel:(MyProcurementModel *)model{
    [_View_BankADDRESS addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BankADDRESS updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新明细
-(void)updateTermTableView{
    if (self.FormDatas.bool_isOpenDetail) {
        NSInteger height=10;
        for (ContractTermDetail *model in self.FormDatas.arr_DetailsDataArray) {
            height=height+[ProcureDetailsCell ContractTermCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        }
        [_View_TermTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        ContractTermDetail *model = self.FormDatas.arr_DetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell ContractTermCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        [_View_TermTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}
-(void)updatePayModeTableView{

    if (self.FormDatas.bool_SecisOpenDetail) {
        NSInteger height=10;
        for (ContractPayMethodDetail *model in self.FormDatas.arr_SecDetailsDataArray) {
            height=height+[ProcureDetailsCell ContractPayMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
        }
        NSInteger expH = 10;
        for (ContractPayMethodDetail *payModel in self.FormDatas.arr_SecDetailsDataArray) {
            if (payModel.contPayMethodExpTypDels.count > 0) {
                for (ExpTypeDetail *expModel in payModel.contPayMethodExpTypDels) {
                    expH = expH +[ProcureDetailsCell ContractExpTypeCellHeightWithArray:self.FormDatas.arr_FouDetailsArray WithModel:expModel];
                }
            }
            expH = expH + 10;
        }
        height = height + expH;
        [_View_PayModeTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        
        ContractPayMethodDetail *model = self.FormDatas.arr_SecDetailsDataArray[0];

        NSInteger expH = 10;
        if (model.contPayMethodExpTypDels.count > 0) {
            for (ExpTypeDetail *expModel in model.contPayMethodExpTypDels) {
                expH = expH +[ProcureDetailsCell ContractExpTypeCellHeightWithArray:self.FormDatas.arr_FouDetailsArray WithModel:expModel];
            }
        }
        NSInteger height=10+[ProcureDetailsCell ContractPayMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
        height = height+expH;
        [_View_PayModeTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
    [_View_PayModeTable reloadData];
}

-(void)updateContractYearExpTableView{
    if (self.FormDatas.bool_ThirisOpenDetail) {
        NSInteger height = 10;
        for (ContractYearExpDetail *model in self.FormDatas.arr_ThirDetailsDataArray) {
            height = height + [ProcureDetailsCell ContractYearExpCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
        }
        [_View_ConYearExpTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        ContractYearExpDetail *model = self.FormDatas.arr_ThirDetailsDataArray[0];
        NSInteger height = 10 + [ProcureDetailsCell ContractYearExpCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
        [_View_ConYearExpTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
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
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}
//MARK:更新审批人
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
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}


#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _View_TermTable) {
        return self.FormDatas.arr_DetailsDataArray.count;
    }else if (tableView == _View_PayModeTable){
        return 1;
    }else if (tableView == _View_ConYearExpTable){
        return self.FormDatas.arr_ThirDetailsDataArray.count;
    }else if (tableView == _View_ExpTypeTable){
        return self.arr_ExpTInSect.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _View_PayModeTable) {
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_TermTable) {
        ContractTermDetail *model=self.FormDatas.arr_DetailsDataArray[indexPath.row];
        return [ProcureDetailsCell ContractTermCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
    }else if (tableView == _View_PayModeTable){
        ContractPayMethodDetail *model=self.FormDatas.arr_SecDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell ContractPayMethodCellHeightWithArray:self.FormDatas.arr_SecDetailsArray WithModel:model];
    }else if (tableView == _View_ConYearExpTable){
        ContractYearExpDetail *model = self.FormDatas.arr_ThirDetailsDataArray[indexPath.row];
        return [ProcureDetailsCell ContractYearExpCellHeightWithArray:self.FormDatas.arr_ThirDetailsArray WithModel:model];
    }else if (tableView == _View_ExpTypeTable){
        ExpTypeDetail *model = self.arr_ExpTInSect[indexPath.row];
        return [ProcureDetailsCell ContractExpTypeCellHeightWithArray:self.FormDatas.arr_FouDetailsArray WithModel:model];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView==_View_TermTable||tableView==_View_PayModeTable||tableView==_View_ConYearExpTable) {
        if (section==0) {
            return 10;
        }else{
            return 0.01;
        }
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==_View_TermTable||tableView==_View_PayModeTable||tableView==_View_ConYearExpTable) {
        if (section==0) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
            view.backgroundColor=Color_White_Same_20;
            return view;
        }else{
            return [UIView new];
        }
    }else{
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _View_PayModeTable) {
        ContractPayMethodDetail *payModel = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:section];
        NSInteger height = 10;
        if (payModel.contPayMethodExpTypDels.count > 0) {
            for (ExpTypeDetail *model in payModel.contPayMethodExpTypDels) {
                height = height+[ProcureDetailsCell ContractExpTypeCellHeightWithArray:self.FormDatas.arr_FouDetailsArray WithModel:model];
            }
        }
        return height;
    }
//    else if (tableView == _View_ExpTypeTable){
//        if (section == _arr_ExpTInSect.count - 1) {
//            return 10;
//        }
//    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _View_PayModeTable) {
        ContractPayMethodDetail *payModel = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:section];
        if (payModel.contPayMethodExpTypDels.count > 0) {
            [self createPayModeTableFooterViewWithSection:section WithExpDataArray:payModel.contPayMethodExpTypDels];
        }
        return _View_PayFootView;
    }
//    else if (tableView==_View_ExpTypeTable){
//        if (section == _arr_ExpTInSect.count - 1) {
//            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
//            view.backgroundColor=Color_White_Same_20;
//            return view;
//        }
//    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_TermTable) {
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configContractTermCellWithArray:self.FormDatas.arr_DetailsArray withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_DetailsDataArray.count] ;
        if (cell.LookMore) {
            [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return cell;
        
    }else if (tableView==_View_PayModeTable){
        
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
//        [cell configContractPayMethodCellWithArray:self.FormDatas.arr_SecDetailsArray withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_SecDetailsDataArray.count] ;
        [cell configContractPayMethodCellWithArray:self.FormDatas.arr_SecDetailsArray withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.section] withindex:indexPath.section withCount:self.FormDatas.arr_SecDetailsDataArray.count] ;
        if (cell.LookMore) {
            [cell.LookMore addTarget:self action:@selector(SecLookMore:) forControlEvents:UIControlEventTouchUpInside];
            [cell.LookMore setImage: self.FormDatas.bool_SecisOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
            [cell.LookMore setTitle: self.FormDatas.bool_SecisOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
        }
        return cell;
    }else if (tableView==_View_ExpTypeTable){//费用类别明细表
        
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configContractExpTypeCellWithArray:self.FormDatas.arr_FouDetailsArray withDetailsModel:self.arr_ExpTInSect[indexPath.row] withindex:indexPath.row withCount:self.arr_ExpTInSect.count] ;
        if (cell.LookMore) {
            cell.LookMore.alpha = 0;
        }
        return cell;
    }else if (tableView==_View_ConYearExpTable){
        
        ProcureDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell == nil) {
            cell = [[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configContractYearExpCellWithArray:self.FormDatas.arr_ThirDetailsArray withDetailsModel:self.FormDatas.arr_ThirDetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_ThirDetailsDataArray.count] ;
        if (cell.LookMore) {
            [cell.LookMore addTarget:self action:@selector(ThirLookMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return [[UITableViewCell alloc]init];
}
- (NSMutableArray *)arr_expTTable{//费用类别表数组
    if (!_arr_expTTable) {
        _arr_expTTable = [NSMutableArray array];
    }
    return _arr_expTTable;
}
- (NSMutableArray *)arr_ExpTInSect{//付款明细下的子表（费用类别明细）数据
    if (!_arr_ExpTInSect) {
        _arr_ExpTInSect = [NSMutableArray array];
    }
    return _arr_ExpTInSect;
}

- (void)createPayModeTableFooterViewWithSection:(NSInteger)section WithExpDataArray:(NSMutableArray *)expArr{
    float height = 10.0;
    for (ExpTypeDetail *model in expArr) {
        height = height+[ProcureDetailsCell ContractExpTypeCellHeightWithArray:self.FormDatas.arr_FouDetailsArray WithModel:model];
    }
    _View_PayFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, height)];
    UITableView *expTable;
    if (self.arr_expTTable.count > section) {
        expTable = [self.arr_expTTable objectAtIndex:section];
    }else{
        expTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        expTable.backgroundColor=Color_WhiteWeak_Same_20;
        expTable.delegate = self;
        expTable.dataSource = self;
        expTable.scrollEnabled=NO;
        expTable.tag = section + 100;
        expTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.arr_expTTable addObject:expTable];
    }
    expTable.frame = CGRectMake(0, 0, Main_Screen_Width, height);
    [_View_PayFootView addSubview:expTable];
    _View_ExpTypeTable = expTable;
    [self.arr_ExpTInSect removeAllObjects];
    [self.arr_ExpTInSect addObjectsFromArray:expArr];
    [_View_ExpTypeTable reloadData];
    [_View_ExpTypeTable layoutIfNeeded];
    

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
