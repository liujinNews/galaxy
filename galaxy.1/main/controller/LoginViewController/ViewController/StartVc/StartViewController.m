//
//  StartViewController.m
//  FitTu
//
//  Created by yyh on 14/12/23.
//  Copyright (c) 2014年 yyh. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "MainLoginViewController.h"
#import "RootWebViewController.h"

#define ISFISTRINSTALL @"ISFISTRINSTALL"

@interface StartViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIView *tipsView;

@end

@implementation StartViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTranslucent:YES];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
       
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[AppDelegate appDelegate]registerInfo];
    [self initScrollView];
    [self initPageControl];
    [self createTipsView];

}

//添加scrollView
- (void)initScrollView
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    
    for (int i = 0; i < 4; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"200%d",i ];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imgView.frame = CGRectMake(Main_Screen_Width * i, 0, Main_Screen_Width, Main_Screen_Height);
        [_scrollView addSubview:imgView];
        
        if (i == 3) {
            self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.startButton.frame = CGRectMake(Main_Screen_Width/2-74, Main_Screen_Height -80, 149, 35);
            [self.startButton setBackgroundImage:[UIImage imageNamed:@"state_login"] forState:UIControlStateNormal];
            self.startButton.hidden = YES;
            [self.startButton addTarget:self action:@selector(changeRootViewController) forControlEvents:UIControlEventTouchUpInside];
            [self.startButton setBackgroundColor:[UIColor clearColor]];
            [imgView addSubview:self.startButton];
            imgView.userInteractionEnabled = YES;
            
        }
    }
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(Main_Screen_Width * 4, Main_Screen_Height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.scrollView];
    
}

// 添加pageControl
- (void)initPageControl{
    self.pageControl = [UIPageControl new];
    self.pageControl.currentPageIndicatorTintColor = Color_form_TextFieldBackgroundColor;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    self.pageControl.bounds = CGRectMake(0, 0, 90, 20);
    self.pageControl.center = CGPointMake(Main_Screen_Width / 2, Main_Screen_Height - 50);
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = self.scrollView.contentSize.width/Main_Screen_Width;
    self.pageControl.currentPage = 0;
    
    self.scrollView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.view addSubview:self.pageControl];
    
}

#pragma mark PageControlDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / Main_Screen_Width;
    [self showButton:self.pageControl.currentPage];

}

#pragma mark -
#pragma mark PageControlDelegate

- (void)changePage:(UIPageControl *)aPageControl
{
    
    [self.scrollView setContentOffset:CGPointMake(aPageControl.currentPage * Main_Screen_Width, 0) animated:YES];
    [self showButton:aPageControl.currentPage];
    
}

