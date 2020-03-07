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
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"PurchaseType",@"CostCenterId",@"ProjId",@"SupplierId",@"DetailList",@"TotalAmount",@"PayMode",@"DeliveryDate",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];

    self.arr_procureType=[NSMutableArray array];
    self.arr_payWay=[NSMutableArray array];
    self.str_PurchaseType=@"";
    self.str_PurchaseCode=@"";
    self.str_PayMode=@"";
    self.str_PayCode=@"";
    self.str_TotalMoney=@"";
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0005";
    self.bool_isOpenDetail=NO;
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
        
        //报销政策
        if ([result[@"formRule"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *formRule=result[@"formRule"];
            if ([formRule[@"claimPolicy"]isKindOfClass:[NSDictionary class]]) {
                self.dict_ReimPolicyDict=formRule[@"claimPolicy"];
            }
        }
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            self.bool_DetailsShow=YES;
            [self getFirGroupDetail:formDict];
            self.bool_DetailsShow=(self.arr_DetailsArray.count>0?YES:NO);
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCont:5];
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
                    model.Amount=[NSString stringWithFormat:@"%@",dict[@"amount"]];
                }
                if (![dict[@"price"] isKindOfClass:[NSNull class]]) {
                    model.Price=[NSString stringWithFormat:@"%@",dict[@"price"]];
                }
                if (![dict[@"supplierId"] isKindOfClass:[NSNull class]]) {
                    model.SupplierId=[NSString stringWithFormat:@"%@",dict[@"supplierId"]];
                }
                if (![dict[@"supplierName"] isKindOfClass:[NSNull class]]) {
                    model.SupplierName=[NSString stringWithFormat:@"%@",dict[@"supplierName"]];
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
                [self.arr_DetailsDataArray addObject:model];
            }
        }
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
    self.SubmitData.HRID=self.personalData.Hrid;
    self.SubmitData.Branch=self.personalData.Branch;
    self.SubmitData.BranchId=self.personalData.BranchId;
    self.SubmitData.RequestorBusDept=self.personalData.RequestorBusDept;
    self.SubmitData.RequestorBusDeptId=self.personalData.RequestorBusDeptId;
    self.SubmitData.UserReserved1=self.personalData.UserReserved1;
    self.SubmitData.UserReserved2=self.personalData.UserReserved2;
    self.SubmitData.UserReserved3=self.personalData.UserReserved3;
    self.SubmitData.UserReserved4=self.personalData.UserReserved4;
    self.SubmitData.UserReserved5=self.personalData.UserReserved5;
    self.SubmitData.UserLevelId=self.personalData.UserLevelId;
    self.SubmitData.UserLevel=self.personalData.UserLevel;
    self.SubmitData.AreaId=self.personalData.AreaId;
    self.SubmitData.Area=self.personalData.Area;
    self.SubmitData.LocationId=self.personalData.LocationId;
    self.SubmitData.Location=self.personalData.Location;

    
    self.SubmitData.ApproverId1=self.personalData.ApproverId1;
    self.SubmitData.ApproverId2=self.personalData.ApproverId2;
    self.SubmitData.ApproverId3=self.personalData.ApproverId3;
    self.SubmitData.ApproverId4=self.personalData.ApproverId4;
    self.SubmitData.ApproverId5=self.personalData.ApproverId5;
    self.SubmitData.UserLevelNo=self.personalData.UserLevelNo;
    
    self.SubmitData.OperatorUserId=self.operatorData.OperatorUserId;
    self.SubmitData.Operator=self.operatorData.Operator;
    self.SubmitData.OperatorDeptId=self.operatorData.OperatorDeptId;
    self.SubmitData.OperatorDept=self.operatorData.OperatorDept;

    
    self.SubmitData.Reserved1=self.model_ReserverModel.Reserverd1;
    self.SubmitData.Reserved2=self.model_ReserverModel.Reserverd2;
    self.SubmitData.Reserved3=self.model_ReserverModel.Reserverd3;
    self.SubmitData.Reserved4=self.model_ReserverModel.Reserverd4;
    self.SubmitData.Reserved5=self.model_ReserverModel.Reserverd5;
    self.SubmitData.Reserved6=self.model_ReserverModel.Reserverd6;
    self.SubmitData.Reserved7=self.model_ReserverModel.Reserverd7;
    self.SubmitData.Reserved8=self.model_ReserverModel.Reserverd8;
    self.SubmitData.Reserved9=self.model_ReserverModel.Reserverd9;
    self.SubmitData.Reserved10=self.model_ReserverModel.Reserverd10;

    
    self.SubmitData.RequestorDeptId=self.personalData.RequestorDeptId;
    self.SubmitData.RequestorDept=self.personalData.RequestorDept;
    self.SubmitData.JobTitleCode=self.personalData.JobTitleCode;
    self.SubmitData.JobTitle=self.personalData.JobTitle;
    self.SubmitData.JobTitleLvl=self.personalData.JobTitleLvl;

    self.SubmitData.PurchaseType=self.str_PurchaseType;
    self.SubmitData.PurchaseCode=self.str_PurchaseCode;
    self.SubmitData.TotalAmount=self.str_TotalMoney;
    self.SubmitData.PayMode=self.str_PayMode;
    self.SubmitData.PayCode=self.str_PayCode;
    
    self.SubmitData.SupplierId=self.str_SupplierId;
    self.SubmitData.SupplierName=self.str_Supplier;
    self.SubmitData.CostCenterId=self.str_CostCenterId;
    self.SubmitData.CostCenter=self.str_CostCenter;
    
    self.SubmitData.ProjId=self.str_ProjId;
    self.SubmitData.ProjName=self.str_ProjName;
    self.SubmitData.ProjMgrUserId=self.str_ProjMgrId;
    self.SubmitData.ProjMgr=self.str_ProjMgrName;

    
    self.SubmitData.Attachments=(self.arr_totalFileArray.count!=0)?@"1":@"";
    self.SubmitData.FirstHandlerUserId=self.str_firstHanderId;
    self.SubmitData.FirstHandlerUserName=self.str_firstHanderName;
    self.SubmitData.RequestorUserId=self.personalData.RequestorUserId;
    self.SubmitData.RequestorAccount=self.personalData.RequestorAccount;
    self.SubmitData.Requestor=self.personalData.Requestor;
    self.SubmitData.RequestorDate=self.personalData.RequestorDate;
    self.SubmitData.CompanyId=self.personalData.CompanyId;
    
    self.SubmitData.CcUsersId=self.str_CcUsersId;
    self.SubmitData.CcUsersName=self.str_CcUsersName;
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
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }else if ([str isEqualToString:@"SupplierId"]){
                            detailStr=model.SupplierId;
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
#pragma mark--显示主表必填项判断
-(NSString *)showerror:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"RequestorDeptId"]) {
        showinfo =Custing(@"请选择部门", nil) ;
    }else if([info isEqualToString:@"BranchId"]) {
        showinfo = Custing(@"请选择分公司", nil);
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
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"TotalAmount"]) {
        showinfo = Custing(@"合计金额不能为空", nil);
    }else if([info isEqualToString:@"PayMode"]) {
        showinfo = Custing(@"请选择支付方式", nil);
    }else if([info isEqualToString:@"DeliveryDate"]) {
        showinfo = Custing(@"请选择期望交货日期", nil);
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
#pragma mark--显示明细必填项判断
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
    }else if ([info isEqualToString:@"Price"]) {
        showinfo = Custing(@"请输入价格", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入明细备注", nil);
    }else if ([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择明细供应商", nil);
    }
    return showinfo;
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
    NSMutableDictionary *Sa_PurchaseDetail = [[NSMutableDictionary alloc]init];
    NSMutableArray *DetailfieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldBigValues=[[NSMutableArray alloc]init];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[DeatilsModel initDicByModel:self.arr_DetailsDataArray[0]];
        for(id key in modelsDic)
        {
            [DetailfieldNamesArr addObject:key];
        }
        for (int i=0; i<DetailfieldNamesArr.count; i++) {//创建几个数组
            NSMutableArray  *array=[NSMutableArray array];
            for (int j=0; j<self.arr_DetailsDataArray.count; j++) {
                NSMutableDictionary *modelDic=[DeatilsModel initDicByModel:self.arr_DetailsDataArray[j]];
                [array addObject:[modelDic objectForKey:DetailfieldNamesArr[i]]];
            }
            [fieldBigValues addObject:array];
        }
        [Sa_PurchaseDetail setObject:@"Sa_PurchaseDetail" forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:DetailfieldNamesArr forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:fieldBigValues forKey:@"fieldBigValues"];
    }else{
        [Sa_PurchaseDetail setObject:@"Sa_PurchaseDetail" forKey:@"tableName"];
        [Sa_PurchaseDetail setObject:DetailfieldNamesArr forKey:@"fieldNames"];
        [Sa_PurchaseDetail setObject:fieldBigValues forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_PurchaseDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
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
