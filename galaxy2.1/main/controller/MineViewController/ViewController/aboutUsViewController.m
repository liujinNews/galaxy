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

@end

@implementation aboutUsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}
//#pragma mark--待审批操作完成后回来刷新
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestSend];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavBarHeight)];
    
    //[self setTitle:@"操作说明" backButton:YES withSystemType:@"0"];
    [self setTitle:@"关于喜报" backButton:YES];
    UIImageView * bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width*1.6232)];
    bgImage.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:bgImage];
    bgImage.image = GPImage(@"my_aboutUs");
//    if ([self.status isEqualToString:@"costCenterInfo"]) {
//        bgImage.image = GPImage(@"costCenterInfomation");
//    }else if ([self.status isEqualToString:@"editPositionInfo"]){
//        bgImage.image = GPImage(@"editPositionInfo");
//    }
    [bgImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    bgImage.contentMode =  UIViewContentModeScaleAspectFill;
    bgImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bgImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    bgImage.clipsToBounds  = YES;
    self.scrollView.contentSize = bgImage.frame.size;
    [self.view addSubview:self.scrollView];
    
    
    // Do any additional setup after loading the view.
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
    self.aboutUSTV = [[UITextView alloc]initWithFrame:CGRectMake(15, 90*Main_Screen_Height/Main_Screen_Width, Main_Screen_Width-30, descSize.height+42)];
    self.aboutUSTV.font = Font_Same_12_20;
    self.aboutUSTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.aboutUSTV.text = self.descriptio;
    self.aboutUSTV.textColor = [UIColor whiteColor];
    self.aboutUSTV.editable = NO;
    self.aboutUSTV.scrollEnabled=NO;
    self.aboutUSTV.delegate = self;
    self.aboutUSTV.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.aboutUSTV];
    
    UIView * contenteHView = [[UIView alloc]initWithFrame:CGRectMake(7.5,Y(self.aboutUSTV)+descSize.height/2+42, Main_Screen_Width-15, 0.5)];
    contenteHView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contenteHView];
    
    UILabel * wxGLa = [GPUtils createLable:CGRectMake(32, Y(contenteHView)+20, 200, 22) text:@"微信公众号: xibaoxiao" font:Font_Important_15_20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    wxGLa.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:wxGLa];
    
    
    UILabel * urlLa = [GPUtils createLable:CGRectMake(32, Y(wxGLa)+32, 70, 22) text:@"喜报官网:" font:Font_Important_15_20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    urlLa.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:urlLa];
    
    UIButton * urlBtn = [GPUtils createButton:CGRectMake(105, Y(wxGLa)+32, 150, 22) action:@selector(websiteReturn:) delegate:self];
    [urlBtn setTitle:self.website forState:UIControlStateNormal];
    [urlBtn setTitleColor:Color_gold forState:UIControlStateNormal];
    urlBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    urlBtn.titleLabel.font = Font_Important_15_20;
    urlBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:urlBtn];
    
    //电话
    UILabel * phoneLa = [GPUtils createLable:CGRectMake(32, Y(urlLa)+32, 70, 22) text:@"客服热线:" font:Font_Important_15_20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    phoneLa.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:phoneLa];
    
    UIButton * phoneBtn = [GPUtils createButton:CGRectMake(105, Y(urlLa)+32, 150, 22) action:@selector(callUsPhone:) delegate:self];
    [phoneBtn setTitle:self.contactNumber forState:UIControlStateNormal];
    [phoneBtn setTitleColor:Color_gold forState:UIControlStateNormal];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    phoneBtn.titleLabel.font = Font_Important_15_20;
    phoneBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:phoneBtn];
    
    UILabel * qqLa = [GPUtils createLable:CGRectMake(32, Y(phoneBtn)+32, 70, 22) text:@"QQ客服:" font:Font_Important_15_20 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    qqLa.backgroundColor = [UIColor clearColor];
    [self.scrollView  addSubview:qqLa];
    
    UIButton * qqBtn = [GPUtils createButton:CGRectMake(105, Y(phoneBtn)+32, 150, 22) action:@selector(qqReturn:) delegate:self];
    [qqBtn setTitle:self.contactQQ forState:UIControlStateNormal];
    [qqBtn setTitleColor:Color_gold forState:UIControlStateNormal];
    qqBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    qqBtn.titleLabel.font = Font_Important_15_20;
    qqBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:qqBtn];
    
    
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
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示信息"
                                                    message:@"该设备不支持QQ功能"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
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
    //判断能否打电话
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示信息"
                                                    message:@"该设备不支持电话功能"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil,nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@",self.contactNumber];
        
        UIAlertView * lertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:Custing(@"cancel", nil) otherButtonTitles:Custing(@"call", nil), nil];
        [lertView show];
    }
    
    
}


//
-(void)requestSend{
    
    [[GPClient shareGPClient]REquestByPostWithPath:[NSString stringWithFormat:@"%@%@",kServer,about] Parameters:nil Delegate:self SerialNum:0 IfUserCache:NO];
    [YXSpritesLoadingView showWithText:@" " andShimmering:NO andBlurEffect:NO];
    
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
    if ([responceFail isEqualToString:@"The request timed out."]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"服务器请求超时" duration:2.0];
    }else{
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",responceFail] duration:2.0];
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
