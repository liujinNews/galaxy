//
//  ContractAppApproveController.m
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ContractAppApproveController.h"

@interface ContractAppApproveController ()

@end

@implementation ContractAppApproveController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[ContractAppFormData alloc]initWithStatus:3];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_flowCode=self.pushFlowCode;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeEditType=[self.pushComeEditType integerValue];
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
    if (self.FormDatas.int_comeStatus == 7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack];
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
    
    if (self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==7) {
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
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self createMainView];
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
    
    _View_ContNo = [[UIView alloc]init];
    _View_ContNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContNo];
    [_View_ContNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
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
    
    _CategoryView = [[UIView alloc]init];
    _CategoryView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
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
    
    _View_RelCont = [[UIView alloc]init];
    _View_RelCont.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RelCont];
    [_View_RelCont makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0005"];
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
    
////    是否使用标准合同模版
//    _view_StdConTemplate = [[UIView alloc]init];
//    _view_StdConTemplate.backgroundColor = Color_WhiteWeak_Same_20;
//    [self.contentView addSubview:_view_StdConTemplate];
//    [_view_StdConTemplate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.View_ContType.bottom);
//        make.left.right.equalTo(self.contentView);
//    }];
    //    是否使用标准合同模版
    _model_StdConTemplate = [[WorkFormFieldsModel alloc]initialize];
    _model_StdConTemplate.view_View = [[UIView alloc]init];
    _model_StdConTemplate.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_model_StdConTemplate.view_View];
    [_model_StdConTemplate.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Amount = [[UIView alloc]init];
    _View_Amount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Amount];
    [_View_Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_StdConTemplate.view_View.bottom);
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
    
    //选择会签人员
     _view_ApprovalPersonnel=[[UIView alloc]init];
     _view_ApprovalPersonnel.backgroundColor=Color_WhiteWeak_Same_20;
     [_contentView addSubview: _view_ApprovalPersonnel];
     [_view_ApprovalPersonnel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.View_LocalCyAmount.bottom);
         make.left.right.equalTo(self.contentView);
     }];
    
    _View_ContractDate = [[UIView alloc]init];
    _View_ContractDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractDate];
    [_View_ContractDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ApprovalPersonnel.bottom);
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
    
    _View_PartyA = [[UIView alloc]init];
    _View_PartyA.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PartyA];
    [_View_PartyA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractCopies.bottom);
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
    _View_InvoiceTitle.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvoiceTitle];
    [_View_InvoiceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_InvoiceType = [[UIView alloc]init];
    _View_InvoiceType.backgroundColor=Color_WhiteWeak_Same_20;
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
        make.top.equalTo(self.View_SwiftCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
 
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankADDRESS.bottom);
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
    
    
    _View_TermTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_TermTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_TermTable.delegate=self;
    _View_TermTable.dataSource=self;
    _View_TermTable.scrollEnabled=NO;
    _View_TermTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_TermTable];
    [_View_TermTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
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
    
    _View_ReleContract = [[FormChildTableView alloc]init];
    [self.contentView addSubview:_View_ReleContract];
    [_View_ReleContract makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ConYearExpTable.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0);
    }];
    
    _View_ContractReleInfo = [[FormChildTableView alloc]init];
    [self.contentView addSubview:_View_ContractReleInfo];
    [_View_ContractReleInfo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReleContract.bottom);
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
//MARK:获取费用类别
-(void)requestCate{
    NSDictionary *parameters=@{@"Type":@"6"};
    [[GPClient shareGPClient]REquestByPostWithPath:GetAddCostNewCategry Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
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
            [self requestCate];
            break;
        case 5:
        {
            [self.FormDatas dealWithCateDateWithType:1];
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
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    
    [_FormRelatedView initFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithBaseModel:self.FormDatas Withcontroller:self];

    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"ContractNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Description"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateDescriptionViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateExpenseTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RelateContNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateRelateContractViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePurchaseNumberViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractTypId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractTypeViewWithModel:model];
        }else if([model.fieldName isEqualToString:@"IsStandardContractTemplate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            self.str_IsStandardContractTemplate = model.fieldValue;
            [self update_StdConTemplateView:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTotalAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCapitalizedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCurrencyCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateExchangeRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateLocalCyAmountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OtherApprover"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateApprovalOfficersTableView:model];
        }else if ([model.fieldName isEqualToString:@"ContractDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EffectiveDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEffectiveDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ExpiryDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateExpiryDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PayCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updatePayCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"MoneyOrderRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateMoneyOrderRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractCopies"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateContractCopiesViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyA"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyAViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyAStaff"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyAStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyATel"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyATelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyB"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyBViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBAddress"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyBAddressViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBPostCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyBPostCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBStaff"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyBStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PartyBTel"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updatePartyBTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceTitle"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateInvoiceTitleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InvoiceType"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateInvoiceTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateTaxRateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateClientNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ClientAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateClientAddrViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanName"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateIbanNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanAccount"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateIbanAccountViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IbanAddr"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateIbanAddrViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SwiftCode"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateSwiftCodeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BankADDRESS"]&&[[model.isShow stringValue]isEqualToString:@"1"]){
            [self updateBankADDRESSViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
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
    if (self.FormDatas.bool_DetailsShow&&self.FormDatas.arr_DetailsDataArray.count!=0) {
        [self updateTermTableView];
        [_View_TermTable reloadData];
    }
    if (self.FormDatas.bool_SecDetailsShow&&self.FormDatas.arr_SecDetailsDataArray.count!=0) {
        [self updatePayModeTableView];
        [_View_PayModeTable reloadData];
    }
    //更新费用类别
//    if (self.FormDatas.bool_FouDetailsShow&&self.FormDatas.arr_FouDetailsDataArray.count!=0) {
//        [self updateExpTypeTableView];
//        [_View_ExpTypeTable reloadData];
//    }
    //更新合同审批新增年度费用明细
    if (self.FormDatas.bool_ThirDetailsShow && self.FormDatas.arr_ThirDetailsDataArray.count != 0) {
        [self updateContractYearExpTableView];
        [_View_ConYearExpTable reloadData];
    }
    
    [self updateForeignCurrencyViews];

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
    _txf_ContNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContNo WithContent:_txf_ContNo WithFormType:self.FormDatas.int_codeIsSystem == 0 ? formViewShowText:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContNo addSubview:view];
}
//MARK:更新合同名称视图
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    _txf_ContName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContName WithContent:_txf_ContName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContName addSubview:view];
}
//MARK:更新描述
- (void)updateDescriptionViewWithModel:(MyProcurementModel *)model{
    _txf_Description = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_Description WithContent:_txf_Description WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Description addSubview:view];
}
//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Cate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_ExpenseCat, self.FormDatas.str_ExpenseType]]}];
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
//MARK:更新关联合同
-(void)updateRelateContractViewWithModel:(MyProcurementModel *)model{
    _txf_RelCont=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_RelCont WithContent:_txf_RelCont WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_RelateContName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"RelaContract"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_RelateContId;
        vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":weakSelf.FormDatas.str_flowGuid};
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_RelateContId = model.taskId;
            weakSelf.FormDatas.str_RelateContNo = model.contractNo;
            weakSelf.FormDatas.str_RelateContName = [GPUtils getSelectResultWithArray:@[model.contractNo,model.contractName]];
            weakSelf.txf_RelCont.text = weakSelf.FormDatas.str_RelateContName;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_RelCont addSubview:view];
}
//MARK:更新采购申请单视图
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo],
                           @"Model":model
                           };
    [_View_PurchaseForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_PurchaseForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        if (status == 1) {
            [weakSelf PurchaseFormClick];
        }else{
            [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
        }
    };
}
//MARK:更新合同类型视图
-(void)updateContractTypeViewWithModel:(MyProcurementModel *)model{
    _txf_ContType = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContType WithContent:_txf_ContType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_ContType}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ContractType"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_ContTypeId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_ContTypeId = model.Id;
            weakSelf.FormDatas.str_PartBType = model.catId;
            weakSelf.FormDatas.str_ContType = model.contractTyp;
            weakSelf.txf_ContType.text = model.contractTyp;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_ContType addSubview:view];
}
//MARK:更新是否是否使用标准模版合同
-(void)update_StdConTemplateView:(MyProcurementModel *)model{
    for (STOnePickModel *model1 in self.array_IsStdConTemplate) {
        if ([self.str_IsStandardContractTemplate isEqualToString:model1.Id]) {
            model.fieldValue=model1.Type;
//            self.int_requiredReason=model1.requiredReason;
//            self.int_requiredAtt=model1.requiredAtt;
        }
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_StdConTemplate.view_View WithContent:_model_StdConTemplate.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_IsStandardContractTemplate=Model.Id;
            weakSelf.model_StdConTemplate.txf_TexfField.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",Model.Type]]?[NSString stringWithFormat:@"%@",Model.Type]:@"";
//            weakSelf.int_requiredAtt=Model.requiredAtt;
//            weakSelf.int_requiredReason=Model.requiredReason;
//            weakSelf.str_ReplExpenseCode=@"";
//            weakSelf.str_ReplExpenseType=@"";
//            [weakSelf update_NoInvReasonView:weakSelf.model_NoInvReason];
//            [weakSelf update_ReplExpenseView:weakSelf.model_ReplExpense];
            weakSelf.FormDatas.str_IsStandardContractTemplate = Model.Id;
            if ([Model.Id isEqualToString:@"0"]) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:Custing(@"请确认已附加法务审核邮件", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:Custing(@"确认", nil) style:UIAlertActionStyleDefault handler:nil];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }];
        picker.typeTitle=Custing(@"是否使用标准合同模版", nil);
        picker.DateSourceArray=self.array_IsStdConTemplate;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=[NSString isEqualToNull:weakSelf.str_IsStandardContractTemplate]?weakSelf.str_IsStandardContractTemplate:@"1";
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_StdConTemplate.view_View addSubview:view];
}
//MARK:更新合同金额视图
-(void)updateTotalAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Amount =[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Amount WithContent:_txf_Amount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:amount];
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
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
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")]];
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
    _txf_LocalCyAmount = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_LocalCyAmount addSubview:view];
}
//MARK:更新会签人员
-(void)updateApprovalOfficersTableView:(MyProcurementModel *)model{
    _txf_ApprovalPersonnel = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ApprovalPersonnel WithContent:_txf_ApprovalPersonnel WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
//    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
//        UIButton *btn = [UIButton new];
//        btn.tag = 106;
//        [weakSelf btn_Click:btn];
        
            contactsVController *contactVC=[[contactsVController alloc]init];
//            contactVC.status = @"3";
            NSMutableArray *array = [NSMutableArray array];
            NSArray *idarr = [self.str_ApprovalPersonnel componentsSeparatedByString:@","];
            for (int i = 0 ; i<idarr.count ; i++) {
                NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                [array addObject:dic];
            }
            contactVC.arrClickPeople = array;
            contactVC.menutype=2;
            contactVC.itemType = 99;
            contactVC.Radio = @"2";
            contactVC.universalDelegate = self;
            __weak typeof(self) weakSelf = self;
            [contactVC setBlock:^(NSMutableArray *array) {
                NSMutableArray *nameArr=[NSMutableArray array];
                NSMutableArray *IdArr=[NSMutableArray array];
                NSMutableArray *DeptIdArr=[NSMutableArray array];
                for (int i = 0 ; i<array.count ; i++) {
                    buildCellInfo *info = array[i];
                    [nameArr addObject:[NSString stringWithFormat:@"%@",info.requestor]];
                    [IdArr addObject:[NSString stringWithFormat:@"%ld",info.requestorUserId]];
                    [DeptIdArr addObject:[NSString stringWithFormat:@"%@",info.requestorDeptId]];
                }
                weakSelf.str_ApprovalPersonnel = [GPUtils getSelectResultWithArray:IdArr WithCompare:@","];
//                weakSelf.str_ApprovalPersonnelDeptId = [GPUtils getSelectResultWithArray:DeptIdArr WithCompare:@","];
                weakSelf.txf_ApprovalPersonnel.text = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
        
    }];
    [_view_ApprovalPersonnel addSubview:view];
    if (![NSString isEqualToNull:model.fieldValue]) {
        _txf_ApprovalPersonnel.text = [NSString stringWithIdOnNO:self.FormDatas.personalData.Requestor];
        _str_ApprovalPersonnel =[NSString stringWithIdOnNO:self.FormDatas.personalData.RequestorUserId];
//        _str_BusinessPersonnelDeptId=[NSString stringWithIdOnNO:self.FormData.personalData.RequestorDeptId];
    }
}


