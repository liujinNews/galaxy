//
//  bwAuthInfoViewController.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "bwInvoiceExaViewController.h"
#import "bwInvoiceElectViewController.h"

#import "XFSegementView.h"
#import "bwAuthInfoViewController.h"

@interface bwAuthInfoViewController ()<UIWebViewDelegate,UITextFieldDelegate,UITextViewDelegate,GPClientDelegate,TouchLabelDelegate>
//@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign)NSInteger segIndex;//分段器当前选择
@property (nonatomic, strong)NSDictionary * electDic;
@property (nonatomic, strong)NJKWebView * webView0;
@property (nonatomic, strong)NJKWebView * webView1;
@property (nonatomic, strong)NSString * systemStr;

@property (nonatomic, strong) UIView *root_View;
@property (nonatomic, strong) UIScrollView *scroll_View;
@property (nonatomic, strong) UITextField *txf_commentName;//公司全称
@property (nonatomic, strong) UITextField *txf_PeopleNumber;//纳税人识别号
@property (nonatomic, strong) UITextField *txf_backName;//开户行名称
@property (nonatomic, strong) UITextField *txf_backAccount;//开户行账号
@property (nonatomic, strong) UITextField *txf_commentPhone;//公司电话
@property (nonatomic, strong) UITextView *txv_commentAddress;//公司地址
@property (nonatomic, strong) NSMutableDictionary *dic_request;//提交数据
@end

@implementation bwAuthInfoViewController
-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
        self.electDic = type;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[self.electDic objectForKey:@"list"] isEqualToString:@"info"]) {
        [self setTitle:Custing(@"使用说明", nil) backButton:YES];
        [self createAuthInfoView0:[UrlKeyManager getHelpURL:XB_IFPIns]];
    }else {
        [self setTitle:Custing(@"开通电子发票", nil) backButton:YES];
        if ([[NSString stringWithFormat:@"%@",[[self.electDic objectForKey:@"dict"] objectForKey:@"einvoice"]] isEqualToString:@"0"]) {
            if ([self.userdatas.userRole containsObject:@"7"]) {
                [self createEinvoiceView];
            }else{
                [self createEinvoiceNo];
            }
        }
    }
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    // Do any additional setup after loading the view.
}

