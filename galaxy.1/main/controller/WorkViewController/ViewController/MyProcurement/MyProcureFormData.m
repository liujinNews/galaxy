//
//  MyProcureFormData.m
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MyProcureFormData.h"


@implementation MyProcureFormData
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
    
    self.str_flowCode=@"F0005";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"PurchaseType",@"ProjId",@"SupplierId",@"DetailList",@"SecondDetailList",@"ThirdDetailList",@"FourthDetailList",@"PayMode",@"DeliveryDate",@"TotalAmount",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];

    self.arr_procureType=[NSMutableArray array];
    self.arr_payWay=[NSMutableArray array];
    self.arr_CategoryArr=[NSMutableArray array];
    self.str_PurchaseType=@"";
    self.str_PurchaseCode=@"";
    self.str_PayMode=@"";
    self.str_PayCode=@"";
    self.str_TotalMoney=@"";
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0005";
    self.bool_isOpenDetail=NO;
    self.bool_SecisOpenDetail = NO;
    self.bool_ThirisOpenDetail = NO;
    self.bool_FourisOpenDetail = NO;
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",ProcurementrequestList];
    }else{
        return [NSString stringWithFormat:@"%@",HasProcurementList];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        if (self.int_formStatus==1) {
            //是否需要采购模板
            self.bool_PurchaseTpl=[result[@"isPurchaseTpl"] floatValue]==1 ? YES:NO;
            if (self.int_comeStatus==1&&[result[@"itemTpl"] isKindOfClass:[NSDictionary class]]) {
                self.dict_DefaultTpl=result[@"itemTpl"];
            }
            //支付方式
            if ([result[@"paymentTyps"] isKindOfClass:[NSArray class]]) {
                [ChooseCategoryModel getPayWayByArray:result[@"paymentTyps"] Array:self.arr_payWay];
            }
            //采购方式
            NSArray *purchaseTyps=result[@"purchaseTyps"];
            if (purchaseTyps.count!=0) {
                [ChooseCategoryModel getpurchaseTypeByArray:purchaseTyps Array:_arr_procureType];
            }
        }
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            self.bool_DetailsShow=YES;
//            if ([NSString isEqualToNullAndZero:result[@"purchaseDetail"]]) {
//                self.bool_DetailsShow=[result[@"purchaseDetail"] boolValue];
                [self getFirGroupDetail:formDict];
//            }
//            判读是否显示采购金额明细
            if ([NSString isEqualToNullAndZero:result[@"purchaseAmountDetail"]]) {
                self.bool_SecDetailsShow=result[@"purchaseAmountDetail"];
                [self getSecGroupDetail:formDict WithTableName:@"purchaseAmountDetailFieldsFId"];
            }
//            判断是否显示采购内容明细
            if ([NSString isEqualToNullAndZero:result[@"purchaseBusinessDetail"]]) {
                self.bool_ThirDetailsShow = result[@"purchaseBusinessDetail"];
                [self getThirGroupDetail:formDict WithTableName:@"purchaseBusinessDetailFieldsFId"];
            }
//            判断是否显示单一采购来源清单显示
            if ([NSString isEqualToNullAndZero:result[@"purchaseSourceDetail"]]) {
                self.bool_FouDetailsShow = result[@"purchaseSourceDetail"];
                [self getFouGroupDetail:formDict WithTableName:@"purchaseSourceDetailFieldsFId"];
            }
            self.bool_DetailsShow=(self.arr_DetailsArray.count>0?YES:NO);
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"]isEqualToString:@"PurchaseCode"]) {
                        _str_PurchaseCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"PayCode"]) {
                        _str_PayCode=[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]];
                    }
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *sa_ChopAppDetailArray=formDataDict[@"sa_PurchaseDetail"];
            for (NSDictionary *dict in sa_ChopAppDetailArray) {
                DeatilsModel *model=[[DeatilsModel alloc]init];
                if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
                    model.Name=[NSString stringWithFormat:@"%@",dict[@"name"]];
                }
                if (![dict[@"brand"] isKindOfClass:[NSNull class]]) {
                    model.Brand=[NSString stringWithFormat:@"%@",dict[@"brand"]];
                }
                if (![dict[@"size"] isKindOfClass:[NSNull class]]) {
                    model.Size=[NSString stringWithFormat:@"%@",dict[@"size"]];
                }
                if (![dict[@"qty"] isKindOfClass:[NSNull class]]) {
                    model.Qty=[NSString stringWithFormat:@"%@",dict[@"qty"]];
                }
                if (![dict[@"unit"] isKindOfClass:[NSNull class]]) {
                    model.Unit=[NSString stringWithFormat:@"%@",dict[@"unit"]];
                }
                if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                    model.Amount = [NSString reviseString:dict[@"amount"]];
                }
                if (![dict[@"price"] isKindOfClass:[NSNull class]]) {
                    model.Price = [NSString reviseString:dict[@"price"]];
                }
                if (![dict[@"supplierId"] isKindOfClass:[NSNull class]]) {
                    model.SupplierId=[NSString stringWithFormat:@"%@",dict[@"supplierId"]];
                }
                if (![dict[@"supplierName"] isKindOfClass:[NSNull class]]) {
                    model.SupplierName = [NSString stringWithFormat:@"%@",dict[@"supplierName"]];
                }
                if (![dict[@"purchaseType"] isKindOfClass:[NSNull class]]) {
                    model.PurchaseType = [NSString stringWithFormat:@"%@",dict[@"purchaseType"]];
                }
                if (![dict[@"remark"] isKindOfClass:[NSNull class]]) {
                    model.Remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
                }
                if (![dict[@"tplId"] isKindOfClass:[NSNull class]]) {
                    model.TplId=[NSString stringWithFormat:@"%@",dict[@"tplId"]];
                }
                if (![dict[@"tplName"] isKindOfClass:[NSNull class]]) {
                    model.TplName=[NSString stringWithFormat:@"%@",dict[@"tplName"]];
                }
                if (![dict[@"itemId"] isKindOfClass:[NSNull class]]) {
                    model.ItemId=[NSString stringWithFormat:@"%@",dict[@"itemId"]];
                }
                if (![dict[@"itemCatId"] isKindOfClass:[NSNull class]]) {
                    model.ItemCatId=[NSString stringWithFormat:@"%@",dict[@"itemCatId"]];
                }
                if (![dict[@"itemCatName"] isKindOfClass:[NSNull class]]) {
                    model.ItemCatName=[NSString stringWithFormat:@"%@",dict[@"itemCatName"]];
                }
                if (![dict[@"code"] isKindOfClass:[NSNull class]]) {
                    model.Code=[NSString stringWithFormat:@"%@",dict[@"code"]];
                }
                [self.arr_DetailsDataArray addObject:model];
            }
        }
        [self dealWithDetailDataWithDic:formDataDict WithTableName:@"sa_PurchaseAmountDetail"];
        [self dealWithDetailDataWithDic:formDataDict WithTableName:@"sa_PurchaseBusinessDetail"];
        [self dealWithDetailDataWithDic:formDataDict WithTableName:@"sa_PurchaseSourceDetail"];
    }
}
//接收明细数据
- (void)dealWithDetailDataWithDic:(NSDictionary *)dic WithTableName:(NSString *)tableName{
    NSMutableArray *mutArr = [NSMutableArray array];
    if (![dic isKindOfClass:[NSNull class]]) {
        NSArray *sa_ChopAppDetailArray=[NSArray arrayWithArray:[dic objectForKey:tableName]];
        for (NSDictionary *dict in sa_ChopAppDetailArray) {
            DeatilsModel *model=[[DeatilsModel alloc]init];
            if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
                model.Name=[NSString stringWithFormat:@"%@",dict[@"name"]];
            }
            if (![dict[@"brand"] isKindOfClass:[NSNull class]]) {
                model.Brand=[NSString stringWithFormat:@"%@",dict[@"brand"]];
            }
            if (![dict[@"size"] isKindOfClass:[NSNull class]]) {
                model.Size=[NSString stringWithFormat:@"%@",dict[@"size"]];
            }
            if (![dict[@"qty"] isKindOfClass:[NSNull class]]) {
                model.Qty=[NSString stringWithFormat:@"%@",dict[@"qty"]];
            }
            if (![dict[@"unit"] isKindOfClass:[NSNull class]]) {
                model.Unit=[NSString stringWithFormat:@"%@",dict[@"unit"]];
            }
            if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                model.Amount = [NSString reviseString:dict[@"amount"]];
            }
            if (![dict[@"price"] isKindOfClass:[NSNull class]]) {
                model.Price = [NSString reviseString:dict[@"price"]];
            }
            if (![dict[@"supplierId"] isKindOfClass:[NSNull class]]) {
                model.SupplierId=[NSString stringWithFormat:@"%@",dict[@"supplierId"]];
            }
            if (![dict[@"supplierName"] isKindOfClass:[NSNull class]]) {
                model.SupplierName = [NSString stringWithFormat:@"%@",dict[@"supplierName"]];
            }
            if (![dict[@"purchaseType"] isKindOfClass:[NSNull class]]) {
                model.PurchaseType = [NSString stringWithFormat:@"%@",dict[@"purchaseType"]];
            }
            if (![dict[@"remark"] isKindOfClass:[NSNull class]]) {
                model.Remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
            }
            if (![dict[@"tplId"] isKindOfClass:[NSNull class]]) {
                model.TplId=[NSString stringWithFormat:@"%@",dict[@"tplId"]];
            }
            if (![dict[@"tplName"] isKindOfClass:[NSNull class]]) {
                model.TplName=[NSString stringWithFormat:@"%@",dict[@"tplName"]];
            }
            if (![dict[@"itemId"] isKindOfClass:[NSNull class]]) {
                model.ItemId=[NSString stringWithFormat:@"%@",dict[@"itemId"]];
            }
            if (![dict[@"itemCatId"] isKindOfClass:[NSNull class]]) {
                model.ItemCatId=[NSString stringWithFormat:@"%@",dict[@"itemCatId"]];
            }
            if (![dict[@"itemCatName"] isKindOfClass:[NSNull class]]) {
                model.ItemCatName=[NSString stringWithFormat:@"%@",dict[@"itemCatName"]];
            }
            if (![dict[@"code"] isKindOfClass:[NSNull class]]) {
                model.Code=[NSString stringWithFormat:@"%@",dict[@"code"]];
            }
            if (![dict[@"description"] isKindOfClass:[NSNull class]]) {
                model.Description=[NSString stringWithFormat:@"%@",dict[@"description"]];
            }
            if (![dict[@"currencyCode"] isKindOfClass:[NSNull class]]) {
                model.CurrencyCode=[NSString stringWithFormat:@"%@",dict[@"currencyCode"]];
            }
            if (![dict[@"currency"] isKindOfClass:[NSNull class]]) {
                model.Currency=[NSString stringWithFormat:@"%@",dict[@"currency"]];
            }
            if (![dict[@"exchangeRate"] isKindOfClass:[NSNull class]]) {
                model.ExchangeRate=[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]];
            }
            if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                model.Amount=[NSString stringWithFormat:@"%@",dict[@"amount"]];
            }
            if (![dict[@"localCyAmount"] isKindOfClass:[NSNull class]]) {
                model.LocalCyAmount=[NSString stringWithFormat:@"%@",dict[@"localCyAmount"]];
            }
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
//            if (![dict[@"feeAppNumber"] isKindOfClass:[NSNull class]]) {
//                model.FeeAppNumber=[NSString stringWithFormat:@"%@",dict[@"feeAppNumber"]];
//            }
            if (![dict[@"feeAppInfo"] isKindOfClass:[NSNull class]]) {
                model.FeeAppInfo=[NSString stringWithFormat:@"%@",dict[@"feeAppInfo"]];
            }
            if (![dict[@"businessRequirement"] isKindOfClass:[NSNull class]]) {
                model.BusinessRequirement=[NSString stringWithFormat:@"%@",dict[@"businessRequirement"]];
            }
            if (![dict[@"techRequirement"] isKindOfClass:[NSNull class]]) {
                model.TechRequirement=[NSString stringWithFormat:@"%@",dict[@"techRequirement"]];
            }
            if (![dict[@"serviceRequirement"] isKindOfClass:[NSNull class]]) {
                model.ServiceRequirement=[NSString stringWithFormat:@"%@",dict[@"serviceRequirement"]];
            }
            if (![dict[@"attachments"] isKindOfClass:[NSNull class]]) {
                model.Attachments=[NSString stringWithFormat:@"%@",dict[@"attachments"]];
            }
            if (![dict[@"supplierName"] isKindOfClass:[NSNull class]]) {
                model.SupplierName=[NSString stringWithFormat:@"%@",dict[@"supplierName"]];
            }
            if (![dict[@"isCrossDepartment"] isKindOfClass:[NSNull class]]) {
                model.IsCrossDepartment=[NSString stringWithFormat:@"%@",dict[@"isCrossDepartment"]];
            }
            if (![dict[@"reason"] isKindOfClass:[NSNull class]]) {
                model.Reason=[NSString stringWithFormat:@"%@",dict[@"reason"]];
            }
            if(![dict[@"no"] isKindOfClass:[NSNull class]]){
                model.No = [NSString stringWithFormat:@"%@",dict[@"no"]];
            }
            if(![dict[@"remarks"] isKindOfClass:[NSNull class]]){
                model.Remarks = [NSString stringWithFormat:@"%@",dict[@"remarks"]];
            }
            [mutArr addObject:model];
        }
    }
    if ([tableName isEqualToString:@"sa_PurchaseAmountDetail"]) {
        self.arr_SecDetailsDataArray = mutArr;
    }else if ([tableName isEqualToString:@"sa_PurchaseBusinessDetail"]){
        self.arr_ThirDetailsDataArray = mutArr;
    }else if([tableName isEqualToString:@"sa_PurchaseSourceDetail"]){
        self.arr_FouDetailsDataArray = mutArr;
    }
}


