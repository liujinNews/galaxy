//
//  MainLoginViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/6/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createJoinNuViewController.h"

#import "MainLoginViewController.h"
#import "JKAlertDialog.h"
#import "createSuccessViewController.h"
#import "createNewCompanyViewController.h"
#import "LoginViewController.h"
#import "CLLockVC.h"
#import "WJTouchID.h"
#import "ExperienceViewController.h"
#import "updatePVController.h"

@interface MainLoginViewController ()<GPClientDelegate,WJTouchIDDelegate>

@property (strong, nonatomic) JKAlertDialog *alertview;
@property (nonatomic, strong) NSString *str_account;//账号
@property (nonatomic, strong) NSString *str_password;//密码
@property (weak, nonatomic) IBOutlet UIImageView *img_Back;

@property (nonatomic, strong) NSString *str_sig;//


@property (nonatomic, strong) WJTouchID *touchID;//指纹识别

@property (nonatomic, assign) NSInteger isShow;
@property (nonatomic, strong) UIImageView *loginImage;

@property (nonatomic, strong) UIView *GoToAppStoreView;
@property (nonatomic, strong) UIView *view_Company;

@end

@implementation MainLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AppDelegate appDelegate]registerInfo];
    if (self.userdatas == nil) {
        self.userdatas = [userData shareUserData];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"dic"];
    [defaults synchronize];
    [self createMainView];
    if (_isGoLoginView == 1) {
        [self btnHiddenNO];
        LoginViewController *log = [[LoginViewController alloc]init];
        log.isTokenInvalid=self.isTokenInvalid;
        [self.navigationController pushViewController:log animated:NO];
        return;
    }
    [self btnHiddenYES];
    [self createCompanyView];
    [self updateVersion];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:YES];
    if (_isShow==1) {
        [self removeCompanyView];
        [self btnHiddenNO];
    }
}

#pragma mark - function
-(void)createCompanyView{
    _view_Company = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:_view_Company];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-60, Main_Screen_Height/4-70, 120, 120)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    if ([NSString isEqualToNull:self.userdatas.companyLogo]){
//        NSArray *arr = [NSString dictionaryWithJsonString:self.userdatas.companyLogo];
//        NSDictionary *dic = arr.lastObject;
        NSDictionary *dic = [NSString dictionaryWithJsonString:self.userdatas.companyLogo];
        if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
        }
    }
    [_view_Company addSubview:image];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(15, Y(image)+150, Main_Screen_Width-30, 60) text:[NSString isEqualToNull:self.userdatas.company]?self.userdatas.company:Custing(@"全流程费用管控", nil) font:[NSString returnStringWidth:[NSString isEqualToNull:self.userdatas.company]?self.userdatas.company:Custing(@"全流程费用管控", nil) font:[UIFont systemFontOfSize:30.f]]>Main_Screen_Width-30?[UIFont systemFontOfSize:22.f]:[UIFont systemFontOfSize:30.f] textColor:[GPUtils colorHString:@"#282828"] textAlignment:NSTextAlignmentCenter];
    lab.numberOfLines = 0;
    [_view_Company addSubview:lab];
}

-(void)removeCompanyView{
    [_view_Company removeFromSuperview];
    _view_Company = nil;
    _img_Back.image = [UIImage new];
    _img_Back.backgroundColor = [UIColor whiteColor];
    
}

