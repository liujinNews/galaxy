//
//  bwInvoiceExaViewController.m
//  galaxy
//
//  Created by 赵碚 on 2017/1/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//
#import "XFSegementView.h"
#import "quaryResultData.h"
#import "quaryResultCell.h"
#import "QRReaderViewController.h"
#import "bwInvoiceExaViewController.h"

@interface bwInvoiceExaViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate,TouchLabelDelegate,QRReaderViewControllerDelegate,GPClientDelegate>
//@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign)NSInteger segIndex;//分段器当前选择

//个人授权
@property (nonatomic,strong)NJKWebView *webView;//授权登录
@property (nonatomic,strong)NSDictionary * personDic;//未授权字典

@property (nonatomic,strong)UIScrollView * inScroView;
@property (nonatomic,strong)UITextField * codeTF;
@property (nonatomic,strong)UITextField * numberTF;
@property (nonatomic,strong)UITextField * verificationTF;
@property (nonatomic,strong)UIButton * queryBtn;

//个人查询结果
@property (nonatomic,strong)NSMutableArray * quaryArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSDictionary * resultDic;

//企业授权
@property (nonatomic,strong)NSString * companyRe;
@property (nonatomic,strong)NSDictionary * companyDic;
@property (nonatomic,strong)UIScrollView * comScroView;
@property (nonatomic,strong)UITextField * comCodeTF;
@property (nonatomic, strong) UITextField *remiberTF;
@property (nonatomic,strong)UITextField * comNumberTF;
@property (nonatomic,strong)UITextField * comVerificationTF;
@property (nonatomic,strong)UIButton * comQueryBtn;

//个人查询结果
@property (nonatomic,strong)NSMutableArray * comQuaryArray;
@property (nonatomic,strong)UITableView * comTableView;
@property (nonatomic,strong)NSDictionary * comResultDic;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *serectTF;
@property (nonatomic, strong) UITextField *comAuthTF;

@end

@implementation bwInvoiceExaViewController
-(id)initWithType:(NSDictionary *)type{
    self = [super init];
    if (self) {
        self.personDic = type;
    }
    
    return self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"发票查验", nil) backButton:YES];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"icon_Scan_white":@"icon_Scan" target:self action:@selector(selectImage:)];
    
//    _segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 44)];
//    _segementView.type=@"1";
//    _segementView.titleArray = @[Custing(@"个人", nil),Custing(@"企业", nil)];
//    _segementView.titleColor=Color_GrayDark_Same_20;
//    [_segementView.scrollLine setBackgroundColor:Color_Blue_Important_20];
//    _segementView.titleSelectedColor = Color_Blue_Important_20;
//    _segementView.backgroundColor=Color_White_Same_20;
//    _segementView.touchDelegate = self;
//    _segementView.titleFont=13.f;
//    [self.view addSubview:_segementView];
    
    if ([[self.personDic objectForKey:@"list"] isEqualToString:@"13"]) {//发票查询未授权
        [self createPersonAuthView];
    }else if ([[self.personDic objectForKey:@"list"] isEqualToString:@"16"]) {//发票查询yi授权
        [self createInvoiceExaminationView];
    }
    //企业授权
//    [self requestGetEntoauthData];
    
    // Do any additional setup after loading the view.
}

-(void)back:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.inScroView.hidden = NO;
            self.webView.hidden = NO;
            self.comScroView.hidden = YES;
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.inScroView.hidden = YES;
            self.webView.hidden = YES;
            self.comScroView.hidden = NO;
            break;
        default:
            break;
    }
}


