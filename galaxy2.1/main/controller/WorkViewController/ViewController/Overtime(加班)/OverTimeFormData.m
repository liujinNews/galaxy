//
//  OverTimeFormData.m
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "OverTimeFormData.h"

@implementation OverTimeFormData
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
    
    self.str_flowCode=@"F0017";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ClientId",@"SupplierId",@"ProjId",@"FromDate",@"ToDate",@"OverTime",@"TotalTime",@"Type",@"AccountingModeId",@"ExchangeHoliday",@"DetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ClientId",@"SupplierId",@"ProjId",@"FromDate",@"ToDate",@"TotalTime",@"Type",@"AccountingModeId",@"ExchangeHoliday",@"DetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0017";
    self.bool_isOpenDetail=NO;
    
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",OvertimeGetOvertimeData];
    }else{
        return [NSString stringWithFormat:@"%@",OvertimeGetFormData];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_DetailsShow=[[NSString stringWithFormat:@"%@",result[@"overtimeDetail"]] isEqualToString:@"1"]?YES:NO;
        self.dic_overtimeHistoryOutput = result[@"overtimeHistoryOutput"];
        self.bool_isBeforehand = [[NSString stringWithFormat:@"%@",result[@"isBeforehand"]] isEqualToString:@"1"];
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            self.bool_hasExchangeHoliday = [self.arr_isShowmDetailArray containsObject:@"ExchangeHoliday"];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"] isEqualToString:@"AccountingMode"]) {
                        _str_AccountingMode=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"AccountingModeId"]) {
                        _str_AccountingModeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"ExchangeHoliday"]) {
                        _str_ExchangeHoliday=[GPUtils removeFloatAllZero:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]];
                    }
                }
            }
        }
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *sa_OvertimeDetail = formDataDict[@"sa_OvertimeDetail"];
            for (NSDictionary *dict in sa_OvertimeDetail) {
                OverTimeDeatil *model=[[OverTimeDeatil alloc]init];
                if (![dict[@"fromDate"] isKindOfClass:[NSNull class]]) {
                    model.FromDate=[NSString stringWithFormat:@"%@",dict[@"fromDate"]];
                }
                if (![dict[@"toDate"] isKindOfClass:[NSNull class]]) {
                    model.ToDate=[NSString stringWithFormat:@"%@",dict[@"toDate"]];
                }
                if (![dict[@"overTime"] isKindOfClass:[NSNull class]]) {
                    model.OverTime=[NSString stringWithFormat:@"%@",dict[@"overTime"]];
                }
                if (![dict[@"type"] isKindOfClass:[NSNull class]]) {
                    model.Type=[NSString stringWithFormat:@"%@",dict[@"type"]];
                }
                if (![dict[@"accountingModeId"] isKindOfClass:[NSNull class]]) {
                    model.AccountingModeId=[NSString stringWithFormat:@"%@",dict[@"accountingModeId"]];
                }
                if (![dict[@"accountingMode"] isKindOfClass:[NSNull class]]) {
                    model.AccountingMode=[NSString stringWithFormat:@"%@",dict[@"accountingMode"]];
                }
                if (![dict[@"exchangeHoliday"] isKindOfClass:[NSNull class]]) {
                    model.ExchangeHoliday=[NSString stringWithFormat:@"%@",dict[@"exchangeHoliday"]];
                }
                if (![dict[@"reason"] isKindOfClass:[NSNull class]]) {
                    model.Reason=[NSString stringWithFormat:@"%@",dict[@"reason"]];
                }
                [self.arr_DetailsDataArray addObject:model];
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData=[[OverTimeData alloc]init];
    
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


    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;

    self.SubmitData.Type=self.str_TypeId;
    self.SubmitData.AccountingMode=self.str_AccountingMode;
    self.SubmitData.AccountingModeId=self.str_AccountingModeId;

}
-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}
-(NSString *)testModel{
    
    OverTimeData *model = self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [OverTimeData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (OverTimeDeatil *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"FromDate"]){
                            detailStr = model.FromDate;
                        }else if ([str isEqualToString:@"ToDate"]){
                            detailStr = model.ToDate;
                        }else if ([str isEqualToString:@"OverTime"]){
                            detailStr = model.OverTime;
                        }else if ([str isEqualToString:@"Type"]){
                            detailStr = model.Type;
                        }else if ([str isEqualToString:@"AccountingModeId"]){
                            detailStr = model.AccountingModeId;
                        }else if ([str isEqualToString:@"Reason"]){
                            detailStr = model.Reason;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
            
        }else{
            if ([key isEqualToString:@"OverTime"]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"FromDate"]]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"ToDate"]]) {
                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"ToDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"FromDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0){
                    returnTips=[self showerror:@"OverTime"];
                    break ;
                }
            }
            NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
            if ([i isEqualToString:@"1"]) {
                NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
                if (![NSString isEqualToNull:str]) {
                    if ([key isEqualToString:@"ExchangeHoliday"]) {
                        if ([[modeldic objectForKey:@"AccountingModeId"]isEqualToString:@"2"]) {
                            returnTips=[self showerror:key];
                            break;
                        }
                    }else{
                        returnTips=[self showerror:key];
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
    }else if([info isEqualToString:@"Reason"]) {
        showinfo =Custing(@"请输入事由", nil) ;
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"FromDate"]) {
        showinfo = Custing(@"请选择开始时间", nil);
    }else if([info isEqualToString:@"ToDate"]) {
        showinfo = Custing(@"请选择结束时间", nil);
    }else if([info isEqualToString:@"OverTime"]) {
        showinfo = Custing(@"开始时间不能大于等于结束时间", nil);
    }else if([info isEqualToString:@"TotalTime"]) {
        showinfo = Custing(@"请输入加班时长", nil);
    }else if([info isEqualToString:@"Type"]) {
        showinfo = Custing(@"请选择加班类型", nil);
    }else if([info isEqualToString:@"AccountingModeId"]) {
        showinfo = Custing(@"请选择加班核算方式", nil);
    }else if([info isEqualToString:@"ExchangeHoliday"]) {
        showinfo = Custing(@"请输入调休天数", nil);
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
    if ([info isEqualToString:@"FromDate"]) {
        showinfo = Custing(@"请选择开始时间", nil);
    }else if ([info isEqualToString:@"ToDate"]) {
        showinfo = Custing(@"请选择结束时间", nil);
    }else if ([info isEqualToString:@"OverTime"]) {
        showinfo = Custing(@"请输入加班时长", nil);
    }else if ([info isEqualToString:@"Type"]) {
        showinfo = Custing(@"请选择加班类型", nil);
    }else if ([info isEqualToString:@"AccountingModeId"]) {
        showinfo = Custing(@"请选择加班核算方式", nil);
    }else if ([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入加班原因", nil);
    }
    return showinfo;
}

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_OvertimeApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[OverTimeData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_OvertimeApp setObject:@"Sa_OvertimeApp" forKey:@"tableName"];
    [Sa_OvertimeApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_OvertimeApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_OvertimeApp];
    
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_OvertimeDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[OverTimeDeatil initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (OverTimeDeatil *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_OvertimeDetail setObject:@"Sa_OvertimeDetail" forKey:@"tableName"];
        [Sa_OvertimeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_OvertimeDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_OvertimeDetail setObject:@"Sa_SealDetail" forKey:@"tableName"];
        [Sa_OvertimeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_OvertimeDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_OvertimeDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_OvertimeApp"];
}

-(NSMutableArray *)arr_OverTimeType{
    if (_arr_OverTimeType==nil) {
        _arr_OverTimeType = [NSMutableArray array];
        NSArray *type = @[Custing(@"工作日", nil),Custing(@"双休日", nil),Custing(@"法定节假日", nil),Custing(@"公司节假日", nil)];
        NSArray *code = @[@"1",@"2",@"3",@"4"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_OverTimeType addObject:model];
        }
    }
    return _arr_OverTimeType;
}

-(NSMutableArray *)arr_AccountingMode{
    if (_arr_AccountingMode==nil) {
        _arr_AccountingMode=[NSMutableArray array];
        NSArray *type=@[Custing(@"申请加班费", nil),Custing(@"申请调休", nil)];
        NSArray *code=@[@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_AccountingMode addObject:model];
        }
    }
    return _arr_AccountingMode;
}


@end
