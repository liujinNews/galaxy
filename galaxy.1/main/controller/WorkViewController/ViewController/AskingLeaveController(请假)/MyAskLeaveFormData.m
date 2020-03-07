//
//  MyAskLeaveFormData.m
//  galaxy
//
//  Created by hfk on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MyAskLeaveFormData.h"
#import "MyAskLeaveDeatil.h"
@implementation MyAskLeaveFormData
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
    
    self.str_flowCode=@"F0004";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"LeaveType",@"OverTime",@"TotalDays",@"Reason",@"ProjId",@"Attachments",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"LeaveType",@"TotalDays",@"Reason",@"ProjId",@"Attachments",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"FirstHandlerUserName",@"CcUsersName"]];
    
    self.str_LeaveType=@"";
    self.str_LeaveTypecCode=@"";

    self.str_WcStartTime=[self getYearMonthDayWithString:nil];
    self.str_WcEndTime=self.str_WcStartTime;

    _bool_firstRequest=YES;
    
    self.str_TotolDays=@"0";
    _dict_WcDict=[NSMutableDictionary dictionary];
    _arr_DaysListArray=[NSMutableArray array];
    _arr_SubmitDaysArray=[NSMutableArray array];
    
    self.int_LeaveTimeType = 1;

    
}
-(void)initializeHasData{
    self.str_flowCode=@"F0004";
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",AskingLeaverequestList];
    }else{
        return [NSString stringWithFormat:@"%@",HasAskedLeaveList];
    }
}
-(NSString *)HolidayUrl{
    return [NSString stringWithFormat:@"%@",AskedLeaveHolidayDays];
}
-(NSDictionary *)HolidayParametersWithFromDate:(NSString *)fromDate{
    return @{@"LeaveCode":self.str_LeaveTypecCode,@"Uid":self.personalData.RequestorUserId,@"FromDate":fromDate};
}
-(NSString *)LeaveCalendarUrl{
    return [NSString stringWithFormat:@"%@",AskedLeaveCalendar];
}

-(NSDictionary *)LeaveCalendarParameters{
    return @{@"StartDate":self.str_WcStartTime,@"EndDate":self.str_WcEndTime,@"Uid":self.personalData.RequestorUserId};
}

-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        
        self.str_WorkStartTime=[NSString isEqualToNull:result[@"startTime"]]?[NSString stringWithFormat:@"%@",result[@"startTime"]]:@"09:00";
        self.str_WorkEndTime=[NSString isEqualToNull:result[@"endTime"]]?[NSString stringWithFormat:@"%@",result[@"endTime"]]:@"18:00";
        
        if (self.int_formStatus==1) {
            //请假类型
            NSArray *leaveType=[result objectForKey:@"leaveTyps"];
            if (leaveType.count!=0) {
                NSMutableArray *LeaveTypeArray=[NSMutableArray array];
                [ChooseCategoryModel getLeaveTypeByArray:leaveType Array:LeaveTypeArray];
//                ChooseCategoryModel *model=LeaveTypeArray[0];
//                _str_LeaveType=model.leaveType;
//                _str_LeaveTypecCode=[NSString stringWithFormat:@"%@",model.leaveCode];
//                _str_LeaveTypeId=[NSString stringWithFormat:@"%@",model.Id];
//                _str_LimitDay=[NSString stringWithFormat:@"%@",model.limitDay];
            }
        }
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveCode"]) {
                        _str_LeaveTypecCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:_str_LeaveTypecCode;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveType"]) {
                        _str_LeaveType=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:_str_LeaveType;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveTypeId"]) {
                        _str_LeaveTypeId=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:_str_LeaveTypeId;
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"YearLeaveDay"]) {
                        _str_YearLeaveDay=[NSString isEqualToNull:[dict objectForKey:@"fieldValue"]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"LimitDay"]) {
                        _str_LimitDay=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:_str_LimitDay;
                    }
                    
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveDays"]) {
                        _str_LeaveDays=[NSString isEqualToNull:dict[@"fieldValue"]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"UsedDays"]) {
                        _str_UsedDays=[NSString isEqualToNull:dict[@"fieldValue"]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"RemainingDays"]) {
                        _str_RemainingDays=[NSString isEqualToNull:dict[@"fieldValue"]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveInLieu"]) {
                        _str_LeaveInLieu=[NSString isEqualToNull:dict[@"fieldValue"]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"LeaveInLieu"]) {
                        _str_LeaveInLieu=[NSString isEqualToNull:dict[@"fieldValue"]]?[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]:@"0";
                    }
                    
                    if ([dict[@"fieldName"]isEqualToString:@"FromDate"]) {
                        self.int_LeaveTimeType = [[NSString stringWithFormat:@"%@",dict[@"ctrlTyp"]]isEqualToString:@"leavehalfday"] ? 2:1;
                    }
                    
                }
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData=[[MyAskLeaveData alloc]init];
    
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


    
    self.SubmitData.LeaveType=self.str_LeaveType;
    self.SubmitData.LeaveCode=self.str_LeaveTypecCode;
    self.SubmitData.FromDate=self.str_FromDate;
    self.SubmitData.FromTime=self.str_FromNoon;
    self.SubmitData.ToDate=self.str_ToDate;
    self.SubmitData.ToTime=self.str_ToNoon;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";

    
    self.SubmitData.LeaveDays=self.dict_HolidayStatus[@"totalDays"];
    self.SubmitData.RemainingDays=self.dict_HolidayStatus[@"remainingDays"];
    self.SubmitData.ApprovalDays=self.dict_HolidayStatus[@"approvalDays"];
    self.SubmitData.UsedDays=self.dict_HolidayStatus[@"usedDays"];
    self.SubmitData.Cycle=self.dict_HolidayStatus[@"cycle"];
    self.SubmitData.LeaveInLieu=self.dict_HolidayStatus[@"leaveInLieu"];
    self.SubmitData.WorkType=self.dict_HolidayStatus[@"workType"];
    self.SubmitData.YearLeaveDay = [[self.str_FromDate substringToIndex:4]isEqualToString:[self.str_ToDate substringToIndex:4]] ? (id)[NSNull null]:self.str_YearLeaveDay;
    self.SubmitData.FromDate=self.str_FromDate;
    self.SubmitData.FromTime=self.str_FromNoon;

    self.SubmitData.LimitDay=self.str_LimitDay;
    self.SubmitData.LeaveTypeId=self.str_LeaveTypeId;
    
}

