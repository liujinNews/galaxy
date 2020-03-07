//
//  AccruedFormData.m
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "AccruedFormData.h"

@implementation AccruedFormData
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
    
    self.str_flowCode=@"F0039";
    self.arr_isShowmsArray = [[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"PaymentTypId",@"PaymentNumber",@"LocalCyAmount",@"CurrencyCode",@"ExchangeRate",@"PayMode",@"PaymentDate",@"ExpenseCode",@"ExpenseDesc",@"InvoiceType",@"TaxRate",@"Tax",@"FeeAppNumber",@"OverBudReason",@"PurchaseNumber",@"RelateContNo",@"ContractName",@"ContEffectiveDate",@"ContExpiryDate",@"ContPmtTyp",@"ProjId",@"ProjectActivityLv1Name",@"BnfId",@"ClientName",@"Beneficiary",@"VmsCode",@"BankHeadOffice",@"BankAccount",@"BankOutlets",@"IbanClientName",@"IbanClientAddr",@"IbanName",@"IbanAccount",@"IbanAddr",@"IbanSwiftCode",@"IbanNo",@"IbanADDRESS",@"RefInvoiceAmount",@"RefInvoiceType",@"RefTaxRate",@"RefTax",@"NoInvReason",@"Attachments",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Files",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.arr_CategoryArr = [NSMutableArray array];
    self.arr_PayCode = [NSMutableArray array];
    self.str_ExpenseCode = @"";
    self.str_ExpenseType = @"";
    self.str_ExpenseIcon = @"";
    self.str_ExpenseCatCode = @"";
    self.str_ExpenseCat = @"";
    
    self.str_HasInvoice = @"1";
    self.bool_ShareShow=NO;
    self.arr_ShareForm=[NSMutableArray array];
    self.arr_ShareData=[NSMutableArray array];
    self.arr_filesArray=[NSMutableArray array];
    self.arr_TolfilesArray=[NSMutableArray array];
    self.arr_PayCode = [NSMutableArray array];
    self.arr_table = [NSMutableArray array];
}

-(void)initializeHasData{
    
    self.str_flowCode = @"F0009";
    self.bool_isOpenDetail = NO;
    self.dict_budgetInfo = [NSMutableDictionary dictionary];
    self.arr_ShareForm = [NSMutableArray array];
    self.arr_ShareData = [NSMutableArray array];
    self.arr_ShareDeptSumData = [NSMutableArray array];
    self.bool_ShareShow = NO;
    self.arr_filesArray=[NSMutableArray array];
    self.arr_TolfilesArray=[NSMutableArray array];
    self.str_ReceiptOfInv = @"1";
    self.str_HasInvoice = @"1";
    self.str_DepositBank = (id)[NSNull null];
    self.str_BankAccount = (id)[NSNull null];
    
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",AccruedAppNewData];
    }else{
        return [NSString stringWithFormat:@"%@",AccruedAppHasData];
    }
}

