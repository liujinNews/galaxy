
//
//  InvoiceAppFormData.m
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "InvoiceAppFormData.h"

@implementation InvoiceAppFormData

-(NSMutableArray *)arr_InvoiceType{
    if (_arr_InvoiceType == nil) {
        _arr_InvoiceType = [NSMutableArray array];
        NSArray *type = @[Custing(@"增值税普通发票", nil),Custing(@"增值税专用发票", nil)];
        NSArray *code = @[@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_InvoiceType addObject:model];
        }
    }
    return _arr_InvoiceType;
}
-(NSMutableArray *)arr_IsPayBack{
    if (_arr_IsPayBack == nil) {
        _arr_IsPayBack = [NSMutableArray array];
        NSArray *type = @[Custing(@"已回款", nil),Custing(@"未回款", nil)];
        NSArray *code = @[@"1",@"2"];
        for (int i=0; i < type.count; i++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_IsPayBack addObject:model];
        }
    }
    return _arr_IsPayBack;
}

-(instancetype)initWithStatus:(NSInteger)status{
    self = [super initBaseWithStatus:status];
    if (self) {
        if (status == 1) {
            [self initializeNewData];
        }else{
            [self initializeHasData];
        }
    }
    return self;
}

-(void)initializeNewData{

    self.str_flowCode = @"F0019";
    self.arr_isShowmsArray = [[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"InvContent",@"InvAmount",@"InvType",@"TaxRate",@"InvFromDate",@"InvExpectedDate",@"PlanPaymentDate",@"ContractName",@"ProjId",@"ReceiveBillNumber",@"ClientId",@"TaxNumber",@"BankName",@"BankAccount",@"Address",@"Tel",@"ReceiverName",@"ReceiverTel",@"ReceiverAddress",@"ReceiverPostCode",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.str_InvoiceType = @"0";
    self.arr_InvFilesImgArray = [NSMutableArray array];
    self.arr_InvFilesTolArray = [NSMutableArray array];
}

-(void)initializeHasData{
    self.str_flowCode = @"F0019";
    self.str_InvoiceType = @"0";
    self.arr_InvFilesImgArray = [NSMutableArray array];
    self.arr_InvFilesTolArray = [NSMutableArray array];
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWINVOICEAPPDATA];
    }else{
        return [NSString stringWithFormat:@"%@",HASINVOICEAPPDATA];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result = [self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];

        //关联收款单单状态(0审批完成 1审批中审批完成)
        self.str_ReceiveBillStatus = [[NSString stringWithFormat:@"%@",result[@"invoiceReceiveBillStatus"]]isEqualToString:@"1"] ? @"1":@"0";
        //是否可以填写回款信息
        if (self.int_comeStatus == 3) {
            self.bool_isMgr = [[NSString stringWithFormat:@"%@",result[@"isMgr"]]isEqualToString:@"1"] ? YES:NO;
        }
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    
                    if ([dict[@"fieldName"]isEqualToString:@"InvType"]) {
                        if ([dict[@"isShow"] floatValue] == 1) {
                            self.str_InvoiceType = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"1"] ? @"1":@"2";
                        }else{
                            self.str_InvoiceType = @"0";
                        }
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvFromDate"]) {
                        self.str_InvFromDate = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvToDate"]) {
                        self.str_InvToDate = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractAppNumber"]) {
                        self.str_ContractAppNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractName"]) {
                        self.str_ContractName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractNo"]) {
                        self.str_ContractNo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ReceiveBillNumber"]) {
                        self.str_ReceiveBillNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ReceiveBillInfo"]) {
                        self.str_ReceiveBillInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"Payback"]) {
                        self.str_IsPayBack = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvFiles"]) {
                        if (![dict[@"fieldValue"] isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]];
                            for (NSDictionary *dict in array) {
                                [self.arr_InvFilesTolArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:self.arr_InvFilesTolArray WithImageArray:self.arr_InvFilesImgArray WithMaxCount:5];
                        }
                    }
                }
            }
        }
    }
}

-(NSString *)getInvoiceHistoryUrl{
    return [NSString stringWithFormat:@"%@",GETINVOICEHISTORY];

}
-(NSDictionary *)getInvoiceHistoryParameter{
    return @{@"TaskId": self.str_ContractAppNumber,@"InvoiceTaskId":self.str_taskId,@"ContractNo":self.str_ContractNo};
}

