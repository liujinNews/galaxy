//
//  InvoiceRegisterFormData.m
//  galaxy
//
//  Created by hfk on 2018/11/21.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "InvoiceRegisterFormData.h"

@implementation InvoiceRegisterFormData

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
    
    self.str_flowCode = @"F0030";
    self.arr_isShowmsArray = [[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ContractName",@"ProjId",@"StoreAppNumber",@"SupplierId",@"InvoiceName",@"InvoiceDate",@"InvoiceCode",@"InvoiceNo",@"InvoiceTitle",@"InvoiceAmount",@"TaxRate",@"Tax",@"SendDate",@"TrackingNo",@"ReceivedDate",@"CheckResult",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.str_InvoiceType = @"0";

}

-(void)initializeHasData{
    
    self.str_flowCode = @"F0030";
    self.str_InvoiceType = @"0";
    
}
-(NSString *)OpenFormUrl{
    
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWInvoiceReg];
    }else{
        return [NSString stringWithFormat:@"%@",HASInvoiceReg];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        //解析已登记发票信息
        if ([result[@"invoiceRegAppInfo"] isKindOfClass:[NSArray class]] && [result[@"invoiceRegAppInfo"] count] > 0) {
            self.array_invoiceRegAppInfo = [NSMutableArray arrayWithArray:result[@"invoiceRegAppInfo"]];
        }
        
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
                    if ([dict[@"fieldName"] isEqualToString:@"StoreAppInfo"]) {
                        self.str_StoreAppInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"StoreAppNumber"]) {
                        self.str_StoreAppNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvoiceType"]) {
                        if ([dict[@"isShow"] floatValue] == 1) {
                            self.str_InvoiceType = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"2"] ? @"2":@"1";
                        }else{
                            self.str_InvoiceType = @"0";
                        }
                    }
                }
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData = [[InvoiceRegisterData alloc]init];
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
    self.SubmitData.StoreAppNumber = self.str_StoreAppNumber;
    self.SubmitData.StoreAppInfo = self.str_StoreAppInfo;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    self.SubmitData.InvoiceType = self.str_InvoiceType;
}

-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}

-(NSString *)testModel{
    InvoiceRegisterData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [InvoiceRegisterData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if ([i isEqualToString:@"1"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if (![NSString isEqualToNull:str]) {
                returnTips=[self showerror:key];
                if ([NSString isEqualToNull:returnTips]) {
                    break ;
                }
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
    }else if([info isEqualToString:@"Reason"]) {
        showinfo =Custing(@"请输入登记事由", nil) ;
    }else if([info isEqualToString:@"Reason"]) {
        showinfo =Custing(@"请输入登记事由", nil) ;
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo =Custing(@"请选择合同审批单", nil) ;
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo =Custing(@"请选择项目名称", nil) ;
    }else if([info isEqualToString:@"StoreAppNumber"]) {
        showinfo =Custing(@"请选择入库单", nil) ;
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo =Custing(@"请选择供应商", nil) ;
    }else if([info isEqualToString:@"InvoiceName"]) {
        showinfo =Custing(@"请输入发票名称", nil) ;
    }else if([info isEqualToString:@"InvoiceDate"]) {
        showinfo =Custing(@"请选择发票日期", nil) ;
    }else if([info isEqualToString:@"InvoiceCode"]) {
        showinfo =Custing(@"请输入发票代码", nil) ;
    }else if([info isEqualToString:@"InvoiceNo"]) {
        showinfo =Custing(@"请输入发票号码", nil) ;
    }else if([info isEqualToString:@"InvoiceTitle"]) {
        showinfo =Custing(@"请输入发票抬头", nil) ;
    }else if([info isEqualToString:@"InvoiceAmount"]) {
        showinfo =Custing(@"请输入发票金额", nil) ;
    }else if([info isEqualToString:@"InvoiceType"]) {
        showinfo =Custing(@"请选择发票类型", nil) ;
    }else if([info isEqualToString:@"TaxRate"] && [self.str_InvoiceType isEqualToString:@"1"]) {
        showinfo =Custing(@"请选择税率", nil) ;
    }else if([info isEqualToString:@"Tax"] && [self.str_InvoiceType isEqualToString:@"1"]) {
        showinfo =Custing(@"请输入税额", nil) ;
    }else if([info isEqualToString:@"SendDate"]) {
        showinfo =Custing(@"请选择寄出时间", nil) ;
    }else if([info isEqualToString:@"TrackingNo"]) {
        showinfo =Custing(@"请输入快递单号", nil) ;
    }else if([info isEqualToString:@"ReceivedDate"]) {
        showinfo =Custing(@"请选择收到时间", nil) ;
    }else if([info isEqualToString:@"CheckResult"]) {
        showinfo =Custing(@"请输入核对结果", nil) ;
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
    NSMutableDictionary *Sa_InvoiceRegApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic = [InvoiceRegisterData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_InvoiceRegApp setObject:@"Sa_InvoiceRegApp" forKey:@"tableName"];
    [Sa_InvoiceRegApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_InvoiceRegApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_InvoiceRegApp];

    self.dict_parametersDict = @{@"mainDataList":mainArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_InvoiceRegApp"];
}


@end
