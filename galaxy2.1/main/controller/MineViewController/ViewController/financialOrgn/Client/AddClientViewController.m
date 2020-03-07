//
//  AddClientViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "AddClientViewController.h"
@interface AddClientViewController ()<GPClientDelegate,UIScrollViewDelegate>
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
@property (nonatomic, copy) NSString *str_LastCode;
//客户信息
@property (nonatomic, strong) UITextField *txf_no;
@property (nonatomic, copy) NSString *str_code;
@property (nonatomic, strong) UITextField *txf_name;
@property (nonatomic, strong) UITextField *txf_contacts;
@property (nonatomic, strong) UITextField *txf_telephone;
@property (nonatomic, strong) UITextField *txf_email;
@property (nonatomic, strong) UITextField *txf_address;
@property (nonatomic, strong) UITextField *txf_post;
//开票信息
//@property (nonatomic, strong) UITextField *txf_InvCorpName;
@property (nonatomic, strong) UITextField *txf_InvTaxpayerID;
@property (nonatomic, strong) UITextField *txf_InvBankName;
@property (nonatomic, strong) UITextField *txf_InvBankAccount;
@property (nonatomic, strong) UITextField *txf_InvTelephone;
@property (nonatomic, strong) UITextField *txf_InvAddress;


@end

@implementation AddClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    if ([NSString isEqualToNull:_ClickId]) {
        [self setTitle:Custing(@"修改客户", nil) backButton:YES];
        [self requestGetClient];
    }else{
        [self setTitle:Custing(@"新增客户", nil) backButton:YES];
        [self createMainView];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(btn_click:)];
}
#pragma mark - function
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
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
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
        if (!_ClickId) {
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
    [NameView addSubview:[[SubmitFormView alloc]initBaseView:NameView WithContent:_txf_name WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"客户名称", nil) WithTips:Custing(@"请输入客户名称", nil) WithInfodict:nil]];
    
    
    UIView *contactsView=[[UIView alloc]init];
    contactsView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:contactsView];
    [contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NameView.bottom);
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
    _txf_telephone.keyboardType =UIKeyboardTypeNumberPad;

    

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

    
    
    UIView *headView=[[UIView  alloc]init];
    [self.contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(postView.bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@27);
    }];
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [headView addSubview:ImgView];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 0,Main_Screen_Width-30, 26) text:Custing(@"开票信息", nil) font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    [headView addSubview:titleLabel];

    
//    UIView *InvCorpNameView=[[UIView alloc]init];
//    InvCorpNameView.backgroundColor=Color_WhiteWeak_Same_20;
//    [self.contentView addSubview:InvCorpNameView];
//    [InvCorpNameView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headView.bottom);
//        make.left.right.equalTo(self.contentView);
//    }];
//    _txf_InvCorpName=[[UITextField alloc]init];
//    [InvCorpNameView addSubview:[[SubmitFormView alloc]initBaseView:InvCorpNameView WithContent:_txf_InvCorpName WithFormType:formViewEnterText WithSegmentType:lineViewNone WithString:Custing(@"企业名称", nil) WithTips:Custing(@"请输入企业名称", nil) WithInfodict:nil]];

    
    UIView *InvTaxpayerIDView=[[UIView alloc]init];
    InvTaxpayerIDView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:InvTaxpayerIDView];
    [InvTaxpayerIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvTaxpayerID=[[UITextField alloc]init];
    [InvTaxpayerIDView addSubview:[[SubmitFormView alloc]initBaseView:InvTaxpayerIDView WithContent:_txf_InvTaxpayerID WithFormType:formViewEnterText WithSegmentType:lineViewNone WithString:Custing(@"纳税人识别号", nil) WithTips:Custing(@"请输入纳税人识别号", nil) WithInfodict:nil]];

    
    UIView *InvBankNameView=[[UIView alloc]init];
    InvBankNameView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:InvBankNameView];
    [InvBankNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InvTaxpayerIDView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvBankName=[[UITextField alloc]init];
    [InvBankNameView addSubview:[[SubmitFormView alloc]initBaseView:InvBankNameView WithContent:_txf_InvBankName WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"开户行", nil) WithTips:Custing(@"请输入开户行", nil) WithInfodict:nil]];

    
    UIView *InvBankAccountView=[[UIView alloc]init];
    InvBankAccountView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:InvBankAccountView];
    [InvBankAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InvBankNameView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvBankAccount=[[UITextField alloc]init];
    [InvBankAccountView addSubview:[[SubmitFormView alloc]initBaseView:InvBankAccountView WithContent:_txf_InvBankAccount WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"银行账号", nil) WithInfodict:nil WithTips:Custing(@"请输入银行账号", nil) WithNumLimit:100]];
    _txf_InvBankAccount.keyboardType =UIKeyboardTypeEmailAddress;

   
    UIView *InvTelephoneView=[[UIView alloc]init];
    InvTelephoneView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:InvTelephoneView];
    [InvTelephoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InvBankAccountView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvTelephone=[[UITextField alloc]init];
    [InvTelephoneView addSubview:[[SubmitFormView alloc]initBaseView:InvTelephoneView WithContent:_txf_InvTelephone WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"电话", nil) WithTips:Custing(@"请输入电话", nil) WithInfodict:nil]];
    _txf_InvTelephone.keyboardType =UIKeyboardTypeNumberPad;

    UIView *InvAddressView=[[UIView alloc]init];
    InvAddressView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:InvAddressView];
    [InvAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InvTelephoneView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _txf_InvAddress=[[UITextField alloc]init];
    [InvAddressView addSubview:[[SubmitFormView alloc]initBaseView:InvAddressView WithContent:_txf_InvAddress WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine WithString:Custing(@"地址", nil) WithTips:Custing(@"请输入地址", nil) WithInfodict:nil]];

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(InvAddressView.bottom);
    }];
}

