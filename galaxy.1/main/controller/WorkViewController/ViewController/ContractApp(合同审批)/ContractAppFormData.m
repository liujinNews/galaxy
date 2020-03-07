//
//  ContractAppFormData.m
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ContractAppFormData.h"
#import "ContractTermDetail.h"
#import "ContractPayMethodDetail.h"
#import "ContractYearExpDetail.h"

@implementation ContractAppFormData

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
    
    self.str_flowCode=@"F0013";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"ContractNo",@"ContractName",@"ExpenseCode",@"RelateContNo",@"PurchaseNumber",@"ProjId",@"ContractTypId",@"TotalAmount",@"CurrencyCode",@"ExchangeRate",@"ContractDate",@"EffectiveDate",@"ExpiryDate",@"PayCode",@"MoneyOrderRate",@"ContractCopies",@"PartyA",@"PartyAStaff",@"PartyATel",@"PartyB",@"PartyBAddress",@"PartyBPostCode",@"PartyBStaff",@"PartyBTel",@"BankName",@"BankAccount",@"InvoiceTitle",@"InvoiceType",@"TaxRate",@"ClientName",@"ClientAddr",@"IbanName",@"IbanAccount",@"IbanAddr",@"SwiftCode",@"BankNo",@"BankADDRESS",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"DetailList",@"SecDetailList",@"ThirDetailList",@"FirstHandlerUserName",@"CcUsersName",@"OtherApprover"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.arr_PayCode = [NSMutableArray array];
    self.arr_CategoryArr = [NSMutableArray array];
    self.str_ExpenseCode = @"";
    self.str_ExpenseType = @"";
    self.str_ExpenseIcon = @"";
    self.str_ExpenseCatCode = @"";
    self.str_ExpenseCat = @"";
    self.str_InvoiceType = @"0";
    self.str_PartBType = @"1";
    
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0013";
    self.bool_isOpenDetail = NO;
    self.bool_SecisOpenDetail = NO;
    self.bool_ThirisOpenDetail = NO;
    self.arr_PayCode = [NSMutableArray array];
    self.arr_RelateCont = [NSMutableArray array];
    self.arr_ContractReleInfo = [NSMutableArray array];
    self.str_InvoiceType = @"0";
    self.str_PartBType=@"1";

}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",GetContractAppData];
    }else{
        return [NSString stringWithFormat:@"%@",ContractAppGetFormData];
    }
}

