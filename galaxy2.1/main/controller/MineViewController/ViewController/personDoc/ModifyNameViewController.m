//
//  ModifyNameViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#define EMAIL @"1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm@._%\\+-"

#import "ModifyNameViewController.h"

#import "TAlertView.h"

@interface ModifyNameViewController ()<GPClientDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)UITextField * serectTF;

@property (nonatomic,strong)UIView * verifyView;
@property (strong,nonatomic)UITextField * accountTF;
@property (strong,nonatomic)UITextField * verificationTF;
@property (strong,nonatomic)UIButton * verificationBtn;
@property (assign,nonatomic) NSUInteger count;

@property (strong,nonatomic)NSTimer  * timer;
@property (copy, nonatomic) NSString * canGetCheckcode;//是否正在获取checkcode
@property (strong,nonatomic)UIButton * nextBtn;

@property (nonatomic,strong)UITextField * nameTF;

@end

@implementation ModifyNameViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.status isEqualToString:@"name"]) {
        [self setTitle:Custing(@"更换姓名", nil) backButton:YES];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:Custing(@"保存", nil) titleColor:self.userdatas.SystemType==1?Color_form_TextFieldBackgroundColor:Normal_NavBar_TitleBlue_20 titleIndex:0 imageName:nil target:self action:@selector(modifyName:)];
        [self cerateModifyNameView];
        
    }else if ([self.status isEqualToString:@"phone"]){
        [self setTitle:Custing(@"更换手机号", nil) backButton:YES];
        [self cerateModifyPhoneView];
        
    }else if ([self.status isEqualToString:@"email"]){
        [self setTitle:Custing(@"更换邮箱", nil) backButton:YES];
        [self cerateModifyEmailView];
        
    }
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 姓名
-(void)cerateModifyNameView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    phoneView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:phoneView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.nameTF = [GPUtils createTextField:CGRectMake(15, 10, WIDTH(self.view)-30, 40) placeholder:Custing(@"请输入姓名", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    NSString * nameStr = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"userDspName"]];
    if ([NSString isEqualToNull:nameStr]) {
        self.nameTF.text = nameStr;
    }
    
    self.nameTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.nameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.nameTF.adjustsFontSizeToFitWidth = YES;
    self.nameTF.delegate=self;
    self.nameTF.tag = 11;
    self.nameTF.keyboardType = UIKeyboardTypeDefault;
    [phoneView addSubview:self.nameTF];
//    [self.nameTF becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameCustomTF1TextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTF];
    
    
//    UIButton * modifyBtn = [GPUtils createButton:CGRectMake(15, 90, Main_Screen_Width-30, 45 ) action:@selector(modifyName:) delegate:self type:UIButtonTypeCustom];
//    [modifyBtn setTitle:@"更换姓名" forState:UIControlStateNormal];
//    modifyBtn.titleLabel.font = Font_Important_15_20;
//    [modifyBtn setTintColor:Color_form_TextFieldBackgroundColor];
//    [modifyBtn setBackgroundColor:Color_Blue_Important_20];
//    modifyBtn.layer.cornerRadius = 11.0f;
//    [self.view addSubview:modifyBtn];
    
    
}


-(void)nameCustomTF1TextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 30) {
                textField.text = [toBeString substringToIndex:30];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过30位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 30) {
            textField.text = [toBeString substringToIndex:30];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过30位", nil)];
        }
    }
}



#pragma mark - 手机号
-(void)cerateModifyPhoneView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    phoneView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:phoneView];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 1, 100, 58) text:Custing(@"您的手机号：", nil) font:[UIFont systemFontOfSize:16.0f] textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.numberOfLines = 0;
    [phoneView addSubview:titleLbl];
    
    UILabel * phoneLbl = [GPUtils createLable:CGRectMake(115, 1, WIDTH(self.view)-130, 58) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    phoneLbl.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:phoneLbl];
    
    NSString * mobile = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"mobile"]];
    if ([NSString isEqualToNull:mobile]) {
        phoneLbl.text = mobile;
    }
     UIButton * modifyBtn = [GPUtils createButton:CGRectMake(15, 90, Main_Screen_Width-30, 45 ) action:@selector(PhoneNumberBtn:) delegate:self type:UIButtonTypeCustom];
    [modifyBtn setTitle:Custing(@"更换手机号", nil) forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = Font_Important_15_20;
    [modifyBtn setTintColor:Color_form_TextFieldBackgroundColor];
    [modifyBtn setBackgroundColor:Color_Blue_Important_20];
    modifyBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:modifyBtn];
    
    
    UILabel * describeLbl = [GPUtils createLable:CGRectMake(15, 135, WIDTH(self.view), 38) text:Custing(@"更换手机号后，登录手机号和企业通讯录均改变", nil) font:[UIFont systemFontOfSize:12.0f] textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    describeLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:describeLbl];
    
}



