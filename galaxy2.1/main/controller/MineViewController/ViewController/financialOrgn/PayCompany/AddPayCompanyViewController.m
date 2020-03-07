//
//  AddPayCompanyViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/2/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "AddPayCompanyViewController.h"
@interface AddPayCompanyViewController ()<GPClientDelegate,UIScrollViewDelegate>

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
@property (nonatomic, copy) NSString *str_LastCode;
@property (nonatomic, strong) UITextField *txf_no;
@property (nonatomic, strong) NSString *str_no;
@property (nonatomic, strong) UITextField *txf_name;
@property (nonatomic, strong) UITextField *txf_taxpayerId;//纳税人识别号
@property (nonatomic, strong) UITextField *txf_taxpayerType;//纳税人类型
@property (nonatomic, copy) NSString *str_taxpayerTypeId;//纳税人类型Id
@property (nonatomic, strong) NSMutableArray *arr_TaxpayerType;//纳税人类型
@property (nonatomic, strong) UITextField *txf_cat;
@property (nonatomic, copy) NSString *str_catId;
@property (nonatomic, strong) UITextField *txf_account;
@property (nonatomic, strong) UITextField *txf_bankOutlets;//开户行网点
@property (nonatomic, strong) UITextField *txf_bankName;//开户行
@property (nonatomic, strong) UITextField *txf_city;//开户城市
@property (nonatomic, copy) NSString *str_bankNo;//开户行行号
@property (nonatomic, copy) NSString *str_bankCode;//开户行编号
@property (nonatomic, copy) NSString *str_CNAPS;//支行行号
@property (nonatomic, copy) NSString *str_bankProvinceCode;//省code
@property (nonatomic, copy) NSString *str_bankProvince;//省
@property (nonatomic, copy) NSString *str_bankCityCode;//城市code
@property (nonatomic, copy) NSString *str_bankCity;//城市
@property (nonatomic, strong) UITextField *txf_contacts;
@property (nonatomic, strong) UITextField *txf_telephone;
@property (nonatomic, strong) UITextField *txf_email;
@property (nonatomic, strong) UITextField *txf_address;
@property (nonatomic, strong) UITextField *txf_post;
@property (nonatomic, strong) UITextField *txf_swiftcode;
@property (nonatomic, strong) UITextField *txf_vmscode;


@end

@implementation AddPayCompanyViewController

-(NSMutableArray *)arr_TaxpayerType{
    if (_arr_TaxpayerType == nil) {
        _arr_TaxpayerType = [NSMutableArray array];
        NSArray *type = @[Custing(@"一般纳税人", nil),Custing(@"小规模纳税人", nil)];
        NSArray *code = @[@"0",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_TaxpayerType addObject:model];
        }
    }
    return _arr_TaxpayerType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    if (self.SupDict) {
        [self setTitle:Custing(@"修改供应商", nil) backButton:YES];
    }else{
        [self setTitle:Custing(@"新增供应商", nil) backButton:YES];
    }
    [self createView];

}

-(void)createView{
    [self createMainView];
    [self checkInDate];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_click:)];
}