//MARK:个人授权
-(void)createPersonAuthView {
    _webView = [[NJKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _webView.progressProxy.webViewProxyDelegate = self;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.personDic[@"result"] objectForKey:@"url"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
    
}

-(void)dealloc {
    self.webView.progressProxy.webViewProxyDelegate = nil;
}

// 网页加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"hello");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    NSString *URLstr=[NSString stringWithFormat:@"%@",url];
    if ([URLstr containsString:@"/Error/NotLogin"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    if ([url.host isEqualToString:@"web.xibaoxiao.com"]) {
        
        NSString *nstring = [NSString stringWithFormat:@"%@",[NSString isEqualToNull:url.fragment] ?url.fragment :@""];
        if (![NSString isEqualToNull:nstring]) {
            return NO;
        }
        NSArray *array = [nstring componentsSeparatedByString:@"&"];
        
        if ([[NSObject baseURLStr] isEqualToString:@"https://xiaoapi.xibaoxiao.com/api/"]) {
            NSString * authorize = [[NSString stringWithFormat:@"%@",[array objectAtIndex:0]] substringWithRange:NSMakeRange(49, [NSString stringWithFormat:@"%@",[array objectAtIndex:0]].length-49)];
            NSString * state = [[NSString stringWithFormat:@"%@",[array objectAtIndex:1]] substringWithRange:NSMakeRange(6, [NSString stringWithFormat:@"%@",[array objectAtIndex:1]].length-6)];
            NSString * account_no = [[NSString stringWithFormat:@"%@",[array objectAtIndex:4]] substringWithRange:NSMakeRange(11, [NSString stringWithFormat:@"%@",[array objectAtIndex:4]].length-11)];
            
            [self requestPersonData:@{@"AuthorizeCode":[NSString isEqualToNull:authorize] ?authorize :@" ",@"State":[NSString isEqualToNull:state] ?state :@" ",@"AccountNo":[NSString isEqualToNull:account_no] ?account_no :@" "}];
            
        }else {
            
            NSString * authorize = [[NSString stringWithFormat:@"%@",[array objectAtIndex:0]] substringWithRange:NSMakeRange(22, [NSString stringWithFormat:@"%@",[array objectAtIndex:0]].length-22)];
            NSString * state = [[NSString stringWithFormat:@"%@",[array objectAtIndex:1]] substringWithRange:NSMakeRange(6, [NSString stringWithFormat:@"%@",[array objectAtIndex:1]].length-6)];
            NSString * account_no = [[NSString stringWithFormat:@"%@",[array objectAtIndex:4]] substringWithRange:NSMakeRange(11, [NSString stringWithFormat:@"%@",[array objectAtIndex:4]].length-11)];
            
            [self requestPersonData:@{@"AuthorizeCode":[NSString isEqualToNull:authorize] ?authorize :@" ",@"State":[NSString isEqualToNull:state] ?state :@" ",@"AccountNo":[NSString isEqualToNull:account_no] ?account_no :@" "}];
        }
        
        return NO;
        
    }
    
    return YES;
}

-(void)requestPersonData:(NSDictionary *)dict {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetPtoken"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
}


//创建发票查验视图
-(void)createInvoiceExaminationView {
    self.inScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.inScroView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
    self.inScroView.backgroundColor = [UIColor clearColor];
    self.inScroView.showsVerticalScrollIndicator = NO;
    self.inScroView.showsHorizontalScrollIndicator = NO;
    self.inScroView.delegate = self;
    [self.view addSubview:self.inScroView];
    
    NSArray * InArray = @[@{@"title":@"发票代码",@"height":@"45"},@{@"title":@"发票号码",@"height":@"45"},@{@"title":@"发票校验码",@"height":@"45"}];
    for (int j = 0 ; j < [InArray count] ; j ++ ) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55, Main_Screen_Width, 45)];
        bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.inScroView addSubview:bgView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [bgView addSubview:lineView];
        
        UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, 105, 43) text:Custing([[InArray objectAtIndex:j] objectForKey:@"title"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLa.backgroundColor = [UIColor clearColor];
        titleLa.numberOfLines = 0;
        [bgView addSubview:titleLa];
        
        UIView * line1View = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
        line1View.backgroundColor = Color_GrayLight_Same_20;
        [bgView addSubview:line1View];
        
    }
    
    self.codeTF = [GPUtils createTextField:CGRectMake(125, 1, WIDTH(self.inScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.codeTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.codeTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.codeTF.tag = 0;
    self.codeTF.delegate=self;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.inScroView addSubview:self.codeTF];
    
    
    self.numberTF = [GPUtils createTextField:CGRectMake(125, 56, WIDTH(self.inScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.numberTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.numberTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.numberTF.tag = 1;
    self.numberTF.delegate=self;
    self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.inScroView addSubview:self.numberTF];
    
    
    self.verificationTF = [GPUtils createTextField:CGRectMake(125, 111, WIDTH(self.inScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.verificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.verificationTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.verificationTF.tag = 2;
    self.verificationTF.delegate=self;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.inScroView addSubview:self.verificationTF];
    
    self.queryBtn = [GPUtils createButton:CGRectMake(15, 181, Main_Screen_Width-30, 49) action:@selector(queryInvoice:) delegate:self title:Custing(@"查询", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [self.queryBtn setBackgroundColor:Color_Blue_Important_20];
    self.queryBtn.layer.cornerRadius = 15.0f;
    [self.inScroView addSubview:self.queryBtn];
    
    
    UILabel * baiLa = [GPUtils createLable:CGRectMake(15, Y(self.queryBtn)+HEIGHT(self.queryBtn), Main_Screen_Width-30, 30) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    baiLa.backgroundColor = [UIColor clearColor];
    [self.inScroView addSubview:baiLa];
    
    
}

//
-(void)queryInvoice:(UIButton *)btn {
    [self.codeTF resignFirstResponder];
    [self.numberTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    //
    if (self.codeTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票代码", nil)];
        return;
    }
    
    //
    if (self.numberTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票号码", nil)];
        return;
    }
    
    //
//    if (self.verificationTF.text.length <=0) {
//        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票校验码", nil)];
//        return;
//    }
    
    //
    [self requestCheckOneInvoiceData];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //第一个字符不允许输入空格
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString isEqual:@" "]) {
        return NO;
    }
    
    return YES;
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.codeTF resignFirstResponder];
    [self.numberTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
    [self.comCodeTF resignFirstResponder];
    [self.comNumberTF resignFirstResponder];
    [self.verificationTF resignFirstResponder];
}

#pragma mark  - 创建查询结果
-(void)createQuaryResultView {
    self.inScroView.contentSize = CGSizeMake(Main_Screen_Width, 730);
    self.quaryArray = [NSMutableArray array];
    self.quaryArray = [quaryResultData quaryDocDatasWithUser:self.resultDic];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 280, Main_Screen_Width-30, 402)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = Color_Blue_Important_20.CGColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.inScroView addSubview:self.tableView];
    
    [UIView animateWithDuration:1.5 animations:^{
        [self.inScroView setContentOffset:CGPointMake(0, 260) animated:YES];
    } completion:^(BOOL finished) {
        //        [self.inScroView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segIndex==0) {
        return [self.quaryArray count];
    }else {
        return [self.comQuaryArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segIndex==0) {
        quaryResultData *cellInfo = self.quaryArray[indexPath.row];
        return [cellInfo.height floatValue];
    }else {
        quaryResultData *cellInfo = self.comQuaryArray[indexPath.row];
        return [cellInfo.height floatValue];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    quaryResultCell *cell=[tableView dequeueReusableCellWithIdentifier:@"quaryResultCell"];
    if (cell==nil) {
        cell=[[quaryResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"quaryResultCell"];
    }
    if (_segIndex==0) {
        quaryResultData *cellInfo = self.quaryArray[indexPath.row];
        [cell configViewWithQuaryResultCellInfo:cellInfo];
    }else {
        quaryResultData *cellInfo = self.comQuaryArray[indexPath.row];
        [cell configViewWithQuaryResultCellInfo:cellInfo];
    }
   
    
    return cell;
}


// 百望发票查验(单张查验)
-(void)requestCheckOneInvoiceData {
    NSDictionary * dict = @{@"FP_DM":[NSString isEqualToNull:self.codeTF.text] ?self.codeTF.text :@" ",@"FP_HM":[NSString isEqualToNull:self.numberTF.text] ?self.numberTF.text :@" ",@"JYM":[NSString isEqualToNull:self.verificationTF.text] ?self.verificationTF.text :@""};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/CheckOneInvoice"] Parameters:dict Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//MARK:获取企业是否已经授权
-(void)requestGetEntoauthData {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetEntoauth"] Parameters:nil Delegate:self SerialNum:2 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//创建发票查验视图
-(void)createComInvoiceExaminationView {
    
    NSInteger cellHei;
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]) {
        cellHei = 0;
    }else {
        cellHei = 20;
    }
    
    self.comScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    self.comScroView.contentSize = CGSizeMake(Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
    self.comScroView.backgroundColor = [UIColor clearColor];
    self.comScroView.showsVerticalScrollIndicator = NO;
    self.comScroView.showsHorizontalScrollIndicator = NO;
    self.comScroView.delegate = self;
    [self.view addSubview:self.comScroView];
    if ([self.companyRe isEqualToString:@"13"]) {
        NSArray * numArr = @[@{@"title":@"收票授权码"},@{@"title":@"报销授权码"},@{@"title":@"client_id"},@{@"title":@"client_secret"}];
        for (int j = 0 ; j < [numArr count] ; j ++ ) {
            NSInteger titleHei;
            NSInteger viewHei;
            if (cellHei ==20) {
                if ([[[numArr objectAtIndex:j] objectForKey:@"title"] isEqualToString:@"收票授权码"]||[[[numArr objectAtIndex:j] objectForKey:@"title"] isEqualToString:@"报销授权码"]) {
                    titleHei = 0;
                }else {
                    titleHei = 20;
                }
                
                if ([[[numArr objectAtIndex:j] objectForKey:@"title"] isEqualToString:@"报销授权码"]) {
                    viewHei = 20;
                }else {
                    viewHei = 0;
                }
            }else {
                titleHei = 0;
                viewHei = 0;
            }
            
            UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55+titleHei, Main_Screen_Width, 45+viewHei)];
            whiteView.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self.comScroView  addSubview:whiteView];
            
            UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, 110, 43+viewHei) text:Custing([[numArr objectAtIndex:j] objectForKey:@"title"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLa.backgroundColor = [UIColor clearColor];
            titleLa.numberOfLines = 0;
            [whiteView addSubview:titleLa];
            
        }
        
        self.comAuthTF = [GPUtils createTextField:CGRectMake(130, 0, Main_Screen_Width-145, 45) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.comAuthTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.comAuthTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.comAuthTF.tag = 0;
        self.comAuthTF.delegate=self;
        self.comAuthTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comScroView addSubview:self.comAuthTF];
        if ([self.companyDic isKindOfClass:[NSNull class]] || self.companyDic == nil|| self.companyDic.count == 0||!self.companyDic){
            
        }else {
            self.comAuthTF.text = [NSString isEqualToNull:[self.companyDic objectForKey:@"spsqm"]] ?[self.companyDic objectForKey:@"spsqm"] :@"";
        }
        
        self.remiberTF = [GPUtils createTextField:CGRectMake(130, 55, Main_Screen_Width-145, 45+cellHei) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.remiberTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.remiberTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.remiberTF.tag = 0;
        self.remiberTF.delegate=self;
        self.remiberTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comScroView addSubview:self.remiberTF];
        if ([self.companyDic isKindOfClass:[NSNull class]] || self.companyDic == nil|| self.companyDic.count == 0||!self.companyDic){
            
        }else {
            self.remiberTF.text = [NSString isEqualToNull:[self.companyDic objectForKey:@"bxsqm"]] ?[self.companyDic objectForKey:@"bxsqm"] :@"";
        }
        
        self.accountTF = [GPUtils createTextField:CGRectMake(130, 110+cellHei, Main_Screen_Width-145, 45) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
        self.accountTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.accountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.accountTF.tag = 0;
        self.accountTF.delegate=self;
        self.accountTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comScroView addSubview:self.accountTF];
        
        if ([self.companyDic isKindOfClass:[NSNull class]] || self.companyDic == nil|| self.companyDic.count == 0||!self.companyDic){
            
        }else {
            self.accountTF.text = [NSString isEqualToNull:[self.companyDic objectForKey:@"clientId"]] ?[self.companyDic objectForKey:@"clientId"] :@"";
        }
        
        self.serectTF = [GPUtils createTextField:CGRectMake(130, 165+cellHei, Main_Screen_Width-145, 45) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
//        self.serectTF.secureTextEntry = YES;
        self.serectTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.serectTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.serectTF.tag = 1;
        self.serectTF.delegate=self;
        self.serectTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comScroView addSubview:self.serectTF];
        
        if ([self.companyDic isKindOfClass:[NSNull class]] || self.companyDic == nil|| self.companyDic.count == 0||!self.companyDic){
            
        }else {
            self.serectTF.text = [NSString isEqualToNull:[self.companyDic objectForKey:@"clientSecret"]] ?[self.companyDic objectForKey:@"clientSecret"] :@"";
        }
        
        //按钮1
        UIButton * nextBtn = [GPUtils createButton:CGRectMake(15, 230+cellHei, Main_Screen_Width-30, 45) action:@selector(saveCompanyAuth:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"授权", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
        [nextBtn setBackgroundColor:Color_Blue_Important_20];
        nextBtn.layer.cornerRadius = 11.0f;
        [self.comScroView addSubview:nextBtn];
    }else {
        NSArray * InArray = @[@{@"title":@"发票代码",@"height":@"45"},@{@"title":@"发票号码",@"height":@"45"},@{@"title":@"发票校验码",@"height":@"45"}];
        for (int j = 0 ; j < [InArray count] ; j ++ ) {
            
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55, Main_Screen_Width, 45)];
            bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self.comScroView addSubview:bgView];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [bgView addSubview:lineView];
            
            UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, 105, 43) text:Custing([[InArray objectAtIndex:j] objectForKey:@"title"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLa.backgroundColor = [UIColor clearColor];
            titleLa.numberOfLines = 0;
            [bgView addSubview:titleLa];
            
            UIView * line1View = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
            line1View.backgroundColor = Color_GrayLight_Same_20;
            [bgView addSubview:line1View];
            
        }
        
        self.comCodeTF = [GPUtils createTextField:CGRectMake(125, 1, WIDTH(self.comScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.comCodeTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.comCodeTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.comCodeTF.tag = 0;
        self.comCodeTF.delegate=self;
        self.comCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.comScroView addSubview:self.comCodeTF];
        
        
        self.comNumberTF = [GPUtils createTextField:CGRectMake(125, 56, WIDTH(self.comScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.comNumberTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.comNumberTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.comNumberTF.tag = 1;
        self.comNumberTF.delegate=self;
        self.comNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.comScroView addSubview:self.comNumberTF];
        
        
        self.comVerificationTF = [GPUtils createTextField:CGRectMake(125, 111, WIDTH(self.comScroView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.comVerificationTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.comVerificationTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.comVerificationTF.tag = 2;
        self.comVerificationTF.delegate=self;
        self.comVerificationTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.comScroView addSubview:self.comVerificationTF];
        
        self.comQueryBtn = [GPUtils createButton:CGRectMake(15, 181, Main_Screen_Width-30, 49) action:@selector(comQueryInvoice:) delegate:self title:Custing(@"查询", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
        [self.comQueryBtn setBackgroundColor:Color_Blue_Important_20];
        self.comQueryBtn.layer.cornerRadius = 15.0f;
        [self.comScroView addSubview:self.comQueryBtn];
        
        
        UILabel * baiLa = [GPUtils createLable:CGRectMake(15, Y(self.comQueryBtn)+HEIGHT(self.comQueryBtn), Main_Screen_Width-30, 30) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        baiLa.backgroundColor = [UIColor clearColor];
        [self.comScroView addSubview:baiLa];
    }
    
    
    
    if (_segIndex==0) {
        self.comScroView.hidden = YES;
    }
}

-(void)saveCompanyAuth:(UIButton *)btn {
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.comAuthTF resignFirstResponder];
    [self.accountTF resignFirstResponder];
    [self.serectTF resignFirstResponder];
    
    if (self.comAuthTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入收票授权码", nil) duration:1.5];
        [self.accountTF becomeFirstResponder];
        return;
    }
    
    if (self.remiberTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入报销授权码", nil) duration:1.5];
        [self.remiberTF becomeFirstResponder];
        return;
    }
    
    if (self.accountTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入client_id", nil) duration:1.5];
        [self.accountTF becomeFirstResponder];
        return;
    }
    
    if (self.serectTF.text.length == 0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入client_secret", nil) duration:1.5];
        [self.serectTF becomeFirstResponder];
        return;
    }
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetEntoken"] Parameters:@{@"ClientId":self.accountTF.text,@"bxsqm":self.remiberTF.text,@"ClientSecret":self.serectTF.text,@"SPSQM":self.comAuthTF.text} Delegate:self SerialNum:5 IfUserCache:NO];
    
}


-(void)createComQuaryResultView {
    self.comScroView.contentSize = CGSizeMake(Main_Screen_Width, 730);
    
    self.comQuaryArray = [NSMutableArray array];
    self.comQuaryArray = [quaryResultData quaryDocDatasWithUser:self.comResultDic];
    self.comTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 280, Main_Screen_Width-30, 402)];
    self.comTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.comTableView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.comTableView.layer.cornerRadius = 10;
    self.comTableView.layer.borderWidth = 1.0f;
    self.comTableView.layer.borderColor = Color_Blue_Important_20.CGColor;
    self.comTableView.dataSource = self;
    self.comTableView.delegate = self;
    
    [self.comScroView addSubview:self.comTableView];
    
    [UIView animateWithDuration:1.5 animations:^{
        [self.comScroView setContentOffset:CGPointMake(0, 260) animated:YES];
    } completion:^(BOOL finished) {
        //        [self.inScroView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
}



-(void)comQueryInvoice:(UIButton *)btn {
    [self.comCodeTF resignFirstResponder];
    [self.comNumberTF resignFirstResponder];
    [self.comVerificationTF resignFirstResponder];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    //
    if (self.comCodeTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票代码", nil)];
        return;
    }
    
    //
    if (self.comNumberTF.text.length <=0) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票号码", nil)];
        return;
    }
    
    //
//    if (self.comVerificationTF.text.length <=0) {
//        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"请输入发票校验码", nil)];
//        return;
//    }
    
    //
    [self requestCheckComInvoiceData];
    
}

// 百望发票查验(企业)
-(void)requestCheckComInvoiceData {
    NSMutableArray * arrs = [NSMutableArray arrayWithObject:@{@"FP_DM":[NSString isEqualToNull:self.comCodeTF.text] ?self.comCodeTF.text :@" ",@"FP_HM":[NSString isEqualToNull:self.comNumberTF.text] ?self.comNumberTF.text :@" ",@"JYM":[NSString isEqualToNull:self.comVerificationTF.text] ?self.comVerificationTF.text :@""}];
    
    NSDictionary * dict = @{@"AccessToken":self.companyDic[@"result"][@"accessToken"],@"ClientId":self.companyDic[@"result"][@"clientId"],@"SQM":self.companyDic[@"result"][@"spsqm"],@"InvItems":arrs};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/CheckInvoiceEnt"] Parameters:@{@"Invoices":stri} Delegate:self SerialNum:3 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}



- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"resDic:%@",responceDic);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
        return;
    }
    
    if (serialNum ==0) {
        
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([[self.personDic objectForKey:@"list"] isEqualToString:@"13"]) {
                    if (self.webView&&self.webView!=nil) {
                        [self.webView removeFromSuperview];
                        self.webView=nil;
                    }
                    self.personDic = @{@"list":@"15",@"result":result};
                    [self createInvoiceExaminationView];
                }
                
            });
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"授权成功" duration:1.5];
        }
    }
    
    //个人查验
    if (serialNum ==1) {
        self.resultDic = [responceDic objectForKey:@"result"];
        if (!self.tableView) {
            [self createQuaryResultView];
        }else {
            [self.tableView reloadData];
        }
    }
    
    //企业
    if (serialNum ==2) {
        self.companyRe = @"13";
        self.companyDic = [responceDic objectForKey:@"result"];
        [self createComInvoiceExaminationView];
    }
    
    //企业查验
    if (serialNum ==3) {
        NSArray * items = [responceDic objectForKey:@"result"];
        if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
            self.comResultDic = [items objectAtIndex:0];
        }
        if (!self.comTableView) {
            [self createComQuaryResultView];
        }else {
            [self.comTableView reloadData];
        }
    }
    
    //企业
    if (serialNum ==5) {
        self.companyRe = @"16";
        self.companyDic = @{@"result":[responceDic objectForKey:@"result"]};
        if (self.comScroView&&self.comScroView!=nil) {
            [self.comScroView removeFromSuperview];
            self.comScroView=nil;
        }
        [self createComInvoiceExaminationView];
    }
    
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}



#pragma mark - 二维码扫描
-(void)selectImage:(UIButton *)btn
{
    QRReaderViewController *VC = [[QRReaderViewController alloc] init];
    VC.delegate = self;
    VC.judgeStr =1;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 二维码扫描后结果
-(void)didFinishedReadingQR:(NSString *)string withType:(NSInteger)type
{
    if ([NSString isEqualToNull:string]) {
        NSArray *array = [string componentsSeparatedByString:@","];
        if (array.count>5 ) {
//            [_segementView selectLabelWithIndex:0];
            
            self.codeTF.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:2]];
            self.numberTF.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:3]];
            self.verificationTF.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:6]];
            
            [self requestCheckOneInvoiceData];
        }else {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"无效二维码", nil)  duration:1.0];
        }
        
    }
    else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"无效二维码", nil)  duration:1.0];
    }
    
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
