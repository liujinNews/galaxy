//
//  BudgetSettingViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/7/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//
//预算设置、城市级别、审批管理
#import "BudgetSettingViewController.h"

@interface BudgetSettingViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)NSString * paramValue;

@end

@implementation BudgetSettingViewController
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
    if ([self.statusStr isEqualToString:@"budgetSet"]) {
        [self setTitle:Custing(@"预算管理", nil) backButton:YES ];
        self.paramValue = [UrlKeyManager getHelpURL:XB_BudgetSet];
    }else if ([self.statusStr isEqualToString:@"cityLeavel"]){
        [self setTitle:Custing(@"城市级别", nil) backButton:YES ];
        self.paramValue = [UrlKeyManager getHelpURL:XB_CityLevelSet];
    }else if ([self.statusStr isEqualToString:@"approvalAdmin"]){
        [self setTitle:Custing(@"审批管理", nil) backButton:YES ];
        self.paramValue = [UrlKeyManager getHelpURL:XB_ApprovalSet];
    }else if ([self.statusStr isEqualToString:@"HRStandard"]){
        [self setTitle:Custing(@"报销标准", nil) backButton:YES ];
        self.paramValue = [UrlKeyManager getHelpURL:XB_StandardSet];
    }
    
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
    self.webView = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView.progressProxy.webViewProxyDelegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSURL* url = [NSURL URLWithString:self.paramValue];//创建URL
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
