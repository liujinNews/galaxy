//
//  PayeesEditViewController.m
//  galaxy
//
//  Created by hfk on 2018/8/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PayeesEditViewController.h"

@interface PayeesEditViewController ()<UIScrollViewDelegate,GPClientDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;

@property (nonatomic,strong)DoneBtnView * dockView;
@property (nonatomic, strong) UITextField *txf_payee;//收款人
@property (nonatomic, strong) UITextField *txf_bankAccount;//银行账号
@property (nonatomic, strong) UITextField *txf_bankOutlets;//开户行网点
@property (nonatomic, strong) UITextField *txf_bankName;//开户行
@property (nonatomic, strong) UITextField *txf_city;//开户城市
@property (nonatomic, strong) UITextField *txf_credentialType;//证件类型
@property (nonatomic, strong) UITextField *txf_identityCardId;//证件号码
@property (nonatomic, copy) NSString *str_bankNo;//开户行行号
@property (nonatomic, copy) NSString *str_bankCode;//开户行编号
@property (nonatomic, copy) NSString *str_CNAPS;//支行行号
@property (nonatomic, copy) NSString *str_bankProvinceCode;//省code
@property (nonatomic, copy) NSString *str_bankProvince;//省
@property (nonatomic, copy) NSString *str_bankCityCode;//城市code
@property (nonatomic, copy) NSString *str_bankCity;//城市
@property (nonatomic, copy) NSString *str_credentialType;//证件类型
@property (nonatomic, copy) NSString *str_identityCardId;//证件号码




@property (nonatomic, strong) UITextField *txf_telPhone;//电话

@end

@implementation PayeesEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    [self createMainView];
    if (self.model_Edit) {
        [self setTitle:Custing(@"编辑收款人", nil) backButton:YES];
        [self checkInDate];
    }else{
        [self setTitle:Custing(@"新增收款人", nil) backButton:YES];
    }

}
-(void)createMainView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor = Color_White_Same_20;
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
    
    [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        [weakSelf saveInfo];
    };
    
    UIView * ViewPayee=[[UIView alloc]init];
    ViewPayee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewPayee];
    [ViewPayee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _txf_payee=[[UITextField alloc]init];
    [ViewPayee addSubview:[[SubmitFormView alloc]initBaseView:ViewPayee WithContent:_txf_payee WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"收款人", nil) WithInfodict:nil WithTips:Custing(@"请输入收款人", nil) WithNumLimit:200]];
    
    UIView *ViewBankAccount=[[UIView alloc]init];
    ViewBankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewBankAccount];
    [ViewBankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewPayee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_bankAccount=[[UITextField alloc]init];
    [ViewBankAccount addSubview:[[SubmitFormView alloc]initBaseView:ViewBankAccount WithContent:_txf_bankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"银行账号", nil) WithInfodict:nil WithTips:Custing(@"请输入银行账号", nil) WithNumLimit:100]];
    _txf_bankAccount.keyboardType =UIKeyboardTypeEmailAddress;

    
    UIView *BankOutletsView = [[UIView alloc]init];
    BankOutletsView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:BankOutletsView];
    [BankOutletsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ViewBankAccount.bottom);
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

    
    
    UIView *CredentialTypeView = [[UIView alloc]init];
    CredentialTypeView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view addSubview:CredentialTypeView];
    [CredentialTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CityView.bottom);
        make.left.right.equalTo(self.view);
    }];
    _txf_credentialType = [[UITextField alloc]init];
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:CredentialTypeView WithContent:_txf_credentialType WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine WithString:Custing(@"证件类型", nil) WithInfodict:nil WithTips:Custing(@"请选择证件类型", nil) WithNumLimit:0];
    view1.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_credentialType.text = Model.Type;
            weakSelf.str_credentialType = Model.Type;
        }];;
        picker.typeTitle = Custing(@"证件类型", nil);
        NSMutableArray *arr = [NSMutableArray array];
        [STOnePickModel getCertificateType:arr];
        picker.DateSourceArray = [NSMutableArray arrayWithArray:arr];
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Type = weakSelf.str_credentialType;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker show];
    };
    [CredentialTypeView addSubview:view1];

    UIView *IdentityCardIdView = [[UIView alloc]init];
    IdentityCardIdView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:IdentityCardIdView];
    [IdentityCardIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CredentialTypeView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_identityCardId = [[UITextField alloc]init];
    [IdentityCardIdView addSubview:[[SubmitFormView alloc]initBaseView:IdentityCardIdView WithContent:_txf_identityCardId WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine WithString:Custing(@"证件号", nil) WithInfodict:nil WithTips:Custing(@"请输入证件号", nil) WithNumLimit:200]];

    
    UIView *ViewTelPhone=[[UIView alloc]init];
    ViewTelPhone.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:ViewTelPhone];
    [ViewTelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IdentityCardIdView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_telPhone=[[UITextField alloc]init];
    [ViewTelPhone addSubview:[[SubmitFormView alloc]initBaseView:ViewTelPhone WithContent:_txf_telPhone WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"电话", nil) WithInfodict:nil WithTips:Custing(@"请输入电话", nil) WithNumLimit:200]];
    _txf_telPhone.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ViewTelPhone.bottom);
    }];
}

