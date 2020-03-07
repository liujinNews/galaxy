//
//  AccruedReqDetail.m
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedReqDetail.h"

@implementation AccruedReqDetail
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNumber class]]) {
        //直接传入精度丢失有问题的Double类型
        double conversionValue = [value doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        value = [decNumber stringValue];
    }
    [super setValue:value forKey:key];
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
-(id)copyWithZone:(NSZone *)zone{
    AccruedReqDetail *model = [[AccruedReqDetail allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}
+ (NSMutableDictionary *)initDicByModel:(AccruedReqDetail *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
