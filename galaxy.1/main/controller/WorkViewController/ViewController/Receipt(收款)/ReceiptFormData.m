//
//  ReceiptFormData.m
//  galaxy
//
//  Created by hfk on 2018/6/3.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ReceiptFormData.h"

@implementation ReceiptFormData

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
    
    self.str_flowCode=@"F0025";
    
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"Amount",@"CurrencyCode",@"ExchangeRate",@"ReceiveDate",@"ReceiveMethod",@"ReceiveType",@"ContractName",@"ProjId",@"ContEffectiveDate",@"ExpiryDate",@"InvoiceAppNumber",@"ClientId",@"BankName",@"BankAccount",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.arr_receiveBillHistory=[NSMutableArray array];
    self.arr_payWay=[NSMutableArray array];

}
-(void)initializeHasData{
    
    self.str_flowCode=@"F0025";
    self.arr_receiveBillHistory=[NSMutableArray array];

}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWRECEIPT];
    }else{
        return [NSString stringWithFormat:@"%@",HASRECEIPT];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        //关联开票申请单状态(0审批完成 1审批中审批完成)
        self.str_InvoiceStatus = [[NSString stringWithFormat:@"%@",result[@"receiveBillInvoiceStatus"]]isEqualToString:@"1"] ? @"1":@"0";
        
        [self getFormSettingBaseData:result];
        
        //收款方式
        if ([result[@"paymentTyps"] isKindOfClass:[NSArray class]]) {
            [ChooseCategoryModel getPayWayByArray:result[@"paymentTyps"] Array:self.arr_payWay];
        }
        
        if (self.int_formStatus==1) {
            //币种
            [self getCurrencyData:result];
        }
        //解析汇款信息
        if ([result[@"receiveBillHistory"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"receiveBillHistory"]) {
                [self.arr_receiveBillHistory addObject:dict];
            }
        }
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    
                    if ([dict[@"fieldName"]isEqualToString:@"ReceiveMethodId"]) {
                        _str_PayCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    
                    if ([dict[@"fieldName"]isEqualToString:@"ReceiveTypeId"]) {
                        self.str_TypeId=[NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractName"]) {
                        self.str_ContractName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractAppNumber"]) {
                        self.str_ContractAppNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractNo"]) {
                        self.str_ContractNo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"ContAmount"]) {
                        self.str_ContAmount=[NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"ContEffectiveDate"]) {
                        self.str_ContEffectiveDate=dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"ExpiryDate"]) {
                        self.str_ContExpiryDate=dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RepaidAmount"]) {
                        self.str_RepaidAmount=[NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"UnpaidAmount"]) {
                        self.str_UnpaidAmount=[NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvoiceAppNumber"]) {
                        self.str_InvoiceAppNumber=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceAppInfo"]) {
                        self.str_InvoiceAppInfo=[NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"BankName"]) {
                        self.str_BankName=dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"BankAccount"]) {
                        self.str_BankAccount=dict[@"fieldValue"];
                    }
                }
            }
        }
    }
}
-(void)inModelContent{
    
    self.SubmitData=[[ReceiptData alloc]init];
    
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

    
    self.SubmitData.CurrencyCode=self.str_CurrencyCode;
    self.SubmitData.Currency=self.str_Currency;
    self.SubmitData.ExchangeRate=self.str_ExchangeRate;
    self.SubmitData.ReceiveType=self.str_Type;
    self.SubmitData.ReceiveTypeId=self.str_TypeId;
    self.SubmitData.ReceiveMethodId=self.str_PayCode;
    self.SubmitData.ReceiveMethod=self.str_PayMode;
    self.SubmitData.ContractAppNumber=self.str_ContractAppNumber;
    self.SubmitData.ContractNo=self.str_ContractNo;
    self.SubmitData.ContractName=self.str_ContractName;
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.ContEffectiveDate=self.str_ContEffectiveDate;
    self.SubmitData.ContExpiryDate=self.str_ContExpiryDate;
    self.SubmitData.ContAmount=self.str_ContAmount;
    self.SubmitData.RepaidAmount=self.str_RepaidAmount;
    self.SubmitData.UnpaidAmount=self.str_UnpaidAmount;
    self.SubmitData.InvoiceAppNumber=self.str_InvoiceAppNumber;
    self.SubmitData.InvoiceAppInfo=self.str_InvoiceAppInfo;
    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.BankName=self.str_BankName;
    self.SubmitData.BankAccount=self.str_BankAccount;
    
}

