//
//  FeeAppDeatil.h
//  galaxy
//
//  Created by hfk on 2017/6/23.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeeAppDeatil : NSObject

@property (nonatomic,copy)NSString * ExpenseCode;
@property (nonatomic,copy)NSString * ExpenseType;
@property (nonatomic,copy)NSString * ExpenseIcon;
@property (nonatomic,copy)NSString * ExpenseCatCode;
@property (nonatomic,copy)NSString * ExpenseCat;
@property (nonatomic,copy)NSString * ExpenseDesc;
@property (nonatomic,copy)NSString * Amount;
//@property (nonatomic,copy)NSString * LocalCyAmount;
//@property (nonatomic,copy)NSString * CostType;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;
 
+ (NSMutableDictionary *) initDicByModel:(FeeAppDeatil *)model;

@end