-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        [self getCurrencyData:result];
        
        self.int_codeIsSystem = [result[@"contractCodeIsSystem"] integerValue];
        
        //付款方式
        if ([result[@"contractPmtTyps"]isKindOfClass:[NSArray class]]) {
            [ChooseCategoryModel getNewPayWayByArray:[NSMutableArray arrayWithArray:result[@"contractPmtTyps"]] Array:self.arr_PayCode];
        }
        
        if (self.int_comeStatus ==  2|| self.int_comeStatus ==  3) {
            //关联合同数组
            if ([result[@"relateContractList"] isKindOfClass:[NSArray class]]) {
                self.arr_RelateCont=[NSMutableArray arrayWithArray:result[@"relateContractList"]];
            }
            //付款，回款，开票数组
            if ([result[@"alreadyPaid"]isKindOfClass:[NSDictionary class]]) {
                NSDictionary *already=result[@"alreadyPaid"];
                if ([already[@"alreadyPaids"]isKindOfClass:[NSArray class]]) {
                    NSArray *arr=already[@"alreadyPaids"];
                    if (arr.count>0) {
                        NSMutableArray *array=[NSMutableArray arrayWithArray:arr];
                        [array addObject:@{@"Key":@"1",@"Amount":[NSString stringWithIdOnNO:already[@"unpaidAmount"]]}];
                        [self.arr_ContractReleInfo addObject:array];
                    }
                }
            }
            if ([result[@"alreadyReceiveBill"]isKindOfClass:[NSDictionary class]]) {
                NSDictionary *already=result[@"alreadyReceiveBill"];
                if ([already[@"alreadyPaids"]isKindOfClass:[NSArray class]]) {
                    NSArray *arr=already[@"alreadyPaids"];
                    if (arr.count>0) {
                        NSMutableArray *array=[NSMutableArray arrayWithArray:arr];
                        [array addObject:@{@"Key":@"2",@"Amount":[NSString stringWithIdOnNO:already[@"unpaidAmount"]]}];
                        [self.arr_ContractReleInfo addObject:array];
                    }
                }
            }
            if ([result[@"alreadyInvoice"]isKindOfClass:[NSDictionary class]]) {
                NSDictionary *already=result[@"alreadyInvoice"];
                if ([already[@"alreadyPaids"]isKindOfClass:[NSArray class]]) {
                    NSArray *arr=already[@"alreadyPaids"];
                    if (arr.count>0) {
                        NSMutableArray *array=[NSMutableArray arrayWithArray:arr];
                        [array addObject:@{@"Key":@"3",@"Amount":[NSString stringWithIdOnNO:already[@"unpaidAmount"]]}];
                        [self.arr_ContractReleInfo addObject:array];
                    }
                }
            }
        }
    
        self.bool_DetailsShow = [[NSString stringWithFormat:@"%@",result[@"term"]] isEqualToString:@"1"] ? YES:NO;
        self.bool_SecDetailsShow = [[NSString stringWithFormat:@"%@",result[@"payMode"]] isEqualToString:@"1"] ? YES:NO;
        self.bool_ThirDetailsShow = [[NSString stringWithFormat:@"%@",result[@"expMode"]] isEqualToString:@"1"] ? YES:NO;

        if (self.bool_DetailsShow) {
            self.dict_isRequiredmsDetaildic=[[NSMutableDictionary alloc]init];
            self.arr_isShowmDetailArray=[[NSMutableArray alloc]init];
            self.arr_DetailsArray=[NSMutableArray array];
            self.arr_DetailsDataArray=[NSMutableArray array];
            //明细主表数据
            if ([result[@"termDetailFld"]isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result[@"termDetailFld"]) {
                    if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                        MyProcurementModel *model=[[MyProcurementModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        [self.arr_DetailsArray addObject:model];
                        [self.arr_isShowmDetailArray addObject:model.fieldName];
                        [self.dict_isRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                    }
                }
            }
        }
        if (self.bool_SecDetailsShow) {
            self.dict_SecisRequiredmsDetaildic=[[NSMutableDictionary alloc]init];
            self.arr_SecisShowmDetailArray=[[NSMutableArray alloc]init];
            self.arr_SecDetailsArray=[NSMutableArray array];
            self.arr_SecDetailsDataArray=[NSMutableArray array];
            //明细主表数据
            if ([result[@"payModeDetailFld"]isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result[@"payModeDetailFld"]) {
                    if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                        MyProcurementModel *model=[[MyProcurementModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        [self.arr_SecDetailsArray addObject:model];
                        [self.arr_SecisShowmDetailArray addObject:model.fieldName];
                        [self.dict_SecisRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                    }
                }
            }
        }
        if (self.bool_ThirDetailsShow) {
            self.dict_ThirisRequiredmsDetaildic = [[NSMutableDictionary alloc]init];
            self.arr_ThirisShowmDetailArray = [[NSMutableArray alloc]init];
            self.arr_ThirDetailsArray = [NSMutableArray array];
            self.arr_ThirDetailsDataArray = [NSMutableArray array];
            //明细主表数据
            if ([result[@"expModeDetailFld"]isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in result[@"expModeDetailFld"]) {
                    if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                        MyProcurementModel *model=[[MyProcurementModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        [self.arr_ThirDetailsArray addObject:model];
                        [self.arr_ThirisShowmDetailArray addObject:model.fieldName];
                        [self.dict_ThirisRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                    }
                }
            }
        }
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"]isEqualToString:@"RelateTaskId"]) {
                        self.str_RelateContId = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RelateContNo"]) {
                        self.str_RelateContNo = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RelateContName"]) {
                        self.str_RelateContName = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseNumber"]) {
                        self.str_PurchaseNumber=[NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseInfo"]) {
                        self.str_PurchaseInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractNo"]) {
                        self.str_ContractNo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"ContractTypId"]) {
                        self.str_ContTypeId= [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"ContractType"]) {
                        self.str_ContType = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PartyBType"]) {
                        self.str_PartBType = [NSString isEqualToNullAndZero:[dict objectForKey:@"fieldValue"]] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]] : @"1";;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayCode"]) {
                        self.str_PayCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayMode"]) {
                        self.str_PayMode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PartyBId"]) {
                        self.str_PartBId = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PartyB"]) {
                        self.str_PartB = [dict objectForKey:@"fieldValue"];
                    }if ([dict[@"fieldName"] isEqualToString:@"IsStandardContractTemplate"]) {
                        self.str_IsStandardContractTemplate = [dict objectForKey:@"fieldValue"];
                    }if ([dict[@"fieldName"] isEqualToString:@"OtherApprover"]) {
                        self.str_OtherApprover = [dict objectForKey:@"OtherApprover"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceType"]) {
                        if ([dict[@"isShow"] floatValue] == 1) {
                            self.str_InvoiceType = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"2"] ? @"2":@"1";
                        }else{
                            self.str_InvoiceType = @"0";
                        }
                    }
                }
            }
        }
        //明细数据
        if ([result[@"formData"]isKindOfClass:[NSDictionary class]]&&[result[@"formData"][@"detail"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *detail = result[@"formData"][@"detail"];
            if ([detail[@"sa_ContractTermDetail"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in detail[@"sa_ContractTermDetail"]) {
                    ContractTermDetail *model=[[ContractTermDetail alloc]init];
                    if (![dict[@"no"] isKindOfClass:[NSNull class]]) {
                        model.No=[NSString stringWithFormat:@"%@",dict[@"no"]];
                    }
                    if (![dict[@"terms"] isKindOfClass:[NSNull class]]) {
                        model.Terms=[NSString stringWithFormat:@"%@",dict[@"terms"]];
                    }
                    [self.arr_DetailsDataArray addObject:model];
                }
            }
            if ([detail[@"sa_ContractPayMethodDetail"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in detail[@"sa_ContractPayMethodDetail"]) {
                    ContractPayMethodDetail *model=[[ContractPayMethodDetail alloc]init];
                    if (![dict[@"no"] isKindOfClass:[NSNull class]]) {
                        model.No=[NSString stringWithFormat:@"%@",dict[@"no"]];
                    }
                    if (![dict[@"payRatio"] isKindOfClass:[NSNull class]]) {
                        model.PayRatio = [NSString reviseString:dict[@"payRatio"]];
                    }
                    if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                        model.Amount = [NSString reviseString:dict[@"amount"]];
                    }
                    if (![dict[@"payDate"] isKindOfClass:[NSNull class]]) {
                        model.PayDate=[NSString stringWithFormat:@"%@",dict[@"payDate"]];
                    }
                    if (![dict[@"remark"] isKindOfClass:[NSNull class]]) {
                        model.Remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
                    }if(![dict[@"paymentClause"] isKindOfClass:[NSNull class]]){
                        model.PaymentClause = [NSString stringWithFormat:@"%@",dict[@"paymentClause"]];
                    }
                    [self.arr_SecDetailsDataArray addObject:model];
                }
            }
            if ([detail[@"sa_ContractExpDetail"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in detail[@"sa_ContractExpDetail"]) {
                    ContractYearExpDetail *model=[[ContractYearExpDetail alloc]init];
                    if (![dict[@"year"] isKindOfClass:[NSNull class]]) {
                        model.Year=[NSString stringWithFormat:@"%@",dict[@"year"]];
                    }
                    if (![dict[@"totalAmount"] isKindOfClass:[NSNull class]]) {
                        model.TotalAmount=[NSString stringWithFormat:@"%@",dict[@"totalAmount"]];
                    }
                    if (![dict[@"tax"] isKindOfClass:[NSNull class]]) {
                        model.Tax=[NSString stringWithFormat:@"%@",dict[@"tax"]];
                    }
                    if (![dict[@"exclTax"] isKindOfClass:[NSNull class]]) {
                        model.ExclTax=[NSString stringWithFormat:@"%@",dict[@"exclTax"]];
                    }
                    [self.arr_ThirDetailsDataArray addObject:model];
                }
            }
        }
        //判断是否外币
        for (STOnePickModel *model in self.arr_CurrencyCode) {
            if ([model.Id isEqualToString:self.str_CurrencyCode]&&[model.stdMoney floatValue]!=1) {
                self.bool_isForeign = YES;
            }
        }
    }
}

-(void)inModelContent{
    self.SubmitData = [[ContractAppData alloc]init];
    
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

    
    self.SubmitData.ExpenseCode = self.str_ExpenseCode;
    self.SubmitData.ExpenseType = self.str_ExpenseType;
    self.SubmitData.ExpenseIcon = self.str_ExpenseIcon;
    self.SubmitData.ExpenseCatCode = self.str_ExpenseCatCode;
    self.SubmitData.ExpenseCat = self.str_ExpenseCat;
    self.SubmitData.RelateContNo=self.str_RelateContNo;
    self.SubmitData.RelateContName=self.str_RelateContName;
    self.SubmitData.RelateTaskId=self.str_RelateContId;
    self.SubmitData.PurchaseNumber=self.str_PurchaseNumber;
    self.SubmitData.PurchaseInfo=self.str_PurchaseInfo;
    
    if (self.int_comeStatus != 0 || self.int_codeIsSystem != 0) {
        self.SubmitData.ContractNo = self.str_ContractNo;
    }
    self.SubmitData.ContractTypId=self.str_ContTypeId;
    self.SubmitData.ContractType=self.str_ContType;
    self.SubmitData.PayCode = self.str_PayCode;
    self.SubmitData.PayMode = self.str_PayMode;

    self.SubmitData.PartyBType = self.str_PartBType;
    self.SubmitData.PartyBId = self.str_PartBId;
    self.SubmitData.PartyB = self.str_PartB;

    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";

    
    self.SubmitData.CurrencyCode = self.str_CurrencyCode;
    self.SubmitData.Currency = self.str_Currency;
    self.SubmitData.ExchangeRate = self.str_ExchangeRate;
    self.SubmitData.InvoiceType = self.str_InvoiceType;
    self.SubmitData.CapitalizedAmount=@"";
    
}
-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}
-(NSString *)testModel{
    ContractAppData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [ContractAppData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (ContractTermDetail *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"No"]){
                            detailStr=model.No;
                        }else if ([str isEqualToString:@"Terms"]){
                            detailStr=model.Terms;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"SecDetailList"]){
            for (NSString *str in self.arr_SecisShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_SecisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (ContractPayMethodDetail *model in self.arr_SecDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"No"]){
                            detailStr=model.No;
                        }else if ([str isEqualToString:@"PayRatio"]){
                            detailStr=model.PayRatio;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if ([str isEqualToString:@"PayDate"]){
                            detailStr=model.PayDate;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }else if([str isEqualToString:@"PaymentClause"]){
                            detailStr=model.PaymentClause;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"ThirDetailList"]){
            for (NSString *str in self.arr_ThirisShowmDetailArray) {
                NSString *i = [NSString stringWithFormat:@"%@",[self.dict_ThirisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (ContractYearExpDetail *model in self.arr_ThirDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Year"]){
                            detailStr = model.Year;
                        }else if ([str isEqualToString:@"TotalAmount"]){
                            detailStr = model.TotalAmount;
                        }else if ([str isEqualToString:@"Tax"]){
                            detailStr = model.Tax;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips = [self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else{
//            if ([key isEqualToString:@"OverTime"]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"VisitDate"]]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"LeaveDate"]]) {
//
//                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"LeaveDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
//                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"VisitDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
//                if ([date2 timeIntervalSinceDate:date1]>=0.0)
//                {
//                    returnTips=[self showerror:@"OverTime"];
//                    break ;
//                }
//            }
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
    }else if([info isEqualToString:@"ContractNo"]&&self.int_codeIsSystem != 0) {
        showinfo =Custing(@"请输入合同编号", nil) ;
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo =Custing(@"请输入合同名称", nil) ;
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if([info isEqualToString:@"RelateContNo"]) {
        showinfo =Custing(@"请选择关联合同", nil) ;
    }else if([info isEqualToString:@"PurchaseNumbe"]) {
        showinfo = Custing(@"请选择关联采购申请", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ContractTypId"]) {
        showinfo =Custing(@"请选择合同类型", nil) ;
    }else if ([info isEqualToString:@"IsStandardContractTemplate"]){
        showinfo = Custing(@"请选择是否使用标准合同模版", nil);
    }else if([info isEqualToString:@"TotalAmount"]) {
        showinfo = Custing(@"请输入合同金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
    }else if ([info isEqualToString:@"OtherApprover"]){
        showinfo = Custing(@"请输入会签人员", nil);
    }else if([info isEqualToString:@"ContractDate"]) {
        showinfo = Custing(@"请选择合同签订日期", nil);
    }else if([info isEqualToString:@"EffectiveDate"]) {
        showinfo = Custing(@"请选择合同开始日期", nil);
    }else if([info isEqualToString:@"ExpiryDate"]) {
        showinfo = Custing(@"请选择合同截止日期", nil);
    }else if([info isEqualToString:@"PayCode"]) {
        showinfo = Custing(@"请选择付款方式", nil);
    }else if([info isEqualToString:@"MoneyOrderRate"]) {
        showinfo = Custing(@"请输入汇票比例", nil);
    }else if([info isEqualToString:@"ContractCopies"]) {
        showinfo = Custing(@"请输入签订份数", nil);
    }else if([info isEqualToString:@"PartyA"]) {
        showinfo = Custing(@"请输入我方单位名称", nil);
    }else if([info isEqualToString:@"PartyAStaff"]) {
        showinfo = Custing(@"请输入我方单位负责人", nil);
    }else if([info isEqualToString:@"PartyATel"]) {
        showinfo = Custing(@"请输入我方单位电话", nil);
    }else if([info isEqualToString:@"PartyB"]) {
        showinfo = Custing(@"请选择对方单位名称", nil);
    }else if([info isEqualToString:@"PartyBAddress"]) {
        showinfo = Custing(@"请输入对方单位地址", nil);
    }else if([info isEqualToString:@"PartyBPostCode"]) {
        showinfo = Custing(@"请输入邮编", nil);
    }else if([info isEqualToString:@"PartyBStaff"]) {
        showinfo = Custing(@"请输入联系人", nil);
    }else if([info isEqualToString:@"PartyBTel"]) {
        showinfo = Custing(@"请输入电话", nil);
    }else if([info isEqualToString:@"BankName"]) {
        showinfo = Custing(@"请输入开户银行", nil);
    }else if([info isEqualToString:@"BankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"InvoiceTitle"]) {
        showinfo = Custing(@"请输入发票抬头", nil);
    }else if([info isEqualToString:@"InvoiceType"]) {
        showinfo = Custing(@"请选择发票类型", nil);
    }else if([info isEqualToString:@"TaxRate"]) {
        showinfo = Custing(@"请选择税率", nil);
    }else if([info isEqualToString:@"ClientName"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入客户名称", nil);
    }else if([info isEqualToString:@"ClientAddr"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入客户地址", nil);
    }else if([info isEqualToString:@"IbanName"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入银行名称", nil);
    }else if([info isEqualToString:@"IbanAccount"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入IBAN/银行账号", nil);
    }else if([info isEqualToString:@"IbanAddr"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入银行地址", nil);
    }else if([info isEqualToString:@"SwiftCode"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入SwiftCode", nil);
    }else if([info isEqualToString:@"BankNo"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入行号", nil);
    }else if([info isEqualToString:@"BankADDRESS"]&&self.bool_isForeign) {
        showinfo = Custing(@"请输入ADDRESS", nil);
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
    if ([info isEqualToString:@"No"]) {
        showinfo = Custing(@"请输入序号", nil);
    }else if ([info isEqualToString:@"Terms"]) {
        showinfo = Custing(@"请输入内容", nil);
    }else if ([info isEqualToString:@"PayRatio"]) {
        showinfo = Custing(@"请输入付款比例", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入金额", nil);
    }else if ([info isEqualToString:@"PayDate"]) {
        showinfo = Custing(@"请选择付款日期", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if ([info isEqualToString:@"Year"]) {
        showinfo = Custing(@"请选择年份", nil);
    }else if ([info isEqualToString:@"TotalAmount"]) {
        showinfo = Custing(@"请输入总金额", nil);
    }else if ([info isEqualToString:@"Tax"]) {
        showinfo = Custing(@"请输入税额", nil);
    }else if ([info isEqualToString:@"PaymentClause"]){
        showinfo = Custing(@"请输入付款条件", nil);
    }
    return showinfo;
}

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_ContractApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[ContractAppData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_ContractApp setObject:@"Sa_ContractApp" forKey:@"tableName"];
    [Sa_ContractApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_ContractApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_ContractApp];
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *Sa_ContractTermDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[ContractTermDetail initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (ContractTermDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_ContractTermDetail setObject:@"Sa_ContractTermDetail" forKey:@"tableName"];
        [Sa_ContractTermDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_ContractTermDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_ContractTermDetail setObject:@"Sa_ContractTermDetail" forKey:@"tableName"];
        [Sa_ContractTermDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_ContractTermDetail setObject:Values forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_ContractTermDetail];
    
    
    NSMutableDictionary *Sa_ContractPayMethodDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames2 = [NSArray array];
    NSMutableArray *Values2 = [NSMutableArray array];
    if (self.arr_SecDetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[ContractPayMethodDetail initDicByModel:self.arr_SecDetailsDataArray[0]];
        fieldNames2 = [modelsDic allKeys];
        for (NSString *key in fieldNames2) {
            NSMutableArray  *array=[NSMutableArray array];
            for (ContractPayMethodDetail *model in self.arr_SecDetailsDataArray) {
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
            [Values2 addObject:array];
        }
        [Sa_ContractPayMethodDetail setObject:@"Sa_ContractPayMethodDetail" forKey:@"tableName"];
        [Sa_ContractPayMethodDetail setObject:fieldNames2 forKey:@"fieldNames"];
        [Sa_ContractPayMethodDetail setObject:Values2 forKey:@"fieldBigValues"];
    }else{
        [Sa_ContractPayMethodDetail setObject:@"Sa_ContractPayMethodDetail" forKey:@"tableName"];
        [Sa_ContractPayMethodDetail setObject:fieldNames2 forKey:@"fieldNames"];
        [Sa_ContractPayMethodDetail setObject:Values2 forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_ContractPayMethodDetail];
    
    
    NSMutableDictionary *Sa_ContractExpDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames3 = [NSArray array];
    NSMutableArray *Values3 = [NSMutableArray array];
    if (self.arr_ThirDetailsDataArray.count != 0) {
        NSMutableDictionary *modelsDic = [ContractYearExpDetail initDicByModel:self.arr_ThirDetailsDataArray[0]];
        fieldNames3 = [modelsDic allKeys];
        for (NSString *key in fieldNames3) {
            NSMutableArray  *array = [NSMutableArray array];
            for (ContractYearExpDetail *model in self.arr_ThirDetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values3 addObject:array];
        }
        [Sa_ContractExpDetail setObject:@"Sa_ContractExpDetail" forKey:@"tableName"];
        [Sa_ContractExpDetail setObject:fieldNames3 forKey:@"fieldNames"];
        [Sa_ContractExpDetail setObject:Values3 forKey:@"fieldBigValues"];
    }else{
        [Sa_ContractExpDetail setObject:@"Sa_ContractExpDetail" forKey:@"tableName"];
        [Sa_ContractExpDetail setObject:fieldNames3 forKey:@"fieldNames"];
        [Sa_ContractExpDetail setObject:Values3 forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_ContractExpDetail];
    
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_ContractApp"];
}

-(NSMutableArray *)arr_PartBType{
    if (_arr_PartBType == nil) {
        _arr_PartBType = [NSMutableArray array];
        NSArray *type = @[Custing(@"供应商", nil),Custing(@"客户", nil)];
        NSArray *code = @[@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_PartBType addObject:model];
        }
    }
    return _arr_PartBType;
}

@end
