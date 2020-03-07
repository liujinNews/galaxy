//
//  GiftFeeDetail.m
//  galaxy
//
//  Created by APPLE on 2019/11/18.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "GiftFeeDetail.h"

@implementation GiftFeeDetail
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
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

+ (NSMutableDictionary *)initDicByModel:(GiftFeeDetail *)model{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
