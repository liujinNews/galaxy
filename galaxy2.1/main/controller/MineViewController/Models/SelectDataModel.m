//
//  SelectDataModel.m
//  galaxy
//
//  Created by 贺一鸣 on 16/1/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "SelectDataModel.h"

@implementation SelectDataModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ids = value;
    }
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
