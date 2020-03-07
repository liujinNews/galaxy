//
//  EmployeeTrainFormData.m
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "EmployeeTrainFormData.h"

@implementation EmployeeTrainFormData
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
    
    self.str_flowCode=@"F0028";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"TrainingName",@"TrainingInstitution",@"TrainingMode",@"TrainingLocation",@"StartDate",@"EndDate",@"Days",@"TrainingFee",@"TrainingContent",@"AssessmentMethod",@"TrainingCertificate",@"ProjId",@"DetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0028";
    self.bool_isOpenDetail=NO;
    
}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWEMPLOYEETRAIN];
    }else{
        return [NSString stringWithFormat:@"%@",HASEMPLOYEETRAIN];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.bool_DetailsShow=[[NSString stringWithFormat:@"%@",result[@"employeeTrainingStaff"]] isEqualToString:@"1"]?YES:NO;
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if (![formDataDict isKindOfClass:[NSNull class]]) {
            NSArray *DetailArray=formDataDict[@"sa_EmployeeTrainingStaff"];
            for (NSDictionary *dict in DetailArray) {
                EmployeeTrainDetail *model=[[EmployeeTrainDetail alloc]init];
                if (![dict[@"userId"] isKindOfClass:[NSNull class]]) {
                    model.UserId=[NSString stringWithFormat:@"%@",dict[@"userId"]];
                }
                if (![dict[@"userName"] isKindOfClass:[NSNull class]]) {
                    model.UserName=[NSString stringWithFormat:@"%@",dict[@"userName"]];
                }
                if (![dict[@"userDeptId"] isKindOfClass:[NSNull class]]) {
                    model.UserDeptId=[NSString stringWithFormat:@"%@",dict[@"userDeptId"]];
                }
                if (![dict[@"userDept"] isKindOfClass:[NSNull class]]) {
                    model.UserDept=[NSString stringWithFormat:@"%@",dict[@"userDept"]];
                }
                if (![dict[@"jobTitleCode"] isKindOfClass:[NSNull class]]) {
                    model.JobTitleCode=[NSString stringWithFormat:@"%@",dict[@"jobTitleCode"]];
                }
                if (![dict[@"jobTitle"] isKindOfClass:[NSNull class]]) {
                    model.JobTitle=[NSString stringWithFormat:@"%@",dict[@"jobTitle"]];
                }
                if (![dict[@"jobTitleLvl"] isKindOfClass:[NSNull class]]) {
                    model.JobTitleLvl=[NSString stringWithFormat:@"%@",dict[@"jobTitleLvl"]];
                }
                if (![dict[@"userLevelId"] isKindOfClass:[NSNull class]]) {
                    model.UserLevelId=[NSString stringWithFormat:@"%@",dict[@"userLevelId"]];
                }
                if (![dict[@"userLevel"] isKindOfClass:[NSNull class]]) {
                    model.UserLevel=[NSString stringWithFormat:@"%@",dict[@"userLevel"]];
                }
                if (![dict[@"userLevelNo"] isKindOfClass:[NSNull class]]) {
                    model.UserLevelNo=[NSString stringWithFormat:@"%@",dict[@"userLevelNo"]];
                }
                [self.arr_DetailsDataArray addObject:model];
            }
        }
    }
}

-(void)inModelContent{
    
    self.SubmitData=[[EmployeeTrainData alloc]init];
    
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
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";

}

-(NSString *)testModel{
    
    EmployeeTrainData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [EmployeeTrainData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (EmployeeTrainDetail *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"UserName"]){
                            detailStr=model.UserName;
                        }else if ([str isEqualToString:@"UserDept"]){
                            detailStr=model.UserDept;
                        }else if ([str isEqualToString:@"JobTitle"]){
                            detailStr=model.JobTitle;
                        }else if ([str isEqualToString:@"UserLevel"]){
                            detailStr=model.UserLevel;
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
    }else if([info isEqualToString:@"TrainingName"]) {
        showinfo = Custing(@"请输入培训名称", nil);
    }else if([info isEqualToString:@"TrainingInstitution"]) {
        showinfo = Custing(@"请输入培训机构", nil);
    }else if([info isEqualToString:@"TrainingMode"]) {
        showinfo = Custing(@"请输入培训形式", nil);
    }else if([info isEqualToString:@"TrainingLocation"]) {
        showinfo = Custing(@"请输入培训地点", nil);
    }else if([info isEqualToString:@"StartDate"]) {
        showinfo = Custing(@"请选择培训开始日期", nil);
    }else if([info isEqualToString:@"EndDate"]) {
        showinfo = Custing(@"请选择培训结束日期", nil);
    }else if([info isEqualToString:@"Days"]) {
        showinfo = Custing(@"请输入实际天数", nil);
    }else if([info isEqualToString:@"TrainingFee"]) {
        showinfo = Custing(@"请输入培训费用", nil);
    }else if([info isEqualToString:@"TrainingContent"]) {
        showinfo = Custing(@"请输入培训主要内容", nil);
    }else if([info isEqualToString:@"AssessmentMethod"]) {
        showinfo = Custing(@"请输入考核方式", nil);
    }else if([info isEqualToString:@"TrainingCertificate"]) {
        showinfo = Custing(@"请输入培训证书", nil);
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
    if ([info isEqualToString:@"UserName"]) {
        showinfo = Custing(@"请选择姓名", nil);
    }
//    else if ([info isEqualToString:@"UserDept"]) {
//        showinfo = Custing(@"请输入部门", nil);
//    }else if ([info isEqualToString:@"JobTitle"]) {
//        showinfo = Custing(@"请输入职位", nil);
//    }else if ([info isEqualToString:@"UserLevel"]) {
//        showinfo = Custing(@"请输入级别", nil);
//    }
    return showinfo;
}

-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_EmployeeTraining = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[EmployeeTrainData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_EmployeeTraining setObject:@"Sa_EmployeeTraining" forKey:@"tableName"];
    [Sa_EmployeeTraining setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_EmployeeTraining setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_EmployeeTraining];
    
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_EmployeeTrainingStaff = [NSMutableDictionary dictionary];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[EmployeeTrainDetail initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (EmployeeTrainDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_EmployeeTrainingStaff setObject:@"Sa_EmployeeTrainingStaff" forKey:@"tableName"];
        [Sa_EmployeeTrainingStaff setObject:fieldNames forKey:@"fieldNames"];
        [Sa_EmployeeTrainingStaff setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_EmployeeTrainingStaff setObject:@"Sa_EmployeeTrainingStaff" forKey:@"tableName"];
        [Sa_EmployeeTrainingStaff setObject:fieldNames forKey:@"fieldNames"];
        [Sa_EmployeeTrainingStaff setObject:Values forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_EmployeeTrainingStaff];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_EmployeeTraining"];
}

@end
