//
//  OverTimeDeatil.h
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverTimeDeatil : NSObject

@property (nonatomic,copy)NSString *FromDate;
@property (nonatomic,copy)NSString *ToDate;
@property (nonatomic,copy)NSString *OverTime;
@property (nonatomic,copy)NSString *Type;
@property (nonatomic,copy)NSString *AccountingModeId;
@property (nonatomic,copy)NSString *AccountingMode;
@property (nonatomic,copy)NSString *ExchangeHoliday;
@property (nonatomic,copy)NSString *Reason;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(OverTimeDeatil *)model;

@end

NS_ASSUME_NONNULL_END
