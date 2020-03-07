//
//  TLSUIViewController.h
//  MyDemo
//
//  Created by tomzhu on 15/7/30.
//  Copyright (c) 2015年 sofawang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "TLSUI/TLSUI.h"
#import "TLSSDK/TLSRefreshTicketListener.h"
#import "TLSSDK/TLSOpenLoginListener.h"

@interface MyTLSUIViewController : UIViewController <TencentSessionDelegate, WXApiDelegate, WeiboSDKDelegate, TLSUILoginListener,TLSRefreshTicketListener,TLSOpenLoginListener>

@end