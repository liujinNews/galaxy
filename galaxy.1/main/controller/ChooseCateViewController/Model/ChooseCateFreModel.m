//
//  ChooseCateFreModel.m
//  galaxy
//
//  Created by hfk on 2017/6/21.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ChooseCateFreModel.h"

@implementation ChooseCateFreModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
//解析项目
+ (void)GetProjectManagerDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"]isKindOfClass:[NSArray class]]) {
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.companyId = [NSString isEqualToNull:listDic[@"companyId"]] ? [NSString stringWithFormat:@"%@",listDic[@"companyId"]]:@"0";
            data.endTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"endTime"]];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"0";
            data.projMgr=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projMgr"]]]?[NSString stringWithFormat:@"%@",listDic[@"projMgr"]]:@"";
            data.projMgrUserId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projMgrUserId"]]]?[NSString stringWithFormat:@"%@",listDic[@"projMgrUserId"]]:@"0";
            data.projName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projName"]]]?[NSString stringWithFormat:@"%@",listDic[@"projName"]]:@"";
            data.startTime = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"startTime"]];
            data.Description=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"description"]]]?[NSString stringWithFormat:@"%@",listDic[@"description"]]:@"";
            data.funder = [NSString stringIsExist:listDic[@"funder"]];
            data.projTyp=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projTyp"]]]?[NSString stringWithFormat:@"%@",listDic[@"projTyp"]]:@"";
            data.projTypId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projTypId"]]]?[NSString stringWithFormat:@"%@",listDic[@"projTypId"]]:@"0";
            [array addObject:data];
        }
    }
}
//解析成本中心
+ (void)GetCostCenterDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.companyId = [NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.costCenter = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenter"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenter"]]:@"";
            data.costCenterMgrUserId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgrUserId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgrUserId"]]:@"0";
            data.costCenterMgr = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgr"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"costCenterMgr"]]:@"";
            [array addObject:data];
        }
    }
}
//解析客户
+ (void)GetClientDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.address = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"address"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"address"]]:@"";
            data.contacts = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contacts"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contacts"]]:@"";
            data.email = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]]:@"";
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"0";
            data.telephone = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"telephone"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"telephone"]]:@"";
            data.code = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"code"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"code"]]:@"";
            data.postCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"postCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"postCode"]]:@"";
            data.invCorpName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invCorpName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invCorpName"]]:@"";
            data.invTaxpayerID = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invTaxpayerID"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invTaxpayerID"]]:@"";
            data.invBankName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invBankName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invBankName"]]:@"";
            data.invBankAccount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invBankAccount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invBankAccount"]]:@"";
            data.invTelephone = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invTelephone"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invTelephone"]]:@"";
            data.invAddress = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invAddress"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invAddress"]]:@"";
            [array addObject:data];
        }
    }
}
//解析供应商
+ (void)GetSupplierDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.active = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"active"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"active"]]:@"0";
            data.companyId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]]:@"";
            data.creater = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"creater"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"creater"]]:@"";
            data.depositBank = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"depositBank"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"depositBank"]]:@"";
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"";
            data.updater = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"updater"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"updater"]]:@"";
            data.code = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"code"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"code"]]:@"";
            data.contacts = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contacts"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contacts"]]:@"";
            data.telephone = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"telephone"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"telephone"]]:@"";
            data.address = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"address"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"address"]]:@"";
            data.postCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"postCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"postCode"]]:@"";
            data.bankAccount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankAccount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankAccount"]]:@"";
            data.email = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"email"]]:@"";
            data.swiftCode = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"swiftCode"]]];
            data.vmsCode = [NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"vmsCode"]]];
            data.bankCityCode = [NSString stringIsExist:listDic[@"bankCityCode"]];
            data.bankCity = [NSString stringIsExist:listDic[@"bankCity"]];
            data.bankProvinceCode = [NSString stringIsExist:listDic[@"bankProvinceCode"]];
            data.bankProvince = [NSString stringIsExist:listDic[@"bankProvince"]];
            data.bankNo = [NSString stringIsExist:listDic[@"bankNo"]];
            data.bankCode = [NSString stringIsExist:listDic[@"bankCode"]];
            data.bankOutlets = [NSString stringIsExist:listDic[@"bankOutlets"]];
            data.cnaps = [NSString stringIsExist:listDic[@"cnaps"]];
            [array addObject:data];
        }
    }
}
//解析地区
+ (void)GetAreaDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"";
            [array addObject:data];
        }
    }
}
//办事处
+ (void)GetLocationDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"";
            [array addObject:data];
        }
    }
}
//项目类型
+ (void)GetProjTypeDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data  = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.projTyp=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"projTyp"]]]?[NSString stringWithFormat:@"%@",listDic[@"projTyp"]]:@"";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"0";
            [array addObject:data];
        }
    }
}