-(void)DealWithFormBaseData{
    NSDictionary *result = [self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        //关联付款单请求参数(0单次 1多次)
        self.str_RelatedPaymentType = [[NSString stringWithFormat:@"%@",result[@"isRelatedMorePaymentApp"]] isEqualToString:@"1"] ? @"3":@"1";
        
        if (self.int_formStatus != 1) {
            //获取预算详情
            [self getFormBudgetInfoWithDict:result];
            
            if ([result[@"paymentContDetailDtoList"] isKindOfClass:[NSArray class]]) {
                self.arr_paymentContDetailDtoList = [NSMutableArray arrayWithArray:result[@"paymentContDetailDtoList"]];
            }
            if ([result[@"paymentPurDetails"] isKindOfClass:[NSArray class]]) {
                self.arr_paymentPurDetails = [NSMutableArray arrayWithArray:result[@"paymentPurDetails"]];
            }
            //是否是财务
            self.bool_isCashier = ((self.int_comeStatus == 3 || self.int_comeStatus == 4)&&[[NSString stringWithFormat:@"%@",result[@"isCashier"]]isEqualToString:@"1"]) ? YES:NO;
        }
        //获取币种
        [self getCurrencyData:result];
        
//        //付款方式
//        if ([result[@"paymentTyps"] isKindOfClass:[NSArray class]]) {
//            [ChooseCategoryModel getPayWayByArray:result[@"paymentTyps"] Array:self.arr_PayCode];
//        }
//        //合同付款方式
//        if ([result[@"contractPmtTyps"]isKindOfClass:[NSArray class]]) {
//            self.arr_ContPay = [NSMutableArray array];
//            [ChooseCategoryModel getNewPayWayByArray:[NSMutableArray arrayWithArray:result[@"contractPmtTyps"]] Array:self.arr_ContPay];
//        }
        //获取开启税额的费用类别
        [self getHasTaxExpenseList:result];
        
        //费用分摊是否必须要
//        self.bool_isPaymentShareRequire = [[NSString stringWithFormat:@"%@",result[@"isPaymentShareRequire"]]isEqualToString:@"1"] ? YES:NO;
//
//        //合同付款方式
//        self.int_isContractPaymentMethod = [[NSString stringWithFormat:@"%@",result[@"isContractPaymentMethod"]]isEqualToString:@"1"] ? 1:0;
//        //付款金额和合同金额完全一致才能提交
//        self.bool_IsSameAmount = [[NSString stringWithFormat:@"%@",result[@"isSameAmount"]]isEqualToString:@"1"] ? YES:NO;
//        //分期付款记录
//        if (self.int_isContractPaymentMethod == 1 && [result[@"paymentContDetailDtoList"] isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in result[@"paymentContDetailDtoList"]) {
//                if ([dict[@"amount"] floatValue] > 0) {
//                    self.model_ContractHas = [[ChooseCateFreModel alloc]init];
//                    self.model_ContractHas.gridOrder = [NSString stringWithIdOnNO:dict[@"contGridOrder"]];
//                    self.model_ContractHas.taskId = [NSString stringWithIdOnNO:dict[@"contTaskId"]];
//                    self.model_ContractHas.paidAmount = [NSString stringWithIdOnNO:dict[@"paidAmount"]];
//                    self.model_ContractHas.amount = [NSString stringWithIdOnNO:dict[@"paymentAmount"]];
//                    self.model_ContractHas.no = [NSString stringWithIdOnNO:dict[@"no"]];
//                    self.model_ContractHas.payDateStr = [NSString stringWithIdOnNO:dict[@"paymentDateStr"]];
//                }
//            }
//        }
        
        
        //预提明细数据
        self.bool_DetailsShow = [[NSString stringWithFormat:@"%@",result[@"accruedDetail"]] isEqualToString:@"1"] ? YES:NO;

        if (self.bool_DetailsShow) {
            self.arr_DetailsArray = [NSMutableArray array];
            if ([result[@"accruedExpDetailFields"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result[@"accruedExpDetailFields"]) {
                    MyProcurementModel *model = [[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.arr_DetailsArray addObject:model];
                }
            }
            self.arr_DetailsDataArray = [NSMutableArray array];
            if ([result[@"formData"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *formData = result[@"formData"];
                if ([formData[@"sa_AccruedExpDetail"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in formData[@"sa_AccruedExpDetail"]) {
                         AccruedReqDetail *model = [[AccruedReqDetail alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
//                         model.isIntegrity = [[NSString stringWithFormat:@"%@",model.isIntegrity] isEqualToString:@"1"] ? @"1":@"0";
                         [self.arr_DetailsDataArray addObject:model];
                     }
                }
            }
        }
        
        //获取分摊数据
//        [self getExpenseShareDataWithData:result WithParameter:@{@"ExpenseShare":@"sa_PaymentAppShare"}];
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:10];
                    
                    if ([dict[@"fieldName"]isEqualToString:@"LocalCyAmount"]) {
                        self.str_PaymentAmount = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ApplicationType"]) {
                        self.str_ApplicationType = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PaymentTypId"]) {
                        self.str_PayTypeId = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PaymentTyp"]) {
                        self.str_PayType = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PaymentNumber"]) {
                        self.str_RelPaymentNumber = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PaymentInfo"]) {
                        self.str_RelPaymentInfo = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayCode"]) {
                        self.str_PayCode = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayMode"]) {
                        self.str_PayMode = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayBankName"]) {
                        self.str_PayBankName = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayBankAccount"]) {
                        self.str_PayBankAccount = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayAccountName"]) {
                        self.str_PayAccountName = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"AccountItemCode"]) {
                        self.str_AccountItemCode = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"AccountItem"]) {
                        self.str_AccountItem= [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceType"]) {
                        self.str_InvoiceType = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceTypeName"]) {
                        self.str_InvoiceTypeName = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceTypeCode"]) {
                        self.str_InvoiceTypeCode = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"AirlineFuelFee"]) {
                        self.str_AirlineFuelFee = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"AirTicketPrice"]) {
                        self.str_AirTicketPrice = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"DevelopmentFund"]) {
                        self.str_DevelopmentFund = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"FuelSurcharge"]) {
                        self.str_FuelSurcharge = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"OtherTaxes"]) {
                        self.str_OtherTaxes = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FeeAppNumber"]) {
                        self.str_FeeAppNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"FeeAppInfo"]) {
                        self.str_FeeAppInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseNumber"]) {
                        self.str_PurchaseNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseInfo"]) {
                        self.str_PurchaseInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurAmount"]) {
                        self.str_PurAmount = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurOverAmount"]) {
                        self.str_PurOverAmount = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelateContFlowCode"]) {
                        self.str_RelateContFlowCode = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelateContNo"]) {
                        self.str_RelateContNo = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelateContInfo"]) {
                        self.str_RelateContInfo = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelateContTotalAmount"]) {
                        self.str_RelateContTotalAmount = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"RelateContAmountPaid"]) {
                        self.str_RelateContAmountPaid = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
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
                    if ([dict[@"fieldName"] isEqualToString:@"ContractAmount"]) {
                        self.str_ContractAmount = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContractOverAmount"]) {
                        self.str_ContractOverAmount = [NSString isEqualToNull:dict[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContPmtTypId"]) {
                        self.str_ContPmtTypId = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ContPmtTyp"]) {
                        self.str_ContPmtTyp = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BnfId"]) {
                        self.str_BnfId = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BnfName"]) {
                        self.str_BnfName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BeneficiaryId"]) {
                        self.personalData.SupplierId = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"Beneficiary"]) {
                        self.personalData.SupplierName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"VmsCode"]) {
                        self.str_VmsCode = [dict objectForKey:@"fieldValue"];
                    }
                    
                    if ([dict[@"fieldName"] isEqualToString:@"BankNo"]) {
                        self.str_BankNo = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankCode"]) {
                        self.str_BankCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"DepositBank"]) {
                        self.str_DepositBank = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"BankOutlets"]) {
                        self.str_BankOutlets = [dict objectForKey:@"fieldValue"];
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
                    if ([dict[@"fieldName"] isEqualToString:@"BankAccount"]) {
                        self.str_BankAccount = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
                    }
                    
                    
                    if ([dict[@"fieldName"]isEqualToString:@"RefInvoiceType"]) {
                        self.str_RefInvoiceType = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RefInvoiceTypeName"]) {
                        self.str_RefInvoiceTypeName = [NSString stringWithIdOnNO:dict[@"fieldValue"]] ;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RefInvoiceTypeCode"]) {
                        self.str_RefInvoiceTypeCode = [NSString stringWithIdOnNO:dict[@"fieldValue"]] ;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"HasInvoice"]) {
                        self.str_HasInvoice = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]isEqualToString:@"0"] ? @"0":@"1";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ShareDeptIds"]) {
                        self.str_ShareDeptIds = [NSString isEqualToNull:[dict objectForKey:@"fieldValue"]] ? [dict objectForKey:@"fieldValue"]:@"";
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"Files"]) {
                        if (![dict[@"fieldValue"] isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]];
                            for (NSDictionary *dict in array) {
                                [self.arr_TolfilesArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:self.arr_TolfilesArray WithImageArray:self.arr_filesArray WithMaxCount:10];
                        }
                    }
                    
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
    
    self.SubmitData=[[AccruedData alloc]init];
    
    self.SubmitData.OperatorUserId = self.personalData.OperatorUserId;
    self.SubmitData.Operator = self.personalData.Operator;
    self.SubmitData.OperatorDeptId = self.personalData.OperatorDeptId;
    self.SubmitData.OperatorDept = self.personalData.OperatorDept;
    self.SubmitData.RequestorUserId = self.personalData.RequestorUserId;
