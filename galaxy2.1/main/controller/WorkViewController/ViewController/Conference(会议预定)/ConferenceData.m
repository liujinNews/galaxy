//
//  ConferenceData.m
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ConferenceData.h"
#import "NSObject+ModelToDic.h"

@implementation ConferenceData
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

+ (NSMutableDictionary *)initDicByModel:(ConferenceData *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
