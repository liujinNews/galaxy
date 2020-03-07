//
//  ContractPayMethodDetail.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractPayMethodDetail : NSObject

@property (nonatomic, copy) NSString *No;
@property (nonatomic, copy) NSString *PayRatio;
@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *PayDate;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *PaymentClause;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(ContractPayMethodDetail *)model;

@end

NS_ASSUME_NONNULL_END
