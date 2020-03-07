//
//  CurrencySumModel.h
//  galaxy
//
//  Created by hfk on 2018/11/29.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencySumModel : NSObject

@property (nonatomic, copy) NSString *CurrencyCode;
@property (nonatomic, copy) NSString *Currency;
@property (nonatomic, copy) NSString *ExchangeRate;
@property (nonatomic, copy) NSNumber *SumAmount;

@end

NS_ASSUME_NONNULL_END