-(NSString *)testModel{
    MyAskLeaveData *model=self.SubmitData;
    NSString *returnTips;
    
    if (self.dict_HolidayStatus&&[self.dict_HolidayStatus[@"cycle"] floatValue]==1&&([self.dict_HolidayStatus[@"usedDays"] floatValue] > 0||[self.dict_HolidayStatus[@"approvalDays"] floatValue] > 0)) {
        returnTips=[NSString stringWithFormat:@"%@%@",self.str_LeaveType,Custing(@"不能重复申请", nil)];
        return returnTips;
    }
    
    NSMutableDictionary *modeldic = [MyAskLeaveData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"OverTime"]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"FromDate"]]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"ToDate"]]) {
            if (self.int_LeaveTimeType == 2) {
                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"ToDate"] WithTimeFormart:@"yyyy/MM/dd"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"FromDate"] WithTimeFormart:@"yyyy/MM/dd"];
                if ([date2 timeIntervalSinceDate:date1]>0.0){
                    returnTips=[self showerror:@"OverTime"];
                    break ;
                }
            }else{
                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"ToDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"FromDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0){
                    returnTips=[self showerror:@"OverTime"];
                    break ;
                }
            }
        }
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if ([i isEqualToString:@"1"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if (![NSString isEqualToNull:str]) {
                returnTips=[self showerror:key];
                break ;
            }
        }
        if ([key isEqualToString:@"TotalDays"]) {
            NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
            if ([str floatValue]==0){
               returnTips=[self showerror:@"NoTotalDays"];
                break ;
            }
        }
    }
    
    if (![NSString isEqualToNull:returnTips]&&self.dict_HolidayStatus&&[self.dict_HolidayStatus[@"limitDay"] floatValue] == 1&&[self.dict_HolidayStatus[@"totalDays"] floatValue] > 0) {
        if ([self.str_TotolDays floatValue] - [self.dict_HolidayStatus[@"remainingDays"] floatValue]>0) {
            returnTips=Custing(@"请假天数不能大于剩余天数", nil);
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
        showinfo =Custing(@"请选择公司", nil) ;
    }else if([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"LeaveType"]) {
        showinfo = Custing(@"请输入请假类型", nil);
    }else if([info isEqualToString:@"OverTime"]) {
        showinfo = Custing(@"开始时间不能大于等于结束时间", nil);
    }else if([info isEqualToString:@"TotalDays"]) {
        showinfo = Custing(@"请输入请假天数", nil);
    }else if([info isEqualToString:@"NoTotalDays"]) {
        showinfo = Custing(@"请假天数不能为0", nil);
    }else if([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入请假事由", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
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

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_LeaveApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[MyAskLeaveData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_LeaveApp setObject:@"Sa_LeaveApp" forKey:@"tableName"];
    [Sa_LeaveApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_LeaveApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_LeaveApp];
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_WorkTimeDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_SubmitDaysArray.count!=0) {
        NSMutableDictionary *modelsDic=[MyAskLeaveDeatil initDicByModel:self.arr_SubmitDaysArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (MyAskLeaveDeatil *model in self.arr_SubmitDaysArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_WorkTimeDetail setObject:@"Sa_WorkTimeDetail" forKey:@"tableName"];
        [Sa_WorkTimeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_WorkTimeDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_WorkTimeDetail setObject:@"Sa_WorkTimeDetail" forKey:@"tableName"];
        [Sa_WorkTimeDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_WorkTimeDetail setObject:Values forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_WorkTimeDetail];
    if (self.int_comeStatus==2&&self.arr_SubmitDaysArray.count==0) {
        detailedArray = (id)[NSNull null];
    }
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_LeaveApp"];
}

-(NSString *)getYearMonthDayWithString:(NSString *)date{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    if (date) {
        return [date substringToIndex:10];
    }else{
        return [dateFormatter stringFromDate:[NSDate date]];
    }
}

-(void)getHolidayDaysInfoWithDict:(NSDictionary *)dicts{
    if ([dicts[@"result"]isKindOfClass:[NSDictionary class]]) {
        self.dict_HolidayStatus=dicts[@"result"];
    }
}

-(void)getWorkCalendarWithDict:(NSDictionary *)dicts{
    [self.dict_WcDict removeAllObjects];
    if ([dicts[@"result"]isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in dicts[@"result"]) {
            [self.dict_WcDict setObject:dict forKey:[NSString stringWithFormat:@"%@",dict[@"wcDate"]]];
        }
    }
}
-(void)getAskLeaveTotolDays{
    
    self.str_TotolDays=@"0";
    
    [self getDaysListArray];
    
    if (self.dict_HolidayStatus&&[self.dict_HolidayStatus[@"workType"] floatValue]!=0) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [_arr_DaysListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger week=[self weekdayStringFromDate:obj];
            if (week==7||week==1) {
                if (!(self.dict_WcDict[obj]&&[self.dict_WcDict[obj][@"wcType"] floatValue]==0)) {
                    [indexSet addIndex:idx];
                }
            }else{
                if (self.dict_WcDict[obj]&&[self.dict_WcDict[obj][@"wcType"] floatValue]>0) {
                    [indexSet addIndex:idx];
                }
            }
        }];
        //计算时间数组
        [_arr_DaysListArray removeObjectsAtIndexes:indexSet];
    }
    
    //跨年拆分天数
    NSMutableArray *arr_YearLeaveDay=[NSMutableArray array];
    NSMutableArray *arr_Year=[NSMutableArray array];
    for (NSInteger i=[[self.str_WcStartTime substringToIndex:4] integerValue]; i<=[[self.str_WcEndTime substringToIndex:4] integerValue]; i++) {
        [arr_Year addObject:[NSString stringWithFormat:@"%ld",i]];
        [arr_YearLeaveDay addObject:@"0"];
    }

    [_arr_SubmitDaysArray removeAllObjects];
    
    if (_arr_DaysListArray.count>0) {
        if (_arr_DaysListArray.count==1) {
            NSString *TotalTime;
            if ([_arr_DaysListArray[0] isEqualToString:self.str_WcStartTime]&&[_arr_DaysListArray[0] isEqualToString:self.str_WcEndTime]) {
                if (self.int_LeaveTimeType == 2) {
                    if ([self.str_FromNoon isEqualToString:@"1"]&&[self.str_ToNoon isEqualToString:@"2"]) {
                        TotalTime = @"1";
                    }else if ([self.str_FromNoon isEqualToString:@"1"]&&[self.str_ToNoon isEqualToString:@"1"]){
                        TotalTime = @"0.5";
                    }else if ([self.str_FromNoon isEqualToString:@"2"]&&[self.str_ToNoon isEqualToString:@"2"]){
                        TotalTime = @"0.5";
                    }
                }else{
                    TotalTime=[self getDuringTimeWithSStart:self.str_WorkStartTime withSEnd:self.str_WorkEndTime withCStart:[self.str_FromDate substringWithRange:NSMakeRange(11, 5)] withCEnd:[self.str_ToDate substringWithRange:NSMakeRange(11, 5)]];
                }
            }else if ([_arr_DaysListArray[0] isEqualToString:self.str_WcStartTime]){
                if (self.int_LeaveTimeType == 2) {
                    if ([self.str_FromNoon isEqualToString:@"1"]) {
                        TotalTime = @"1";
                    }else if ([self.str_FromNoon isEqualToString:@"2"]){
                        TotalTime = @"0.5";
                    }
                }else{
                    TotalTime=[self getDuringTimeWithSStart:self.str_WorkStartTime withSEnd:self.str_WorkEndTime withCStart:[self.str_FromDate substringWithRange:NSMakeRange(11, 5)] withCEnd:self.str_WorkEndTime];
                }
            }else if ([_arr_DaysListArray[0] isEqualToString:self.str_WcEndTime]){
                if (self.int_LeaveTimeType == 2) {
                    if ([self.str_ToNoon isEqualToString:@"1"]) {
                        TotalTime = @"0.5";
                    }else if ([self.str_FromNoon isEqualToString:@"2"]){
                        TotalTime = @"1";
                    }
                }else{
                    TotalTime=[self getDuringTimeWithSStart:self.str_WorkStartTime withSEnd:self.str_WorkEndTime withCStart:self.str_WorkStartTime withCEnd:[self.str_ToDate substringWithRange:NSMakeRange(11, 5)]];
                }
            }else{
                TotalTime=@"1";
            }
            
            self.str_TotolDays=[GPUtils decimalNumberAddWithString:self.str_TotolDays with:TotalTime];

            if ([arr_Year containsObject:[_arr_DaysListArray[0]substringToIndex:4]]) {
                NSUInteger index = [arr_Year indexOfObject:[_arr_DaysListArray[0]substringToIndex:4]];
                NSString *days=[GPUtils decimalNumberAddWithString:arr_YearLeaveDay[index] with:TotalTime];
                [arr_YearLeaveDay replaceObjectAtIndex:index withObject:days];
            }
            
            MyAskLeaveDeatil *model=[[MyAskLeaveDeatil alloc]init];
            model.UserId=self.userdatas.userId;
            model.ObjectId=self.str_LeaveTypeId;
            model.WtYear=[_arr_DaysListArray[0] substringToIndex:4];
            model.WtMonth=[_arr_DaysListArray[0] substringWithRange:NSMakeRange(5, 2)];
            model.WtDate=_arr_DaysListArray[0];
            model.TimeUnit=@"0";
            model.TotalTime=TotalTime;
            model.FlowCode=self.str_flowCode;
            [self.arr_SubmitDaysArray addObject:model];
  
        }else{
            for (int i=0; i<_arr_DaysListArray.count; i++) {
                NSString *TotalTime;
                
                if ([_arr_DaysListArray[i] isEqualToString:self.str_WcStartTime]) {
                    if (self.int_LeaveTimeType == 2) {
                        if ([self.str_FromNoon isEqualToString:@"1"]) {
                            TotalTime = @"1";
                        }else if ([self.str_FromNoon isEqualToString:@"2"]){
                            TotalTime = @"0.5";
                        }
                    }else{
                        TotalTime=[self getDuringTimeWithSStart:self.str_WorkStartTime withSEnd:self.str_WorkEndTime withCStart:[self.str_FromDate substringWithRange:NSMakeRange(11, 5)] withCEnd:self.str_WorkEndTime];
                    }
                }else if ([_arr_DaysListArray[i] isEqualToString:self.str_WcEndTime]){
                    if (self.int_LeaveTimeType == 2) {
                        if ([self.str_ToNoon isEqualToString:@"1"]) {
                            TotalTime = @"0.5";
                        }else if ([self.str_ToNoon isEqualToString:@"2"]){
                            TotalTime = @"1";
                        }
                    }else{
                        TotalTime=[self getDuringTimeWithSStart:self.str_WorkStartTime withSEnd:self.str_WorkEndTime withCStart:self.str_WorkStartTime withCEnd:[self.str_ToDate substringWithRange:NSMakeRange(11, 5)]];
                    }
                }else{
                    TotalTime=@"1";
                }
                self.str_TotolDays=[GPUtils decimalNumberAddWithString:self.str_TotolDays with:TotalTime];
                
                if ([arr_Year containsObject:[_arr_DaysListArray[i]substringToIndex:4]]) {
                    NSUInteger index = [arr_Year indexOfObject:[_arr_DaysListArray[i]substringToIndex:4]];
                    NSString *days=[GPUtils decimalNumberAddWithString:arr_YearLeaveDay[index] with:TotalTime];
                    [arr_YearLeaveDay replaceObjectAtIndex:index withObject:days];
                }
                MyAskLeaveDeatil *model=[[MyAskLeaveDeatil alloc]init];
                model.UserId=self.userdatas.userId;
                model.ObjectId=self.str_LeaveTypeId;
                model.WtYear=[_arr_DaysListArray[i] substringToIndex:4];
                model.WtMonth=[_arr_DaysListArray[i] substringWithRange:NSMakeRange(5, 2)];
                model.WtDate=_arr_DaysListArray[i];
                model.TimeUnit=@"0";
                model.TotalTime=TotalTime;
                model.FlowCode=self.str_flowCode;
                [self.arr_SubmitDaysArray addObject:model];
            }
        }
    }
    self.str_YearLeaveDay = [GPUtils getSelectResultWithArray:arr_YearLeaveDay WithCompare:@","];
}

-(NSString *)DateDuring{
    NSString *duringTime=nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat: self.int_LeaveTimeType ==2 ? @"yyyy/MM/dd":@"yyyy/MM/dd HH:mm"];
    if ([NSString isEqualToNull:self.str_FromDate]&&[NSString isEqualToNull:self.str_ToDate]) {
        NSDate *formdate = [formatter dateFromString:self.str_FromDate];
        NSDate *todate = [formatter dateFromString:self.str_ToDate];
        double intervalTime = [todate timeIntervalSinceReferenceDate] - [formdate timeIntervalSinceReferenceDate];
        if (intervalTime>=0) {
            duringTime=[NSString notRounding:[NSString stringWithFormat:@"%f",intervalTime/(3600*24)] afterPoint:2];
        }
    }
    return duringTime;
}

