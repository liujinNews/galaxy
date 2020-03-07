//
//  AccountHelper.m
//  MyDemo
//
//  Created by tomzhu on 15/6/11.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "AccountHelper.h"
#import "GlobalData.h"
#import <ImSDK/ImSDK.h>

#import "MyErrorTable.h"

static AccountHelper *sharedInstance;
static TLSAccountHelper *tlsAccountHelper;
static TLSLoginHelper *tlsLoginHelper;

@interface AccountHelper()

@property (nonatomic, strong)TIMLoginParam *loginParam;

@end

@implementation AccountHelper

#pragma mark - interface
+ (instancetype)sharedInstance {
    static dispatch_once_t AccountHelperToken;
    
    dispatch_once(&AccountHelperToken, ^{
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.loginParam = nil;
    });
    
    return sharedInstance;
}

- (void)initWithAppid:(int)appid accountType:(int)accountType appVersion:(NSString *)appVersion hostIp:(NSString *)hostIp hostPort:(int)hostPort localId:(int)localId countryId:(int)countryId {
    tlsLoginHelper = [[TLSLoginHelper getInstance]init:appid andAccountType:accountType andAppVer:appVersion];
    
    [tlsLoginHelper setLogcat:1];
    [tlsLoginHelper setLocalId:localId];
    
    tlsAccountHelper = [[TLSAccountHelper getInstance]init:appid andAccountType:accountType andAppVer:appVersion];
    [tlsAccountHelper setLocalId:localId];
    [tlsAccountHelper setCountry:countryId];
}

- (TIMLoginParam *)getLoginParam {
    return self.loginParam;
}

- (void)storeLoginParam:(TIMLoginParam *)newParam {
    self.loginParam = newParam;
}

static void (^loginCompletitonHandler)(NSDictionary* data, NSString* err);

- (BOOL)clearUserInfo:(NSString *)userIdentifier {
    return [tlsLoginHelper clearUserInfo:userIdentifier withOption:YES];
}

static void (^regAskCodeCompletitonHandler)(int data, NSString* err);
- (void)regAskCode:cellphoneNumber completionHandler:(void (^)(int data, NSString* err)) handler {
    regAskCodeCompletitonHandler = handler;
    [tlsAccountHelper TLSPwdRegAskCode:cellphoneNumber andTLSPwdRegListener:self];
}

static void (^regReaskCodeCompletitonHandler)(int data, NSString* err);
- (void)regReaskCode:(void (^)(int data, NSString* err)) handler {
    regReaskCodeCompletitonHandler = handler;
    [tlsAccountHelper TLSPwdRegReaskCode:self];
}

static void (^registerCompletionHandler)(NSArray *data, NSString *err);
static NSString *tlsRegPassword;
- (void)register:(NSString *)askCode password:(NSString *)password completionHandler:(void (^)(NSArray *data, NSString *err))handler {
    registerCompletionHandler = handler;
    tlsRegPassword = password;
    [tlsAccountHelper TLSPwdRegVerifyCode:askCode andTLSPwdRegListener:self];
}

static void (^smsRegAskCodeCompletitonHandler)(int data, NSString* err);
- (void)smsRegAskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int, NSString *))handler {
    smsRegAskCodeCompletitonHandler = handler;
    [tlsAccountHelper TLSSmsRegAskCode:cellphoneNumber andTLSSmsRegListener:self];
}

static void (^smsRegReaskCodeCompletitonHandler)(int data, NSString* err);
- (void)smsRegReaskCode:(void (^)(int, NSString *))handler {
    smsRegReaskCodeCompletitonHandler = handler;
    [tlsAccountHelper TLSSmsRegReaskCode:self];
}

static void (^smsRegisterCompletionHandler)(NSArray *data, NSString *err);
- (void)smsRegister:(NSString *)askCode completionHandler:(void (^)(NSArray *, NSString *))handler {
    smsRegisterCompletionHandler = handler;
    [tlsAccountHelper TLSSmsRegVerifyCode:askCode andTLSSmsRegListener:self];
}

static void (^smsLoginAskCodeCompletitonHandler)(int data, NSString* error);
- (void)smsLoginAskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int data, NSString* error)) handler{
    smsLoginAskCodeCompletitonHandler = handler;
    [tlsLoginHelper TLSSmsAskCode:cellphoneNumber andTLSSmsLoginListener:self];
}

