//
//  costCenterData.m
//  galaxy
//
//  Created by 赵碚 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "costCenterData.h"

@implementation costCenterData
+ (void)GetCostCenterListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            costCenterData * data    = [[costCenterData alloc]init];
            data.companyId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.costCenter = [NSString stringIsExist:[listDic objectForKey:@"costCenter"]];
            data.costCenterEn = [NSString stringIsExist:[listDic objectForKey:@"costCenterEn"]];
            data.costCenterMgrUserId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgrUserId"]];
            data.costCenterMgr = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgr"]];
            [array addObject:data];
        }
    }
}
//采购类型
+ (void)GetProcurementListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSArray * items = [dic objectForKey:@"result"];
    if ([items isKindOfClass:[NSNull class]] || items == nil|| items.count == 0||!items){
        return;
    }
    for (NSDictionary * listDic in items) {
        costCenterData * data    = [[costCenterData alloc]init];
        data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
        data.no = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]];
        data.purchaseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"purchaseCode"]];
        data.type = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]];
        
        [array addObject:data];
        
    }
}

//出差类型
+ (void)GetTravelTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
   
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            costCenterData * data    = [[costCenterData alloc]init];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.no = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]];
            data.travelType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"travelType"]];
            data.travelTypeEn = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"travelTypeEn"]];
            [array addObject:data];
            
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
