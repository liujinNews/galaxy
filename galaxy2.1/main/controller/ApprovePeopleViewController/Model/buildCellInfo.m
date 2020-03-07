//
//  buildCellInfo.m
//  galaxy
//
//  Created by 赵碚 on 15/7/29.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "buildCellInfo.h"
#import "NSString+Common.h"
#import "NSObject+ModelToDic.h"

@implementation buildCellInfo
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


+ (void)GetcompanyBookDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2 cleanSelf:(BOOL)cleanSelf{
    
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * currency = [result objectForKey:@"oftenUsers"]?[result objectForKey:@"oftenUsers"]:nil;
    
    userData *userdatas = [userData shareUserData];

    if (![currency isKindOfClass:[NSNull class]] && currency != nil && currency.count != 0){
        for (NSDictionary * listDic in currency) {
            buildCellInfo * data    = [[buildCellInfo alloc]init];
            [data setValuesForKeysWithDictionary:listDic];
            data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.requestor = [listDic objectForKey:@"requestor"];
            data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
            data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
            data.requestorUserId = [[listDic objectForKey:@"requestorUserId"] intValue];
            data.gender = [[listDic objectForKey:@"gender"]intValue];
            data.guihua = [NSString firstCharactor:data.requestor];
            data.isClick = @"0";
            if (cleanSelf) {
                if (![[NSString stringWithFormat:@"%ld",data.requestorUserId]isEqualToString:[NSString stringWithFormat:@"%@",userdatas.userId]]) {
                    [array1 addObject:data];
                }
            }else{
                [array1 addObject:data];
            }
        }
    }
    
    NSArray * formField = [result objectForKey:@"users"];
    if (![formField isKindOfClass:[NSNull class]] && formField != nil && formField.count != 0){
        for (NSDictionary * listDic in formField) {
            buildCellInfo * data    = [[buildCellInfo alloc]init];
            [data setValuesForKeysWithDictionary:listDic];
            data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.gender = [[listDic objectForKey:@"gender"]intValue];

            data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
            data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
            data.requestorUserId  = [[listDic objectForKey:@"requestorUserId"] intValue];
            data.guihua = [NSString firstCharactor:data.requestor];
            data.isClick = @"0";
            if (cleanSelf) {
                if (![[NSString stringWithFormat:@"%ld",data.requestorUserId]isEqualToString:[NSString stringWithFormat:@"%@",userdatas.userId]]) {
                    [array2 addObject:data];
                }
            }else{
                [array2 addObject:data];
            }
        }
    }
}


+ (void)GetcompanyAddressDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2{
    
     NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    
    if (![result isKindOfClass:[NSNull class]] && result != nil && result.count != 0){
        for (NSDictionary * listDic in result) {
            buildCellInfo * data    = [[buildCellInfo alloc]init];
            [data setValuesForKeysWithDictionary:listDic];
            data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.gender = [[listDic objectForKey:@"gender"]intValue];
            data.email = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]];
            data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
            data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
            data.requestorUserId  = [[listDic objectForKey:@"requestorUserId"]intValue];
            data.guihua = [NSString firstCharactor:data.requestor];
            data.isClick = @"0";
            if (![data.requestor isKindOfClass:[NSNull class]] && data.requestor != nil){
                [array2 addObject:data];
            }
            
        }
    }
    
}

+ (void)GetcompanyAddressByNoDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array1 Array:(NSMutableArray *)array2
{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * currency = [result objectForKey:@"notactusers"];
    if (![currency isKindOfClass:[NSNull class]] && currency != nil && currency.count != 0){
        for (NSDictionary * listDic in currency) {
            buildCellInfo * data    = [[buildCellInfo alloc]init];
            [data setValuesForKeysWithDictionary:listDic];
            data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.gender = [[listDic objectForKey:@"gender"]intValue];
            data.email = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]];
            data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
            data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
            data.requestorUserId  = [[listDic objectForKey:@"requestorUserId"]intValue];
            data.guihua = [NSString firstCharactor:data.requestor];
            data.isClick = @"0";
            data.apply = 1;
            if (![data.requestor isKindOfClass:[NSNull class]] && data.requestor != nil){
                [array1 addObject:data];
            }
        }
    }
    
    NSArray * users = [result objectForKey:@"users"];
    if (![users isKindOfClass:[NSNull class]] && users != nil && users.count != 0){
        for (NSDictionary * listDic in users) {
            buildCellInfo * data    = [[buildCellInfo alloc]init];
            [data setValuesForKeysWithDictionary:listDic];
            data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.gender = [[listDic objectForKey:@"gender"]intValue];
            data.email = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]];
            data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
            data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
            data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
            data.requestorUserId  = [[listDic objectForKey:@"requestorUserId"]intValue];
            data.guihua = [NSString firstCharactor:data.requestor];
            data.isClick = @"0";
            data.apply = 0;
            if (![data.requestor isKindOfClass:[NSNull class]] && data.requestor != nil){
                [array2 addObject:data];
            }
        }
    }
    
}

+ (buildCellInfo *) retrunByDic:(NSDictionary *)dic
{
    NSDictionary *listDic = dic;
    buildCellInfo * data    = [[buildCellInfo alloc]init];
    [data setValuesForKeysWithDictionary:listDic];
    data.companyId      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
    data.contact  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"contact"]];
    data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
    data.jobTitleCode      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
    data.photoGraph  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
    data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
    data.gender = [[listDic objectForKey:@"gender"]intValue];
    data.email = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]];
    data.requestorAccount      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorAccount"]];
    data.requestorDept  = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
    data.requestorDeptId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDeptId"]];
    data.requestorHRID      = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorHRID"]];
    data.requestorUserId  = [[listDic objectForKey:@"requestorUserId"]intValue];
    data.guihua = [NSString firstCharactor:data.requestor];
    data.isClick = @"0";
    data.apply = 0;
    return data;
}

+ (NSMutableDictionary *)initDicByModel:(buildCellInfo*)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:model]];
    return dic;
}

@end
