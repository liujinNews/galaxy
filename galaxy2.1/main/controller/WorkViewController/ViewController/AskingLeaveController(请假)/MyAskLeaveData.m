//
//  MyAskLeaveData.m
//  galaxy
//
//  Created by hfk on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyAskLeaveData.h"
#import "NSObject+ModelToDic.h"
@implementation MyAskLeaveData
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

+ (NSMutableDictionary *)initDicByModel:(MyAskLeaveData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
