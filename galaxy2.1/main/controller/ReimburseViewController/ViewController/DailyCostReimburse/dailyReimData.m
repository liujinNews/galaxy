//
//  dailyReimData.m
//  galaxy
//
//  Created by hfk on 15/11/16.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "dailyReimData.h"
#import "NSObject+ModelToDic.h"
@implementation dailyReimData
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

+ (NSMutableDictionary *)initDicByModel:(dailyReimData*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