//公司类型
+ (void)GetBranchListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.groupId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupId"]]:@"0";
            data.no=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"no"]]]?[NSString stringWithFormat:@"%@",listDic[@"no"]]:@"";
            data.groupName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"groupName"]]:@"0";
            [array addObject:data];
        }
    }
}

//业务部门
+ (void)GetBusDeptsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.no=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"no"]]]?[NSString stringWithFormat:@"%@",listDic[@"no"]]:@"";
            data.name = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"0";
            [array addObject:data];
        }
    }
}

//借款单
+ (void)GetBorrowFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.reason=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"reason"]]]?[NSString stringWithFormat:@"%@",listDic[@"reason"]]:@"";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.advanceAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"advanceAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"advanceAmount"]]:@"0";
            data.amount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]]:@"0";
            data.originalCurrencyAmt = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"originalCurrencyAmt"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"originalCurrencyAmt"]]:@"0";
            [array addObject:data];
        }
    }
}
//出差申请单
+ (void)GetTravelFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.reason=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"reason"]]]?[NSString stringWithFormat:@"%@",listDic[@"reason"]]:@"";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.advanceAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"advanceAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"advanceAmount"]]:@"0";
            data.localCyAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]:@"0";
            data.estimatedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]:@"0";
            data.fromDate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromDate"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromDate"]]:@"";
            data.toDate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"toDate"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"toDate"]]:@"";
            data.fromDateStr = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromDateStr"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fromDateStr"]]:@"";
            data.toDateStr = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"toDateStr"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"toDateStr"]]:@"";
            data.fellowOfficersId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fellowOfficersId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fellowOfficersId"]]:@"";
            data.fellowOfficers = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fellowOfficers"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"fellowOfficers"]]:@"";
            data.travelTypeId = [NSString stringWithIdOnNO:listDic[@"travelTypeId"]];
            data.travelType = [NSString stringWithIdOnNO:listDic[@"travelType"]];
            data.relevantDeptId = [NSString stringWithIdOnNO:listDic[@"relevantDeptId"]];
            data.relevantDept = [NSString stringWithIdOnNO:listDic[@"relevantDept"]];
            data.financialSourceId = [NSString stringWithIdOnNO:listDic[@"financialSourceId"]];
            data.financialSource = [NSString stringWithIdOnNO:listDic[@"financialSource"]];
            data.fromCityCode = [NSString stringWithIdOnNO:listDic[@"fromCityCode"]];
            data.fromCity = [NSString stringWithIdOnNO:listDic[@"fromCity"]];
            data.toCityCode = [NSString stringWithIdOnNO:listDic[@"toCityCode"]];
            data.toCity = [NSString stringWithIdOnNO:listDic[@"toCity"]];
            data.requestorUserId = [NSString stringIsExist:listDic[@"requestorUserId"]];
            data.requestor = [NSString stringIsExist:listDic[@"requestor"]];
            data.requestorDept = [NSString stringIsExist:listDic[@"requestorDept"]];
            data.requestorDeptId = [NSString stringIsExist:listDic[@"requestorDeptId"]];
            [array addObject:data];
        }
    }
}
//费用申请单
+ (void)GetFeeEntertainVehicleSvcFormListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.reason=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"reason"]]]?[NSString stringWithFormat:@"%@",listDic[@"reason"]]:@"";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.estimatedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]:@"0";
            data.localCyAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]:@"0";

            [array addObject:data];
        }
    }
}

//撤销申请单
+ (void)GetFormReasonDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.taskName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"taskName"]]]?[NSString stringWithFormat:@"%@",listDic[@"taskName"]]:@"";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.flowCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowCode"]]:@"0";
            data.flowName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"flowName"]]:@"0";
            [array addObject:data];
        }
    }
}

