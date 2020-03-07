//
//  AccruedDetailModel.m
//  galaxy
//
//  Created by APPLE on 2020/1/2.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedDetailModel.h"

@implementation AccruedDetailModel
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
    AccruedDetailModel *model = [[AccruedDetailModel allocWithZone:zone] init];
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
+ (NSMutableDictionary *)initDicByModel:(PaymentExpDetail *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}


//获取关联预提明细
+(void)getAccruedDetailType:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"]isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in result[@"items"]) {
            AccruedDetailModel *model=[[AccruedDetailModel alloc]init];
            
            model.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"taskId"]]]?[NSString stringWithFormat:@"%@",dict[@"taskId"]]:@"";
            model.paymentOrderNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"paymentOrderNo"]]]?[NSString stringWithFormat:@"%@",dict[@"paymentOrderNo"]]:@"";
            model.accruedTaskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedTaskId"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedTaskId"]]:@"";
            model.accruedDetailInfo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedDetailInfo"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedDetailInfo"]]:@"";
            model.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"serialNo"]]]?[NSString stringWithFormat:@"%@",dict[@"serialNo"]]:@"";
            model.supplierName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"supplierName"]]]?[NSString stringWithFormat:@"%@",dict[@"supplierName"]]:@"";
            model.supplierId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"supplierId"]]]?[NSString stringWithFormat:@"%@",dict[@"supplierId"]]:@"";
            model.contractAppInfo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"contractAppInfo"]]]?[NSString stringWithFormat:@"%@",dict[@"contractAppInfo"]]:@"";
            model.createTime = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"createTime"]]]?[NSString stringWithFormat:@"%@",dict[@"createTime"]]:@"";
            model.accruedName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedName"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedName"]]:@"";
            model.accruedTypeId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedTypeId"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedTypeId"]]:@"";
            model.accruedType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedType"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedType"]]:@"";
            model.accruedGridOrder = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedGridOrder"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedGridOrder"]]:@"";
            model.gridOrder = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"gridOrder"]]]?[NSString stringWithFormat:@"%@",dict[@"gridOrder"]]:@"";
            model.active = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"active"]]]?[NSString stringWithFormat:@"%@",dict[@"active"]]:@"";
            model.expenseCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseCode"]]]?[NSString stringWithFormat:@"%@",dict[@"expenseCode"]]:@"";
            model.expenseType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]]?[NSString stringWithFormat:@"%@",dict[@"expenseType"]]:@"";
            model.expenseIcon = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseIcon"]]]?[NSString stringWithFormat:@"%@",dict[@"expenseIcon"]]:@"";
            model.expenseCatCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseCatCode"]]]?[NSString stringWithFormat:@"%@",dict[@"expenseCatCode"]]:@"";
            model.expenseCat = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseCat"]]]?[NSString stringWithFormat:@"%@",dict[@"expenseCat"]]:@"";
            model.writeOffAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"writeOffAmount"]]]?[NSString stringWithFormat:@"%@",dict[@"writeOffAmount"]]:@"";
            model.surplusAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"surplusAmount"]]]?[NSString stringWithFormat:@"%@",dict[@"surplusAmount"]]:@"";
            model.accruedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"accruedAmount"]]]?[NSString stringWithFormat:@"%@",dict[@"accruedAmount"]]:@"";
            model.localCyAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"localCyAmount"]]]?[NSString stringWithFormat:@"%@",dict[@"localCyAmount"]]:@"";
            model.exclTax = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"exclTax"]]]?[NSString stringWithFormat:@"%@",dict[@"exclTax"]]:@"";
            model.tax = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"tax"]]]?[NSString stringWithFormat:@"%@",dict[@"tax"]]:@"";
            model.exchangeRate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]]]?[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]]:@"";
            model.reason = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"reason"]]]?[NSString stringWithFormat:@"%@",dict[@"reason"]]:@"";
            model.expense = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expense"]]]?[NSString stringWithFormat:@"%@",dict[@"expense"]]:@"";
            [array addObject:model];
        }
    }
}



@end
