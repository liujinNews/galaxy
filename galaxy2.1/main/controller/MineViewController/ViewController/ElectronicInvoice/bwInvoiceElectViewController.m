
//
//  bwInvoiceElectViewController.m
//  galaxy
//
//  Created by 赵碚 on 2017/1/3.
//  Copyright © 2017年 赵碚. All rights reserved.
//
#import "XFSegementView.h"
#import "bwAuthInfoViewController.h"
//#import "ElectInvoiceViewController.h"
#import "bwInvoiceShowViewController.h"
#import "bwInvoiceElectViewController.h"

@interface bwInvoiceElectViewController ()<UIWebViewDelegate,UITextFieldDelegate,chooseTravelDateViewDelegate,TouchLabelDelegate,GPClientDelegate>
//@property (nonatomic, strong) XFSegementView *segementView;
@property (nonatomic, assign)NSInteger segIndex;//分
//个人授权
@property (nonatomic,strong)NJKWebView *webView;//授权登录
@property (nonatomic,strong)NSDictionary * personDic;//未授权字典
@property (nonatomic,strong)NSString * personRe;
//个人查询
@property (nonatomic,strong)UIView * queryView;
@property (nonatomic,strong)UITextField * codeTF;
@property (nonatomic,strong)UIButton * startBtn;
@property (nonatomic,strong)UILabel * startLa;
@property (nonatomic,strong)UIButton * endBtn;
@property (nonatomic,strong)UILabel * endLa;
@property (nonatomic,strong)UIDatePicker * datePicker;
@property (nonatomic,strong)NSString * dataType;
@property (nonatomic,strong)chooseTravelDateView * datelView;
@property (nonatomic,strong)NSString * startStr;
@property (nonatomic,strong)NSString * endStr;

@property (nonatomic,strong)NSString * dateReplace;
//企业授权
@property (nonatomic,strong)NSDictionary * companyDic;
@property (nonatomic,strong)NSString * companyRe;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *remiberTF;
@property (nonatomic, strong) UITextField *serectTF;
@property (nonatomic, strong) UITextField *comAuthTF;
@property (nonatomic, strong) UIView * comView;
@property (nonatomic,strong)UIButton * comStartBtn;
@property (nonatomic,strong)UILabel * comStartLa;
@property (nonatomic,strong)UIButton * comEndBtn;
@property (nonatomic,strong)UILabel * comEndLa;

@property (nonatomic,strong)NSString * comStartStr;
@property (nonatomic,strong)NSString * comEndStr;

@end

@implementation bwInvoiceElectViewController
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
    [self setTitle:Custing(@"发票查询", nil) backButton:YES];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"my_positionsWhite":@"my_positionQ" target:self action:@selector(bwAuthInfo:)];
    self.personRe = @"15";
    [self testPersonAuth];
}

-(void)back:(UIButton *)btn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)bwAuthInfo:(UIButton *)btn{
    bwAuthInfoViewController * INFO = [[bwAuthInfoViewController alloc]initWithType:@{@"list":@"info",@"dict":@""}];
    [self.navigationController pushViewController:INFO animated:YES];
}

- (void)touchLabelWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            if (_segIndex==0) {
                return;
            }
            _segIndex=0;
            self.comView.hidden = YES;
            if ([self.personRe isEqualToString:@"12"]) {
                if (self.queryView&&self.queryView!=nil) {
                    [self.queryView removeFromSuperview];
                    self.queryView=nil;
                }
                self.webView.hidden = NO;
            }else if ([self.personRe isEqualToString:@"15"]) {
                if (self.webView&&self.webView!=nil) {
                    [self.webView removeFromSuperview];
                    self.webView=nil;
                }
                self.queryView.hidden = NO;
            }
            
            break;
        case 1:
            if (_segIndex==1) {
                return;
            }
            _segIndex=1;
            self.webView.hidden = YES;
            self.queryView.hidden = YES;

            self.comView.hidden = NO;
            
            
            break;
        default:
            break;
    }
}


