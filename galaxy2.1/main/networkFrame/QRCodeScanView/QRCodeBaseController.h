//
//  QRCodeBaseController.h
//  galaxy
//
//  Created by hfk on 2017/9/29.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "JQZXScanViewController.h"

@interface QRCodeBaseController : JQZXScanViewController
/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;
//区分进入来源1:申请单扫描 2:发票验证二维码
@property (nonatomic, assign) NSInteger type;

//codestring:二维码信息 type:来源信息 1:扫描报销单  2:扫描发票
@property (copy, nonatomic) void(^QRCodeScanBackBlock)(NSString *codeString, NSInteger type);

@end
