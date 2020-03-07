//
//  newbieWebViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/7/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "newbieWebViewController.h"

@interface newbieWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)NSString * statusStr;
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)NSString * parmentStr;
@property(nonatomic,strong)NSDictionary * managementDict;
@end

@implementation newbieWebViewController

-(id)initWithType:(NSString *)type management:(NSDictionary *)managementDict{
    self = [super init];
    if (self) {
        self.statusStr = type;
        self.managementDict = managementDict;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.statusStr isEqualToString:@"management"]){
        NSString * titleStr = self.managementDict[@"managementType"];
        if ([NSString isEqualToNull:titleStr]) {
            [self setTitle:titleStr backButton:YES];
        }
        NSString * urlStr = self.managementDict[@"managementUrl"];
        if ([NSString isEqualToNull:urlStr]) {
            self.parmentStr = urlStr;
        }
    
    }else if ([self.statusStr isEqualToString:@"newbie"]){
        NSString * titleStr = self.managementDict[@"newbieName"];
        if ([NSString isEqualToNull:titleStr]) {
            [self setTitle:titleStr backButton:YES];
        }
        NSString * urlStr = self.managementDict[@"newbieUrl"];
        if ([NSString isEqualToNull:urlStr]) {
            self.parmentStr = urlStr;
        }
        
    }
    
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
    self.webView = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView.progressProxy.webViewProxyDelegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSURL* url = [NSURL URLWithString:self.parmentStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc {
    self.webView.progressProxy.webViewProxyDelegate = nil;
}
//
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"erros is %@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"hello");
    
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
