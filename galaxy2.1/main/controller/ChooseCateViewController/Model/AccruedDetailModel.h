//
//  AccruedDetailModel.h
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccruedDetailModel : NSObject

@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *paymentOrderNo;
@property (nonatomic,strong)NSString *accruedTaskId;
@property (nonatomic,strong)NSString *accruedDetailInfo;
@property (nonatomic,strong)NSString *companyId;
@property (nonatomic,strong)NSString *active;
@property (nonatomic, copy) NSString *expenseCode;
@property (nonatomic, copy) NSString *expenseType;
@property (nonatomic, copy) NSString *expenseIcon;
@property (nonatomic, copy) NSString *expenseCatCode;
@property (nonatomic, copy) NSString *expenseCat;
@property (nonatomic, copy) NSString *expense;

@property (nonatomic,strong)NSString *creater;
@property (nonatomic,strong)NSString *upadteTime;
@property (nonatomic,strong)NSString *updater;

@property (copy, nonatomic) NSString *reason;
@property (nonatomic,strong)NSString *serialNo;
@property (nonatomic,strong)NSString *supplierName;
@property (nonatomic,strong)NSString *supplierId;
@property (nonatomic,strong)NSString *contractAppInfo;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *accruedName;
@property (nonatomic,strong)NSString *accruedTypeId;
@property (nonatomic,strong)NSString *accruedType;
@property (nonatomic,strong)NSString *accruedGridOrder;
@property (nonatomic,strong)NSString *gridOrder;

@property (nonatomic,strong)NSString *writeOffAmount;
@property (nonatomic,strong)NSString *surplusAmount;
@property (nonatomic,strong)NSString *accruedAmount;
@property (nonatomic,strong)NSString *localCyAmount;
@property (nonatomic,strong)NSString *exclTax;
@property (nonatomic,strong)NSString *tax;
@property (nonatomic,strong)NSString *exchangeRate;


+(void)getAccruedDetailType:(NSDictionary *)dic Array:(NSMutableArray *)array;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(PaymentExpDetail *)model;
@end

NS_ASSUME_NONNULL_END
