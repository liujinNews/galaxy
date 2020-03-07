//
//  PDFLookViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "PDFLookViewController.h"
#import <WebKit/WebKit.h>

@interface PDFLookViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) NJKWebView * webView;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation PDFLookViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_hasBack) {
        [self setTitle:Custing(@"文件", nil) backButton:NO];
        [self createOtherBack];
    }else{
        [self setTitle:Custing(@"文件", nil) backButton:YES];
    }
    [self CreateWebView];
}

-(void)createOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
    [leftbtn addTarget:self action:@selector(dismissModalVC) forControlEvents:UIControlEventTouchUpInside];
    if (self.userdatas.SystemType==1) {
        [leftbtn setImage:[[UIImage imageNamed:@"Share_AgentGoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [leftbtn setImage:[[UIImage imageNamed:@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    UIBarButtonItem* leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leBtn;
}
- (void)dismissModalVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK:创建webview
-(void)CreateWebView{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 1)];
    progressView.tintColor =Color_Blue_Important_20;
    progressView.trackTintColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    //    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = Color_form_TextFieldBackgroundColor;
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    _url = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [wkWebView loadRequest:request];

    self.wkWebView = wkWebView;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - webView代理
// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount--;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadCount--;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

