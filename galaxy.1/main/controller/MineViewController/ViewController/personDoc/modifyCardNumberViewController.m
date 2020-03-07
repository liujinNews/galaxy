//
//  modifyCardNumberViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define  credential  @"0123456789X"

#import "STOnePickView.h"
#import "modifyCardNumberViewController.h"
#import "STOnePickModel.h"
#import "SelectCardViewController.h"
#import "TAlertView.h"
#import "STAlertView.h"
@interface modifyCardNumberViewController ()<GPClientDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)UITextField * serectTF;

@property(nonatomic,strong)NSString * isYan;
@property(nonatomic,strong)UITextField * nameTF;
@property(nonatomic,strong)UITextField * cardTF;
@property(nonatomic,strong)UITextField * bankTF;
@property(nonatomic,strong)UITextField * allbankTF;
@property(nonatomic,strong)NSString * bankName;
@property(nonatomic,strong)NSString * bankAccount;
@property(nonatomic,strong)NSString * bankSte;
@property(nonatomic,strong)NSString * bankHeadOffice;
@property(nonatomic,strong)NSString * bankNo;

@property(nonatomic, strong)NSString * credentialType;
@property(nonatomic, strong)NSString * identityCardId;
@property(nonatomic,strong)UITextField * identityCardIdTF;

@property(nonatomic,strong)UILabel *CardTypeLal;
@property(nonatomic,assign)BOOL requestType;

@property (nonatomic, strong) UITextField *txf_accountName;//收款人
@property (nonatomic, strong) UITextField *txf_bankAccount;//账号
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

@end

