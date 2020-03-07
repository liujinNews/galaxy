//
//  MyAdvanceFormData.m
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MyAdvanceFormData.h"

@implementation MyAdvanceFormData

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
    
    self.str_flowCode=@"F0006";
    
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Type",@"Reason",@"LocalCyAmount",@"CurrencyCode",@"ExchangeRate",@"RepayDate",@"TravelNumber",@"FeeAppNumber",@"ProjId",@"ExpenseCode",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.str_TypeId=@"";
    self.str_Type=@"";
    self.str_LastAdvanceAmount=@"";
    
    self.arr_CategoryArr=[NSMutableArray array];
    self.str_ExpenseCode=@"";
    self.str_ExpenseType=@"";
    self.str_ExpenseIcon=@"";
    self.str_ExpenseCatCode=@"";
    self.str_ExpenseCat=@"";
    self.str_FeeAppNumber=@"";
    self.arr_payWay=[NSMutableArray array];

    self.arr_table = [NSMutableArray array];
    
}
-(void)initializeHasData{
    
    self.str_flowCode=@"F0006";
    self.dict_budgetInfo = [NSMutableDictionary dictionary];
    self.str_FeeAppNumber=@"";
    self.arr_payWay=[NSMutableArray array];

}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",AdvancerequestList];
    }else{
        return [NSString stringWithFormat:@"%@",HasAdvanceList];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        //关联出差申请单状态(0审批完成 1审批中审批完成)
        self.str_TravelStatus = [[NSString stringWithFormat:@"%@",result[@"advanceTravelStatus"]]isEqualToString:@"3"] ? @"3":@"2";
        
        //结算方式
        if ([result[@"paymentTyps"] isKindOfClass:[NSArray class]]) {
            [ChooseCategoryModel getPayWayByArray:result[@"paymentTyps"] Array:self.arr_payWay];
        }

        [self getFormSettingBaseData:result];
        
        //获取预算详情
        [self getFormBudgetInfoWithDict:result];
        
        //币种
        if (self.int_formStatus==1) {
            [self getCurrencyData:result];
        }
        
        //是否允许再次借款
        if (![result[@"canAdvance"] isKindOfClass:[NSNull class]]) {
            self.bool_canAdvance=[result[@"canAdvance"] boolValue];
        }
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:10];
                    if ([dict[@"fieldName"]isEqualToString:@"TypeId"]) {
                        self.str_TypeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelInfo"]) {
                        self.str_travelFormInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelNumber"]) {
                        self.str_travelFormId=([NSString isEqualToNullAndZero:[dict objectForKey:@"fieldValue"]])?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:self.str_travelFormId;
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FeeAppInfo"]) {
                        self.str_FeeAppInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FeeAppNumber"]) {
                        self.str_FeeAppNumber=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PmtMethodId"]) {
                        _str_PayCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PmtMethod"]) {
                        _str_PayMode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"LastAdvanceAmount"]) {
                        //上次借款金额
                        self.str_LastAdvanceAmount=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    
                }
            }
        }
    }
}
-(void)inModelContent{
    
    self.SubmitData=[[MyAdvanceData alloc]init];
    
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
    self.SubmitData.IsCostCenterMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.CostCenterMgrUserId]] ? @"1":@"0";
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
    
    
    
    self.SubmitData.TypeId=self.str_TypeId;
    self.SubmitData.Type=self.str_Type;
    
    self.SubmitData.TravelNumber=self.str_travelFormId;
    self.SubmitData.TravelInfo=self.str_travelFormInfo;

    self.SubmitData.FeeAppNumber=self.str_FeeAppNumber;
    self.SubmitData.FeeAppInfo=self.str_FeeAppInfo;

    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";


    self.SubmitData.ExpenseCode=self.str_ExpenseCode;
    self.SubmitData.ExpenseType=self.str_ExpenseType;
    self.SubmitData.ExpenseIcon=self.str_ExpenseIcon;
    self.SubmitData.ExpenseCatCode=self.str_ExpenseCatCode;
    self.SubmitData.ExpenseCat=self.str_ExpenseCat;
    
    self.SubmitData.BudgetInfo=@"";
    self.SubmitData.IsOverBud=@"0";

    self.SubmitData.LastAdvanceAmount=[NSString isEqualToNull:self.str_LastAdvanceAmount]?self.str_LastAdvanceAmount:@"0";
    self.SubmitData.CurrencyCode=self.str_CurrencyCode;
    self.SubmitData.Currency=self.str_Currency;
    self.SubmitData.ExchangeRate=self.str_ExchangeRate;
    self.SubmitData.IsDeptBearExps = self.str_IsDeptBearExps;
}

