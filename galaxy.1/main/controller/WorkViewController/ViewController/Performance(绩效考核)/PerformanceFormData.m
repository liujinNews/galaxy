//
//  PerformanceFormData.m
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceFormData.h"

@implementation PerformanceFormData
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
    
    self.str_flowCode=@"F0022";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"PerformanceMth",@"PerformanceQuarter",@"PerformanceYear",@"SelfComment",@"LeaderComment",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.arr_DetailsDataArray=[NSMutableArray array];
    self.str_TypeId=@"";
    self.str_SelfTotalScore=@"";
    self.str_LeaderTotalScore=@"";
}

-(void)initializeHasData{
    self.str_flowCode=@"F0022";
    self.arr_DetailsDataArray=[NSMutableArray array];
    self.str_SelfTotalScore=@"";
    self.str_LeaderTotalScore=@"";

}
-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",GETPERNERFORM];
    }else{
        return [NSString stringWithFormat:@"%@",GETPERHASFORM];
    }
}
-(NSDictionary *)OpenFormParameters{
    if (self.int_formStatus==1) {
        return @{@"TaskId":self.str_taskId,@"ProcId":self.str_procId,@"TypeId":self.str_TypeId,@"FlowGuid":self.str_flowGuid};
    }else{
        return @{@"TaskId":self.str_taskId,@"ProcId":self.str_procId};
    }
}
-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        self.int_performanceMode=[NSString isEqualToNull:result[@"performanceMode"]]?[[NSString stringWithFormat:@"%@",result[@"performanceMode"]]floatValue]:0;
        
        self.int_performanceTime=[NSString isEqualToNull:result[@"performanceTime"]]?[[NSString stringWithFormat:@"%@",result[@"performanceTime"]]floatValue]:0;
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            [self getFirGroupDetail:formDict];
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"] isEqualToString:@"TypeId"]&&self.int_comeStatus!=1) {
                        _str_TypeId=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"TypeName"]&&self.int_comeStatus!=1) {
                        _str_TypeName=[dict objectForKey:@"fieldValue"];
                    }
                
                    if ([dict[@"fieldName"] isEqualToString:@"PerformanceMth"]) {
                        _str_PerformanceMth=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PerformanceQuarter"]) {
                        _str_PerformanceQuarter=[dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"PerformanceYear"]) {
                        _str_PerformanceYear=[dict objectForKey:@"fieldValue"];
                    }
                }
            }
        }
        //明细数据
        [PerformanceDetail getPerformanceDetailWithDict:result WithResultArray:self.arr_DetailsDataArray];
    }
}
//MARK:处理分数显示模块
-(void)dealTheScoreViewShowSetting{
    if (self.int_formStatus==1) {
        if (self.int_performanceMode==0||self.int_performanceMode==2) {
            self.int_EditType=1;
        }else if (self.int_performanceMode==1){
            self.int_EditType=2;
        }
    }else{
        if (self.int_performanceMode==0){
            self.int_EditType=4;
        }else if (self.int_performanceMode==1){
            self.int_EditType=5;
        }else if (self.int_performanceMode==2){
            if (self.int_comeStatus==3) {
                self.int_EditType=3;
            }else if ([self.str_noteStatus isEqualToString:@"4"]||[self.str_noteStatus isEqualToString:@"5"]||[self.str_noteStatus isEqualToString:@"6"]){
                self.int_EditType=6;
            }else{
                self.int_EditType=4;
            }
        }
    }
}
-(void)getTheTotalScore{
    self.str_SelfTotalScore=@"";
    self.str_LeaderTotalScore=@"";
//    for (PerformanceDetail *model in self.arr_DetailsDataArray) {
//        NSMutableArray *arr=model.performanceDetailItem;
//        NSString *selfScore=@"0";
//        NSString *leadScore=@"0";
//        NSString *stdScore=@"0";
//        for (PerformanceDetailSub *subModel in arr) {
//            selfScore=[GPUtils decimalNumberAddWithString:selfScore with:subModel.selfScore];
//            leadScore=[GPUtils decimalNumberAddWithString:leadScore with:subModel.leaderScore];
//            stdScore=[GPUtils decimalNumberAddWithString:stdScore with:subModel.stdScore];
//        }
//        self.str_SelfTotalScore=[GPUtils decimalNumberAddWithString:self.str_SelfTotalScore with:([GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",model.weight] with:([GPUtils decimalNumberDividingWithString:selfScore with:stdScore])])];
//        self.str_LeaderTotalScore=[GPUtils decimalNumberAddWithString:self.str_LeaderTotalScore with:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",model.weight] with:([GPUtils decimalNumberDividingWithString:leadScore with:stdScore])]];
//    }
    
    for (PerformanceDetail *model in self.arr_DetailsDataArray) {
        NSMutableArray *arr=model.performanceDetailItem;
        for (PerformanceDetailSub *subModel in arr) {
            self.str_SelfTotalScore=[GPUtils decimalNumberAddWithString:self.str_SelfTotalScore with:([GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",subModel.itemWeight] with:[NSString stringWithFormat:@"%@",subModel.selfScore]])];
            self.str_LeaderTotalScore=[GPUtils decimalNumberAddWithString:self.str_LeaderTotalScore with:([GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",subModel.itemWeight] with:[NSString stringWithFormat:@"%@",subModel.leaderScore]])];
        }
    }

    if (self.int_EditType==1) {
        self.str_SelfTotalScore=[GPUtils getRoundingOffNumber:self.str_SelfTotalScore afterPoint:2];
        self.str_LeaderTotalScore=@"";
    }else if (self.int_EditType==2){
        self.str_LeaderTotalScore=[GPUtils getRoundingOffNumber:self.str_LeaderTotalScore afterPoint:2];
        self.str_SelfTotalScore=@"";
    }else if (self.int_EditType==3){
        self.str_LeaderTotalScore=[GPUtils getRoundingOffNumber:self.str_LeaderTotalScore afterPoint:2];
    }
}

-(void)inModelContent{
    self.SubmitData=[[PerformanceData alloc]init];
    
    
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
    
    self.SubmitData.TypeId=self.str_TypeId;
    self.SubmitData.TypeName=self.str_TypeName;
    self.SubmitData.PerformanceType=[NSString stringWithFormat:@"%ld",self.int_performanceTime];
    self.SubmitData.SelfTotalScore=self.str_SelfTotalScore;
    self.SubmitData.LeaderTotalScore=self.str_LeaderTotalScore;
    self.SubmitData.PerformanceMth=self.str_PerformanceMth;
    self.SubmitData.PerformanceQuarter=self.str_PerformanceQuarter;
    self.SubmitData.PerformanceYear=self.str_PerformanceYear;
    
}

-(NSString *)testModel{
    PerformanceData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [PerformanceData initDicByModel:model];
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
    }else if([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门", nil);
    }else if([info isEqualToString:@"AreaId"]) {
        showinfo =Custing(@"请选择地区", nil) ;
    }else if([info isEqualToString:@"LocationId"]) {
        showinfo =Custing(@"请选择办事处", nil) ;
    }else if([info isEqualToString:@"PerformanceMth"]) {
        showinfo = Custing(@"请选择评价月", nil);
    }else if([info isEqualToString:@"PerformanceQuarter"]) {
        showinfo = Custing(@"请选择评价季度", nil);
    }else if([info isEqualToString:@"PerformanceYear"]) {
        showinfo = Custing(@"请选择评价年", nil);
    }else if([info isEqualToString:@"SelfComment"]) {
        showinfo = Custing(@"请输入自评", nil);
    }else if([info isEqualToString:@"LeaderComment"]) {
        showinfo = Custing(@"请输入领导评语", nil);
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
-(void)contectData{
    
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_PerformanceApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[PerformanceData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_PerformanceApp setObject:@"Sa_PerformanceApp" forKey:@"tableName"];
    [Sa_PerformanceApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_PerformanceApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_PerformanceApp];

    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":[self getPerformanceDetail]};
}

-(NSMutableArray *)getPerformanceDetail{
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_PerformanceDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray>0) {
        NSMutableArray *dataArray=[NSMutableArray array];
        for (PerformanceDetail *Detailmodel in self.arr_DetailsDataArray) {
            for (PerformanceDetailSub *sub in Detailmodel.performanceDetailItem) {
                [dataArray addObject:sub];
            }
        }
        if (dataArray.count>0) {
            NSMutableDictionary *modelsDic=[PerformanceDetailSub initDicByModel:dataArray[0]];
            fieldNames = [modelsDic allKeys];
            for (NSString *key in fieldNames) {
                NSMutableArray  *array=[NSMutableArray array];
                for (PerformanceDetailSub *model in dataArray) {
                    if ([NSString isEqualToNull:[model valueForKey:key]]) {
                        [array addObject:[model valueForKey:key]];
                    }else{
                        [array addObject:(id)[NSNull null]];
                    }
                }
                [Values addObject:array];
            }
            [Sa_PerformanceDetail setObject:@"Sa_PerformanceDetail" forKey:@"tableName"];
            [Sa_PerformanceDetail setObject:fieldNames forKey:@"fieldNames"];
            [Sa_PerformanceDetail setObject:Values forKey:@"fieldBigValues"];
        }else{
            [Sa_PerformanceDetail setObject:@"Sa_PerformanceDetail" forKey:@"tableName"];
            [Sa_PerformanceDetail setObject:fieldNames forKey:@"fieldNames"];
            [Sa_PerformanceDetail setObject:Values forKey:@"fieldBigValues"];
        }
    }else{
        [Sa_PerformanceDetail setObject:@"Sa_PerformanceDetail" forKey:@"tableName"];
        [Sa_PerformanceDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_PerformanceDetail setObject:Values forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_PerformanceDetail];
    
    return detailedArray;
}

-(void)contectHasDataWithTableName:(NSString *)tableName{
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"LeaderComment",@"LeaderTotalScore",nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    if (![NSString isEqualToNull:self.str_LeaderComments]) {
        self.str_LeaderComments=@"";
    }
    if (![NSString isEqualToNull:self.str_LeaderTotalScore]) {
        self.str_LeaderTotalScore=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName,self.str_LeaderComments,self.str_LeaderTotalScore, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":[self getPerformanceDetail]};
}
-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_PerformanceApp"];
}




@end
