//
//  createJoinNuViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/11/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createNewCompanyViewController.h"

#import "createSuccessViewController.h"
#import "createNewCoListViewController.h"
#import "createNewCompanyViewController.h"
#import "GPVerification.h"
#import "createJoinCViewController.h"
#import "createJoinNuViewController.h"
#import "reimProtelViewController.h"

@interface createJoinNuViewController ()<UITextFieldDelegate,GPClientDelegate>
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)UIView * mainView;

@property(nonatomic,strong)UITextField * phoneTF;
@property(nonatomic,strong)UITextField * pictuTF;
@property(nonatomic,strong)UITextField * verifTF;
@property(nonatomic,strong)GPVerification * ChooseVerification;
@property(nonatomic,strong)UIButton * SMSBtn;

@property(assign,nonatomic) NSUInteger verificationCount;
@property(copy, nonatomic) NSString * canGetCheckcode;
@property(nonatomic,strong)NSString * isRightVerif;

@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)NSArray * CorpsArr;
@property(nonatomic,strong)NSDictionary * companyDic;
@property(nonatomic,strong)NSString * Source;


@end

@implementation createJoinNuViewController
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
    if ([self.status isEqualToString:@"zhuceNEW"]) {
        [self setTitle:Custing(@"注册新企业", nil) backButton:YES];
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        [self setTitle:Custing(@"加入已有企业", nil) backButton:YES];
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        [self setTitle:Custing(@"找回密码", nil) backButton:YES];
    }
    [self createJoinNumberView];
    // Do any additional setup after loading the view.
}