-(void)createMainView{
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
        make.bottom.equalTo(self.view);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled = YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    __weak typeof(self) weakSelf = self;

    
    UIView *NoView=[[UIView alloc]init];
    NoView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NoView];
    [NoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_no=[[UITextField alloc]init];
    [NoView addSubview:[[SubmitFormView alloc]initBaseView:NoView WithContent:_txf_no WithFormType:self.codeIsSystem == 0 ? formViewShowText:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"编号", nil) WithInfodict:nil WithTips:nil WithNumLimit:200]];
    if (self.codeIsSystem == 0) {
        _txf_no.text = Custing(@"系统自动生成", nil);
        if (!self.SupDict) {
            [NoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
    
    UIView *NameView=[[UIView alloc]init];
    NameView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:NameView];
    [NameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_name=[[UITextField alloc]init];
    [NameView addSubview:[[SubmitFormView alloc]initBaseView:NameView WithContent:_txf_name WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"供应商名称", nil) WithTips:Custing(@"请输入供应商名称", nil) WithInfodict:nil]];
    
    
    UIView *TaxpayerIdView = [[UIView alloc]init];
    TaxpayerIdView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:TaxpayerIdView];
    [TaxpayerIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    UIView *TaxpayerTypeView = [[UIView alloc]init];
    TaxpayerTypeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:TaxpayerTypeView];
    [TaxpayerTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TaxpayerIdView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId]isEqualToString:@"11888"]) {
        //纳税人识别号
        _txf_taxpayerId = [[UITextField alloc]init];
        [TaxpayerIdView addSubview:[[SubmitFormView alloc]initBaseView:TaxpayerIdView WithContent:_txf_taxpayerId WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"纳税人识别号", nil) WithTips:Custing(@"请输入纳税人识别号", nil) WithInfodict:nil]];
        _txf_taxpayerId.keyboardType = UIKeyboardTypeEmailAddress;
        
        //纳税人类型
        _txf_taxpayerType = [[UITextField alloc]init];
        SubmitFormView *taxpayerType = [[SubmitFormView alloc]initBaseView:TaxpayerTypeView WithContent:_txf_taxpayerType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"纳税人类型", nil) WithTips:Custing(@"请选择纳税人类型", nil) WithInfodict:nil];
        [taxpayerType setFormClickedBlock:^(MyProcurementModel *model){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakSelf.str_taxpayerTypeId = Model.Id;
                weakSelf.txf_taxpayerType.text = Model.Type;
            }];
            picker.typeTitle = Custing(@"纳税人类型", nil);
            picker.DateSourceArray = [NSMutableArray arrayWithArray:self.arr_TaxpayerType];
            STOnePickModel *model1 = [[STOnePickModel alloc]init];
            model1.Id = [self.str_taxpayerTypeId floatValue] == 1 ? @"1":@"0";
            picker.Model = model1;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
        [TaxpayerTypeView addSubview:taxpayerType];
    }
    
    UIView *CatView=[[UIView alloc]init];
    CatView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:CatView];
    [CatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TaxpayerTypeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_cat=[[UITextField alloc]init];
    SubmitFormView *cat = [[SubmitFormView alloc]initBaseView:CatView WithContent:_txf_cat WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"供应商类别", nil) WithTips:Custing(@"请选择供应商类别", nil) WithInfodict:nil];
    [cat setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"SupplierCat"];
        choose.ChooseCategoryId = self.str_catId;
        choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCategoryModel *model = array[0];
            weakSelf.str_catId = model.Id;
            weakSelf.txf_cat.text = model.name;
        };
        [weakSelf.navigationController pushViewController:choose animated:YES];
    }];
    [CatView addSubview:cat];

    
    UIView *swiftCodeView = [[UIView alloc]init];
    swiftCodeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:swiftCodeView];
    [swiftCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CatView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_swiftcode = [[UITextField alloc]init];
    [swiftCodeView addSubview:[[SubmitFormView alloc]initBaseView:swiftCodeView WithContent:_txf_swiftcode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"SWIFT CODE", nil) WithTips:Custing(@"请输入SWIFT CODE", nil) WithInfodict:nil]];
    _txf_swiftcode.keyboardType = UIKeyboardTypeEmailAddress;

    
    UIView *vmsCodeView = [[UIView alloc]init];
    vmsCodeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:vmsCodeView];
    [vmsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(swiftCodeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_vmscode = [[UITextField alloc]init];
    [vmsCodeView addSubview:[[SubmitFormView alloc]initBaseView:vmsCodeView WithContent:_txf_vmscode WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"VMS CODE", nil) WithTips:Custing(@"请输入VMS Code", nil) WithInfodict:nil]];
    _txf_vmscode.keyboardType = UIKeyboardTypeEmailAddress;

    
    UIView *AccountView=[[UIView alloc]init];
    AccountView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:AccountView];
    [AccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vmsCodeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_account=[[UITextField alloc]init];
    [AccountView addSubview:[[SubmitFormView alloc]initBaseView:AccountView WithContent:_txf_account WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"银行账号", nil) WithInfodict:nil WithTips:Custing(@"请输入银行账号", nil) WithNumLimit:100]];
    _txf_account.keyboardType =UIKeyboardTypeEmailAddress;

    
    UIView *BankOutletsView = [[UIView alloc]init];
    BankOutletsView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:BankOutletsView];
    [BankOutletsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AccountView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_bankOutlets = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:BankOutletsView WithContent:_txf_bankOutlets WithFormType:formViewSelect WithSegmentType:lineViewNoneLine WithString:Custing(@"开户网点", nil) WithInfodict:nil WithTips:Custing(@"选择开户网点", nil) WithNumLimit:0];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ClearingBank"];
        vc.ChooseBankOutletsBlock = ^(NSMutableArray *array) {
            ChooseCateFreModel *model = array[0];
            self.txf_bankOutlets.text = model.bankName;
            self.txf_bankName.text = model.clearingBank;
            self.txf_city.text = [GPUtils getSelectResultWithArray:@[model.provinceName,model.cityName] WithCompare:@"/"];
            self.str_bankNo = model.clearingBankNo;
            self.str_bankCode = model.clearingBankCode;
            self.str_CNAPS = model.bankNo;
            self.str_bankProvinceCode = model.provinceCode;
            self.str_bankProvince = model.provinceName;
            self.str_bankCityCode = model.cityCode;
            self.str_bankCity = model.cityName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    [BankOutletsView addSubview:view];
    
    UIView *BankNameView = [[UIView alloc]init];
    BankNameView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:BankNameView];
    [BankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BankOutletsView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_bankName = [[UITextField alloc]init];
    [BankNameView addSubview:[[SubmitFormView alloc]initBaseView:BankNameView WithContent:_txf_bankName WithFormType:formViewShowText WithSegmentType:lineViewNoneLine WithString:Custing(@"开户行", nil) WithInfodict:nil WithTips:nil WithNumLimit:0]];
    
    
    UIView *CityView = [[UIView alloc]init];
    CityView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:CityView];
    [CityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BankNameView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_city = [[UITextField alloc]init];
    [CityView addSubview:[[SubmitFormView alloc]initBaseView:CityView WithContent:_txf_city WithFormType:formViewShowText WithSegmentType:lineViewNoneLine WithString:Custing(@"开户城市", nil) WithInfodict:nil WithTips:nil WithNumLimit:0]];

    
    UIView *contactsView=[[UIView alloc]init];
    contactsView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:contactsView];
    [contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CityView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_contacts=[[UITextField alloc]init];
    [contactsView addSubview:[[SubmitFormView alloc]initBaseView:contactsView WithContent:_txf_contacts WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"联系人", nil) WithTips:Custing(@"请输入联系人", nil) WithInfodict:nil]];
    
    
    
    UIView *telephoneView=[[UIView alloc]init];
    telephoneView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:telephoneView];
    [telephoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactsView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_telephone=[[UITextField alloc]init];
    [telephoneView addSubview:[[SubmitFormView alloc]initBaseView:telephoneView WithContent:_txf_telephone WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"电话", nil) WithTips:Custing(@"请输入电话", nil) WithInfodict:nil]];
    _txf_telephone.keyboardType =UIKeyboardTypeDecimalPad;

    
    UIView *emailView=[[UIView alloc]init];
    emailView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telephoneView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_email=[[UITextField alloc]init];
    [emailView addSubview:[[SubmitFormView alloc]initBaseView:emailView WithContent:_txf_email WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"邮箱", nil) WithTips:Custing(@"请输入邮箱", nil) WithInfodict:nil]];

    
    
    UIView *addressView=[[UIView alloc]init];
    addressView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_address=[[UITextField alloc]init];
    [addressView addSubview:[[SubmitFormView alloc]initBaseView:addressView WithContent:_txf_address WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"地址", nil) WithTips:Custing(@"请输入地址", nil) WithInfodict:nil]];
    
    UIView *postView=[[UIView alloc]init];
    postView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:postView];
    [postView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_post=[[UITextField alloc]init];
    [postView addSubview:[[SubmitFormView alloc]initBaseView:postView WithContent:_txf_post WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"邮编", nil) WithTips:Custing(@"请输入邮编", nil) WithInfodict:nil]];
    _txf_post.keyboardType =UIKeyboardTypeDecimalPad;
    

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(postView.bottom);
    }];
}
-(void)checkInDate{
    if (_SupDict) {
        if (self.codeIsSystem == 1) {
            _txf_no.text = [NSString stringWithIdOnNO:_SupDict[@"code"]];
        }
        _txf_name.text = [NSString stringWithIdOnNO:_SupDict[@"name"]];
        _txf_taxpayerId.text = [NSString stringWithIdOnNO:_SupDict[@"taxpayerID"]];

        self.str_taxpayerTypeId = [NSString isEqualToNull:_SupDict[@"taxpayerTypeId"]] ? _SupDict[@"taxpayerTypeId"]:(id)[NSNull null];
        _txf_taxpayerType.text = [NSString stringWithIdOnNO:_SupDict[@"taxpayerType"]];
        
        _txf_cat.text = [NSString stringWithIdOnNO:_SupDict[@"catName"]];
        self.str_catId = [NSString isEqualToNull:_SupDict[@"catId"]]?_SupDict[@"catId"]:@"0";
        _txf_swiftcode.text = [NSString stringWithIdOnNO:_SupDict[@"swiftCode"]];
        _txf_vmscode.text = [NSString stringWithIdOnNO:_SupDict[@"vmsCode"]];
        _txf_account.text = [NSString stringWithIdOnNO:_SupDict[@"bankAccount"]];
        self.txf_bankOutlets.text = _SupDict[@"bankOutlets"];
        self.txf_bankName.text = _SupDict[@"depositBank"];
        self.txf_city.text = [GPUtils getSelectResultWithArray:@[_SupDict[@"bankProvince"],_SupDict[@"bankCity"]] WithCompare:@"/"];
        self.str_bankNo = [NSString stringWithIdOnNO:_SupDict[@"bankNo"]];
        self.str_bankCode = [NSString stringWithIdOnNO:_SupDict[@"bankCode"]];
        self.str_CNAPS = [NSString stringWithIdOnNO:_SupDict[@"cnaps"]];
        self.str_bankProvinceCode = [NSString stringWithIdOnNO:_SupDict[@"bankProvinceCode"]];
        self.str_bankProvince = [NSString stringWithIdOnNO:_SupDict[@"bankProvince"]];
        self.str_bankCityCode = [NSString stringWithIdOnNO:_SupDict[@"bankCityCode"]];
        self.str_bankCity = [NSString stringWithIdOnNO:_SupDict[@"bankCity"]];
        _txf_contacts.text = [NSString isEqualToNull:_SupDict[@"contacts"]]?_SupDict[@"contacts"]:@"";
        _txf_email.text = [NSString isEqualToNull:_SupDict[@"email"]]?_SupDict[@"email"]:@"";
        _txf_address.text = [NSString isEqualToNull:_SupDict[@"address"]]?_SupDict[@"address"]:@"";
        _txf_telephone.text = [NSString isEqualToNull:_SupDict[@"telephone"]]?_SupDict[@"telephone"]:@"";
        _txf_post.text = [NSString isEqualToNull:_SupDict[@"postCode"]]?_SupDict[@"postCode"]:@"";
    }

}
#pragma mark - action
-(void)btn_click:(UIButton *)btn{
    if (self.codeIsSystem == 1 && self.txf_no.text.length <= 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入编号", nil) duration:2.0];
        return;
    }
    if (_txf_name.text.length == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入供应商", nil) duration:2.0];
        return;
        
    }else if (_txf_taxpayerType && _txf_taxpayerType.text.length == 0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请选择纳税人类型", nil) duration:2.0];
        return;

    }else if (_txf_account.text.length == 0){
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入银行账号", nil) duration:2.0];
        return;

    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"Id":[NSString isEqualToNull:_SupDict[@"id"]]?_SupDict[@"id"]:@"0",
                                                                                @"Name":_txf_name.text,
                                                                                @"CatId":[NSString isEqualToNull:self.str_catId]? self.str_catId:@"0",
                                                                                @"CatName":_txf_cat.text,
                                                                                @"SwiftCode":_txf_swiftcode.text,
                                                                                @"VmsCode":_txf_vmscode.text,
                                                                                @"Contacts":_txf_contacts.text,
                                                                                @"Telephone":_txf_telephone.text,
                                                                                @"Address":_txf_address.text,
                                                                                @"PostCode":_txf_post.text,
                                                                                @"BankAccount":_txf_account.text,
                                                                                @"Cnaps":self.str_CNAPS,
                                                                                @"BankOutlets": self.txf_bankOutlets.text,
                                                                                @"BankNo":self.str_bankNo,
                                                                                @"BankCode":self.str_bankCode,
                                                                                @"DepositBank":self.txf_bankName.text,
                                                                                @"BankProvinceCode":self.str_bankProvinceCode,
                                                                                @"BankProvince":self.str_bankProvince,
                                                                                @"BankCityCode":self.str_bankCityCode,
                                                                                @"BankCity":self.str_bankCity,
                                                                                @"Email":_txf_email.text
                                                                                }];
    if (self.codeIsSystem == 1) {
        [dict setObject:self.txf_no.text forKey:@"Code"];
    }else{
        if (self.SupDict) {
            [dict setObject:[NSString stringWithIdOnNO:self.SupDict[@"code"]] forKey:@"Code"];
        }
    }
    NSString *url=[NSString stringWithFormat:@"%@",SaveBeneficiary_B];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取最近一条code
-(void)getLastCode{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETLASTCODE];
    NSDictionary *parameters = @{@"Table":@"Sa_Beneficiary"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] isEqualToString:@"-1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"供应商已存在", nil) duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_SupDict?Custing(@"修改成功", nil):Custing(@"添加成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 1:
        {
            self.str_LastCode=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
            [self createView];
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
