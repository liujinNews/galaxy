//
//  SpecialReqestDetail.m
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SpecialReqestDetail.h"

@implementation SpecialReqestDetail

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableDictionary *)initDicByModel:(SpecialReqestDetail *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