-(void)getDaysListArray{
    //    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy/MM/dd"];
    //    _arr_DaysListArray = [NSMutableArray array];
    //    long long startTime =[[format dateFromString:[self.str_FromDate substringToIndex:10]] timeIntervalSince1970];
    //    long long endTime =[[format dateFromString:[self.str_ToDate substringToIndex:10]] timeIntervalSince1970];
    //    long long dayTime = 24*60*60;
    //    while (startTime <= endTime) {
    //        NSString *showOldDate = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTime]];
    //        [_arr_DaysListArray addObject:showOldDate];
    //        startTime += dayTime;
    //    }
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    [_arr_DaysListArray removeAllObjects];
    NSDate *startTime=[format dateFromString:[self.str_FromDate substringToIndex:10]];
    NSDate *endTime=[format dateFromString:[self.str_ToDate substringToIndex:10]];
    
    while([endTime timeIntervalSinceDate:startTime]>=0) {
        NSString * time = [format stringFromDate:startTime];
        [_arr_DaysListArray addObject:time];
        startTime=[GPUtils getLaterDateFromDate:startTime withYear:0 month:0 day:1];
    }
}
- (NSInteger )weekdayStringFromDate:(id)date{
    NSDate *dateNew;
    if ([date isKindOfClass:[NSString class]]) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd"];
        dateNew=[format dateFromString:date];
    }else{
        dateNew=[NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:dateNew];
    return theComponents.weekday;
}

