//
//  approvalDockView.h
//  galaxy
//
//  Created by 赵碚 on 15/8/7.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface approvalDockView : UIView<UIAlertViewDelegate>
@property (weak, nonatomic) UIViewController * vc;
@property (strong,nonatomic)UIAlertView * alert;

+ (approvalDockView *)shareInstance;

- (void)setCurrentViewController:(UIViewController *)curVC;
- (void)setDockViewContent:(int)index;
- (void)clear;
@end
