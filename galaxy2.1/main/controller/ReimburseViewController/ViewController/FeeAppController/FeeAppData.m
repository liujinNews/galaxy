//
//  FeeAppData.m
//  galaxy
//
//  Created by hfk on 2017/6/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FeeAppData.h"
#import "NSObject+ModelToDic.h"

@implementation FeeAppData
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

+ (NSMutableDictionary *)initDicByModel:(FeeAppData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