@implementation modifyCardNumberViewController
-(id)initWithType:(NSString *)type
{
    self=[super init];
    if (self) {
        self.status = type;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    if ([self.status isEqualToString:@"bankCard"] && self.requestType) {
        [self cerateModifyBankView];
    }else{
        [self.identityCardIdTF becomeFirstResponder];
    }
    self.requestType = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.requestType = YES;
    
    if ([self.status isEqualToString:@"bankCard"]) {
        [self setTitle:Custing(@"银行信息", nil) backButton:YES];
        self.isYan = @"no";
    }else{
        [self setTitle:Custing(@"证件信息", nil) backButton:YES ];
        [self createCredentialsView];
    }
}


#pragma mark - 证件信息
-(void)createCredentialsView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.credentialType = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"credentialType"]];
    self.identityCardId = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"identityCardId"]];
    
    UIView * idtypeImage = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH(self.view), 40)];
    idtypeImage.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:idtypeImage];
    

    UIImageView * skipImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-30, 11, 18, 18)];
    skipImage.image =[UIImage imageNamed:@"skipImage"];
    [idtypeImage addSubview:skipImage];
    
    UILabel * numberType = [GPUtils createLable:CGRectMake(15, 0, 75, 40) text:Custing(@"证件类型", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    numberType.numberOfLines = 0;
    [idtypeImage  addSubview:numberType];
    
    _CardTypeLal = [GPUtils createLable:CGRectMake(95, 0, Main_Screen_Width-130, 40) text:@"" font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    if ([NSString isEqualToNull:self.credentialType]) {
        _CardTypeLal.text = Custing(self.credentialType, nil);
    }
    [idtypeImage  addSubview:_CardTypeLal];
    
    UIButton * tapBtn = [GPUtils createButton:CGRectMake(0, 0, WIDTH(idtypeImage),40) action:@selector(pickerViewAccountInfo:) delegate:self title:@"" font:Font_cellContent_16 titleColor:Color_Unsel_TitleColor];
    [idtypeImage addSubview:tapBtn];
    
    
    UIView * idNumblerImage = [[UIView alloc]initWithFrame:CGRectMake(0, 60, WIDTH(self.view), 40)];
    idNumblerImage.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:idNumblerImage];
    
    UILabel * idNumberType = [GPUtils createLable:CGRectMake(15, 0, 75, 40) text:Custing(@"证件号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    idNumberType.numberOfLines = 0;
    [idNumblerImage  addSubview:idNumberType];
    
    self.identityCardIdTF = [GPUtils createTextField:CGRectMake(100, 0, WIDTH(idNumblerImage)-130, 40) placeholder:Custing(@"请输入证件号", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.identityCardIdTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.identityCardIdTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.identityCardIdTF.adjustsFontSizeToFitWidth = YES;
    self.identityCardIdTF.tag = 4;
    self.identityCardIdTF.delegate=self;
    self.identityCardIdTF.keyboardType = UIKeyboardTypeEmailAddress;
    if ([NSString isEqualToNull:self.identityCardId]) {
        self.identityCardIdTF.text = self.identityCardId;
    }
    [idNumblerImage addSubview:self.identityCardIdTF];
    
    UIButton * modifyBtn = [GPUtils createButton:CGRectMake(15, 120, Main_Screen_Width-30, 44) action:@selector(save:) delegate:self type:UIButtonTypeCustom];
    [modifyBtn setTitle:Custing(@"确定", nil) forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = Font_Important_15_20;
    [modifyBtn setTintColor:Color_form_TextFieldBackgroundColor];
    [modifyBtn setBackgroundColor:Color_Blue_Important_20];
    modifyBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:modifyBtn];
    
    
}

-(void)pickerViewAccountInfo:(UIButton *)btn{
    [self keyClose];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.CardTypeLal.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",Model.Type]]?[NSString stringWithFormat:@"%@",Model.Type]:@"";
        weakSelf.credentialType=Custing(weakSelf.CardTypeLal.text, nil);
    }];;
    picker.typeTitle=Custing(@"证件类型", nil);
    NSMutableArray *arr=[NSMutableArray array];
    [STOnePickModel getCertificateType:arr];
    picker.DateSourceArray=[NSMutableArray arrayWithArray:arr];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Type=[NSString isEqualToNull: _CardTypeLal.text]?_CardTypeLal.text:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker show];
}



#pragma mark - 创建验证密码
-(void)cerateModifyBankView{

    TAlertView *alterAccount =[[TAlertView alloc] initWithTitle:Custing(@"输入密码",nil) withSubTitle:nil message:Custing(@"请输入登录密码",nil)];
    __weak typeof(self) weakSelf = self;
    [alterAccount showPawWithTXFActionSure:^(id str) {
        userData *datas = [userData shareUserData];
        if ([datas.password isEqualToString:str]) {
            weakSelf.isYan = @"yes";
            [alterAccount close];
            [weakSelf createHaveVerifyModifyView];
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@""
                                                        message:Custing(@"密码错误，重新输入", nil)
                                                       delegate:nil
                                              cancelButtonTitle:Custing(@"确定", nil)
                                              otherButtonTitles:nil,nil];
            [alert show];
        }
    } cancel:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - 创建银行信息
-(void)createHaveVerifyModifyView{
    
    self.view.backgroundColor = Color_White_Same_20;
    
    __weak typeof(self) weakSelf = self;
    UIView *AccountNameView = [[UIView alloc]init];
    AccountNameView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:AccountNameView];
    [AccountNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    _txf_accountName = [[UITextField alloc]init];
    [AccountNameView addSubview:[[SubmitFormView alloc]initBaseView:AccountNameView WithContent:_txf_accountName WithFormType:formViewEnterText WithSegmentType:lineViewNone WithString:Custing(@"收款人", nil) WithInfodict:nil WithTips:Custing(@"请输入收款人", nil) WithNumLimit:50]];

    
    UIView *BankAccountView = [[UIView alloc]init];
    BankAccountView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:BankAccountView];
    [BankAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AccountNameView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_bankAccount = [[UITextField alloc]init];
    [BankAccountView addSubview:[[SubmitFormView alloc]initBaseView:BankAccountView WithContent:_txf_bankAccount WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"账号", nil) WithInfodict:nil WithTips:Custing(@"请输入账号", nil) WithNumLimit:50]];
    _txf_bankAccount.keyboardType = UIKeyboardTypeEmailAddress;
    
    
    UIView *BankOutletsView = [[UIView alloc]init];
    BankOutletsView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:BankOutletsView];
    [BankOutletsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BankAccountView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_bankOutlets = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:BankOutletsView WithContent:_txf_bankOutlets WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"开户网点", nil) WithInfodict:nil WithTips:Custing(@"选择开户网点", nil) WithNumLimit:0];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ClearingBank"];
        vc.ChooseBankOutletsBlock = ^(NSMutableArray *array) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_bankOutlets.text = model.bankName;
            weakSelf.txf_bankName.text = model.clearingBank;
            weakSelf.txf_city.text = [GPUtils getSelectResultWithArray:@[model.provinceName,model.cityName] WithCompare:@"/"];
            weakSelf.str_bankNo = model.clearingBankNo;
            weakSelf.str_bankCode = model.clearingBankCode;
            weakSelf.str_CNAPS = model.bankNo;
            weakSelf.str_bankProvinceCode = model.provinceCode;
            weakSelf.str_bankProvince = model.provinceName;
            weakSelf.str_bankCityCode = model.cityCode;
            weakSelf.str_bankCity = model.cityName;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
    [BankNameView addSubview:[[SubmitFormView alloc]initBaseView:BankNameView WithContent:_txf_bankName WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine WithString:Custing(@"开户行", nil) WithInfodict:nil WithTips:nil WithNumLimit:0]];

    
    UIView *CityView = [[UIView alloc]init];
    CityView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:CityView];
    [CityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BankNameView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_city = [[UITextField alloc]init];
    [CityView addSubview:[[SubmitFormView alloc]initBaseView:CityView WithContent:_txf_city WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine WithString:Custing(@"开户城市", nil) WithInfodict:nil WithTips:nil WithNumLimit:0]];
    
    
    UIButton *btn=[GPUtils createButton:CGRectZero action:@selector(save:) delegate:self title:Custing(@"确定", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10.0];
    btn.backgroundColor=Color_Blue_Important_20;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CityView.bottom).offset(30);
        make.left.equalTo(self.view).offset(15);
        make.size.equalTo(CGSizeMake(Main_Screen_Width - 30, 48));
    }];
    
    if ([self.personDic[@"bankAccountInfo"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = self.personDic[@"bankAccountInfo"];
        self.txf_accountName.text = dict[@"accountName"];
        self.txf_bankAccount.text = dict[@"bankAccount"];
        self.txf_bankOutlets.text = dict[@"bankOutlets"];
        self.txf_bankName.text = dict[@"bankName"];
        self.txf_city.text = [GPUtils getSelectResultWithArray:@[dict[@"bankProvince"],dict[@"bankCity"]] WithCompare:@"/"];
        self.str_bankNo = [NSString stringWithIdOnNO:dict[@"bankNo"]];
        self.str_bankCode = [NSString stringWithIdOnNO:dict[@"bankCode"]];
        self.str_CNAPS = [NSString stringWithIdOnNO:dict[@"cnaps"]];
        self.str_bankProvinceCode = [NSString stringWithIdOnNO:dict[@"bankProvinceCode"]];
        self.str_bankProvince = [NSString stringWithIdOnNO:dict[@"bankProvince"]];
        self.str_bankCityCode = [NSString stringWithIdOnNO:dict[@"bankCityCode"]];
        self.str_bankCity = [NSString stringWithIdOnNO:dict[@"bankCity"]];
    }
}
-(void)nameTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    //    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 50) {
                textField.text = [toBeString substringToIndex:50];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"户名不超过50位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 50) {
            textField.text = [toBeString substringToIndex:50];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"户名不超过50位", nil)];
        }
    }
    
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 100) {
                textField.text = [toBeString substringToIndex:100];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开户行不超过100位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 100) {
            textField.text = [toBeString substringToIndex:100];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开户行不超过100位", nil)];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.cardTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.bankTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.identityCardIdTF];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyClose];
}



