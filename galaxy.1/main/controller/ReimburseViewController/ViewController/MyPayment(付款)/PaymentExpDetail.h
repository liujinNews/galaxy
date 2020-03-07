//
//  PaymentExpDetail.h
//  galaxy
//
//  Created by hfk on 2018/11/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentExpDetail : NSObject

@property (nonatomic, copy) NSString *ExpId;
@property (nonatomic, copy) NSString *ExpenseDate;
@property (nonatomic, copy) NSString *InvoiceNo;
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;
@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;
@property (nonatomic, copy) NSString *LocalCyAmount;
@property (nonatomic, copy) NSString *InvoiceType;
@property (nonatomic, copy) NSString *InvoiceTypeName;
@property (nonatomic, copy) NSString *InvoiceTypeCode;
@property (nonatomic, copy) NSString *AirTicketPrice;
@property (nonatomic, copy) NSString *DevelopmentFund;
@property (nonatomic, copy) NSString *FuelSurcharge;
@property (nonatomic, copy) NSString *OtherTaxes;
@property (nonatomic, copy) NSString *AirlineFuelFee;
@property (nonatomic, copy) NSString *TaxRate;
@property (nonatomic, copy) NSString *Tax;
@property (nonatomic, copy) NSString *ExclTax;
@property (nonatomic, copy) NSString *ContractAppNumber;
@property (nonatomic, copy) NSString *ContractNo;
@property (nonatomic, copy) NSString *ContractName;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *ExpenseDesc;
@property (nonatomic, copy) NSString *Attachments;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *InvCyPmtExchangeRate;
@property (nonatomic, copy) NSString *InvPmtAmount;
@property (nonatomic, copy) NSString *InvPmtTax;
@property (nonatomic, copy) NSString *InvPmtAmountExclTax;
@property (nonatomic, copy) NSString *isIntegrity;//消费记录信息是否完整(1不完整 0完整)
@property (nonatomic, copy) NSString *GridOrder;
@property (nonatomic, copy) NSString *Overseas;
@property (nonatomic, copy) NSString *Nationality;
@property (nonatomic, copy) NSString *NationalityId;
@property (nonatomic, copy) NSString *TransactionCode;
@property (nonatomic, copy) NSString *TransactionCodeId;
@property (nonatomic, copy) NSString *HandmadePaper;
@property (nonatomic, copy) NSString *IsExpExpired;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(PaymentExpDetail *)model;


@end

NS_ASSUME_NONNULL_END
