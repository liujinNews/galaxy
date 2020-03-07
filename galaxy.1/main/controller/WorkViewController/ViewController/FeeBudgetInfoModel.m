//
//  FeeBudgetInfoModel.m
//  galaxy
//
//  Created by hfk on 2018/7/1.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FeeBudgetInfoModel.h"

@implementation FeeBudgetInfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(id)copyWithZone:(NSZone *)zone{
    FeeBudgetInfoModel *model = [[FeeBudgetInfoModel allocWithZone:zone] init];
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

+ (NSMutableDictionary *)initDicByModel:(FeeBudgetInfoModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}
@end
