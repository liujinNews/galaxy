//
//  AccruedReqDetail.h
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccruedReqDetail : NSObject

@property (nonatomic, copy) NSString *AccruedTypeId;
@property (nonatomic, copy) NSString *AccruedGridOrder;
@property (nonatomic, copy) NSString *AccruedType;
@property (nonatomic, copy) NSString *AccruedMonth;
@property (nonatomic, copy) NSString *ProjId;
@property (nonatomic, copy) NSString *ProjName;
@property (nonatomic, copy) NSString *ProjMgrUserId;
@property (nonatomic, copy) NSString *ProjMgr;
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;
@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *ExpenseDesc;
@property (nonatomic, copy) NSString *SupplierId;
@property (nonatomic, copy) NSString *SupplierName;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;
@property (nonatomic, copy) NSString *LocalCyAmount;
@property (nonatomic, copy) NSString *IsVAT;
@property (nonatomic, copy) NSString *TaxRate;
@property (nonatomic, copy) NSString *Tax;
@property (nonatomic, copy) NSString *ExclTax;
@property (nonatomic, copy) NSString *IsSupportMaterials;
@property (nonatomic, copy) NSString *EstimateContractSignTime;
@property (nonatomic, copy) NSString *ContractAppInfo;
@property (nonatomic, copy) NSString *ContractAppNumber;
@property (nonatomic, copy) NSString *ContractGridOrderId;
@property (nonatomic, copy) NSString *FeeAppInfo;
@property (nonatomic, copy) NSString *FeeAppNumber;
@property (nonatomic, copy) NSString *ActualAmount;
@property (nonatomic, copy) NSString *ActualLocalAmount;
@property (nonatomic, copy) NSString *AccruedName;
@property (nonatomic, copy) NSString *AccountItem;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(AccruedReqDetail *)model;


@end

NS_ASSUME_NONNULL_END