-(void)createMainView{
    _loginImage = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _loginImage.image = [UIImage imageNamed:Custing(@"login_vector", nil)];
    _loginImage.contentMode =  UIViewContentModeScaleAspectFill;
    _loginImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _loginImage.clipsToBounds  = YES;
    [self.view addSubview:_loginImage];
    
    
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];

    _img_icon.image = [UIImage imageNamed:lan ? @"login_logo":@"login_logoIcon"];

    if (Source == 1) {
        _img_icon.image = [UIImage imageNamed:lan ? @"login_logo_sb":@"login_logoEn_sb"];
    }

    _img_icon.backgroundColor = [UIColor clearColor];
    [_btn_login setTitle:Custing(@"注册", nil) forState:UIControlStateNormal];
    [_btn_register setTitle:Custing(@"登录", nil) forState:UIControlStateNormal];
    //    [_btn_experience setTitle:Custing(@"快速体验", nil) forState:UIControlStateNormal];
    _lab_experience.text =Custing(@"快速体验", nil);
}
//隐藏全部按钮
-(void)btnHiddenYES
{
    _img_icon.hidden = YES;
    _btn_login.hidden = YES;
    _btn_register.hidden = YES;
    _btn_experience.hidden = YES;
    _lab_experience.hidden = YES;
    _img_experience.hidden = YES;
    
    if (Source == 1) {
        _btn_login.hidden = YES;
        _btn_experience.hidden = YES;
        _lab_experience.hidden = YES;
        _img_experience.hidden = YES;
    }
}

//显示全部按钮
-(void)btnHiddenNO
{
    _img_icon.hidden = NO;
    _loginImage.hidden = YES;
    _btn_login.hidden = NO;
    _btn_register.hidden = NO;
    _btn_experience.hidden = NO;
    _lab_experience.hidden = NO;
    _img_experience.hidden = NO;
    
    if (Source == 1) {
        _btn_login.hidden = YES;
        _btn_experience.hidden = YES;
        _lab_experience.hidden = YES;
        _img_experience.hidden = YES;
    }
}

//检查更新
-(void)updateVersion
{
    //获得当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *parameters = @{@"DeviceType":@"iOS",@"Version":currentVersion};
    
    [[GPClient shareGPClient]REquestByPostWithPath:XB_CheckUpt Parameters:parameters Delegate:self SerialNum:9 IfUserCache:NO];
}

//自动登录
- (void)autoLogin {
    
    _str_account = self.userdatas.logName;
    _str_password = self.userdatas.password;
    NSDictionary *parameters = @{@"Account":_str_account,@"Password": _str_password,@"IsUserSig":@0};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_Login Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    
}

//前往APPSTORE
-(void)goAppStore:(UIButton *)btn
{
    NSString *appleID = @"1064300623";
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//去主页面
-(void)gotoHome{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]getBaseShowDataWithBlock:^(BOOL successed) {
        if (successed) {
            [ApplicationDelegate setupTabViewController];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"数据有误", nil) duration:1.0];
            return;
        }
    }];
}

