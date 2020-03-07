//
//  FeeAppFormData.m
//  galaxy
//
//  Created by hfk on 2018/1/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FeeAppFormData.h"

@implementation FeeAppFormData

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
    
    self.str_flowCode=@"F0012";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ExpenseCode",@"ExpenseDesc",@"ProjId",@"ClientId",@"SupplierId",@"EstimatedAmount",@"CurrencyCode",@"ExchangeRate",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"DetailList",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    
    self.arr_CategoryArr=[NSMutableArray array];
    self.str_ExpenseCode=@"";
    self.str_ExpenseType=@"";
    self.str_ExpenseIcon=@"";
    self.str_ExpenseCatCode=@"";
    self.str_ExpenseCat=@"";
    self.int_DetailTypeIndex=0;
    self.arr_table = [NSMutableArray array];
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0012";
    self.bool_isOpenDetail=NO;
    self.dict_budgetInfo = [NSMutableDictionary dictionary];

}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",FeeApprequestList];
    }else{
        return [NSString stringWithFormat:@"%@",HasFeeAppList];
    }
}

-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        //获取预算详情
        [self getFormBudgetInfoWithDict:result];

        if (self.int_formStatus==1) {
            //币种
            [self getCurrencyData:result];
        }
        self.bool_DetailsShow=[[NSString stringWithFormat:@"%@",result[@"feeDetail"]] isEqualToString:@"1"]?YES:NO;
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *sa_ChopAppDetailArray=formDataDict[@"sa_FeeDetail"];
            for (NSDictionary *dict in sa_ChopAppDetailArray) {
                FeeAppDeatil *model=[[FeeAppDeatil alloc]init];
                if (![dict[@"expenseCode"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseCode=[NSString stringWithFormat:@"%@",dict[@"expenseCode"]];
                }
                if (![dict[@"expenseType"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseType=[NSString stringWithFormat:@"%@",dict[@"expenseType"]];
                }
                if (![dict[@"expenseIcon"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseIcon=[NSString stringWithFormat:@"%@",dict[@"expenseIcon"]];
                }
                if (![dict[@"expenseCatCode"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseCatCode=[NSString stringWithFormat:@"%@",dict[@"expenseCatCode"]];
                }
                if (![dict[@"expenseCat"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseCat=[NSString stringWithFormat:@"%@",dict[@"expenseCat"]];
                }
                if (![dict[@"expenseDesc"] isKindOfClass:[NSNull class]]) {
                    model.ExpenseDesc=[NSString stringWithFormat:@"%@",dict[@"expenseDesc"]];
                }
                if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                    model.Amount = [NSString reviseString:dict[@"amount"]];
                }
                if (![dict[@"costType"]isKindOfClass:[NSNull class]]) {
                    model.CostType = [NSString stringWithFormat:@"%@",dict[@"costType"]];
                }
                [self.arr_DetailsDataArray addObject:model];
            }
        }
    }
}

-(void)inModelContent{
    self.SubmitData=[[FeeAppData alloc]init];
    
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

    
    
    
    self.SubmitData.BudgetInfo=@"";
    self.SubmitData.IsOverBud=@"0";

    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;

    
    self.SubmitData.CurrencyCode=self.str_CurrencyCode;
    self.SubmitData.Currency=self.str_Currency;
    self.SubmitData.ExchangeRate=self.str_ExchangeRate;

    
    self.SubmitData.ExpenseCode=self.str_ExpenseCode;
    self.SubmitData.ExpenseType=self.str_ExpenseType;
    self.SubmitData.ExpenseIcon=self.str_ExpenseIcon;
    self.SubmitData.ExpenseCatCode=self.str_ExpenseCatCode;
    self.SubmitData.ExpenseCat=self.str_ExpenseCat;
    
    //新增字段
    self.SubmitData.ApplicationType = self.str_ApplicationType;
    self.SubmitData.FeeAppNumber = self.str_FeeAppNumber;
    self.SubmitData.FeeAppInfo = self.str_FeeAppInfo;
    self.SubmitData.CapexAmount = self.str_CapexAmount;
    self.SubmitData.CostAmount = self.str_CostAmount;
    self.SubmitData.LocalCyAmount = self.str_LocalCyAmount;
    self.SubmitData.BusinessMgr = self.str_BusinessMgr;
    self.SubmitData.BusinessMgrId = self.str_BusinessMgrId;
    self.SubmitData.BusinessOwnerId = self.str_BusinessOwnerId;
    self.SubmitData.BusinessOwner = self.str_BusinessOwner;
    
    self.SubmitData.CapitalizedAmount=@"";
    self.SubmitData.IsDeptBearExps = self.str_IsDeptBearExps;
    self.SubmitData.FormScope = self.str_FormScope;

}

-(NSString *)testModel{
    FeeAppData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [FeeAppData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (FeeAppDeatil *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"ExpenseCode"]){
                            detailStr=model.ExpenseCode;
                        }else if ([str isEqualToString:@"ExpenseDesc"]){
                            detailStr=model.ExpenseDesc;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if([str isEqualToString:@"CostType"]){
                            detailStr = model.CostType;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else{
            NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
            if ([i isEqualToString:@"1"]) {
                NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
                if (![NSString isEqualToNull:str]) {
                    returnTips=[self showerror:key];
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
        showinfo = Custing(@"请输入事由", nil);
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if([info isEqualToString:@"ExpenseDesc"]) {
        showinfo = Custing(@"请输入费用描述", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"EstimatedAmount"]) {
        showinfo = Custing(@"请输入预计总金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
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
//MARK:显示明细必填项判断
-(NSString *)showerrorDetail:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseDesc"]) {
        showinfo = Custing(@"请输入费用描述", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入预计金额", nil);
    }
    return showinfo;
}

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_FeeApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[FeeAppData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_FeeApp setObject:@"Sa_FeeApp" forKey:@"tableName"];
    [Sa_FeeApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_FeeApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_FeeApp];
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_FeeDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[FeeAppDeatil initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (FeeAppDeatil *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_FeeDetail setObject:@"Sa_FeeDetail" forKey:@"tableName"];
        [Sa_FeeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_FeeDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_FeeDetail setObject:@"Sa_FeeDetail" forKey:@"tableName"];
        [Sa_FeeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_FeeDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_FeeDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}
-(void)contectHasDataWithTableName:(NSString *)tableName{
    //    NSLog(@"子类必须实现方法%s",__FUNCTION__);
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate", nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName,self.str_BudgetSubDate, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_FeeApp"];
}
-(NSString *)getCommonField{
    NSDictionary *dict=@{@"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
    return [NSString transformToJson:dict];
}
-(NSDictionary *)getCheckSubmitOtherPar{
    
    return  @{@"AdvanceTaskId":@"",@"OtherTaskId":@""};
}
@end
