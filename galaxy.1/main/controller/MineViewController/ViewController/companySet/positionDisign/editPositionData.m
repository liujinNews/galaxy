//
//  editPositionData.m
//  galaxy
//
//  Created by 赵碚 on 16/1/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "editPositionData.h"

@implementation editPositionData
+ (void)GetEditPositionListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            editPositionData * data    = [[editPositionData alloc]init];
            data.active = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"active"]];
            data.companyId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.createTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"createTime"]];
            data.creater = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"active"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.jobTitle = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitle"]];
            data.jobTitleCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleCode"]];
            data.jobTitleEn = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"jobTitleEn"]];
            data.updateTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"updateTime"]];
            data.updater = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"updater"]];
            [array addObject:data];
            
        }
    }
    
    
}

+ (void)GetEditUserLevealDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            editPositionData * data    = [[editPositionData alloc]init];
            data.active = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"active"]];
            data.companyId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.createTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"createTime"]];
            data.creater = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"creater"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.descriptino = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"description"]];
            data.total = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"total"]];
            data.updateTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"updateTime"]];
            data.updater = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"updater"]];
            data.userLevel = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevel"]];
            data.userLevelEn = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelEn"]];
            data.userLevelNo = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelNo"]];

            [array addObject:data];
            
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
