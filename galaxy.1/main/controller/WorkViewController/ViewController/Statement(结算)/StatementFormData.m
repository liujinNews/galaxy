
//
//  StatementFormData.m
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "StatementFormData.h"

@implementation StatementFormData

-(instancetype)initWithStatus:(NSInteger)status{
    self = [super initBaseWithStatus:status];
    if (self) {
        if (status==1) {
            [self initializeNewData];
        }else{
            [self initializeHasData];
        }
    }
    return self;
}

-(void)initializeNewData{
    
    self.str_flowCode = @"F0031";
    self.arr_isShowmsArray = [[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"EpcName",@"SubcontractorName",@"ContractName",@"ContractAmount",@"ProjId",@"StartDate",@"EndDate",@"AcceptanceDate",@"SettlementDate",@"DeductionAmount",@"DeductionAttachment",@"SettlementPrice",@"SettlementAttachment",@"TotalAmount",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.arr_DeduceImgArray = [NSMutableArray array];
    self.arr_DedueTolArray = [NSMutableArray array];
    self.arr_SettleImgArray = [NSMutableArray array];
    self.arr_SettleTolArray = [NSMutableArray array];

}

-(void)initializeHasData{
    
    self.str_flowCode = @"F0031";
    self.arr_DeduceImgArray = [NSMutableArray array];
    self.arr_DedueTolArray = [NSMutableArray array];
    self.arr_SettleImgArray = [NSMutableArray array];
    self.arr_SettleTolArray = [NSMutableArray array];
    
}
-(NSString *)OpenFormUrl{
    
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWSETTLEMENT];
    }else{
        return [NSString stringWithFormat:@"%@",HASSETTLEMENT];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    
                    if ([dict[@"fieldName"] isEqualToString:@"ContractName"]) {
                        self.str_ContractName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractAppNumber"]) {
                        self.str_ContractAppNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractNo"]) {
                        self.str_ContractNo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"DeductionAttachment"]) {
                        if (![dict[@"fieldValue"] isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]];
                            for (NSDictionary *dict in array) {
                                [self.arr_DedueTolArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:self.arr_DedueTolArray WithImageArray:self.arr_DeduceImgArray WithMaxCount:5];
                        }
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"SettlementAttachment"]) {
                        if (![dict[@"fieldValue"] isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]];
                            for (NSDictionary *dict in array) {
                                [self.arr_SettleTolArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:self.arr_SettleTolArray WithImageArray:self.arr_SettleImgArray WithMaxCount:5];
                        }
                    }
                }
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData = [[StatementData alloc]init];
    self.SubmitData.OperatorUserId = self.personalData.OperatorUserId;
    self.SubmitData.Operator = self.personalData.Operator;
    self.SubmitData.OperatorDeptId = self.personalData.OperatorDeptId;
    self.SubmitData.OperatorDept = self.personalData.OperatorDept;
    self.SubmitData.RequestorUserId = self.personalData.RequestorUserId;
    self.SubmitData.Requestor = self.personalData.Requestor;
    self.SubmitData.RequestorAccount = self.personalData.RequestorAccount;
    self.SubmitData.RequestorDeptId = self.personalData.RequestorDeptId;
    self.SubmitData.RequestorDept = self.personalData.RequestorDept;
    self.SubmitData.JobTitleCode = self.personalData.JobTitleCode;
    self.SubmitData.JobTitle = self.personalData.JobTitle;
    self.SubmitData.JobTitleLvl = self.personalData.JobTitleLvl;
    self.SubmitData.UserLevelId = self.personalData.UserLevelId;
    self.SubmitData.UserLevel = self.personalData.UserLevel;
    self.SubmitData.HRID = self.personalData.Hrid;
    self.SubmitData.Branch = self.personalData.Branch;
    self.SubmitData.BranchId = self.personalData.BranchId;
    self.SubmitData.CostCenterId = self.personalData.CostCenterId;
    self.SubmitData.CostCenter = self.personalData.CostCenter;
    self.SubmitData.CostCenterMgrUserId = self.personalData.CostCenterMgrUserId;
    self.SubmitData.CostCenterMgr = self.personalData.CostCenterMgr;
    self.SubmitData.RequestorBusDept = self.personalData.RequestorBusDept;
    self.SubmitData.RequestorBusDeptId = self.personalData.RequestorBusDeptId;
    self.SubmitData.AreaId = self.personalData.AreaId;
    self.SubmitData.Area = self.personalData.Area;
    self.SubmitData.LocationId = self.personalData.LocationId;
    self.SubmitData.Location = self.personalData.Location;
    self.SubmitData.UserReserved1 = self.personalData.UserReserved1;
    self.SubmitData.UserReserved2 = self.personalData.UserReserved2;
    self.SubmitData.UserReserved3 = self.personalData.UserReserved3;
    self.SubmitData.UserReserved4 = self.personalData.UserReserved4;
    self.SubmitData.UserReserved5 = self.personalData.UserReserved5;
    self.SubmitData.UserLevelNo = self.personalData.UserLevelNo;
    self.SubmitData.ApproverId1 = self.personalData.ApproverId1;
    self.SubmitData.ApproverId2 = self.personalData.ApproverId2;
    self.SubmitData.ApproverId3 = self.personalData.ApproverId3;
    self.SubmitData.ApproverId4 = self.personalData.ApproverId4;
    self.SubmitData.ApproverId5 = self.personalData.ApproverId5;
    self.SubmitData.RequestorDate=self.personalData.RequestorDate;
    
    self.SubmitData.Attachments = (self.arr_totalFileArray.count!=0)?@"1":@"";
    self.SubmitData.FirstHandlerUserId = self.str_firstHanderId;
    self.SubmitData.FirstHandlerUserName = self.str_firstHanderName;
    self.SubmitData.CompanyId = self.personalData.CompanyId;
    self.SubmitData.Reserved1 = self.model_ReserverModel.Reserverd1;
    self.SubmitData.Reserved2 = self.model_ReserverModel.Reserverd2;
    self.SubmitData.Reserved3 = self.model_ReserverModel.Reserverd3;
    self.SubmitData.Reserved4 = self.model_ReserverModel.Reserverd4;
    self.SubmitData.Reserved5 = self.model_ReserverModel.Reserverd5;
    self.SubmitData.Reserved6 = self.model_ReserverModel.Reserverd6;
    self.SubmitData.Reserved7 = self.model_ReserverModel.Reserverd7;
    self.SubmitData.Reserved8 = self.model_ReserverModel.Reserverd8;
    self.SubmitData.Reserved9 = self.model_ReserverModel.Reserverd9;
    self.SubmitData.Reserved10 = self.model_ReserverModel.Reserverd10;
    self.SubmitData.CcUsersId = self.str_CcUsersId;
    self.SubmitData.CcUsersName = self.str_CcUsersName;
    
    
    self.SubmitData.ContractName = self.str_ContractName;
    self.SubmitData.ContractNo = self.str_ContractNo;
    self.SubmitData.ContractAppNumber = self.str_ContractAppNumber;
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.DeductionAttachment = (self.arr_DedueTolArray.count != 0) ? @"1":@"";
    self.SubmitData.SettlementAttachment = (self.arr_SettleTolArray.count != 0) ? @"1":@"";
}
-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}

