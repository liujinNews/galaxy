//
//  BulkImportViewController.m
//  galaxy
//
//  Created by 赵碚 on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "BulkImportViewController.h"
#import "JQScanWrapper.h"

@interface BulkImportViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSString * status;
@property(nonatomic,strong)NJKWebView * webView;
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation BulkImportViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:247/255.0f alpha:1.0f];

    if ([self.status isEqualToString:@"Bulk"]) {
        [self setTitle:Custing(@"批量导入成员", nil) backButton:YES];
        
        CGRect webSize =CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-NavigationbarHeight);
        self.webView = [[NJKWebView alloc]initWithFrame:webSize];
        self.webView.progressProxy.webViewProxyDelegate = self;
        self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
        NSURL* url = [NSURL URLWithString:self.JoinStr];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
        
    }else if ([self.status isEqualToString:@"Add"]){
        self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:247/255.0f alpha:1.0f];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - NavigationbarHeight)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
        [self setTitle:Custing(@"填写企业号加入", nil) backButton:YES];
        
        CGFloat scale = [UIScreen mainScreen].bounds.size.height;
        NSInteger  widthStr = 5;
        if (scale<=480) {
            widthStr = 130;
        }else if (scale >=480&&568>=scale){
            widthStr = 100;
        }

        CGRect webSize =CGRectMake(0, 100, Main_Screen_Width, Main_Screen_Height - NavigationbarHeight+widthStr);
        self.webView = [[NJKWebView alloc]initWithFrame:webSize];
        self.webView.progressProxy.webViewProxyDelegate = self;
        self.webView.backgroundColor = Color_form_TextFieldBackgroundColor;
        NSURL* url = [NSURL URLWithString:self.JoinStr];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];        
        
        NSInteger height = [[_webView stringByEvaluatingJavaScriptFromString:
                             @"document.body.scrollHeight"] integerValue];
        
        self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width, height);
        
        [self.scrollView addSubview:self.webView];
        
        if (![NSString isEqualToNull:self.corpId]) {
            self.corpId = @"";
        }
        
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 100)];
        headView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self.scrollView addSubview:headView];

        UILabel * lookLa = [GPUtils createLable:CGRectMake(0, 25, Main_Screen_Width, 20) text:Custing(@"当前企业号", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [headView addSubview:lookLa];
        
        UILabel * corpIdLa = [GPUtils createLable:CGRectMake(0, 48, Main_Screen_Width, 30) text:[NSString stringWithFormat:@"%@",self.corpId] font:[UIFont systemFontOfSize:25.0f] textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
        [corpIdLa setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28.0f]];
        [headView addSubview:corpIdLa];
        
    }else if ([self.status isEqualToString:@"Join"]){
        [self setTitle:Custing(@"面对面扫码加入", nil) backButton:YES];
        UIImage *qrImg = [JQScanWrapper createQRWithString:self.JoinStr size:CGSizeMake(150, 150)];
        qrImg=[JQScanWrapper imageBlackToTransparent:qrImg withRed:2 andGreen:173 andBlue:252];

        UIImageView *qrImageView = [[UIImageView alloc]initWithImage:qrImg];
        qrImageView.backgroundColor = Color_form_TextFieldBackgroundColor;
        qrImageView.frame = CGRectMake(Main_Screen_Width/2-75, Main_Screen_Height/5, 150, 150);
        [self.view addSubview:qrImageView];
        
        
        UILabel *codeTitle=[GPUtils createLable:CGRectMake(10, 0, Main_Screen_Width - 20, 30) text:Custing(@"扫一扫加入公司", nil) font:Font_Important_18_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        codeTitle.center=CGPointMake(Main_Screen_Width/2, Main_Screen_Height/5+170);
        [self.view addSubview:codeTitle];
        
    }
    // Do any additional setup after loading the view.
}

-(void)dealloc {
    self.webView.progressProxy.webViewProxyDelegate = nil;
}
//
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"erros is %@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"hello");
   
    
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
