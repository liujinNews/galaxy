//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyTabBarViewController.h"
#import "MyRecentViewController.h"
#import "MyContactsViewController.h"
#import "MyMeViewController.h"
#import "MyUIDefine.h"
#import "AppDelegate.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建三个tab的视图
    self.recentViewCntlr = [[MyRecentViewController alloc] init];
    self.contactsViewCntlr = [[MyContactsViewController alloc] init];
    self.meViewCntlr = [[MyMeViewController alloc] init];
    
    //设置navi作为根视图
    UINavigationController* recentNaviCntlr = [[UINavigationController alloc]initWithRootViewController:self.recentViewCntlr];
    UINavigationController* contactsNaviCntlr = [[UINavigationController alloc]initWithRootViewController:self.contactsViewCntlr];
    UINavigationController* meNaviCntlr = [[UINavigationController alloc]initWithRootViewController:self.meViewCntlr];
    
    [self addChildViewController:recentNaviCntlr];
    [self addChildViewController:contactsNaviCntlr];
    [self addChildViewController:meNaviCntlr];

    recentNaviCntlr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                               image:[[UIImage imageNamed:@"tab_recents_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"tab_recents_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    contactsNaviCntlr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录"
                                                            image:[[UIImage imageNamed:@"tab_contact_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                    selectedImage:[[UIImage imageNamed:@"tab_contact_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    meNaviCntlr.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"配置"
                                                                 image:[[UIImage imageNamed:@"tab_me_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                         selectedImage:[[UIImage imageNamed:@"tab_me_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f)];
    
    //[[AppDelegate sharedAppDelegate] testLogout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.recentViewCntlr = nil;
    self.contactsViewCntlr = nil;
    self.meViewCntlr = nil;
}

@end