//    self.SubmitData.Requestor = self.personalData.Requestor;
    self.SubmitData.RequestorAccount = self.personalData.RequestorAccount;
    self.SubmitData.RequestorDeptId = self.personalData.RequestorDeptId;
    self.SubmitData.RequestorDept = self.personalData.RequestorDept;
        self.SubmitData.Requestor = self.personalData.Requestor;

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
//    self.SubmitData.IsCostCenterMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.CostCenterMgrUserId]] ? @"1":@"0";
//    self.SubmitData.RequestorBusDept = self.personalData.RequestorBusDept;
//    self.SubmitData.RequestorBusDeptId = self.personalData.RequestorBusDeptId;
    self.SubmitData.RequestorBusDept = self.personalData.RequestorBusDept;
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
//    self.SubmitData.ApproverId1 = self.personalData.ApproverId1;
//    self.SubmitData.ApproverId2 = self.personalData.ApproverId2;
//    self.SubmitData.ApproverId3 = self.personalData.ApproverId3;
//    self.SubmitData.ApproverId4 = self.personalData.ApproverId4;
//    self.SubmitData.ApproverId5 = self.personalData.ApproverId5;
    self.SubmitData.RequestorDate=self.personalData.RequestorDate;
    
    self.SubmitData.Attachments = (self.arr_totalFileArray.count!=0)?@"1":@"";
