//
//  projectManagerModel.m
//  galaxy
//
//  Created by 赵碚 on 16/2/25.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "projectManagerModel.h"

@implementation projectManagerModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)GetProjectManagerDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    NSArray * items = [result objectForKey:@"items"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            projectManagerModel * data    = [[projectManagerModel alloc]init];
            data.companyId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"companyId"]]]?[NSString stringWithFormat:@"%@",listDic[@"companyId"]]:@"0";
            data.idd = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"0";            
            data.projMgr=[NSString stringIsExist:listDic[@"projMgr"]];
            data.projMgrUserId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projMgrUserId"]]]?[NSString stringWithFormat:@"%@",listDic[@"projMgrUserId"]]:@"0";
            data.projName = [NSString stringIsExist:listDic[@"projName"]];
            data.projNameEn = [NSString stringIsExist:listDic[@"projNameEn"]];
            data.startTime=[NSString stringIsExist:listDic[@"startTime"]];
            data.endTime=[NSString stringIsExist:listDic[@"endTime"]];
            data.Description=[NSString stringIsExist:listDic[@"description"]];
            data.funder = [NSString stringIsExist:listDic[@"funder"]];
            data.projTyp=[NSString stringIsExist:listDic[@"projTyp"]];
            data.projTypId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projTypId"]]]?[NSString stringWithFormat:@"%@",listDic[@"projTypId"]]:@"0";
            data.memberId=[NSString stringIsExist:listDic[@"memberId"]];
            data.memberName=[NSString stringIsExist:listDic[@"memberName"]];
            data.costCenter = [NSString stringIsExist:listDic[@"costCenter"]];
            data.costCenterId = [NSString stringIsExist:listDic[@"costCenterId"]];
            [array addObject:data];
            
        }
    }
    
    
}


@end
