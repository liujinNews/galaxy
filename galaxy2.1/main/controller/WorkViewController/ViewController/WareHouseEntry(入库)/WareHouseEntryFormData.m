//
//  WareHouseEntryFormData.m
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "WareHouseEntryFormData.h"
#import "WareHouseEntryDetail.h"

@implementation WareHouseEntryFormData

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
    
    self.str_flowCode = @"F0029";
    self.arr_isShowmsArray = [[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"StoreDate",@"SupplierId",@"ContractName",@"ProjId",@"PurchaseNumber",@"ReceivedDate",@"StoreType",@"InvStorageName",@"DetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
}

-(void)initializeHasData{
    
    self.str_flowCode = @"F0029";
    self.bool_isOpenDetail = NO;
}
-(NSString *)OpenFormUrl{
    
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWWAREHOUSEENTRY];
    }else{
        return [NSString stringWithFormat:@"%@",HASWAREHOUSEENTRY];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_DetailsShow = [[NSString stringWithFormat:@"%@",result[@"storeDetail"]] isEqualToString:@"1"]?YES:NO;
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
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
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseInfo"]) {
                        self.str_PurchaseInfo = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PurchaseNumber"]) {
                        self.str_PurchaseNumber = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"StoreType"]) {
                        self.str_StoreType = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"StoreTypeId"]) {
                        self.str_StoreTypeId = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvStorageName"]) {
                        self.str_InvStorageName = dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvStorageId"]) {
                        self.str_InvStorageId = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"InvStorageCode"]) {
                        self.str_InvStorageCode = [NSString stringWithIdOnNO:dict[@"fieldValue"]];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TotalAmount"]) {
                        self.str_TotalMoney = [NSString reviseString:dict[@"fieldValue"]];
                    }
                }
            }
        }
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *DetailArray=formDataDict[@"sa_StoreDetail"];
            for (NSDictionary *dict in DetailArray) {
                WareHouseEntryDetail *model=[[WareHouseEntryDetail alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.arr_DetailsDataArray addObject:model];
            }
        }
    }
}

-(void)inModelContent{
    self.SubmitData = [[WareHouseEntryData alloc]init];
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
    
    
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    self.SubmitData.ContractName = self.str_ContractName;
    self.SubmitData.ContractNo = self.str_ContractNo;
    self.SubmitData.ContractAppNumber = self.str_ContractAppNumber;
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.PurchaseNumber = self.str_PurchaseNumber;
    self.SubmitData.PurchaseInfo = self.str_PurchaseInfo;
    self.SubmitData.StoreTypeId = self.str_StoreTypeId;
    self.SubmitData.StoreType = self.str_StoreType;
    self.SubmitData.InvStorageId = self.str_InvStorageId;
    self.SubmitData.InvStorageCode = self.str_InvStorageCode;
    self.SubmitData.InvStorageName = self.str_InvStorageName;
    self.SubmitData.TotalAmount = self.str_TotalMoney;
    self.SubmitData.CapitalizedAmount = [NSString getChineseMoneyByString:self.str_TotalMoney];
}

-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}

-(NSString *)testModel{
    
    WareHouseEntryData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [WareHouseEntryData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (WareHouseEntryDetail *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Name"]){
                            detailStr = model.Name;
                        }else if ([str isEqualToString:@"Brand"]){
                            detailStr = model.Brand;
                        }else if ([str isEqualToString:@"Spec"]){
                            detailStr = model.Spec;
                        }else if ([str isEqualToString:@"Unit"]){
                            detailStr = model.Unit;
                        }else if ([str isEqualToString:@"Qty"]){
                            detailStr = model.Qty;
                        }else if ([str isEqualToString:@"Price"]){
                            detailStr = model.Price;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr = model.Amount;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr = model.Remark;
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
        showinfo =Custing(@"请输入入库事由", nil) ;
    }else if([info isEqualToString:@"StoreDate"]) {
        showinfo =Custing(@"请选择入库日期", nil) ;
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo =Custing(@"请选择供应商", nil) ;
    }else if([info isEqualToString:@"ContractName"]) {
        showinfo =Custing(@"请选择合同审批单", nil) ;
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo =Custing(@"请选择项目名称", nil) ;
    }else if([info isEqualToString:@"PurchaseNumber"]) {
        showinfo =Custing(@"请选择采购申请单", nil) ;
    }else if([info isEqualToString:@"ReceivedDate"]) {
        showinfo =Custing(@"请选择收货时间", nil) ;
    }else if([info isEqualToString:@"StoreType"]) {
        showinfo =Custing(@"请选择入库类型", nil) ;
    }else if([info isEqualToString:@"InvStorageName"]) {
        showinfo =Custing(@"请选择仓库", nil) ;
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
    if ([info isEqualToString:@"Name"]) {
        showinfo = Custing(@"请选择物品", nil);
    }else if ([info isEqualToString:@"Brand"]) {
        showinfo = Custing(@"请输入品牌", nil);
    }else if ([info isEqualToString:@"Spec"]) {
        showinfo = Custing(@"请输入规格", nil);
    }else if ([info isEqualToString:@"Unit"]) {
        showinfo =Custing(@"请输入单位", nil);
    }else if ([info isEqualToString:@"Qty"]) {
        showinfo = Custing(@"请输入数量", nil);
    }else if ([info isEqualToString:@"Price"]) {
        showinfo = Custing(@"请输入单价", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入金额", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入明细备注", nil);
    }
    return showinfo;
}

-(void)contectData{
    
    self.dict_parametersDict = [NSDictionary dictionary];
    NSMutableArray *mainArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_StoreApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic = [WareHouseEntryData initDicByModel:self.SubmitData];
    for(id key in modelDic){
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_StoreApp setObject:@"Sa_StoreApp" forKey:@"tableName"];
    [Sa_StoreApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_StoreApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_StoreApp];
    
    
    NSMutableArray *detailedArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_StoreDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values = [NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[WareHouseEntryDetail initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (WareHouseEntryDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_StoreDetail setObject:@"Sa_StoreDetail" forKey:@"tableName"];
        [Sa_StoreDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_StoreDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_StoreDetail setObject:@"Sa_StoreDetail" forKey:@"tableName"];
        [Sa_StoreDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_StoreDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_StoreDetail];
    self.dict_parametersDict = @{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_StoreApp"];
}

-(void)getTotolAmount{
    self.str_TotalMoney=@"";
    for (WareHouseEntryDetail *models in self.arr_DetailsDataArray) {
        self.str_TotalMoney=[GPUtils decimalNumberAddWithString:self.str_TotalMoney with:models.Amount];
    }
}

@end
