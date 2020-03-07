//
//  NJKWebView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/1/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface NJKWebView : UIWebView

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;


@end
