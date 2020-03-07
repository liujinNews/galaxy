//
//  createNewCompanyViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "MainLoginViewController.h"

#import "reimProtelViewController.h"
#import "createSuccessViewController.h"
#import "createNewCompanyViewController.h"

@interface createNewCompanyViewController ()<GPClientDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSDictionary * companyDic;
@property(nonatomic,strong)UIView * mainView;

@property(nonatomic,strong)UITextField * comNameTF;
@property(nonatomic,strong)UITextField * founderTF;
@property(nonatomic,strong)UITextField * passwordTF;
@property(nonatomic,strong)UITextField * apasswordATF;

@property(nonatomic,strong)NSString * corpId;

@end

@implementation createNewCompanyViewController

-(id)initWithType:(NSString *)type can:(NSDictionary *)canDic{
    self = [super init];
    if (self) {
        self.status = type;
        self.companyDic = canDic;
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
    if ([self.status isEqualToString:@"jiaruNEW"]) {
        [self setTitle:Custing(@"加入已有企业", nil) backButton:YES];
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        [self setTitle:Custing(@"设置新密码", nil) backButton:YES];
    }else if ([self.status isEqualToString:@"login"]) {
        [self setTitle:Custing(@"完善信息", nil) backButton:YES];
    }
    else {
        [self setTitle:Custing(@"创建新企业", nil) backButton:YES];
    }
    
    [self createJoinCompanyView];
    // Do any additional setup after loading the view.
}

-(void)createJoinCompanyView{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    NSInteger height = 350;
    NSInteger top = 10;

    if (![self.status isEqualToString:@"lostPassword"]&&![self.status isEqualToString:@"login"]) {
        top = 25;
        UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2.5, 25)];
        blueView.backgroundColor = Color_Blue_Important_20;
        [self.view addSubview:blueView];
        
        UILabel * comNaLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width - 30, 25) text:Custing(@"完善信息", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        comNaLa.backgroundColor = [UIColor clearColor];
        [self.view addSubview:comNaLa];
        
    }
    
   
    
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, top, ScreenRect.size.width,height)];
    self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.mainView ];
    
    
    NSArray * numArr;
    if ([self.status isEqualToString:@"105"]) {//没名字、密码
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"},
                   @{@"height":@"55"},
                   @{@"height":@"60"}];
    }else if ([self.status isEqualToString:@"103"]) {//有名字、没密码
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"},
                   @{@"height":@"55"},
                   @{@"height":@"62.5"}];
    }else if ([self.status isEqualToString:@"102"]) {//没名字、有密码
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"}];
    }else if ([self.status isEqualToString:@"101"]) {//有名字、密码
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"}];
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"},
                   @{@"height":@"62.5"}];
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"72.5"}];
    }else if ([self.status isEqualToString:@"login"]) {
        numArr = @[
                   @{@"height":@"55"},
                   @{@"height":@"55"}];
    }
    
    for (int j = 0 ; j < [numArr count] ; j ++ ) {
        NSInteger heightCell = [[[numArr objectAtIndex:j] objectForKey:@"height"] integerValue];

        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, j*heightCell, WIDTH(self.mainView), 45)];
        whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.mainView  addSubview:whiteView];
        
    }
    
   
    self.comNameTF = [GPUtils createTextField:CGRectMake(15, 0, WIDTH(self.mainView)-30, 45) placeholder:Custing(@"请输入企业名称", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.comNameTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.comNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.comNameTF.keyboardType = UIKeyboardTypeDefault;
    self.comNameTF.tag = 0;
    self.comNameTF.delegate = self;
    [self.mainView addSubview:self.comNameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editCompanyNameTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.comNameTF];
    
    
    self.founderTF = [GPUtils createTextField:CGRectMake(15, 55, WIDTH(self.mainView)-30, 45) placeholder:Custing(@"请输入真实姓名", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.founderTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.founderTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.founderTF.tag = 1;
    self.founderTF.delegate=self;
    self.founderTF.keyboardType = UIKeyboardTypeDefault;
    [self.mainView addSubview:self.founderTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editFounderTextFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.founderTF];
    
    self.passwordTF = [GPUtils createTextField:CGRectMake(15, 110, WIDTH(self.mainView)-30, 45) placeholder:Custing(@"设置登录密码", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordTF.tag = 3;
    self.passwordTF.delegate=self;
    [self.mainView addSubview:self.passwordTF];
    
    UILabel * serectLa = [GPUtils createLable:CGRectMake(15, 155, Main_Screen_Width - 30, 25) text:Custing(@"密码6-16位，必须字母和数字", nil) font:Font_Same_12_20 textColor:RGB(195, 195, 202) textAlignment:NSTextAlignmentLeft];
    serectLa.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:serectLa];
    
    self.apasswordATF = [GPUtils createTextField:CGRectMake(15, 180, WIDTH(self.mainView)-30, 45) placeholder:Custing(@"确认密码", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.apasswordATF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.apasswordATF.tag = 5;
    self.apasswordATF.delegate=self;
    self.apasswordATF.secureTextEntry = YES;
    self.apasswordATF.keyboardType = UIKeyboardTypeEmailAddress;
    [self.mainView addSubview:self.apasswordATF];
    
    
    //按钮1
    UIButton * nextBtn = [GPUtils createButton:CGRectMake(15, 255, Main_Screen_Width-30, 45) action:@selector(finishCreateNewCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"完成", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [nextBtn setBackgroundColor:Color_Blue_Important_20];
    nextBtn.layer.cornerRadius = 11.0f;
    [self.mainView addSubview:nextBtn];
    
    //报销协议
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    NSString * reiment = Custing(@"注册即同意 《喜报服务协议》", nil);
    NSMutableAttributedString * allStr = [[NSMutableAttributedString alloc]initWithString:reiment];
    [allStr addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, ((lan)?6:23))];
    [allStr addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(((lan)?6:23), allStr.length - ((lan)?6:23))];
    
    [allStr addAttribute:NSFontAttributeName value:Font_Same_14_20 range:NSMakeRange(0, allStr.length)];
    
    UILabel * proteLa = [GPUtils createLable:CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+10, Main_Screen_Width - 30, 50) text:@"" font:Font_Same_12_20 textColor:RGB(195, 195, 202) textAlignment:NSTextAlignmentCenter];
    proteLa.backgroundColor = [UIColor clearColor];
    proteLa.numberOfLines = 0;
    [self.mainView addSubview:proteLa];
    [proteLa setAttributedText:allStr];
    
    UIButton * protelBtn = [GPUtils createButton:CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+20, Main_Screen_Width - 30, 30) action:@selector(RegisterReimbursementProtel:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:@"" font:Font_Same_14_20 color:Color_Blue_Important_20];
    [protelBtn setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:protelBtn];
    
    if ([self.status isEqualToString:@"105"]||[self.status isEqualToString:@"103"]) {//没名字、密码
        
    }
//    else if ([self.status isEqualToString:@"103"]) {//有名字、没密码
//        self.founderTF.hidden = YES;
//        self.passwordTF.frame = CGRectMake(15, 55, WIDTH(self.mainView)-30, 45);
//        serectLa.frame = CGRectMake(15, 100, Main_Screen_Width - 30, 25);
//        self.apasswordATF.frame = CGRectMake(15, 125, WIDTH(self.mainView)-30, 45);
//        nextBtn.frame = CGRectMake(15, 200, Main_Screen_Width-30, 45);
//        
//    }
    else if ([self.status isEqualToString:@"102"]) {//没名字、有密码
        self.passwordTF.hidden = YES;
        serectLa.hidden = YES;
        self.apasswordATF.hidden = YES;
        nextBtn.frame = CGRectMake(15, 125, Main_Screen_Width-30, 45);
        proteLa.frame = CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+10, Main_Screen_Width - 30, 50);
        protelBtn.frame = CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+20, Main_Screen_Width - 30, 30);
        
    }else if ([self.status isEqualToString:@"101"]) {//有名字、密码
        self.passwordTF.hidden = YES;
        serectLa.hidden = YES;
        self.apasswordATF.hidden = YES;
        nextBtn.frame = CGRectMake(15, 125, Main_Screen_Width-30, 45);
        proteLa.frame = CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+10, Main_Screen_Width - 30, 50);
        protelBtn.frame = CGRectMake(15, Y(nextBtn)+HEIGHT(nextBtn)+20, Main_Screen_Width - 30, 30);
        
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        protelBtn.hidden = YES;
        self.comNameTF.hidden = YES;
        self.founderTF.frame = CGRectMake(15, 0, WIDTH(self.mainView)-30, 45);
        self.passwordTF.frame = CGRectMake(15, 55, WIDTH(self.mainView)-30, 45);
        serectLa.frame = CGRectMake(15, 100, Main_Screen_Width - 30, 25);
        self.apasswordATF.frame = CGRectMake(15, 125, WIDTH(self.mainView)-30, 45);
        nextBtn.frame = CGRectMake(15, 200, Main_Screen_Width-30, 45);
        proteLa.hidden = YES;
        protelBtn.hidden = YES;
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        protelBtn.hidden = YES;
        self.comNameTF.hidden = YES;
        self.founderTF.hidden = YES;
        self.passwordTF.placeholder = Custing(@"新密码", nil);
        self.passwordTF.frame = CGRectMake(15, 0, WIDTH(self.mainView)-30, 45);
        serectLa.frame = CGRectMake(15, 45, Main_Screen_Width - 30, 25);
        self.apasswordATF.placeholder = Custing(@"确认新密码", nil);
        self.apasswordATF.frame = CGRectMake(15, 72.5, WIDTH(self.mainView)-30, 45);
        [nextBtn setTitle:Custing(@"进入喜报", nil) forState:UIControlStateNormal];
        [nextBtn setTitle:Custing(@"进入喜报", nil) forState:UIControlStateHighlighted];
        nextBtn.frame = CGRectMake(15, 135, Main_Screen_Width-30, 45);
        proteLa.hidden = YES;
        protelBtn.hidden = YES;

    }else if ([self.status isEqualToString:@"login"]) {
        self.passwordTF.hidden = YES;
        serectLa.hidden = YES;
        self.apasswordATF.hidden = YES;
        nextBtn.frame = CGRectMake(15, 125, Main_Screen_Width-30, 45);
        [nextBtn setTitle:Custing(@"下一步", nil) forState:UIControlStateNormal];
        [nextBtn setTitle:Custing(@"下一步", nil) forState:UIControlStateHighlighted];
        proteLa.hidden = YES;
        protelBtn.hidden = YES;
    }
    
}

//创建成功or加入成功
-(void)pushCreateNewCompamySuccess {
    NSDictionary * dica;
    if ([self.status isEqualToString:@"jiaruNEW"]) {
        dica = @{@"Source":[NSString isEqualToNull:[self.companyDic objectForKey:@"Source"]] ? [self.companyDic objectForKey:@"Source"] : @"",@"CoCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"CoCode"]] ? [self.companyDic objectForKey:@"CoCode"] : @"",@"companyName":[NSString isEqualToNull:[self.companyDic objectForKey:@"companyName"]] ? [self.companyDic objectForKey:@"companyName"] : @"",@"companyContact":[NSString isEqualToNull:self.founderTF.text] ?self.founderTF.text : @"",@"Account":[NSString isEqualToNull:[self.companyDic objectForKey:@"Account"]] ? [self.companyDic objectForKey:@"Account"] : @"",@"VerifyCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"VerifyCode"]] ? [self.companyDic objectForKey:@"VerifyCode"] :@"",@"Password":[NSString isEqualToNull:self.passwordTF.text] ?self.passwordTF.text : @""};
    }else if ([self.status isEqualToString:@"login"]) {
        dica = @{@"Source":@"",@"CoCode":@"",@"companyName":[NSString isEqualToNull:self.comNameTF.text] ? self.comNameTF.text : @"",@"companyContact":[NSString isEqualToNull:self.founderTF.text] ?self.founderTF.text : @"",@"Account":[NSString isEqualToNull:self.userdatas.logName] ? self.userdatas.logName : @"",@"VerifyCode":@"",@"Password":[NSString isEqualToNull:self.userdatas.password] ?self.userdatas.password : @"",@"corpId":[NSString isEqualToNull:self.userdatas.companyId] ? self.userdatas.companyId :@""};
    }
    else {
        dica = @{@"Source":[NSString isEqualToNull:[self.companyDic objectForKey:@"Source"]] ? [self.companyDic objectForKey:@"Source"] : @"",@"CoCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"CoCode"]] ? [self.companyDic objectForKey:@"CoCode"] : @"",@"companyName":[NSString isEqualToNull:self.comNameTF.text] ? self.comNameTF.text : @"",@"companyContact":[NSString isEqualToNull:self.founderTF.text] ?self.founderTF.text : @"",@"Account":[NSString isEqualToNull:[self.companyDic objectForKey:@"Account"]] ? [self.companyDic objectForKey:@"Account"] : @"",@"VerifyCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"VerifyCode"]] ? [self.companyDic objectForKey:@"VerifyCode"] :@"",@"Password":[NSString isEqualToNull:self.passwordTF.text] ?self.passwordTF.text : @"",@"corpId":[NSString isEqualToNull:self.corpId] ? self.corpId :@""};
    }
    createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:self.status can:dica];
    [self.navigationController pushViewController:success animated:YES];
}

