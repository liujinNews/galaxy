//
//  borrowModel.m
//  galaxy
//
//  Created by 赵碚 on 16/1/14.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "borrowModel.h"

@implementation borrowModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (void)GetBorrowRecordDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            borrowModel * data    = [[borrowModel alloc]init];
            data.amount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]];
            data.comment = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"comment"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.operators = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"operator"]];
            data.operatorDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"operatorDate"]];
            data.repayAmount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"repayAmount"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.requestorDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDate"]];
            data.requestorDept = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorUserId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorUserId"]];
            data.taskId =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"";
            data.flowCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]:@"";
            data.type = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]];
            [array addObject:data];
            
        }
    }
    
    
}
//GetRepaymentListDictionary
+ (void)GetRepaymentListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            borrowModel * data    = [[borrowModel alloc]init];
            data.amount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]];
            data.currencyCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"currencyCode"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.reason = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"reason"]];
            data.repayDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"repayDate"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.requestorDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDate"]];
            data.requestorUserId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorUserId"]];
            data.taskId =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"";
            data.flowCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]:@"";
            [array addObject:data];
            
        }
    }
    
    
}

@end