//显示按钮
- (void)showButton:(NSInteger )index{
    if (index == 3) {
        self.pageControl.hidden = YES;
        self.startButton.hidden = NO;
    }
    else
    {
        self.pageControl.hidden = NO;
    }
}
- (void)changeRootViewController{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    MainLoginViewController *vc=[[MainLoginViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    delegate.window.rootViewController = nav;
}
//liu_s
- (void)createTipsView{

    //禁止scrollview滑动
    self.scrollView.scrollEnabled = NO;
    //创建视图
    float gapW = 15;
    float gapH = 20;
    float tipViewGapW ;
    if (Main_Screen_Width > 375) {
        tipViewGapW = 3*gapW;
    }else{
        tipViewGapW = 2*gapW;

    }
    float tipsViewH = 0;
    float tipsViewW = Main_Screen_Width-2*tipViewGapW;
    //创建底视图
    UIView *tipsView = [[UIView alloc] init];
    tipsView.frame = CGRectMake(tipViewGapW, (Main_Screen_Height - tipsViewH)*3/5.0, tipsViewW,tipsViewH);
    [self.view addSubview:tipsView];
    tipsView.clipsToBounds = YES;
    tipsView.layer.cornerRadius = 10.0f;
    tipsView.backgroundColor = Color_form_TextFieldBackgroundColor;
    self.tipsView = tipsView;
    [self.view bringSubviewToFront:tipsView];
    //创建标题lab
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake((WIDTH(tipsView)-100)/2.0, gapH, 100, 20);
    titleLab.text = Custing(@"温馨提示", nil);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = Color_Black_Important_20;
    [tipsView addSubview:titleLab];
    //创建分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(titleLab)+20, WIDTH(tipsView), 0.5)];
    lineView.backgroundColor = Color_LineGray_Same_20;
    [tipsView addSubview:lineView];
    
    
    //创建文字间距格式
    
    UILabel *textLab1 = [[UILabel alloc] initWithFrame:CGRectMake(gapW, MaxY(lineView)+20, WIDTH(tipsView) - 1.9*gapW, 40)];
    NSString *text1 = Custing(@"亲爱的用户，感谢您一直以来的支持！为了更好地保护您的权益，同时遵守相关监管要求，", nil);
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:text1];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text1 length])];
    textLab1.attributedText = attributedString1;
    textLab1.text = text1;
    textLab1.font = Font_Same_14_20;
    textLab1.numberOfLines = 0;
    textLab1.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab1];
    UILabel *textLab2 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab1), 73, 20)];
    textLab2.text = Custing(@"我们更新了", nil);
    textLab2.font = Font_Same_14_20;
    textLab2.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab2];
    //创建协议按钮
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [protocolBtn setTitle:Custing(@"《喜报隐私协议》", nil) forState:UIControlStateNormal];
    [protocolBtn setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
    [protocolBtn setFrame:CGRectMake(MaxX(textLab2), MaxY(textLab1), 125, 20)];
    protocolBtn.titleLabel.font = Font_Same_14_20;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:protocolBtn];
    
    UILabel *textLab3 = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(protocolBtn), MaxY(textLab1), WIDTH(tipsView)-WIDTH(textLab2)-WIDTH(protocolBtn)-2*gapW, 20)];
    textLab3.text = Custing(@"，特向您说", nil);
    textLab3.font = Font_Same_14_20;
    textLab3.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab3];
    
    UILabel *textLab4 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab2), 73, 20)];
    textLab4.text = Custing(@"明如下：", nil);
    textLab4.font = Font_Same_14_20;
    textLab4.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab4];
    
    UILabel *textLab5 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab4)+10, WIDTH(tipsView)-2*gapW, 40)];

    NSString *text5 = Custing(@"1.为了向您提供基本服务，我们会遵循正当，合法，必要的原则收集和使用必要的信息；", nil);
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:text5];
    NSMutableParagraphStyle *paragraphStyle5 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle5 setLineSpacing:3];
    [attributedString5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle5 range:NSMakeRange(0, [text5 length])];
    textLab5.attributedText = attributedString5;
    textLab5.text = text5;
    textLab5.numberOfLines = 0;
    textLab5.font = Font_Same_14_20;
    textLab5.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab5];
    
    UILabel *textLab6 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab5)+10, WIDTH(tipsView)-2*gapW, 60)];
    NSString *text6 = Custing(@"2.基于您的授权我们可能会收集和使用您的位置信息以便为您提供自驾车以及打卡服务，您有权拒绝或取消授权；", nil);
    NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:text6];
    NSMutableParagraphStyle *paragraphStyle6 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle6 setLineSpacing:3];
    [attributedString6 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle6 range:NSMakeRange(0, [text5 length])];
    textLab6.attributedText = attributedString6;
    textLab6.text = text6;
    textLab6.numberOfLines = 0;
    textLab6.font = Font_Same_14_20;
    textLab6.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab6];
    
    UILabel *textLab7 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab6)+10, WIDTH(tipsView)-2*gapW, 40)];
    NSString *text7 = Custing(@"3.未经您的授权同意，我们不会将您的信息共享给第三方或用于您未授权的其他用途；", nil);
    NSMutableAttributedString *attributedString7 = [[NSMutableAttributedString alloc] initWithString:text7];
    NSMutableParagraphStyle *paragraphStyle7 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle7 setLineSpacing:3];
    [attributedString7 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle7 range:NSMakeRange(0, [text7 length])];
    textLab7.attributedText = attributedString7;
    textLab7.text = text7;
    textLab7.numberOfLines = 0;
    textLab7.font = Font_Same_14_20;
    textLab7.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab7];
    
    UILabel *textLab8 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab7)+10, WIDTH(tipsView)-2*gapW, 40)];
    NSString *text8 = Custing(@"4.您可以对上述信息进行访问、更正、删除、以及注销账号。", nil);
    NSMutableAttributedString *attributedString8 = [[NSMutableAttributedString alloc] initWithString:text8];
    NSMutableParagraphStyle *paragraphStyle8 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle8 setLineSpacing:3];
    [attributedString8 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle8 range:NSMakeRange(0, [text8 length])];
    textLab8.attributedText = attributedString5;
    textLab8.text = text8;
    textLab8.numberOfLines = 0;
    textLab8.font = Font_Same_14_20;
    textLab8.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab8];
    
    UILabel *textLab9 = [[UILabel alloc]initWithFrame:CGRectMake(gapW, MaxY(textLab8)+10, WIDTH(tipsView)-2*gapW, 40)];
    NSString *text9 = Custing(@"喜报将一如既往坚守使命，帮助大家工作得更好，生活更好！", nil);
    NSMutableAttributedString *attributedString9 = [[NSMutableAttributedString alloc] initWithString:text9];
    NSMutableParagraphStyle *paragraphStyle9 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle9 setLineSpacing:3];
    [attributedString9 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle9 range:NSMakeRange(0, [text9 length])];
    textLab9.attributedText = attributedString9;
    textLab9.text = text9;
    textLab9.numberOfLines = 0;
    textLab9.font = Font_Same_14_20;
    textLab9.textColor = Color_Black_Important_20;
    [tipsView addSubview:textLab9];
    
    //创建拒绝按钮
    float btnW = (WIDTH(tipsView) - 3*gapW)/2.0;
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [refuseBtn setTitle:Custing(@"拒绝", nil) forState:UIControlStateNormal];
    [refuseBtn setTitleColor:Color_Black_Important_20 forState:UIControlStateNormal];
    refuseBtn.clipsToBounds = YES;
    refuseBtn.layer.cornerRadius = 5.0f;
    [refuseBtn setBackgroundColor:Color_White_Same_20];
    [refuseBtn setFrame:CGRectMake(gapW, MaxY(textLab9)+gapH, btnW, 3*gapW)];
    [refuseBtn addTarget:self action:@selector(refuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:refuseBtn];
    //创建接受按钮
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [acceptBtn setTitle:Custing(@"接受", nil) forState:UIControlStateNormal];
    acceptBtn.clipsToBounds = YES;
    acceptBtn.layer.cornerRadius = 5.0f;
    [acceptBtn setBackgroundColor:Color_Blue_Important_20];
    [acceptBtn setTitleColor:Color_Black_Important_20 forState:UIControlStateNormal];
    [acceptBtn setFrame:CGRectMake(MaxX(refuseBtn)+gapW, MaxY(textLab9)+gapH, btnW, 3*gapW)];
    [acceptBtn addTarget:self action:@selector(acceptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:acceptBtn];
    
    tipsViewH = MaxY(acceptBtn) + gapW;
    tipsView.frame = CGRectMake(tipViewGapW, (Main_Screen_Height - tipsViewH)*5/9.0, tipsViewW,tipsViewH);
}
//拒绝协议
- (void)refuseBtnClick:(UIButton *)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:Custing(@"您需要同意才能继续使用我们的服务哦", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:Custing(@"暂不", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:Custing(@"去同意", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:noAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
  
}
//接受协议
- (void)acceptBtnClick:(UIButton *)sender{
    //禁止scrollview滑动
    self.scrollView.scrollEnabled = YES;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@"aa" forKey:ISFISTRINSTALL];
    [userDef synchronize];
    [self.tipsView removeFromSuperview];
}
- (void)protocolBtnClick:(UIButton *)sender{
    RootWebViewController *vc = [[RootWebViewController alloc]initWithUrl:@"http://139.196.104.114:82/rule.html"];
    [self.navigationController pushViewController:vc animated:YES];
}
//liu_e
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
