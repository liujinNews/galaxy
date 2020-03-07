//
//  currencyData.m
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "currencyData.h"

@implementation currencyData
+ (void)GetCurrencyListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            currencyData * data    = [[currencyData alloc]init];
            data.currency =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"currency"]]]?[NSString stringWithFormat:@"%@",listDic [@"currency"]]:@"";
            data.currencyCode =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"currencyCode"]]]?[NSString stringWithFormat:@"%@",listDic [@"currencyCode"]]:@"";
            data.ExchangeRate =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"exchangeRate"]]]?[NSString stringWithFormat:@"%@",listDic [@"exchangeRate"]]:@"";
            data.idd =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"id"]]]?[NSString stringWithFormat:@"%@",listDic [@"id"]]:@"0";
            data.currencyShort =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"currencyShort"]]]?[NSString stringWithFormat:@"%@",listDic [@"currencyShort"]]:@"";
            data.no =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"no"]]]?[NSString stringWithFormat:@"%@",listDic [@"no"]]:@"0";
            data.stdMoney =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic [@"stdMoney"]]]?[NSString stringWithFormat:@"%@",listDic [@"stdMoney"]]:@"0";

            [array addObject:data];
            
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
