//
//  StepWarningView.h
//  galaxy
//
//  Created by 贺一鸣 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepWarningView : UIView

typedef void (^StepWarningView_Click)(NSInteger buttonIndex);

+(void)initWithViews:(NSInteger)Type view:(StepWarningView *)view controller:(UIViewController *)controller Click:(StepWarningView_Click) Index;

//@property (nonatomic, strong) UIViewController *controller;

@end
