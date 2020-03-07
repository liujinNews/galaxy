//
//  AppoverEditModel.h
//  galaxy
//
//  Created by hfk on 2017/9/5.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppoverEditModel : NSObject

@property (nonatomic, copy) NSString *gridOrder;
@property (nonatomic, copy) NSString *exchangeRate;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *hotelPrice;
@property (nonatomic, copy) NSString *localCyAmount;
@property (nonatomic, copy) NSString *tax;
@property (nonatomic, copy) NSString *exclTax;
@property (nonatomic, copy) NSString *taxRate;
@property (nonatomic, copy) NSString *invCyPmtExchangeRate;
@property (nonatomic, copy) NSString *invPmtAmount;
@property (nonatomic, copy) NSString *invPmtTax;
@property (nonatomic, copy) NSString *invPmtAmountExclTax;
@property (nonatomic, copy) NSString *isEdit;
@property (nonatomic, copy) NSString *overStd;
@property (nonatomic, copy) NSString *overStd2;
@property (nonatomic, copy) NSString *overStdAmt;
@property (nonatomic, copy) NSString *accountItemCode;
@property (nonatomic, copy) NSString *accountItem;

@property (nonatomic, copy) NSString *invoiceType;
@property (nonatomic, copy) NSString *invoiceTypeName;
@property (nonatomic, copy) NSString *invoiceTypeCode;
@property (nonatomic, copy) NSString *expenseCode;
@property (nonatomic, copy) NSString *expenseIcon;
@property (nonatomic, copy) NSString *expenseType;
@property (nonatomic, copy) NSString *expenseCat;
@property (nonatomic, copy) NSString *expenseCatCode;
@property (nonatomic, copy) NSString *airlineFuelFee;//总金额
@property (nonatomic, copy) NSString *airTicketPrice;//民航发展基金
@property (nonatomic, copy) NSString *developmentFund;//发展基金
@property (nonatomic, copy) NSString *fuelSurcharge;//燃油附加费
@property (nonatomic, copy) NSString *otherTaxes;//其他费用
@property (nonatomic, copy) NSString *costCenter;
@property (nonatomic, copy) NSString *costCenterId;



+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AppoverEditModel*)model;

@end
