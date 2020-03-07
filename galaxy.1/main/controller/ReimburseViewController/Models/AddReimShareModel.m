//
//  AddReimShareModel.m
//  galaxy
//
//  Created by hfk on 2018/10/11.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AddReimShareModel.h"

@implementation AddReimShareModel
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

+ (NSMutableDictionary *)initDicByModel:(AddReimShareModel*)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end