static void (^smsLoginReaskCodeCompletitonHandler)(int data, NSString* err);
- (void)smsLoginReaskCode:(NSString*)cellphoneNumber completionHandler:(void (^)(int, NSString *))handler {
    smsLoginReaskCodeCompletitonHandler = handler;
    [tlsLoginHelper TLSSmsReaskCode:cellphoneNumber andTLSSmsLoginListener:self];
}

static NSString *smsLoginCellphoneNumber;
static void (^smsLoginCompletitonHandler)(NSDictionary* data, NSString* err);
- (void)smsLogin:(NSString *)cellphoneNumber askCode:(NSString *)askCode completionHandler:(void (^)(NSDictionary *data, NSString *err))handler {
    int retValue;
    smsLoginCompletitonHandler = handler;
    retValue = [tlsLoginHelper TLSSmsVerifyCode:cellphoneNumber andCode:askCode andTLSSmsLoginListener:self];
    smsLoginCellphoneNumber = cellphoneNumber;
    if (retValue != TLS_LOGIN_SUCCESS)
    {
        TDDLogEvent(@"TLSPwdLogin ret: %d", retValue);
        return;
    }else
    {
        TDDLogEvent(@"TLSPwdLogin ok: %d", retValue);
    }
}

#pragma mark - delegate<TLSPwdLoginListener>
- (void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo
{
    TDDLogEvent(@"OnPwdLoginSuccess: %@", userInfo);
    NSMutableDictionary *retData = [[NSMutableDictionary alloc] init];
    
    [retData setObject:userInfo.identifier forKey:@"Identifier"];
    [retData setObject:([tlsLoginHelper getTLSUserSig:userInfo.identifier]) ? [tlsLoginHelper getTLSUserSig:userInfo.identifier] : @"default_userSig" forKey:@"userSig"];
    
    //登录sdk ....
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    login_param.identifier = userInfo.identifier;
    //用户账号体系验证生成的密钥串
    login_param.userSig = ([tlsLoginHelper getTLSUserSig:userInfo.identifier]) ? [tlsLoginHelper getTLSUserSig:userInfo.identifier] : @"default_userSig";
    //test end
    
    login_param.appidAt3rd = [@kTLSAppid stringValue];
    login_param.accountType = [NSString stringWithFormat:@"%d", kSdkAccountType];
    login_param.sdkAppId = kSdkAppId;
    
    [[TIMManager sharedInstance] login: login_param succ:^(){
        TDDLogEvent(@"login sucess");
        
        [self storeLoginParam:login_param];
        
        loginCompletitonHandler((NSDictionary *)retData, nil);
        loginCompletitonHandler = nil;
        
    } fail:^(int code, NSString * err) {
        TDDLogEvent(@"login failed: code=%d err=%@", code, err);
        if (code == DING_HAO_ERR) {
            [self clearUserInfo:userInfo.identifier];
            loginCompletitonHandler(@{@"ErrType":@DING_HAO_ERR}, [NSString stringWithFormat:@"%d->%@", code, ERRORCODE_TO_ERRORDEC(code)]);
            loginCompletitonHandler = nil;
            return;
        }
        
        loginCompletitonHandler(nil, [NSString stringWithFormat:@"%d->%@", code, ERRORCODE_TO_ERRORDEC(code)]);
        loginCompletitonHandler = nil;
    }];
}

- (void)OnPwdLoginFail:(TLSErrInfo *)errMsg
{
    TDDLogEvent(@"OnPwdLoginFail: %@", errMsg);
    if (errMsg.sErrorMsg != nil) {
        loginCompletitonHandler(nil, errMsg.sErrorMsg);
    } else {
        loginCompletitonHandler(nil, errMsg.description);
    }
    loginCompletitonHandler = nil;
}

- (void)OnPwdLoginTimeout:(TLSErrInfo *)errMsg
{
    TDDLogEvent(@"OnPwdLoginTimeout: %@", errMsg);
    if (errMsg.sErrorMsg != nil) {
        loginCompletitonHandler(nil, errMsg.sErrorMsg);
    } else {
        loginCompletitonHandler(nil, errMsg.description);
    }
    loginCompletitonHandler = nil;
}

- (void)OnPwdLoginNeedImgcode:(NSData *)pictureData andErrInfo:(TLSErrInfo *)errInfo
{
    TDDLogEvent(@"OnPwdLoginNeedImgcode: %@", errInfo);
    if (errInfo.sErrorMsg != nil) {
        loginCompletitonHandler(nil, errInfo.sErrorMsg);
    } else {
        loginCompletitonHandler(nil, errInfo.description);
    }
    loginCompletitonHandler = nil;
}

-(void)	OnPwdLoginReaskImgcodeSuccess:(NSData *)picData{

}

#pragma mark - delegate<TLSPwdRegListener>
- (void)OnPwdRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration {
    TDDLogEvent(@"OnPwdRegAskCodeSuccess");
    regAskCodeCompletitonHandler(reaskDuration, nil);
    regAskCodeCompletitonHandler = nil;
}

- (void)OnPwdRegReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    TDDLogEvent(@"OnPwdRegReaskCodeSuccess");
    regReaskCodeCompletitonHandler(reaskDuration, nil);
    regReaskCodeCompletitonHandler = nil;
}

