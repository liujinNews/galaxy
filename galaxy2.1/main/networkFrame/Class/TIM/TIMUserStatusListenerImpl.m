//
//  TIMUserStatusListenerImpl.m
//  MyDemo
//
//  Created by tomzhu on 15/6/30.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import "TIMUserStatusListenerImpl.h"
#import "GlobalData.h"
#import "AccountHelper.h"
#import "AppDelegate.h"
#import "MyUtilty.h"

@implementation TIMUserStatusListenerImpl

#pragma mark - Delegate<TIMUserStatusListener>
static bool _isLogined;
- (void)onForceOffline {
    _isLogined = [GlobalData shareInstance].isLogined;
    
    // 删除登录sdk缓存
    NSString *userIdentifier = [GlobalData shareInstance].me;
    
    [[GlobalData shareInstance].accountHelper clearUserInfo:userIdentifier];
    
    // 登出imsdk
    [[TIMManager sharedInstance] logout:^{
        TDDLogEvent(@"logout Succ");
    } fail:^(int code, NSString *err) {
        TDDLogEvent(@"Fail: %d->%@", code, err);
    }];
    
    // 删除全局数据对象
    [GlobalData removeInstance];
    
    // 删除本地登录参数，下次不自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLoginParam];
    if (_isLogined) {
        [self showAlert:@"提示" andMsg:@"该账号已在另一台设备上登录，请重新登录"];
    }
}

#pragma mark - Delegate<>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
#warning dengchu
//    [appDelegate switchToLoginView];
}

#pragma mark - Private Methods
- (void)showAlert:(NSString*)title andMsg:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
}

@end
