//
//  SpecialReqestFormData.m
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SpecialReqestFormData.h"

@implementation SpecialReqestFormData

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
    
    self.str_flowCode=@"F0027";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"LocationId",@"Reason",@"TravelNumber",@"TravelCityName",@"TravelUserName",@"DepartureDate",@"ReturnDate",@"ProjId",@"DetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0027";
    self.bool_isOpenDetail=NO;
    
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWSPECIALREQUEST];
    }else{
        return [NSString stringWithFormat:@"%@",HASSPECIALREQUEST];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_DetailsShow=[[NSString stringWithFormat:@"%@",result[@"specialOverStdDetail"]] isEqualToString:@"1"]?YES:NO;
        
        self.int_travelTimeParams =[[NSString stringWithFormat:@"%@",result[@"travelTimeParams"]]isEqualToString:@"1"]?1:0;

        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"] isEqualToString:@"TravelNumber"]) {
                        _str_travelFormId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelInfo"]) {
                        _str_travelFormInfo=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelCityCode"]) {
                        _str_travelCityCode=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelCityName"]) {
                        _str_travelCity=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelUserId"]) {
                        _str_travelUserId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TravelUserName"]) {
                        _str_travelUser=[dict objectForKey:@"fieldValue"];
                    }
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *DetailArray=formDataDict[@"sa_SpecialOverStdDetail"];
            for (NSDictionary *dict in DetailArray) {
                SpecialReqestDetail *model=[[SpecialReqestDetail alloc]init];
                if (![dict[@"stdTypeId"] isKindOfClass:[NSNull class]]) {
                    model.StdTypeId=[NSString stringWithFormat:@"%@",dict[@"stdTypeId"]];
                }
                if (![dict[@"stdType"] isKindOfClass:[NSNull class]]) {
                    model.StdType=[NSString stringWithFormat:@"%@",dict[@"stdType"]];
                }
                if (![dict[@"standard"] isKindOfClass:[NSNull class]]) {
                    model.Standard=[NSString stringWithFormat:@"%@",dict[@"standard"]];
                }
                if (![dict[@"actualExecution"] isKindOfClass:[NSNull class]]) {
                    model.ActualExecution=[NSString stringWithFormat:@"%@",dict[@"actualExecution"]];
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
    
    self.SubmitData=[[SpecialReqestData alloc]init];
    
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
    
    self.SubmitData.TravelNumber=self.str_travelFormId;
    self.SubmitData.TravelInfo=self.str_travelFormInfo;
    self.SubmitData.TravelCityCode=self.str_travelCityCode;
    self.SubmitData.TravelCityName=self.str_travelCity;
    self.SubmitData.TravelUserId=self.str_travelUserId;
    self.SubmitData.TravelUserName=self.str_travelUser;
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
}

-(NSString *)testModel{
    
    SpecialReqestData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [SpecialReqestData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (SpecialReqestDetail *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"StdType"]){
                            detailStr=model.StdType;
                        }else if ([str isEqualToString:@"Standard"]){
                            detailStr=model.Standard;
                        }else if ([str isEqualToString:@"ActualExecution"]){
                            detailStr=model.ActualExecution;
                        }else if ([str isEqualToString:@"Reason"]){
                            detailStr=model.Reason;
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
        showinfo = Custing(@"请输入事由", nil);
    }else if([info isEqualToString:@"TravelNumber"]) {
        showinfo = Custing(@"请选择出差申请单", nil);
    }else if([info isEqualToString:@"TravelCityName"]) {
        showinfo = Custing(@"请选择出差地", nil);
    }else if([info isEqualToString:@"TravelUserName"]) {
        showinfo = Custing(@"请选择出差人员", nil);
    }else if([info isEqualToString:@"DepartureDate"]) {
        showinfo = Custing(@"请选择出发时间", nil);
    }else if([info isEqualToString:@"ReturnDate"]) {
        showinfo = Custing(@"请选择返回时间", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
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
    if ([info isEqualToString:@"StdType"]) {
        showinfo = Custing(@"请选择类型", nil);
    }else if ([info isEqualToString:@"Standard"]) {
        showinfo = Custing(@"请输入按制度标准", nil);
    }else if ([info isEqualToString:@"ActualExecution"]) {
        showinfo = Custing(@"请输入实际执行", nil);
    }else if ([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"请输入超标原因", nil);
    }
    return showinfo;
}

-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_SpecialRequirements = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[SpecialReqestData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_SpecialRequirements setObject:@"Sa_SpecialRequirements" forKey:@"tableName"];
    [Sa_SpecialRequirements setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_SpecialRequirements setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_SpecialRequirements];
    
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_SpecialOverStdDetail = [NSMutableDictionary dictionary];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[SpecialReqestDetail initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (SpecialReqestDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_SpecialOverStdDetail setObject:@"Sa_SpecialOverStdDetail" forKey:@"tableName"];
        [Sa_SpecialOverStdDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_SpecialOverStdDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_SpecialOverStdDetail setObject:@"Sa_SpecialOverStdDetail" forKey:@"tableName"];
        [Sa_SpecialOverStdDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_SpecialOverStdDetail setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_SpecialOverStdDetail];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_SpecialRequirements"];
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


@end
