//
//  GiftFeeDetail.h
//  galaxy
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftFeeDetail : NSObject

@property (nonatomic,copy)NSString * ExpenseCode;
@property (nonatomic,copy)NSString * ExpenseType;
@property (nonatomic,copy)NSString * ExpenseIcon;
@property (nonatomic,copy)NSString * ExpenseCatCode;
@property (nonatomic,copy)NSString * ExpenseCat;
@property (nonatomic,copy)NSString * ExpenseDesc;
//礼品费数据
@property (nonatomic,copy)NSString * TCompanyName;
@property (nonatomic,copy)NSString * TRecipient;
@property (nonatomic,copy)NSString * GiftName;
@property (nonatomic,copy)NSString * Remark;
@property (nonatomic,copy)NSString * Amount;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(GiftFeeDetail *)model;
@end

NS_ASSUME_NONNULL_END
