//
//  PersonnelStatData.m
//  galaxy
//
//  Created by 赵碚 on 16/6/28.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "PersonnelStatData.h"

@implementation PersonnelStatData

+ (void)GetPersonnelStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            PersonnelStatData * data    = [[PersonnelStatData alloc]init];
            data.expenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.expenseDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseDate"]];
            data.expenseIcon = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseIcon"]];
            data.expenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.requestorDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDate"]];
            data.requestorUserId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorUserId"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            
            [array addObject:data];
            
        }
    }
    
    
}

+ (void)GetProjectStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            PersonnelStatData * data    = [[PersonnelStatData alloc]init];
            data.expenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.expenseDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseDate"]];
            data.expenseIcon = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseIcon"]];
            data.expenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.projName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"projName"]];
            data.requestorUserId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorUserId"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            
            [array addObject:data];
            
        }
    }
    
    
}


+ (void)GetZFProjectStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            PersonnelStatData * data    = [[PersonnelStatData alloc]init];
            
            data.descriptino = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"description"]];
            data.projName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"projName"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            
            [array addObject:data];
            
        }
    }
    
    
}



+ (void)GetDepartmentStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            PersonnelStatData * data    = [[PersonnelStatData alloc]init];
            data.amount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]];
            data.expenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.expenseDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseDate"]];
            
            data.expenseIcon = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseIcon"]];
            data.expenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            
            [array addObject:data];
            
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
