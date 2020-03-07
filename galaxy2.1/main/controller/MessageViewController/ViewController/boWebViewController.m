//
//  boWebViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/5/16.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "boWebViewController.h"

@interface boWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)NSString * paramValue;


@end

@implementation boWebViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.paramValue = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString isEqualToNull:_str_title]) {
        [self setTitle:_str_title backButton:YES];
    }else{
        [self setTitle:@"小喜鹊动态" backButton:YES];
    }
    
    self.webView = [[NJKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _webView.progressProxy.webViewProxyDelegate = self;
    
    NSURL* url = [NSURL URLWithString:self.paramValue];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
//    [self loadJson];
    // Do any additional setup after loading the view.
}

-(void)dealloc {
    self.webView.delegate = nil;
}
//
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"erros is %@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"hello");
    [[GPAlertView sharedAlertView]stopAnimating];
    
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