-(NSString *)getDuringTimeWithSStart:(NSString *)sstart withSEnd:(NSString *)send            withCStart:(NSString *)cstart  withCEnd:(NSString *)cend{
    if (!cstart) {
        cstart=sstart;
    }
    if (!cend) {
        cend=send;
    }
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"HH:mm"];
    if (([[dateformat dateFromString:cstart] timeIntervalSinceDate:[dateformat dateFromString:send]]>0)||([[dateformat dateFromString:cend] timeIntervalSinceDate:[dateformat dateFromString:sstart]]<0)) {
        return @"0";
    }else{
        NSString *start;
        NSString *end;
        if ([[dateformat dateFromString:cstart] timeIntervalSinceDate:[dateformat dateFromString:sstart]]>0) {
            start=cstart;
            if ([[dateformat dateFromString:cend] timeIntervalSinceDate:[dateformat dateFromString:send]]>0) {
                end=send;
            }else{
                end=cend;
            }
        }else{
            start=sstart;
            if ([[dateformat dateFromString:cend] timeIntervalSinceDate:[dateformat dateFromString:send]]>0) {
                end=send;
            }else{
                end=cend;
            }
        }
        NSDate *startDate = [dateformat dateFromString:start];
        NSDate *endDate = [dateformat dateFromString:end];
        double intervalTime = [endDate timeIntervalSinceReferenceDate] - [startDate timeIntervalSinceReferenceDate];
        return  [NSString stringWithFormat:@"%.2f",(intervalTime/(3600*8))>1?1:(intervalTime/(3600*8))];
    }
}


@end