-(void)updateMainView:(NSDictionary *)dic{
    NSDictionary *dics = dic[@"result"];
    if (self.codeIsSystem == 1) {
        _txf_no.text = [NSString isEqualToNull:dics[@"code"]]?dics[@"code"]:@"";
    }
    if ([NSString isEqualToNull:dics[@"code"]]) {
        self.str_code = dics[@"code"];
    }
    _txf_name.text = [NSString isEqualToNull:dics[@"name"]]?dics[@"name"]:@"";
    _txf_contacts.text = [NSString isEqualToNull:dics[@"contacts"]]?dics[@"contacts"]:@"";
    _txf_address.text = [NSString isEqualToNull:dics[@"address"]]?dics[@"address"]:@"";
    _txf_telephone.text = [NSString isEqualToNull:dics[@"telephone"]]?dics[@"telephone"]:@"";
    _txf_email.text = [NSString isEqualToNull:dics[@"email"]]?dics[@"email"]:@"";
    _txf_post.text = [NSString isEqualToNull:dics[@"postCode"]]?dics[@"postCode"]:@"";
//    _txf_InvCorpName.text=[NSString isEqualToNull:dics[@"invCorpName"]]?dics[@"invCorpName"]:@"";
    _txf_InvTaxpayerID.text=[NSString isEqualToNull:dics[@"invTaxpayerID"]]?dics[@"invTaxpayerID"]:@"";
    _txf_InvBankName.text=[NSString isEqualToNull:dics[@"invBankName"]]?dics[@"invBankName"]:@"";
    _txf_InvBankAccount.text=[NSString isEqualToNull:dics[@"invBankAccount"]]?dics[@"invBankAccount"]:@"";
    _txf_InvTelephone.text=[NSString isEqualToNull:dics[@"invTelephone"]]?dics[@"invTelephone"]:@"";
    _txf_InvAddress.text=[NSString isEqualToNull:dics[@"invAddress"]]?dics[@"invAddress"]:@"";

}

-(void)btn_click:(UIButton *)btn{
    if (self.codeIsSystem == 1 && _txf_no.text.length <= 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入编号", nil) duration:2.0];
        return;
    }
    if (_txf_name.text.length <= 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入客户", nil) duration:2.0];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"Id":[NSString isEqualToNull:_ClickId]?_ClickId:@"",
                                                                                @"Name":[NSString isEqualToNull:_txf_name.text]?_txf_name.text:@"",
                                                                                @"Email":[NSString isEqualToNull:_txf_email.text]?_txf_email.text:@"",
                                                                                @"Contacts":[NSString isEqualToNull:_txf_contacts.text]?_txf_contacts.text:@"",
                                                                                @"Telephone":[NSString isEqualToNull:_txf_telephone.text]?_txf_telephone.text:@"",
                                                                                @"Address":[NSString isEqualToNull:_txf_address.text]?_txf_address.text:@"",
                                                                                @"PostCode":[NSString isEqualToNull:_txf_post.text]?_txf_post.text:@"",
                                                                                //                          @"InvCorpName":[NSString isEqualToNull:_txf_InvCorpName.text]?_txf_InvCorpName.text:@"",
                                                                                @"InvTaxpayerID":[NSString isEqualToNull:_txf_InvTaxpayerID.text]?_txf_InvTaxpayerID.text:@"",
                                                                                @"InvBankName":[NSString isEqualToNull:_txf_InvBankName.text]?_txf_InvBankName.text:@"",
                                                                                @"InvBankAccount":[NSString isEqualToNull:_txf_InvBankAccount.text]?_txf_InvBankAccount.text:@"",
                                                                                @"InvTelephone":[NSString isEqualToNull:_txf_InvTelephone.text]?_txf_InvTelephone.text:@"",
                                                                                @"InvAddress":[NSString isEqualToNull:_txf_InvAddress.text]?_txf_InvAddress.text:@""
                                                                                }];
    if (self.codeIsSystem == 1) {
        [dic setObject:self.txf_no.text forKey:@"Code"];
    }else{
        if (self.str_code.length > 0) {
            [dic setObject:[NSString stringWithIdOnNO:self.str_code] forKey:@"Code"];
        }
    }
    if (self.codeIsSystem == 1) {
        [dic setObject:self.txf_no.text forKey:@"Code"];
    }
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveClient] Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)requestGetClient{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dic =@{@"Id":[NSString isEqualToNull:_ClickId]?_ClickId:@""};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",GetClient] Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:获取最近一条code
-(void)getLastCode{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",GETLASTCODE];
    NSDictionary *parameters = @{@"Table":@"Sa_Client"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]] isEqualToString:@"-1"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"客户已存在", nil) duration:1.0];
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:_ClickId]?Custing(@"修改成功", nil):Custing(@"添加成功", nil) duration:2.0];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
            break;
        case 1:
        {
            [self createMainView];
            [self updateMainView:responceDic];
        }
            break;
        case 2:
        {
            self.str_LastCode=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
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
