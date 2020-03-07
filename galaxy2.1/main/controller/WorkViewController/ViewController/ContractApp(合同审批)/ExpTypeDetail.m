//
//  ExpTypeDetail.m
//  galaxy
//
//  Created by APPLE on 2019/12/23.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "ExpTypeDetail.h"

@implementation ExpTypeDetail

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

+ (NSMutableDictionary *)initDicByModel:(ExpTypeDetail *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
