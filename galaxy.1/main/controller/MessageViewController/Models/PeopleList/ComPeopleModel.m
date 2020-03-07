//
//  ComPeopleModel.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ComPeopleModel.h"

@implementation ComPeopleModel

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
