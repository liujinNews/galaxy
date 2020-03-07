//
//  aboutUsViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/4/27.
//  Copyright © 2016年 赵碚. All rights reserved.
//
//弱 橙色
#define Color_gold         [GPUtils colorHString:@"#ffa83a"]

#import "aboutUsViewController.h"

@interface aboutUsViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIWebViewDelegate,GPClientDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic, strong)NSDictionary *resultDict;
@property (nonatomic,strong)NSString * descriptio;
@property (nonatomic,strong)NSString * contactNumber;
@property (nonatomic,strong)NSString * contactQQ;
@property (nonatomic,strong)NSString * idd;
@property (nonatomic,strong)NSString * website;
@property (nonatomic,strong)UITextView * aboutUSTV;
@property (nonatomic,strong)NSString * status;

@end

@implementation aboutUsViewController
-(id)initWithType:(NSString *)type{
    self = [super init];
    if (self) {
        self.status = type;
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
    if ([self.status isEqualToString:@"banben"]) {
        [self setTitle:Custing(@"版本信息", nil) backButton:YES];
        [self createVersionInformation];
    }else{
        [self requestSend];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight)];
        
        [self setTitle:Custing(@"关于喜报", nil) backButton:YES];
        UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width*1.8232)];
        bgImage.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:bgImage];
        bgImage.image = GPImage(@"my_aboutUs");
        
        [bgImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        bgImage.contentMode =  UIViewContentModeScaleAspectFill;
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        bgImage.clipsToBounds  = YES;
        self.scrollView.contentSize = bgImage.frame.size;
        [self.view addSubview:self.scrollView];
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

//创建版本信息
-(void)createVersionInformation{
    UIImageView * qrImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2-100/2, Main_Screen_Height*0.1589, 100, 100)];
    qrImage.image = GPImage(@"shareAvatar.png");
    [self.view addSubview:qrImage];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSString *CFBundleDisplayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-30, 24) text:[NSString stringWithFormat:@"%@ %@",Custing(@"喜报", nil),currentVersion] font:Font_cellContent_16 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentCenter];
    titleLbl.center = CGPointMake(Main_Screen_Width/2, Y(qrImage)+HEIGHT(qrImage)+10+HEIGHT(titleLbl)/2);
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLbl];
}

