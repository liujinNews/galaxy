//
//  BpmRemindController.m
//  galaxy
//
//  Created by hfk on 16/5/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BpmRemindController.h"

@interface BpmRemindController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation BpmRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([NSString isEqualToNull:_BpmRemindTitle]) {
        [self setTitle:_BpmRemindTitle backButton:YES  ];
    }else{
        [self setTitle:nil backButton:YES  ];
    }
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
    self.webView = [[UIWebView alloc]initWithFrame:webSize];
    self.webView.delegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    NSString *encodedString = [_BpmRemindUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}
-(void)dealloc {
    self.webView.delegate = nil;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"erros is %@",error);
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
