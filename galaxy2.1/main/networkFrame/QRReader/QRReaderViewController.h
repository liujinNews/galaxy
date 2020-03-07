//
//  QRReaderViewController.h
//  YunWan
//
//  Created by 张威 on 15/1/26.
//  Copyright (c) 2015年 ZhangWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManInputElecController.h"
@protocol QRReaderViewControllerDelegate;

@interface QRReaderViewController : RootViewController

@property (nonatomic, weak) id<QRReaderViewControllerDelegate> delegate;

//1发票查验  2发票验证  0//默认
@property (nonatomic,assign)NSInteger judgeStr;
@end

@protocol QRReaderViewControllerDelegate <NSObject>

- (void)didFinishedReadingQR:(NSString *)string withType:(NSInteger)type;
//-(void)didOperation;
@end