//合同
+ (void)GetContractListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.contractName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contractName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contractName"]]:@"";
            data.contractNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contractNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"contractNo"]]:@"";
            data.amount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"amount"]]:@"";
            data.bankAccount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankAccount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankAccount"]]:@"";
            data.bankName = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankName"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"bankName"]]:@"";
            data.gridOrder = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"gridOrder"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"gridOrder"]]:@"";
            data.invoicedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invoicedAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"invoicedAmount"]]:@"";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"";
            data.paidAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paidAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paidAmount"]]:@"";
            data.partyB = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"partyB"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"partyB"]]:@"";
            data.partyBId = [NSString stringIsExist:[listDic objectForKey:@"partyBId"]];
            data.payDate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"payDate"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"payDate"]]:@"";
            data.payDateStr = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"payDateStr"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"payDateStr"]]:@"";
            data.totalAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]]:@"";
            data.unbilledAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"unbilledAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"unbilledAmount"]]:@"";
            data.effectiveDateStr = [NSString stringIsExist:listDic[@"effectiveDateStr"]];
            data.expiryDateStr = [NSString stringIsExist:listDic[@"expiryDateStr"]];
            data.payMode = [NSString stringIsExist:listDic[@"payMode"]];
            data.payCode = [NSString stringIsExist:listDic[@"payCode"]];
            data.clientName = [NSString stringIsExist:listDic[@"clientName"]];
            data.clientAddr = [NSString stringIsExist:listDic[@"clientAddr"]];
            data.ibanName = [NSString stringIsExist:listDic[@"ibanName"]];
            data.ibanAccount = [NSString stringIsExist:listDic[@"ibanAccount"]];
            data.ibanAddr = [NSString stringIsExist:listDic[@"ibanAddr"]];
            data.swiftCode = [NSString stringIsExist:listDic[@"swiftCode"]];
            data.ibanNo = [NSString stringIsExist:listDic[@"ibanNo"]];
            data.ibanADDRESS = [NSString stringIsExist:listDic[@"ibanADDRESS"]];
            data.projId = [NSString isEqualToNull:listDic[@"projId"]]?[NSString stringWithFormat:@"%@",listDic[@"projId"]]:@"0";
            data.projName = [NSString stringIsExist:listDic[@"projName"]];
            data.projMgrUserId = [NSString isEqualToNull:listDic[@"projMgrUserId"]]?[NSString stringWithFormat:@"%@",listDic[@"projMgrUserId"]]:@"0";
            data.projMgr = [NSString stringIsExist:listDic[@"projMgr"]];
            data.purchaseNumber = [NSString stringIsExist:listDic[@"purchaseNumber"]];
            data.purchaseInfo = [NSString stringIsExist:listDic[@"purchaseInfo"]];
            [array addObject:data];
        }
    }
}

//采购申请单
+ (void)GetPurchaseNumberListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"0";
            data.reason = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"reason"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"reason"]]:@"";
            data.localCyAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]:@"0";
            data.estimatedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]:@"0";
            data.totalAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"totalAmount"]]:@"0";
            data.paidAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paidAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paidAmount"]]:@"0";
            [array addObject:data];
        }
    }
}
//借款类型
+ (void)GetAdvanceTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.type=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"type"]]]?[NSString stringWithFormat:@"%@",listDic[@"type"]]:@"";
            data.typeCh = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"typeCh"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"typeCh"]]:@"0";
            data.typeEn = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"typeEn"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"typeEn"]]:@"0";            
            [array addObject:data];
        }
    }
}
//请假类型
+ (void)GetLeaveTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.leaveCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"leaveCode"]]]?[NSString stringWithFormat:@"%@",listDic[@"leaveCode"]]:@"";
            data.leaveType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveType"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveType"]]:@"";
            data.leaveTypeCh = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveTypeCh"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveTypeCh"]]:@"";
            data.leaveTypeEn = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveTypeEn"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveTypeEn"]]:@"";
            data.limitDay = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"limitDay"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"limitDay"]]:@"0";

//            data.remark = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"remark"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"remark"]]:@"";
//            data.paid = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paid"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"paid"]]:@"";
//            data.type = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]]:@"";
//            data.leaveInLieu = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveInLieu"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"leaveInLieu"]]:@"";
//            data.cycle = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"cycle"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"cycle"]]:@"";
            [array addObject:data];
        }
    }
}
//员工级别
+ (void)GetUserLevelListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.companyId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"companyId"]]]?[NSString stringWithFormat:@"%@",listDic[@"companyId"]]:@"0";
            data.Description = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"description"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"description"]]:@"";
            data.userLevelEn = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelEn"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevelEn"]]:@"";
            data.userLevel = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevel"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"userLevel"]]:@"";
            [array addObject:data];
        }
    }
}

