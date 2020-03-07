//
//  LoginViewController.m
//  galaxy
//
//  Created by hfk on 16/4/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "registerVController.h"

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "MessageViewController.h"
#import "TravelViewController.h"
#import "ReimburseViewController.h"
#import "WorkViewController.h"
#import "MineViewController.h"
#import "SecondRootViewController.h"
@interface LoginViewController ()<GPClientDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    btn.backgroundColor=[UIColor cyanColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *registerbtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 200, 50, 50)];
    registerbtn.backgroundColor=[UIColor cyanColor];
    [registerbtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerbtn];
    
    UIButton *lostbtn=[[UIButton alloc]initWithFrame:CGRectMake(200, 200, 50, 50)];
    lostbtn.backgroundColor=[UIColor cyanColor];
    [lostbtn addTarget:self action:@selector(lostPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [lostbtn setTitle:@"找回" forState:UIControlStateNormal];

    [self.view addSubview:lostbtn];
    
    [self requestReserveList];
    
}

-(void)lostPasswordBtn:(UIButton *)btn{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"当前网络不可用，请检查您的网络" duration:2.0];
        return;
    }else{
        registerVController * rvc = [[registerVController alloc]initWithType:@"lostPassword"];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

-(void)registerBtn:(UIButton *)btn{
//    [self headerViewWillHide];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"当前网络不可用，请检查您的网络" duration:2.0];
        return;
    }else{
        registerVController * rvc = [[registerVController alloc]initWithType:@"register"];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
}


-(void)btnClick:(UIButton *)btn{
    //用 storyboard  
    UIStoryboard *Message = [UIStoryboard storyboardWithName:@"MessageView" bundle:[NSBundle mainBundle]];
    UINavigationController *MessageNav = Message.instantiateInitialViewController;
    UIViewController *firstNavigationController = MessageNav;
    
    UIViewController *secondViewController = [[TravelViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[ReimburseViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    UIViewController *fourthViewController = [[WorkViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    UIViewController *fifthViewController = [[MineViewController alloc] init];
    UIViewController *fifthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fifthViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,fourthNavigationController,fifthNavigationController]];
    
    [[firstNavigationController rdv_tabBarItem] setBadgeValue:@"18"];
    
    
    SecondRootViewController *sec=[[SecondRootViewController alloc]init];
    sec=(id)tabBarController;
    tabBarController.selectedIndex=2;
    [self customizeTabBarForController:tabBarController];
    UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
    window.rootViewController =sec;
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"Message", @"Travel", @"Reimburse",@"Work",@"Mine"];
    NSArray *titleItems=@[@"消息", @"差旅", @"费用",@"工作",@"我的"];
    //    title
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *lineImage=[UIImage imageNamed:@"tabbar_selected_background"];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage withLineImage:lineImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title=titleItems[index];
        index++;
    }
}

-(void)requestReserveList{

//    NSDictionary *parameters = @{@"account":@"13266663257",@"password": @"111111a",@"language":@"ch",@"SigIsEffect":@"1"};


    NSDictionary *parameters = @{@"account":@"18235011820",@"password": @"123abc",@"language":@"ch",@"SigIsEffect":@"1"};
    
    [[GPClient shareGPClient]requestByPostWithPath:[NSString stringWithFormat:@"%@%@",kServer,requestFilterList] Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    
}

- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    
    [YXSpritesLoadingView dismiss];
    NSDictionary * result = [responceDic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"galaxy_userInfo"];
    self.userdatas = nil;
    
    self.userdatas = [[userData alloc]init];
    self.userdatas.language = [NSString stringWithFormat:@"%@",[result objectForKey:@"language"]];
    self.userdatas.company = [NSString stringWithFormat:@"%@",[result objectForKey:@"companyId"]];
    self.userdatas.name = [NSString stringWithFormat:@"%@",[result objectForKey:@"userDspName"]];
    self.userdatas.token = [NSString stringWithFormat:@"%@",[result objectForKey:@"token"]];
    self.userdatas.userId = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
    
    NSDictionary * dic = [GPUtils transformToDictionaryFromString:[NSString stringWithFormat:@"%@",[result objectForKey:@"photoGraph"]]];
    if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
        self.userdatas.photoGraph = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
    }else{
        self.userdatas.photoGraph = nil;
    }


//    self.userdatas.logName = @"13266663257";
//    self.userdatas.password = @"111111a";
    
    self.userdatas.logName = @"18235011820";
    self.userdatas.password = @"123abc";




    //[MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",self.acountTF.text]];
    [MobClick endEvent:@"dengluNumber"];//登录次数
    self.userdatas.isLogin = Login_yes;
    
    [self.userdatas storeUserInfo];
    
    switch (serialNum) {
        case 0://
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
