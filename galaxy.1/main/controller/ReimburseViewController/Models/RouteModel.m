//
//  RouteModel.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/8/15.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RouteModel.h"

@implementation RouteModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _Id = value;
    }
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

@end
