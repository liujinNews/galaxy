//
//  DiDiOrderController.m
//  galaxy
//
//  Created by hfk on 2019/3/20.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "DiDiOrderController.h"

@interface DiDiOrderController ()<UIWebViewDelegate,GPClientDelegate>

@property (nonatomic, strong)NJKWebView * webView;
@property (nonatomic, strong)NSDictionary *resultDict;
@property (nonatomic, copy) NSString *str_fromCityId;
@property (nonatomic, copy) NSString *str_toCityId;
@end

@implementation DiDiOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"滴滴", nil) backButton:NO];
    if (!self.userdatas) {
        self.userdatas = [userData shareUserData];
    }
    [self setOtherBack];
    if (self.model) {
        [self requestCityId];
    }else{
        [self CreateWebView];
    }
}
//MARK:创建返回按钮
-(void)setOtherBack{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftbtn.titleLabel setFont:Font_Same_14_20];
    [leftbtn addTarget:self action:@selector(WebViewBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setImage:[[UIImage imageNamed:self.userdatas.SystemType==1 ? @"Share_AgentGoBack":@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    UIButton* leftbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,30,40)];
    leftbtn2.contentEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [leftbtn2 addTarget:self action:@selector(WebViewClose:) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn2 setTitle:@"关闭" forState:UIControlStateNormal];
    [leftbtn2.titleLabel setFont:Font_Same_14_20];
    [leftbtn setTitleColor:self.userdatas.SystemType==1 ? Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    [leftbtn2 setTitleColor:self.userdatas.SystemType==1 ? Color_form_TextFieldBackgroundColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    
    UIBarButtonItem *leBtn2 = [[UIBarButtonItem alloc]initWithCustomView:leftbtn2];
    self.navigationItem.leftBarButtonItems =@[leBtn,leBtn2];
}

//MARK:城市id
-(void)requestCityId{
    NSString *url = [NSString stringWithFormat:@"%@",GETDIDICITYIDBYCODE];
    NSDictionary *parameters = @{@"FromCode":self.model.FromCityCode,@"ToCode":self.model.ToCityCode};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
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
        {
            if ([_resultDict[@"result"] isKindOfClass:[NSDictionary class]]) {
                self.str_fromCityId = [NSString isEqualToNull:_resultDict[@"result"][@"FromId"]] ? [NSString stringWithFormat:@"%@",_resultDict[@"result"][@"FromId"]]:@"0";
                self.str_toCityId= [NSString isEqualToNull:_resultDict[@"result"][@"ToId"]] ? [NSString stringWithFormat:@"%@",_resultDict[@"result"][@"ToId"]]:@"0";
                [self CreateWebView];
            }
        }
            break;
        default:
            break;
    }
}

//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

//MARK:创建webview
-(void)CreateWebView{
    self.webView = [[NJKWebView alloc]init];
    self.webView.progressProxy.webViewProxyDelegate = self;
    self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    NSString *url = [NSString stringWithFormat:@"%@",DIDILOGIN];
    if (self.model) {
        NSString *lat_from = @"";
        NSString *lng_from = @"";
        NSString *lat_to = @"";
        NSString *lng_to = @"";
        NSArray *arr_from = [self.model.FromLocation componentsSeparatedByString:@","];
        NSArray *arr_to = [self.model.ToLocation componentsSeparatedByString:@","];
        if (arr_from.count == 2) {
            lng_from = arr_from[0];
            lat_from = arr_from[1];
        }
        if (arr_to.count == 2) {
            lng_to = arr_to[0];
            lat_to = arr_to[1];
        }
        url = [NSString stringWithFormat:@"%@?scene_id=1&jumpPage=callCarNow&city_id=%@&lat_from=%@&lng_from=%@&poi_from_name=%@&to_city_id=%@&lat_to=%@&lng_to=%@&poi_to_name=%@",url,self.str_fromCityId,lat_from,lng_from,self.model.Departure,self.str_toCityId,lat_to,lng_to,self.model.Destination];
    }else{
        url = [NSString stringWithFormat:@"%@?scene_id=1",url];
    }
    NSString *encodedString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [request setURL:[NSURL URLWithString:encodedString]];
    [self.webView loadRequest: request];
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
