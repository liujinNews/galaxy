//
//  RootFlowWebViewController.m
//  galaxy
//
//  Created by hfk on 2019/4/28.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "RootFlowWebViewController.h"
#import "SonicJSContext.h"

@interface RootFlowWebViewController ()

@property (nonatomic,copy) NSString *str_requestor;

@property (nonatomic,strong)SonicJSContext *sonicContext;

@property (nonatomic,assign)BOOL isStandSonic;

/** 添加 progressView 属性*/
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation RootFlowWebViewController

- (instancetype)initWithUrl:(NSString *)aUrl{
    
    if (self = [super init]) {
        
        self.url = aUrl;
        
        self.clickTime = (long long)([[NSDate date]timeIntervalSince1970]*1000);
        
        SonicSessionConfiguration *configuration = [SonicSessionConfiguration new];
        NSString *linkValue = @"http://assets.kgc.cn/ff7f069b/css/common-min.www.kgc.css?v=e4ecfe82;http://assets.kgc.cn/ff7f069b/css/themes.www.kgc.css?v=612eb426;http://assets.kgc.cn/ff7f069b/css/style.www.kgc.css?v=05d94f84";
        configuration.customResponseHeaders = @{
                                                SonicHeaderKeyCacheOffline:SonicHeaderValueCacheOfflineStore,
                                                SonicHeaderKeyLink:linkValue
                                                };
        configuration.enableLocalServer = YES;
        configuration.supportCacheControl = YES;
//        [[SonicEngine sharedEngine] createSessionWithUrl:self.url withWebDelegate:self withConfiguration:configuration];
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_form_TextFieldBackgroundColor;

    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"iOSExit"];
    [userContentController addScriptMessageHandler:self name:@"iOSGoToPush"];

    // WKWebView的配置
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;

    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StateBarHeight);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    //  将 progressView 添加到父视图
    [self.view addSubview:self.progressView];

    // 使用 KVO 注册观察者
    // 监听 WKWebView 对象的 estimatedProgress 属性，就是当前网页加载的进度
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];

    
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    SonicSession* session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
    if (session) {
        [self.webView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:request]];
    }else{
        [self.webView loadRequest:request];
    }
    self.sonicContext = [[SonicJSContext alloc]init];
    self.sonicContext.owner = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
/**
  初始化progressView
 
 @return 返回初始化后的进度条视图
 */
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect sreenBounds = [[UIScreen mainScreen] bounds];
        CGRect progressViewFrame = CGRectMake(0, NavigationbarHeight, sreenBounds.size.width, 1);
        _progressView = [[UIProgressView alloc] initWithFrame:progressViewFrame];
        // 设置进度条色调
        _progressView.tintColor = Color_Blue_Important_20;
        // 设置进度条跟踪色调
        _progressView.trackTintColor = Color_form_TextFieldBackgroundColor;
    }
    return _progressView;
}

- (void)dealloc{
//    // 移除观察者
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.sonicContext = nil;
    [[SonicEngine sharedEngine] removeSessionWithWebDelegate:self];
}
//MARK: KVO
//  接收变更后的通知，计算 webView 的进度条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
        
        if (self.progressView.progress == 1) {
            /*
             * 添加一个简单的动画，将 progressView 的 Height 变为1.5倍
             * 动画时长0.25s，延时0.3s后开始动画
             * 动画结束后将 progressView 隐藏
             */
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
        
    }else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"iOSExit"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"iOSGoToPush"]){
        if (![message.body isKindOfClass:[NSDictionary class]]) {
            return;
        }
        self.str_requestor = message.body[@"requestor"];
        [self GoToPushWithTaskId:[NSString stringWithFormat:@"%@",message.body[@"taskId"]]];
    }
}
#pragma mark - wkWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//  页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    // 防止 progressView 被网页挡住
    [self.view bringSubviewToFront:self.progressView];

}
//  当web内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
//  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [YXSpritesLoadingView dismiss];
    
}
//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error:%@",error.localizedDescription);
    self.progressView.hidden = YES;
    
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",error] duration:2.0];
}
//web视图导航过程中发生错误时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error:%@",error.localizedDescription);
    self.progressView.hidden = YES;
    // 如果请求被取消
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",error] duration:2.0];

}
// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    self.progressView.hidden = YES;
    [YXSpritesLoadingView dismiss];

}
#pragma mark - Sonic Session Delegate
- (void)sessionWillRequest:(SonicSession *)session{
    //可以在请求发起前同步Cookie等信息
}
- (void)session:(SonicSession *)session requireWebViewReload:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}

//MARK:打印链接
-(void)GoToPushWithTaskId:(NSString *)taskId{
    NSDictionary *parameters = @{@"TaskId":taskId
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:GETPrintLink Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 10:
        {
            NSDictionary *dict = responceDic[@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                     @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                     @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                     @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                     @"flowCode":self.str_flowCode,
                                                                     @"requestor":self.str_requestor
                                                                     }]];
            }
        }
            break;
        default:
            break;
    }
    
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
