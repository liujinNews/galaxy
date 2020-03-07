//
//  travelReimFormDate.m
//  galaxy
//
//  Created by hfk on 2018/1/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "travelReimFormDate.h"

@implementation travelReimFormDate
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
    
    self.str_flowCode=@"F0002";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"ThirDetailList",@"ClaimType",@"Reason",@"Contact",@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"BnfId",@"ProjId",@"ClientId",@"SupplierId",@"TravelNumber",@"TravelType",@"RelevantDept",@"FinancialSource",@"FromDate",@"FellowOfficers",@"OverBudReason",@"StaffOutNumber",@"VehicleNumber",@"AdvanceNumber",@"NoInvAmount",@"CurrencyCode",@"NumberOfDocuments",@"Payee",@"BankAccount",@"BankOutlets",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    
    //    self.str_ClaimTypeId=@"";
    //    self.str_ClaimType=@"";
    self.bool_isOpenDetail=NO;
    
    //    self.str_travelFormId=@"";
    //    self.str_travelFormInfo=@"";
    //    self.str_travelFormMoney=@"0";
    //    self.str_EstimatedAmount=@"0";
    
    
    //    self.str_AdvanceInfo=@"";
    //    self.str_AdvanceId=@"";
    //    self.str_AdvanceMoney=@"0";
    
    self.bool_ShareShow=NO;
    self.arr_ShareForm=[NSMutableArray array];
    self.arr_ShareData=[NSMutableArray array];
    self.arr_sonItem=[NSMutableArray array];
    
    self.str_LoanTotalAmount = @"0";
    self.str_InvLoanAmount = @"0";
    
    
    //    self.str_overlimit = @"0";
    
    self.bool_NeedCostDate=NO;
    //    self.str_travel_FromDate=@"";
    //    self.str_travel_ToDate=@"";
    self.dict_ClaimAttRule=[NSMutableDictionary dictionary];
    self.arr_ClaimType=[NSMutableArray array];
    self.arr_payWay=[NSMutableArray array];
    self.arr_table = [NSMutableArray array];
    self.str_ReversalType = @"0";
    
}
-(void)initializeHasData{
    self.str_flowCode = @"F0002";
    self.bool_isOpenDetail = NO;
    self.bool_SecisOpenDetail = NO;
    self.bool_ThirisOpenDetail = NO;
    self.arr_sonItem = [NSMutableArray array];
    self.arr_itemShow = [NSMutableArray array];
    self.arr_itemShowDes = [NSMutableArray array];
    self.arr_CurrencySum = [NSMutableArray array];
    self.arr_travelSum = [NSMutableArray array];
    self.dict_budgetInfo = [NSMutableDictionary dictionary];
    self.arr_ShareForm = [NSMutableArray array];
    self.arr_ShareData = [NSMutableArray array];
    self.arr_ShareDeptSumData = [NSMutableArray array];
    self.arr_payWay = [NSMutableArray array];
    self.bool_ShareShow = NO;
    self.bool_needSure = NO;
    self.str_ReceiptOfInv = @"1";
    self.arr_ApprovBefoEditExpense = [NSMutableArray array];
    self.str_ReversalType = @"0";
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",travelReimrequestList];
    }else{
        return [NSString stringWithFormat:@"%@",travelHasrequestList];
    }
}
-(NSDictionary *)OpenFormParameters{
    return @{@"TaskId":self.str_taskId,@"UserId":self.str_userId,@"ProcId":self.str_procId,@"ProcId":self.str_procId,@"FlowGuid":self.str_flowGuid};
}