//MARK:个人授权
-(void)createPersonAuthView {
    _webView = [[NJKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
    _webView.progressProxy.webViewProxyDelegate = self;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[_personDic[@"result"] objectForKey:@"url"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
}

// 网页加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"did hello");
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"start hello");
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
}

-(void)requestPersonData:(NSDictionary *)dict {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetPtoken"] Parameters:dict Delegate:self SerialNum:0 IfUserCache:NO];
}

//
-(void)createPersonQueryEIView {
    self.queryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 260)];
    self.queryView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.queryView];
    
    NSArray * InArray = @[@{@"title":@"发票抬头",@"image":@"skipImage"},@{@"title":@"开始日期",@"image":@"skipImage"},@{@"title":@"结束日期",@"image":@"skipImage"}];
    
    for (int j = 0 ; j < [InArray count] ; j ++ ) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55, Main_Screen_Width, 45)];
        bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.queryView addSubview:bgView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
        lineView.backgroundColor = Color_GrayLight_Same_20;
        [bgView addSubview:lineView];
        
        UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, 85, 43) text:Custing([[InArray objectAtIndex:j] objectForKey:@"title"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        titleLa.backgroundColor = [UIColor clearColor];
        titleLa.numberOfLines = 0;
        [bgView addSubview:titleLa];
        
        UIImageView * skipImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-35,13.5 , 18, 18)];
        skipImage.image = GPImage([[InArray objectAtIndex:j] objectForKey:@"image"]);
        skipImage.backgroundColor = [UIColor clearColor];
        if (![[[InArray objectAtIndex:j] objectForKey:@"title"] isEqualToString:@"发票抬头"]) {
            [bgView addSubview:skipImage];
        }
        
        UIView * line1View = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
        line1View.backgroundColor = Color_GrayLight_Same_20;
        [bgView addSubview:line1View];
        
    }
    
    self.startStr = [NSString stringWithFormat:@"%@",[self getDateFromDate]];
    self.endStr = [NSString stringWithDate:[NSDate date]];
    
    self.codeTF = [GPUtils createTextField:CGRectMake(110, 1, WIDTH(self.queryView)-125, 43) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    self.codeTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.codeTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.codeTF.tag = 0;
    self.codeTF.delegate=self;
    self.codeTF.keyboardType = UIKeyboardTypeEmailAddress;
    [self.queryView addSubview:self.codeTF];
    
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    if ([NSString isEqualToNull:[userdefa objectForKey:@"invoiceTitle"]]||![[NSString stringWithFormat:@"%@",[userdefa objectForKey:@"invoiceTitle"]] isEqualToString:@" "]) {
        self.codeTF.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[userdefa objectForKey:@"invoiceTitle"]]]?[NSString stringWithFormat:@"%@",[userdefa objectForKey:@"invoiceTitle"]]:Custing(@"公司", nil);
    }else{
        self.codeTF.text = Custing(@"公司", nil);
    }
    
    self.startBtn = [GPUtils createButton:CGRectMake(110, 55, Main_Screen_Width-110, 45) action:@selector(startDate:) delegate:self normalImage:nil highlightedImage:nil];
    self.startBtn.backgroundColor = [UIColor clearColor];
    [self.queryView addSubview:self.startBtn];
    
    self.startLa = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.startBtn)-35, 45) text:self.startStr font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.startLa.backgroundColor = [UIColor clearColor];
    [self.startBtn addSubview:self.startLa];
    
    
    self.endBtn = [GPUtils createButton:CGRectMake(110, 110, Main_Screen_Width-110, 45) action:@selector(endDate:) delegate:self normalImage:nil highlightedImage:nil];
    self.endBtn.backgroundColor = [UIColor clearColor];
    [self.queryView addSubview:self.endBtn];
    
    self.endLa = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.endBtn)-35, 45) text:self.endStr font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    self.endLa.backgroundColor = [UIColor clearColor];
    [self.endBtn addSubview:self.endLa];
    