//配置项数据
+ (void)GetConfigurationItemListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"name"]]]?[NSString stringWithFormat:@"%@",listDic[@"name"]]:@"";
            data.no = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"no"]]:@"0";
            [array addObject:data];
        }
    }
}

+ (void)GetPurchaseItemsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.purId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.purName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"name"]]]?[NSString stringWithFormat:@"%@",listDic[@"name"]]:@"";
            data.purBrand=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"brand"]]]?[NSString stringWithFormat:@"%@",listDic[@"brand"]]:@"";
            data.purCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"code"]]]?[NSString stringWithFormat:@"%@",listDic[@"code"]]:@"";
            data.purSize=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"size"]]]?[NSString stringWithFormat:@"%@",listDic[@"size"]]:@"";
            data.purUnit=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"unit"]]]?[NSString stringWithFormat:@"%@",listDic[@"unit"]]:@"";
            data.purItemCatId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"catId"]]]?[NSString stringWithFormat:@"%@",listDic[@"catId"]]:@"";
            data.purItemCatName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"cat"]]]?[NSString stringWithFormat:@"%@",listDic[@"cat"]]:@"";
            data.purTplId=@"";
            data.purTplName=@"";
            [array addObject:data];
        }
    }
    
}

+ (void)GetPurchaseTplsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.name=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"name"]]:@"";
            data.code=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"code"]]]?[NSString stringWithFormat:@"%@",listDic[@"code"]]:@"";
            data.isDefault=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"isDefault"]]]?[NSString stringWithFormat:@"%@",listDic[@"isDefault"]]:@"0";
            data.itemId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"itemId"]]]?[NSString stringWithFormat:@"%@",listDic[@"itemId"]]:@"";
            data.itemName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"itemName"]]]?[NSString stringWithFormat:@"%@",listDic[@"itemName"]]:@"";
            [array addObject:data];
        }
    }
}

+ (void)GetPurchaseItemsTplListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array WithTplModel:(ChooseCateFreModel *)tplModel{
    if ([dic[@"result"] isKindOfClass:[NSArray class]]){
        NSArray *dateArr=dic[@"result"];
        for (NSDictionary * listDic in dateArr) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.purId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.purName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"name"]]]?[NSString stringWithFormat:@"%@",listDic[@"name"]]:@"";
            data.purBrand=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"brand"]]]?[NSString stringWithFormat:@"%@",listDic[@"brand"]]:@"";
            data.purCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"code"]]]?[NSString stringWithFormat:@"%@",listDic[@"code"]]:@"";
            data.purSize=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"size"]]]?[NSString stringWithFormat:@"%@",listDic[@"size"]]:@"";
            data.purUnit=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"unit"]]]?[NSString stringWithFormat:@"%@",listDic[@"unit"]]:@"";
            data.purItemCatId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"catId"]]]?[NSString stringWithFormat:@"%@",listDic[@"catId"]]:@"";
            data.purItemCatName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"cat"]]]?[NSString stringWithFormat:@"%@",listDic[@"cat"]]:@"";
            data.purTplId=tplModel.Id;
            data.purTplName=tplModel.name;
            [array addObject:data];
        }
    }
}


+ (void)GetContractTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.catId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"catId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"catId"]]:@"1";
            data.contractTyp=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"contractTyp"]]]?[NSString stringWithFormat:@"%@",listDic[@"contractTyp"]]:@"";
            data.no=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"no"]]]?[NSString stringWithFormat:@"%@",listDic[@"no"]]:@"";
            [array addObject:data];
        }
    }
}


+ (void)GetReceiveBillListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"";
            data.reason=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"reason"]]]?[NSString stringWithFormat:@"%@",listDic[@"reason"]]:@"";
            [array addObject:data];
        }
    }
}
+ (void)GetInvoiceFormsListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"serialNo"]]:@"";
            data.reason=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"reason"]]]?[NSString stringWithFormat:@"%@",listDic[@"reason"]]:@"";
            data.clientId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"clientId"]]]?[NSString stringWithFormat:@"%@",listDic[@"clientId"]]:@"";
            data.clientName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"clientName"]]]?[NSString stringWithFormat:@"%@",listDic[@"clientName"]]:@"";
            data.bankName=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"bankName"]]]?[NSString stringWithFormat:@"%@",listDic[@"bankName"]]:@"";
            data.bankAccount=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",listDic[@"bankAccount"]]]?[NSString stringWithFormat:@"%@",listDic[@"bankAccount"]]:@"";
            [array addObject:data];
        }
    }
}

