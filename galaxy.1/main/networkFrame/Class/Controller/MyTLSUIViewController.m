//
//  TLSUIViewController.m
//  MyDemo
//
//  Created by tomzhu on 15/7/30.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "MyTLSUIViewController.h"

#import "GlobalData.h"

#import "AccountHelper.h"

#import "FriendshipManager.h"
#import "AppDelegate.h"
#import "MyCommOperation.h"
#import "MyUtilty.h"

#import "MyTabBarViewController.h"
#import "UIResponder+addtion.h"
#import "MBProgressHUD.h"

#import "TLSSDK/TLSHelper.h"

#import "MyAlertView.h"

#define kDaysInSeconds(x)      (x * 24 * 60 * 60)

@interface MyTLSUIViewController () {
    TencentOAuth *_openQQ;
    id<WXApiDelegate> _tlsuiwx;
    BOOL first;
    MBProgressHUD *HUD;
}

@end

@implementation MyTLSUIViewController

- (void)dealloc
{
    _openQQ = nil;
    _tlsuiwx = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _openQQ = [[TencentOAuth alloc]initWithAppId:QQ_APP_ID andDelegate:self];
    first = YES;
    
    [WXApi registerApp:WX_APP_ID];
    //demo暂不提供微博登录
    //[WeiboSDK registerApp:WB_APPKEY];

    if (![self autoLogin]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pullLoginUI];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mak - delegate<TencentLoginDelegate>
-(void)tencentDidNotNetWork{
    NSLog(@"%s", __func__);
}

-(void)tencentDidLogin{
    NSLog(@"%s", __func__);
    
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"%s %d", __func__, cancelled);
}

#pragma mark - delegate<WXApiDelegate>
-(void) onReq:(BaseReq*)req{
    NSLog(@"%s %@", __func__, req);
}

-(void)onResp:(BaseResp *)resp{
    NSLog(@"%d %@ %d",resp.errCode, resp.errStr, resp.type);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if(_tlsuiwx != nil)
            [_tlsuiwx onResp:resp];
    }
}

#pragma mark - 拉起登陆框
- (void)pullLoginUI{
    TLSUILoginSetting *tlsSetting = [[TLSUILoginSetting alloc] init];
    [tlsSetting setOpenQQ:_openQQ];
    tlsSetting.qqScope = nil;
    tlsSetting.wxScope = @"snsapi_userinfo";
    tlsSetting.enableWXExchange = YES;
    tlsSetting.enableGuest = YES;
    //demo暂不提供微博登录
//    tlsSetting.wbScope = nil;
//    tlsSetting.wbRedirectURI = @"https://api.weibo.com/oauth2/default.html";

    if (first) {
        _tlsuiwx = TLSUILogin(self, tlsSetting);
        first = false;
    }
}

