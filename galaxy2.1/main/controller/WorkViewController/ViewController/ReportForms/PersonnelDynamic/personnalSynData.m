//
//  personnalSynData.m
//  galaxy
//
//  Created by 赵碚 on 16/5/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "personnalSynData.h"

@implementation personnalSynData
+ (void)GetPersonnalSynDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            personnalSynData * data    = [[personnalSynData alloc]init];
            data.fromCity = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromCity"]];
            data.fromDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromDate"]];
            data.mobile = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"mobile"]];
            data.photoGraph = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"photoGraph"]];
            data.gender = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"gender"]];
            data.reason = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"reason"]];
            data.requestor = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestor"]];
            data.requestorDept = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"requestorDept"]];
            data.toCity = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"toCity"]];
            data.toDate = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"toDate"]];
            data.userDspName = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userDspName"]];
            data.userId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userId"]];
            [array addObject:data];
            
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
