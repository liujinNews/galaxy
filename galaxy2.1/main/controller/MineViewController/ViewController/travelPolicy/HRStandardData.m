//
//  HRStandardData.m
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "HRStandardData.h"

@implementation HRStandardData
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)GetUserLevelListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array {
   
    NSArray * items = [dic objectForKey:@"result"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            HRStandardData * data    = [[HRStandardData alloc]init];
            data.housePrice0 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice0"]];
            data.housePrice1 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice1"]];
            data.housePrice2 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice2"]];
            data.housePrice3 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice3"]];
            data.housePrice4 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice4"]];
            data.housePrice5 = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"housePrice5"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.isLimit = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"isLimit"]];
            if ([[NSString stringWithFormat:@"%@",[listDic objectForKey:@"isLimit"]] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@",[listDic objectForKey:@"standard"]] isEqualToString:@"1"]){
                    data.cellHeight = @"160";
                    data.type = hrstCellTypeYes;
                }else{
                    data.cellHeight = @"55";
                    data.type = hrstCellTypeAll;
                }
                
            }else{
                data.cellHeight = @"55";
                data.type = hrstCellTypeNo;
            }
            data.standard = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"standard"]];
            data.userLevel = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevel"]];
            data.userLevelId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelId"]];
            
            [array addObject:data];
            
        }
    }
}

//补贴标准列表
+ (void)GetUserForStandardListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)hrstArray {
    
    NSArray * items = [dic objectForKey:@"result"];
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            HRStandardData * data    = [[HRStandardData alloc]init];
            data.userLevel = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevel"]];
            data.userLevelId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelId"]];
            data.StdAllowances = [listDic objectForKey:@"stdAllowances"];
            data.type = ForStCellType;
            if (data.StdAllowances.count <= 1) {
                data.cellHeight = @"55";
            }else {
                NSInteger heights = 30 * data.StdAllowances.count + 5;
                data.cellHeight = [NSString stringWithFormat:@"%ld",(long)heights];
            }
            [hrstArray addObject:data];
            
        }
    }
}

//补贴标准修改
+ (void)GetUserGetStdAllowancesDictionary:(NSArray *)items Array:(NSMutableArray *)hrstArray
{
    
    if (![items isKindOfClass:[NSNull class]] && items != nil && items.count != 0){
        for (NSDictionary * listDic in items) {
            HRStandardData * data    = [[HRStandardData alloc]init];
            data.amount = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]];
            data.expenseCode = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseCode"]];
            data.expenseType = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"expenseType"]];
            data.idd = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]];
            data.unit = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"unit"]];
 
            [hrstArray addObject:data];
            
        }
    }
}


@end
