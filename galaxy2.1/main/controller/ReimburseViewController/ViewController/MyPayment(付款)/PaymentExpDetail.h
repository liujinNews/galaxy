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
@property (nonatomic, copy) NSString *CostType;
@property (nonatomic, copy) NSString *IsPrepay;
@property (nonatomic, copy) NSString *IsAccruedaccount;
@property (nonatomic, copy) NSString *Government;
@property (nonatomic, copy) NSString *CostCenterId;//成本中心ID
@property (nonatomic, copy) NSString *CostCenter;//成本中心
@property (nonatomic, copy) NSString *FeeAppInfo;//费用申请单
@property (nonatomic, copy) NSString *FeeAppNumber;//费用申请单
@property (nonatomic, copy) NSString *IsSettlement;//是否已结项
@property (nonatomic, copy) NSString *IsStorage;//是否已入库
@property (nonatomic, copy) NSString *PrepayStartDate;//预付开始时间
@property (nonatomic, copy) NSString *PrepayEndDate;//预付结束时间
@property (nonatomic, copy) NSString *AccountItem;//辅助核算项
@property (nonatomic, copy) NSString *AccountItemCode;//辅助核算项Code
@property (nonatomic, copy) NSString *AccountItemAmount;//辅助核算金额
@property (nonatomic, copy) NSString *AccountItem2;//辅助核算项2
@property (nonatomic, copy) NSString *AccountItemCode2;//辅助核算项Code2
@property (nonatomic, copy) NSString *AccountItemAmount2;//辅助核算金额2
@property (nonatomic, copy) NSString *AccountItem3;//辅助核算项3
@property (nonatomic, copy) NSString *AccountItemCode3;//辅助核算项Code3
@property (nonatomic, copy) NSString *AccountItemAmount3;//辅助核算金额3
@property (nonatomic, copy) NSString *ContractGridOrder;//合同明细
@property (nonatomic, copy) NSString *PaymentOrderNo;



+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(PaymentExpDetail *)model;


@end

NS_ASSUME_NONNULL_END
