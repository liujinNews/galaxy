//
//  CostCateNewModel.m
//  galaxy
//
//  Created by hfk on 2018/1/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "CostCateNewModel.h"

@implementation CostCateNewModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getTypeByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array
{
    NSArray *listArray=[dic objectForKey:@"result"];
    for (NSDictionary *listDic in listArray) {
        CostCateNewModel *data=[[CostCateNewModel alloc]init];
        //        data.expenseCode=[listDic objectForKey:@"expenseCode"];
        //        data.expenseIcon=[listDic objectForKey:@"expenseIcon"];
        //        data.expenseType=[listDic objectForKey:@"expenseType"];
        [data setValuesForKeysWithDictionary:listDic];
        [array addObject:data];
    }
}

+(NSDictionary *)getCostCateByDict:(NSDictionary *)reqDict array:(NSMutableArray *)resultArr withType:(NSInteger)type{
    NSDictionary *backDict;
    if (type==1) {
        NSString  *str_CateLevel=@"0";
        NSString  *str_isShowDesc=@"0";
        NSInteger int_categoryRows=0;
        NSDictionary *Basedict=[reqDict objectForKey:@"result"];
        if (![Basedict isKindOfClass:[NSNull class]]) {
            str_CateLevel=[NSString stringWithFormat:@"%@",[Basedict objectForKey:@"result"]];
            str_isShowDesc=[NSString stringWithFormat:@"%@",[Basedict objectForKey:@"isShowExpenseDesc"]];
            if ([str_CateLevel isEqualToString:@"1"]) {
                NSArray *result=[Basedict objectForKey:@"expTypBoxOutputs"];
                if (![result isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result) {
                        CostCateNewModel *model=[[CostCateNewModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        model.parentCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"parentCode"]];
                        model.expenseCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCode"]];
                        model.expenseIcon=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseIcon"]];
                        model.expenseType=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseType"]];
                        model.expenseCat=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCat"]];
                        model.expenseCatCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCatCode"]];
                        model.expenseDesc=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseDesc"]];
                        model.tax=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tax"]];
                        model.tag=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tag"]];
                        model.isTravel=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isTravel"]];
                        model.isApproval=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isApproval"]];
                        model.isDaily=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isDaily"]];
                        model.isPayment=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isPayment"]];
                        model.isContract=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isContract"]];
                        model.parentId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"parentId"]];
                        model.accountItemCode = [NSString stringIsExist:dict[@"accountItemCode"]];
                        model.accountItem = [NSString stringIsExist:dict[@"accountItem"]];
                        [resultArr addObject:model];
                    }
                }
            }else if ([str_CateLevel isEqualToString:@"2"]||[str_CateLevel isEqualToString:@"3"]){
                NSArray *result=[Basedict objectForKey:@"expTypListOutputs"];
                if (![result isKindOfClass:[NSNull class]]) {
                    [CostCateNewModel getCostCate:result result:resultArr];
                }
            }
        }
        
        int_categoryRows=ceilf((float)(resultArr.count)/5);
        backDict=@{@"CateLevel":str_CateLevel,@"categoryRows":[NSString stringWithFormat:@"%ld",(long)int_categoryRows],@"isShowExpenseDesc":str_isShowDesc};
    }else if (type==2){
        NSArray *BaseArray=[reqDict objectForKey:@"result"];
        if (![BaseArray isKindOfClass:[NSNull class]]&&BaseArray.count>0) {
            [CostCateNewModel getCostCate:BaseArray result:resultArr];
        }
    }
    return backDict;
}


+(void)getCostCate:(NSArray *)array  result:(NSMutableArray *)resultarr{
    for (NSDictionary *dict in array) {
        CostCateNewModel *model=[[CostCateNewModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        model.expenseCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCode"]];
        model.expenseIcon=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseIcon"]];
        model.expenseType=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseType"]];
        model.isTravel=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isTravel"]];
        model.isApproval=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isApproval"]];
        model.isDaily=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isDaily"]];
        model.isPayment=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isPayment"]];
        model.isContract=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isContract"]];
        model.accountItemCode = [NSString stringIsExist:dict[@"accountItemCode"]];
        model.accountItem = [NSString stringIsExist:dict[@"accountItem"]];
        model.Id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        model.getExpTypeList=[NSMutableArray array];
        if (![dict[@"getExpTypeList"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=dict[@"getExpTypeList"];
            if (![arr isKindOfClass:[NSNull class]]&&arr.count>0) {
                [CostCateNewSubModel getSubCostCateByArray:arr withResult:model.getExpTypeList];
            }
        }
        [resultarr addObject:model];
    }
}

@end

@implementation CostCateNewSubModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+(void)getSubCostCateByArray:(NSArray *)array withResult:(NSMutableArray *)resultarray{
    for (NSDictionary *dict in array) {
        CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        model.Id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        model.isTravel=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isTravel"]];
        model.isApproval=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isApproval"]];
        model.isDaily=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isDaily"]];
        model.isPayment=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isPayment"]];
        model.isContract=[NSString stringWithFormat:@"%@",[dict objectForKey:@"isContract"]];
        model.expenseCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCode"]];
        model.expenseIcon=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseIcon"]];
        model.expenseType=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseType"]];
        model.expenseDesc=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseDesc"]];
        model.tag=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tag"]];
        model.expenseCatCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCatCode"]];
        model.expenseCat=[NSString stringWithFormat:@"%@",[dict objectForKey:@"expenseCat"]];
        model.tax=[NSString stringWithFormat:@"%@",[dict objectForKey:@"tax"]];
        model.no=[NSString stringWithFormat:@"%@",[dict objectForKey:@"no"]];
        model.catNo=[NSString stringWithFormat:@"%@",[dict objectForKey:@"catNo"]];
        model.parentId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"parentId"]];
        model.accountItemCode = [NSString stringIsExist:dict[@"accountItemCode"]];
        model.accountItem = [NSString stringIsExist:dict[@"accountItem"]];
        [resultarray addObject:model];
    }
}


@end


