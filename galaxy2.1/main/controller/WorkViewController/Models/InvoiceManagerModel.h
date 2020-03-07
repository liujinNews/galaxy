//
//  InvoiceManagerModel.h
//  galaxy
//
//  Created by hfk on 2017/11/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceManagerModel : NSObject
@property (nonatomic,strong)NSString *Id;
@property (nonatomic,strong)NSString *billingDate;//开票日期
@property (nonatomic,strong)NSString *invoiceCode;
@property (nonatomic,strong)NSString *invoiceNumber;
@property (nonatomic,strong)NSString *purchaserName;
@property (nonatomic,strong)NSString *purchaserTaxNo;
@property (nonatomic,strong)NSString *salesName;//开票方
@property (nonatomic,strong)NSString *totalAmount;//金额
@property (nonatomic,strong)NSString *totalTax;
@property (nonatomic,strong)NSString *amountTax;
@property (nonatomic,strong)NSString *amountTaxCN;
@property (nonatomic,strong)NSString *invoiceType;//发票类型(1增值税普通发票/2增值税专用发票/3增值税电子普通发票/4其他)
@property (nonatomic,strong)NSString *status;//状态(1未报销/2审批中/3审批完成/4已支付/5已入账)
@property (nonatomic,strong)NSString *flowCode;//差旅
@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *expenseCatCode;
@property (nonatomic,strong)NSString *expenseCat;
@property (nonatomic,strong)NSString *expenseCode;
@property (nonatomic,strong)NSString *expenseType;
@property (nonatomic,strong)NSString *expenseIcon;
@property (nonatomic,strong)NSString *pdF_URL;
@property (nonatomic,strong)NSString *source;//(百望电子 12、微信卡包 16、发票扫描 15、发票拍照 18)



@end
