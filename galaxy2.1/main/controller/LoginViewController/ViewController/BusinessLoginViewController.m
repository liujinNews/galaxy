//
//  BusinessLoginViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/11/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BusinessLoginViewController.h"
#import "StatisticalView.h"
#import "createSuccessViewController.h"
#import "createNewCompanyViewController.h"


@interface BusinessLoginViewController ()<GPClientDelegate,StatisticalViewDelegate>
@property (nonatomic, strong) UITextField *txf_number;//企业号
@property (nonatomic, strong) UITextField *txf_access;//账号
@property (nonatomic, strong) UITextField *txf_password;//密码

@property (nonatomic, strong) NSDictionary *fuDic;
@property (nonatomic, strong) StatisticalView * dateView;
@property (nonatomic, strong) NSDictionary *dic_requst;
@end

@implementation BusinessLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.view.backgroundColor = UIColor.whiteColor;
    
    [self setTitle:Custing(@"企业号登录", nil) backButton:YES];
    self.view.backgroundColor = Color_White_Same_20;
    [self setMainView];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - function
//创建视图
- (void)setMainView
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 45)];
    view1.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view1];
    _txf_number = [[UITextField alloc]initWithFrame:CGRectMake(15, 17.5, Main_Screen_Width-30, 30)];
    _txf_number.placeholder = Custing(@"企业号", nil);
    _txf_number.font = Font_Same_14_20;
    [self.view addSubview:_txf_number];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 65, Main_Screen_Width, 45)];
    view2.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view2];
    _txf_access = [[UITextField alloc]initWithFrame:CGRectMake(15, 55+17.5, Main_Screen_Width-30, 30)];
    _txf_access.placeholder = Custing(@"账号", nil);
    _txf_access.font = Font_Same_14_20;
    [self.view addSubview:_txf_access];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, Main_Screen_Width, 45)];
    view3.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:view3];
    _txf_password = [[UITextField alloc]initWithFrame:CGRectMake(15, 110+17.5, Main_Screen_Width-30, 30)];
    _txf_password.placeholder = Custing(@"密码", nil);
    _txf_password.secureTextEntry = YES;
    _txf_password.font = Font_Same_14_20;
    [self.view addSubview:_txf_password];
    
    UIButton *btn = [GPUtils createButton:CGRectMake(15, 195, Main_Screen_Width-30, 40) action:@selector(btn_click:) delegate:self title:Custing(@"登录", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"People_BlueEllipse"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 235, Main_Screen_Width-30, 45)];
    lab.text = Custing(@"第三方平台用户通过企业号登录", nil);
    lab.font = Font_Same_12_20;
    lab.textColor = Color_GrayDark_Same_20;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];
}

//第三方登录
-(void)requestReserveList{
    NSDictionary *parameters  = @{@"CorpCode":_txf_number.text,@"account":_txf_access.text,@"password": _txf_password.text,@"language":[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en",@"IsUserSig":@0};
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:XB_LoginByCid Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}
//续费登录
-(void)createXueFeiLogin {
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-142.5, 0,300, 316)];
    View.backgroundColor = [UIColor clearColor];
    View.layer.cornerRadius = 15.0f;
    View.userInteractionEnabled = YES;
    
    UIView * Views = [[UIView alloc]initWithFrame:CGRectMake(0, 121,270, 195)];
    Views.backgroundColor = Color_form_TextFieldBackgroundColor;
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
    
    UILabel * oneLa = [GPUtils createLable:CGRectMake(0, 372/2+21, 270, 30) text:Custing(@"您的企业版已经到期", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    oneLa.numberOfLines = 0;
    oneLa.backgroundColor = [UIColor clearColor];
    [View addSubview:oneLa];
    
    UILabel * twoLa = [GPUtils createLable:CGRectMake(0, 372/2+46, 270, 50) text:adminStr font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentCenter];
    twoLa.numberOfLines = 0;
    twoLa.backgroundColor = [UIColor clearColor];
    [View addSubview:twoLa];
    
    if (!self.dateView) {
        self.dateView = [[StatisticalView alloc]initWithStatisticalFrame:CGRectMake(0,Main_Screen_Height, 0, 0) pickerView:View titleView:nil];
        self.dateView.delegate = self;
    }
    [self.dateView showStatisticalDownView:View frame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
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
#pragma mark - action
//按钮点击事件
- (void)btn_click:(UIButton *)btn
{
    if (![NSString isEqualToNull:_txf_number.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入企业号", nil) duration:2.0];
        return;
    }
    if (![NSString isEqualToNull:_txf_access.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入账号", nil) duration:2.0];
        return;
    }
    if (![NSString isEqualToNull:_txf_password.text]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"请输入密码", nil) duration:2.0];
        return;
    }
    [self requestReserveList];
}

#pragma mark - delegate
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum{
    NSLog(@"%@",responceDic);
    //临时解析用的数据
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        if (serialNum == 1) {
            
            if ([result isKindOfClass:[NSNull class]] || result == nil|| result == 0||!result) {
                
            }else {
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
        self.userdatas.logName = _txf_access.text;
        self.userdatas.password = _txf_password.text;
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
        
        self.userdatas.cacheItems = [NSMutableDictionary dictionary];
        
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

- (void)wozhdiaole:(UIButton *)btn {
    [self.dateView removeStatistical];
}

//键盘取消
- (void)dimsissStatisticalPDActionView{
    self.dateView = nil;
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