#pragma mark - delegate<TLSUILoginListener>
-(void)TLSUILoginOK:(TLSUserInfo *)userinfo{
    //回调时已结束登录流程 销毁微信回调对象
    _tlsuiwx = nil;
    _openQQ = nil;
    //根据登录结果处理
    if (userinfo) {
        [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
        [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
        
        TIMLoginParam *param = [self createParam:userinfo];
        [self TIMLogin:param];
    }
}

-(void)TLSUILoginQQOK{
    //回调时已结束登录流程 销毁微信回调对象
    _tlsuiwx = nil;
    
    [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
    [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];

    [[TLSHelper getInstance] TLSOpenLogin:kQQAccountType andOpenId:_openQQ.openId andAppid:QQ_APP_ID andAccessToken:_openQQ.accessToken andTLSOpenLoginListener:self];

    _openQQ = nil;
}
//已经废弃
-(void)TLSUILoginWXOK:(SendAuthResp*)resp
{
}

-(void)TLSUILoginWXOK2:(TLSTokenInfo*)tokenInfo
{
    _tlsuiwx = nil;
    _openQQ = nil;
    
    [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
    [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
    
    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:WX_APP_ID andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];
}
//demo暂不提供微博登录

-(void)TLSUILoginWBOK:(WBAuthorizeResponse*)resp
{
//    [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
//    [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
//    NSString *appid = [[NSString alloc] initWithFormat:@"%d",kSdkAppId ];
//    [[TLSHelper getInstance] TLSOpenLogin:kWXAccountType andOpenId:tokenInfo.openid andAppid:appid andAccessToken:tokenInfo.accessToken andTLSOpenLoginListener:self];

}

-(void)TLSUILoginCancel{
    //回调时已结束登录流程 销毁微信回调对象
    _tlsuiwx = nil;
    _openQQ = nil;
}

#pragma mark - TLSOpenLoginListener

//第三方登录成功之后，再次登陆tls换取userinfo
-(void)OnOpenLoginSuccess:(TLSUserInfo*)userInfo
{
    TIMLoginParam *param = [self createParam:userInfo];
    [self TIMLogin:param];
}

-(void)OnOpenLoginFail:(TLSErrInfo*)errInfo
{
    NSLog(@"%@",errInfo);
}

-(void)OnOpenLoginTimeout:(TLSErrInfo*)errInfo
{
    NSLog(@"%@",errInfo);
}

#pragma mark - Provate Methods
- (BOOL)autoLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kLoginParam]) {
        if (!HUD){
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            [HUD show:YES];
            HUD.hidden = YES;
            [HUD showText:@"正在自动登录" atMode:MBProgressHUDModeIndeterminate];
        }
        
        TIMLoginParam *param = [[TIMLoginParam alloc] init];
        NSData *paramData = [defaults objectForKey:kLoginParam];
        param = [NSKeyedUnarchiver unarchiveObjectWithData:paramData];
        
        NSString *saveTimeStr = [defaults objectForKey:kSaveSigTime];
        NSInteger saveTime = [saveTimeStr integerValue];
        
        time_t curTime = [[NSDate date] timeIntervalSince1970];
        if (curTime-saveTime > kDaysInSeconds(10)) {
            //刷新票据
            [[TLSHelper getInstance] TLSRefreshTicket:param.identifier andTLSRefreshTicketListener:self];
        }
        else{
            //直接登录
            __weak MyTLSUIViewController *weakSelf = self;
            __weak MBProgressHUD *weakHUD = HUD;
            __weak TIMLoginParam *wp = param;
            [[MyCommOperation shareInstance] autoLogin:param succ:^{
                
                [weakHUD hide:YES];
                
                [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
                [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
                [weakSelf onLoginSucess:wp];
                [weakSelf doLoginInSuccess];
            }
            fail:^(int code, NSString *err){
              
                [weakHUD hide:YES];
              
                NSString *errInfo = [[NSString alloc] initWithFormat:@"自动登录失败\ncode:%d, error:%@",code,err];
                [weakSelf showAlert:@"提示" andMsg:errInfo];
                [weakSelf pullLoginUI];
            }];
        }
        return YES;
    }
    return NO;
}

#pragma mark - 刷新票据代理

-(void)	OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    //保存最新票据
    TIMLoginParam *param = [[TIMLoginParam alloc ]init];
    param.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
    [[TIMManager sharedInstance] log:TIM_LOG_DEBUG tag:@"OnRefreshTicketSuccess get usersig is " msg:[NSString stringWithFormat:@"%@",param.userSig]];
    param.identifier = userInfo.identifier;
    param.appidAt3rd = [@kTLSAppid stringValue];
    param.accountType = [NSString stringWithFormat:@"%d", kSdkAccountType];
    param.sdkAppId = kSdkAppId;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    time_t curTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [[NSString alloc] initWithFormat:@"%ld",curTime];
    [defaults setObject:timeStr forKey:kSaveSigTime];
    
    NSData *loginData = [NSKeyedArchiver archivedDataWithRootObject:param];
    [defaults setObject:loginData forKey:kLoginParam];
    
    //登录
    __weak MyTLSUIViewController *weakSelf = self;
    __weak MBProgressHUD *weakHUD = HUD;
    [[MyCommOperation shareInstance] autoLogin:param succ:^{
        
        [weakHUD hide:YES];
        
        [GlobalData shareInstance].accountHelper = [AccountHelper sharedInstance];
        [GlobalData shareInstance].friendshipManager = [FriendshipManager sharedInstance];
        [weakSelf onLoginSucess:param];
        [weakSelf doLoginInSuccess];
    }
    fail:^(int code, NSString *err){

    [weakHUD hide:YES];

    NSString *errInfo = [[NSString alloc] initWithFormat:@"自动登录失败\ncode:%d, error:%@",code,err];
    [weakSelf showAlert:@"提示" andMsg:errInfo];
    [weakSelf pullLoginUI];
    }];
}


-(void)	OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    [HUD hide:YES];
    
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@",errInfo.dwErrorCode,errInfo.sErrorTitle];
    [self showAlert:@"提示" andMsg:err];
    [self pullLoginUI];
}


-(void)	OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [HUD hide:YES];
    
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据超时\ncode:%d, error:%@",errInfo.dwErrorCode,errInfo.sErrorTitle];
    [self showAlert:@"提示" andMsg:err];
    [self pullLoginUI];
}