-(void)createJoinNumberView {
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    NSInteger height = 300;
    NSInteger top = 10;
    if ([self.status isEqualToString:@"zhuceNEW"]) {
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        UILabel * comNaLa = [GPUtils createLable:CGRectMake(15, 0, Main_Screen_Width - 30, 39) text:[NSString isEqualToNull:[self.companyDic objectForKey:@"companyName"]] ? [self.companyDic objectForKey:@"companyName"]: @"" font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        comNaLa.backgroundColor = [UIColor clearColor];
        comNaLa.numberOfLines = 0;
        [self.view addSubview:comNaLa];
        top = 39;
    }else if ([self.status isEqualToString:@"lostPassword"]) {
    }
    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, top, ScreenRect.size.width,height)];
    self.mainView .backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.mainView ];

    NSArray * numArr = @[
                         @{@"image":@"login_phone"},
                         @{@"image":@"login_info"},
                         @{@"image":@"login_info"}];
    
    for (int j = 0 ; j < [numArr count] ; j ++ ) {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55, WIDTH(self.mainView), 45)];
        whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.mainView  addSubview:whiteView];
        
    }
    
    //手机号
    self.phoneTF = [GPUtils createTextField:CGRectMake(15, 0, Main_Screen_Width-30, 45) placeholder:Custing(@"请输入手机号", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.phoneTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.phoneTF.tag = 0;
    self.phoneTF.delegate=self;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.mainView addSubview:self.phoneTF];
    
    if ([self.status isEqualToString:@"lostPassword"]) {
        if ([NSString isEqualToNull:[self.companyDic objectForKey:@"Account"]]) {
            self.phoneTF.text = [self.companyDic objectForKey:@"Account"];
        }
    }
    
    //数字
    self.pictuTF = [GPUtils createTextField:CGRectMake(15, 55, Main_Screen_Width-155, 45) placeholder:Custing(@"请输入图形验证码", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.pictuTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.pictuTF.keyboardType = UIKeyboardTypeNumberPad;
    self.pictuTF.tag = 1;
    self.pictuTF.delegate = self;
    [self.pictuTF addTarget:self action:@selector(PictuTextFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.mainView addSubview:self.pictuTF];
    
    self.ChooseVerification = [[GPVerification alloc]initWithFrame:CGRectMake(Main_Screen_Width-140, 55,140, 45)];
    [self.mainView addSubview:self.ChooseVerification];
    
    
    //数字1
    self.verifTF = [GPUtils createTextField:CGRectMake(15, 110, Main_Screen_Width-155, 45) placeholder:Custing(@"请输入短信验证码", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
    self.verifTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.verifTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verifTF.tag = 2;
    self.verifTF.delegate=self;
    [self.mainView addSubview:self.verifTF];
    
    self.SMSBtn = [GPUtils createButton:CGRectMake(Main_Screen_Width-140, 110, 140, 45) action:@selector(haveSMSCode:) delegate:self title:Custing(@"获取验证码", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    [self.SMSBtn setBackgroundColor:Color_Orange_Weak_20];
    [self.mainView addSubview:self.SMSBtn];
    
    self.SMSBtn.userInteractionEnabled = NO;
    
    //按钮1
    UIButton * nextBtn = [GPUtils createButton:CGRectMake(15, 190, Main_Screen_Width-30, 45) action:@selector(submitPassword:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"下一步", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
    [nextBtn setBackgroundColor:Color_Blue_Important_20];
    nextBtn.layer.cornerRadius = 11.0f;
    [self.mainView addSubview:nextBtn];
    
    if ([self.status isEqualToString:@"zhuceNEW"]) {
        //按钮2
        UIButton * jiaBtn = [GPUtils createButton:CGRectMake(15, 251, Main_Screen_Width-30, 45) action:@selector(pushJoinHaveCompany:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"加入已有企业", nil) font:Font_Important_15_20 color:Color_Blue_Important_20];
        [jiaBtn setBackgroundColor:[UIColor clearColor]];
        jiaBtn.layer.cornerRadius = 11.0f;
        jiaBtn.layer.borderWidth = 1.0;
        jiaBtn.layer.borderColor = Color_Blue_Important_20.CGColor;
        [self.mainView addSubview:jiaBtn];
    }
    
    //报销协议
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    NSString * reiment = Custing(@"注册即同意 《喜报服务协议》", nil);
    NSMutableAttributedString * allStr = [[NSMutableAttributedString alloc]initWithString:reiment];
    [allStr addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, ((lan)?6:23))];
    [allStr addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(((lan)?6:23), allStr.length - ((lan)?6:23))];
    [allStr addAttribute:NSFontAttributeName value:Font_Same_14_20 range:NSMakeRange(0, allStr.length)];
    
    UILabel * proteLa = [GPUtils createLable:CGRectMake(15, 300+20, Main_Screen_Width - 30, 50) text:@"" font:Font_Same_12_20 textColor:RGB(195, 195, 202) textAlignment:NSTextAlignmentCenter];
    proteLa.backgroundColor = [UIColor clearColor];
    proteLa.numberOfLines = 0;
    [self.mainView addSubview:proteLa];
    [proteLa setAttributedText:allStr];
    
    UIButton * protelBtn = [GPUtils createButton:CGRectMake(15,300+20, Main_Screen_Width - 30, 50) action:@selector(RegisterReimbursementProtel:) delegate:self ];
    [protelBtn setBackgroundColor:[UIColor clearColor]];
    protelBtn.userInteractionEnabled = YES;
    [self.view addSubview:protelBtn];
    
}

//获取验证码
-(void)requestGetregcode{
    if ([self.status isEqualToString:@"lostPassword"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:XB_FindPawCode Parameters:@{@"Account":[NSString stringWithFormat:@"%@",self.phoneTF.text]} Delegate:self SerialNum:0 IfUserCache:NO];
    }else {
        [[GPClient shareGPClient]REquestByPostWithPath:XB_RegistCode Parameters:@{@"Account":[NSString stringWithFormat:@"%@",self.phoneTF.text]} Delegate:self SerialNum:0 IfUserCache:NO];
    }
    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

-(void)RegisterReimbursementProtel:(id)btn{
    //报销协议文本
    reimProtelViewController * reim = [[reimProtelViewController alloc]initWithType:@""];
    [self.navigationController pushViewController:reim animated:YES];
    
}

////创建新企业
-(void)requestAccountAndCheckVerify{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];

    if ([self.status isEqualToString:@"zhuceNEW"]) {
         [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"account/CheckRegCode"] Parameters:@{@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text} Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"jiaruNEW"]) {
        [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"account/CheckJoinCode"] Parameters:@{@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text} Delegate:self SerialNum:1 IfUserCache:NO];
    }else if ([self.status isEqualToString:@"lostPassword"]) {
        [YXSpritesLoadingView dismiss];
        createNewCompanyViewController * create = [[createNewCompanyViewController alloc]initWithType:@"lostPassword" can:@{@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text}];
        [self.navigationController pushViewController:create animated:YES];
    }
    
}

-(void)requestJoinXianYouCompany {
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
     [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"account/Join"] Parameters:@{@"Account":self.phoneTF.text,@"Name":@"",@"Password":@"",@"CoCode":[NSString stringWithFormat:@"%@",[self.companyDic objectForKey:@"CoCode"]]} Delegate:self SerialNum:2 IfUserCache:NO];
}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    [YXSpritesLoadingView dismiss];
    if (serialNum != 2) {
        if ([success isEqualToString:@"0"]) {
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            if (serialNum ==0) {
                [self.timer invalidate];
                self.timer = nil;
                [self.SMSBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
                [self.SMSBtn setBackgroundColor:Color_Orange_Weak_20];
                self.SMSBtn.userInteractionEnabled = YES;
                self.pictuTF.userInteractionEnabled = YES;
            }
            return;
        }else {
            self.verificationCount = COUNT;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerMinCount:) userInfo:nil repeats:YES];
            self.SMSBtn.userInteractionEnabled = NO;
            self.pictuTF.userInteractionEnabled = NO;
            [self.SMSBtn setBackgroundColor:Color_Blue_Important_20];
            self.canGetCheckcode = FcanGetCheckcode_no;
            [self.timer fire];
        }
    }
   
    
    if (serialNum == 1) {//创建新企业
        if ([self.status isEqualToString:@"zhuceNEW"]) {
            NSString * isStr;
            
            NSArray * Corps = [[responceDic objectForKey:@"result"] objectForKey:@"corps"];//公司列表
            NSString * HasName = [NSString stringWithFormat:@"%@",[[responceDic objectForKey:@"result"] objectForKey:@"hasName"]];//是否有姓名
            NSString * HasPwd = [NSString stringWithFormat:@"%@",[[responceDic objectForKey:@"result"] objectForKey:@"hasPwd"]];//是否有密码
            
            if ([Corps isKindOfClass:[NSNull class]] || Corps == nil|| Corps.count == 0||!Corps){
                if ([HasName isEqualToString:@"1"]&&[HasPwd isEqualToString:@"1"]) {
                    isStr = @"101";
                }else if (![HasName isEqualToString:@"1"]&&[HasPwd isEqualToString:@"1"]) {
                    isStr = @"102";
                }else if ([HasName isEqualToString:@"1"]&&![HasPwd isEqualToString:@"1"]) {
                    isStr = @"103";
                }else if (![HasName isEqualToString:@"1"]&&![HasPwd isEqualToString:@"1"]) {
                    isStr = @"105";
                }
                self.CorpsArr = [NSMutableArray arrayWithArray:@[]];
                createNewCompanyViewController * create = [[createNewCompanyViewController alloc]initWithType:isStr can:@{@"Source":@"",@"CoCode":@"",@"companyName":@"",@"companyContact":@"",@"Password":@"",@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Corps":self.CorpsArr}];
                [self.navigationController pushViewController:create animated:YES];
            }else {
                self.CorpsArr = Corps;
                if ([HasName isEqualToString:@"1"]&&[HasPwd isEqualToString:@"1"]) {
                    isStr = @"101";
                }else if (![HasName isEqualToString:@"1"]&&[HasPwd isEqualToString:@"1"]) {
                    isStr = @"102";
                }else if ([HasName isEqualToString:@"1"]&&![HasPwd isEqualToString:@"1"]) {
                    isStr = @"103";
                }else if (![HasName isEqualToString:@"1"]&&![HasPwd isEqualToString:@"1"]) {
                    isStr = @"105";
                }
                createNewCoListViewController * create = [[createNewCoListViewController alloc]initWithType:isStr can:@{@"Source":@"",@"CoCode":@"",@"companyName":@"",@"companyContact":@"",@"Password":@"",@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Corps":self.CorpsArr}];
                [self.navigationController pushViewController:create animated:YES];
            }
        }else if ([self.status isEqualToString:@"jiaruNEW"]) {//加入已有企业
           
            self.Source = [NSString stringWithFormat:@"%@",[[responceDic objectForKey:@"result"] objectForKey:@"source"]];//是否有姓名
            NSString * HasPwd = [NSString stringWithFormat:@"%@",[[responceDic objectForKey:@"result"] objectForKey:@"hasPwd"]];//是否有密码
            
            
            if ([HasPwd isEqualToString:@"1"]&&[self.Source isEqualToString:@"1"]) {//有密码、邀请添加
                [self requestJoinXianYouCompany];
                
            }else if ([HasPwd isEqualToString:@"1"]&&[self.Source isEqualToString:@"2"]) {//有密码、管理员添加
                createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":self.Source,@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Password":@""}];
                
                [self.navigationController pushViewController:success animated:YES];
                
            }else if ([HasPwd isEqualToString:@"0"]) {//没有密码
                createNewCompanyViewController * success = [[createNewCompanyViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":self.Source,@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Password":@""}];
                
                [self.navigationController pushViewController:success animated:YES];
            }
           
            
        }

    }
    
    if (serialNum==2) {
        
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            if ([error isEqualToString:@"等待管理员同意加入公司"]) {
                createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":self.Source,@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Password":@""}];
                
                [self.navigationController pushViewController:success animated:YES];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
                return;
            }
            
        }else {
            createSuccessViewController * success = [[createSuccessViewController alloc]initWithType:@"jiaruNEW" can:@{@"Source":self.Source,@"CoCode":[self.companyDic objectForKey:@"CoCode"],@"companyName":[self.companyDic objectForKey:@"companyName"],@"companyContact":[self.companyDic objectForKey:@"companyContact"],@"Account":self.phoneTF.text,@"VerifyCode":self.verifTF.text,@"Password":@""}];
            
            [self.navigationController pushViewController:success animated:YES];
        }
        
    }

    
    self.isRightVerif = @"yes";
    switch (serialNum) {
        case 0://
            break;
        case 1://
            
            break;
        default:
            break;
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
    
}

//注册新企业内《加入已有企业》
-(void)pushJoinHaveCompany:(UIButton *)btn {
    createJoinCViewController * create = [[createJoinCViewController alloc]initWithType:@"jiaruHave"];
    [self.navigationController pushViewController:create animated:YES];
}


//下一步
-(void)submitPassword:(UIButton *)btn{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
   
    [self.phoneTF resignFirstResponder];
    [self.pictuTF resignFirstResponder];
    [self.verifTF  resignFirstResponder];
    
    if (self.phoneTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.5];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    if (self.phoneTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
        [self.phoneTF becomeFirstResponder];
        return;
    }
    NSString *emailRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.phoneTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
        return;
    }
    if (self.pictuTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入图形验证码", nil) duration:1.5];
        [self.pictuTF becomeFirstResponder];
        return;
    }
    if (self.pictuTF.text.length !=4) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的图形验证码", nil) duration:1.5];
        [self.pictuTF becomeFirstResponder];
        return;
    }
    if (self.verifTF.text.length ==0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入验证码", nil) duration:1.5];
        [self.verifTF becomeFirstResponder];
        return;
    }
    if (self.verifTF.text.length >6) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
        [self.verifTF becomeFirstResponder];
        return;
    }
    if ([self.isRightVerif isEqualToString:@"yes"]) {
         [self requestAccountAndCheckVerify];
        
    }else{
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的验证码", nil) duration:1.5];
        [self.verifTF becomeFirstResponder];
        return;
    }
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //不允许输入空格
    if ([string isEqual:@" "]) {
        return NO;
    }
    switch (textField.tag) {
        case 0:
        {
            if (textField.text.length >= 11 && string.length>0) {
                [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"手机号不超过11位", nil)];
                return NO;
            }
            NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:KALLNum]invertedSet];
            NSArray* arrayTemp = [string componentsSeparatedByCharactersInSet:cs];
            
            if ([self.pictuTF.text isEqualToString:self.ChooseVerification.authCodeStr])
            {
                if (self.phoneTF.text.length+string.length==11&&![string isEqualToString:@""]) {
                    self.SMSBtn.backgroundColor = Color_Orange_Weak_20;
                    self.SMSBtn.userInteractionEnabled = YES;
                    
                    [self.pictuTF resignFirstResponder];
                }
                else
                {
                    self.SMSBtn.backgroundColor = Color_Orange_Weak_20;
                    self.SMSBtn.userInteractionEnabled = NO;                }
            }
            
            return [string isEqualToString:[arrayTemp componentsJoinedByString:@""]];
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
        default:
            break;
    }
    
    return YES;
}



