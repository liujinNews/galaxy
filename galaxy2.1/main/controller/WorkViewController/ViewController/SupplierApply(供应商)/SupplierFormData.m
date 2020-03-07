//
//  SupplierFormData.m
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SupplierFormData.h"

@implementation SupplierFormData

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
    
    self.str_flowCode=@"F0026";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"SupplierName",@"SupplierCode",@"SupplierCat",@"VmsCode",@"DetailList",@"InvBankAccount",@"BankOutlets",@"InvContacts",@"InvTel",@"InvAddr",@"InvZipCode",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0026";
    self.bool_isOpenDetail=NO;
    
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWSUPPLIERAPPLY];
    }else{
        return [NSString stringWithFormat:@"%@",HASSUPPLIERAPPLY];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_DetailsShow = [[NSString stringWithFormat:@"%@",result[@"supplierDetail"]] isEqualToString:@"1"]?YES:NO;
        self.int_codeIsSystem = [result[@"suppCodeIsSystem"] integerValue];
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"] isEqualToString:@"SupplierCatId"]) {
                        _str_SupplierCatId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"VmsCode"]) {
                        self.str_VmsCode = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"SupplierCode"]) {
                        self.str_SupplierCode=[dict objectForKey:@"fieldValue"];
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
                   
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *DetailArray=formDataDict[@"sa_SupplierDetail"];
            for (NSDictionary *dict in DetailArray) {
                SupplierDetail *model=[[SupplierDetail alloc]init];
                if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
                    model.Name=[NSString stringWithFormat:@"%@",dict[@"name"]];
                }
                if (![dict[@"sex"] isKindOfClass:[NSNull class]]) {
                    model.Sex=[NSString stringWithFormat:@"%@",dict[@"sex"]];
                }
                if (![dict[@"dept"] isKindOfClass:[NSNull class]]) {
                    model.Dept=[NSString stringWithFormat:@"%@",dict[@"dept"]];
                }
                if (![dict[@"jobTitle"] isKindOfClass:[NSNull class]]) {
                    model.JobTitle=[NSString stringWithFormat:@"%@",dict[@"jobTitle"]];
                }
                if (![dict[@"tel"] isKindOfClass:[NSNull class]]) {
                    model.Tel=[NSString stringWithFormat:@"%@",dict[@"tel"]];
                }
                if (![dict[@"email"] isKindOfClass:[NSNull class]]) {
                    model.Email=[NSString stringWithFormat:@"%@",dict[@"email"]];
                }
                [self.arr_DetailsDataArray addObject:model];
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData=[[SupplierData alloc]init];
    
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

    
    if (self.int_comeStatus != 0 || self.int_codeIsSystem != 0) {
        self.SubmitData.SupplierCode = self.str_SupplierCode;
    }
    self.SubmitData.SupplierCat = self.str_SupplierCat;
    self.SubmitData.SupplierCatId = self.str_SupplierCatId;
    self.SubmitData.VmsCode = self.str_VmsCode;
    self.SubmitData.BankNo = self.str_BankNo;
    self.SubmitData.BankCode = self.str_BankCode;
    self.SubmitData.CNAPS = self.str_CNAPS;
    self.SubmitData.BankProvinceCode = self.str_BankProvinceCode;
    self.SubmitData.BankProvince = self.str_BankProvince;
    self.SubmitData.BankCityCode = self.str_BankCityCode;
    self.SubmitData.BankCity = self.str_BankCity;
}

-(NSString *)testModel{
    
    SupplierData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [SupplierData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (SupplierDetail *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Name"]){
                            detailStr=model.Name;
                        }else if ([str isEqualToString:@"Sex"]){
                            detailStr=model.Sex;
                        }else if ([str isEqualToString:@"Dept"]){
                            detailStr=model.Dept;
                        }else if ([str isEqualToString:@"JobTitle"]){
                            detailStr=model.JobTitle;
                        }else if ([str isEqualToString:@"Tel"]){
                            detailStr=model.Tel;
                        }else if ([str isEqualToString:@"Email"]){
                            detailStr=model.Email;
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
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"SupplierName"]) {
        showinfo = Custing(@"请输入供应商名称", nil);
    }else if([info isEqualToString:@"SupplierCode"]&&self.int_codeIsSystem != 0) {
        showinfo = Custing(@"请输入供应商编号", nil);
    }else if([info isEqualToString:@"SupplierCat"]) {
        showinfo = Custing(@"请选择供应商类别", nil);
    }else if([info isEqualToString:@"VmsCode"]) {
        showinfo = Custing(@"请输入VMS Code", nil);
    }else if([info isEqualToString:@"InvBankAccount"]) {
        showinfo = Custing(@"请输入银行账号", nil);
    }else if([info isEqualToString:@"BankOutlets"]) {
        showinfo = Custing(@"请选择开户网点", nil);
    }else if([info isEqualToString:@"InvContacts"]) {
        showinfo = Custing(@"请输入联系人", nil);
    }else if([info isEqualToString:@"InvTel"]) {
        showinfo = Custing(@"请输入电话", nil);
    }else if([info isEqualToString:@"InvAddr"]) {
        showinfo = Custing(@"请输入地址", nil);
    }else if([info isEqualToString:@"InvZipCode"]) {
        showinfo = Custing(@"请输入邮编", nil);
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
        showinfo = Custing(@"请输入姓名", nil);
    }else if ([info isEqualToString:@"Sex"]) {
        showinfo = Custing(@"请选择性别", nil);
    }else if ([info isEqualToString:@"Dept"]) {
        showinfo = Custing(@"请输入部门", nil);
    }else if ([info isEqualToString:@"JobTitle"]) {
        showinfo = Custing(@"请输入职位", nil);
    }else if ([info isEqualToString:@"Tel"]) {
        showinfo = Custing(@"请输入电话", nil);
    }else if ([info isEqualToString:@"Email"]) {
        showinfo = Custing(@"请输入邮箱", nil);
    }
    return showinfo;
}

-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_SupplierApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[SupplierData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_SupplierApp setObject:@"Sa_SupplierApp" forKey:@"tableName"];
    [Sa_SupplierApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_SupplierApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_SupplierApp];
    
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_SupplierDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[SupplierDetail initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (SupplierDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_SupplierDetail setObject:@"Sa_SupplierDetail" forKey:@"tableName"];
        [Sa_SupplierDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_SupplierDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_SupplierDetail setObject:@"Sa_SupplierDetail" forKey:@"tableName"];
        [Sa_SupplierDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_SupplierDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_SupplierDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_SupplierApp"];
}

@end
