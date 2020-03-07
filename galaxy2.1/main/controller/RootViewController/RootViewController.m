//
//  RootViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()
@property (strong, nonatomic) UIButton *NavTitleBtn;
@property (strong, nonatomic) UIButton *NavBackBtn;
@end

@implementation RootViewController

@synthesize universalDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_form_TextFieldBackgroundColor;
    if (!self.userdatas) {
        self.userdatas = [userData shareUserData];
    }
    [self setNavigationController];
}

-(void)setNavigationController{
    self.userdatas = [userData shareUserData];
    if (self.userdatas.SystemType==1) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationController.navigationBar.barTintColor =Color_Orange_Weak_20;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: Color_form_TextFieldBackgroundColor,NSFontAttributeName:Font_Important_18_20}];
    }else{
        if ([FestivalStyle isEqualToString:@"1"]) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Festival_NavBar"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Color_form_TextFieldBackgroundColor}];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//            self.navigationController.navigationBar.barTintColor = Color_form_TextFieldBackgroundColor;
//            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: Color_Unsel_TitleColor,NSFontAttributeName:Font_Important_18_20}];
            //[XBColorSupport supportUnselectedTabbarTitleColor]
            self.navigationController.navigationBar.barTintColor = [XBColorSupport supportTabbarBackgroundColor];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [XBColorSupport supportUnselectedTabbarTitleColor],NSFontAttributeName:Font_Important_18_20}];
        }
    }
    self.navigationController.navigationBar.translucent = NO;
}
- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  设置导航栏
 *
 *  @param title          导航栏标题
 *  @param showBackButton 是否显示返回按钮
 */
-(void)setTitle:(NSString *)title backButton:(BOOL)showBackButton
{
    self.navigationItem.backBarButtonItem = nil;
    if (showBackButton){
        UIImage *image;
        if (self.userdatas.SystemType==1) {
            image=[UIImage imageNamed:@"Share_AgentGoBack"];
        }else{
            image=[UIImage imageNamed:@"NavBarImg_GoBack"];
        }
        _NavBackBtn=[GPUtils createButton:CGRectMake(0,0, 40, 40) action:@selector(Navback) delegate:self];
        [_NavBackBtn setImage:image forState:UIControlStateNormal];
        _NavBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_NavBackBtn];
        [self.navigationItem setLeftBarButtonItem:barButtonItem];
    }else{
        self.navigationItem.hidesBackButton = YES;
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
    
    if (title && [title isKindOfClass:[NSString class]] && [title length]>0){
        self.navigationController.navigationBar.hidden = NO;
        self.navigationItem.title = title;
    }
}
/**
 创建导航栏信息
 @param title 标题
 @param showBackButton 是否显示返回按钮
 @param img 标题右边图片
 @param index 返回index
 */
-(void)setTitle:(NSString *)title backButton:(BOOL)showBackButton WithTitleImg:(NSString *)img{
    [self setTitle:title backButton:showBackButton];
    if (img&& [img isKindOfClass:[NSString class]]&&img.length>0) {
        self.navigationItem.title = nil;
        if (!_NavTitleBtn) {
            _NavTitleBtn = [[UIButton alloc]init];
            [_NavTitleBtn setTitleColor:Color_Unsel_TitleColor forState:UIControlStateNormal];
            [_NavTitleBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
            [_NavTitleBtn addTarget:self action:@selector(ImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.titleView = _NavTitleBtn;
            title=title?title:@"";
            CGSize size = [title sizeCalculateWithFont:_NavTitleBtn.titleLabel.font constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByTruncatingTail];
            CGFloat titleWidth =size.width;
            CGFloat imageWidth = 20;
            CGFloat btnWidth = titleWidth +imageWidth;
            _NavTitleBtn.frame = CGRectMake((Main_Screen_Width-btnWidth)/2, (44-30)/2, btnWidth, 30);
            _NavTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            _NavTitleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
            [_NavTitleBtn setTitle:title forState:UIControlStateNormal];
            [_NavTitleBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }
    }
}
-(void)Navback{
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if ([NSString isEqualToNull:_backIndex]&&index > [_backIndex integerValue]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: [_backIndex integerValue]] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 标题按钮点击
 */
-(void)ImageClicked:(id)obj{

}

-(void)createOtherBackWithTag:(NSInteger)tag{
    UIButton* leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,40,40)];
    leftbtn.contentEdgeInsets = UIEdgeInsetsMake(0,-30, 0, 0);
    leftbtn.tag=tag;
    [leftbtn addTarget:self action:@selector(OtherBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (self.userdatas.SystemType==1) {
        [leftbtn setImage:[[UIImage imageNamed:@"Share_AgentGoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [leftbtn setImage:[[UIImage imageNamed:@"NavBarImg_GoBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    UIBarButtonItem* leBtn = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leBtn;
}

-(void)keyClose
{
    [self.view endEditing:YES];
}


-(void)OtherBackBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-_backCount)] animated:YES];
        }
            break;
        case 2:
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:_backCount] animated:YES];
            break;
        default:
            break;
    }
}
//获取当前屏幕显示的viewcontroller  
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

/**
 *  延迟执行
 *
 *  @param block 执行的block
 *  @param delay 延迟的时间：秒
 */
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (void)tabBarItemClicked{
    DebugLog(@"\ntabBarItemClicked : %@", NSStringFromClass([self class]));
}

//MARK:-转json
-(NSString*)transformToJson:(id)object{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)createLineView{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    
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

-(UIView *)createLineViewOfHeight:(CGFloat)height{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,height, Main_Screen_Width,0.5)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
}

-(UIView *)createLineViewOfHeight:(CGFloat)height X:(CGFloat)x{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(x,height, Main_Screen_Width-x,0.5)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
}

-(UIView *)createLineViewOfHeight_ByTitle:(CGFloat)height{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(12,height, Main_Screen_Width,0.5)];
    view.backgroundColor=Color_GrayLight_Same_20;
    return view;
}

-(void)goToReSubmitWithModel:(FormBaseModel *)model{
    if (model.int_comeStatus == 2 || model.int_comeStatus == 8) {
        NSString *pushController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:model.str_flowCode][@"pushController"];
        Class cls = NSClassFromString(pushController);
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId = model.str_taskId;
        vc.pushUserId = model.str_userId;
        vc.pushProcId = [NSString stringWithFormat:@"%@",model.dict_resultDict[@"result"]];
        if ([model.str_flowCode isEqualToString:@"F0010"]) {
            vc.pushExpenseCode = model.str_expenseCode;
        }
//        vc.pushFlowGuid = model.str_flowGuid;
        vc.pushComeStatus = @"4";
        vc.pushBackIndex = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goSubmitSuccessToWithModel:(FormBaseModel *)model{
    NSString *str_taskId = [NSString stringWithFormat:@"%@",model.dict_resultDict[@"result"]];
    if ([NSString isEqualToNull:str_taskId]) {
        NSString *pushHasController = [[VoiceDataManger sharedManager]getControllerNameWithFlowCode:model.str_flowCode][@"pushHasController"];
        Class cls = NSClassFromString(pushHasController);
        UIViewController *vc = [[cls alloc] init];
        vc.pushTaskId = str_taskId;
//        vc.pushFlowGuid = model.str_flowGuid;
        vc.pushProcId = @"";
        vc.pushComeStatus = @"1";
        if (model.int_comeStatus == 1) {
            vc.pushBackIndex = @"0";
        }else{
            vc.pushBackIndex = @"1";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
