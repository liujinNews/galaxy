//
//  MicroAppViewController.m
//  galaxy
//
//  Created by hfk on 16/5/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MicroAppViewController.h"
#import "RootTabViewController.h"

@interface MicroAppViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation MicroAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    if (!_isClick) {
        [self getMicroApp];
    }else{
        [self getMicroAppCode];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isClick) {
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }else{
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    }
}
//MARK:获取微应用列表
-(void)getMicroApp{
    NSString *url=[NSString stringWithFormat:@"%@",MicroAppGet];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取微应用Codeu
-(void)getMicroAppCode{
    NSString *url=[NSString stringWithFormat:@"%@",MicroAppGetCode];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            NSMutableArray *workarr = [NSMutableArray array];
            [WorkShowModel getReportFormDataByDictionary:responceDic Array:workarr];
            if (workarr.count>0) {
                _JumpModel = workarr[0];
                [self getMicroAppCode];
            }
        }
            break;
        case 1:
        {
            if (![responceDic isKindOfClass:[NSNull class]]) {
                NSDictionary *dict=responceDic[@"result"];
                if (![dict isKindOfClass:[NSNull class]]) {
                    if ([NSString isEqualToNull:dict[@"result"]]) {
                        _microAppCode=[NSString stringWithFormat:@"%@",dict[@"result"]];
                        [self createWebView];
                    }
                }
            }
        }
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


-(void)createWebView{
    
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    
    NSString *deviceLan = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([deviceLan isEqualToString:@"en-US"]){
        deviceLan = @"en";
    }else if ([deviceLan isEqualToString:@"en"]){
        deviceLan = @"en";
    }
    else if ([deviceLan isEqualToString:@"zh-Hans-CN"]){
        deviceLan = @"ch";
    }else if ([deviceLan isEqualToString:@"zh-Hans-US"]){
        deviceLan = @"ch";
    }
    else if ([deviceLan isEqualToString:@"zh-Hans"]){
        deviceLan = @"ch";
    }
    else if ([deviceLan isEqualToString:@"zh-Hant-CN"]){
        deviceLan = @"ch";
    }
    else if ([deviceLan isEqualToString:@"zh-Hant"]){
        deviceLan = @"ch";
    }
    else if ([deviceLan isEqualToString:@"ja"]){
        deviceLan = @"en";
    }else if ([deviceLan isEqualToString:@""]){
        deviceLan = @"en";
    }
    
    NSString *MicroAppUrl =[NSString stringWithFormat:@"%@?code=%@&lan=%@&deviceType=ios",_JumpModel.appUrl,_microAppCode,deviceLan];
    
    MicroAppUrl = [MicroAppUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:MicroAppUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    if (_isClick) {
        [self.webView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }else{
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(iPhoneX ? @-83:@ -49);
        }];
    }
    
   
}
-(void)returnBack
{
    [super returnBack];
}

-(void)back:(UIButton *)btn{
    [self Navback];
}

-(void)dealloc {
    self.webView.delegate = nil;
}
#pragma mark - 网络代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"erros is %@",error);
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    
    if ([[url scheme] isEqualToString:@"galaxy"]){
        if ([[url host] isEqualToString:@"sys"]){
            NSString *parameterString = [[url relativePath] substringFromIndex:1];
            if ([parameterString isEqualToString:@"exit"]) {
                [self returnBack];
                return NO;
            }
        }
    }
    return YES;
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


