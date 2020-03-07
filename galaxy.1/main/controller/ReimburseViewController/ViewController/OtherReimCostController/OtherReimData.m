//
//  OtherReimData.m
//  galaxy
//
//  Created by hfk on 2016/12/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "OtherReimData.h"
#import "NSObject+ModelToDic.h"
@implementation OtherReimData
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

+ (NSMutableDictionary *)initDicByModel:(OtherReimData*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
