//
//  MessageIndexCellModel.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/7.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MessageIndexCellModel.h"

@implementation MessageIndexCellModel

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

@end
