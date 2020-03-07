//
//  AppoverEditModel.m
//  galaxy
//
//  Created by hfk on 2017/9/5.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "AppoverEditModel.h"

@implementation AppoverEditModel
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

+ (NSMutableDictionary *)initDicByModel:(AppoverEditModel*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
