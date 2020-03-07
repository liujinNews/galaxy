//
//  MakeInvoiceFormData.m
//  galaxy
//
//  Created by hfk on 2018/6/2.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MakeInvoiceFormData.h"

@implementation MakeInvoiceFormData
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
    
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:self.arr_isShowmsArray];
    self.str_PayNumber=@"";
    self.str_PayInfo=@"";
    self.str_InvoiceType = @"0";
    self.arr_filesArray=[NSMutableArray array];
    self.arr_TolfilesArray=[NSMutableArray array];

    
}
-(void)initializeHasData{
    
    self.str_flowCode=@"F0026";
    self.arr_filesArray=[NSMutableArray array];
    self.arr_TolfilesArray=[NSMutableArray array];
    self.str_InvoiceType = @"0";
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWMAKEINVOICE];
    }else{
        return [NSString stringWithFormat:@"%@",HASMAKEINVOICE];
    }
}
-(void)DealWithFormBaseData{
    
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        if (self.int_formStatus==1) {
            //币种
            [self getCurrencyData:result];
        }
        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"]isEqualToString:@""]) {
                        self.str_PayInfo=dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@""]) {
                        self.str_PayNumber=dict[@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"InvoiceType"]) {
                        if ([dict[@"isShow"] floatValue] == 1) {
                            self.str_InvoiceType = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"2"] ? @"2":@"1";
                        }else{
                            self.str_InvoiceType = @"0";
                        }
                    }
                    if ([dict[@"fieldName"] isEqualToString:@"Files"]) {
                        if (![dict[@"fieldValue"] isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]];
                            for (NSDictionary *dict in array) {
                                [self.arr_TolfilesArray addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:self.arr_TolfilesArray WithImageArray:self.arr_filesArray WithMaxCount:5];
                        }
                    }
                }
            }
        }
    }
}
-(void)inModelContent{
    
    self.SubmitData=[[MakeInvoiceData alloc]init];
    
    self.SubmitData.Hrid=self.personalData.Hrid;
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
    
    self.SubmitData.OperatorUserId=self.personalData.OperatorUserId;
    self.SubmitData.Operator=self.personalData.Operator;
    self.SubmitData.OperatorDeptId=self.personalData.OperatorDeptId;
    self.SubmitData.OperatorDept=self.personalData.OperatorDept;
    
    
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
    
    
    self.SubmitData.RequestorDeptId = self.personalData.RequestorDeptId;
    self.SubmitData.RequestorDept = self.personalData.RequestorDept;
    self.SubmitData.JobTitleCode = self.personalData.JobTitleCode;
    self.SubmitData.JobTitle = self.personalData.JobTitle;
    self.SubmitData.JobTitleLvl = self.personalData.JobTitleLvl;

    
    
    self.SubmitData.Files=(self.arr_TolfilesArray.count!=0)?@"1":@"";

    self.SubmitData.Attachments=(self.arr_totalFileArray.count!=0)?@"1":@"";
    self.SubmitData.FirstHandlerUserId=self.str_firstHanderId;
    self.SubmitData.FirstHandlerUserName=self.str_firstHanderName;
    self.SubmitData.RequestorUserId=self.personalData.RequestorUserId;
    self.SubmitData.RequestorAccount=self.personalData.RequestorAccount;
    self.SubmitData.Requestor=self.personalData.Requestor;
    self.SubmitData.RequestorDate=self.personalData.RequestorDate;
    self.SubmitData.CompanyId=self.personalData.CompanyId;
    
    self.SubmitData.InvoiceType=self.str_InvoiceType;

//    self.SubmitData.CurrencyCode=self.str_CurrencyCode;
//    self.SubmitData.Currency=self.str_Currency;
//    self.SubmitData.ExchangeRate=self.str_ExchangeRate;
}

-(NSString *)testModel{
  
    MakeInvoiceData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [MakeInvoiceData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        NSString *i = [NSString stringWithFormat:@"%@",[self.dict_isRequiredmsdic objectForKey:key]];
        if (([key isEqualToString:@"TaxRate"]||[key isEqualToString:@"Tax"])&&![self.str_InvoiceType isEqualToString:@"1"]) {
            i=@"0";
        }
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
-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_ExpAdvance = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[MakeInvoiceData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_ExpAdvance setObject:@"Sa_ExpAdvance" forKey:@"tableName"];
    [Sa_ExpAdvance setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_ExpAdvance setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_ExpAdvance];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_ExpAdvance"];
}
@end
