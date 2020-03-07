//
//  PdfReadViewController.m
//  galaxy
//
//  Created by hfk on 2016/12/26.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PdfReadViewController.h"
#import <WebKit/WebKit.h>
@interface PdfReadViewController ()<WKNavigationDelegate>
@property (nonatomic,strong)NJKWebView * webView;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
@property (strong, nonatomic) WKWebView *wkWebView;
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation PdfReadViewController
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
    [self setTitle:Custing(@"电子发票", nil) backButton:YES];
    if ([NSString isEqualToNull:_PdfUrl]) {
        [self CreateWebView];
    }else{
        [self requestElectronicInfo];
    }
}

//MARK:ElectronicInfo
-(void)requestElectronicInfo{
    NSString *url;
    NSDictionary *parameters;
    if (_AddModel) {
        if ([[NSString stringWithFormat:@"%@",_AddModel.fP_ActTyp]isEqualToString:@"1"]) {
            url=[NSString stringWithFormat:@"%@",GETPersonalPDF];
            parameters = @{@"AccountType":@"",@"AccountNo":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.accountNo]]?[NSString stringWithFormat:@"%@",_AddModel.accountNo]:@"",@"FP_DM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.fP_DM]]?[NSString stringWithFormat:@"%@",_AddModel.fP_DM]:@"",@"FP_HM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.fP_HM]]?[NSString stringWithFormat:@"%@",_AddModel.fP_HM]:@""};
        }else if ([[NSString stringWithFormat:@"%@",_AddModel.fP_ActTyp]isEqualToString:@"2"]){
            url=[NSString stringWithFormat:@"%@",GETCompanyPDF];
            parameters = @{@"FP_DM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.fP_DM]]?[NSString stringWithFormat:@"%@",_AddModel.fP_DM]:@"",@"FP_HM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.fP_HM]]?[NSString stringWithFormat:@"%@",_AddModel.fP_HM]:@"",@"SPSQM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_AddModel.spsqm]]?[NSString stringWithFormat:@"%@",_AddModel.spsqm]:@""};
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"链接错误", nil) duration:2.0];
            return;
        }
    }else{
        if ([[NSString stringWithFormat:@"%@",_CheckAddModel.fP_ActTyp]isEqualToString:@"1"]) {
            url=[NSString stringWithFormat:@"%@",GETPersonalPDF];
              parameters= @{@"AccountType":@"",@"AccountNo":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.accountNo]]?[NSString stringWithFormat:@"%@",_CheckAddModel.accountNo]:@"",@"FP_DM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.fP_DM]]?[NSString stringWithFormat:@"%@",_CheckAddModel.fP_DM]:@"",@"FP_HM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.fP_HM]]?[NSString stringWithFormat:@"%@",_CheckAddModel.fP_HM]:@""};
        }else if ([[NSString stringWithFormat:@"%@",_CheckAddModel.fP_ActTyp]isEqualToString:@"2"]){
            url=[NSString stringWithFormat:@"%@",GETCompanyPDF];
              parameters= @{@"SPSQM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.spsqm]]?[NSString stringWithFormat:@"%@",_CheckAddModel.spsqm]:@"",@"FP_DM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.fP_DM]]?[NSString stringWithFormat:@"%@",_CheckAddModel.fP_DM]:@"",@"FP_HM":[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_CheckAddModel.fP_HM]]?[NSString stringWithFormat:@"%@",_CheckAddModel.fP_HM]:@""};

        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"链接错误", nil) duration:2.0];
            return;
        }
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
//    NSLog(@"resDic:%@",responceDic);
//    //临时解析用的数据
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
//    NSLog(@"string%@",stri);
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

//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:处理数据
-(void)dealWithDate{
    NSDictionary *dict = (NSDictionary *)[NSString transformToObj:[_resultDict objectForKey:@"result"]];
    NSLog(@"%@",dict);
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict [@"filepath"]]]) {
        _PdfUrl=[NSString stringWithFormat:@"%@",dict [@"filepath"]];
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"链接错误", nil) duration:2.0];
        return;
    }    
}
//MARK:创建webview
-(void)CreateWebView{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 1)];
    progressView.tintColor =Color_Blue_Important_20;
    progressView.trackTintColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = Color_form_TextFieldBackgroundColor;
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSString *uStr = [NSString stringWithFormat:@"%@",_PdfUrl];
    NSString *urlStr = [uStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [wkWebView loadRequest:request];
    self.wkWebView = wkWebView;
//    [self.wkWebView loadHTMLString:_PdfUrl baseURL:[NSURL URLWithString:_PdfUrl]];
}
#pragma mark - wkWebView代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    //    如果是跳转一个新页面
//    if (navigationAction.targetFrame == nil) {
//        [webView loadRequest:navigationAction.request];
//    }

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
