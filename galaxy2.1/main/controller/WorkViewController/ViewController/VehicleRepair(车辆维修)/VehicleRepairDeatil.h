//
//  VehicleRepairDeatil.h
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleRepairDeatil : NSObject

@property (nonatomic,copy)NSString * ExpenseCode;
@property (nonatomic,copy)NSString * ExpenseType;
@property (nonatomic,copy)NSString * ExpenseIcon;
@property (nonatomic,copy)NSString * ExpenseCatCode;
@property (nonatomic,copy)NSString * ExpenseCat;
@property (nonatomic,copy)NSString * ExpenseDesc;
@property (nonatomic,copy)NSString * Amount;
@property (nonatomic,copy)NSString * Remark;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableDictionary *) initDicByModel:(VehicleRepairDeatil *)model;

@end
