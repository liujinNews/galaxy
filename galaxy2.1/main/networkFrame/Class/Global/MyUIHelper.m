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

#import "MyUIHelper.h"
#import "MyUIDefine.h"

static MyUIHelper* instance;

@implementation MyUIHelper

+ (MyUIHelper*)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        if (instance == nil) {
            instance = [[MyUIHelper alloc] init];
        }
    });
    return instance;
}

+ (void)configAppearenceForNavigationBar:(UINavigationBar *)navigationBar{
    navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:22.f],
                                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    navigationBar.translucent = NO;
}

+ (void)configAppAppearance{
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:APP_MAIN_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
    UIColor *highlightColor = RGBACOLOR(0x12, 0xa8, 0x6b, 1.0f);
    UIColor *normalColor = [UIColor colorWithWhite:0.3f alpha:1.f];
    
    NSDictionary *selectedTextAttr = nil;
    NSDictionary *normalTextAttr = nil;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        selectedTextAttr = @{NSForegroundColorAttributeName: highlightColor,
                             NSFontAttributeName: [UIFont systemFontOfSize:10.f]};
        normalTextAttr = @{NSForegroundColorAttributeName: normalColor,
                           NSFontAttributeName: [UIFont systemFontOfSize:10.f]};
    }
    else
    {
        selectedTextAttr = @{UITextAttributeTextColor: highlightColor,};
        normalTextAttr = @{UITextAttributeTextColor: normalColor};
    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:normalTextAttr forState:UIControlStateNormal];
}

@end