-(void)createCompany{
    createNewCompanyViewController * create = [[createNewCompanyViewController alloc]initWithType:@"login" can:nil];
    [self.navigationController pushViewController:create animated:YES];
}
//升级页面
-(void)createGoToAppStoreView:(NSDictionary *)dic{
    _GoToAppStoreView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    _GoToAppStoreView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    _GoToAppStoreView.userInteractionEnabled=YES;
    
//    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    [self.view addSubview:_GoToAppStoreView];
    
    UIImageView *guide=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,280,365)];
    guide.center=CGPointMake(Main_Screen_Width/2, (Main_Screen_Height-49)/2);
    guide.image=[UIImage imageNamed:@"GoToAppStore_content"];
    [_GoToAppStoreView addSubview:guide];
    
    UILabel *lab = [GPUtils createLable:CGRectMake(X(guide)+20,Y(guide)+170,240,25) text:Custing(@"发现新版本", nil) font:[UIFont systemFontOfSize:18.f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [_GoToAppStoreView addSubview:lab];
    
    UITextView *textview = [GPUtils createUITextView:CGRectMake(X(guide)+20, Y(guide)+195, 240, 90) delegate:self font:Font_Same_12_20 textColor:[UIColor blackColor]];
    textview.text = [NSString isEqualToNull:dic[@"result"][@"body"]]?dic[@"result"][@"body"]:@"";
//    textview.userInteractionEnabled = NO;
    textview.editable = NO;
    [_GoToAppStoreView addSubview:textview];
    
    if ([dic[@"result"][@"type"] intValue] == 1) {
        UIButton *fork=[GPUtils createButton:CGRectMake(X(guide)+268,Y(guide)+40,25,25) action:@selector(GotoView_Close:) delegate:self];
        [fork setBackgroundImage:[UIImage imageNamed:@"GoToAppStore_Close"] forState:UIControlStateNormal];
        [_GoToAppStoreView addSubview:fork];
    }
    
    UIButton *btn=[GPUtils createButton:CGRectMake(X(guide)+22.5, Y(guide)+300, 235, 40) action:@selector(goAppStore:) delegate:self];
    [btn setBackgroundImage:[UIImage imageNamed:@"GoToAppStore_btn"] forState:UIControlStateNormal];
    [btn setTitle:Custing(@"立即更新", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_GoToAppStoreView addSubview:btn];
}

-(void)GotoView_Close:(UIButton *)btn{
    if (_GoToAppStoreView) {
        [_GoToAppStoreView removeFromSuperview];
    }
    if ([NSString isEqualToNull:self.userdatas.logName]&&[NSString isEqualToNull:self.userdatas.password]) {
        //弹出验证
        NSInteger safetype = [[[NSUserDefaults standardUserDefaults]objectForKey:SafeProtectionType] integerValue];
        if(safetype == 1){
            [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                NSLog(@"忘记密码");
                self.userdatas.password = @"";
                [self removeCompanyView];
                [self btnHiddenNO];
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                if ([NSString isEqualToNull:pwd]) {
                    NSLog(@"密码正确");
                    if ([pwd isEqualToString:@"000000"]) {
                        self.userdatas.password = @"";
                        [self removeCompanyView];
                        [self btnHiddenNO];
                    }
                    [lockVC dismiss:1.0f];
                    [self autoLogin];
                    
                }else{
                    //点击返回
                    self.userdatas.password = @"";
                    [self removeCompanyView];
                    [self btnHiddenNO];
                }
                
            }];
        }else if (safetype == 2){
            _touchID = [[WJTouchID alloc]init];
            [_touchID startWJTouchIDWithMessage:Custing(@"按压指纹以识别身份", nil) fallbackTitle:Custing(@"密码登录", nil) delegate:self];
        }else{
            [self autoLogin];
        }
        
    }else if ([NSString isEqualToNull:self.userdatas.logName]){
        [self btn_register_click:[UIButton new]];
    }else
    {
        //临时调试
        //原有的跳转改为停留在当前页面等待选择
        [self removeCompanyView];
        [self btnHiddenNO];
    }
}

#pragma mark - action
//注册
- (IBAction)Btn_login_click:(UIButton *)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }else{
        //        registerVController * rvc = [[registerVController alloc]initWithType:@"register" account:[NSString stringWithFormat:@"%@",self.userdatas.logName]];
        //        [self.navigationController pushViewController:rvc animated:YES];
        createJoinNuViewController *Exp = [[createJoinNuViewController alloc]initWithType:@"zhuceNEW" can:nil];
        [self.navigationController pushViewController:Exp animated:YES];
    }
    
}

//登录
- (IBAction)btn_register_click:(UIButton *)sender {
    LoginViewController *log = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:log animated:YES];
}

//体验
- (IBAction)btn_Experience_click:(id)sender {
    ExperienceViewController *Exp = [[ExperienceViewController alloc]init];
    [self.navigationController pushViewController:Exp animated:YES];
}


