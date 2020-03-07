//
//  EntertainmentData.m
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "EntertainmentData.h"

@implementation EntertainmentData

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

+ (NSMutableDictionary *)initDicByModel:(EntertainmentData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}


@end
