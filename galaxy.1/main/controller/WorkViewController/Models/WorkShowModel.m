//
//  WorkShowModel.m
//  galaxy
//
//  Created by hfk on 16/5/24.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "WorkShowModel.h"

@implementation WorkShowModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (void)getReportFormDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)ResultArray{
    
    NSArray *array=[dic objectForKey:@"result"];
    if ([array isKindOfClass:[NSNull class]]||array == nil||array.count == 0||!array){
        return;
    }
    for (NSDictionary * listDic in array) {
        WorkShowModel *model = [[WorkShowModel alloc]init];
        model.appDesc=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"appDesc"]];
        model.appIcon=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"appIcon"]];
        model.appId=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"appId"]];
        model.appName=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"appName"]];
        model.appUrl=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"appUrl"]];
        model.companyId=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"companyId"]];
        model.type=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"type"]];
        model.webUrl=[NSString stringWithFormat:@"%@",[listDic objectForKey:@"webUrl"]];
        model.appType=4;
        [ResultArray addObject:model];
    }
}

+ (void)getWorkPartDataByDictionary:(NSDictionary *)dic Array:(NSMutableArray *)DataArray WithPartArray:(NSMutableArray *)partArray{
    
    userData *userdatas=[userData shareUserData];
    
    if (userdatas.arr_XBOpenFlowcode.count > 0) {
        NSMutableArray *array=[NSMutableArray array];
        NSArray *array1 = @[Custing(@"我的审批", nil),Custing(@"我的申请",nil)];
        NSArray *array2 = @[(userdatas.SystemType==1 && userdatas.bool_AgentHasApprove == NO) ? @"Work_AgentMyApprove":@"Work_MyApprove",@"Work_MyApply"];
        for (NSInteger i=0; i<array1.count; i++) {
            WorkShowModel *model=[[WorkShowModel alloc]init];
            model.appName=array1[i];
            model.appIcon=array2[i];
            model.appType=1;
            [array addObject:model];
        }
        [DataArray addObject:array];
    }else{
        [partArray removeObject:Custing(@"审批", nil)];
    }
    
    
    if (userdatas.arr_WorkMeumArray.count>0) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *flowKey in userdatas.arr_WorkMeumArray) {
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:flowKey];
            WorkShowModel *model = [[WorkShowModel alloc]init];
            model.appName = dict[@"Title"];
            model.appIcon = dict[@"EnterImage"];
            model.appFlowCode = dict[@"FlowCode"];
            model.appFlowGuid = flowKey;
            model.appIsNew = dict[@"IsNew"];
            model.appType=2;
            [array addObject:model];
        }
        
        NSInteger num =3*(ceilf((float)(userdatas.arr_WorkMeumArray.count)/3));
        NSInteger Dvalue=num-userdatas.arr_WorkMeumArray.count;
        for (int i=0; i<Dvalue; i++) {
            WorkShowModel *model=[[WorkShowModel alloc]init];
            model.appName = @"";
            model.appIcon = @"";
            model.appFlowCode = @"";
            model.appFlowGuid = @"";
            model.appIsNew = @"0";
            model.appType = 2;
            [array addObject:model];

        }
        [DataArray addObject:array];
    }else{
        [partArray removeObject:Custing(@"工作", nil)];
    }
    
    

    NSMutableArray *menuArray=[NSMutableArray array];
    if ([NSString isEqualToNull:userdatas.menuHide]) {
        [menuArray addObjectsFromArray:[userdatas.menuHide componentsSeparatedByString:@","]];
        for (NSInteger i=0; i<menuArray.count; i++) {
            if (![NSString isEqualToNull:menuArray[i]]) {
                [menuArray removeObjectAtIndex:i];
            }
        }
    }

    NSMutableArray *yingArray=[NSMutableArray array];
    BOOL isCashier = [userdatas.userRole containsObject:@"7"];
    
    for (NSDictionary *dict in userdatas.arr_AppMeumArray) {
        NSDictionary *appDict = [VoiceDataManger getApplicationWithInfoDict:dict];
        WorkShowModel *model = [[WorkShowModel alloc]init];
        if (userdatas.SystemType==1) {
            model.appIcon = appDict[@"AgentEnterImage"];
        }else{
            model.appIcon = appDict[@"EnterImage"];
        }
        model.appName = appDict[@"Title"];
        model.appFlowCode = appDict[@"Code"];
        model.appIsNew = appDict[@"IsNew"];
        model.appType = 3;
        if ([model.appFlowCode isEqualToString:@"Pay"]||[model.appFlowCode isEqualToString:@"CashAdvance"]) {
            if (isCashier) {
                [yingArray addObject:model];
            }
        }else{
            [yingArray addObject:model];
        }
    }

    if (![menuArray containsObject:@"4"]) {
        WorkShowModel *model = [[WorkShowModel alloc]init];
        if (userdatas.SystemType==1) {
            model.appIcon=@"Work_AgentReportForm";
        }else{
            model.appIcon=@"Work_ReportForm";
        }
        model.appName=Custing(@"报表", nil);
        model.appFlowCode=@"Report";
        model.appIsNew=@"0";
        model.appType=3;
        [yingArray addObject:model];
    }
    

    [WorkShowModel getReportFormDataByDictionary:dic Array:yingArray];
    
    NSInteger num =3*(ceilf((float)(yingArray.count)/3));
    NSInteger Dvalue=num-yingArray.count;
    for (int i=0; i<Dvalue; i++) {
        WorkShowModel *model = [[WorkShowModel alloc]init];
        model.appIcon=@"";
        model.appName=@"";
        model.appType=3;
        [yingArray addObject:model];
    }
    
    if (yingArray.count>0) {
        [DataArray addObject:yingArray];
    }else{
        [partArray removeObject:Custing(@"应用", nil)];
    }
    
}


@end