#pragma mark - 邮箱
-(void)cerateModifyEmailView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIView * phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 60)];
    phoneView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:phoneView];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(15, 1, 100, 58) text:Custing(@"您的邮箱：", nil) font:[UIFont systemFontOfSize:16.0f] textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    titleLbl.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:titleLbl];
    
    UILabel * phoneLbl = [GPUtils createLable:CGRectMake(115, 1, WIDTH(self.view)-130, 58) text:@"" font:[UIFont systemFontOfSize:16.0f] textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    phoneLbl.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:phoneLbl];
    
    NSString * mobile = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"email"]];
    if ([NSString isEqualToNull:mobile]) {
        phoneLbl.text = mobile;
    }
    UIButton * modifyBtn = [GPUtils createButton:CGRectMake(15, 90, Main_Screen_Width-30, 44) action:@selector(crateEmailModifyView:) delegate:self type:UIButtonTypeCustom];
    [modifyBtn setTitle:Custing(@"更换邮箱", nil) forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = Font_Important_15_20;
    [modifyBtn setTintColor:Color_form_TextFieldBackgroundColor];
    [modifyBtn setBackgroundColor:Color_Blue_Important_20];
    modifyBtn.layer.cornerRadius = 11.0f;
    [self.view addSubview:modifyBtn];
    
}