-(void)initProcureItemDate{
    if (self.int_comeStatus==1&&self.dict_DefaultTpl) {
        NSString *purTplId=[NSString stringWithIdOnNO:self.dict_DefaultTpl[@"id"]];
        NSString *purTplName=[NSString stringWithIdOnNO:self.dict_DefaultTpl[@"name"]];
        if ([self.dict_DefaultTpl[@"items"] isKindOfClass:[NSArray class]]) {
            NSArray *array=self.dict_DefaultTpl[@"items"];
            for (NSDictionary *dict in array) {
                DeatilsModel *modelD=[[DeatilsModel alloc]init];
                modelD.ItemId = [NSString stringWithIdOnNO:dict[@"id"]];
                modelD.ItemCatId = [NSString stringWithIdOnNO:dict[@"catId"]];
                modelD.ItemCatName = [NSString stringWithIdOnNO:dict[@"cat"]];
                modelD.Size = [NSString stringWithIdOnNO:dict[@"size"]];
                modelD.Name = [NSString stringWithIdOnNO:dict[@"name"]];
                modelD.Brand = [NSString stringWithIdOnNO:dict[@"brand"]];
                modelD.Unit = [NSString stringWithIdOnNO:dict[@"unit"]];
                modelD.TplId=purTplId;
                modelD.TplName=purTplName;
                [self.arr_DetailsDataArray addObject:modelD];
            }
        }else{
            DeatilsModel *model=[[DeatilsModel alloc]init];
            [self.arr_DetailsDataArray addObject:model];
        }
    }else{
        if (self.arr_DetailsDataArray.count==0) {
            DeatilsModel *model=[[DeatilsModel alloc]init];
            [self.arr_DetailsDataArray addObject:model];
        }
    }
}
-(void)inModelContent{
    
    self.SubmitData=[[MyProcureData alloc]init];
    
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

    
    self.SubmitData.PurchaseType=self.str_PurchaseType;
    self.SubmitData.PurchaseCode=self.str_PurchaseCode;
    self.SubmitData.TotalAmount = self.str_TotalMoney;
    self.SubmitData.PayMode=self.str_PayMode;
    self.SubmitData.PayCode=self.str_PayCode;
    
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";
//    self.SubmitData.FeeAppNumber = self.str_FeeAppNumber;
//    self.SubmitData.FeeAppInfo = self.str_FeeAppInfo;
//    self.SubmitData.FormScope = self.str_FormScope;
}

