//
//  FPTInvoiceController.m
//  galaxy
//
//  Created by hfk on 2019/3/27.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FPTInvoiceController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Sonic.h"
#import <WebKit/WebKit.h>

@interface FPTInvoiceController ()<SonicSessionDelegate,UIWebViewDelegate,WKNavigationDelegate,WKScriptMessageHandler,GPClientDelegate>

@property (nonatomic,copy) NSString *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) long long clickTime;
@property (nonatomic, strong) NSDictionary *dict_js;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation FPTInvoiceController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInvoicePhotoInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)getInvoicePhotoInfo{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSMutableArray *loadImageArray = [NSMutableArray array];
    for (int i=0; i < self.arr_InvoicePhoto.count; i++) {
        id asset = self.arr_InvoicePhoto[i];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            [loadImageArray addObject:[[asset originImage]dataSmallerThan:1024 * 20000]];
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            [loadImageArray addObject:[[asset photoImage]dataSmallerThan:1024 * 20000]];
        }
    }
    if (loadImageArray.count != 0) {
        //图片上传处理
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *name = [pickerFormatter stringFromDate:pickerDate];
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
        name = [name stringByReplacingOccurrencesOfString:@"-" withString:@""];
        name = [name stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSMutableArray *names = [[NSMutableArray alloc]init];
        [names addObject:name];
        [[GPClient shareGPClient]RequestByPostOnImageWithPath:XB_FPInvoiceScan Parameters:nil NSArray:loadImageArray name:names type:@"image/png" Delegate:self SerialNum:0 IfUserCache:NO];
    }
}
#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        [YXSpritesLoadingView dismiss];
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            self.dict_js = responceDic;
            [self initWebViewSetting];
            [self CreateWebView];
        }
            break;
        default:
            break;
    }
}
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:初始化webview配置
-(void)initWebViewSetting{
    self.url = [UrlKeyManager getFormH5URL:XB_InvoiceH5];
    self.clickTime = (long long)([[NSDate date]timeIntervalSince1970]*1000);
    
    SonicSessionConfiguration *configuration = [SonicSessionConfiguration new];
    NSString *linkValue = @"http://assets.kgc.cn/ff7f069b/css/common-min.www.kgc.css?v=e4ecfe82;http://assets.kgc.cn/ff7f069b/css/themes.www.kgc.css?v=612eb426;http://assets.kgc.cn/ff7f069b/css/style.www.kgc.css?v=05d94f84";
    configuration.customResponseHeaders = @{
                                            SonicHeaderKeyCacheOffline:SonicHeaderValueCacheOfflineStore,
                                            SonicHeaderKeyLink:linkValue
                                            };
    configuration.enableLocalServer = YES;
    configuration.supportCacheControl = YES;
    [[SonicEngine sharedEngine] createSessionWithUrl:self.url withWebDelegate:self withConfiguration:configuration];
}

//MARK:创建webview
-(void)CreateWebView{
    // js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"iOSExit"];
    
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
    
    [self.view addSubview:self.progressView];

    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    SonicSession* session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
    if (session) {
        [self.webView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:request]];
    }else{
        [self.webView loadRequest:request];
    }
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[SonicEngine sharedEngine] removeSessionWithWebDelegate:self];
}
//MARK: KVO ,接收变更后的通知，计算 webView 的进度条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
        
        if (self.progressView.progress == 1) {
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
//MARK: WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"body:%@",message.body);
        if ([message.name isEqualToString:@"iOSExit"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
}
//MARK:wkWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    // 防止 progressView 被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}
//当web内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [YXSpritesLoadingView dismiss];
    NSString *js = [NSString transformToJsonWithOutEnter:self.dict_js];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getData('%@','%@','%@')",js, self.userdatas.userId,self.userdatas.token] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];    
}
//页面加载失败时调用 ( 【web视图加载内容时】发生错误)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