//    NSString * timeStr = [NSString stringWithDate:[NSDate date]];
//    self.startStr = [NSString stringWithFormat:@"%@01",[timeStr substringToIndex:8]];
//    self.endStr = [NSString stringWithDate:[NSDate date]];
    
    UIButton * queryBtn = [GPUtils createButton:CGRectMake(15, 176, Main_Screen_Width-30, 45) action:@selector(queryInvoice:) delegate:self title:Custing(@"查询", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
    [queryBtn setBackgroundColor:Color_Blue_Important_20];
    queryBtn.layer.cornerRadius = 15.0f;
    [self.queryView addSubview:queryBtn];
    
    UILabel * baiLa = [GPUtils createLable:CGRectMake(15, Y(queryBtn)+HEIGHT(queryBtn), Main_Screen_Width-30, 30) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    baiLa.backgroundColor = [UIColor clearColor];
    [self.queryView addSubview:baiLa];
    
}

-(NSString *)getDateFromDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:+1];
    NSString * startDate = [NSString stringWithDate:[calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0]];
    return startDate;
    
}


//
-(void)queryInvoice:(UIButton *)btn {
    [self.codeTF resignFirstResponder];
    [self keyClose];
    [self.datelView remove];
    [self dimsissPDActionView];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    //
    if ([self.startLa.text isEqualToString:@"请选择"]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开始日期不能为空", nil)];
        return;
    }
    
    if ([self.endLa.text isEqualToString:@"请选择"]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"结束日期不能为空", nil)];
        return;
    }
    
    NSUserDefaults *userdefa = [NSUserDefaults standardUserDefaults];
    [userdefa setObject:[NSString isEqualToNull:self.codeTF.text] ?self.codeTF.text :@" " forKey:@"invoiceTitle"];
    [userdefa synchronize];
    
    
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
    [self.serectTF resignFirstResponder];
    [self.accountTF resignFirstResponder];
    [self.comAuthTF resignFirstResponder];
    [self.remiberTF resignFirstResponder];
}


//开始日期
-(void)startDate:(UIButton *)btn {
    self.dataType = @"start";
    self.dateReplace = @"15";
    [self selectionDate];
}

//结束日期
-(void)endDate:(UIButton *)btn {
    self.dataType = @"end";
    self.dateReplace = @"15";
    [self selectionDate];
}

//日期选择
-(void)selectionDate {
    [self keyClose];
    _datePicker = [[UIDatePicker alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate;//=[format dateFromString:dateStr];
    
    if ([self.dataType isEqualToString:@"start"]) {
        if ([self.dateReplace isEqualToString:@"15"]) {
            fromdate = [format dateFromString:self.startStr];
        }else {
            fromdate = [format dateFromString:self.comStartStr];
        }
        
    }else{
        if ([self.dateReplace isEqualToString:@"15"]) {
            fromdate = [format dateFromString:self.endStr];
        }else {
            fromdate = [format dateFromString:self.comEndStr];
        }
    }
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _datePicker.date=fromDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    if ([self.dataType isEqualToString:@"start"]) {
        lbl.text=Custing(@"起始时间", nil);
    }else{
        lbl.text=Custing(@"结束时间", nil);
    }
    
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(sureData) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Cancel_Click) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    if (!_datelView) {
        _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _datelView.delegate = self;
    }
    
    [_datelView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    if ([self.dataType isEqualToString:@"start"]) {
        if ([self.dateReplace isEqualToString:@"15"]) {
            self.startStr = str;
        }else {
            self.comStartStr = str;
        }
    }else{
        if ([self.dateReplace isEqualToString:@"15"]) {
            self.endStr = str;
        }else {
            self.comEndStr = str;
        }
    }
    
}
-(NSDate*) convertLeaveDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

//MARK:时间选择确定按钮
-(void)sureData{
    [self keyClose];
    [self.datelView remove];
    [self dimsissPDActionView];
    if ([self.dataType isEqualToString:@"start"]) {
        if ([self.dateReplace isEqualToString:@"15"]) {
            self.startLa.text = self.startStr;
            self.startLa.textColor = Color_form_TextField_20;
        }else {
            self.comStartLa.text = self.comStartStr;
            self.comStartLa.textColor = Color_form_TextField_20;
        }
    }else{
        if ([self.dateReplace isEqualToString:@"15"]) {
            if (self.startStr) {
                NSDate *date2 = [self convertLeaveDateFromString:self.startStr];
                NSDate *date1 = [self convertLeaveDateFromString:self.endStr];
                if ([date2 timeIntervalSinceDate:date1]>=0.0)
                {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText: Custing(@"开始时间不能大于等于结束时间", nil)];
                    return;
                }else {
                    self.endLa.text = self.endStr;
                    self.endLa.textColor = Color_form_TextField_20;
                }
            }
        }else {
            if (self.comStartStr) {
                NSDate *date2 = [self convertLeaveDateFromString:self.comStartStr];
                NSDate *date1 = [self convertLeaveDateFromString:self.comEndStr];
                if ([date2 timeIntervalSinceDate:date1]>=0.0)
                {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText: Custing(@"开始时间不能大于等于结束时间", nil)];
                    return;
                }else {
                    self.comEndLa.text = self.comEndStr;
                    self.comEndLa.textColor = Color_form_TextField_20;
                }
            }
        }
    }
}

