 //
//  LoginViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "createNewCompanyViewController.h"
#import "createSuccessViewController.h"
#import "createJoinNuViewController.h"
#import "StatisticalView.h"

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "MessageViewController.h"
#import "ReimburseViewController.h"
#import "WorkViewController.h"
#import "MineViewController.h"
#import "JKAlertDialog.h"
#import "ExperienceViewController.h"

#import "MainLoginViewController.h"
#import "BusinessLoginViewController.h"
#import "updatePVController.h"

@interface LoginViewController ()<GPClientDelegate,StatisticalViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *str_account;//账号
@property (nonatomic, strong) NSString *str_password;//密码

@property (nonatomic, strong) NSDictionary *dic_requst;

@property (copy, nonatomic) NSString * appstoreUrl;//app下载地址
@property (copy, nonatomic) NSString * appVersion;//app版本号

@property (strong, nonatomic) JKAlertDialog *alertview;
@property (nonatomic,strong)StatisticalView * dateView;
@property (nonatomic,strong)NSDictionary * fuDic;

@end

@implementation LoginViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerViewWillHide)
                                                 name:UIKeyboardWillHideNotification object:nil];
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 50; // 左端盖宽度
    CGFloat right = 50; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *image = [_btn_login.imageView.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [_btn_login setImage:image forState:UIControlStateNormal];
    [_btn_login setTitle:Custing(@"登录", nil) forState:UIControlStateNormal];
    [_btn_Experience setTitle:Custing(@"企业号登录", nil) forState:UIControlStateNormal];
    [_btn_regisn setTitle:Custing(@"快速注册", nil) forState:UIControlStateNormal];
    [_btn_losdward setTitle:Custing(@"忘记密码？", nil) forState:UIControlStateNormal];
    _txf_account.placeholder = Custing(@"手机号/账号", nil);
    _txf_password.placeholder = Custing(@"密码", nil);
    _txf_password.backgroundColor = [UIColor whiteColor];
    
    BOOL lan = [[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"];
    _img_logo.backgroundColor = [UIColor clearColor];
    _img_logo.image = [UIImage imageNamed:lan ? @"login_logo":@"login_logoIcon"];
    if (@available(iOS 13.0, *)) {
        _txf_account.textColor = [UIColor blackColor];
        _txf_password.textColor = [UIColor blackColor];
       } else {
           // Fallback on earlier versions
       }
    
    if (Source == 1) {
        _btn_losdward.hidden = YES;
        _btn_Experience.hidden = YES;
        _img_logo.image = [UIImage imageNamed:lan ? @"login_logo_sb":@"login_logoEn_sb"];
    }
    
    [self setMainView];
    
    if (self.isTokenInvalid) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"登录已过期", nil) duration:1.0];
    }
    
    
    
    
}

-(void)setMainView{
    _img_account.highlighted = YES;
    _img_password.highlighted = YES;
    UIImage *image = [UIImage imageNamed:@"login_white"];
    image = [image scaleToSize:CGSizeMake(Main_Screen_Width, Main_Screen_Height)];
    if ([NSString isEqualToNull:self.userdatas.logName]) {
        _txf_account.text = self.userdatas.logName;
        _img_account.highlighted = NO;
    }
    if ([NSString isEqualToNull:self.userdatas.password]) {
        _txf_password.text = self.userdatas.password;
        _img_password.highlighted = NO;
    }
    
    _txf_account.delegate = self;
    _txf_password.delegate = self;
    
    _img_BackImage.image = image;
    _img_BackImage.contentMode = UIViewContentModeCenter;
}



-(void)createCompany{
    createNewCompanyViewController * create = [[createNewCompanyViewController alloc]initWithType:@"login" can:nil];
    [self.navigationController pushViewController:create animated:YES];
}



#pragma mark - action
//登录点击
- (IBAction)btn_login_click:(UIButton *)sender {
    [self headerViewWillHide];
    _img_account.highlighted = YES;
    
    _str_account = _txf_account.text;
    _str_password = _txf_password.text;
    
    //判断账号
    if (_str_account.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入账号", nil) duration:1.5];
        return;
    }
    else if (_str_password.length==0)
    {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入正确的密码。", nil) duration:1.5];
        return;
    }
    else
    {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        [self requestReserveList];
    }
}

//忘记密码
- (IBAction)btn_lostPassword_click:(id)sender {
    [self headerViewWillHide];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }else{
        createJoinNuViewController * lost = [[createJoinNuViewController alloc]initWithType:@"lostPassword" can:@{@"Account":[NSString isEqualToNull:_txf_account.text] ? _txf_account.text : @""}];
        [self.navigationController pushViewController:lost animated:YES];
    }
}

//企业号登陆点击
- (IBAction)btn_businessLogin_click:(id)sender {
    BusinessLoginViewController *bus = [[BusinessLoginViewController alloc]init];
    [self.navigationController pushViewController:bus animated:YES];
}

//注册密码
//- (IBAction)btn_register_click:(UIButton *)sender {
//    [self headerViewWillHide];
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
//        return;
//    }else{
//        registerVController * rvc = [[registerVController alloc]initWithType:@"register" account:[NSString stringWithFormat:@"%@",_txf_account.text]];
//        [self.navigationController pushViewController:rvc animated:YES];
//    }
//}
//
//- (IBAction)btn_Experience:(UIButton *)sender {
//    ExperienceViewController *Exp = [[ExperienceViewController alloc]init];
//    [self.navigationController pushViewController:Exp animated:YES];
//}

