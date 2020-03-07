//
//  pmtMethodDetail.h
//  galaxy
//
//  Created by hfk on 2018/7/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pmtMethodDetail : NSObject

@property (nonatomic,copy)NSString * PmtMethod;
@property (nonatomic,copy)NSString * Currency;
@property (nonatomic,copy)NSString * ExchangeRate;
@property (nonatomic,copy)NSString * Amount;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(pmtMethodDetail *)model;


@end