-(NSString *)testModel{
    StatementData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [StatementData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if ([i isEqualToString:@"1"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if (![NSString isEqualToNull:str]) {
                returnTips=[self showerror:key];
                break ;
            }
        }
    }
when_failed:
    return returnTips;
}
//MARK:显示主表必填项判断
-(NSString *)showerror:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"RequestorDeptId"]) {
        showinfo =Custing(@"请选择部门", nil) ;
    }else if([info isEqualToString:@"BranchId"]) {
        showinfo =Custing(@"请选择公司", nil) ;
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"EpcName"]) {
        showinfo =Custing(@"请输入总包单位名称", nil) ;
    }else if([info isEqualToString:@"SubcontractorName"]) {
        showinfo =Custing(@"请输入分包单位名称", nil) ;
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo =Custing(@"请选择合同审批单", nil) ;
    }else if([info isEqualToString:@"ContractAmount"]) {
        showinfo =Custing(@"请输入合同金额", nil) ;
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo =Custing(@"请选择项目名称", nil) ;
    }else if([info isEqualToString:@"StartDate"]) {
        showinfo =Custing(@"请选择开工日期", nil) ;
    }else if([info isEqualToString:@"EndDate"]) {
        showinfo =Custing(@"请选择完工日期", nil) ;
    }else if([info isEqualToString:@"AcceptanceDate"]) {
        showinfo =Custing(@"请选择验收日期", nil) ;
    }else if([info isEqualToString:@"SettlementDate"]) {
        showinfo =Custing(@"请选择结算日期", nil) ;
    }else if([info isEqualToString:@"DeductionAmount"]) {
        showinfo =Custing(@"请输入扣款金额", nil) ;
    }else if([info isEqualToString:@"DeductionAttachment"]) {
        showinfo = Custing(@"请选择扣款附件", nil);
    }else if([info isEqualToString:@"SettlementPrice"]) {
        showinfo =Custing(@"请输入结算价", nil) ;
    }else if([info isEqualToString:@"SettlementAttachment"]) {
        showinfo = Custing(@"请选择结算附件", nil);
    }else if([info isEqualToString:@"TotalAmount"]) {
        showinfo =Custing(@"请输入最终双方确认总价", nil) ;
    }else if([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if([info isEqualToString:@"Attachments"]) {
        showinfo = Custing(@"请选择附件", nil);
    }else if([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
        showinfo =[[self.dict_isCtrlTypdic objectForKey:info] isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[self.dict_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[self.dict_reservedDic objectForKey:info]];
    }else if([info isEqualToString:@"FirstHandlerUserName"]) {
        showinfo = Custing(@"请选择审批人", nil);
    }else if([info isEqualToString:@"CcUsersName"]) {
        showinfo = Custing(@"请选择抄送人", nil);
    }
    return showinfo;
}

-(void)contectData{
    
    self.dict_parametersDict = [NSDictionary dictionary];
    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_SettlementSlip = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic = [StatementData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_SettlementSlip setObject:@"Sa_SettlementSlip" forKey:@"tableName"];
    [Sa_SettlementSlip setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_SettlementSlip setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_SettlementSlip];
    
    self.dict_parametersDict = @{@"mainDataList":mainArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_SettlementSlip"];
}


@end
