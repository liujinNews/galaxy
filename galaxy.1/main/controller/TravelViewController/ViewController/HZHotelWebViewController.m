//
//  HZHotelWebViewController.m
//  galaxy
//
//  Created by hfk on 2019/5/14.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "HZHotelWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Sonic.h"
#import <WebKit/WebKit.h>
#import "SonicJSContext.h"

@interface HZHotelWebViewController ()<GPClientDelegate,SonicSessionDelegate,UIWebViewDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,copy)NSString *srcID;
@property(nonatomic,copy)NSString *vCard;
@property(nonatomic,copy)NSString *secretkey;
@property(nonatomic,copy)NSString *uniqueId;
@property(nonatomic,copy)NSString *travelType;
@property(nonatomic,copy)NSString *occupantNumber;

@property (nonatomic,strong) WKWebView *webView;
/** 添加 progressView 属性*/
@property (nonatomic, strong) UIProgressView *progressView;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;


@end

@implementation HZHotelWebViewController

- (instancetype)init{
    
    if (self = [super init]) {
        
        SonicSessionConfiguration *configuration = [SonicSessionConfiguration new];
        NSString *linkValue = @"http://assets.kgc.cn/ff7f069b/css/common-min.www.kgc.css?v=e4ecfe82;http://assets.kgc.cn/ff7f069b/css/themes.www.kgc.css?v=612eb426;http://assets.kgc.cn/ff7f069b/css/style.www.kgc.css?v=05d94f84";
        configuration.customResponseHeaders = @{
                                                SonicHeaderKeyCacheOffline:SonicHeaderValueCacheOfflineStore,
                                                SonicHeaderKeyLink:linkValue
                                                };
        configuration.enableLocalServer = YES;
        configuration.supportCacheControl = YES;
        [[SonicEngine sharedEngine] createSessionWithUrl:HuaZhuServerTest withWebDelegate:self withConfiguration:configuration];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"华住酒店_", nil) backButton:NO];
    [self setOtherBack];
    [self requestPersonInfo];
}
//MARK:创建返回按钮
-(void)setOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftbtn.titleLabel setFont:Font_Same_14_20];
    [leftbtn addTarget:self action:@selector(WebViewBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[[UIImage imageNamed:self.userdatas.SystemType==1 ? @"Share_AgentGoBack":@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    UIButton* leftbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,30,40)];
    leftbtn2.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn2 addTarget:self action:@selector(WebViewClose:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn2 setTitle:@"关闭" forState:UIControlStateNormal];
    [leftbtn2.titleLabel setFont:Font_Same_14_20];
    [leftbtn setTitleColor:self.userdatas.SystemType==1 ? Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    [leftbtn2 setTitleColor:self.userdatas.SystemType==1 ? Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 forState:UIControlStateNormal];

    UIBarButtonItem *leBtn2 = [[UIBarButtonItem alloc]initWithCustomView:leftbtn2];
    self.navigationItem.leftBarButtonItems =@[leBtn,leBtn2];
}
//MARK:webView返回
-(void)WebViewBack:(UIButton *)btn{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//MARK:webView关闭
-(void)WebViewClose:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:请求华住酒店信息
-(void)requestPersonInfo{
    NSString *url=[NSString stringWithFormat:@"%@",HotelUserInfo];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    _resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    switch (serialNum) {
        case 0:
            [self dealWithDate];
            [self CreateWebView];
            break;
        default:
            break;
    }
    
}
//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:处理数据
-(void)dealWithDate{
    NSDictionary *dict = _resultDict[@"result"];
    if (![dict isKindOfClass:[NSNull class]]) {
//        _idCard=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"idCard"]]]?[NSString stringWithFormat:@"%@",dict[@"idCard"]]:@"";
    }
}
//MARK:创建webview
-(void)CreateWebView{
    
    _srcID = @"HUAZHUOA";
    _vCard = @"VCENTCRM0010434049";
    _secretkey = @"8B145089E1223413";
    _travelType = @"YS";
    _occupantNumber = @"";
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.progressView];
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    pickerFormatter.timeZone = [NSTimeZone localTimeZone];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *Time= [pickerFormatter stringFromDate:pickerDate];
    
    NSString *SecretString = [NSString stringWithFormat:@"%@SrcID=%@&VCard=%@&Time=%@%@",_secretkey,_srcID,_vCard,Time,_secretkey];
    SecretString = [GPUtils escapedQuery:[GPUtils sha256HashFor:SecretString]];
    
    NSString *TravelType = [GPUtils escapedQuery:[GPUtils AES128Encrypt:_travelType key:_secretkey]];
    
    NSString *UniqueId = [GPUtils escapedQuery:[GPUtils AES128Encrypt:_uniqueId key:_secretkey]];
    UniqueId = [GPUtils escapedQuery:@"mO7eE58eyL3mjhDHXJ0XNA=="];
    
    NSString *OccupantNumber = [GPUtils escapedQuery:[GPUtils AES128Encrypt:_occupantNumber key:_secretkey]];
    OccupantNumber = [GPUtils escapedQuery:@"mO7eE58eyL3mjhDHXJ0XNA=="];
    
    NSString *Token = [GPUtils escapedQuery:[GPUtils AES128Encrypt:Time key:_secretkey]];
    
    NSString *post = [NSString stringWithFormat: @"SrcID=%@&Time=%@&VCard=%@&SecretString=%@&TravelType=%@&UniqueId=%@&OccupantNumber=%@&Token=%@",_srcID,Time,_vCard,SecretString,TravelType,UniqueId,OccupantNumber,Token];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:HuaZhuServerTest]];
    [request setHTTPMethod:@"POST"]; [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0]; [request setHTTPBody:postData];
    SonicSession* session = [[SonicEngine sharedEngine] sessionWithWebDelegate:self];
    if (session) {
        [self.webView loadRequest:[SonicUtil sonicWebRequestWithSession:session withOrigin:request]];
    }else{
        [self.webView loadRequest:request];
    }
}

//MARK: KVO
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
//MARK: WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"body:%@",message.body);
    
}
//MARK: wkWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//MARK: 页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
    // 防止 progressView 被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}
//MARK:当web内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
//MARK:页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

}
//MARK:页面加载失败时调用([web视图加载内容时]发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.progressView.hidden = YES;
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",error] duration:2.0];
}
//MARK:web视图导航过程中发生错误时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.progressView.hidden = YES;
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",error] duration:2.0];
    
}
//MARK:当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    self.progressView.hidden = YES;
}
#pragma mark - Sonic Session Delegate
- (void)sessionWillRequest:(SonicSession *)session{
    //可以在请求发起前同步Cookie等信息
}
- (void)session:(SonicSession *)session requireWebViewReload:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
        _progressView.tintColor = Color_Blue_Important_20;
        _progressView.trackTintColor = Color_form_TextFieldBackgroundColor;
    }
    return _progressView;
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[SonicEngine sharedEngine] removeSessionWithWebDelegate:self];
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