//    self.SubmitData.FirstHandlerUserId = self.str_firstHanderId;
//    self.SubmitData.FirstHandlerUserName = self.str_firstHanderName;
    self.SubmitData.CompanyId = self.personalData.CompanyId;
//    self.SubmitData.Reserved1 = self.model_ReserverModel.Reserverd1;
//    self.SubmitData.Reserved2 = self.model_ReserverModel.Reserverd2;
//    self.SubmitData.Reserved3 = self.model_ReserverModel.Reserverd3;
//    self.SubmitData.Reserved4 = self.model_ReserverModel.Reserverd4;
//    self.SubmitData.Reserved5 = self.model_ReserverModel.Reserverd5;
//    self.SubmitData.Reserved6 = self.model_ReserverModel.Reserverd6;
//    self.SubmitData.Reserved7 = self.model_ReserverModel.Reserverd7;
//    self.SubmitData.Reserved8 = self.model_ReserverModel.Reserverd8;
//    self.SubmitData.Reserved9 = self.model_ReserverModel.Reserverd9;
//    self.SubmitData.Reserved10 = self.model_ReserverModel.Reserverd10;
    self.SubmitData.CcUsersId = self.str_CcUsersId;
//    self.SubmitData.CcUsersName = self.str_CcUsersName;
    
    
    
//    self.SubmitData.PaymentTypId = self.str_PayTypeId;
//    self.SubmitData.PaymentTyp = self.str_PayType;
//    self.SubmitData.PaymentNumber = self.str_RelPaymentNumber;
//    self.SubmitData.PaymentInfo = self.str_RelPaymentInfo;
//    self.SubmitData.CurrencyCode = self.str_CurrencyCode;
//    self.SubmitData.Currency = self.str_Currency;
//    self.SubmitData.ExchangeRate = self.str_ExchangeRate;
//    self.SubmitData.PayCode = self.str_PayCode;
//    self.SubmitData.PayMode = self.str_PayMode;
//    self.SubmitData.ExpenseCode = self.str_ExpenseCode;
//    self.SubmitData.ExpenseType = self.str_ExpenseType;
//    self.SubmitData.ExpenseIcon = self.str_ExpenseIcon;
//    self.SubmitData.ExpenseCatCode = self.str_ExpenseCatCode;
//    self.SubmitData.ExpenseCat = self.str_ExpenseCat;
//    self.SubmitData.InvoiceType = self.str_InvoiceType;
//    self.SubmitData.InvoiceTypeName = self.str_InvoiceTypeName;
//    self.SubmitData.InvoiceTypeCode = self.str_InvoiceTypeCode;
//    self.SubmitData.FeeAppNumber = self.str_FeeAppNumber;
//    self.SubmitData.FeeAppInfo = self.str_FeeAppInfo;
//    self.SubmitData.EstimatedAmount = self.str_EstimatedAmount;
//    self.SubmitData.PurchaseNumber = self.str_PurchaseNumber;
//    self.SubmitData.PurchaseInfo = self.str_PurchaseInfo;
//    self.SubmitData.PurAmount = self.str_PurAmount;
//    self.SubmitData.PurOverAmount = self.str_PurOverAmount;
//    self.SubmitData.RelateContFlowCode = self.str_RelateContFlowCode;
//    self.SubmitData.RelateContNo = self.str_RelateContNo;
//    self.SubmitData.RelateContInfo = self.str_RelateContInfo;
//    self.SubmitData.RelateContTotalAmount = self.str_RelateContTotalAmount;
//    self.SubmitData.RelateContAmountPaid = self.str_RelateContAmountPaid;
//    self.SubmitData.ContractName = self.str_ContractName;
//    self.SubmitData.ContractNo = self.str_ContractNo;
//    self.SubmitData.ContractAppNumber = self.str_ContractAppNumber;
//    self.SubmitData.ContractAmount = self.str_ContractAmount;
//    self.SubmitData.ContractOverAmount = self.str_ContractOverAmount;
//    self.SubmitData.ContPmtTypId = self.str_ContPmtTypId;
//    self.SubmitData.ContPmtTyp = self.str_ContPmtTyp;
//    self.SubmitData.ProjId = self.personalData.ProjId;
//    self.SubmitData.ProjName = self.personalData.ProjName;
//    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
//    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
//    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";
//    self.SubmitData.ProjectActivityLv1 = self.personalData.ProjectActivityLv1;
//    self.SubmitData.ProjectActivityLv1Name = self.personalData.ProjectActivityLv1Name;
//    self.SubmitData.ProjectActivityLv2 = self.personalData.ProjectActivityLv2;
//    self.SubmitData.ProjectActivityLv2Name = self.personalData.ProjectActivityLv2Name;
//
//    self.SubmitData.BankNo = self.str_BankNo;
//    self.SubmitData.BankCode = self.str_BankCode;
//    self.SubmitData.DepositBank = self.str_DepositBank;
//    self.SubmitData.BankAccount = self.str_BankAccount;
//    self.SubmitData.BankOutlets = self.str_BankOutlets;
//    self.SubmitData.BankProvinceCode = self.str_BankProvinceCode;
//    self.SubmitData.BankProvince = self.str_BankProvince;
//    self.SubmitData.BankCityCode = self.str_BankCityCode;
//    self.SubmitData.BankCity = self.str_BankCity;
//    self.SubmitData.CNAPS = self.str_CNAPS;
//
//
//    self.SubmitData.BnfId = self.str_BnfId;
//    self.SubmitData.BnfName = self.str_BnfName;
//    self.SubmitData.VmsCode = self.str_VmsCode;
//    self.SubmitData.ClientId = self.personalData.ClientId;
//    self.SubmitData.ClientName = self.personalData.ClientName;
//    self.SubmitData.BeneficiaryId = self.personalData.SupplierId;
//    self.SubmitData.Beneficiary = self.personalData.SupplierName;
//    self.SubmitData.RefInvoiceType = self.str_RefInvoiceType;
//    self.SubmitData.RefInvoiceTypeName = self.str_RefInvoiceTypeName;
//    self.SubmitData.RefInvoiceTypeCode = self.str_RefInvoiceTypeCode;
//    self.SubmitData.HasInvoice = self.str_HasInvoice;
//    self.SubmitData.IsDeptBearExps = self.str_IsDeptBearExps;
//    self.SubmitData.Files = (self.arr_TolfilesArray.count!=0) ? @"1":@"";
//    self.SubmitData.AccountItemCode = self.str_AccountItemCode;
//    self.SubmitData.AccountItem = self.str_AccountItem;
//
//    self.SubmitData.BudgetInfo = @"";
//    self.SubmitData.Projbudinfo = @"";
//    self.SubmitData.IsOverBud = @"0";
//    self.SubmitData.Projbuddata = self.str_projbuddata;
//
//    self.SubmitData.CostShareApproval1 = (id)[NSNull null];
//    self.SubmitData.CostShareApproval2 = (id)[NSNull null];
//    self.SubmitData.CostShareApproval3 = (id)[NSNull null];
    