-(void)btn_Cancel_Click{
    [self.datelView remove];
    [self dimsissPDActionView];
}

//清除时间控制器
-(void)dimsissPDActionView{
    _datelView = nil;
}


//MARK:获取企业是否已经授权
-(void)requestGetEntoauthData {
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetEntoauth"] Parameters:nil Delegate:self SerialNum:1 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
}

//企业授权界面
-(void)createCompanyAuthView:(NSDictionary *)dict {
    
    NSInteger cellHei;
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]) {
        cellHei = 0;
    }else {
        cellHei = 20;
    }
    
    self.comView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 300)];
    self.comView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.comView];
    
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
            [self.comView  addSubview:whiteView];
            
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
        [self.comView addSubview:self.comAuthTF];
        if ([dict isKindOfClass:[NSNull class]] || dict == nil|| dict.count == 0||!dict){
            
        }else {
            self.comAuthTF.text = [NSString isEqualToNull:[dict objectForKey:@"spsqm"]] ?[dict objectForKey:@"spsqm"] :@"";
        }
        
        
        self.remiberTF = [GPUtils createTextField:CGRectMake(130, 55, Main_Screen_Width-145, 45+cellHei) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        self.remiberTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.remiberTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.remiberTF.tag = 0;
        self.remiberTF.delegate=self;
        self.remiberTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comView addSubview:self.remiberTF];
        if ([dict isKindOfClass:[NSNull class]] || dict == nil|| dict.count == 0||!dict){
            
        }else {
            self.remiberTF.text = [NSString isEqualToNull:[dict objectForKey:@"bxsqm"]] ?[dict objectForKey:@"bxsqm"] :@"";
        }
        
        
        self.accountTF = [GPUtils createTextField:CGRectMake(130, 110+cellHei, Main_Screen_Width-145, 45) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
        self.accountTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.accountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.accountTF.tag = 0;
        self.accountTF.delegate=self;
        self.accountTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.comView addSubview:self.accountTF];
        
        if ([dict isKindOfClass:[NSNull class]] || dict == nil|| dict.count == 0||!dict){
            
        }else {
            self.accountTF.text = [NSString isEqualToNull:[dict objectForKey:@"clientId"]] ?[dict objectForKey:@"clientId"] :@"";
        }
        
        self.serectTF = [GPUtils createTextField:CGRectMake(130, 165+cellHei, Main_Screen_Width-145, 45) placeholder:Custing(@"请输入", nil) delegate:self font:Font_Important_15_20 textColor:Color_Black_Important_20];