-(void)checkInDate{
    self.txf_payee.text = _model_Edit.payee;
    self.txf_bankAccount.text = _model_Edit.bankAccount;
    self.txf_bankOutlets.text = _model_Edit.bankOutlets;
    self.txf_bankName.text = _model_Edit.depositBank;
    self.txf_city.text = [GPUtils getSelectResultWithArray:@[_model_Edit.bankProvince,_model_Edit.bankCity] WithCompare:@"/"];
    self.str_bankNo = _model_Edit.bankNo;
    self.str_bankCode = _model_Edit.bankCode;
    self.str_CNAPS = _model_Edit.cnaps;
    self.str_bankProvinceCode = _model_Edit.bankProvinceCode;
    self.str_bankProvince = _model_Edit.bankProvince;
    self.str_bankCityCode = _model_Edit.bankCityCode;
    self.str_bankCity = _model_Edit.bankCity;
    self.txf_credentialType.text = _model_Edit.credentialType;
    self.str_credentialType = _model_Edit.credentialType;
    self.txf_identityCardId.text = _model_Edit.identityCardId;
    self.txf_telPhone.text = _model_Edit.tel;
}

-(void)saveInfo{
    [self keyClose];
    if (self.txf_payee.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入收款人", nil)];
        return;
    }
    if (self.txf_bankAccount.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入银行账号", nil)];
        return;
    }
    [self requestSave];
}

-(void)requestSave{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dic    =@{@"Id":_model_Edit ? _model_Edit.Id:@"",
                             @"Payee":self.txf_payee.text,
                             @"BankAccount":self.txf_bankAccount.text,
                             @"Cnaps":self.str_CNAPS,
                             @"BankOutlets": self.txf_bankOutlets.text,
                             @"BankNo":self.str_bankNo,
                             @"BankCode":self.str_bankCode,
                             @"DepositBank":self.txf_bankName.text,
                             @"BankProvinceCode":self.str_bankProvinceCode,
                             @"BankProvince":self.str_bankProvince,
                             @"BankCityCode":self.str_bankCityCode,
                             @"BankCity":self.str_bankCity,
                             @"CredentialType":self.str_credentialType,
                             @"IdentityCardId":self.txf_identityCardId.text,
                             @"Tel":self.txf_telPhone.text};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",ADDEDITOUTSIDEPAYEE] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            if ([NSString isEqualToNull:responceDic[@"result"]]) {
                if ([[NSString stringWithFormat:@"%@",responceDic[@"result"]]isEqualToString:@"-1"]) {
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"已存在", nil) duration:2.0];
                    return;
                }
                [[GPAlertView sharedAlertView]showAlertText:self WithText:self.model_Edit ? Custing(@"编辑成功", nil):Custing(@"新增成功", nil) duration:2.0];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1];
            }
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
