//
//  ExpTypeDetail.h
//  galaxy
//
//  Created by APPLE on 2019/12/23.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//费用类别明细
@interface ExpTypeDetail : NSObject

//No        int
//ExpenseCode    string
//ExpenseType    string
//ExpenseIcon    string
//ExpenseCatCode    string
//ExpenseCat    string
//LocalCyAmount    string
//PurchaseNumber    string
//PurchaseInfo    string
@property (nonatomic, copy) NSString *No;
@property (nonatomic, copy) NSString *ExpenseCode;
@property (nonatomic, copy) NSString *ExpenseType;
@property (nonatomic, copy) NSString *ExpenseIcon;
@property (nonatomic, copy) NSString *ExpenseCatCode;
@property (nonatomic, copy) NSString *ExpenseCat;
@property (nonatomic, copy) NSString *LocalCyAmount;
@property (nonatomic, copy) NSString *PurchaseNumber;
@property (nonatomic, copy) NSString *PurchaseInfo;
@property (nonatomic, copy) NSString *PayMethodNo;
@property (nonatomic, copy) NSString *Amount;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(ExpTypeDetail *)model;

@end

NS_ASSUME_NONNULL_END