-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_SecDetailsShow=[[NSString stringWithFormat:@"%@",result[@"expenseSettle"]] isEqualToString:@"1"]?YES:NO;
        self.bool_ThirDetailsShow=[[NSString stringWithFormat:@"%@",result[@"travelExpensePayeeDetail"]] isEqualToString:@"1"]?YES:NO;
        
        
        self.int_travelTimeParams =[[NSString stringWithFormat:@"%@",result[@"travelTimeParams"]]isEqualToString:@"1"]?1:0;
        
        //结算方式
        if ([result[@"paymentTyps"] isKindOfClass:[NSArray class]]) {
            [ChooseCategoryModel getPayWayByArray:result[@"paymentTyps"] Array:self.arr_payWay];
        }
        
        //币种
        [self getCurrencyData:result];
        self.str_CurrencyCode = @"";
        self.str_ExchangeRate = @"";
        self.str_Currency = @"";
        
        //获取预算详情
        [self getFormBudgetInfoWithDict:result];
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            
            [self getSecGroupDetail:formDict WithTableName:@"expenseSettleFields"];
            [self getThirGroupDetail:formDict WithTableName:@"travelExpensePayeeDetailFields"];
            
            if (self.int_comeStatus==1) {
                //解析记一笔中附件是否显示
                [self getAddFilesShowWithDict:formDict];
            }
            
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:10];
                    
                    if ([dict[@"fieldName"] isEqualToString:@"TravelInfo"]) {
                        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]) {
                            self.str_travelFormInfo = dict[@"fieldValue"];
                        }else{
                            self.str_travelFormInfo=@"";
                            self.str_travelFormId=@"";
                        }
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelNumber"]) {
                        self.str_travelFormId=([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]&&![[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"0"])?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:self.str_travelFormId;
                        
                        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"isShow"]]isEqualToString:@"1"]) {
                            self.bool_TravelShow=YES;
                        }
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelTypeId"]) {
                        self.str_travelTypeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelevantDeptId"]) {
                        self.str_relevantDeptId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FinancialSourceId"]) {
                        self.str_financialSourceId = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BnfName"]) {
                        self.str_Beneficiaries=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"LoanAmount"]) {
                        self.str_LoanTotalAmount =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvLoanAmount"]) {
                        self.str_InvLoanAmount =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"AdvanceNumber"]) {
                        self.str_AdvanceId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"";
                        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"isShow"]]isEqualToString:@"1"]) {
                            self.bool_AdvanceShow=YES;
                        }
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"AdvanceInfo"]) {
                        self.str_AdvanceInfo=[dict objectForKey:@"fieldValue"];
                    }
                    
                    if ([dict[@"fieldName"] isEqualToString:@"StaffOutNumber"]) {
                        self.str_StaffOutNumber=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"StaffOutInfo"]) {
                        self.str_StaffOutInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"VehicleNumber"]) {
                        self.str_VehicleNumber=[NSString stringWithIdOnNO:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"VehicleInfo"]) {
                        self.str_VehicleInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ClaimTypeId"]) {
                        self.str_ClaimTypeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PmtMethodId"]) {
                        _str_PayCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PmtMethod"]) {
                        _str_PayMode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ShareDeptIds"]) {
                        self.str_ShareDeptIds=[NSString isEqualToNull:[dict objectForKey:@"fieldValue"]]?[dict objectForKey:@"fieldValue"]:@"";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FromDate"]) {
                        self.str_FromDate=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ToDate"]) {
                        self.str_ToDate=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FromCity"]) {
                        self.str_FromCity=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FromCityCode"]) {
                        self.str_FromCityCode=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ToCity"]) {
                        self.str_ToCity=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ToCityCode"]) {
                        self.str_ToCityCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ReversalType"]) {
                        self.str_ReversalType = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FellowOfficersId"]) {
                        self.str_FellowOfficersId=[NSString isEqualToNull:[dict objectForKey:@"fieldValue"]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankOutlets"]) {
                        self.str_BankOutlets = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"Payee"]) {
                        self.str_Payee = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankAccount"]) {
                        self.str_BankAccount = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankName"]) {
                        self.str_BankName = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankNo"]) {
                        self.str_BankNo = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankCode"]) {
                        self.str_BankCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"CNAPS"]) {
                        self.str_CNAPS = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankProvinceCode"]) {
                        self.str_BankProvinceCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankProvince"]) {
                        self.str_BankProvince = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankCityCode"]) {
                        self.str_BankCityCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankCity"]) {
                        self.str_BankCity = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"CredentialType"]) {
                        self.str_CredentialType = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"IdentityCardId"]) {
                        self.str_IdentityCardId = [dict objectForKey:@"fieldValue"];
                    }
                }
            }
        }
        
        //分摊表单规则消费记录等数据
        if (self.int_formStatus ==1) {
            [self getTravel_Daily_OtherReimData:result WithParameter:nil WithType:1];
            if (![result[@"formRule"]isKindOfClass:[NSNull class]]) {
                self.str_TravelStatus = ![result[@"formRule"][@"travelStatus"] isKindOfClass:[NSNull class]] ? [NSString stringWithFormat:@"%@",result[@"formRule"][@"travelStatus"]]:@"0";
            }
        }else{
            [self getTravel_Daily_OtherHasReimData:result WithParameter:@{@"expensedetail":@"sa_travelexpensedetail",@"expenseSummary":@"sa_travelexpenseSummary",@"expenseSettle":@"sa_TravelExpenseSettle"} WithType:1];
        }
        //分摊数据
        [self getExpenseShareDataWithData:result WithParameter:@{@"ExpenseShare":@"sa_TravelExpenseShare"}];
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if ([formDataDict isKindOfClass:[NSDictionary class]]) {
            if ([formDataDict[@"travelExpensePayeeDetailData"]isKindOfClass:[NSDictionary class]]) {
                if ([formDataDict[@"travelExpensePayeeDetailData"][@"sa_TravelExpensePayeeDetail"]isKindOfClass:[NSArray class]]) {
                    NSArray *array = formDataDict[@"travelExpensePayeeDetailData"][@"sa_TravelExpensePayeeDetail"];
                    for (NSDictionary *dict in array) {
                        PayeeDetails *model=[[PayeeDetails alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                            model.Amount = [NSString reviseString:dict[@"amount"]];
                        }
                        [self.arr_ThirDetailsDataArray addObject:model];
                    }
                }
            }
        }
        
    }
    [self dealAdvanceAndTravelMoney];
}