-(void)crateEmailModifyView:(UIButton *)btn{
    self.verifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.verifyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.verifyView];
    
    UIView * backgroundV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 140)];
    backgroundV.userInteractionEnabled = YES;
    backgroundV.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.verifyView addSubview:backgroundV];
    
    
    UIImageView * verifyNImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, WIDTH(self.verifyView)-30, 40)];
    verifyNImage.userInteractionEnabled = YES;
    verifyNImage.image = GPImage(@"my_modifyPhoneCorn");
    [backgroundV addSubview:verifyNImage];
    
    self.accountTF = [GPUtils createTextField:CGRectMake(10, 0, WIDTH(verifyNImage)-20, 40) placeholder:Custing(@"请输入邮箱", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.accountTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.accountTF.tag = 0;
    self.accountTF.delegate=self;
    self.accountTF.keyboardType = UIKeyboardTypeEmailAddress;
    [self.accountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [verifyNImage addSubview:self.accountTF];
    
    UIImageView * verifyBImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 80, WIDTH(self.verifyView)-30, 40)];
    verifyBImage.userInteractionEnabled = YES;
    verifyBImage.image = GPImage(@"my_verifyBtn");
    [backgroundV addSubview:verifyBImage];
    
    self.verificationTF = [GPUtils createTextField:CGRectMake(10, 0, WIDTH(verifyBImage)/3*2-10, 40) placeholder:Custing(@"请输入验证码", nil) delegate:self font:Font_cellContent_16 textColor:[XBColorSupport supportScreenListColor]];
    
    self.verificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTF.tag = 2;
    self.verificationTF.delegate=self;
    [verifyBImage addSubview:self.verificationTF];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    self.verificationBtn = [GPUtils createButton:CGRectMake(WIDTH(verifyBImage)/3*2+5, 0, WIDTH(verifyBImage)/3-10, 40) action:@selector(VerificationRestCode:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"获取验证码", nil) font:((lan)?Font_Same_14_20:Font_Same_12_20) color:Color_form_TextFieldBackgroundColor];
    [self.verificationBtn setBackgroundColor:[UIColor clearColor]];
    [verifyBImage addSubview:self.verificationBtn];
    
    self.nextBtn = [GPUtils createButton:CGRectMake(15,150, Main_Screen_Width-30, 44) action:@selector(relaySubmitNext:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"确定", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    self.nextBtn.layer.cornerRadius = 11.0f;
    [self.nextBtn setBackgroundColor:Color_Blue_Important_20];
    [self.verifyView addSubview:self.nextBtn];
    
}


-(void)PhoneNumberBtn:(UIButton *)btn{
    
    TAlertView *alterAccount =[[TAlertView alloc] initWithTitle:Custing(@"输入密码",nil) withSubTitle:nil message:Custing(@"请输入登录密码",nil)];
    __weak typeof(self) weakSelf = self;
    [alterAccount showPawWithTXFActionSure:^(id str) {
        userData *datas = [userData shareUserData];
        if ([datas.password isEqualToString:str]) {
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
    }];
    
}



-(void)createHaveVerifyModifyView{
    
    self.verifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.verifyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.verifyView];
    
    UIView * backgroundV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Height, 140)];
    backgroundV.userInteractionEnabled = YES;
    backgroundV.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.verifyView addSubview:backgroundV];
    
    
    UIImageView * verifyNImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, WIDTH(self.verifyView)-30, 40)];
    verifyNImage.userInteractionEnabled = YES;
    verifyNImage.image = GPImage(@"my_modifyPhoneCorn");
    [backgroundV addSubview:verifyNImage];
    
    self.accountTF = [GPUtils createTextField:CGRectMake(10, 0, WIDTH(verifyNImage)-20, 40) placeholder:Custing(@"请输入手机号", nil) delegate:self font:Font_cellContent_16 textColor:Color_form_TextField_20];
    self.accountTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.accountTF.tag = 0;
    self.accountTF.delegate=self;
    self.accountTF.keyboardType = UIKeyboardTypeNumberPad;
    [verifyNImage addSubview:self.accountTF];
    
    UIImageView * verifyBImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 80, WIDTH(self.verifyView)-30, 40)];
    verifyBImage.userInteractionEnabled = YES;
    verifyBImage.image = GPImage(@"my_verifyBtn");
    [backgroundV addSubview:verifyBImage];
    
    self.verificationTF = [GPUtils createTextField:CGRectMake(10, 0, WIDTH(verifyBImage)/3*2-10, 40) placeholder:Custing(@"请输入验证码", nil) delegate:self font:Font_cellContent_16 textColor:[XBColorSupport supportScreenListColor]];
    self.verificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTF.tag = 2;
    self.verificationTF.delegate=self;
    [verifyBImage addSubview:self.verificationTF];
    

    self.verificationBtn = [GPUtils createButton:CGRectMake(WIDTH(verifyBImage)/3*2+8, 0, WIDTH(verifyBImage)/3-10, 40) action:@selector(VerificationRestCode:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"获取验证码", nil) font:Font_Same_14_20 color:Color_form_TextFieldBackgroundColor];
    [self.verificationBtn setBackgroundColor:[UIColor clearColor]];
    [verifyBImage addSubview:self.verificationBtn];
    
    self.nextBtn = [GPUtils createButton:CGRectMake(15,150, Main_Screen_Width-30, 44) action:@selector(relaySubmitNext:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"确定", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    self.nextBtn.layer.cornerRadius = 11.0f;
    [self.nextBtn setBackgroundColor:Color_Blue_Important_20];
    [self.verifyView addSubview:self.nextBtn];
    
}

-(void)relaySubmitNext:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.accountTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
    if ([self.status isEqualToString:@"phone"]) {
        if (self.accountTF.text.length != 11) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
            [self.accountTF becomeFirstResponder];
            return;
        }
        NSString *emailRegex = @"^1[0-9][0-9]{9}$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:self.accountTF.text]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
            return;
        }
        if (self.verificationTF.text.length ==0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入验证码", nil) duration:1.5];
            [self.verificationTF becomeFirstResponder];
            return;
        }
        if (self.verificationTF.text.length >6) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
            [self.verificationTF becomeFirstResponder];
            return;
        }
    }else{
        if (self.accountTF.text.length <6) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确格式邮箱", nil) duration:1.5];
            [self.accountTF becomeFirstResponder];
            return;
        }
        if (self.verificationTF.text.length ==0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入验证码", nil) duration:1.5];
            [self.verificationTF becomeFirstResponder];
            return;
        }
        if (self.verificationTF.text.length >6) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
            [self.verificationTF becomeFirstResponder];
            return;
        }
        
    }
    [self requestGetverifycode];
    
    
}

//获取验证码
-(void)VerificationRestCode:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.accountTF resignFirstResponder];
    if ([self.status isEqualToString:@"phone"]) {
        
        NSString *emailRegex = @"^1[0-9][0-9]{9}$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:self.accountTF.text]) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
            return;
        }
        
        if (self.accountTF.text.length != 11) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
            return;
        }else{
            
            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"你正在获取验证码" duration:1.5];
        }
        
        
    }else if([self.status isEqualToString:@"email"]) {
        
        if (self.accountTF.text.length ==0) {
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入邮箱", nil) duration:1.5];
            return;
        }
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:self.accountTF.text]) {//邮箱地址不正确吧？
            [[GPAlertView sharedAlertView] showAlertText:self WithText:@"输入邮箱信息不正确，请重新输入。"];
            return;
        }
        [[GPAlertView sharedAlertView] showAlertText:self WithText:@"你正在获取验证码" duration:1.5];
        
    }
    [self requestMobileAndEmail];
    self.count = COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(restMinCount:) userInfo:nil repeats:YES];
