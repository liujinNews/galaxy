//
//  WeChatInvoiceModel.h
//  galaxy
//
//  Created by hfk on 2017/10/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatInvoiceModel : NSObject
/**
 发票号码
 */
@property (nonatomic, strong) NSString *billing_no;
/**
 发票对应的PDF_URL
 */
@property (nonatomic, strong) NSString *pdf_url;
/**
 税额
 */
@property (nonatomic, strong) NSString *tax;
/**
 收票方
 */
@property (nonatomic, strong) NSString *title;
/**
 发票加税合计金额
 */
@property (nonatomic, strong) NSString *fee;
/**
 收票方纳税人识别号
 */
@property (nonatomic, strong) NSString *buyer_number;
/**
 开票方
 */
@property (nonatomic, strong) NSString *payee;
/**
 开票时间
 */
@property (nonatomic, strong) NSString *billing_time;
/**
 发票代码
 */
@property (nonatomic, strong) NSString *billing_code;
/**
 code 单个发票导入结果(0:成功，1000:收票方信息不一致)
 */
@property (nonatomic, strong) NSString *code;

@end
