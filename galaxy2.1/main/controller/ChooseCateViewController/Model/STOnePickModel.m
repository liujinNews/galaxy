//
//  STOnePickModel.m
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "STOnePickModel.h"
#import "userData.h"

@implementation STOnePickModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getCertificateType:(NSMutableArray *)array{
    NSArray *arr=@[Custing(@"身份证", nil),Custing(@"户口薄", nil),Custing(@"护照", nil),Custing(@"军人证", nil),Custing(@"港澳台居民身份证", nil),Custing(@"武警身份证", nil),Custing(@"边民出入境通行证", nil)];
    for (NSString *str in arr) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Type = str;
        model.Id = @"";
        [array addObject:model];
    }
}
+(void)getPayWay:(NSMutableArray *)array{
    NSArray *arr=@[@{@"type":Custing(@"线上支付", nil),@"Id":@"1"},@{@"type":Custing(@"线下支付", nil),@"Id":@"2"}];
    for (NSDictionary *dict in arr) {
        STOnePickModel *model=[[STOnePickModel alloc]init];
        model.Type=dict[@"type"];
        model.Id=dict[@"Id"];
        [array addObject:model];
    }
}
+(void)getCurrcyWithDate:(NSMutableArray *)resultArr WithResult:(NSMutableArray *)array WithCurrencyDict:(NSMutableDictionary *)Currencydict{
    if (resultArr.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArr) {
        STOnePickModel *model=[[STOnePickModel alloc]init];
        model.Type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"currency"]]]?[NSString stringWithFormat:@"%@",dict[@"currency"]]:@"";
        model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"currencyCode"]]]?[NSString stringWithFormat:@"%@",dict[@"currencyCode"]]:@"";
        model.currencyShort=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"currencyShort"]]]?[NSString stringWithFormat:@"%@",dict[@"currencyShort"]]:@"";
        model.exchangeRate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]]]?[NSString reviseString:[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]]]:@"";
        model.stdMoney=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"stdMoney"]]]?[NSString stringWithFormat:@"%@",dict[@"stdMoney"]]:@"0";
        
        if ([model.stdMoney isEqualToString:@"1"]) {
            [Currencydict setValue:model.Type forKey:@"Currency"];
            [Currencydict setValue:model.Id forKey:@"CurrencyCode"];
            [Currencydict setValue:model.exchangeRate forKey:@"ExchangeRate"];
        }

        [array addObject:model];
    }
}
+(void)getInvoiceTypeWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array{
    if (resultArr.count>0) {
        for (NSDictionary *dict in resultArr) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
            model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"type"]]]?[NSString stringWithFormat:@"%@",dict[@"type"]]:@"";
            model.requiredReason=[[NSString stringWithFormat:@"%@",dict[@"requiredReason"]]isEqualToString:@"1"] ? 1 : 0;
            model.requiredAtt=[[NSString stringWithFormat:@"%@",dict[@"requiredAtt"]]isEqualToString:@"1"] ? 1 : 0;;
            [array addObject:model];
        }
    }
}


+(void)getVehicleType:(NSMutableArray *)array{
    NSArray *arr=@[Custing(@"公司车辆", nil),Custing(@"滴滴出行", nil)];
    for (NSString *str in arr) {
        STOnePickModel *model=[[STOnePickModel alloc]init];
        model.Type=str;
        model.Id=@"";
        [array addObject:model];
    }
}

+(void)getClaimTypeWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array{
    if (resultArr.count>0) {
        userData *userdatas = [userData shareUserData];
        for (NSDictionary *dict in resultArr) {
            if (([dict[@"type"]floatValue] == 1 && [userdatas.arr_XBFlowcode containsObject:@"F0002"])||([dict[@"type"]floatValue] == 2 && [userdatas.arr_XBFlowcode containsObject:@"F0003"])||([dict[@"type"]floatValue] == 3 && [userdatas.arr_XBFlowcode containsObject:@"F0010"])) {
                STOnePickModel *model=[[STOnePickModel alloc]init];
                model.Type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
                model.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"type"]]]?[NSString stringWithFormat:@"%@",dict[@"type"]]:@"";
                [array addObject:model];
            }
        }
    }
}

+(void)getInvoiceTypesWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array{
    if (resultArr.count>0) {
        for (NSDictionary *dict in resultArr) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
            model.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"code"]]]?[NSString stringWithFormat:@"%@",dict[@"code"]]:@"";
            model.isDefault = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"isDefault"]]]?[NSString stringWithFormat:@"%@",dict[@"isDefault"]]:@"0";
            model.taxRate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"taxRate"]]]?[NSString stringWithFormat:@"%@",dict[@"taxRate"]]:@"";
            model.invoiceType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"type"]]]?[NSString stringWithFormat:@"%@",dict[@"type"]]:@"";
            [array addObject:model];
        }
    }
}

+(void)getTaxRatesWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array{
    if (resultArr.count>0) {
        for (NSDictionary *dict in resultArr) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"taxRate"]]]?[NSString stringWithFormat:@"%@",dict[@"taxRate"]]:@"0";
            model.isDefault = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"isDefault"]]]?[NSString stringWithFormat:@"%@",dict[@"isDefault"]]:@"0";
            [array addObject:model];
        }
    }
}

+(void)getTrainSeatsWithDate:(NSArray *)resultArr WithResult:(NSMutableArray *)array{
    if (resultArr.count>0) {
        for (NSDictionary *dict in resultArr) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"name"]]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
            [array addObject:model];
        }
    }
}

@end