+ (void)GetPayBankNameListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.bankName=[NSString stringWithIdOnNO:listDic[@"bankName"]];
            data.bankAccount=[NSString stringWithIdOnNO:listDic[@"bankAccount"]];
            data.accountName=[NSString stringWithIdOnNO:listDic[@"accountName"]];
            [array addObject:data];
        }
    }
}

+ (void)GetStaffOutListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.taskId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo=[NSString stringWithIdOnNO:listDic[@"serialNo"]];
            data.reason=[NSString stringWithIdOnNO:listDic[@"reason"]];
            [array addObject:data];
        }
    }
}

+ (void)GetAllPayeesListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data    = [[ChooseCateFreModel alloc]init];
            data.Id=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.payee=[NSString stringWithIdOnNO:listDic[@"payee"]];
            data.bankAccount=[NSString stringWithIdOnNO:listDic[@"bankAccount"]];
            data.bankCityCode = [NSString stringIsExist:listDic[@"bankCityCode"]];
            data.bankCity = [NSString stringIsExist:listDic[@"bankCity"]];
            data.bankProvinceCode = [NSString stringIsExist:listDic[@"bankProvinceCode"]];
            data.bankProvince = [NSString stringIsExist:listDic[@"bankProvince"]];
            data.bankNo = [NSString stringIsExist:listDic[@"bankNo"]];
            data.bankCode = [NSString stringIsExist:listDic[@"bankCode"]];
            data.bankOutlets = [NSString stringIsExist:listDic[@"bankOutlets"]];
            data.cnaps = [NSString stringIsExist:listDic[@"cnaps"]];
            data.depositBank=[NSString stringWithIdOnNO:listDic[@"depositBank"]];
            data.tel=[NSString stringWithIdOnNO:listDic[@"tel"]];
            data.identityCardId = [NSString stringIsExist:listDic[@"identityCardId"]];
            data.credentialType = [NSString stringIsExist:listDic[@"credentialType"]];
            [array addObject:data];
        }
    }
}

+ (void)GetBusinessTypeListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:listDic[@"id"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.travelType = [NSString stringWithIdOnNO:listDic[@"travelType"]];
            data.no = [NSString stringWithIdOnNO:listDic[@"no"]];
            [array addObject:data];
        }
    }
}


+ (void)GetInventorysListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:listDic[@"id"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.code = [NSString stringWithIdOnNO:listDic[@"code"]];
            data.name = [NSString stringWithIdOnNO:listDic[@"name"]];
            data.pendingQty = [NSString isEqualToNull:listDic[@"pendingQty"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"pendingQty"]]:@"0";
            data.qty = [NSString isEqualToNull:listDic[@"qty"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"qty"]]:@"0";
            data.spec = [NSString isEqualToNull:listDic[@"spec"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"spec"]]:@"0";
            data.type = [NSString stringWithIdOnNO:listDic[@"type"]];
            data.unit = [NSString stringWithIdOnNO:listDic[@"unit"]];
            data.brand = [NSString stringWithIdOnNO:listDic[@"brand"]];
            data.price = [NSString stringWithIdOnNO:listDic[@"price"]];
//            "storageName" : "",
//            "storageId" : null,
//            "amount" : null,
            [array addObject:data];
        }
    }
}
+ (void)GetPaymentFormListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"taskId"]]:@"0";
            data.serialNo=[NSString stringWithIdOnNO:listDic[@"serialNo"]];
            data.reason=[NSString stringWithIdOnNO:listDic[@"reason"]];
            data.localCyAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"localCyAmount"]]:@"0";
            data.estimatedAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"estimatedAmount"]]:@"0";
            [array addObject:data];
        }
    }
}

+ (void)GetAccountItemListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.accountItemCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",[listDic objectForKey:@"accountItemCode"]]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"accountItemCode"]]:@"0";
            data.accountItem = [NSString stringWithIdOnNO:listDic[@"accountItem"]];
            [array addObject:data];
        }
    }
}

