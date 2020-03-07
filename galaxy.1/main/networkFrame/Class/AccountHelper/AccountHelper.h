//
//  AccountHelper.h
//  MyDemo
//
//  Created by tomzhu on 15/6/11.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "TLSSDK/TLSAccountHelper.h"
#import "TLSSDK/TLSPwdRegListener.h"
#import "TLSSDK/TLSLoginHelper.h"

/// 注册类别
typedef enum _TLS_REG_TYPE{
    TLS_REG_PHONE = 0x1,       //手机号注册
    TLS_RESET_PHONE = 0x4,      //重置手机帐号密码
    TLS_REG_NO_PWD_PHONE = 0x5, //无密码注册手机号码
} TLS_REG_TYPE;

@interface AccountHelper : NSObject<TLSPwdRegListener, TLSPwdLoginListener, TLSSmsRegListener, TLSSmsLoginListener> {
}
+ (instancetype)sharedInstance;

- (void)initWithAppid:(int)appid accountType:(int)accountType appVersion:(NSString *)appVersion hostIp:(NSString *)hostIp hostPort:(int)hostPort localId:(int)localId countryId:(int)countryId;

- (BOOL)clearUserInfo:(NSString *)userIdentifier;

- (void)regAskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int data, NSString* error)) handler;

- (void)regReaskCode:(void (^)(int data, NSString* error)) handler;

- (void)register:(NSString *)askCode password:(NSString *)password completionHandler:(void (^)(NSArray *data, NSString *err))handler;

- (void)smsRegAskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int data, NSString* error)) handler;

- (void)smsRegReaskCode:(void (^)(int data, NSString* error)) handler;

- (void)smsRegister:(NSString *)askCode completionHandler:(void (^)(NSArray *data, NSString *err))handler;

- (void)smsLoginAskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int data, NSString* error)) handler;

- (void)smsLoginReaskCode:(NSString *)cellphoneNumber completionHandler:(void (^)(int data, NSString* error)) handler;

- (void)smsLogin:(NSString *)cellphoneNumber askCode:(NSString *)askCode completionHandler:(void (^)(NSDictionary *data, NSString *err))handler;

- (TIMLoginParam *)getLoginParam;

@end