//MARK:更新签订日期视图
-(void)updateContractDateViewWithModel:(MyProcurementModel *)model{
    _txf_ContractDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContractDate WithContent:_txf_ContractDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContractDate addSubview:view];
}
//MARK:更新合同有效期视图
-(void)updateEffectiveDateViewWithModel:(MyProcurementModel *)model{
    _txf_EffectiveDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EffectiveDate WithContent:_txf_EffectiveDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_EffectiveDate addSubview:view];
}
//MARK:更新合同截止日期视图
-(void)updateExpiryDateViewWithModel:(MyProcurementModel *)model{
    _txf_ExpiryDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExpiryDate WithContent:_txf_ExpiryDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ExpiryDate addSubview:view];
}
//MARK:更新付款方式视图
-(void)updatePayCodeViewWithModel:(MyProcurementModel *)model{
    _txf_PayCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PayCode WithContent:_txf_PayCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_PayMode}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"NewPayWay"];
        choose.ChooseCategoryArray = weakSelf.FormDatas.arr_PayCode;
        choose.ChooseCategoryId = weakSelf.FormDatas.str_PayCode;
        choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            if (array) {
                ChooseCategoryModel *model = array[0];
                weakSelf.FormDatas.str_PayCode = model.Id;
                weakSelf.FormDatas.str_PayMode = model.name;
                weakSelf.txf_PayCode.text = model.name;
            }else{
                weakSelf.FormDatas.str_PayCode = @"";
                weakSelf.FormDatas.str_PayMode = @"";
                weakSelf.txf_PayCode.text = @"";
            }
        };
        [weakSelf.navigationController pushViewController:choose animated:YES];
    }];
    [_View_PayCode addSubview:view];
    
}
//MARK:更新合同汇票比例饿视图
-(void)updateMoneyOrderRateViewWithModel:(MyProcurementModel *)model{
    _txf_MoneyOrderRate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_MoneyOrderRate WithContent:_txf_MoneyOrderRate WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_MoneyOrderRate addSubview:view];
}
//MARK:更新签订份数视图
-(void)updateContractCopiesViewWithModel:(MyProcurementModel *)model{
    _txf_ContractCopies = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ContractCopies WithContent:_txf_ContractCopies WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ContractCopies addSubview:view];
}
//MARK:更新我方单位名称视图
-(void)updatePartyAViewWithModel:(MyProcurementModel *)model{
    _txf_PartyA = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyA WithContent:_txf_PartyA WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyA addSubview:view];
}
//MARK:更新负责人视图
-(void)updatePartyAStaffViewWithModel:(MyProcurementModel *)model{
    _txf_PartyAStaff = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyAStaff WithContent:_txf_PartyAStaff WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyAStaff addSubview:view];
}
//MARK:更新电话视图
-(void)updatePartyATelViewWithModel:(MyProcurementModel *)model{
    _txf_PartyATel = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyATel WithContent:_txf_PartyATel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyATel addSubview:view];
    _txf_PartyATel.keyboardType = UIKeyboardTypePhonePad;
}
//MARK:更新对方单位名称视图
-(void)updatePartyBViewWithModel:(MyProcurementModel *)model{
    _txf_PartyB = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyB WithContent:_txf_PartyB WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        if ([weakSelf.FormDatas.str_PartBType isEqualToString:@"1"]) {
            [weakSelf SupplierClick];
        }else if ([weakSelf.FormDatas.str_PartBType isEqualToString:@"3"]){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                if ([Model.Id floatValue] == 1) {
                    [weakSelf SupplierClick];
                }else{
                    [weakSelf ClientClick];
                }
            }];
            picker.typeTitle = Custing(@"单位选择", nil);
            picker.DateSourceArray = weakSelf.FormDatas.arr_PartBType;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }else{
            [weakSelf ClientClick];
        }
    }];
    [_View_PartyB addSubview:view];
}
//MARK:更新地址视图
-(void)updatePartyBAddressViewWithModel:(MyProcurementModel *)model{
    _txf_PartyBAddr = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyBAddr WithContent:_txf_PartyBAddr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyBAddr addSubview:view];
}
//MARK:更新邮编视图
-(void)updatePartyBPostCodeViewWithModel:(MyProcurementModel *)model{
    _txf_PartyBPostCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyBPostCode WithContent:_txf_PartyBPostCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyBPostCode addSubview:view];
    _txf_PartyBPostCode.keyboardType = UIKeyboardTypePhonePad;
}
//MARK:更新联系人视图
-(void)updatePartyBStaffViewWithModel:(MyProcurementModel *)model{
    _txf_PartyBStaff = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyBStaff WithContent:_txf_PartyBStaff WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyBStaff addSubview:view];
}
//MARK:更新电话视图
-(void)updatePartyBTelViewWithModel:(MyProcurementModel *)model{
    _txf_PartyBTel = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PartyBTel WithContent:_txf_PartyBTel WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PartyBTel addSubview:view];
    _txf_PartyBTel.keyboardType = UIKeyboardTypePhonePad;
}
//MARK:更新开户银行视图
-(void)updateBankNameViewWithModel:(MyProcurementModel *)model{
    _txf_BankName = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankName WithContent:_txf_BankName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankName addSubview:view];
}
//更新银行账号视图
-(void)updateBankAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_BankAccount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankAccount addSubview:view];
    _txf_BankAccount.keyboardType = UIKeyboardTypeEmailAddress;
    //    _Txf_BankAccount.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^BOOL(UITextField *txf, NSRange rang, NSString *str) {
    //        NSString *newString = [txf.text stringByReplacingCharactersInRange:rang withString:str];
    //        BOOL res = YES;
    //        NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    //        int i = 0;
    //        while (i < newString.length) {
    //            NSString * string = [newString substringWithRange:NSMakeRange(i, 1)];
    //            NSRange range = [string rangeOfCharacterFromSet:tmpSet];
    //            if (range.length == 0) {
    //                res = NO;
    //                break;
    //            }
    //            i++;
    //        }
    //        return res;
    //    };
}
//MARK:发票抬头更新
-(void)updateInvoiceTitleViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceTitle = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvoiceTitle WithContent:_txf_InvoiceTitle WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvoiceTitle addSubview:view];
}
//MARK:发票类型更新
-(void)updateInvoiceTypeViewWithModel:(MyProcurementModel *)model{
    _txf_InvoiceType = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_InvoiceType = Model.Id;
            weakSelf.txf_InvoiceType.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_InvoiceTypes;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_InvoiceType;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    if ([self.FormDatas.str_InvoiceType isEqualToString:@"2"]) {
        self.txf_InvoiceType.text = Custing(@"增值税普通发票", nil);
    }else if ([self.FormDatas.str_InvoiceType isEqualToString:@"1"]){
        self.txf_InvoiceType.text = Custing(@"增值税专用发票", nil);
    } else{
        self.txf_InvoiceType.text = @"";
    }
    [_View_InvoiceType addSubview:view];
}
//MARK:发票税率更新
-(void)updateTaxRateViewWithModel:(MyProcurementModel *)model{
    _txf_TaxRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TaxRate WithContent:_txf_TaxRate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_TaxRate.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"税率(%)", nil);
        picker.DateSourceArray = self.FormDatas.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_TaxRate addSubview:view];
}
//MARK:客户名称更新
-(void)updateClientNameViewWithModel:(MyProcurementModel *)model{
    _txf_ClientName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ClientName WithContent:_txf_ClientName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ClientName addSubview:view];
    
}
//MARK:客户地址更新
-(void)updateClientAddrViewWithModel:(MyProcurementModel *)model{
    _txf_ClientAddr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ClientAddr WithContent:_txf_ClientAddr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ClientAddr addSubview:view];
}
//MARK:银行名称更新
-(void)updateIbanNameViewWithModel:(MyProcurementModel *)model{
    _txf_IbanName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanName WithContent:_txf_IbanName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanName addSubview:view];
}
//MARK:IBAN/银行账号更新
-(void)updateIbanAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_IbanAccount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanAccount WithContent:_txf_IbanAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanAccount addSubview:view];
    _txf_IbanAccount.keyboardType = UIKeyboardTypeEmailAddress;
    
}
//MARK:IBAN/银行地址更新
-(void)updateIbanAddrViewWithModel:(MyProcurementModel *)model{
    _txf_IbanAddr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IbanAddr WithContent:_txf_IbanAddr WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_IbanAddr addSubview:view];
    
}
//MARK:IBAN/银行SwiftCode更新
-(void)updateSwiftCodeViewWithModel:(MyProcurementModel *)model{
    _txf_SwiftCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SwiftCode WithContent:_txf_SwiftCode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_SwiftCode addSubview:view];
}
//MARK:IBAN/银行IBAN更新
-(void)updateBankNoViewWithModel:(MyProcurementModel *)model{
    _txf_BankNo = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankNo WithContent:_txf_BankNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankNo addSubview:view];
}
//MARK:IBAN/银行IbanADDRESS更新
-(void)updateBankADDRESSViewWithModel:(MyProcurementModel *)model{
    _txf_BankADDRESS = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankADDRESS WithContent:_txf_BankADDRESS WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankADDRESS addSubview:view];
}
//MARK:更新外币付款信息
-(void)updateForeignCurrencyViews{
    self.FormDatas.bool_isForeign = NO;
    for (STOnePickModel *model in self.FormDatas.arr_CurrencyCode) {
        if ([model.Id isEqualToString:self.FormDatas.str_CurrencyCode]&&[model.stdMoney floatValue]!=1) {
            self.FormDatas.bool_isForeign = YES;
        }
    }
    [_View_ClientName updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_ClientName)?@60:@0));
    }];
    
    [_View_ClientAddr updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_ClientAddr)?@60:@0));
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
    
    [_View_BankNo updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_BankNo)?@60:@0));
    }];
    
    [_View_BankADDRESS updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(((self.FormDatas.bool_isForeign&&self.txf_BankADDRESS)?@60:@0));
    }];
    
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
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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
//MARK:更新底层视图
-(void)updateBottomView{
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
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
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
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
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                [weakSelf updateCateGoryView];
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
//MARK:修改币种
-(void)changeCurrency{
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_CurrencyCode = Model.Id;
        weakSelf.FormDatas.str_Currency = Model.Type;
        weakSelf.txf_CurrencyCode.text = Model.Type;
        weakSelf.txf_ExchangeRate.text = Model.exchangeRate;
        weakSelf.FormDatas.str_ExchangeRate = Model.exchangeRate;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
        [weakSelf updateForeignCurrencyViews];
    }];
    picker.typeTitle = Custing(@"币种", nil);
    picker.DateSourceArray = [NSMutableArray arrayWithArray:self.FormDatas.arr_CurrencyCode];
    STOnePickModel *model = [[STOnePickModel alloc]init];
    model.Id = [NSString isEqualToNull:self.FormDatas.str_CurrencyCode] ? self.FormDatas.str_CurrencyCode:@"";
    picker.Model = model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//MARK:修改供应商
