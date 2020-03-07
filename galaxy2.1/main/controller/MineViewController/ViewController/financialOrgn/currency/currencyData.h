//
//  currencyData.h
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface currencyData : NSObject
@property(nonatomic,copy)NSString * currency;
@property(nonatomic,copy)NSString * currencyCode;
@property(nonatomic,copy)NSString * idd;
@property(nonatomic,copy)NSString * ExchangeRate;
@property(nonatomic,copy)NSString * no;
@property(nonatomic,copy)NSString * currencyShort;
@property(nonatomic,copy)NSString * stdMoney;
+ (void)GetCurrencyListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array;

@end
