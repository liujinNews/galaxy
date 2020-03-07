//
//  GPAlertView.m
//  galaxy
//
//  Created by 赵碚 on 15/7/23.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//
#define GPWIDTH 150
#define GPHEIGHT 100
#import "GPAlertView.h"

@implementation GPAlertView{
    UIActivityIndicatorView * loadingView;
    UILabel * label;
    UILabel * alertLabel;
    BOOL isLoading;
}

static GPAlertView * alertView = nil;
//单例对象
+ (GPAlertView *)sharedAlertView {
    if(alertView == nil) {
        int naviHeight = NavigationbarHeight - StatusBarHeight;
        alertView = [[GPAlertView alloc]initWithFrame:CGRectMake(ScreenRect.size.width / 2 - 75, ScreenRect.size.height / 2-GPHEIGHT/2-naviHeight , GPWIDTH, GPHEIGHT)];
        alertView.center = CGPointMake(ScreenRect.size.width / 2, ScreenRect.size.height / 2 - naviHeight);
        alertView.alpha = 0.8;
        alertView.layer.cornerRadius = 10;
        alertView.layer.masksToBounds = YES;
        alertView.opaque = NO;
    }
    return alertView;
}

//启动加载动画
- (void)startAnimating :(UIViewController *)viewController WithText:(NSString *)loadingText{
    isLoading = YES;
    int naviHeight = NavigationbarHeight - StatusBarHeight;
    alertView.center = CGPointMake(ScreenRect.size.width / 2, ScreenRect.size.height / 2 - naviHeight);
    [viewController.view addSubview:self];
    [viewController.view bringSubviewToFront:self];
    [self addSubview:loadingView];
    [self addSubview:label];
    label.text = loadingText;
    label.backgroundColor = [UIColor clearColor];
    
    [loadingView startAnimating];
}
//停止加载动画
- (void)stopAnimating {
    isLoading = NO;
    [loadingView stopAnimating];
    [loadingView removeFromSuperview];
    [label removeFromSuperview];
    [self removeFromSuperview];
}

- (BOOL)isLoading {
    return isLoading;
}

//简单弹出框
+(void)showAlertViewWithError:(NSString*)errorStr{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:errorStr delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alertView show];
}
//显示单独文本信息
- (void)showAlertText :(UIViewController *)viewController WithText:(NSString *)alertText {
    int naviHeight = NavigationbarHeight - StatusBarHeight;
    alertView.center = CGPointMake(ScreenRect.size.width / 2, ScreenRect.size.height / 3 - naviHeight);
    [viewController.view addSubview:self];
    [viewController.view bringSubviewToFront:self];
    [self addSubview:alertLabel];
    alertLabel.text = alertText;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeAlertText) userInfo:nil repeats:NO];
}

- (void)showAlertText :(UIViewController *)viewController WithText:(NSString *)alertText duration:(float)duration{
    int naviHeight = NavigationbarHeight - StatusBarHeight;
    alertView.center = CGPointMake(ScreenRect.size.width / 2, ScreenRect.size.height / 2 - naviHeight);
    [viewController.view addSubview:self];
    [viewController.view bringSubviewToFront:self];
    [self addSubview:alertLabel];
    alertLabel.text = alertText;
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(closeAlertText) userInfo:nil repeats:NO];
}

//关闭文本信息
- (void)closeAlertText {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformScale(self.transform, 1, 0.1);
    } completion:^(BOOL finished) {
        [self->alertLabel removeFromSuperview];
        [self removeFromSuperview];
        self.alpha = 0.8;
        self.transform = CGAffineTransformIdentity;
    }];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.center = CGPointMake(GPWIDTH/2, GPHEIGHT/2-20);
        CGFloat y = loadingView.center.y + loadingView.bounds.size.height / 2 + 10;
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, y, GPWIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color_form_TextFieldBackgroundColor;
        label.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = Color_Unsel_TitleColor;
        
        alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, GPWIDTH, GPHEIGHT-30)];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.textColor = Color_form_TextFieldBackgroundColor;
        alertLabel.numberOfLines = 4;
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}

- (void)showAlertBankText :(UIViewController *)viewController WithText:(NSString *)alertText duration:(float)duration{
    int naviHeight = NavigationbarHeight - StatusBarHeight-20;
    alertView.center = CGPointMake(ScreenRect.size.width / 2, ScreenRect.size.height / 5 - naviHeight);
    [viewController.view addSubview:self];
    [viewController.view bringSubviewToFront:self];
    [self addSubview:alertLabel];
    alertLabel.text = alertText;
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(closeAlertText) userInfo:nil repeats:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