- (void)OnPwdRegVerifyCodeSuccess {
    TDDLogEvent(@"OnPwdRegVerifyCodeSuccess");
    [tlsAccountHelper TLSPwdRegCommit:tlsRegPassword andTLSPwdRegListener:self];
    tlsRegPassword = nil;
}

- (void)OnPwdRegCommitSuccess:(TLSUserInfo *)userInfo {
    TDDLogEvent(@"OnPwdRegCommitSuccess");
    registerCompletionHandler(nil, nil);
    registerCompletionHandler = nil;
}

- (void)OnPwdRegFail:(TLSErrInfo *) errInfo {
    TDDLogEvent(@"OnPwdRegFail: %@", errInfo);
    if (regAskCodeCompletitonHandler) {
        regAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        regAskCodeCompletitonHandler = nil;
    }
    if (regReaskCodeCompletitonHandler) {
        regReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        regReaskCodeCompletitonHandler = nil;
    }
    if (registerCompletionHandler) {
        registerCompletionHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        registerCompletionHandler = nil;
    }
    if (tlsRegPassword) {
        tlsRegPassword = nil;
    }
}

- (void)OnPwdRegTimeout:(TLSErrInfo *) errInfo {
    TDDLogEvent(@"OnPwdRegTimeout");
    if (regAskCodeCompletitonHandler) {
        regAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        regAskCodeCompletitonHandler = nil;
    }
    if (regReaskCodeCompletitonHandler) {
        regReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        regReaskCodeCompletitonHandler = nil;
    }
    if (registerCompletionHandler) {
        registerCompletionHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        registerCompletionHandler = nil;
    }
    if (tlsRegPassword) {
        tlsRegPassword = nil;
    }
}


#pragma mark - delegate<TLSSmsRegListener>
-(void)	OnSmsRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration {
    TDDLogEvent(@"OnSmsRegAskCodeSuccess");
    smsRegAskCodeCompletitonHandler(reaskDuration, nil);
    smsRegAskCodeCompletitonHandler = nil;
}

-(void)	OnSmsRegReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    TDDLogEvent(@"OnPSmsRegReaskCodeSuccess");
    smsRegReaskCodeCompletitonHandler(reaskDuration, nil);
    smsRegReaskCodeCompletitonHandler = nil;
}

-(void)	OnSmsRegVerifyCodeSuccess; {
    TDDLogEvent(@"OnSmsRegVerifyCodeSuccess");
    [tlsAccountHelper TLSSmsRegCommit:self];
}


-(void)	OnSmsRegCommitSuccess:(TLSUserInfo *)userInfo {
    TDDLogEvent(@"OnSmsRegCommitSuccess");
    smsRegisterCompletionHandler(nil, nil);
    smsRegisterCompletionHandler = nil;
}

-(void)	OnSmsRegFail:(TLSErrInfo *) errInfo {
    TDDLogEvent(@"OnSmsRegFail: %@", errInfo);
    if (smsRegAskCodeCompletitonHandler) {
        smsRegAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegAskCodeCompletitonHandler = nil;
    }
    if (smsRegReaskCodeCompletitonHandler) {
        smsRegReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegReaskCodeCompletitonHandler = nil;
    }
    if (smsRegisterCompletionHandler) {
        smsRegisterCompletionHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegisterCompletionHandler = nil;
    }
}

-(void)	OnSmsRegTimeout:(TLSErrInfo *) errInfo {
    TDDLogEvent(@"OnSmsRegTimeout: %@", errInfo);
    if (smsRegAskCodeCompletitonHandler) {
        smsRegAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegAskCodeCompletitonHandler = nil;
    }
    if (smsRegReaskCodeCompletitonHandler) {
        smsRegReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegReaskCodeCompletitonHandler = nil;
    }
    if (smsRegisterCompletionHandler) {
        smsRegisterCompletionHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsRegisterCompletionHandler = nil;
    }
}