//    self.SubmitData.IsExpExpired = @"0";
    
    //分摊部门Id处理
    NSMutableArray *arr = [NSMutableArray array];
    for (ReimShareModel *model in self.arr_ShareData) {
        if ([NSString isEqualToNullAndZero:model.RequestorDeptId]) {
            [arr addObject:[NSString stringWithFormat:@"%@",model.RequestorDeptId]];
        }
    }
    self.arr_SubmitExpenseCodes = [NSMutableArray array];
    self.arr_SubmitExpenseTypes = [NSMutableArray array];
    for (AccruedReqDetail *detail in self.arr_DetailsDataArray) {
        if ([NSString isEqualToNull:detail.ExpenseCode]  && ![self.arr_SubmitExpenseCodes containsObject:[NSString stringWithFormat:@"%@",detail.ExpenseCode]]) {
            [self.arr_SubmitExpenseCodes addObject:[NSString stringWithFormat:@"%@",detail.ExpenseCode]];
        }
        if ([NSString isEqualToNull:detail.ExpenseType]  && ![self.arr_SubmitExpenseTypes containsObject:[NSString stringWithFormat:@"%@",detail.ExpenseType]]) {
            [self.arr_SubmitExpenseTypes addObject:[NSString stringWithFormat:@"%@",detail.ExpenseType]];
        }
    }
}
-(void)inModelHasApproveContent{
    [self inModelContent];
}
//MARK:必填项判断
-(NSString *)testModel{
    AccruedData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [AccruedData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if ([i isEqualToString:@"1"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if (![NSString isEqualToNull:str]) {
                returnTips = [self showerror:key];
                if ([NSString isEqualToNull:returnTips]) {
                    break ;
                }
            }
        }
    }
    if (![NSString isEqualToNull:returnTips]) {
        
        if ([NSString isEqualToNullAndZero:self.str_CurrencyCode] && ![[NSString stringWithFormat:@"%@",self.str_CurrencyCode]isEqualToString:@"CNY"] && ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"])) {
            returnTips = Custing(@"币种不是人民币，发票类型不能为铁路车票、航空行程单、公路、水路客票", nil);
            goto when_failed;
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
        showinfo =Custing(@"请选择机构", nil) ;
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入付款事由", nil);
    }else if([info isEqualToString:@"PaymentTypId"]) {
        showinfo = Custing(@"请选择付款类型", nil);
    }else if([info isEqualToString:@"PaymentNumber"]) {
        showinfo = Custing(@"请选择关联付款", nil);
    }else if([info isEqualToString:@"LocalCyAmount"]) {
        showinfo = Custing(@"请输入付款金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
    }else if([info isEqualToString:@"PayMode"]) {
        showinfo = Custing(@"请选择付款方式", nil);
    }else if([info isEqualToString:@"PaymentDate"]) {
        showinfo = Custing(@"请选择期望付款日期", nil);
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if([info isEqualToString:@"ExpenseDesc"]) {
        showinfo = Custing(@"请输入费用描述", nil);
    }else if([info isEqualToString:@"InvoiceType"] && [self.arr_hasTaxExpense containsObject:self.str_ExpenseCode]) {
        showinfo = Custing(@"请选择发票类型", nil);
    }
    //    else if([info isEqualToString:@"TaxRate"] && [self.str_InvoiceType isEqualToString:@"1"]) {
    //        showinfo = Custing(@"请选择税率", nil) ;
    //    }else if([info isEqualToString:@"Tax"] && [self.str_InvoiceType isEqualToString:@"1"]) {
    //        showinfo = Custing(@"请输入税额", nil) ;
    //    }
    else if([info isEqualToString:@"FeeAppNumber"]) {
        showinfo = Custing(@"请选择关联费用申请", nil);
    }else if([info isEqualToString:@"OverBudReason"]) {
        showinfo = Custing(@"请输入超预算原因", nil);
    }else if([info isEqualToString:@"PurchaseNumber"]) {
        showinfo = Custing(@"请选择关联采购申请", nil);
    }else if([info isEqualToString:@"RelateContNo"]) {
        showinfo = Custing(@"请选择合同/申请单", nil);
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo = Custing(@"请选择合同名称", nil);
    }else if([info isEqualToString:@"ContEffectiveDate"]) {
        showinfo = Custing(@"请选择合同开始日期", nil);
    }else if([info isEqualToString:@"ContExpiryDate"]) {
        showinfo = Custing(@"请选择合同截止日期", nil);
    }else if([info isEqualToString:@"ContPmtTyp"]) {
        showinfo = Custing(@"请选择合同付款方式", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ProjectActivityLv1Name"]) {
        showinfo = Custing(@"请选择项目活动", nil);
    }else if([info isEqualToString:@"BnfId"]) {
        showinfo = Custing(@"请选择受益人", nil);
    }else if([info isEqualToString:@"ClientName"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"Beneficiary"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"VmsCode"]) {
        showinfo = Custing(@"请输入VMS Code", nil);
    }else if([info isEqualToString:@"BankHeadOffice"]) {
        showinfo = Custing(@"请选择开户行总行名称", nil);
    }else if([info isEqualToString:@"BankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"BankOutlets"]) {
        showinfo = Custing(@"请选择开户网点", nil);
    }else if([info isEqualToString:@"IbanClientName"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入客户名称", nil);
    }else if([info isEqualToString:@"IbanClientAddr"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入客户地址", nil);
    }else if([info isEqualToString:@"IbanName"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入银行名称", nil);
    }else if([info isEqualToString:@"IbanAccount"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入IBAN/银行账号", nil);
    }else if([info isEqualToString:@"IbanAddr"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入银行地址", nil);
    }else if([info isEqualToString:@"IbanSwiftCode"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入SwiftCode", nil);
    }else if([info isEqualToString:@"IbanNo"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入行号", nil);
    }else if([info isEqualToString:@"IbanADDRESS"] && self.bool_isForeign) {
        showinfo = Custing(@"请输入ADDRESS", nil);
    }else if([info isEqualToString:@"RefInvoiceAmount"]) {
        showinfo = Custing(@"请输入发票金额", nil);
    }else if([info isEqualToString:@"RefInvoiceType"]) {
        showinfo = Custing(@"请选择发票类型", nil);
    }else if([info isEqualToString:@"RefTaxRate"]) {
        showinfo = Custing(@"请选择税率", nil);
    }else if([info isEqualToString:@"RefTax"]) {
        showinfo = Custing(@"请输入税额", nil);
    }else if([info isEqualToString:@"NoInvReason"] && [self.str_HasInvoice isEqualToString:@"0"]) {
        showinfo = Custing(@"请输入无发票原因", nil);
    }else if([info isEqualToString:@"Attachments"]) {
        showinfo = Custing(@"添加发票", nil);
    }else if([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
        showinfo =[[self.dict_isCtrlTypdic objectForKey:info] isEqualToString:@"text"]?[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[self.dict_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[self.dict_reservedDic objectForKey:info]];
    }else if([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if([info isEqualToString:@"Files"]) {
        showinfo = Custing(@"请选择附件", nil);
    }else if([info isEqualToString:@"FirstHandlerUserName"]) {
        showinfo = Custing(@"请选择审批人", nil);
    }else if([info isEqualToString:@"CcUsersName"]) {
        showinfo = Custing(@"请选择抄送人", nil);
    }
    return showinfo;
}
//MARK: 提交前关联主表和子表的数据
-(void)contectData{
    
    self.dict_parametersDict = [NSDictionary dictionary];
    NSMutableArray *mainArray = [NSMutableArray array];
    NSMutableDictionary *Sa_AccruedApp = [NSMutableDictionary dictionary];
    NSMutableArray *fieldNamesArr = [NSMutableArray array];
    NSMutableArray *fieldValuesArr = [NSMutableArray array];
    NSMutableDictionary *modelDic = [AccruedData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_AccruedApp setObject:@"Sa_AccruedApp" forKey:@"tableName"];
    [Sa_AccruedApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_AccruedApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_AccruedApp];
    
    //子表数据json化提交数组
    NSMutableArray *detailedArray = [NSMutableArray array];
    //预提明细
    NSMutableDictionary *Sa_AccruedExpDetail = [NSMutableDictionary dictionary];
    NSArray *fieldNames1 = [NSArray array];
    NSMutableArray *Values1 = [NSMutableArray array];
    if (self.arr_DetailsDataArray.count != 0) {
        NSMutableDictionary *modelsDic = [AccruedReqDetail initDicByModel:self.arr_DetailsDataArray[0]];
        [modelsDic removeObjectForKey:@"GridOrder"];
        fieldNames1 = [modelsDic allKeys];
        for (NSString *key in fieldNames1) {
            NSMutableArray  *array = [NSMutableArray array];
            for (AccruedReqDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values1 addObject:array];
        }
        [Sa_AccruedExpDetail setObject:@"Sa_AccruedExpDetail" forKey:@"tableName"];
        [Sa_AccruedExpDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_AccruedExpDetail setObject:Values1 forKey:@"fieldBigValues"];
    }else{
        [Sa_AccruedExpDetail setObject:@"Sa_AccruedExpDetail" forKey:@"tableName"];
        [Sa_AccruedExpDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_AccruedExpDetail setObject:Values1 forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_AccruedExpDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(void)contectHasDataWithTableName:(NSString *)tableName{
    NSMutableArray *FieldNames = [NSMutableArray arrayWithArray:@[@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate",@"IsReceiptOfInv"]];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId = @"";
    }
    NSMutableArray *FieldValues = [NSMutableArray arrayWithArray:@[self.str_twoHandeId,self.str_twoApprovalName,self.str_BudgetSubDate,self.str_ReceiptOfInv]];
    if (self.bool_isCashier) {
        [FieldNames addObjectsFromArray:@[@"DepositBank",@"BankAccount"]];
        [FieldValues addObjectsFromArray:@[self.str_DepositBank, self.str_BankAccount]];
    }
    if (self.int_formStatus == 3) {
        [FieldNames addObjectsFromArray:@[@"IsOverBud"]];
        [FieldValues addObjectsFromArray:@[self.dict_JudgeAmount[@"IsOverBud"]]];
    }
    NSDictionary *Dict = @{@"fieldNames":FieldNames,@"fieldValues":FieldValues,@"tableName":tableName};
    NSArray *mainArray = [NSArray arrayWithObjects:Dict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}
-(void)contectHasPayDataWithTableName:(NSString *)tableName{
    
    NSMutableArray *FieldNames = [NSMutableArray arrayWithArray:@[@"twohandleruserid",@"twohandlerusername",@"BudgetSubDate",@"IsReceiptOfInv"]];
    NSMutableArray *FieldValues = [NSMutableArray arrayWithArray:@[@"",@"",self.str_BudgetSubDate,self.str_ReceiptOfInv]];
    if (self.bool_isCashier) {
        [FieldNames addObjectsFromArray:@[@"DepositBank",@"BankAccount"]];
        [FieldValues addObjectsFromArray:@[self.str_DepositBank, self.str_BankAccount]];
    }
    if (self.int_formStatus == 3) {
        [FieldNames addObjectsFromArray:@[@"IsOverBud"]];
        [FieldValues addObjectsFromArray:@[self.dict_JudgeAmount[@"IsOverBud"]]];
    }
    NSDictionary *Dict=@{@"fieldNames":FieldNames,@"fieldValues":FieldValues,@"tableName":tableName};
    NSArray *mainArray = [NSArray arrayWithObjects:Dict, nil];
    self.dict_parametersDict= @{@"mainDataList":mainArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_AccruedApp"];
}
-(NSString *)getCommonField{
//    NSDictionary *dict=@{@"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
//    return [NSString transformToJson:dict];
    return nil;
}
-(NSDictionary *)getCheckSubmitOtherPar{
    NSString *OtherFlowCode = @"";
    NSString *OtherTaskId = @"";
    if ([self.str_FeeAppNumber floatValue] > 0) {
        OtherFlowCode = @"F0012";
        OtherTaskId = self.str_FeeAppNumber;
    }
    NSString *PaymentExpDetails = @"";
    if (self.arr_DetailsDataArray &&self.arr_DetailsDataArray.count != 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (AccruedReqDetail *model in self.arr_DetailsDataArray) {
            [array addObject:[AccruedReqDetail initDicByModel:model]];
        }
        PaymentExpDetails = [NSString transformToJson:array];
    }
    
    return  @{@"OtherTaskId":OtherTaskId,
              @"OtherFlowCode":OtherFlowCode,
              @"PaymentExpDetails":PaymentExpDetails,
              @"PaymentTyp":self.str_PayType,
              @"RelateContNo":self.str_RelateContNo
              };
}

-(NSString *)getContractFormsUrl{
    return PaymentAppGetContractFormsByTaskId;
}
-(NSDictionary *)getContractFormsParame{
    return @{@"ContTaskId":self.str_ContractAppNumber,@"TaskId":self.str_taskId};
}
-(void )dealContractFormsWithDict:(NSDictionary *)responceDic{
    //Sa_AccruedExpDetail
    if ([responceDic[@"result"] isKindOfClass:[NSArray class]] && [responceDic[@"result"] count] > 0) {
        NSMutableDictionary *Sa_PaymentContDetail = [NSMutableDictionary dictionary];
        [Sa_PaymentContDetail setObject:@"Sa_PaymentContDetail" forKey:@"tableName"];
        [Sa_PaymentContDetail setObject:@[@"no",@"paymentdate",@"paymentamount",@"paidamount",@"amount",@"conttaskid",@"contgridorder"] forKey:@"fieldNames"];
        NSMutableArray *arr_no = [NSMutableArray array];
        NSMutableArray *arr_paymentdate = [NSMutableArray array];
        NSMutableArray *arr_paymentamount = [NSMutableArray array];
        NSMutableArray *arr_paidamount = [NSMutableArray array];
        NSMutableArray *arr_amount = [NSMutableArray array];
        NSMutableArray *arr_conttaskid = [NSMutableArray array];
        NSMutableArray *arr_contgridorder = [NSMutableArray array];
        for (NSDictionary *dict in responceDic[@"result"]) {
            [arr_no addObject:dict[@"no"]];
            [arr_paymentdate addObject:dict[@"paymentDate"]];
            [arr_paymentamount addObject:dict[@"paymentAmount"]];
            [arr_paidamount addObject:dict[@"paidAmount"]];
            [arr_conttaskid addObject:dict[@"contTaskId"]];
            [arr_contgridorder addObject:dict[@"contGridOrder"]];
            if ([dict[@"contGridOrder"] integerValue] == [self.model_ContractHas.gridOrder integerValue]) {
//                if (![NSString isEqualToNull:self.SubmitData.LocalCyAmount]) {
//                    [arr_amount addObject:[GPUtils decimalNumberSubWithString:dict[@"paymentAmount"] with:dict[@"paidAmount"]]];
//                }else{
//                    [arr_amount addObject:[NSString isEqualToNull:self.SubmitData.LocalCyAmount] ? self.SubmitData.LocalCyAmount:@"0"];
//                }
                self.bool_isSameContract = YES;
            }else{
                [arr_amount addObject:dict[@"amount"]];
            }
        }
        [Sa_PaymentContDetail setObject:@[arr_no,arr_paymentdate,arr_paymentamount,arr_paidamount,arr_amount,arr_conttaskid,arr_contgridorder] forKey:@"fieldBigValues"];
        
        NSMutableArray *mainArray = self.dict_parametersDict[@"mainDataList"];
        NSMutableArray *detailedArray = self.dict_parametersDict[@"detailedDataList"];
        [detailedArray addObject:Sa_PaymentContDetail];
        self.dict_parametersDict = @{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
    }
}


@end