-(NSString *)testModel{
    if (self.bool_canAdvance) {
        return Custing(@"请还清借款后,然后在申请借款", nil);
    }
    MyAdvanceData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [MyAdvanceData initDicByModel:model];
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
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"Type"]) {
        showinfo = Custing(@"请选择借款类型", nil);
    }else if([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入借款事由", nil);
    }else if([info isEqualToString:@"LocalCyAmount"]) {
        showinfo = Custing(@"请输入借款金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
    }else if([info isEqualToString:@"RepayDate"]) {
        showinfo = Custing(@"请选择还款日期", nil);
    }else if([info isEqualToString:@"TravelNumber"]) {
        showinfo =Custing( @"请选择出差申请单", nil);
    }else if([info isEqualToString:@"FeeAppNumber"]) {
        showinfo = Custing(@"请选择费用申请单", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
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
    NSMutableDictionary *Sa_ExpAdvance = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[MyAdvanceData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_ExpAdvance setObject:@"Sa_ExpAdvance" forKey:@"tableName"];
    [Sa_ExpAdvance setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_ExpAdvance setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_ExpAdvance];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(NSString *)testApporveEditModel{
    if (self.int_comeEditType == 1) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"fieldName MATCHES %@ && isShow = 1 && isRequired = 1", @"PmtMethod"];
        NSArray *filterArray = [self.arr_FormMainArray filteredArrayUsingPredicate:pred];
        if (filterArray.count > 0 && ![NSString isEqualToNull:self.str_PayCode]) {
            MyProcurementModel *model = filterArray[0];
            return model.tips;
        }
    }
    return nil;
}
-(void)contectHasDataWithTableName:(NSString *)tableName{

    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate",@"PmtMethodId",@"PmtMethod", nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName,self.str_BudgetSubDate, self.str_PayCode,self.str_PayMode, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}
-(void)contectHasPayDataWithTableName:(NSString *)tableName{

    NSArray *travelFieldName=[NSArray arrayWithObjects:@"twohandleruserid",@"twohandlerusername",@"BudgetSubDate",@"PmtMethodId",@"PmtMethod", nil];
    NSArray *travelfieldValues=[NSArray arrayWithObjects:@"",@"",self.str_BudgetSubDate, self.str_PayCode,self.str_PayMode, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
    
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_ExpAdvance"];
}
-(NSString *)getCommonField{
    NSDictionary *dict=@{@"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
    return [NSString transformToJson:dict];
}
-(NSDictionary *)getCheckSubmitOtherPar{
    
    NSString *OtherFlowCode;
    NSString *OtherTaskId;
    if ([self.str_FeeAppNumber floatValue]>0) {
        OtherFlowCode=@"F0012";
        OtherTaskId=self.str_FeeAppNumber;
    }else if ([self.str_travelFormId floatValue]>0){
        OtherFlowCode=@"F0001";
        OtherTaskId=self.str_travelFormId;
    }
    return  @{@"AdvanceTaskId":@"",@"OtherTaskId":OtherTaskId,@"OtherFlowCode":OtherFlowCode};
}
@end