//        self.serectTF.secureTextEntry = YES;
        self.serectTF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.serectTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        self.serectTF.tag = 1;
        self.serectTF.delegate=self;
        self.serectTF.keyboardType = UIKeyboardTypeEmailAddress;
        [self.comView addSubview:self.serectTF];
        
        if ([dict isKindOfClass:[NSNull class]] || dict == nil|| dict.count == 0||!dict){
            
        }else {
            self.serectTF.text = [NSString isEqualToNull:[dict objectForKey:@"clientSecret"]] ?[dict objectForKey:@"clientSecret"] :@"";
        }
        
        //按钮1
        UIButton * nextBtn = [GPUtils createButton:CGRectMake(15, 230+cellHei, Main_Screen_Width-30, 45) action:@selector(saveCompanyAuth:) delegate:self normalBackgroundImage:nil highlightedBackgroundImage:nil title:Custing(@"授权", nil) font:Font_Important_15_20 color:Color_form_TextFieldBackgroundColor];
        [nextBtn setBackgroundColor:Color_Blue_Important_20];
        nextBtn.layer.cornerRadius = 11.0f;
        [self.comView addSubview:nextBtn];
        
    }else if ([self.companyRe isEqualToString:@"16"]) {
        NSArray * numArr = @[@{@"title":@"开始日期",@"image":@"skipImage"},@{@"title":@"结束日期",@"image":@"skipImage"}];
        for (int j = 0 ; j < [numArr count] ; j ++ ) {
            
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, j*55, Main_Screen_Width, 45)];
            bgView.backgroundColor = Color_form_TextFieldBackgroundColor;
            [self.comView addSubview:bgView];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.5)];
            lineView.backgroundColor = Color_GrayLight_Same_20;
            [bgView addSubview:lineView];
            
            UILabel * titleLa = [GPUtils createLable:CGRectMake(15, 1, 85, 43) text:Custing([[numArr objectAtIndex:j] objectForKey:@"title"], nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
            titleLa.backgroundColor = [UIColor clearColor];
            titleLa.numberOfLines = 0;
            [bgView addSubview:titleLa];
            
            UIImageView * skipImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width-35,13.5 , 18, 18)];
            skipImage.image = GPImage([[numArr objectAtIndex:j] objectForKey:@"image"]);
            skipImage.backgroundColor = [UIColor clearColor];
            [bgView addSubview:skipImage];
            
            UIView * line1View = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, Main_Screen_Width, 0.5)];
            line1View.backgroundColor = Color_GrayLight_Same_20;
            [bgView addSubview:line1View];
            
        }
        
        self.comStartStr = [NSString stringWithFormat:@"%@",[self getDateFromDate]];
        self.comEndStr = [NSString stringWithDate:[NSDate date]];
        
        self.comStartBtn = [GPUtils createButton:CGRectMake(110, 0, Main_Screen_Width-110, 45) action:@selector(comStartDate:) delegate:self normalImage:nil highlightedImage:nil];
        self.comStartBtn.backgroundColor = [UIColor clearColor];
        [self.comView addSubview:self.comStartBtn];
        
        self.comStartLa = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.comStartBtn)-35, 45) text:self.comStartStr font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        self.comStartLa.backgroundColor = [UIColor clearColor];
        [self.comStartBtn addSubview:self.comStartLa];
        
        
        self.comEndBtn = [GPUtils createButton:CGRectMake(110, 55, Main_Screen_Width-110, 45) action:@selector(comEndDate:) delegate:self normalImage:nil highlightedImage:nil];
        self.comEndBtn.backgroundColor = [UIColor clearColor];
        [self.comView addSubview:self.comEndBtn];
        
        self.comEndLa = [GPUtils createLable:CGRectMake(0, 0, WIDTH(self.comEndBtn)-35, 45) text:self.comEndStr font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
        self.comEndLa.backgroundColor = [UIColor clearColor];
        [self.comEndBtn addSubview:self.comEndLa];
        
        UIButton * queryBtn = [GPUtils createButton:CGRectMake(15, 120, Main_Screen_Width-30, 45) action:@selector(comQueryInvoice:) delegate:self title:Custing(@"查询", nil) font:Font_Important_15_20 titleColor:Color_form_TextFieldBackgroundColor];
        [queryBtn setBackgroundColor:Color_Blue_Important_20];
        queryBtn.layer.cornerRadius = 15.0f;
        [self.comView addSubview:queryBtn];
        
        UILabel * baiLa = [GPUtils createLable:CGRectMake(15, Y(queryBtn)+HEIGHT(queryBtn), Main_Screen_Width-30, 30) text:Custing(@"仅支持百望电子开具的电子发票", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        baiLa.backgroundColor = [UIColor clearColor];
        [self.comView addSubview:baiLa];
        
    }
    if (_segIndex==0) {
        self.comView.hidden = YES;
    }

    
}

//开始日期
-(void)comStartDate:(UIButton *)btn {
    self.dataType = @"start";
    self.dateReplace = @"16";
    [self selectionDate];
}

//结束日期
-(void)comEndDate:(UIButton *)btn {
    self.dataType = @"end";
    self.dateReplace = @"16";
    [self selectionDate];
}

//
-(void)comQueryInvoice:(UIButton *)btn {
    [self.codeTF resignFirstResponder];
    [self keyClose];
    [self.datelView remove];
    [self dimsissPDActionView];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    
    //
    if ([self.comStartLa.text isEqualToString:@"请选择"]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"开始日期不能为空", nil)];
        return;
    }
    
    if ([self.comEndLa.text isEqualToString:@"请选择"]) {
        [[GPAlertView sharedAlertView] showAlertText:self WithText:Custing(@"结束日期不能为空", nil)];
        return;
    }
    
