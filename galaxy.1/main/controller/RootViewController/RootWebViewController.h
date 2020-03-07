//
//  RootWebViewController.h
//  galaxy
//
//  Created by hfk on 2019/8/13.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Sonic.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootWebViewController : VoiceBaseController<SonicSessionDelegate,UIWebViewDelegate,WKNavigationDelegate,WKScriptMessageHandler,GPClientDelegate>

@property (nonatomic,copy) NSString *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSDictionary *Parameters;
@property (nonatomic, assign) long long clickTime;
@property (nonatomic, copy) NSString *token;

- (instancetype)initWithUrl:(NSString *)aUrl;

@end

NS_ASSUME_NONNULL_END