-(NSString *)testModel{
    MyProcureData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [MyProcureData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (DeatilsModel *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Name"]){
                            detailStr=model.Name;
                        }else if ([str isEqualToString:@"Brand"]){
                            detailStr=model.Brand;
                        }else if ([str isEqualToString:@"Size"]){
                            detailStr=model.Size;
                        }else if ([str isEqualToString:@"Qty"]){
                            detailStr=model.Qty;
                        }else if ([str isEqualToString:@"Unit"]){
                            detailStr=model.Unit;
                        }else if ([str isEqualToString:@"Price"]){
                            detailStr=model.Price;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }else if ([str isEqualToString:@"SupplierId"]){
                            detailStr=model.SupplierId;
                        }else if ([str isEqualToString:@"PurchaseType"]){
                            detailStr=model.PurchaseType;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
            
        }else if ([key isEqualToString:@"SecondDetailList"]){
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_SecisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (DeatilsModel *model in self.arr_SecDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Name"]){
                            detailStr=model.Name;
                        }else if ([str isEqualToString:@"Brand"]){
                            detailStr=model.Brand;
                        }else if ([str isEqualToString:@"Size"]){
                            detailStr=model.Size;
                        }else if ([str isEqualToString:@"Qty"]){
                            detailStr=model.Qty;
                        }else if ([str isEqualToString:@"Unit"]){
                            detailStr=model.Unit;
                        }else if ([str isEqualToString:@"Price"]){
                            detailStr=model.Price;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }else if ([str isEqualToString:@"SupplierId"]){
                            detailStr=model.SupplierId;
                        }else if ([str isEqualToString:@"PurchaseType"]){
                            detailStr=model.PurchaseType;
                        }else if ([str isEqualToString:@"Remarks"]){
                            detailStr=model.Remarks;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showErrorSecondDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"ThirdDetailList"]){
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_ThirisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (DeatilsModel *model in self.arr_ThirDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"No"]){
                            detailStr=model.No;
                        }else if ([str isEqualToString:@"Description"]){
                            detailStr=model.Description;
                        }else if ([str isEqualToString:@"BusinessRequirement"]){
                            detailStr=model.BusinessRequirement;
                        }else if ([str isEqualToString:@"TechRequirement"]){
                            detailStr=model.TechRequirement;
                        }else if ([str isEqualToString:@"ServiceRequirement"]){
                            detailStr=model.ServiceRequirement;
                        }else if ([str isEqualToString:@"Attachments"]){
                            detailStr=model.Attachments;
                        }else if ([str isEqualToString:@"Remarks"]){
                            detailStr=model.Remarks;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showErrorThirdDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"FourthDetailList"]){
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_FouisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (DeatilsModel *model in self.arr_FouDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"No"]){
                            detailStr=model.No;
                        }else if ([str isEqualToString:@"Brand"]){
                            detailStr=model.Brand;
                        }else if ([str isEqualToString:@"Size"]){
                            detailStr=model.Size;
                        }else if ([str isEqualToString:@"Qty"]){
                            detailStr=model.Qty;
                        }else if ([str isEqualToString:@"Unit"]){
                            detailStr=model.Unit;
                        }else if ([str isEqualToString:@"Price"]){
                            detailStr=model.Price;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }else if ([str isEqualToString:@"SupplierId"]){
                            detailStr=model.SupplierId;
                        }else if ([str isEqualToString:@"PurchaseType"]){
                            detailStr=model.PurchaseType;
                        }else if ([str isEqualToString:@"Remarks"]){
                            detailStr=model.Remarks;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showErrorSFourthDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }
        else{
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
        showinfo = Custing(@"请输入采购事由", nil);
    }else if([info isEqualToString:@"PurchaseType"]) {
        showinfo = Custing(@"请选择采购类型", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"PayMode"]) {
        showinfo = Custing(@"请选择支付方式", nil);
    }else if([info isEqualToString:@"DeliveryDate"]) {
        showinfo = Custing(@"请选择期望交货日期", nil);
    }else if([info isEqualToString:@"TotalAmount"]) {
        showinfo = Custing(@"采购金额不能为空", nil);
    }else if([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if([info isEqualToString:@"Attachments"]) {
        showinfo = Custing(@"请选择附件", nil);
    }else if ([info isEqualToString:@"FormScope"]){
        showinfo = Custing(@"请选择单据可见范围", nil);
    }else if([info isEqualToString:@"FeeAppNumber"]){
        showinfo = Custing(@"请选择关联费用申请", nil);
    }
    else if([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
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
    if ([info isEqualToString:@"Name"]) {
        showinfo = Custing(@"请输入产品", nil);
    }else if ([info isEqualToString:@"Brand"]) {
        showinfo = Custing(@"请输入品牌", nil);
    }else if ([info isEqualToString:@"Size"]) {
        showinfo = Custing(@"请输入规格", nil);
    }else if ([info isEqualToString:@"Qty"]) {
        showinfo = Custing(@"请输入数量", nil);
    }else if ([info isEqualToString:@"Unit"]) {
        showinfo =Custing(@"请输入单位", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入单价", nil);
    }else if ([info isEqualToString:@"Price"]) {
        showinfo = Custing(@"请输入金额", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入明细备注", nil);
    }else if ([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择明细供应商", nil);
    }else if ([info isEqualToString:@"PurchaseType"]) {
        showinfo = Custing(@"请选择采购类型", nil);
    }
    return showinfo;
}
//金额明细表报错
- (NSString *)showErrorSecondDetail:(NSString *)info{
    NSString *showInfo = nil;
    if ([info isEqualToString:@"No"]) {
        showInfo = Custing(@"请输入序号", nil);
    }else if ([info isEqualToString:@"Description"]){
        showInfo = Custing(@"请输入采购名称", nil);
    }else if ([info isEqualToString:@"CurrencyCode"]){
        showInfo = Custing(@"请输入币种", nil);
    }else if ([info isEqualToString:@"Currency"]){
        showInfo = Custing(@"请输入币种", nil);
    }else if ([info isEqualToString:@"ExchangeRate"]){
        showInfo = Custing(@"请输入汇率", nil);
    }else if ([info isEqualToString:@"Amount"]){
        showInfo = Custing(@"请输入金额", nil);
    }else if ([info isEqualToString:@"LocalCyAmount"]){
        showInfo = Custing(@"请输入本位币", nil);
    }else if ([info isEqualToString:@"ExpenseCode"]){
        showInfo = Custing(@"请输入费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseType"]){
        showInfo = Custing(@"请输入费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseIcon"]){
        showInfo = Custing(@"请输入费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseCatCode"]){
        showInfo = Custing(@"请输入费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseCat"]){
        showInfo = Custing(@"请输入费用类别", nil);
    }else if ([info isEqualToString:@"FeeAppNumber"]){
        showInfo = Custing(@"请输入关联费用申请", nil);
    }else if ([info isEqualToString:@"FeeAppInfo"]){
        showInfo = Custing(@"请输入关联费用申请", nil);
    }
    return showInfo;
}
//内容表报错
- (NSString *)showErrorThirdDetail:(NSString *)info{
    NSString *showInfo = nil;
    if ([info isEqualToString:@"No"]) {
        showInfo = Custing(@"请输入序号", nil);
    }else if ([info isEqualToString:@"Description"]){
        showInfo = Custing(@"请输入采购项目名称", nil);
    }else if ([info isEqualToString:@"BusinessRequirement"]){
        showInfo = Custing(@"请输入具体功能/业务需求", nil);
    }else if ([info isEqualToString:@"TechRequirement"]){
        showInfo = Custing(@"请输入具体技术需求", nil);
    }else if ([info isEqualToString:@"ServiceRequirement"]){
        showInfo = Custing(@"请输入服务需求及其他", nil);
    }else if ([info isEqualToString:@"Attachments"]){
        showInfo = Custing(@"请添加附件", nil);
    }
    return showInfo;
}
//单一采购来源表报错
- (NSString *)showErrorSFourthDetail:(NSString *)info{
    NSString *showInfo = nil;
    if ([info isEqualToString:@"No"]) {
        showInfo = Custing(@"请输入序号", nil);
    }else if ([info isEqualToString:@"Description"]){
        showInfo = Custing(@"请输入采购项目名称", nil);
    }else if ([info isEqualToString:@"SupplierName"]){
        showInfo = Custing(@"请输入供应商", nil);
    }else if ([info isEqualToString:@"IsCrossDepartment"]){
        showInfo = Custing(@"请选择是否跨部门", nil);
    }else if ([info isEqualToString:@"Reason"]){
        showInfo = Custing(@"请输入单一来源原因", nil);
    }else if ([info isEqualToString:@"Attachments"]){
        showInfo = Custing(@"请添加附件", nil);
    }
    return showInfo;
}

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_PurchaseApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[MyProcureData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_PurchaseApp setObject:@"Sa_PurchaseApp" forKey:@"tableName"];
    [Sa_PurchaseApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_PurchaseApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_PurchaseApp];
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    self.detailedArray = detailedArray;
    NSMutableDictionary *Sa_PurchaseDetail = [[NSMutableDictionary alloc]init];
//    NSArray *fieldNames = [NSArray array];
    NSArray *fieldNames = [NSArray arrayWithObjects:@"Name",@"Brand",@"Size",@"Qty",@"Unit",@"Amount",@"Price",@"SupplierId",@"SupplierName",@"PurchaseType",@"Remark",@"Attachments",@"TplId",@"TplName",@"ItemId",@"ItemCatId",@"ItemCatName",@"Code", nil];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
//        NSMutableDictionary *modelsDic=[DeatilsModel initDicByModel:self.arr_DetailsDataArray[0]];
//        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (DeatilsModel *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_PurchaseDetail setObject:@"Sa_PurchaseDetail" forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_PurchaseDetail setObject:@"Sa_PurchaseDetail" forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_PurchaseDetail];
   
//    采购金额明细表
    [self contectPurchaseArr:self.arr_SecDetailsDataArray withTableName:@"Sa_PurchaseAmountDetail"];
//    采购内容明细表
    [self contectPurchaseArr:self.arr_ThirDetailsDataArray withTableName:@"Sa_PurchaseBusinessDetail"];
//    单一采购来源清单
    [self contectPurchaseArr:self.arr_FouDetailsDataArray withTableName:@"Sa_PurchaseSourceDetail"];
     self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":self.detailedArray};
}
- (void)contectPurchaseArr:(NSMutableArray *)purArr withTableName:(NSString *)tableName{
    NSMutableDictionary *Sa_PurchaseDetail = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNames = [NSMutableArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (purArr.count!=0) {
        if ([tableName isEqualToString:@"Sa_PurchaseAmountDetail"]) {
            fieldNames = [NSMutableArray arrayWithObjects:@"No",@"Description",@"CurrencyCode",@"Currency",@"ExchangeRate",@"Amount",@"LocalCyAmount",@"ExpenseCode",@"ExpenseType",@"ExpenseIcon",@"ExpenseCatCode",@"ExpenseCat",@"FeeAppNumber",@"FeeAppInfo",@"Remarks", nil];
        }else if([tableName isEqualToString:@"Sa_PurchaseBusinessDetail"]){
            fieldNames = [NSMutableArray arrayWithObjects:@"No",@"Description",@"BusinessRequirement",@"TechRequirement",@"ServiceRequirement",@"Attachments",@"Remarks", nil];
        }else if ([tableName isEqualToString:@"Sa_PurchaseSourceDetail"]){
            fieldNames = [NSMutableArray arrayWithObjects:@"No",@"Description",@"SupplierName",@"IsCrossDepartment",@"Reason",@"Attachments",@"Remarks", nil];
        }
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (DeatilsModel *model in purArr) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_PurchaseDetail setObject:tableName forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_PurchaseDetail setObject:tableName forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:Values forKey:@"fieldBigValues"];
    }
    [self.detailedArray addObject:Sa_PurchaseDetail];
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_PurchaseApp"];
}

-(void)getTotolAmount{
    self.str_TotalMoney=@"";
    for (DeatilsModel *models in self.arr_DetailsDataArray) {
        self.str_TotalMoney=[GPUtils decimalNumberAddWithString:self.str_TotalMoney with:models.Price];
    }
}

@end