+ (void)GetInventoryStorageListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:listDic[@"id"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.code = [NSString stringWithIdOnNO:listDic[@"code"]];
            data.name = [NSString stringWithIdOnNO:listDic[@"name"]];
            data.remark = [NSString stringWithIdOnNO:listDic[@"remark"]];
            data.address = [NSString stringWithIdOnNO:listDic[@"address"]];
            data.managerId = [NSString isEqualToNull:listDic[@"managerId"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"managerId"]]:@"0";
            data.manager = [NSString stringWithIdOnNO:listDic[@"manager"]];
            [array addObject:data];
        }
    }
}


+ (void)GetProjActivityListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.Id = [NSString isEqualToNull:listDic[@"id"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id"]]:@"0";
            data.no = [NSString stringIsExist:listDic[@"no"]];
            data.name = [NSString stringIsExist:listDic[@"name"]];
            data.parentId = [NSString isEqualToNull:listDic[@"parentId"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"parentId"]]:@"0";
            data.id_Lv1 = [NSString isEqualToNull:listDic[@"id_Lv1"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"id_Lv1"]]:@"0";
            data.name_Lv1 = [NSString stringIsExist:listDic[@"name_Lv1"]];
            data.parentId_Lv1 = [NSString isEqualToNull:listDic[@"parentId_Lv1"]]?[NSString stringWithFormat:@"%@",[listDic objectForKey:@"parentId_Lv1"]]:@"0";
            [array addObject:data];
        }
    }
}

+ (void)GetClearingBankListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.clearingBankCode = [NSString stringIsExist:listDic[@"clearingBankCode"]];
            data.clearingBank = [NSString stringIsExist:listDic[@"clearingBank"]];
            [array addObject:data];
        }
    }
}
+ (void)GetBankOutletsListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.cityCode = [NSString stringIsExist:listDic[@"cityCode"]];
            data.cityName = [NSString stringIsExist:listDic[@"cityName"]];
            data.provinceCode = [NSString stringIsExist:listDic[@"provinceCode"]];
            data.provinceName = [NSString stringIsExist:listDic[@"provinceName"]];
            data.clearingBankNo = [NSString stringIsExist:listDic[@"clearingBankNo"]];
            data.clearingBankCode = [NSString stringIsExist:listDic[@"clearingBankCode"]];
            data.clearingBank = [NSString stringIsExist:listDic[@"clearingBank"]];
            data.bankNo = [NSString stringIsExist:listDic[@"bankNo"]];
            data.bankName = [NSString stringIsExist:listDic[@"bankName"]];
            [array addObject:data];
        }
    }
}

+ (void)GetRelateContAndApplyListListDictionary:(NSDictionary *)dic Array:(NSMutableArray *)array{
    NSDictionary * result = [dic objectForKey:@"result"];
    if ([result isKindOfClass:[NSNull class]]){
        return;
    }
    if ([result[@"items"] isKindOfClass:[NSArray class]]){
        for (NSDictionary * listDic in result[@"items"]) {
            ChooseCateFreModel * data = [[ChooseCateFreModel alloc]init];
            data.taskId = [NSString stringIsExist:listDic[@"taskId"]];
            data.serialNo = [NSString stringIsExist:listDic[@"serialNo"]];
            data.flowCode = [NSString stringIsExist:listDic[@"flowCode"]];
            data.contractNo = [NSString stringIsExist:listDic[@"contractNo"]];
            data.contractName = [NSString stringIsExist:listDic[@"contractName"]];
            data.totalAmount = [NSString stringIsExist:listDic[@"totalAmount"]];
            data.paidAmount = [NSString stringIsExist:listDic[@"paidAmount"]];
            data.procType = [NSString stringIsExist:listDic[@"procType"]];
            data.expenseCatCode = [NSString stringIsExist:listDic[@"expenseCatCode"]];
            data.expenseCat = [NSString stringIsExist:listDic[@"expenseCat"]];
            data.expenseCode = [NSString stringIsExist:listDic[@"expenseCode"]];
            data.expenseType = [NSString stringIsExist:listDic[@"expenseType"]];
            data.expenseIcon = [NSString stringIsExist:listDic[@"expenseIcon"]];
            data.supplierId = [NSString stringIsExist:listDic[@"supplierId"]];
            data.supplierName = [NSString stringIsExist:listDic[@"supplierName"]];
            data.bankName = [NSString stringIsExist:listDic[@"bankName"]];
            data.bankAccount = [NSString stringIsExist:listDic[@"bankAccount"]];
            [array addObject:data];
        }
    }
}

@end