//完成创建新企业
-(void)finishCreateNewCompany:(UIButton *)btn {
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.comNameTF resignFirstResponder];
    [self.founderTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.apasswordATF resignFirstResponder];
    
    //密码必须要有字母加数字
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{0,50}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([self.status isEqualToString:@"105"]) {//没名字、密码
        if (self.comNameTF.text.length ==0) {
            [self isComNameNull];
            return;
        }
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
        //判断密码
        if (self.passwordTF.text.length ==0) {
            [self isPasswordNull];
            return;
        }
        if (self.passwordTF.text.length<6||self.passwordTF.text.length>16) {
            [self isPasswordListSixOr];
            return;
        }
        if (![pred evaluateWithObject:self.passwordTF.text]) {
            [self isPasswordRegexPred];
            return;
        }
        if (![self.apasswordATF.text isEqual:self.passwordTF.text]) {
            [self isPasswordSame];
            return;
        }
        
    }else if ([self.status isEqualToString:@"103"]) {//有名字、没密码
        if (self.comNameTF.text.length ==0) {
            [self isComNameNull];
            return;
        }
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
        //判断密码
        if (self.passwordTF.text.length ==0) {
            [self isPasswordNull];
            return;
        }
        if (self.passwordTF.text.length<6||self.passwordTF.text.length>16) {
            [self isPasswordListSixOr];
            return;
        }
        if (![pred evaluateWithObject:self.passwordTF.text]) {
            [self isPasswordRegexPred];
            return;
        }
        if (![self.apasswordATF.text isEqual:self.passwordTF.text]) {
            [self isPasswordSame];
            return;
        }
    }else if ([self.status isEqualToString:@"102"]) {//没名字、有密码
        if (self.comNameTF.text.length ==0) {
            [self isComNameNull];
            return;
        }
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
        
    }else if ([self.status isEqualToString:@"101"]) {//有名字、密码
        if (self.comNameTF.text.length ==0) {
            [self isComNameNull];
            return;
        }
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
        
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
        //判断密码
        if (self.passwordTF.text.length ==0) {
            [self isPasswordNull];
            return;
        }
        if (self.passwordTF.text.length<6||self.passwordTF.text.length>16) {
            [self isPasswordListSixOr];
            return;
        }
        if (![pred evaluateWithObject:self.passwordTF.text]) {
            [self isPasswordRegexPred];
            return;
        }
        if (![self.apasswordATF.text isEqual:self.passwordTF.text]) {
            [self isPasswordSame];
            return;
        }
        
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        //判断密码
        if (self.passwordTF.text.length ==0) {
            [self isPasswordNull];
            return;
        }
        if (self.passwordTF.text.length<6||self.passwordTF.text.length>16) {
            [self isPasswordListSixOr];
            return;
        }
        if (![pred evaluateWithObject:self.passwordTF.text]) {
            [self isPasswordRegexPred];
            return;
        }
        if (![self.apasswordATF.text isEqual:self.passwordTF.text]) {
            [self isPasswordSame];
            return;
        }
        
    }else if ([self.status isEqualToString:@"login"]) {
        if (self.comNameTF.text.length ==0) {
            [self isComNameNull];
            return;
        }
        if (self.founderTF.text.length ==0) {
            [self isFounderNull];
            return;
        }
    }
    [self requestRegisterCompanyInfo];
    
}


