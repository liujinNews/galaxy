//
//  NJKWebView.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/1/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NJKWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface NJKWebView ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@end

@implementation NJKWebView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configWebViews];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:_progressView];
}
-(void)configWebViews{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.delegate = _progressProxy;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0, Main_Screen_Width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


@end
