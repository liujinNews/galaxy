//
//  FieldNamesModel.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/12.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "FieldNamesModel.h"
#import "NSObject+ModelToDic.h"

@implementation FieldNamesModel
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

+ (NSMutableDictionary *)initDicByModel:(FieldNamesModel*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