//获取验证码
-(void)haveSMSCode:(UIButton *)btn {
    if ([[GPClient shareGPClient].networkIsReachable isEqualToString:@"no"]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    //判断输入的是否为验证图片中显示的验证码
    if (![self.pictuTF.text isEqualToString:self.ChooseVerification.authCodeStr])
    {
        self.SMSBtn.backgroundColor = Color_Orange_Weak_20;
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"验证码错误", nil) duration:1.5];
        return;
    }
    NSString *emailRegex = @"^1[0-9][0-9]{9}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailPredicate evaluateWithObject:self.phoneTF.text]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil) ];
        return;
    }
    if (self.phoneTF.text.length != 11) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:1.5];
        return;
    }else{
        
        [self requestGetregcode];
    }
    
}

-(void)registerMinCount:(NSTimer*)timer
{   self.verificationCount--;
    
    //    NSLog(@"%lu",(unsigned long)self.verificationCount);
    [self.SMSBtn setTitle:[NSString stringWithFormat:@"%lu s",(unsigned long)self.verificationCount] forState:UIControlStateNormal];
    self.SMSBtn.showsTouchWhenHighlighted = YES;
    
    if (self.verificationCount<=0) {
        [timer invalidate];
        self.canGetCheckcode = canGetCheckcode_yes;
        self.verificationCount = COUNT;
        [self.SMSBtn setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
        self.SMSBtn.userInteractionEnabled = YES;
        self.pictuTF.userInteractionEnabled = YES;
        [self.SMSBtn setBackgroundColor:Color_Orange_Weak_20];
    }
}


#pragma mark 输入框代理，点击return 按钮
- (BOOL)PictuTextFieldWithText:(UITextField *)textField
{
    //判断输入的是否为验证图片中显示的验证码
    if ([self.pictuTF.text isEqualToString:self.ChooseVerification.authCodeStr])
    {
        if (self.phoneTF.text.length==11) {
            self.SMSBtn.backgroundColor = Color_Orange_Weak_20;
            self.SMSBtn.userInteractionEnabled = YES;
            
            [self.pictuTF resignFirstResponder];
        }
        else
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入正确的手机号", nil)  duration:2.0];
        }
    }
    else
    {
        self.SMSBtn.backgroundColor = Color_Orange_Weak_20;
        self.SMSBtn.userInteractionEnabled = NO;
        //验证不匹配，验证码和输入框抖动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        
        [self.pictuTF.layer addAnimation:anim forKey:nil];
    }
    
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTF   resignFirstResponder];
    [self.pictuTF   resignFirstResponder];
    [self.verifTF   resignFirstResponder];
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
