//
//  MyChopData.m
//  galaxy
//
//  Created by hfk on 2017/12/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "MyChopData.h"
#import "NSObject+ModelToDic.h"

@implementation MyChopData
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

+ (NSMutableDictionary *)initDicByModel:(MyChopData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
