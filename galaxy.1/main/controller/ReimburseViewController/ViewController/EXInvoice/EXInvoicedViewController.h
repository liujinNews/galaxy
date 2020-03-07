//
//  EXInvoiceViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/9/19.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "InvoiceManagerModel.h"

@interface EXInvoicedViewController : VoiceBaseController
//扫描参数
@property (nonatomic, strong) NSString *str_result;
//1、扫描 2、电子发票 
@property (nonatomic, assign) NSInteger int_Type;
//电子发票传输数据
@property (nonatomic, strong) NSDictionary *dic_bwInvoice;
@property (nonatomic, strong) NSString *str_AccountNo;
@property (nonatomic, strong) NSString *str_AccountType;
@property (nonatomic, strong) NSString *str_fplx;
@end