#pragma mark - delegate<TLSSmsLoginListener>
-(void) OnSmsLoginAskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    TDDLogEvent(@"OnSmsLoginAskCodeSuccess");
    smsLoginAskCodeCompletitonHandler(reaskDuration, nil);
    smsLoginAskCodeCompletitonHandler = nil;
}

-(void)	OnSmsLoginReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration {
    TDDLogEvent(@"OnSmsLoginReaskCodeSuccess");
    smsLoginReaskCodeCompletitonHandler(reaskDuration, nil);
    smsLoginReaskCodeCompletitonHandler = nil;
}

-(void)	OnSmsLoginVerifyCodeSuccess {
    TDDLogEvent(@"OnSmsLoginVerifyCodeSuccess");
    [tlsLoginHelper TLSSmsLogin:smsLoginCellphoneNumber andTLSSmsLoginListener:self];
    smsLoginCellphoneNumber = nil;
}

-(void)	OnSmsLoginSuccess:(TLSUserInfo *) userInfo {
    TDDLogEvent(@"OnSmsLoginSuccess: %@", userInfo);
    NSMutableDictionary *retData = [[NSMutableDictionary alloc] init];
    [retData setObject:userInfo.identifier forKey:@"Identifier"];
    [retData setObject:([tlsLoginHelper getTLSUserSig:userInfo.identifier]) ? [tlsLoginHelper getTLSUserSig:userInfo.identifier] : @"default_userSig" forKey:@"userSig"];
    
    //登录sdk ....
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    login_param.identifier = userInfo.identifier;
    //用户账号体系验证生成的密钥串
    login_param.userSig = ([tlsLoginHelper getTLSUserSig:userInfo.identifier]) ? [tlsLoginHelper getTLSUserSig:userInfo.identifier] : @"default_userSig";
    //test end
    
    login_param.appidAt3rd = [@kTLSAppid stringValue];
    login_param.accountType = [NSString stringWithFormat:@"%d", kSdkAccountType];
    login_param.sdkAppId = kSdkAppId;
    
    [[TIMManager sharedInstance] login: login_param succ:^(){
        TDDLogEvent(@"login sucess");
        
        [self storeLoginParam:login_param];
        
        smsLoginCompletitonHandler((NSDictionary *)retData, nil);
        smsLoginCompletitonHandler = nil;
        
    } fail:^(int code, NSString * err) {
        TDDLogEvent(@"login failed: code=%d err=%@", code, err);
        if (code == DING_HAO_ERR) {
            [self clearUserInfo:userInfo.identifier];
            smsLoginCompletitonHandler(@{@"ErrType":@DING_HAO_ERR}, [NSString stringWithFormat:@"%d->%@", code, ERRORCODE_TO_ERRORDEC(code)]);
            smsLoginCompletitonHandler = nil;
            return;
        }
        
        smsLoginCompletitonHandler(nil, [NSString stringWithFormat:@"%d->%@", code, ERRORCODE_TO_ERRORDEC(code)]);
        smsLoginCompletitonHandler = nil;
    }];
}

-(void)	OnSmsLoginFail:(TLSErrInfo *) errInfo {
    TDDLogEvent(@"OnSmsRegFail: %@", errInfo);
    if (smsLoginAskCodeCompletitonHandler) {
        smsLoginAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginAskCodeCompletitonHandler = nil;
    }
    if (smsLoginReaskCodeCompletitonHandler) {
        smsLoginReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginReaskCodeCompletitonHandler = nil;
    }
    if (smsLoginCompletitonHandler) {
        smsLoginCompletitonHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginCompletitonHandler = nil;
    }
    if (smsLoginCellphoneNumber) {
        smsLoginCellphoneNumber = nil;
    }
}

-(void)	OnSmsLoginTimeout:(TLSErrInfo *)errInfo {
    TDDLogEvent(@"OnSmsLoginTimeout: %@", errInfo);
    if (smsLoginAskCodeCompletitonHandler) {
        smsLoginAskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginAskCodeCompletitonHandler = nil;
    }
    if (smsLoginReaskCodeCompletitonHandler) {
        smsLoginReaskCodeCompletitonHandler(-1, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginReaskCodeCompletitonHandler = nil;
    }
    if (smsLoginCompletitonHandler) {
        smsLoginCompletitonHandler(nil, (errInfo.sErrorMsg!=nil) ? errInfo.sErrorMsg:errInfo.description);
        smsLoginCompletitonHandler = nil;
    }
    if (smsLoginCellphoneNumber) {
        smsLoginCellphoneNumber = nil;
    }
}


#pragma mark - private methods
@end