#pragma mark - funtion
#define lab_width 100
-(void)createEinvoiceView {
    _scroll_View = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-44)];
    [self.view addSubview:_scroll_View];
    
    _root_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 365)];
    _root_View.backgroundColor = Color_White_Same_20;
    [_scroll_View addSubview:_root_View];
    
    //公司名称
    UIView *view_commentName = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 54)];
    view_commentName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentName addSubview:[self createDownLineView]];
    UILabel *lab_commentName = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"公司全称", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentName.numberOfLines = 0;
    [view_commentName addSubview:lab_commentName];
    _txf_commentName = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入公司全称", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_commentName addSubview:_txf_commentName];
    [_root_View addSubview:view_commentName];
    
    //纳税人识别号
    UIView *view_PeopleNumber = [[UIView alloc]initWithFrame:CGRectMake(0, 54, Main_Screen_Width, 54)];
    view_PeopleNumber.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_PeopleNumber addSubview:[self createLineView]];
    UILabel *lab_peopleNumber = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"纳税人识别号", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_peopleNumber.numberOfLines = 0;
    [view_PeopleNumber addSubview:lab_peopleNumber];
    _txf_PeopleNumber = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入纳税人识别号", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_PeopleNumber addSubview:_txf_PeopleNumber];
    [_root_View addSubview:view_PeopleNumber];
    
    //开户行名称
    UIView *view_backName = [[UIView alloc]initWithFrame:CGRectMake(0, 108, Main_Screen_Width, 54)];
    view_backName.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_backName addSubview:[self createLineView]];
    UILabel *lab_backName = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"开户行名称", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_backName.numberOfLines = 0;
    [view_backName addSubview:lab_backName];
    _txf_backName = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入开户行名称", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_backName addSubview:_txf_backName];
    [_root_View addSubview:view_backName];
    
    //银行账户
    UIView *view_backAccount = [[UIView alloc]initWithFrame:CGRectMake(0, 162, Main_Screen_Width, 54)];
    view_backAccount.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_backAccount addSubview:[self createLineView]];
    [view_backAccount addSubview:[GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"银行账户", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft]];
    _txf_backAccount = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入银行账户", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_backAccount addSubview:_txf_backAccount];
    [_root_View addSubview:view_backAccount];
    
    //公司电话
    UIView *view_commentPhone = [[UIView alloc]initWithFrame:CGRectMake(0, 214, Main_Screen_Width, 54)];
    view_commentPhone.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentPhone addSubview:[self createLineView]];
    UILabel *lab_commentPhone = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"公司电话", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentPhone.numberOfLines = 0;
    [view_commentPhone addSubview:lab_commentPhone];
    _txf_commentPhone = [GPUtils createTextField:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 44) placeholder:Custing(@"请输入公司电话", nil) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    [view_commentPhone addSubview:_txf_commentPhone];
    [_root_View addSubview:view_commentPhone];
    
    //注册地址
    UIView *view_commentAddress = [[UIView alloc]initWithFrame:CGRectMake(0, 270, Main_Screen_Width, 94)];
    view_commentAddress.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view_commentAddress addSubview:[self createLineView]];
    UILabel *lab_commentAddress = [GPUtils createLable:CGRectMake(15, 10, lab_width, 44) text:Custing(@"注册地址", nil) font:Font_Same_14_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_commentAddress.numberOfLines = 0;
    [view_commentAddress addSubview:lab_commentAddress];
    
    _txv_commentAddress = [GPUtils createUITextView:CGRectMake(lab_width+30, 10, Main_Screen_Width-lab_width-30, 84) delegate:self font:Font_Same_14_20 textColor:Color_Black_Important_20];
    _txv_commentAddress.userInteractionEnabled = YES;
    [view_commentAddress addSubview:_txv_commentAddress];
    UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,93.48, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_GrayLight_Same_20;
    [view_commentAddress addSubview:lineDown];
    [_root_View addSubview:view_commentAddress];
    
    
    UIButton *btn_save = [GPUtils createButton:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-44, Main_Screen_Width, 49) action:@selector(btn_click:) delegate:self title:Custing(@"开通", nil) font:Font_Same_14_20 titleColor:Color_form_TextFieldBackgroundColor];
    [btn_save setBackgroundColor:Color_Blue_Important_20];
    [self.view addSubview:btn_save];
    
    _txf_backName.text = [NSString isEqualToNull:self.electDic[@"dict"][@"bankName"]]?self.electDic[@"dict"][@"bankName"]:@"";
    _txf_commentName.text = [NSString isEqualToNull:self.electDic[@"dict"][@"companyName"]]?self.electDic[@"dict"][@"companyName"]:@"";
    _txf_PeopleNumber.text = [NSString isEqualToNull:self.electDic[@"dict"][@"taxpayerId"]]?self.electDic[@"dict"][@"taxpayerId"]:@"";
    _txf_commentPhone.text = [NSString isEqualToNull:self.electDic[@"dict"][@"telephone"]]?self.electDic[@"dict"][@"telephone"]:@"";
    _txv_commentAddress.text = [NSString isEqualToNull:self.electDic[@"dict"][@"address"]]?self.electDic[@"dict"][@"address"]:@"";
    _txf_backAccount.text = [NSString isEqualToNull:self.electDic[@"dict"][@"bankAccount"]]?self.electDic[@"dict"][@"bankAccount"]:@"";

}

-(UIView *)createLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineUp];
    
    UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,9.5, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineDown];
    return view;
}
-(UIView *)createUpLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0.1, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineUp];
    return view;
}
-(UIView *)createDownLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    UIView *lineDown=[[UIView alloc]initWithFrame:CGRectMake(0,9.5, Main_Screen_Width,0.5)];
    lineDown.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineDown];
    
    return view;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![string isEqualToString:@""]) {
        if (textField.text.length>19) {
            if ([textField isEqual:_txf_commentPhone]) {
                return NO;
            }
            if (textField.text.length>29) {
                if ([textField isEqual:_txf_backAccount]) {
                    return NO;
                }
            }
            if (textField.text.length>49) {
                if ([textField isEqual:_txf_commentName]||[textField isEqual:_txf_PeopleNumber]) {
                    return NO;
                }
                if (textField.text.length>99) {
                    if ([textField isEqual:_txf_backName]) {
                        return NO;
                    }
                    if (textField.text.length>199) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}



//不是系统管理员
-(void)createEinvoiceNo {
    UIImageView * electImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-16.5, 60, 33, 33)];
    electImage.image = GPImage(@"electInvoiceNo");
    electImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:electImage];
    
    UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 100,Main_Screen_Width - 15, 50) text:Custing(@"开通电子发票请联系管理员", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    titleLa.backgroundColor = [UIColor clearColor];
    titleLa.numberOfLines = 0;
    [self.view addSubview:titleLa];
    
}

- (void)touchLabelWithIndex:(NSInteger)index{
//    if (self.webView&&self.webView!=nil) {
//        [self.webView removeFromSuperview];
//        self.webView=nil;
//    }
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.webView0.hidden = NO;
            self.webView1.hidden = YES;
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.webView0.hidden = YES;
            self.webView1.hidden = NO;
            break;
        default:
            break;
    }
}