-(void)dealAdvanceAndTravelMoney{
    if (self.bool_TravelShow&&!self.bool_AdvanceShow) {
        self.str_travelFormMoney = self.str_LoanTotalAmount;
        self.str_InvtravelFormMoney = self.str_InvLoanAmount;
    }else if (!self.bool_TravelShow&&self.bool_AdvanceShow){
        self.str_AdvanceMoney = self.str_LoanTotalAmount;
        self.str_InvAdvanceMoney = self.str_InvLoanAmount;
    }else if (self.bool_TravelShow&&self.bool_AdvanceShow){
        self.str_AdvanceMoney=self.str_LoanTotalAmount;
        self.str_InvAdvanceMoney = self.str_InvLoanAmount;
    }
}
//MARK:处理借款单或出差申请单数据
-(void)dealWithAdvanceOrTravelFormMoney{
    self.str_LoanTotalAmount = @"0";
    self.str_InvLoanAmount = @"0";
    if (self.bool_TravelShow&&!self.bool_AdvanceShow) {
        self.str_LoanTotalAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.str_travelFormMoney]]?[NSString stringWithFormat:@"%@",self.str_travelFormMoney]:@"0";
        self.str_InvLoanAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.str_InvtravelFormMoney]]?[NSString stringWithFormat:@"%@",self.str_InvtravelFormMoney]:@"0";
        
    }else if (!self.bool_TravelShow&&self.bool_AdvanceShow){
        self.str_LoanTotalAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.str_AdvanceMoney]]?[NSString stringWithFormat:@"%@",self.str_AdvanceMoney]:@"0";
        self.str_InvLoanAmount = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",self.str_InvAdvanceMoney]]?[NSString stringWithFormat:@"%@",self.str_InvAdvanceMoney]:@"0";
        
    }else if (self.bool_TravelShow&&self.bool_AdvanceShow){
        self.str_LoanTotalAmount = [NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",self.str_AdvanceMoney]]?[NSString stringWithFormat:@"%@",self.str_AdvanceMoney]:([NSString stringWithFormat:@"%@",self.str_travelFormMoney]?[NSString stringWithFormat:@"%@",self.str_travelFormMoney]:@"0");
        self.str_InvLoanAmount = [NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",self.str_InvAdvanceMoney]]?[NSString stringWithFormat:@"%@",self.str_InvAdvanceMoney]:([NSString stringWithFormat:@"%@",self.str_InvtravelFormMoney]?[NSString stringWithFormat:@"%@",self.str_InvtravelFormMoney]:@"0");
        
    }
}

-(void)inModelContent{
    
    self.SubmitData=[[travelReimData alloc]init];
    
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
    
    
    self.SubmitData.Contact=self.personalData.Contact;
    self.SubmitData.CurrencyCode = self.str_CurrencyCode;
    self.SubmitData.Currency = self.str_Currency;
    self.SubmitData.BudgetInfo=@"";
    self.SubmitData.Projbudinfo =@"";
    self.SubmitData.IsOverBud=@"0";
    self.SubmitData.IsOverStd=@"0";
    self.SubmitData.EstimatedAmount=[NSString isEqualToNull:self.str_EstimatedAmount] ?[self.str_EstimatedAmount stringByReplacingOccurrencesOfString:@"," withString:@""]:@"";
    
    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";
    
    self.SubmitData.BnfId=self.str_BeneficiariesId;
    self.SubmitData.BnfName=self.str_Beneficiaries;
    
    self.SubmitData.Projbuddata = self.str_projbuddata;
    self.SubmitData.Overlimit = self.str_overlimit;
    self.SubmitData.TravelInfo=self.str_travelFormInfo;
    self.SubmitData.TravelNumber=self.str_travelFormId;
    
    self.SubmitData.FromCityCode=self.str_FromCityCode;
    self.SubmitData.FromCity=self.str_FromCity;
    self.SubmitData.ToCityCode=self.str_ToCityCode;
    self.SubmitData.ToCity=self.str_ToCity;
    
    self.SubmitData.TravelTypeId=self.str_travelTypeId;
    self.SubmitData.TravelType=self.str_travelType;
    self.SubmitData.RelevantDeptId=self.str_relevantDeptId;
    self.SubmitData.RelevantDept=self.str_relevantDept;
    self.SubmitData.FinancialSourceId = self.str_financialSourceId;
    self.SubmitData.FinancialSource = self.str_financialSource;
    self.SubmitData.ClaimType =self.str_ClaimType;
    self.SubmitData.ClaimTypeId=self.str_ClaimTypeId;
    self.SubmitData.StaffOutInfo=self.str_StaffOutInfo;
    self.SubmitData.StaffOutNumber = self.str_StaffOutNumber;
    self.SubmitData.VehicleNumber = self.str_VehicleNumber;
    self.SubmitData.VehicleInfo = self.str_VehicleInfo;
    self.SubmitData.AdvanceInfo = self.str_AdvanceInfo;
    self.SubmitData.AdvanceNumber = self.str_AdvanceId;
    
    self.SubmitData.FromDate = self.str_FromDate;
    self.SubmitData.ToDate = self.str_ToDate;
    self.SubmitData.FellowOfficersId = self.str_FellowOfficersId;
    self.SubmitData.FellowOfficers = self.str_FellowOfficers;
    self.SubmitData.IsExpExpired = @"0";
    self.SubmitData.IsOverStd2 = @"0";
    self.SubmitData.IsDeptBearExps = self.str_IsDeptBearExps;
    
    self.SubmitData.ReversalType = self.str_ReversalType;
    
    
    self.SubmitData.Payee = self.str_Payee;
    self.SubmitData.BankAccount = self.str_BankAccount;
    self.SubmitData.BankName = self.str_BankName;
    self.SubmitData.BankOutlets = self.str_BankOutlets;
    self.SubmitData.BankNo = self.str_BankNo;
    self.SubmitData.BankCode = self.str_BankCode;
    self.SubmitData.BankProvinceCode = self.str_BankProvinceCode;
    self.SubmitData.BankProvince = self.str_BankProvince;
    self.SubmitData.BankCityCode = self.str_BankCityCode;
    self.SubmitData.BankCity = self.str_BankCity;
    self.SubmitData.CNAPS = self.str_CNAPS;
    self.SubmitData.CredentialType = self.str_CredentialType;
    self.SubmitData.IdentityCardId = self.str_IdentityCardId;
    
    
    self.SubmitData.CostShareApproval1 = (id)[NSNull null];
    self.SubmitData.CostShareApproval2 = (id)[NSNull null];
    self.SubmitData.CostShareApproval3 = (id)[NSNull null];
    
    self.SubmitData.SubstituteInvoice = @"0";
    
    //分摊部门数据处理
    self.arr_ShareProjId = [NSMutableArray array];
    self.arr_ShareProjMgrId = [NSMutableArray array];
    self.arr_ShareDeptId = [NSMutableArray array];
    self.arr_SubmitExpenseCodes = [NSMutableArray array];
    self.arr_SubmitExpenseTypes = [NSMutableArray array];
    if ([NSString isEqualToNullAndZero:self.personalData.ProjId] && ![self.arr_ShareProjId containsObject:[NSString stringWithFormat:@"%@",self.personalData.ProjId]]) {
        [self.arr_ShareProjId addObject:[NSString stringWithFormat:@"%@",self.personalData.ProjId]];
    }
    if ([NSString isEqualToNullAndZero:self.personalData.ProjMgrUserId] && ![self.arr_ShareProjMgrId containsObject:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]]) {
        [self.arr_ShareProjMgrId addObject:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]];
    }
    for (ReimShareModel *model in self.arr_ShareData) {
        if ([NSString isEqualToNullAndZero:model.ProjId] && ![self.arr_ShareProjId containsObject:[NSString stringWithFormat:@"%@",model.ProjId]]) {
            [self.arr_ShareProjId addObject:[NSString stringWithFormat:@"%@",model.ProjId]];
        }
        if ([NSString isEqualToNullAndZero:model.ProjMgrUserId] && ![self.arr_ShareProjMgrId containsObject:model.ProjMgrUserId]) {
            [self.arr_ShareProjMgrId addObject:[NSString stringWithFormat:@"%@",model.ProjMgrUserId]];
        }
        if ([NSString isEqualToNullAndZero:model.RequestorDeptId] && ![[NSString stringWithFormat:@"%@",model.RequestorDeptId] isEqualToString:self.personalData.RequestorDeptId] && ![self.arr_ShareDeptId containsObject:[NSString stringWithFormat:@"%@",model.RequestorDeptId]] ) {
            [self.arr_ShareDeptId addObject:[NSString stringWithFormat:@"%@",model.RequestorDeptId]];
        }
    }
    self.SubmitData.LoanAmount = [NSString isEqualToNull:self.str_LoanTotalAmount]?[self.str_LoanTotalAmount stringByReplacingOccurrencesOfString:@"," withString:@""]:(id)[NSNull null];
    
    self.SubmitData.InvLoanAmount = [NSString isEqualToNull:self.str_InvLoanAmount]?[self.str_InvLoanAmount stringByReplacingOccurrencesOfString:@"," withString:@""]:(id)[NSNull null];
    
}

