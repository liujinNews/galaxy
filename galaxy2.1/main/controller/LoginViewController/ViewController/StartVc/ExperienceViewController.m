//
//  ExperienceViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/7/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ExperienceViewController.h"

@interface ExperienceViewController ()<GPClientDelegate,UITextFieldDelegate>

@property (assign, nonatomic) NSUInteger verificationCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.navigationController.navigationBar.hidden = NO;
    [self setTitle:Custing(@"体验", nil) backButton:YES];
    self.view.backgroundColor = Color_White_Same_20;
    _txf_code.userInteractionEnabled = NO;
    _txf_code.keyboardType = UIKeyboardTypeNumberPad;
    _txf_phone.keyboardType = UIKeyboardTypeNumberPad;
    _txf_phone.delegate = self;
    _txf_phone.placeholder = Custing(@"请输入手机号", nil);
    _txf_code.placeholder = Custing(@"请输入短信验证码", nil);
    [_btn_ok setTitle:Custing(@"立即体验", nil) forState:UIControlStateNormal];
    [_btn_Code setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - action
- (IBAction)btn_code:(id)sender {
    if (_txf_phone.text.length!=11) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.0];
        return;
    }
    self.verificationCount = COUNT;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerMinCount:) userInfo:nil repeats:YES];
    UIButton *btn = sender;
    btn.userInteractionEnabled = NO;
    [btn setBackgroundColor:Color_Blue_Important_20];
    _txf_code.userInteractionEnabled = YES;
    [self.timer fire];
    [self requestGetExperienceCode];
}

- (IBAction)btn_OK:(UIButton *)sender {
    if (_txf_phone.text.length!=11) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入手机号", nil) duration:1.0];
        return;
    }
    if (_txf_code.text.length==0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入短信验证码", nil) duration:1.0];
        return;
    }
    _btn_ok.userInteractionEnabled = NO;
    [self requestExperienceLogin];
}

#pragma mark - function
-(void)registerMinCount:(NSTimer*)timer
{
    [_btn_Code setTitle:[NSString stringWithFormat:@"%lu s",(unsigned long)self.verificationCount] forState:UIControlStateNormal];
    self.verificationCount--;
    if (self.verificationCount<=0) {
        [timer invalidate];
        self.verificationCount = COUNT;
        [_btn_Code setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
        _btn_Code.userInteractionEnabled = YES;
        [_btn_Code setBackgroundColor:Color_Orange_Weak_20];
    }
}
//获取验证码
-(void)requestGetExperienceCode{
    NSDictionary *dic = @{@"Account":_txf_phone.text};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_ExperienceCode Parameters:dic Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//体验提交验证码
-(void)requestExperienceLogin{
    NSDictionary *dic = @{@"Account":_txf_phone.text,@"VerifyCode":_txf_code.text};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_VerifyExperience Parameters:dic Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}
//体验账号登录
-(void)requestFilterListLogin{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"account":@"20168888888",@"password": @"abc123",@"IsUserSig":@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:XB_Login Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
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
#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    if ([responceDic[@"success"] intValue] == 0 ) {
        if (serialNum == 0) {
            [_timer invalidate];
            self.verificationCount = COUNT;
            [_btn_Code setTitle:Custing(@"获取验证码", nil) forState:UIControlStateNormal];
            _btn_Code.userInteractionEnabled = YES;
            [_btn_Code setBackgroundColor:Color_Orange_Weak_20];
        }
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        if (serialNum == 1) {
            _btn_ok.userInteractionEnabled = YES;
        }
        return;
    }
    if (serialNum == 1) {
        [self requestFilterListLogin];
    }else if (serialNum==2) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"galaxy_userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.userdatas = [[userData alloc]init];
        [self.userdatas loadLocal];
        self.userdatas.multCompanyId=@"0";
        self.userdatas.language = [NSString isEqualToNull:result[@"language"]] ? result[@"language"]:@"ch";
        [[NSUserDefaults standardUserDefaults] setObject:[self.userdatas.language isEqualToString:@"en"] ? @"en":@"zh-Hans" forKey:AppLanguage];
        [NSUserDefaults standardUserDefaults];
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
        self.userdatas.experience = @"yes";
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
        [self gotoHome];
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==_txf_phone) {
        if (textField.text.length>10&&![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
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
