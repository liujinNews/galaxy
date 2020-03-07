//
//  ContractYearExpDetail.h
//  galaxy
//
//  Created by hfk on 2019/4/2.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractYearExpDetail : NSObject

@property (nonatomic, copy) NSString *Year;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *Tax;
@property (nonatomic, copy) NSString *ExclTax;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(ContractYearExpDetail *)model;

@end

NS_ASSUME_NONNULL_END
