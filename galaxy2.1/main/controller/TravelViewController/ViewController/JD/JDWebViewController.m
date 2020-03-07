//
//  JDWebViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "JDWebViewController.h"

@interface JDWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NJKWebView *webView;
@property (nonatomic, assign) int loadNumber;
@end

@implementation JDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:Custing(@"京东", nil) backButton:YES];
    _loadNumber = 0;
    _webView = [[NJKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _webView.progressProxy.webViewProxyDelegate = self;
    NSString *urlStr;
    if (_type==6) {
        urlStr = [NSString stringWithFormat:@"http://m.jd.com"];
    }else{
        urlStr = [NSString stringWithFormat:@"http://so.m.jd.com/category/all.html"];
    }
//    if (_type == 1) {
//        urlStr = @"http://10.1.2.230:8000/";
//    }else{
//        urlStr = @"http://10.1.2.230:3000/home/form/CashAdvance/234444";
//    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_loadNumber==0) {
        if (_type!=6) {
            int v= arc4random() % 10000;
            NSString *js = [NSString stringWithFormat:@"var newscript = document.createElement(\"script\"); newscript.src=\"https://help.xibaoxiao.com/js/jd.js?v=%d\";newscript.onload=function(){completeLoading(%d);};document.body.appendChild(newscript);",v,_type];
            
            [self.webView stringByEvaluatingJavaScriptFromString:js];
        }
    }
    _loadNumber ++;
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
