//
//  NewAddCostModel.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/28.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NewAddCostModel.h"

@implementation NewAddCostModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableDictionary *)initDicByModel:(NewAddCostModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
