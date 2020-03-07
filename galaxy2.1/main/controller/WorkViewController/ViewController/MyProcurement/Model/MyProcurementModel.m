//
//  MyProcurementModel.m
//  galaxy
//
//  Created by hfk on 16/4/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MyProcurementModel.h"

@implementation MyProcurementModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)copyWithZone:(NSZone *)zone{
    MyProcurementModel *my=[[self class] allocWithZone:zone];
    my.Description = _Description;
    my.fieldName = _fieldName;
    my.fieldValue = _fieldValue;
    my.isRequired = _isRequired;
    my.isShow = _isShow;
    my.tips = _tips;
    my.ctrlTyp = _ctrlTyp;
    my.masterId = _masterId;
    my.isOnlyRead = _isOnlyRead;
    my.enterLimit = _enterLimit;
    my.isEdit = _isEdit;
    my.isNotSelect = _isNotSelect;

    return my;
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

+ (NSMutableDictionary *)initDicByModel:(MyProcurementModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
