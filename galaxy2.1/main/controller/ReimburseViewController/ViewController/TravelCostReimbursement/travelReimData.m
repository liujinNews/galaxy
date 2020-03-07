
//
//  travelReimData.m
//  galaxy
//
//  Created by hfk on 15/10/13.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "travelReimData.h"
#import "NSObject+ModelToDic.h"
@implementation travelReimData
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

+ (NSMutableDictionary *)initDicByModel:(travelReimData*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
