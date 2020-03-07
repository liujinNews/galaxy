//
//  VehicleApplyFormData.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VehicleApplyFormData.h"

@implementation VehicleApplyFormData

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
    
    self.str_flowCode=@"F0014";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"VehicleType",@"DepartCity",@"BackCity",@"VehicleDate",@"BackDate",@"VehicleStaffId",@"InitialMileage",@"EndMileage",@"Mileage",@"FuelBills",@"Pontage",@"ParkingFee",@"OtherFee",@"TravelNumber",@"ProjId",@"ClientId",@"SupplierId",@"CarNo",@"Driver",@"DriverTel",@"Entourage",@"DispatcherReview",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.str_IsPassNight = @"0";
    
}
-(void)initializeHasData{
    
    self.str_flowCode=@"F0014";
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",GetVehicleAppData];
    }else{
        return [NSString stringWithFormat:@"%@",VehicleAppGetFormData];
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        //关联出差申请单状态(0审批完成 1审批中审批完成)
        self.str_TravelStatus = [[NSString stringWithFormat:@"%@",result[@"vehicleTravelStatus"]]isEqualToString:@"3"] ? @"3":@"2";
        
        [self getFormSettingBaseData:result];
        
        if ([result[@"stdSelfDrive"]isKindOfClass:[NSDictionary class]]) {
            self.dict_stdSelfDrive = result[@"stdSelfDrive"];
        }
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    
                    if ([dict[@"fieldName"]isEqualToString:@"VehicleTypeId"]) {
                        self.str_TypeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"VehicleTypeFlag"]) {
                        self.str_TypeFlag=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"VehicleStaff"]) {
                        self.str_VehicleStaff=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"EntourageId"]) {
                        self.str_EntourageId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelInfo"]) {
                        self.str_travelFormInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelNumber"]) {
                        self.str_travelFormId=([NSString isEqualToNullAndZero:[dict objectForKey:@"fieldValue"]])?[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]:self.str_travelFormId;
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"CarDesc"]) {
                        self.str_CarDes=[dict objectForKey:@"fieldValue"];
                    }
                }
            }
        }
    }
}
-(void)inModelContent{
    
    self.SubmitData=[[VehicleApplyData alloc]init];
    
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

    
    self.SubmitData.VehicleTypeId=self.str_TypeId;
    self.SubmitData.VehicleType=self.str_Type;
    self.SubmitData.VehicleTypeFlag=self.str_TypeFlag;
    
    self.SubmitData.TravelNumber=self.str_travelFormId;
    self.SubmitData.TravelInfo=self.str_travelFormInfo;
    
    self.SubmitData.VehicleStaff=self.str_VehicleStaff;
    self.SubmitData.VehicleStaffId=self.str_VehicleStaffId;

    self.SubmitData.IsPassNight=self.str_IsPassNight;

    self.SubmitData.EntourageId=self.str_EntourageId;
    self.SubmitData.Entourage=self.str_Entourage;

    
    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;

    self.SubmitData.CarDesc=self.str_CarDes;
    
}