-(NSString *)dealWithAcutual{
    NSString *str;
    if ([[GPUtils decimalNumberSubWithString:self.str_amountPrivate with:self.str_LoanTotalAmount]floatValue]<0) {
        str = @"0.00";
    }else{
        str = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:self.str_amountPrivate with:self.str_LoanTotalAmount] afterPoint:2];
    }
    return  str;
}

-(NSString *)testModel{
    if (self.bool_isNeedAdvance&&![NSString isEqualToNullAndZero:self.str_AdvanceId]) {
        return Custing(@"借款还没有还清,需要关联借款单!", nil);
    }
    if ([self.SubmitData.EstimatedAmount floatValue]>0) {
        if ([[GPUtils decimalNumberSubWithString:self.SubmitData.ActualAmount with:self.SubmitData.EstimatedAmount]floatValue]>0&&self.bool_OvEstimatSubmit==NO) {
            return Custing(@"应付金额超过出差申请预估金额不能提交", nil);
        }
    }
    travelReimData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [travelReimData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if ([key isEqualToString:@"TravelNumber"]) {
            if ([i isEqualToString:@"1"]) {
                NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
                if (![NSString isEqualToNull:str]) {
                    returnTips=[self showerror:key];
                    break ;
                }
            }
            if (self.bool_isReleTravel) {
                NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
                if (![NSString isEqualToNull:str]) {
                    returnTips=[self showerror:key];
                    break ;
                }
            }
        }else if ([key isEqualToString:@"FromDate"]&&[i isEqualToString:@"1"]){
            if (![NSString isEqualToNull:[modeldic objectForKey:@"FromDate"]]) {
                returnTips=[self showerror:@"FromDate"];
                break ;
            }else if (![NSString isEqualToNull:[modeldic objectForKey:@"ToDate"]]){
                returnTips=[self showerror:@"ToDate"];
                break ;
            }
            //            else{
            //                NSString *TimeFormart=self.int_travelTimeParams==1?@"yyyy/MM/dd":@"yyyy/MM/dd HH:mm";
            //                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"ToDate"] WithTimeFormart:TimeFormart];
            //                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"FromDate"] WithTimeFormart:TimeFormart];
            //                if ([date2 timeIntervalSinceDate:date1]>=0.0){
            //                    returnTips=[self showerror:@"OverTime"];
            //                    break ;
            //                }
            //            }
        }else if ([key isEqualToString:@"ThirDetailList"]){
            for (NSString *str in self.arr_ThirisShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_ThirisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (PayeeDetails *model in self.arr_ThirDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Payee"]){
                            detailStr=model.Payee;
                        }else if ([str isEqualToString:@"DepositBank"]){
                            detailStr=model.DepositBank;
                        }else if ([str isEqualToString:@"BankAccount"]){
                            detailStr=model.BankAccount;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorThirDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else{
            if ([i isEqualToString:@"1"]) {
                NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
                if (![NSString isEqualToNull:str]) {
                    returnTips=[self showerror:key];
                    break ;
                }
            }
        }
    }
    if (![NSString isEqualToNull:returnTips]) {
        if (self.arr_sonItem.count==0) {
            returnTips = Custing(@"请添加费用明细", nil);
            goto when_failed;
        }
        self.arr_expirationTimeId = [NSMutableArray array];//几个月前单据不能报销消费记录id
        NSMutableArray *arr_CostCenterMgrUserIds = [NSMutableArray array];
        NSInteger count = 1;
        for (AddDetailsModel *model in self.arr_sonItem) {
            if ([model.checked isEqualToString:@"1"]) {
                //记录费用类别
                if ([NSString isEqualToNull:model.expenseCode]  && ![self.arr_SubmitExpenseCodes containsObject:[NSString stringWithFormat:@"%@",model.expenseCode]]) {
                    [self.arr_SubmitExpenseCodes addObject:[NSString stringWithFormat:@"%@",model.expenseCode]];
                }
                if ([NSString isEqualToNull:model.expenseType]  && ![self.arr_SubmitExpenseTypes containsObject:[NSString stringWithFormat:@"%@",model.expenseType]]) {
                    [self.arr_SubmitExpenseTypes addObject:[NSString stringWithFormat:@"%@",model.expenseType]];
                }
                if ([NSString isEqualToNull:model.OverStd]&&[model.OverStd floatValue]>0) {
                    self.SubmitData.IsOverStd = @"1";
                }
                if ([NSString isEqualToNull:model.overStd2]&&[model.overStd2 floatValue]>0) {
                    self.SubmitData.IsOverStd2 = @"1";
                }
                if ([[NSString stringWithFormat:@"%@",model.hasInvoice]isEqualToString:@"2"]) {
                    self.SubmitData.SubstituteInvoice = @"1";
                }
//                [arr_CostCenterMgrUserIds addObject:[NSString stringWithFormat:@"%@",model.projMgrUserId]];
                [arr_CostCenterMgrUserIds addObject:[NSString stringWithFormat:@"%@",model.costCenterMgrUserId]];
                //控制费用明细完整
                if (self.bool_isDataIntegrity && [model.isIntegrity integerValue] == 1) {
                    returnTips = [NSString stringWithFormat:@"%@%ld%@",Custing(@"你选择的第", nil),count,Custing(@"条费用明细不完整,请补充信息后再提交", nil)];
                    goto when_failed;
                }
                
                //报销期间控制
                if (self.arr_overDueList.count > 0 && [[NSString stringIsExist:model.expenseDate] length] == 10) {
                    NSString *year = [model.expenseDate substringAtRange:NSMakeRange(0, 4)];
                    NSString *expMth = [model.expenseDate substringAtRange:NSMakeRange(5, 2)];
                    for (NSDictionary *overDue in self.arr_overDueList) {
                        if ([NSString isEqualToNullAndZero:expMth]
                            && [NSString isEqualToNullAndZero:overDue[@"startMth"]]
                            && [NSString isEqualToNullAndZero:overDue[@"endMth"]]
                            && [NSString isEqualToNullAndZero:overDue[@"upToMth"]]
                            && ([expMth integerValue] - [overDue[@"startMth"] integerValue] >= 0)
                            && ([expMth integerValue] - [overDue[@"endMth"] integerValue] <= 0)) {
                            
                            NSString *upToMth = [overDue[@"upToMth"] integerValue] >= 10 ? [NSString stringWithFormat:@"%@",overDue[@"upToMth"]]:[NSString stringWithFormat:@"0%@",overDue[@"upToMth"]];
                            NSString *overEnd = [NSString stringWithFormat:@"%ld/%@", ([[NSString stringWithFormat:@"%@",overDue[@"isNextYear"]] isEqualToString:@"1"] ? [year integerValue] + 1 : [year integerValue]), upToMth];
                            if ([NSDate CompareDateStartTime:overEnd endTime:self.str_deadlineDateTime WithFormatter:@"yyyy/MM"] > 0) {
                                returnTips = Custing(@"费用明细超期", nil);
                                goto when_failed;
                            }
                            break;
                        }
                    }
                }
                if ([NSString isEqualToNullAndZero:self.str_expirationTime] && [[NSString stringIsExist:model.expenseDate] length] == 10 && [NSDate CompareDateStartTime:self.str_expirationTime endTime:model.expenseDate WithFormatter:@"yyyy/MM/dd"] <= 0) {
                    [self.arr_expirationTimeId addObject:[NSString stringWithFormat:@"%@",model.Id]];
                }
                //控制费用发生日期必须在出差期间
                if (self.bool_NeedCostDate && [NSString isEqualToNull:self.str_travel_FromDate] && [NSString isEqualToNull:self.str_travel_ToDate] ) {
                    NSDate *date1 = [GPUtils convertLeaveDateFromStrings:model.expenseDate];
                    NSDate *date2 = [GPUtils convertLeaveDateFromStrings:self.str_travel_FromDate];
                    NSDate *date3 = [GPUtils convertLeaveDateFromStrings:self.str_travel_ToDate];
                    if ([date2 timeIntervalSinceDate:date1] > 0.0 || [date1 timeIntervalSinceDate:date3] > 0.0) {
                        returnTips = [NSString stringWithFormat:@"%@%@-%@",Custing(@"费用发生日期必须在", nil),self.str_travel_FromDate,self.str_travel_ToDate];
                        goto when_failed;
                    }
                }
                //报销单超出金额必须上传附件
                if (self.dict_ClaimAttRule[model.expenseCode] && ![self.dict_ClaimAttRule[model.expenseCode] isKindOfClass:[NSNull class]] && self.bool_AddFilesShow && ![NSString isEqualToNull:model.files]) {
                    NSDictionary *dict = self.dict_ClaimAttRule[model.expenseCode];
                    NSString *over_Amount = [GPUtils decimalNumberSubWithString:model.localCyAmount with:dict[@"amount"]];
                    if ([over_Amount floatValue] > 0) {
                        NSString *expType = [NSString stringWithIdOnNO:model.expenseType];
                        NSString *expDate = [NSString stringWithIdOnNO:model.expenseDate];
                        returnTips = [NSString stringWithFormat:@"%@(%@)%@,%@",expType,expDate,Custing(@"费用超标", nil),Custing(@"请提供说明文件", nil)];
                        goto when_failed;
                    }
                }
                count += 1;
            }
        }
        if (self.bool_limitExpirationTime && self.arr_expirationTimeId.count > 0) {
            returnTips = [NSString stringWithFormat:@"%@%@%@",Custing(@"只能报销", nil),self.str_expirationTime,Custing(@"之后的费用", nil)];
            goto when_failed;
        }
        //改变主表超期值
        self.SubmitData.IsExpExpired = self.arr_expirationTimeId.count > 0 ? @"1":@"0";
        //    去重
        NSSet *arrSet = [NSSet setWithArray:arr_CostCenterMgrUserIds];
        NSArray *setArr = [arrSet allObjects];
        self.SubmitData.CostCenterMgrUserIds = [GPUtils getSelectResultWithArray:setArr WithCompare:@","];
//        self.SubmitData.CostCenterMgrUserIds = [GPUtils getSelectResultWithArray:arr_CostCenterMgrUserIds WithCompare:@","];
        
        if (self.bool_ThirDetailsShow && self.bool_isConsistentAmount) {
            NSString *Amout = @"0";
            for (PayeeDetails *model in self.arr_ThirDetailsDataArray) {
                Amout = [GPUtils decimalNumberAddWithString:Amout with:[NSString stringWithFormat:@"%@",model.Amount]];
            }
            if ([[GPUtils decimalNumberSubWithString:self.SubmitData.ActualAmount with:Amout] floatValue] != 0) {
                returnTips = Custing(@"收款明细金额合计必须与应付金额相同", nil);
                goto when_failed;
            }
        }
        
        if (self.bool_ShareShow && self.bool_isSameShareAMT) {
            NSString *Amout=@"0";
            for (ReimShareModel *model in self.arr_ShareData) {
                Amout=[GPUtils decimalNumberAddWithString:Amout with:[NSString stringWithFormat:@"%@",model.Amount]];
            }
            if ([[GPUtils decimalNumberSubWithString:self.SubmitData.TotalAmount with:Amout] floatValue]!=0) {
                returnTips=Custing(@"费用分摊金额合计必须与报销金额相同", nil);
                goto when_failed;
            }
        }
        if ([NSString isEqualToNull:self.str_submitId]) {
            if (self.int_SubmitSaveType == 3) {
                if ([[GPUtils decimalNumberSubWithString:self.SubmitData.TotalAmount with:self.str_lastAmount] floatValue]!=0&&[self.str_directType integerValue] == 2) {
                    returnTips=Custing(@"您修改了金额，请重新提交", nil);
                    goto when_failed;
                }else if ([[GPUtils decimalNumberSubWithString:self.SubmitData.TotalAmount with:self.str_lastAmount]floatValue]>0&&[self.str_directType integerValue] ==3){
                    returnTips=Custing(@"您修改了金额，请重新提交", nil);
                    goto when_failed;
                }
            }
        }else{
            returnTips=Custing(@"请选择费用明细", nil);
            goto when_failed;
        }
    }
    
when_failed:
    return returnTips;
}
//MARK:显示主表必填项判断
-(NSString *)showerror:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"ClaimType"]) {
        showinfo =Custing(@"请输入报销类型", nil) ;
    }else if([info isEqualToString:@"Reason"]) {
        showinfo =Custing(@"请输入报销事由", nil) ;
    }else if([info isEqualToString:@"Contact"]) {
        showinfo = Custing(@"请输入联系方式", nil);
    }else if([info isEqualToString:@"RequestorDeptId"]) {
        showinfo =Custing(@"请选择部门", nil) ;
    }else if([info isEqualToString:@"BranchId"]) {
        showinfo = Custing(@"请选择公司", nil);
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"BnfId"]) {
        showinfo = Custing(@"请选择受益人", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"TravelNumber"]) {
        showinfo =Custing( @"请选择出差申请单", nil);
    }else if([info isEqualToString:@"TravelType"]) {
        showinfo =Custing( @"请选择出差类型", nil);
    }else if([info isEqualToString:@"RelevantDept"]) {
        showinfo =Custing( @"请选择归口部门", nil);
    }else if([info isEqualToString:@"FinancialSource"]) {
        showinfo =Custing( @"请选择经费来源", nil);
    }else if([info isEqualToString:@"FromDate"]) {
        showinfo =Custing( @"请选择出发时间", nil);
    }else if([info isEqualToString:@"ToDate"]) {
        showinfo =Custing( @"请选择返回时间", nil);
    }
    //    else if([info isEqualToString:@"OverTime"]) {
    //        showinfo = Custing(@"出发时间不能大于等于返回时间", nil);
    //    }
    else if([info isEqualToString:@"FellowOfficers"]) {
        showinfo =Custing( @"请选择出差人员", nil);
    }else if([info isEqualToString:@"OverBudReason"]) {
        showinfo = Custing(@"请输入超预算原因", nil);
    }else if([info isEqualToString:@"StaffOutNumber"]) {
        showinfo = Custing(@"请选择外出申请单", nil);
    }else if([info isEqualToString:@"VehicleNumber"]) {
        showinfo = Custing(@"请选择用车申请单", nil);
    }else if([info isEqualToString:@"AdvanceNumber"]) {
        showinfo = Custing(@"请选择借款单", nil);
    }else if([info isEqualToString:@"NoInvAmount"]) {
        showinfo = Custing(@"请输入无发票金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择报销币种", nil);
    }else if([info isEqualToString:@"NumberOfDocuments"]) {
        showinfo =Custing(@"请输入单据数量", nil);
    }else if([info isEqualToString:@"Payee"]) {
        showinfo =Custing(@"请输入收款人", nil);
    }else if([info isEqualToString:@"BankAccount"]) {
        showinfo =Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"BankOutlets"]) {
        showinfo =Custing(@"请选择开户网点", nil);
    }else if([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if([info isEqualToString:@"Attachments"]) {
        showinfo = Custing(@"请上传附件", nil);
    }else if([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
        
        showinfo =[[self.dict_isCtrlTypdic objectForKey:info] isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[self.dict_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[self.dict_reservedDic objectForKey:info]];
    }else if([info isEqualToString:@"FirstHandlerUserName"]) {
        showinfo = Custing(@"请选择审批人", nil);
    }else if([info isEqualToString:@"CcUsersName"]) {
        showinfo = Custing(@"请选择抄送人", nil);
    }
    return showinfo;
}
-(NSString *)showerrorThirDetail:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"Payee"]) {
        showinfo = Custing(@"请选择收款人", nil);
    }else if ([info isEqualToString:@"DepositBank"]) {
        showinfo = Custing(@"请输入开户行", nil);
    }else if ([info isEqualToString:@"BankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入金额", nil);
    }
    return showinfo;
}
-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_ReimApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[travelReimData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_ReimApp setObject:@"Sa_TravelExpense" forKey:@"tableName"];
    [Sa_ReimApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_ReimApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_ReimApp];
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_TravelExpenseShare = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_ShareData.count!=0) {
        NSMutableDictionary *modelsDic=[ReimShareModel initDicByModel:self.arr_ShareData[0]];
        [modelsDic removeObjectForKey:@"TaskId"];
        [modelsDic removeObjectForKey:@"GridOrder"];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (ReimShareModel *model in self.arr_ShareData) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelExpenseShare setObject:@"Sa_TravelExpenseShare" forKey:@"tableName"];
        [Sa_TravelExpenseShare setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelExpenseShare setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_TravelExpenseShare setObject:@"Sa_TravelExpenseShare" forKey:@"tableName"];
        [Sa_TravelExpenseShare setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelExpenseShare setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_TravelExpenseShare];
    
    
    NSMutableDictionary *Sa_TravelExpensePayeeDetail = [NSMutableDictionary dictionary];
    NSArray *fieldNames1 = [NSArray array];
    NSMutableArray *Values1=[NSMutableArray array];
    if (self.arr_ThirDetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[PayeeDetails initDicByModel:self.arr_ThirDetailsDataArray[0]];
        fieldNames1 = [modelsDic allKeys];
        for (NSString *key in fieldNames1) {
            NSMutableArray  *array=[NSMutableArray array];
            for (PayeeDetails *model in self.arr_ThirDetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values1 addObject:array];
        }
        [Sa_TravelExpensePayeeDetail setObject:@"Sa_TravelExpensePayeeDetail" forKey:@"tableName"];
        [Sa_TravelExpensePayeeDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_TravelExpensePayeeDetail setObject:Values1 forKey:@"fieldBigValues"];
    }else{
        [Sa_TravelExpensePayeeDetail setObject:@"Sa_TravelExpensePayeeDetail" forKey:@"tableName"];
        [Sa_TravelExpensePayeeDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_TravelExpensePayeeDetail setObject:Values1 forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_TravelExpensePayeeDetail];
    
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)testApporveEditModel{
    if (self.int_comeEditType == 2 || self.int_comeEditType == 3 || self.int_comeEditType == 6 || self.int_comeEditType == 7) {
        NSArray *filterSetArray = @[@"Amount",@"Currency",@"ExchangeRate",@"PmtMethod"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"fieldName IN %@ && isShow = 1 && isRequired = 1",filterSetArray];
        NSArray *filterArray = [self.arr_SecDetailsArray filteredArrayUsingPredicate:pred];
        if (filterArray.count > 0 && self.arr_SecDetailsDataArray.count > 0) {
            for (pmtMethodDetail *detail in self.arr_SecDetailsDataArray) {
                for (MyProcurementModel *model in filterArray) {
                    if (![NSString isEqualToNull:[detail valueForKey:model.fieldName]]) {
                        return model.tips;
                    }
                }
            }
        }
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"fieldName MATCHES %@ && isShow = 1 && isRequired = 1", @"PmtMethod"];
        NSArray *filterArray1 = [self.arr_FormMainArray filteredArrayUsingPredicate:pred1];
        if (filterArray1.count > 0 && ![NSString isEqualToNull:self.str_PayCode]) {
            MyProcurementModel *model = filterArray1[0];
            return model.tips;
        }
    }
    return nil;
}