-(void)back:(UIButton *)btn{
    [YXSpritesLoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createAboutView{
    
    NSDictionary * result = [_resultDict objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
        self.idd = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
        self.descriptio = [NSString stringWithFormat:@"%@",[result objectForKey:@"description"]];
        self.contactNumber = [NSString stringWithFormat:@"%@",[result objectForKey:@"contactNumber"]];
        self.contactQQ = [NSString stringWithFormat:@"%@",[result objectForKey:@"contactQQ"]];
        self.website = [NSString stringWithFormat:@"%@",[result objectForKey:@"website"]];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:Font_cellContent_16, NSFontAttributeName, nil];
    
    CGSize descSize = [self.descriptio boundingRectWithSize:CGSizeMake(Main_Screen_Width-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.aboutUSTV = [[UITextView alloc]initWithFrame:CGRectMake(15, Main_Screen_Width/2-30, Main_Screen_Width-30, descSize.height+42)];
    self.aboutUSTV.font = Font_Same_12_20;
    self.aboutUSTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    if ([NSString isEqualToNull:self.descriptio]) {
        self.aboutUSTV.text = self.descriptio;
    }
    self.aboutUSTV.textColor = Color_form_TextFieldBackgroundColor;
    self.aboutUSTV.editable = NO;
    self.aboutUSTV.scrollEnabled=NO;
    self.aboutUSTV.delegate = self;
    self.aboutUSTV.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.aboutUSTV];
    
    UIView * contenteHView = [[UIView alloc]initWithFrame:CGRectMake(7.5,Y(self.aboutUSTV)+descSize.height/2+42, Main_Screen_Width-15, 0.5)];
    contenteHView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.scrollView addSubview:contenteHView];
    
//    [[[[NSUserDefaults standardUserDefaults] stringForKey:AppLanguage]isEqualToString:@"zh-Hans"]?@"ch":@"en" isEqualToString:@"ch"]?YES:NO;

//    CGFloat scale = [UIScreen mainScreen].bounds.size.width;
//    NSInteger  widthStr = 0;
//    NSInteger contentWStr = 0;
//    if (scale<=320) {
//        widthStr = 7.5;
//        contentWStr = 0;
//    }else {
//        widthStr = 17.5;
//        contentWStr = 10;
//    }
    
//    UILabel * wxGLa = [GPUtils createLable:CGRectMake((lan)?19:widthStr, Y(contenteHView)+20, Main_Screen_Width - 39, 22) text:[NSString stringWithFormat:@"%@ xibaoxiao",Custing(@"微信公众号:", nil)] font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
//    wxGLa.backgroundColor = [UIColor clearColor];
//    [self.scrollView  addSubview:wxGLa];
//    
//
//    UILabel * urlLa = [GPUtils createLable:CGRectMake((lan)?19:widthStr, Y(wxGLa)+32, (lan)?70:180, 22) text:Custing(@"喜报官网:", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
//    urlLa.backgroundColor = [UIColor clearColor];
//    [self.scrollView  addSubview:urlLa];
//    
//    UIButton * urlBtn = [GPUtils createButton:CGRectMake((lan)?92:185+contentWStr, Y(wxGLa)+32, 150, 22) action:@selector(websiteReturn:) delegate:self];
//    [urlBtn setTitle:self.website forState:UIControlStateNormal];
//    [urlBtn setTitleColor:Color_gold forState:UIControlStateNormal];
//    urlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    urlBtn.titleLabel.font = Font_Important_15_20;
//    urlBtn.backgroundColor = [UIColor clearColor];
//    [self.scrollView addSubview:urlBtn];
//    
//    //电话
//    UILabel * phoneLa = [GPUtils createLable:CGRectMake((lan)?19:widthStr, Y(urlLa)+32, (lan)?70:60, 22) text:Custing(@"客服热线:", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
//    phoneLa.backgroundColor = [UIColor clearColor];
//    [self.scrollView  addSubview:phoneLa];
//    
//    UIButton * phoneBtn = [GPUtils createButton:CGRectMake((lan)?92:65+contentWStr, Y(urlLa)+32, 150, 22) action:@selector(callUsPhone:) delegate:self];
//    [phoneBtn setTitle:self.contactNumber forState:UIControlStateNormal];
//    [phoneBtn setTitleColor:Color_gold forState:UIControlStateNormal];
//    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    phoneBtn.titleLabel.font = Font_Important_15_20;
//    phoneBtn.backgroundColor = [UIColor clearColor];
//    [self.scrollView addSubview:phoneBtn];
//    
//    UILabel * qqLa = [GPUtils createLable:CGRectMake((lan)?19:widthStr, Y(phoneBtn)+32, (lan)?70:160, 22) text:Custing(@"QQ客服:", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentLeft];
//    qqLa.backgroundColor = [UIColor clearColor];
//    [self.scrollView  addSubview:qqLa];
//    
//    UIButton * qqBtn = [GPUtils createButton:CGRectMake((lan)?92:165+contentWStr, Y(phoneBtn)+32, 150, 22) action:@selector(qqReturn:) delegate:self];
//    [qqBtn setTitle:self.contactQQ forState:UIControlStateNormal];
//    [qqBtn setTitleColor:Color_gold forState:UIControlStateNormal];
//    qqBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    qqBtn.titleLabel.font = Font_Important_15_20;
//    qqBtn.backgroundColor = [UIColor clearColor];
//    [self.scrollView addSubview:qqBtn];
    
    UILabel *compent = [GPUtils createLable:CGRectMake(0, HEIGHT(_scrollView)-30, Main_Screen_Width, 20) text:Custing(@"上海星汉信息技术有限公司", nil) font:Font_Important_15_20 textColor:Color_form_TextFieldBackgroundColor textAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:compent];
}

-(void)websiteReturn:(UIButton *)btn{
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.website]]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.website]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


-(void)qqReturn:(UIButton *)btn{// 检测是否安装了QQ
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString * befStr = [NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin="];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",befStr,self.contactQQ]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                    message:Custing(@"该设备不支持QQ功能", nil)
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定", nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }
    
}

//alertView的delegate方法（用于打电话）
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //可以调用系统的打电话功能
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.contactNumber]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)callUsPhone:(UIButton *)btn{
    
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:Custing(@"提示信息", nil)
                                                    message:@"该设备不支持电话功能"
                                                   delegate:nil
                                          cancelButtonTitle:Custing(@"确定", nil)
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@",self.contactNumber];
        
        UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"取消", nil) otherButtonTitles:Custing(@"呼叫", nil), nil];
        [lertView show];
    }
}


//
-(void)requestSend{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@",about] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSLog(@"resDic:%@",responceDic);
    [YXSpritesLoadingView dismiss];
        NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
        if ([success isEqualToString:@"0"]) {
    
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:2.0];
            return;
        }
    //description//id
    
    
    switch (serialNum) {
        case 0://
            _resultDict = responceDic;
//            if (!self.userdatas.cache06) {
//                self.userdatas.cache06 = [NSString GetstringFromDate];
//            }
//            self.userdatas.local06 = self.userdatas.cache06;
//            self.userdatas.localFile06 = _resultDict;
//            [userData savrlocalFile:responceDic type:6];
            [self createAboutView];
            break;
        default:
            break;
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
