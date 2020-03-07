//
//  ItemRequestData.m
//  galaxy
//
//  Created by hfk on 2018/3/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ItemRequestData.h"
#import "NSObject+ModelToDic.h"

@implementation ItemRequestData

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
+ (NSMutableDictionary *)initDicByModel:(ItemRequestData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
