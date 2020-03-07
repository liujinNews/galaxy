//
//  ContractYearExpDetail.m
//  galaxy
//
//  Created by hfk on 2019/4/2.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ContractYearExpDetail.h"

@implementation ContractYearExpDetail

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

+ (NSMutableDictionary *)initDicByModel:(ContractYearExpDetail *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