-(void)inModelHasApproveContent{
    [self inModelContent];
    self.SubmitData.FirstHandlerUserId=self.str_twoHandeId;
    self.SubmitData.FirstHandlerUserName=self.str_twoApprovalName;
}
-(NSString *)testModel{
   
    VehicleApplyData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [VehicleApplyData initDicByModel:model];
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
    }else if([info isEqualToString:@"Reason"]) {
        showinfo =Custing(@"请输入用车事由", nil) ;
    }else if([info isEqualToString:@"VehicleType"]) {
        showinfo =Custing(@"请选择用车类型", nil) ;
    }else if([info isEqualToString:@"DepartCity"]) {
        showinfo =Custing(@"请输入出发地", nil) ;
    }else if([info isEqualToString:@"BackCity"]) {
        showinfo =Custing(@"请输入目的地", nil) ;
    }else if([info isEqualToString:@"VehicleDate"]) {
        showinfo =Custing(@"请选择用车时间", nil) ;
    }else if([info isEqualToString:@"BackDate"]) {
        showinfo =Custing(@"请选择返回时间", nil) ;
    }else if([info isEqualToString:@"VehicleStaffId"]) {
        showinfo =Custing(@"请选择同车人员", nil) ;
    }else if([info isEqualToString:@"InitialMileage"]) {
        showinfo =Custing(@"请输入起始里程", nil) ;
    }else if([info isEqualToString:@"EndMileage"]) {
        showinfo =Custing(@"请输入预计结束里程", nil) ;
    }else if([info isEqualToString:@"Mileage"]) {
        showinfo =Custing(@"请输入实际里程", nil) ;
    }else if([info isEqualToString:@"FuelBills"]) {
        showinfo =Custing(@"请输入油费", nil) ;
    }else if([info isEqualToString:@"Pontage"]) {
        showinfo =Custing(@"请输入路桥费", nil) ;
    }else if([info isEqualToString:@"ParkingFee"]) {
        showinfo =Custing(@"请输入停车费", nil) ;
    }else if([info isEqualToString:@"OtherFee"]) {
        showinfo =Custing(@"请输入其他费用", nil) ;
    }else if([info isEqualToString:@"TravelNumber"]) {
        showinfo =Custing(@"请选择出差申请单", nil) ;
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo =Custing(@"请选择项目", nil) ;
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo =Custing(@"请选择客户", nil) ;
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo =Custing(@"请选择供应商", nil) ;
    }else if([info isEqualToString:@"CarNo"]) {
        showinfo =Custing(@"请选择车辆", nil) ;
    }else if([info isEqualToString:@"Driver"]) {
        showinfo =Custing(@"请输入司机", nil) ;
    }else if([info isEqualToString:@"DriverTel"]) {
        showinfo =Custing(@"请输入司机电话", nil) ;
    }else if([info isEqualToString:@"Entourage"]) {
        showinfo =Custing(@"请选择同行人", nil) ;
    }else if([info isEqualToString:@"DispatcherReview"]) {
        showinfo =Custing(@"请输入车辆调度评审", nil) ;
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
-(NSString *)checkCarIsUsedUrl{
    return [NSString stringWithFormat:@"%@",VehicleAppIsUsed];
}
-(NSDictionary *)checkCarIsUsedParameter{
    return @{@"CarNo":self.SubmitData.CarNo,@"StartDate":self.SubmitData.VehicleDate,@"EndDate":self.SubmitData.BackDate,@"TaskId":self.str_taskId};
}
-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_VehicleApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[VehicleApplyData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_VehicleApp setObject:@"Sa_VehicleApp" forKey:@"tableName"];
    [Sa_VehicleApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_VehicleApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_VehicleApp];
    

    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_VehicleStaffDetail = [[NSMutableDictionary alloc]init];
    NSMutableArray *DetailfieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldBigValues=[[NSMutableArray alloc]init];
    if ([NSString isEqualToNull:self.str_VehicleStaffId]) {
        [DetailfieldNamesArr addObjectsFromArray:@[@"UserId",@"UserDspName",@"RequestorUserId"]];
        NSMutableArray *arr_UserId = [NSMutableArray arrayWithArray:[self.str_VehicleStaffId componentsSeparatedByString:@","]];
        NSMutableArray *arr_UserDspName = [NSMutableArray arrayWithArray:[self.str_VehicleStaff componentsSeparatedByString:@","]];
        NSMutableArray *arr_RequestorUserId = [NSMutableArray array];
        for (int i = 0; i<arr_UserId.count; i++) {
            [arr_RequestorUserId addObject:self.personalData.OperatorUserId];
        }
        [fieldBigValues addObjectsFromArray:@[arr_UserId,arr_UserDspName,arr_RequestorUserId]];
        [Sa_VehicleStaffDetail setObject:@"Sa_VehicleStaffDetail" forKey:@"tableName"];
        [Sa_VehicleStaffDetail setObject:DetailfieldNamesArr forKey:@"fieldNames"];
        [Sa_VehicleStaffDetail setObject:fieldBigValues forKey:@"fieldBigValues"];
    }else{
        [Sa_VehicleStaffDetail setObject:@"Sa_VehicleStaffDetail" forKey:@"tableName"];
        [Sa_VehicleStaffDetail setObject:DetailfieldNamesArr forKey:@"fieldNames"];
        [Sa_VehicleStaffDetail setObject:fieldBigValues forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_VehicleStaffDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}
-(void)contectHasDataWithTableName:(NSString *)tableName{
    //    NSLog(@"子类必须实现方法%s",__FUNCTION__);
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName", nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_VehicleApp"];
}


@end