#pragma mark - 代理
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    _isShow = 1;
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum == 1) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"galaxy_userInfo"];
                self.userdatas = nil;
                self.userdatas = [[userData alloc]init];
                [self.userdatas loadLocal];
                [NSUserDefaults standardUserDefaults];
                self.userdatas.checkExpiryDic = result[@"checkExpiry"];
                [self.userdatas storeUserInfo];
                if ([self.userdatas.checkExpiryDic isKindOfClass:[NSDictionary class]]) {
                    NSString * isExpiry = [NSString stringWithFormat:@"%@",[self.userdatas.checkExpiryDic objectForKey:@"isExpiry"]];
                    if ([isExpiry isEqualToString:@"1"]) {
                        //原有的跳转改为停留在当前页面等待选择
                        [self removeCompanyView];
                        [self btnHiddenNO];
                        return;
                    }
                }
                
            }
        }
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        //原有的跳转改为停留在当前页面等待选择
        [self removeCompanyView];
        [self btnHiddenNO];
        return;
    }
    if (serialNum == 9) {
        //临时
        if ([responceDic[@"result"][@"type"] intValue] != 0 ) {
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
            NSString *ver = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"ver"]];
            if ([NSString isEqualToNull:ver] && [ver compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                [self createGoToAppStoreView:responceDic];
                return;
            }
        }
        [self GotoView_Close:[UIButton new]];
    }else if (serialNum == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"galaxy_userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.userdatas = [userData shareUserData];
        [self.userdatas loadLocal];
        self.userdatas.logName = _str_account;
        self.userdatas.password = _str_password;
        self.userdatas.multCompanyId=@"0";
        self.userdatas.language = [NSString isEqualToNull:result[@"language"]] ? result[@"language"]:@"ch";
        [[NSUserDefaults standardUserDefaults] setObject:[self.userdatas.language isEqualToString:@"en"] ? @"en":@"zh-Hans" forKey:AppLanguage];
        [NSUserDefaults standardUserDefaults];
        self.userdatas.companyLogo = result[@"companyLogo"];
        self.userdatas.checkExpiryDic = result[@"checkExpiry"];
        self.userdatas.source = [result[@"source"] integerValue];
        self.userdatas.companyId = [NSString stringWithIdOnNO:result[@"companyId"]];
        self.userdatas.company = [NSString stringWithIdOnNO:result[@"coName"]];
        self.userdatas.department = [NSString stringWithIdOnNO:result[@"department"]];
        self.userdatas.coCode = [NSString stringWithIdOnNO:result[@"coCode"]];
        self.userdatas.userDspName = [NSString stringWithIdOnNO:result[@"userDspName"]];
        self.userdatas.token = [NSString stringWithFormat:@"%@",result[@"token"]];
        self.userdatas.userId = [NSString stringWithFormat:@"%@",result[@"userId"]];
        self.userdatas.isOnlinePay = [NSString stringWithFormat:@"%@",result[@"isOnlinePay"]];
        self.userdatas.CorpActTyp = [NSString stringWithFormat:@"%@",result[@"corpActTyp"]];
        self.userdatas.multiCyPayment = [[NSString stringWithFormat:@"%@",result[@"multiCyPayment"]] isEqualToString:@"1"] ? @"1":@"0";
        self.userdatas.isOpenChanPay = [[NSString stringWithFormat:@"%@",result[@"isOpenChanPay"]] isEqualToString:@"1"] ? @"1":@"0";


        NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",result[@"photoGraph"]]];
        if ([dic isKindOfClass:[NSDictionary class]]){
            self.userdatas.photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
        }else{
            self.userdatas.photoGraph = nil;
        }
        self.userdatas.gender = [NSString stringWithIdOnNO:result[@"gender"]];
        self.userdatas.groupid = @"0";
        if (!self.userdatas.cacheItems) {
            self.userdatas.cacheItems = [NSMutableDictionary dictionary];
        }
        if ([result[@"cacheItems"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"cacheItems"]) {
                NSString *name = dict[@"name"];
                if (!self.userdatas.cacheItems[name]) {
                    NSDictionary *item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                           @"update":@"1"
                                           };
                    [self.userdatas.cacheItems setObject:item forKey:name];
                }else{
                    NSDictionary *item;
                    if ([self.userdatas.cacheItems[name][@"updateTime"] isEqualToString:[NSString stringWithFormat:@"%@",dict[@"updateTime"]]]) {
                        item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                               @"update":@"0"
                                               };

                    }else{
                        item = @{@"updateTime":[NSString stringWithIdOnNO:dict[@"updateTime"]],
                                               @"update":@"1"
                                               };
                    }
                    [self.userdatas.cacheItems setObject:item forKey:name];
                }
            }
        }
        self.userdatas.isSystem = [[NSString stringWithFormat:@"%@",result[@"isManager"]] isEqualToString:@"1"] ? @"1":@"0";
        [self.userdatas storeUserInfo];
        //2.6版本新增内容
        if ([result[@"isFirstLoginRestPwd"] intValue]==1) {
            createJoinNuViewController * lost = [[createJoinNuViewController alloc]initWithType:@"lostPassword" can:@{@"Account":[NSString isEqualToNull:_str_account] ? _str_account : @""}];
            [self.navigationController pushViewController:lost animated:YES];
            return;
        }
        if ([result[@"isResetPwd"] intValue]==1) {
            updatePVController * update = [[updatePVController alloc]init];
            update.type = 1;
            [self.navigationController pushViewController:update animated:YES];
            return;
        }
        if ([self.userdatas.isSystem isEqualToString:@"1"]) {
            if ([NSString isEqualToNull:self.userdatas.company]) {
                if ([responceDic[@"result"][@"isFirstLogin"] intValue] == 0) {
                    createSuccessViewController * coSuccess = [[createSuccessViewController alloc]initWithType:@"login" can:@{@"Source":@"",@"CoCode":@"",@"companyName":[NSString isEqualToNull:self.userdatas.company] ? self.userdatas.company : @"",@"companyContact":@"",@"Account":[NSString isEqualToNull:self.userdatas.logName] ? self.userdatas.logName : @"",@"VerifyCode":@"",@"Password":[NSString isEqualToNull:self.userdatas.password] ?self.userdatas.password : @"",@"corpId":[NSString isEqualToNull:self.userdatas.companyId] ? self.userdatas.companyId :@""}];
                    [self.navigationController pushViewController:coSuccess animated:YES];
                }else{
                    [self gotoHome];
                }
            }else{
                [self createCompany];
            }
        }else{
            [self gotoHome];
        }
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
    //原有的跳转改为停留在当前页面等待选择
    [self removeCompanyView];
    [self btnHiddenNO];
}