-(void)SupplierClick{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId = self.FormDatas.str_PartBId;
    vc.dict_otherPars = @{@"DateType":self.FormDatas.str_SupplierParam};
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_PartBId = model.Id;
        weakSelf.FormDatas.str_PartB = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_PartyB.text = weakSelf.FormDatas.str_PartB;
        weakSelf.txf_BankName.text = model.depositBank;
        weakSelf.txf_BankAccount.text = model.bankAccount;
        weakSelf.txf_PartyBAddr.text = model.address;
        weakSelf.txf_PartyBPostCode.text = model.postCode;
        weakSelf.txf_PartyBStaff.text = model.contacts;
        weakSelf.txf_PartyBTel.text = model.telephone;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改客户
-(void)ClientClick{
    __weak typeof(self) weakSelf = self;
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Client"];
    vc.ChooseCategoryId = self.FormDatas.str_PartBId;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_PartBId = model.Id;
        weakSelf.FormDatas.str_PartB = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_PartyB.text = weakSelf.FormDatas.str_PartB;
        weakSelf.txf_BankName.text = model.depositBank;
        weakSelf.txf_BankAccount.text = model.bankAccount;
        weakSelf.txf_PartyBAddr.text = model.address;
        weakSelf.txf_PartyBPostCode.text = model.postCode;
        weakSelf.txf_PartyBStaff.text = model.contacts;
        weakSelf.txf_PartyBTel.text = model.telephone;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
//MARK:撤回操作
-(void)reCallBack{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
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
//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    if (type == 2) {
        [self.FormDatas inModelHasApproveContent];
        [self configModelOtherData];
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }else{
        examineViewController *vc=[[examineViewController alloc]init];
        vc.ProcId=self.FormDatas.str_procId;
        vc.TaskId=self.FormDatas.str_taskId;
        vc.FlowCode=self.FormDatas.str_flowCode;
        vc.Type=[NSString stringWithFormat:@"%ld",(long)type];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)configModelOtherData{
    
    self.FormDatas.SubmitData.ContractNo = self.txf_ContNo.text;
    self.FormDatas.SubmitData.ContractName = self.txf_ContName.text;
    self.FormDatas.SubmitData.ContractName = self.txf_ContName.text;
    self.FormDatas.SubmitData.Description = self.txf_Description.text;
    self.FormDatas.SubmitData.TotalAmount = [NSString isEqualToNull:_txf_Amount.text] ? _txf_Amount.text:@"0";
    self.FormDatas.SubmitData.CapitalizedAmount = self.txf_Capitalized.text;
    NSString *LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate] ? self.FormDatas.str_ExchangeRate:@"1.0000")];
    LocalCyAmount = [GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    self.FormDatas.SubmitData.LocalCyAmount = [NSString isEqualToNull:LocalCyAmount] ? LocalCyAmount:@"0.00";
    self.FormDatas.SubmitData.ContractDate = self.txf_ContractDate.text;
    self.FormDatas.SubmitData.EffectiveDate = self.txf_EffectiveDate.text;
    self.FormDatas.SubmitData.ExpiryDate = self.txf_ExpiryDate.text;
    self.FormDatas.SubmitData.MoneyOrderRate = self.txf_MoneyOrderRate.text;
    self.FormDatas.SubmitData.ContractCopies=_txf_ContractCopies.text;
    self.FormDatas.SubmitData.PartyA = self.txf_PartyA.text;
    self.FormDatas.SubmitData.PartyAStaff = self.txf_PartyAStaff.text;
    self.FormDatas.SubmitData.PartyATel = self.txf_PartyATel.text;
    self.FormDatas.SubmitData.PartyBStaff = self.txf_PartyBStaff.text;
    self.FormDatas.SubmitData.PartyBTel = self.txf_PartyBTel.text;
    self.FormDatas.SubmitData.BankName = self.txf_BankName.text;
    self.FormDatas.SubmitData.BankAccount = self.txf_BankAccount.text;
    self.FormDatas.SubmitData.PartyBAddress = self.txf_PartyBAddr.text;
    self.FormDatas.SubmitData.PartyBPostCode = self.txf_PartyBPostCode.text;
    self.FormDatas.SubmitData.PartyBPostCode = self.txf_PartyBPostCode.text;
    self.FormDatas.SubmitData.InvoiceTitle = self.txf_InvoiceTitle.text;
    self.FormDatas.SubmitData.TaxRate = self.txf_TaxRate.text;
    self.FormDatas.SubmitData.ClientName = self.View_ClientName.zl_height>0 ? self.txf_ClientName.text:@"";
    self.FormDatas.SubmitData.ClientAddr = self.View_ClientAddr.zl_height>0 ? self.txf_ClientAddr.text:@"";
    self.FormDatas.SubmitData.IbanName = self.View_IbanName.zl_height>0 ? self.txf_IbanName.text:@"";
    self.FormDatas.SubmitData.IbanAccount = self.View_IbanAccount.zl_height>0 ? self.txf_IbanAccount.text:@"";
    self.FormDatas.SubmitData.IbanAddr = self.View_IbanAddr.zl_height>0 ? self.txf_IbanAddr.text:@"";
    self.FormDatas.SubmitData.SwiftCode = self.View_SwiftCode.zl_height>0 ? self.txf_SwiftCode.text:@"";
    self.FormDatas.SubmitData.BankNo = self.View_BankNo.zl_height>0 ? self.txf_BankNo.text:@"";
    self.FormDatas.SubmitData.BankADDRESS = self.View_BankADDRESS.zl_height>0 ? self.txf_BankADDRESS.text:@"";
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
    self.FormDatas.SubmitData.IsStandardContractTemplate = [NSString isEqualToNull:self.str_IsStandardContractTemplate]?self.str_IsStandardContractTemplate:@"1";
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:STAFFOUTLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:1.0];
        }else{
            weakSelf.FormDatas.str_imageDataString=data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf readySubmitAndSave];
        }
    }];
}
-(void)readySubmitAndSave{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.ProcId=self.FormDatas.str_procId;
    vc.TaskId=self.FormDatas.str_taskId;
    vc.FlowCode=self.FormDatas.str_flowCode;
    vc.Type=@"2";
    vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
    [self.navigationController pushViewController:vc animated:YES];
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
            self.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            [self updateCateGoryView];
        }else{
            [self updateCateGoryView];
        }
    }
}
//MARK:费用类别明细表
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
    }
    if (expTable == nil) {
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
