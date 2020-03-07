//
//  departmentStatData.m
//  galaxy
//
//  Created by 赵碚 on 16/6/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "departmentStatData.h"

@implementation departmentStatData


+ (void)GetDepartmentStatDictionary:(NSDictionary *)dic Array:(NSMutableArray *)groupsArray Array:(NSMutableArray *)groupMbrsArray Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * groups = [result objectForKey:@"groups"];
    if (![groups isKindOfClass:[NSNull class]] && groups != nil && groups.count != 0){
        for (NSDictionary * listDic in groups) {
            departmentStatData * data    = [[departmentStatData alloc]init];
            data.groupId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupId"]];
            data.groupName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupName"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            data.height = @"55";
            data.type = [@(departmentCell)integerValue];
            [groupsArray addObject:data];
            
        }
    }
    
    NSArray * groupMbrs = [result objectForKey:@"groupMbrs"];
    if (![groupMbrs isKindOfClass:[NSNull class]] && groupMbrs != nil && groupMbrs.count != 0){
        for (NSDictionary * listDic in groupMbrs) {
            departmentStatData * data    = [[departmentStatData alloc]init];
            data.photoGraph = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.gender = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"gender"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            data.userDspName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userDspName"]];
            data.userId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userId"]];
            data.height = @"80";
            data.type = [@(departmentCellPerson)integerValue];
            [groupMbrsArray addObject:data];
            
        }
    }
    
    NSMutableArray * amountArray = [[NSMutableArray alloc]init];
    if (groupsArray.count != 0||groupMbrsArray.count != 0) {
        departmentStatData * data = [[departmentStatData alloc]init];
        data.totalAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"totalAmount"]];
        data.height = @"55";
        data.type = [@(departmentCellAmount)integerValue];
        [amountArray addObject:data];
        [array addObject:amountArray];
    }
    [array addObject:groupsArray];
    [array addObject:groupMbrsArray];
    
}

+ (void)GetDepartmentStatCategaryDictionary:(NSDictionary *)dic Array:(NSMutableArray *)groupsArray Array:(NSMutableArray *)groupMbrsArray Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * groups = [result objectForKey:@"groups"];
    if (![groups isKindOfClass:[NSNull class]] && groups != nil && groups.count != 0){
        for (NSDictionary * listDic in groups) {
            departmentStatData * data    = [[departmentStatData alloc]init];
            data.groupId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupId"]];
            data.groupName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupName"]];
            data.totalAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]];
            data.height = @"45";
            data.type = [@(departmentCellDepart)integerValue];
            [groupsArray addObject:data];
            
        }
    }
    
    NSArray * groupTyps = [result objectForKey:@"groupTyps"];
    if (![groupTyps isKindOfClass:[NSNull class]] && groupTyps != nil && groupTyps.count != 0){
        for (NSDictionary * listDic in groupTyps) {
            departmentStatData * data    = [[departmentStatData alloc]init];
            data.amount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]];
            data.expenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.expenseDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseDate"]];
            data.expenseIcon = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseIcon"]];
            data.expenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            data.groupId = [NSString stringWithFormat:@"%@",[result objectForKey:@"groupId"]];
            data.height = @"45";
            data.type = [@(departmentCellCategary)integerValue];
            [groupMbrsArray addObject:data];
            
        }
    }
    
//    NSMutableArray * amountArray = [[NSMutableArray alloc]init];
//    if (groupsArray.count != 0||groupMbrsArray.count != 0) {
//        departmentStatData * data = [[departmentStatData alloc]init];
//        data.totalAmount = [NSString stringWithFormat:@"%@",[result objectForKey:@"totalAmount"]];
//        data.height = @"55";
//        data.type = [@(departmentCellAmount)integerValue];
//        [amountArray addObject:data];
//        [array addObject:amountArray];
//    }
    [array addObject:groupsArray];
    [array addObject:groupMbrsArray];
    
}


@end