/**
 *  TouchID验证成功
 *
 *  (English Comments) Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
    [self autoLogin];
}

/**
 *  TouchID验证失败
 *
 *  (English Comments) Authentication Failure
 */
- (void) WJTouchIDAuthorizeFailure {
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:Custing(@"警告", nil) message:Custing(@"Touch ID验证失败", nil) cancelButtonTitle:Custing(@"密码登录", nil) otherButtonTitles:@[Custing(@"再试一次", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            weakSelf.userdatas.password = @"";
            //原有的跳转改为停留在当前页面等待选择
            [weakSelf removeCompanyView];
            [weakSelf btnHiddenNO];
        }else{
            [weakSelf.touchID startWJTouchIDWithMessage:Custing(@"按压指纹以识别身份", nil) fallbackTitle:Custing(@"密码登录", nil) delegate:self];
        }
    }];
}

//点击取消
- (void)WJTouchIDAuthorizeErrorUserCancel{
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:Custing(@"警告", nil) message:Custing(@"Touch ID验证失败", nil) cancelButtonTitle:Custing(@"密码登录", nil) otherButtonTitles:@[Custing(@"再试一次", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            weakSelf.userdatas.password = @"";
            [weakSelf removeCompanyView];
            [weakSelf btnHiddenNO];
        }else{
            [weakSelf.touchID startWJTouchIDWithMessage:Custing(@"按压指纹以识别身份", nil) fallbackTitle:Custing(@"密码登录", nil) delegate:self];
        }
    }];
}

-(void)WJTouchIDAuthorizeErrorUserFallback{
    self.userdatas.password = @"";
    [self removeCompanyView];
    [self btnHiddenNO];
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
