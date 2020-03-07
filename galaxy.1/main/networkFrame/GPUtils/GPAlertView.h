//
//  GPAlertView.h
//  galaxy
//
//  Created by 赵碚 on 15/7/23.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPAlertView : UIView
//单例对象
+ (GPAlertView *)sharedAlertView;

//启动加载动画
- (void)startAnimating :(UIViewController *)viewController WithText:(NSString *)loadingText;
//停止加载动画
- (void)stopAnimating;

+(void)showAlertViewWithError:(NSString*)errorStr;
//显示单独文本信息
- (void)showAlertText :(UIViewController *)viewController WithText:(NSString *)alertText;

- (void)showAlertText :(UIViewController *)viewController WithText:(NSString *)alertText duration:(float)duration;
- (void)closeAlertText;
//判断当前是否loading状态
- (BOOL)isLoading;
- (void)showAlertBankText :(UIViewController *)viewController WithText:(NSString *)alertText duration:(float)duration;
@end
