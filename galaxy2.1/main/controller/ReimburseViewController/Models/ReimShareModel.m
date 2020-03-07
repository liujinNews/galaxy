//
//  ReimShareModel.m
//  galaxy
//
//  Created by hfk on 2017/9/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ReimShareModel.h"

@implementation ReimShareModel
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

+ (NSMutableDictionary *)initDicByModel:(ReimShareModel*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