-(void)createAuthInfoView0:(NSString *)authUrl {
    CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
    self.webView0 = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView0.progressProxy.webViewProxyDelegate = self;
    self.webView0.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSURL* url = [NSURL URLWithString:authUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView0 loadRequest:request];
    [self.view addSubview:self.webView0];
}

-(void)createAuthInfoView1:(NSString *)authUrl {
    CGRect webSize =CGRectMake(0, 44, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight-44);
    self.webView1 = [[NJKWebView alloc]initWithFrame:webSize];
    self.webView1.progressProxy.webViewProxyDelegate = self;
    self.webView1.backgroundColor = Color_form_TextFieldBackgroundColor;
    NSURL* url = [NSURL URLWithString:authUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView1 loadRequest:request];
    [self.view addSubview:self.webView1];
    if (_segIndex==0) {
        self.webView1.hidden = YES;
    }
}

-(void)dealloc {
    self.webView0.progressProxy.webViewProxyDelegate = nil;
    self.webView1.progressProxy.webViewProxyDelegate = nil;
}
//
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"erros is %@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"hello");
    
}
#pragma mark - action
-(void)btn_click:(UIButton *)btn
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [_txf_commentName resignFirstResponder];
    [_txf_PeopleNumber resignFirstResponder];
    [_txf_backName resignFirstResponder];
    [_txf_backAccount resignFirstResponder];
    [_txf_commentPhone resignFirstResponder];
    [_txv_commentAddress resignFirstResponder];
    
    if (_txf_commentName.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司全称", nil) duration:1.5];
        [_txf_commentName becomeFirstResponder];
        return;
    }
    if (_txf_PeopleNumber.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入纳税人识别号", nil) duration:1.5];
        [_txf_PeopleNumber becomeFirstResponder];
        return;
    }
    if (_txf_backName.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入开户行名称", nil) duration:1.5];
        [_txf_backName becomeFirstResponder];
        return;
    }
    if (_txf_backAccount.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入银行账号", nil) duration:1.5];
        [_txf_backAccount becomeFirstResponder];
        return;
    }
    if (_txf_commentPhone.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入公司电话", nil) duration:1.5];
        [_txf_commentPhone becomeFirstResponder];
        return;
    }
    
    if (_txv_commentAddress.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入注册地址", nil) duration:1.5];
        [_txv_commentAddress becomeFirstResponder];
        return;
    }
    
    
    _dic_request = [[NSMutableDictionary alloc]init];
    [_dic_request addString:_txf_commentName.text forKey:@"CompanyName"];
    [_dic_request addString:_txf_PeopleNumber.text forKey:@"TaxpayerId"];
    [_dic_request addString:_txf_backName.text forKey:@"BankName"];
    [_dic_request addString:_txf_backAccount.text forKey:@"BankAccount"];
    [_dic_request addString:_txf_commentPhone.text forKey:@"Telephone"];
    [_dic_request addString:_txv_commentAddress.text forKey:@"Address"];
    [_dic_request addString:@"1" forKey:@"Einvoice"];
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",SaveCoCard] Parameters:_dic_request Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

// 百望个人报销发票授权接口
-(void)requestGetPoauthData {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetPoauth"] Parameters:nil Delegate:self SerialNum:11 IfUserCache:NO];
}

//MARK:数据请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    //个人
    if (serialNum ==1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开通成功", nil) duration:2.0];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self requestGetPoauthData];
        });
    }
    
    if (serialNum ==11) {
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else {
            if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"isoAuth"]] isEqualToString:@"0"]) {
                if ([[self.electDic objectForKey:@"list"] isEqualToString:@"elect"]) {
                    bwInvoiceElectViewController * examain = [[bwInvoiceElectViewController alloc]initWithType:@{@"list":@"12",@"result":result}];
                    [self.navigationController pushViewController:examain animated:YES];
                }else {
                    bwInvoiceExaViewController * examain = [[bwInvoiceExaViewController alloc]initWithType:@{@"list":@"13",@"result":result}];
                    [self.navigationController pushViewController:examain animated:YES];
                }

            }else {
                if ([[self.electDic objectForKey:@"list"] isEqualToString:@"elect"]) {
                    bwInvoiceElectViewController * examain = [[bwInvoiceElectViewController alloc]initWithType:@{@"list":@"15",@"result":result}];
                    [self.navigationController pushViewController:examain animated:YES];

                }else {
                    bwInvoiceExaViewController * examain = [[bwInvoiceExaViewController alloc]initWithType:@{@"list":@"16",@"result":result}];
                    [self.navigationController pushViewController:examain animated:YES];
                }
            }
            
        }
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
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