-(void)inModelContent{

    self.SubmitData = [[InvoiceAppData alloc]init];
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

    
    self.SubmitData.InvType = self.str_InvoiceType;
    self.SubmitData.InvFromDate = self.str_InvFromDate;
    self.SubmitData.InvToDate = self.str_InvToDate;
    self.SubmitData.ContractNo = self.str_ContractNo;
    self.SubmitData.ContractAppNumber = self.str_ContractAppNumber;
    self.SubmitData.ContractName = self.str_ContractName;
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.ReceiveBillNumber = self.str_ReceiveBillNumber;
    self.SubmitData.ReceiveBillInfo = self.str_ReceiveBillInfo;
    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;

}

-(NSString *)testModel{
    
    InvoiceAppData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [InvoiceAppData initDicByModel:model];
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
    return returnTips;
}

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
        showinfo =Custing(@"请输入开票事由", nil) ;
    }else if([info isEqualToString:@"InvContent"]) {
        showinfo =Custing(@"请输入开票内容", nil) ;
    }else if([info isEqualToString:@"InvAmount"]) {
        showinfo =Custing(@"请输入开票金额", nil) ;
    }else if([info isEqualToString:@"InvType"]) {
        showinfo = Custing(@"请选择发票类型", nil);
    }else if([info isEqualToString:@"TaxRate"]) {
        showinfo = Custing(@"请选择税率", nil);
    }else if([info isEqualToString:@"InvFromDate"]) {
        showinfo = Custing(@"请选择开票周期", nil);
    }else if([info isEqualToString:@"InvExpectedDate"]) {
        showinfo = Custing(@"请选择期望开票日期", nil);
    }else if([info isEqualToString:@"PlanPaymentDate"]) {
        showinfo = Custing(@"请选择预计付款日期", nil);
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo = Custing(@"请选择合同名称", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ReceiveBillNumber"]) {
        showinfo = Custing(@"请选择收款单", nil);
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"TaxNumber"]) {
        showinfo = Custing(@"请输入税号", nil);
    }else if([info isEqualToString:@"BankName"]) {
        showinfo = Custing(@"请输入开户银行", nil);
    }else if([info isEqualToString:@"BankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"Address"]) {
        showinfo = Custing(@"请输入地址", nil);
    }else if([info isEqualToString:@"Tel"]) {
        showinfo = Custing(@"请输入电话", nil);
    }else if([info isEqualToString:@"ReceiverName"]) {
        showinfo = Custing(@"请输入收件人姓名", nil);
    }else if([info isEqualToString:@"ReceiverTel"]) {
        showinfo = Custing(@"请输入电话号码", nil);
    }else if([info isEqualToString:@"ReceiverAddress"]) {
        showinfo = Custing(@"请输入地址", nil);
    }else if([info isEqualToString:@"ReceiverPostCode"]) {
        showinfo = Custing(@"请输入邮编", nil);
    }else if([info isEqualToString:@"Remark"]) {
        showinfo =Custing(@"请输入备注", nil) ;
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
    NSMutableArray *mainArray = [NSMutableArray array];
    NSMutableDictionary *Sa_InvoiceApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [NSMutableArray array];
    NSMutableArray *fieldValuesArr = [NSMutableArray array];
    NSMutableDictionary *modelDic = [InvoiceAppData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_InvoiceApp setObject:@"Sa_InvoiceApp" forKey:@"tableName"];
    [Sa_InvoiceApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_InvoiceApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_InvoiceApp];
    self.dict_parametersDict = @{@"mainDataList":mainArray};
}
-(void)contectHasDataWithTableName:(NSString *)tableName{
    NSMutableArray *FieldName = [NSMutableArray arrayWithArray:@[@"FirstHandlerUserId",@"FirstHandlerUserName"]];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSMutableArray *FieldValues = [NSMutableArray arrayWithArray:@[self.str_twoHandeId,self.str_twoApprovalName]];
    if (self.bool_isMgr && self.dict_PayBack) {
        [FieldName addObjectsFromArray:@[@"Payback",@"PaybackAccount",@"InvNumber",@"InvDate",@"InvFiles"]];
        [FieldValues addObjectsFromArray:@[self.dict_PayBack[@"Payback"],self.dict_PayBack[@"PaybackAccount"],self.dict_PayBack[@"InvNumber"],self.dict_PayBack[@"InvDate"],self.dict_PayBack[@"InvFiles"]]];
    }
    NSDictionary *travelDict = @{@"fieldNames":FieldName,@"fieldValues":FieldValues,@"tableName":tableName};
    NSArray *mainArray = [NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict = @{@"mainDataList":mainArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_InvoiceApp"];
}

@end