-(NSString *)testModel{
  
    ReceiptData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [ReceiptData initDicByModel:model];
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
//MARK:显示主表必填项判断
-(NSString *)showerror:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"RequestorDeptId"]) {
        showinfo =Custing(@"请选择部门", nil) ;
    }else if([info isEqualToString:@"BranchId"]) {
        showinfo =Custing(@"请选择公司", nil) ;
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入收款事由", nil);
    }else if([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入收款金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
    }else if([info isEqualToString:@"ReceiveDate"]) {
        showinfo = Custing(@"请选择收款日期", nil);
    }else if([info isEqualToString:@"ReceiveMethod"]) {
        showinfo = Custing(@"请选择收款方式", nil);
    }else if([info isEqualToString:@"ReceiveType"]) {
        showinfo = Custing(@"请选择类型", nil);
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo = Custing(@"请选择合同名称", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ContEffectiveDate"]) {
        showinfo = Custing(@"请选择合同开始日期", nil);
    }else if([info isEqualToString:@"ExpiryDate"]) {
        showinfo = Custing(@"请选择合同截止日期", nil);
    }else if([info isEqualToString:@"InvoiceAppNumber"]) {
        showinfo = Custing(@"请选择开票申请单", nil);
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"BankName"]) {
        showinfo = Custing(@"请输入银行名称", nil);
    }else if([info isEqualToString:@"BankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if([info isEqualToString:@"Attachments"]) {
        showinfo = Custing(@"请选择附件", nil);
    }else if([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
        showinfo =[[self.dict_isCtrlTypdic objectForKey:info] isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[self.dict_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[self.dict_reservedDic objectForKey:info]];
    }else if([info isEqualToString:@"FirstHandlerUserName"]) {
        showinfo = Custing(@"请输入审批人", nil);
    }else if([info isEqualToString:@"CcUsersName"]) {
        showinfo = Custing(@"请选择抄送人", nil);
    }
    return showinfo;
}
-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_ReceiveBill = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[ReceiptData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_ReceiveBill setObject:@"Sa_ReceiveBill" forKey:@"tableName"];
    [Sa_ReceiveBill setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_ReceiveBill setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_ReceiveBill];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_ReceiveBill"];
}

-(NSString *)getReceiveBillInfoUrl{
    return [NSString stringWithFormat:@"%@",GETRECEIVEBILLINFO];
}
-(NSDictionary *)getReceiveBillInfoParameters{
    return @{@"TaskId":self.str_ContractAppNumber,@"ContractNo":self.str_ContractNo,@"InvoiceTaskId":self.str_taskId};
}
-(void)dealWithReceiveBillInfoWithType:(NSInteger)type{
    
    [self.arr_receiveBillHistory removeAllObjects];
    if ([self.dict_resultDict[@"result"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict=self.dict_resultDict[@"result"] ;
        if ([dict[@"receiveBillHistory"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict1 in dict[@"receiveBillHistory"]) {
                [self.arr_receiveBillHistory addObject:dict1];
            }
        }
        if (type==2) {
            self.personalData.ProjId = [NSString stringWithIdOnNO:dict[@"projId"]];
            self.personalData.ProjName = [NSString stringWithIdOnNO:dict[@"projName"]];
            self.personalData.ProjMgrUserId = [NSString stringWithIdOnNO:dict[@"projMgrUserId"]];
            self.personalData.ProjMgr = [NSString stringWithIdOnNO:dict[@"projMgr"]];
            self.str_ContEffectiveDate=[NSString stringWithIdOnNO:dict[@"effectiveDate"]];
            self.str_ContExpiryDate=[NSString stringWithIdOnNO:dict[@"expiryDate"]];
            self.str_ContAmount=[NSString stringWithIdOnNO:dict[@"contractAmount"]];
            self.str_RepaidAmount=[NSString stringWithIdOnNO:dict[@"invoiceAmount"]];
            self.str_UnpaidAmount=[NSString stringWithIdOnNO:dict[@"noInvoiceAmount"]];
        }
    }
}

@end
