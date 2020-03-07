//
//  RootFlowWebViewController.h
//  galaxy
//
//  Created by hfk on 2019/4/28.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Sonic.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootFlowWebViewController : VoiceBaseController<SonicSessionDelegate,UIWebViewDelegate,WKNavigationDelegate,WKScriptMessageHandler,GPClientDelegate>

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *str_flowCode;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) long long clickTime;
@property (nonatomic,weak) JSContext *jscontext;


- (instancetype)initWithUrl:(NSString *)aUrl;

@end

NS_ASSUME_NONNULL_END