- (TIMLoginParam *)createParam:(TLSUserInfo *)userinfo
{
    TIMLoginParam *param = [[TIMLoginParam alloc ]init];
    param.userSig = [[TLSHelper getInstance] getTLSUserSig:userinfo.identifier];
    [[TIMManager sharedInstance] log:TIM_LOG_DEBUG tag:@"createParam get usersig is " msg:[NSString stringWithFormat:@"%@",param.userSig]];
    param.identifier = userinfo.identifier;
    param.appidAt3rd = [@kTLSAppid stringValue];
    param.accountType = [NSString stringWithFormat:@"%d", kSdkAccountType];
    param.sdkAppId = kSdkAppId;
    
    return param;
}

- (void)TIMLogin:(TIMLoginParam *)param {
    
    __weak TIMLoginParam * wp = param;
    __weak MyTLSUIViewController *ws = self;
    [[TIMManager sharedInstance] login:param succ:^{
        TDDLogEvent(@"TIMLogin Succ");
        [self saveLoginData:wp];
        [ws onLoginSucess:wp];
        [ws doLoginInSuccess];
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"TIMLogin Failed: code=%d err=%@", code, err);
        if (code == kEachKickErrorCode) {
            NSString *errInfo = [[NSString alloc] initWithFormat:@"该账号已在另一台设备上登录，请重新登录"];
            MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"提示" message:errInfo cancelButtonTitle:@"返回" otherButtonTitles:nil block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
                if (buttonIndex == 0) {
                    AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
                    #warning dengchu
//                    [appDelegate switchToLoginView];
                }
            }];
            [alert show];
        }
        else{
            NSString *errInfo = [[NSString alloc] initWithFormat:@"登录失败，请重新登录\ncode:%d, error:%@",code,err];
            MyAlertView *alert = [[MyAlertView alloc]initWithTitle:@"提示" message:errInfo cancelButtonTitle:@"返回" otherButtonTitles:nil block:^(MyAlertView *myAlertView, NSInteger buttonIndex){
                if (buttonIndex == 0) {
                    AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
                    #warning dengchu
//                    [appDelegate switchToLoginView];
                }
            }];
            [alert show];
        }
    }];
}



- (void)saveLoginData:(TIMLoginParam *)param
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    time_t curTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [[NSString alloc] initWithFormat:@"%ld",curTime];
    [defaults setObject:timeStr forKey:kSaveSigTime];
    
    NSData *loginData = [NSKeyedArchiver archivedDataWithRootObject:param];
    [defaults setObject:loginData forKey:kLoginParam];
}

#pragma mark - 微博登录代理
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{

}

- (void)onLoginSucess:(TIMLoginParam *)param {
    // 配置全局信息
    [GlobalData shareInstance].me = [[TIMManager sharedInstance] getLoginUser];
    [GlobalData shareInstance].isLogined = YES;
    
    // 跳转到登录后界面
    MyTabBarViewController* tabBarViewCtrlr = [[MyTabBarViewController alloc] init];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIWindow *curWindow = app.window;
    curWindow.rootViewController = tabBarViewCtrlr;
}

- (void)doLoginInSuccess{ //登录成功时，拉取打印日志等级、个人信息、好友列表、群组列表、黑名单和系统消息列表
    [[MyCommOperation shareInstance] getLogLevel];
    [[MyCommOperation shareInstance] getSelfProfile];
    [[MyCommOperation shareInstance] requestFriendList];
    [[MyCommOperation shareInstance] requestGroupList];
    [[MyCommOperation shareInstance] requestBlackList];
}

@end
