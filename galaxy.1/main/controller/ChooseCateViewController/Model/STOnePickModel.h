//
//  STOnePickModel.h
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STOnePickModel : NSObject
/**
 *  共用id
 */
@property (nonatomic,copy) NSString *Id;
/**
 *  共用id
 */
@property (nonatomic,copy) NSString *Type;

@property (nonatomic,copy) NSString *isDefault;


@property (nonatomic,copy) NSString *taxRate;
@property (nonatomic,copy) NSString *invoiceType;





@property (nonatomic,strong)NSString *currencyShort;
@property (nonatomic,strong)NSString *exchangeRate;
@property (nonatomic,strong)NSString *stdMoney;

@property (nonatomic,assign)NSInteger requiredReason;
@property (nonatomic,assign)NSInteger requiredAtt;


+(void)getCertificateType:(NSMutableArray *)array;
+(void)getPayWay:(NSMutableArray *)array;
+(void)getCurrcyWithDate:(NSMutableArray *)resultArr WithResult:(NSMutableArray *)array WithCurrencyDict:(NSMutableDictionary *)Currencydict;
/**
 获取无发票有发票替票
 */
+(void)getInvoiceTypeWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array;
/**
 类型类型
 */
+(void)getVehicleType:(NSMutableArray *)array;

/**
 报销类型
 */
+(void)getClaimTypeWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array;

/**
 发票类型
 */
+(void)getInvoiceTypesWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array;

/**
 税率
 */
+(void)getTaxRatesWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array;

/**
 座位列表
 */
+(void)getTrainSeatsWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array;

@end