//返回到MAIN页面
- (IBAction)Go_MainLogin:(UIButton *)sender {
//    MainLoginViewController *main = [[MainLoginViewController alloc]init];
    self.userdatas.password = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btn_Pw_Click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = _txf_password.text;
        _txf_password.text = @""; // 这句代码可以防止切换的时候光标偏移
        _txf_password.secureTextEntry = NO;
        _txf_password.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = _txf_password.text;
        _txf_password.text = @"";
        _txf_password.secureTextEntry = YES;
        _txf_password.text = tempPwdStr;
    }
}


#pragma mark - 方法
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

-(void)requestReserveList{
    NSDictionary *parameters;
    parameters = @{@"account":_str_account,@"password": _str_password,@"IsUserSig":@0};
    [[GPClient shareGPClient]RequestByPostWithPath:XB_Login Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    
}

-(void)headerViewWillHide{
    [self keyClose];
    [UIView animateWithDuration:.5 animations:^{
        self.view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
        self.img_logo.hidden = NO;
    }];
}

#pragma mark - 代理
//网络请求回调
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    //临时解析用的数据
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum == 1) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                self.fuDic = [result objectForKey:@"checkExpiry"];
                if ([self.fuDic isKindOfClass:[NSNull class]] || self.fuDic == nil|| self.fuDic.count == 0||!self.fuDic) {
                }else {
                    NSString * isExpiry = [NSString stringWithFormat:@"%@",[self.fuDic objectForKey:@"isExpiry"]];
                    if ([isExpiry isEqualToString:@"1"]) {
                        [self createXueFeiLogin];
                        return;
                    }
                }
            }
        }
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 1) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"galaxy_userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.userdatas = nil;
        self.userdatas = [[userData alloc]init];
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
        //2.6版本新增内容
        if ([result[@"isFirstLoginRestPwd"] intValue]==1) {
            createJoinNuViewController * lost = [[createJoinNuViewController alloc]initWithType:@"lostPassword" can:@{@"Account":[NSString isEqualToNull:_str_account] ? _str_account : @""}];
            [self.navigationController pushViewController:lost animated:YES];
            return;
        }
        self.userdatas.isSystem = [[NSString stringWithFormat:@"%@",result[@"isManager"]] isEqualToString:@"1"] ? @"1":@"0";
        [self.userdatas storeUserInfo];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _txf_account) {
        _img_account.highlighted = NO;
        _img_password.highlighted = YES;
    }
    if (textField == _txf_password) {
        _img_password.highlighted = NO;
        _img_account.highlighted = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.5 animations:^{
        self.view.frame = CGRectMake(0, -182, Main_Screen_Width, Main_Screen_Height);
        self.img_logo.hidden = YES;
    }];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self headerViewWillHide];
}

//续费登录
-(void)createXueFeiLogin {
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-142.5, 0,300, 316)];
    View.backgroundColor = [UIColor clearColor];
    View.layer.cornerRadius = 15.0f;
    View.userInteractionEnabled = YES;
    
    UIView * Views = [[UIView alloc]initWithFrame:CGRectMake(0, 121,270, 195)];
    Views.backgroundColor = [UIColor whiteColor];
    Views.layer.cornerRadius = 15.0f;
    Views.userInteractionEnabled = YES;
    [View addSubview:Views];
    
    UIImageView * alertView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 11,270, 372/2)];
    alertView.image = GPImage(@"ArrearsNotification");
    alertView.backgroundColor = [UIColor clearColor];
    [View addSubview:alertView];
    
    UIButton * chooseBtn = [GPUtils createButton:CGRectMake(254.25, -4.75, 31.5, 31.5) action:@selector(wozhdiaole:) delegate:self];
    chooseBtn.backgroundColor = [UIColor clearColor];
    [chooseBtn setImage:GPImage(@"ArrearsNotRelease") forState:UIControlStateNormal];
    [View addSubview:chooseBtn];

    NSString * adminStr;
    if ([self.fuDic isKindOfClass:[NSNull class]] || self.fuDic == nil|| self.fuDic.count == 0||!self.fuDic) {
    }else {
        NSString * isAdmin = [NSString stringWithFormat:@"%@",[self.fuDic objectForKey:@"isAdmin"]];
        if ([isAdmin isEqualToString:@"1"]) {
            adminStr = Custing(@"请前往网页端续费", nil);
        }else {
            adminStr = Custing(@"请联系公司管理员续费", nil);
        }
    }
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 372/2+21, 270, 30) text:Custing(@"您的企业版已经到期", nil) font:Font_Important_15_20 textColor:[GPUtils colorHString:@"#282828"] textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    
    
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(0, 372/2+46, 270, 50) text:adminStr font:Font_Important_15_20 textColor:[GPUtils colorHString:@"#282828"] textAlignment:NSTextAlignmentCenter];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [View addSubview:twoLa];
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
}


//键盘取消
- (void)dimsissStatisticalPDActionView{
    self.dateView = nil;
}
//键盘显示通知
-(void)keyboardWillShow:(NSNotification*)notification{
    
    if (_dateView) {
        [_dateView removeStatistical];
    }
}

- (void)wozhdiaole:(UIButton *)btn {
    [self.dateView removeStatistical];
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
