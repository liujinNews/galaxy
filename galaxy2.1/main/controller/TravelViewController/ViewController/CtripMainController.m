//
//  CtripMainController.m
//  galaxy
//
//  Created by hfk on 2016/10/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "CtripMainController.h"

@interface CtripMainController ()<UIWebViewDelegate,GPClientDelegate>
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)NSString * TripType;


/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
@property (nonatomic,strong)NSString *AccessUserId;//单点登录接入账号
@property (nonatomic,strong)NSString *EmployeeId;//员工编号
@property (nonatomic,strong)NSString *Token;//单点登录令牌
@property (nonatomic,strong)NSString *Appid;//公司ID
@property (nonatomic,strong)NSString *EndorsementID;//审批单号
@property (nonatomic,strong)NSString *Signature;//大客户签名
@property (nonatomic,strong)NSString *CtripCorpType;//客户类型区分(0普通1大客户)
@property (nonatomic,strong)NSString *InitPage;//登录成功后的第一个页面
@property (nonatomic,strong)NSString *Callback;//首页
@property (nonatomic,strong)NSString *CostCenter1;//成本中心1
@property (nonatomic,strong)NSString *OnError;//错误处理方式
@end

@implementation CtripMainController
-(id)initWithType:(NSString *)type{
    
    self = [super init];
    if (self) {
        self.TripType=type;
    }
    return self;
}
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
    [self setTitle:Custing(@"携程商旅", nil) backButton:NO];
    if (!self.userdatas) {
        self.userdatas = [userData shareUserData];
    }
    [self setOtherBack];
    [self requestInfo];

}

//MARK:创建返回按钮
-(void)setOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn setTitle:@"关闭" forState:UIControlStateNormal];
    [leftbtn.titleLabel setFont:Font_Same_14_20];
    [leftbtn addTarget:self action:@selector(WebViewBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[[UIImage imageNamed:self.userdatas.SystemType==1 ? @"Share_AgentGoBack":@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    [leftbtn setTitleColor:self.userdatas.SystemType==1 ? Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=leBtn;
}

//MARK:创建webview
-(void)CreateWebView{
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
    self.webView = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView.progressProxy.webViewProxyDelegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSString *post;
    if ([_CtripCorpType floatValue]==0) {
        post = [NSString stringWithFormat: @"AccessUserId=%@&EmployeeId=%@&Token=%@&Appid=%@&EndorsementID=%@&InitPage=%@&Callback=%@&CostCenter1=%@&OnError=%@",_AccessUserId,_EmployeeId,_Token,_Appid,_EndorsementID,_InitPage,_Callback,_CostCenter1,_OnError];
    }else{
        post = [NSString stringWithFormat: @"AccessUserId=%@&EmployeeId=%@&Token=%@&Signature=%@&Appid=%@&EndorsementID=%@&InitPage=%@&Callback=%@&CostCenter1=%@&OnError=%@",_AccessUserId,_EmployeeId,_Token,_Signature,_Appid,_EndorsementID,_InitPage,_Callback,_CostCenter1,_OnError];
    }
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:CtripLogIn]];
    [request setHTTPMethod:@"POST"]; [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0]; [request setHTTPBody:postData];
    [self.webView loadRequest: request];
    [self.view addSubview:self.webView];
}

//MARK:请求Info
-(void)requestInfo{
    NSString *url=[NSString stringWithFormat:@"%@",CtripGetLogin];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
        _AccessUserId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accessUserId"]]]?[NSString stringWithFormat:@"%@",dict[@"accessUserId"]]:@"";
        _EmployeeId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"employeeId"]]]?[NSString stringWithFormat:@"%@",dict[@"employeeId"]]:@"";
        _Token=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"token"]]]?[NSString stringWithFormat:@"%@",dict[@"token"]]:@"";
        _Appid=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"appid"]]]?[NSString stringWithFormat:@"%@",dict[@"appid"]]:@"";
        _Signature=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"signature"]]]?[NSString stringWithFormat:@"%@",dict[@"signature"]]:@"";
        _CtripCorpType=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"ctripCorpType"]]]?[NSString stringWithFormat:@"%@",dict[@"ctripCorpType"]]:@"0";
        _EndorsementID=@"";
        _InitPage=self.TripType;
        _Callback=@"https://ct.ctrip.com/m";
        _CostCenter1=@"";
        _OnError=@"";
    }
}
//MARK:webView返回
-(void)WebViewBack:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
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