//    NSDictionary * dict = @{@"list":@"company",@"result":[self.companyDic objectForKey:@"result"],@"StartDate":self.comStartLa.text,@"EndDate":self.comEndLa.text};
//    ElectInvoiceViewController * elect = [[ElectInvoiceViewController alloc]initWithType:dict];
//    [self.navigationController pushViewController:elect animated:YES];
    
}

-(void)saveCompanyAuth:(UIButton *)btn {
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前网络不可用，请检查您的网络", nil) duration:2.0];
        return;
    }
    [self.comAuthTF resignFirstResponder];
    [self.remiberTF resignFirstResponder];
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
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetEntoken"] Parameters:@{@"ClientId":self.accountTF.text,@"bxsqm":self.remiberTF.text,@"ClientSecret":self.serectTF.text,@"SPSQM":self.comAuthTF.text} Delegate:self SerialNum:2 IfUserCache:NO];
    
}

-(void)testPersonAuth {
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary * dict = @{@"AccessToken":self.personDic[@"result"][@"accessToken"],@"accountType":self.personDic[@"result"][@"accountType"],@"accountNo":self.personDic[@"result"][@"accountNo"],@"InvoiceTitle":@"1",@"StartDate":@"2017/01/01",@"EndDate":@"2017/01/02"};
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetInvoiceList"] Parameters:dict Delegate:self SerialNum:15 IfUserCache:NO];
}




- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        if (serialNum !=15) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
    }
    
    if (serialNum ==0) {
        
        NSDictionary * result = [responceDic objectForKey:@"result"];
        if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
            return;
        }else {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([[self.personDic objectForKey:@"list"] isEqualToString:@"12"]) {
                    if (self.webView&&self.webView!=nil) {
                        [self.webView removeFromSuperview];
                        self.webView=nil;
                    }
                    self.personRe = @"15";
                    self.personDic = @{@"list":@"15",@"result":result};
                    [self createPersonQueryEIView];
                }
                
            });
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"授权成功" duration:1.5];
        }
    }
    
    //企业
    if (serialNum ==1) {
        self.companyRe = @"13";
        self.companyDic = [responceDic objectForKey:@"result"];
        [self createCompanyAuthView:self.companyDic];
    }
    
    //企业
    if (serialNum ==2) {
        self.companyRe = @"16";
        self.companyDic = @{@"result":[responceDic objectForKey:@"result"]};
        if (self.comView&&self.comView!=nil) {
            [self.comView removeFromSuperview];
            self.comView=nil;
        }
        [self createCompanyAuthView:self.companyDic];
    }
    
    //测试个人授权
    if (serialNum ==15) {
//#warning test
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]] isEqualToString:@"0"]) {
            [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"BaiWang/GetPoauthUrl"] Parameters:nil Delegate:self SerialNum:16 IfUserCache:NO];

        }else {
//            [self createPersonQueryEIView];   废除
            bwInvoiceShowViewController *bw = [[bwInvoiceShowViewController alloc]init];
            bw.str_AccountType = _personDic[@"result"][@"accountType"];
            bw.str_AccountNo = _personDic[@"result"][@"accountNo"];
            bw.str_AccountToken = _personDic[@"result"][@"accessToken"];
            [self.navigationController pushViewController:bw animated:NO];
        }
    }
    
    if (serialNum ==16) {
        self.personRe = @"12";
        self.personDic = @{@"list":@"12",@"result":@{@"url":[NSString isEqualToNull:[responceDic objectForKey:@"result"]] ?[responceDic objectForKey:@"result"] :@" "}};
        [self createPersonAuthView];
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
