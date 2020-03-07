//
//  ChooseCategoryModel.m
//  galaxy
//
//  Created by hfk on 16/4/20.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "ChooseCategoryModel.h"

@implementation ChooseCategoryModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
//支付方式
+ (void)getPayWayByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.payMode=[NSString isEqualToNull:dict[@"payMode"]]?dict[@"payMode"]:@"";
        model.payCode=[NSString stringWithFormat:@"%@",dict[@"payCode"]];
        [array addObject:model];
    }
}
//采购类型
+ (void)getpurchaseTypeByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.purchaseType =[NSString isEqualToNull:dict[@"purchaseType"]]?dict[@"purchaseType"]:@"";
        model.purchaseCode=[NSString stringWithFormat:@"%@",dict[@"purchaseCode"]];
        [array addObject:model];
    }
}
//请假类型
+ (void)getLeaveTypeByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.leaveType =[NSString isEqualToNull:dict[@"leaveType"]]?dict[@"leaveType"]:@"";
        model.leaveCode=[NSString stringWithFormat:@"%@",dict[@"leaveCode"]];
        model.limitDay=[NSString stringWithFormat:@"%@",dict[@"limitDay"]];
        model.Id=[NSString stringWithFormat:@"%@",dict[@"id"]];
        [array addObject:model];
    }

}
//获取部门(新)
+(void)getDepartmentNewByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSArray * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]] || result == nil|| result.count == 0||!result){
        return;
    }
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model = [[ChooseCategoryModel alloc]init];
        model.groupName = [NSString isEqualToNull:dict[@"groupName"]]?dict[@"groupName"]:@"";
        model.groupId = [NSString stringWithFormat:@"%@",dict[@"groupId"]];
        model.jobTitle = [NSString isEqualToNull:dict[@"jobTitle"]]?dict[@"jobTitle"]:@"";
        model.jobTitleCode = [NSString isEqualToNull:dict[@"jobTitleCode"]]?[NSString stringWithFormat:@"%@",dict[@"jobTitleCode"]]:@"";
        model.jobTitleLvl = [NSString isEqualToNull:dict[@"jobTitleLvl"]]?[NSString stringWithFormat:@"%@",dict[@"jobTitleLvl"]]:@"0";
        [array addObject:model];
    }
}
//获取报销类型
+(void)getClaimType:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.claimType =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"claimType"]]]?[NSString stringWithFormat:@"%@",dict[@"claimType"]]:@"";
        model.isRelation  =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"isRelation"]]]?[NSString stringWithFormat:@"%@",dict[@"isRelation"]]:@"";
        model.Id =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"id"]]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"";
        model.setApprover  =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"setApprover"]]]?[NSString stringWithFormat:@"%@",dict[@"setApprover"]]:@"0";
        [array addObject:model];
    }
}
//获取车辆信息
+(void)getCarInfoByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.carDesc =[NSString isEqualToNull:dict[@"carDesc"]]?[NSString stringWithFormat:@"%@",dict[@"carDesc"]]:@"";
        model.carNo=[NSString isEqualToNull:dict[@"carNo"]]?[NSString stringWithFormat:@"%@",dict[@"carNo"]]:@"";
        model.Id=[NSString isEqualToNull:dict[@"id"]]?dict[@"id"]:@"0";
        [array addObject:model];
    }
}

+ (void)getSupplierCatByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.name=[NSString isEqualToNull:dict[@"name"]]?[NSString stringWithFormat:@"%@",dict[@"name"]]:@"";
        model.Id=[NSString isEqualToNull:dict[@"id"]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        model.code=[NSString isEqualToNull:dict[@"code"]]?[NSString stringWithFormat:@"%@",dict[@"code"]]:@"0";
        [array addObject:model];
    }
}
//获取采购分类
+(void)getProductCatListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.code =[NSString isEqualToNull:dict[@"code"]]?[NSString stringWithFormat:@"%@",dict[@"code"]]:@"";
        model.Id=[NSString isEqualToNull:dict[@"id"]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        model.name=[NSString isEqualToNull:dict[@"name"]]?dict[@"name"]:@"";
        [array addObject:model];
    }
}
//获取新支付方式
+ (void)getNewPayWayByArray:(NSArray *)resultArray Array:(NSMutableArray *)array{
    if (resultArray.count==0) {
        return;
    }
    for (NSDictionary *dict in resultArray) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.name=[NSString stringWithIdOnNO:dict[@"name"]];
        model.Id=[NSString isEqualToNull:dict[@"id"]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        model.code=[NSString stringWithIdOnNO:dict[@"code"]];
        model.no=[NSString stringWithIdOnNO:dict[@"no"]];
        [array addObject:model];
    }
}
//用车类型
+(void)getVehicleTypListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.type =[NSString isEqualToNull:dict[@"type"]]?[NSString stringWithFormat:@"%@",dict[@"type"]]:@"0";
        model.Id=[NSString isEqualToNull:dict[@"id"]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        model.name=[NSString isEqualToNull:dict[@"name"]]?dict[@"name"]:@"";
        model.no=[NSString isEqualToNull:dict[@"no"]]?dict[@"no"]:@"";
        [array addObject:model];
    }
}

+(void)getAttendanceRoleListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.roleId = [NSString isEqualToNull:dict[@"roleId"]]?[NSString stringWithFormat:@"%@",dict[@"roleId"]]:@"0";
        model.roleName = [NSString stringWithIdOnNO:dict[@"roleName"]];
        model.roleNameEn = [NSString stringWithIdOnNO:dict[@"roleNameEn"]];
        [array addObject:model];
    }
}
+(void)getSupplierCatsListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.Id = [NSString isEqualToNull:dict[@"id"]]?[NSString stringWithFormat:@"%@",dict[@"id"]]:@"0";
        model.code = [NSString stringWithIdOnNO:dict[@"code"]];
        model.name = [NSString stringWithIdOnNO:dict[@"name"]];
        [array addObject:model];
    }
}

+(void)getProvincesListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.provinceCode = [NSString stringIsExist:dict[@"provinceCode"]];
        model.provinceName = [NSString stringIsExist:dict[@"provinceName"]];
        [array addObject:model];
    }
}
+(void)getCitysListByDict:(NSDictionary *)dic Array:(NSMutableArray *)array{
    if (![dic[@"result"] isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *result=dic[@"result"];
    for (NSDictionary *dict in result) {
        ChooseCategoryModel *model=[[ChooseCategoryModel alloc]init];
        model.cityCode = [NSString stringIsExist:dict[@"cityCode"]];
        model.cityName = [NSString stringIsExist:dict[@"cityName"]];
        [array addObject:model];
    }
}


@end