-(void)RegisterReimbursementProtel:(id)btn{
    //报销协议文本
    reimProtelViewController * reim = [[reimProtelViewController alloc]initWithType:@""];
    [self.navigationController pushViewController:reim animated:YES];
    
}

-(void)editCompanyNameTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不超过20位", nil)];
        }
    }
    
}

-(void)editFounderTextFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过20位", nil)];
            }
            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过20位", nil)];
        }
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.comNameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.founderTF];
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    
    switch (textField.tag) {
//        case 1:
//            if (textField.text.length > 50) {
//                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不超过50位", nil)];
//                return NO;
//            }
//            break;
//        case 2:
//            if (textField.text.length > 50) {
//                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不超过50位", nil)];
//                return NO;
//            }
//            break;
        case 3:
        {
            if (textField.text.length >= 16 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@6-16%@",Custing(@"请输入正确的密码，必须字母与数字，长度在", nil),Custing(@"位之间！", nil)]];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORDLIMIT]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"密码只能由数字和字母组合！", nil)];
                return NO;
            }
        }
            break;
        case 5:
        {
            if (textField.text.length >= 16 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@6-16%@",Custing(@"请输入正确的密码，必须字母与数字，长度在", nil),Custing(@"位之间！", nil)]];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:PASSWORDLIMIT]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            if ([string isEqualToString:[arrayTemp componentsJoinedByString:@""]]) {
                return YES;
            }
            else
            {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"密码只能由数字和字母组合！", nil)];
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
    [self.comNameTF    resignFirstResponder];
    [self.founderTF    resignFirstResponder];
    [self.passwordTF   resignFirstResponder];
    [self.apasswordATF resignFirstResponder];
}

