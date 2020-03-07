//
//  hotelVController.m
//  galaxy
//
//  Created by 赵碚 on 15/7/28.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "hotelVController.h"

@interface hotelVController ()<UIWebViewDelegate,GPClientDelegate>
@property(nonatomic,strong)UILabel * addL;
@property(nonatomic,strong)UITextField * addTF;
@property(nonatomic,strong)UIButton * locationBtn;
@property(nonatomic,strong)UIView * dataView;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)NSMutableArray * meItemArray;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
@end

@implementation hotelVController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}
////MARK:待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:Custing(@"华住酒店_", nil) backButton:NO];
    if (!self.userdatas) {
        self.userdatas = [userData shareUserData];
    }
    _userId =self.userdatas.userId;
    [self setOtherBack];
    [self requestPersonInfo];
    
}
//MARK:创建webview
-(void)CreateWebView{
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
    self.webView = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView.progressProxy.webViewProxyDelegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    pickerFormatter.timeZone = [NSTimeZone localTimeZone];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss:sss"];
    NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
    currStr=[currStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *hotolUrl=[NSString stringWithFormat:@"%@%@",HuaZhuServer,HotelUrl];
    NSString *baseUrl=[NSString stringWithFormat:@"%@/?SrcID=%@&VCard=%@&Time=%@",hotolUrl,_srcID,_vCardID,currStr];

    NSString *result1=[GPUtils AES128Encrypt:_employeeName key:_secretkey];
    NSString *result2 =[GPUtils AES128Encrypt:_idCard key:_secretkey];
    NSString *secrect=[NSString stringWithFormat:@"%@SrcID=%@&VCard=%@&Time=%@%@",_secretkey,_srcID,_vCardID,currStr,_secretkey];
    NSString *result3=[GPUtils sha256HashFor:secrect];
    NSString *result4=[GPUtils AES128Encrypt:self.userdatas.logName key:_secretkey];
    NSString *result5=[GPUtils AES128Encrypt:_uniqueId key:_secretkey];

    result1=[GPUtils escapedQuery:result1];
    result2=[GPUtils escapedQuery:result2];
    result3=[GPUtils escapedQuery:result3];
    result4=[GPUtils escapedQuery:result4];
    result5=[GPUtils escapedQuery:result5];

    NSString *post = [NSString stringWithFormat: @"EmployeeName=%@&IDCard=%@&SecretString=%@&Mobile=%@&UniqueId=%@",result1,result2,result3,result4,result5];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];

    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:baseUrl]];
    [request setHTTPMethod:@"POST"]; [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0]; [request setHTTPBody:postData];
    [self.webView loadRequest: request];
    [self.view addSubview:self.webView];
}
//MARK:请求消费总额
-(void)requestPersonInfo{
    NSString *url=[NSString stringWithFormat:@"%@",HotelUserInfo];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
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
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:处理数据
-(void)dealWithDate{
    NSDictionary *dict=_resultDict[@"result"];
    if (![dict isKindOfClass:[NSNull class]]) {
        _employeeName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"employeeName"]]]?[NSString stringWithFormat:@"%@",dict[@"employeeName"]]:@"";
        _idCard=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"idCard"]]]?[NSString stringWithFormat:@"%@",dict[@"idCard"]]:@"";
        _secretkey=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"secretkey"]]]?[NSString stringWithFormat:@"%@",dict[@"secretkey"]]:@"";
        _srcID=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"srcID"]]]?[NSString stringWithFormat:@"%@",dict[@"srcID"]]:@"";
        _uniqueId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"uniqueId"]]]?[NSString stringWithFormat:@"%@",dict[@"uniqueId"]]:@"";
        _vCardID=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"vCardID"]]]?[NSString stringWithFormat:@"%@",dict[@"vCardID"]]:@"";
    }
}

//MARK:创建返回按钮
-(void)setOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftbtn.titleLabel setFont:Font_Same_14_20];
    [leftbtn addTarget:self action:@selector(WebViewBack:) forControlEvents:UIControlEventTouchUpInside];
    if (self.userdatas.SystemType==1) {
        [leftbtn setImage:[[UIImage imageNamed:@"Share_AgentGoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [leftbtn setImage:[[UIImage imageNamed:@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    UIButton* leftbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,30,40)];
    leftbtn2.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn2 addTarget:self action:@selector(WebViewClose:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn2 setTitle:@"关闭" forState:UIControlStateNormal];
    [leftbtn2.titleLabel setFont:Font_Same_14_20];
    if (self.userdatas.SystemType==1) {
        [leftbtn setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
        [leftbtn2 setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    }else{
        [leftbtn setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        [leftbtn2 setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    }
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

-(void)dealloc {
    self.webView.delegate = nil;
}
//MARK:webView代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if([error code] == NSURLErrorCancelled)  {
        return;
    }
    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",error] duration:2.0];
    NSLog(@"erros is %@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finish");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    NSString *URLstr=[NSString stringWithFormat:@"%@",url];
    if ([URLstr containsString:@"/Error/NotLogin"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
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