//    self.photoTF.userInteractionEnabled = NO;
    self.verificationBtn.userInteractionEnabled = NO;
    self.canGetCheckcode = FcanGetCheckcode_no;
    [self.timer fire];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
        case 0:
        {
            if ([self.status isEqualToString:@"phone"]) {
                if (textField.text.length >= 11 && string.length>0) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号不超过11位", nil)];
                    return NO;
                    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
                    NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
                    return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
                }
            }else{
                if (textField.text.length >= 50 && string.length>0) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:@"邮箱号不超过50位"];
                    return NO;
                    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:EMAIL]invertedSet];
                    NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
                    return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
                }
                
            }
            
            
        }
            break;
        case 1:
        {
            if (textField.text.length >= 4 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"验证码不超过4位", nil)];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
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
        case 2:
        {
            if (textField.text.length >= 6 && string.length>0)
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"验证码不超过6位", nil)];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
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
        case 3:
        {
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORDLIMIT]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
//                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"密码只能由数字和字母组合！", nil)];
                return NO;
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.photoTF resignFirstResponder];
    [self.accountTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}

-(void)restMinCount:(NSTimer*)timer
{   self.count--;
    
    //    NSLog(@"%lu",(unsigned long)self.count);
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"%lu s",(unsigned long)self.count] forState:UIControlStateNormal];
    self.verificationBtn.showsTouchWhenHighlighted = YES;
    
    if (self.count<=0) {
        [timer invalidate];
        self.canGetCheckcode = canGetCheckcode_yes;
        self.count = COUNT;
        [self.verificationBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
        self.verificationBtn.userInteractionEnabled = YES;
//        self.photoTF.userInteractionEnabled = YES;
    }
}

#pragma mark - 验证手机号、邮箱
-(void)requestMobileAndEmail{
    
    NSDictionary * parametersDic = @{@"UserAccount":[NSString stringWithFormat:@"%@",self.accountTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_UptPhoneVerifyCode Parameters:parametersDic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

#pragma mark - 下一步
-(void)requestGetverifycode{
    
    NSString * str;
    if ([self.status isEqualToString:@"phone"]) {
        str = XB_UptMobile;
    }else{
        str = XB_UptEmail;
    }
    NSDictionary * paramettersDic = @{@"Account":[NSString stringWithFormat:@"%@",self.accountTF.text],@"VerifyCode":[NSString stringWithFormat:@"%@",self.verificationTF.text]};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",str] Parameters:paramettersDic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

#pragma mark - 修改姓名
-(void)modifyName:(UIButton *)btn{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.nameTF resignFirstResponder];
    if (self.nameTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入姓名", nil) duration:1.5];
        return;
    }
    NSString * nameS = [NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"userDspName"]];
    
    if ([self.nameTF.text isEqualToString:nameS]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入不同姓名",nil) duration:1.5];
        return;
    }
    
    NSDictionary *dic = @{@"UserDspName":self.nameTF.text,@"Gender":[NSString stringWithFormat:@"%@",[self.personDic objectForKey:@"gender"]]};
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",XB_UptUserName] Parameters:dic Delegate:self SerialNum:5 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    [YXSpritesLoadingView dismiss];

    if (serialNum ==0) {
        if ([success isEqualToString:@"0"]) {
            
            [self.timer invalidate];
            self.timer = nil;
            [self.verificationBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
            
            if ([self.status isEqualToString:@"phone"]) {
                self.verificationBtn.userInteractionEnabled = YES;
            }else{
                self.verificationBtn.userInteractionEnabled = YES;
            }
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
    }
    if (serialNum ==1) {
        if ([success isEqualToString:@"0"]) {
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self pushLoginViewController];
        });
    }
    if (serialNum == 5) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self pushLoginViewController];
        });
    }
    switch (serialNum) {
        case 0://
            
            break;
        case 1://
            if ([self.status isEqualToString:@"phone"]) {
                self.userdatas.RefreshStr = @"YES";
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"手机验证成功", nil) duration:2.0];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:@"邮箱验证成功" duration:2.0];
            }
            [self.timer invalidate];
            self.timer = nil;
            
            break;
        case 5:
            self.userdatas.RefreshStr = @"YES";
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"修改姓名成功", nil) duration:2.0];

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