-(void)isComNameNull {
    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"公司名不能为空", nil) duration:1.5];
    [self.comNameTF becomeFirstResponder];
}

-(void)isFounderNull {
    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"姓名不能为空", nil) duration:1.5];
    [self.founderTF becomeFirstResponder];
}

//判断密码
-(void)isPasswordNull {
    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入密码", nil) duration:1.5];
    [self.passwordTF becomeFirstResponder];
}

-(void)isPasswordListSixOr {
    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@6-16%@",Custing(@"请输入正确的密码，必须字母与数字，长度在", nil),Custing(@"位之间！", nil)] duration:1.5];
    [self.passwordTF becomeFirstResponder];
}

-(void)isPasswordRegexPred {
    [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"您设置的密码太简单", nil) duration:1.5];
    [self.passwordTF becomeFirstResponder];
}

-(void)isPasswordSame {
    if (![self.apasswordATF.text isEqual:self.passwordTF.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"两次输入密码不一样", nil) duration:1.5];
        [self.apasswordATF becomeFirstResponder];
        return;
    }
}


//请求注册创建新公司
-(void)requestRegisterCompanyInfo {
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
    if (![self.status isEqualToString:@"login"]) {
        self.userdatas = [userData shareUserData];
        self.userdatas.logName = [self.companyDic objectForKey:@"Account"];
        self.userdatas.password = [NSString isEqualToNull:self.passwordTF.text] ? self.passwordTF.text: @"";
        [self.userdatas storeUserInfo];
    }
    
    if ([self.status isEqualToString:@"103"]||[self.status isEqualToString:@"105"]) {
        NSDictionary * parametersDic = @{@"Account":[self.companyDic objectForKey:@"Account"],@"VerifyCode":[self.companyDic objectForKey:@"VerifyCode"],@"Password":[NSString isEqualToNull:self.passwordTF.text] ? self.passwordTF.text: @"",@"Language":[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en",@"Name":[NSString isEqualToNull:self.founderTF.text] ? self.founderTF.text: @"",@"CompanyName":[NSString isEqualToNull:self.comNameTF.text] ? self.comNameTF.text: @""};
        [[GPClient shareGPClient]REquestByPostWithPath:XB_Regist Parameters:parametersDic Delegate:self SerialNum:0 IfUserCache:NO];
    }if ([self.status isEqualToString:@"jiaruNEW"]) {
       
        [[GPClient shareGPClient]REquestByPostWithPath:XB_JoinCorp Parameters:@{@"Account":[self.companyDic objectForKey:@"Account"],@"Name":[NSString isEqualToNull:self.founderTF.text] ? self.founderTF.text: @"",@"Password":[NSString isEqualToNull:self.passwordTF.text] ? self.passwordTF.text: @"",@"CoCode":[NSString stringWithFormat:@"%@",[self.companyDic objectForKey:@"CoCode"]]} Delegate:self SerialNum:3 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        
        [[GPClient shareGPClient]REquestByPostWithPath:XB_FindPaw Parameters:@{@"Account":[self.companyDic objectForKey:@"Account"],@"VerifyCode":[self.companyDic objectForKey:@"VerifyCode"],@"Password": [NSString stringWithFormat:@"%@",self.passwordTF.text],@"Language":[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en"} Delegate:self SerialNum:1 IfUserCache:NO];
        
    }else if ([self.status isEqualToString:@"login"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:XB_UptCorpInfo Parameters:@{@"CompanyName":self.comNameTF.text,@"CompanyContact":self.founderTF.text} Delegate:self SerialNum:0 IfUserCache:NO];
    }
    else if ([self.status isEqualToString:@"102"]||[self.status isEqualToString:@"101"]) {
        NSDictionary * parametersDic = @{@"Mobile":[self.companyDic objectForKey:@"Account"],@"VerifyCode":[self.companyDic objectForKey:@"VerifyCode"],@"CompanyContact":[NSString isEqualToNull:self.founderTF.text] ? self.founderTF.text: @"",@"CompanyName":[NSString isEqualToNull:self.comNameTF.text] ? self.comNameTF.text: @""};
        [[GPClient shareGPClient]REquestByPostWithPath:XB_CreateCorp Parameters:parametersDic Delegate:self SerialNum:0 IfUserCache:NO];
    }

    
    
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    [YXSpritesLoadingView dismiss];
    if (serialNum !=3) {
        if ([success isEqualToString:@"0"]) {
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            
            return;
        }
    }else {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            if ([error isEqualToString:@"等待管理员同意加入公司"]) {
                createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":[NSString isEqualToNull:[self.companyDic objectForKey:@"Source"]] ? [self.companyDic objectForKey:@"Source"] : @"",@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":[NSString isEqualToNull:[self.companyDic objectForKey:@"Account"]] ? [self.companyDic objectForKey:@"Account"] : @"",@"VerifyCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"VerifyCode"]] ? [self.companyDic objectForKey:@"VerifyCode"] : @"",@"Password":@""}];
                
                [self.navigationController pushViewController:success animated:YES];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
                return;
            }
            
        }else {
            createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":[NSString isEqualToNull:[self.companyDic objectForKey:@"Source"]] ? [self.companyDic objectForKey:@"Source"] : @"",@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":[NSString isEqualToNull:[self.companyDic objectForKey:@"Account"]] ? [self.companyDic objectForKey:@"Account"] : @"",@"VerifyCode":[NSString isEqualToNull:[self.companyDic objectForKey:@"VerifyCode"]] ? [self.companyDic objectForKey:@"VerifyCode"] : @"",@"Password":@""}];
            
            [self.navigationController pushViewController:success animated:YES];
        }
    }
    
    
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (serialNum ==0) {
            [self pushCreateNewCompamySuccess];
            
        }else if (serialNum == 1) {
            MainLoginViewController * main = [[MainLoginViewController alloc]init];
            [self.navigationController pushViewController:main animated:YES];
        }
        
    });
    switch (serialNum) {
        case 0://
            if ([self.status isEqualToString:@"103"]||[self.status isEqualToString:@"105"]) {
                NSDictionary * result = [responceDic objectForKey:@"result"];
                if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
                    
                    }else{
                        self.corpId = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyId"]];//是否有姓名
                    }
                
            }else {
                self.corpId = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]];//是否有姓名
            }
            
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"注册成功", nil) duration:2.0];
            break;
        case 1://
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"找回密码成功", nil) duration:2.0];
            break;
        case 3:
            
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
