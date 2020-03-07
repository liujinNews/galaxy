//
//  addTravelAndDayCateryData.m
//  galaxy
//
//  Created by 赵碚 on 2016/12/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "addTravelAndDayCateryData.h"

@implementation addTravelAndDayCateryData

//费用类别
+ (void)GetTravelAndDayCateryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSArray * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }else {
        for (NSDictionary * listDic in result) {
            addTravelAndDayCateryData * data    = [[addTravelAndDayCateryData alloc]init];
            data.ExpenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            data.GetExpTypeList = [listDic objectForKey:@"getExpTypeList"];
            
            data.expenstr = @"";
            for (NSDictionary * dicts in data.GetExpTypeList) {
                data.expenstr = [NSString stringWithFormat:@"%@    %@",data.expenstr,[dicts objectForKey:@"expenseType"]];
            }
            data.sizes = [NSString sizeWithText:data.expenstr font:Font_Important_15_20 maxSize:CGSizeMake(Main_Screen_Width-30, MAXFLOAT)];
            
            [array addObject:data];
            
        }
    }
    
}

+(void)getResultDate:(NSDictionary *)dict WithArray:(NSMutableArray *)array{
    NSArray * result = [dict objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result) {
        return;
    }else{
        for (NSDictionary * listDic in result) {
            addTravelAndDayCateryData * data    = [[addTravelAndDayCateryData alloc]init];
            data.Idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.ExpenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            data.ExpenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.ExpenseIcon = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseIcon"]];
            NSArray *arr=[listDic objectForKey:@"getExpTypeList"];
            NSMutableArray *arr1=[NSMutableArray array];
            for (NSDictionary *aimdict in arr) {
                NSMutableDictionary *indict=[NSMutableDictionary dictionaryWithDictionary:aimdict];
                [arr1 addObject:indict];
            }
            data.GetExpTypeList = arr1;
            [array addObject:data];
        }
    }
}
//费用类别collection
+ (void)GetCollectionAddTravelAndDayCateryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSArray * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }else {
        for (NSDictionary * listDic in result) {
            addTravelAndDayCateryData * data    = [[addTravelAndDayCateryData alloc]init];
            data.coId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.coExpenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            data.isTravelApp = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isTravelApp"]];
            data.isDaily = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isDaily"]];
            data.isTravel = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isTravel"]];
            data.isApproval = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isApproval"]];
            data.isPayment = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isPayment"]];
            data.isContract = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isContract"]];
            data.tax = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"tax"]];
            [array addObject:data];
            
        }
    }
    
}

+(void)getSubmitData:(NSMutableArray *)sourceArr WithResultArr:(NSMutableArray *)aimArr{
    for (addTravelAndDayCateryData *date in sourceArr) {
        NSMutableArray *array=date.GetExpTypeList;
        if (![array isKindOfClass:[NSNull class]]&&array.count>0) {
            for (NSMutableDictionary * listDic in array) {
                [aimArr addObject:listDic];
            }
        }
    }
}
@end
