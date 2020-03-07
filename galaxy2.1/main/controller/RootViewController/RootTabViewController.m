//
//  RootTabViewController.m
//  galaxy
//
//  Created by hfk on 16/5/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MessageViewController.h"
#import "RootTabViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "MessageViewController.h"
#import "ReimburseViewController.h"
#import "WorkViewController.h"
#import "MineViewController.h"
#import "TravelMainController.h"
#import "MicroAppViewController.h"
@interface RootTabViewController ()
@property(nonatomic,strong)NSMutableArray *menuArray;
@property(nonatomic,strong)NSMutableArray *tabBarItemImages;//图片
@property(nonatomic,strong)NSMutableArray *titleItems;//文字

@end

@implementation RootTabViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.userdatas) {
        self.userdatas = [userData shareUserData];
    }
    _menuArray=[NSMutableArray array];
    [self setupViewControllers];
    [self initUMessage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)setupViewControllers{
    if ([NSString isEqualToNull:self.userdatas.menuHide]) {
        _menuArray=[NSMutableArray arrayWithArray:[self.userdatas.menuHide componentsSeparatedByString:@","]];
        for (NSInteger i=0; i<_menuArray.count; i++) {
            if (![NSString isEqualToNull:_menuArray[i]]) {
                [_menuArray removeObjectAtIndex:i];
            }
        }
    }
    UIViewController *MessageNav = [[MessageViewController alloc]init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]initWithRootViewController:MessageNav];;
    
    UIViewController *secondViewController = [[TravelMainController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[ReimburseViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    UIViewController *fourthViewController = [[WorkViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    UIViewController *fifthViewController = [[MicroAppViewController alloc] init];
    UIViewController *fifthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fifthViewController];
    UIViewController *sixthViewController = [[MineViewController alloc] init];
    UIViewController *sixthNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:sixthViewController];

    _tabBarItemImages=[NSMutableArray arrayWithArray:@[@"Message", @"Travel", @"Reimburse",@"Work",@"Mine"]];
    _titleItems=[NSMutableArray arrayWithArray:@[Custing(@"消息",nil), Custing(@"差旅",nil), Custing(@"费用", nil),Custing(@"工作", nil),Custing(@"我的",nil)]];
    NSMutableArray *navArray=[NSMutableArray arrayWithArray:@[firstNavigationController, secondNavigationController,thirdNavigationController,fourthNavigationController,fifthNavigationController,sixthNavigationController]];
    
    if (_menuArray.count!=0&&[_menuArray containsObject:@"1"]) {
        [_tabBarItemImages removeObjectsInArray:@[@"Reimburse"]];
        [_titleItems removeObjectsInArray:@[Custing(@"费用", nil)]];
        [navArray removeObjectsInArray:@[thirdNavigationController]];
    }
    
    if (_menuArray.count!=0&&[_menuArray containsObject:@"3"]) {
        [navArray removeObjectsInArray:@[fourthNavigationController]];
    }else{
        [navArray removeObjectsInArray:@[fifthNavigationController]];
    }
    
    if (_menuArray.count!=0&&[_menuArray containsObject:@"5"]) {
        [_tabBarItemImages removeObjectsInArray:@[@"Travel"]];
        [_titleItems removeObjectsInArray:@[Custing(@"差旅", nil)]];
        [navArray removeObjectsInArray:@[secondNavigationController]];
    }
    
    if (_menuArray.count!=0&&[_menuArray containsObject:@"6"]) {
        [_tabBarItemImages removeObjectsInArray:@[@"Message"]];
        [_titleItems removeObjectsInArray:@[Custing(@"消息", nil)]];
        [navArray removeObjectsInArray:@[firstNavigationController]];
    }
    
    [self setViewControllers:navArray];
    
    if ([_titleItems containsObject:Custing(@"费用", nil)]) {
        self.selectedIndex=[_titleItems indexOfObject:Custing(@"费用", nil)];
    }else if ([_titleItems containsObject:Custing(@"工作", nil)]){
        self.selectedIndex=[_titleItems indexOfObject:Custing(@"工作", nil)];
    }else{
        self.selectedIndex=0;
    }
    
    if ([FestivalStyle isEqualToString:@"1"]&&self.userdatas.SystemType==0) {
        [self customizefestivalTabBarForController];
    }else{
        [self customizeTabBarForController];
    }
    self.delegate = self;
}

- (void)customizeTabBarForController {
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.unselectedTitleAttributes=@{
                                         NSFontAttributeName: [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: [XBColorSupport supportUnselectedTabbarTitleColor],
                                         };
        item.selectedTitleAttributes=@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:10],
                                       NSForegroundColorAttributeName:Color_Blue_Important_20,
                                       };
        UIImage *lineImage=[UIImage imageNamed:@"tabbar_selected_background"];
        [item setBackgroundSelectedImage:[UIImage imageNamed:@"tabbar_background"] withUnselectedImage:[UIImage imageNamed:@"tabbar_background"] withLineImage:lineImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [_tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [_tabBarItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title=_titleItems[index];
        index++;
    }
}

- (void)customizefestivalTabBarForController {
    NSInteger index = 0;
    [self tabBar].tabbarImage=[NSString stringWithFormat:@"%@",@"tabbar_bg_Festival"];
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.unselectedTitleAttributes=@{
                                         NSFontAttributeName: [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: Color_form_TextFieldBackgroundColor,
                                         };;
        item.selectedTitleAttributes=@{
                                       NSFontAttributeName: [UIFont systemFontOfSize:10],
                                       NSForegroundColorAttributeName: Color_form_TextFieldBackgroundColor,
                                       };;
        UIImage *lineImage=[UIImage imageNamed:@"tabbar_selected_background"];
        [item setBackgroundSelectedImage:nil withUnselectedImage:nil withLineImage:lineImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Festival_select",
                                                      [_tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Festival_normal",
                                                        [_tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title=_titleItems[index];
        index++;
    }
}

#pragma mark RDVTabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    tabBarController.view.backgroundColor = [XBColorSupport supportFormTextFieldBackgroundColor];
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.topViewController isKindOfClass:[RootViewController class]]) {
        RootViewController *rootVC = (RootViewController *)nav.topViewController;
        [rootVC tabBarItemClicked];
    }
    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
    return YES;
}

-(void)initUMessage{
    [UMessage removeAlias:self.userdatas.userId type:@"GalaxyPoint" response:^(id responseObject, NSError *error) {
        NSLog(@"删除成功");
    }];
//    [UMessage addAlias:self.userdatas.userId type:@"GalaxyPoint" response:^(id responseObject, NSError *error) {
//        NSLog(@"注册成功");
    [UMessage setAlias:self.userdatas.userId type:@"GalaxyPoint" response:^(id responseObject, NSError *error) {
    NSLog(@"注册成功");
    }];
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

