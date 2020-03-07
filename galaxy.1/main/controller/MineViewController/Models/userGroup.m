//
//  userGroup.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/22.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "userGroup.h"

@implementation userGroup

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithBydic:dict];
}

- (instancetype)initWithBydic:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