-(void)save:(UIButton *)btn{
    [self keyClose];
    if ([self.status isEqualToString:@"bankCard"]) {
        if ([self.isYan isEqualToString:@"no"]) {
            [self cerateModifyBankView];
            return;
        }
        if (self.txf_accountName.text.length <= 0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入收款人", nil)];
            return;
        }
        if (self.txf_bankAccount.text.length <= 0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"请输入账号"];
            return;
        }
        [self requestBankInfomation];
    }else{
        if (self.identityCardIdTF.text.length <= 0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入证件号", nil)];
            return;
        }
        
        if ([self.credentialType isEqualToString:@"身份证"]&&![GPUtils validateIDCardNumber:self.identityCardIdTF.text]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"输入身份证信息不正确，请重新输入。", nil)];
            return;
        }
        
        else{
            [self.identityCardIdTF resignFirstResponder];
            [self requestCredentials];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
            
        case 1:
        {
            if (textField.text.length >= 100 && string.length > 0){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"卡号不超过100位", nil)];
                return NO;
            }
        }
            break;
        case 3:
        {
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORDLIMIT]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }else{
                return NO;
            }
        }
            break;
        case 4:
        {
            if (textField.text.length >= 18 && string.length>0){
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"证件号不超过18位", nil)];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:credential]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

-(void)requestBankInfomation{
    NSDictionary *parameters = @{@"AccountName":self.txf_accountName.text,
                                 @"BankAccount": self.txf_bankAccount.text,
                                 @"Cnaps":self.str_CNAPS,
                                 @"BankOutlets": self.txf_bankOutlets.text,
                                 @"BankNo":self.str_bankNo,
                                 @"BankCode":self.str_bankCode,
                                 @"BankName":self.txf_bankName.text,
                                 @"BankProvinceCode":self.str_bankProvinceCode,
                                 @"BankProvince":self.str_bankProvince,
                                 @"BankCityCode":self.str_bankCityCode,
                                 @"BankCity":self.str_bankCity,
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:XB_UptBankInfo Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

-(void)requestCredentials{
    NSDictionary *parameters = @{@"CredentialType":self.credentialType,@"IdentityCardId": [NSString stringWithFormat:@"%@",self.identityCardIdTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_UptCredential Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestMatchingBankNo{
    NSDictionary *parameters = @{@"CardBinNo":_cardTF.text};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_MatchBankNo Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
//    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if (serialNum != 2) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self pushLoginViewController];
        });
    }
    
    switch (serialNum) {
        case 0://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"银行信息保存成功", nil) duration:2.0];
            break;
        case 1://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"证件信息保存成功", nil) duration:2.0];
            break;
        case 2:
            if (![responceDic[@"result"]isEqual:[NSNull null]]) {
                _bankTF.text = responceDic[@"result"][@"recBankName"];
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

-(void)pushLoginViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
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