-(void)contectHasDataWithTableName:(NSString *)tableName{
    
    NSMutableArray *travelFieldName = [NSMutableArray arrayWithArray:@[@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate",@"IsReceiptOfInv",@"ShareDeptIds",@"PmtMethodId",@"PmtMethod"]];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSMutableArray *travelfieldValues = [NSMutableArray arrayWithArray:@[self.str_twoHandeId,self.str_twoApprovalName,self.str_BudgetSubDate,self.str_ReceiptOfInv,self.str_ShareDeptIds,self.str_PayCode,self.str_PayMode]];
    
    if (self.int_formStatus == 3) {
        [travelFieldName addObjectsFromArray:@[@"IsOverBud",@"IsOverStd",@"IsOverStd2"]];
        [travelfieldValues addObjectsFromArray:@[self.dict_JudgeAmount[@"IsOverBud"],self.dict_JudgeAmount[@"IsOverStd"],self.dict_JudgeAmount[@"IsOverStd2"]]];
    }
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    
    NSMutableArray *array = [self getTravelExpenseSettle];
    if (array.count > 0) {
        self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":array};
    }else{
        self.dict_parametersDict=@{@"mainDataList":mainArray};
    }
}

-(void)contectHasPayDataWithTableName:(NSString *)tableName{
    
    NSMutableArray *travelFieldName = [NSMutableArray arrayWithArray:@[@"twohandleruserid",@"twohandlerusername",@"BudgetSubDate",@"IsReceiptOfInv",@"ShareDeptIds",@"PmtMethodId",@"PmtMethod"]];
    NSMutableArray *travelfieldValues = [NSMutableArray arrayWithArray:@[@"",@"",self.str_BudgetSubDate,self.str_ReceiptOfInv,self.str_ShareDeptIds,self.str_PayCode,self.str_PayMode]];
    if (self.int_formStatus == 3) {
        [travelFieldName addObjectsFromArray:@[@"IsOverBud",@"IsOverStd",@"IsOverStd2"]];
        [travelfieldValues addObjectsFromArray:@[self.dict_JudgeAmount[@"IsOverBud"],self.dict_JudgeAmount[@"IsOverStd"],self.dict_JudgeAmount[@"IsOverStd2"]]];
    }
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    
    NSMutableArray *array = [self getTravelExpenseSettle];
    if (array.count > 0) {
        self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":array};
    }else{
        self.dict_parametersDict=@{@"mainDataList":mainArray};
    }
}

-(NSMutableArray *)getTravelExpenseSettle{
    NSMutableArray *detailedArray = [NSMutableArray array];
    if ((self.int_comeEditType == 2 || self.int_comeEditType == 3 || self.int_comeEditType == 6 || self.int_comeEditType == 7)&&self.arr_SecDetailsDataArray.count!=0) {
        NSMutableDictionary *Sa_TravelExpenseSettle = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = [NSArray array];
        NSMutableArray *Values=[[NSMutableArray alloc]init];
        NSMutableDictionary *modelsDic=[pmtMethodDetail initDicByModel:self.arr_SecDetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (pmtMethodDetail *model in self.arr_SecDetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    if ([key isEqualToString:@"Amount"]) {
                        [array addObject:@"0"];
                    }else{
                        [array addObject:(id)[NSNull null]];
                    }
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelExpenseSettle setObject:@"Sa_TravelExpenseSettle" forKey:@"tableName"];
        [Sa_TravelExpenseSettle setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelExpenseSettle setObject:Values forKey:@"fieldBigValues"];
        [detailedArray addObject:Sa_TravelExpenseSettle];
    }
    return detailedArray;
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_TravelExpense"];
}

-(NSString *)getCommonField{
    NSDictionary *dict;
    if (self.int_formStatus == 1) {
        dict=@{
            @"IsLimitIdList": self.arr_expirationTimeId.count > 0 ? [self.arr_expirationTimeId componentsJoinedByString:@","]:@""};
    }else{
        dict=@{
            @"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
    }
    return [NSString transformToJson:dict];
}
-(NSDictionary *)getCheckSubmitOtherPar{
    return  @{@"AdvanceTaskId":[NSString isEqualToNull:self.str_AdvanceId]?self.str_AdvanceId:@"",@"OtherTaskId":[NSString isEqualToNull:self.str_travelFormId]?self.str_travelFormId:@"",@"OtherFlowCode":@""};
}

-(NSString *)getTravelFromTimeAndToTime:(NSString *)time{
    NSString *endStr=@"";
    if ([NSString isEqualToNull:time]) {
        NSString *times=[NSString stringWithFormat:@"%@",time];
        if (self.int_travelTimeParams==1) {
            if (times.length==10) {
                endStr=[NSString stringWithFormat:@"%@ 00:00",times];
            }
        }else{
            if (times.length>10) {
                endStr=[times substringToIndex:10];
            }
        }
    }
    return endStr;
}

-(void)getSubmitExpShareDataWithDict:(NSArray *)array{
    for (NSDictionary *dict in array) {
        if ([NSString isEqualToNullAndZero:dict[@"projId"]] && ![self.arr_ShareProjId containsObject:[NSString stringWithFormat:@"%@",dict[@"projId"]]]) {
            [self.arr_ShareProjId addObject:[NSString stringWithFormat:@"%@",dict[@"projId"]]];
        }
        if ([NSString isEqualToNullAndZero:dict[@"projMgrUserId"]] && ![self.arr_ShareProjMgrId containsObject:[NSString stringWithFormat:@"%@",dict[@"projMgrUserId"]]]) {
            [self.arr_ShareProjMgrId addObject:[NSString stringWithFormat:@"%@",dict[@"projMgrUserId"]]];
        }
        if ([NSString isEqualToNullAndZero:dict[@"requestorDeptId"]] && ![[NSString stringWithFormat:@"%@",dict[@"requestorDeptId"]] isEqualToString:self.personalData.RequestorDeptId] && ![self.arr_ShareDeptId containsObject:[NSString stringWithFormat:@"%@",dict[@"requestorDeptId"]]]) {
            [self.arr_ShareDeptId addObject:[NSString stringWithFormat:@"%@",dict[@"requestorDeptId"]]];
        }
    }
    self.SubmitData.ExpenseCodes = self.arr_SubmitExpenseCodes.count > 0 ? [self.arr_SubmitExpenseCodes componentsJoinedByString:@","]:(id)[NSNull null];
    self.SubmitData.ExpenseTypes = self.arr_SubmitExpenseTypes.count > 0 ? [self.arr_SubmitExpenseTypes componentsJoinedByString:@","]:(id)[NSNull null];
    self.SubmitData.ShareProjIds = self.arr_ShareProjId.count > 0 ? [self.arr_ShareProjId componentsJoinedByString:@","]:(id)[NSNull null];
    self.SubmitData.ShareProjMgrIds = self.arr_ShareProjMgrId.count > 0 ? [self.arr_ShareProjMgrId componentsJoinedByString:@","]:(id)[NSNull null];
    self.SubmitData.ShareDeptIds = self.arr_ShareDeptId.count > 0 ? [self.arr_ShareDeptId componentsJoinedByString:@","]:(id)[NSNull null];
}


@end
