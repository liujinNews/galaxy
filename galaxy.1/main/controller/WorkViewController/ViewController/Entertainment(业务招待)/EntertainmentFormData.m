//
//  EntertainmentFormData.m
//  galaxy
//
//  Created by hfk on 2018/4/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "EntertainmentFormData.h"
#import "EntertainmentDeatil.h"
#import "EntertainmentSchDeatil.h"
#import "EntertainmentVisitorDeatil.h"
@implementation EntertainmentFormData

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
    
    self.str_flowCode=@"F0023";
    self.arr_isShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ReceptionObj",@"VisitDate",@"LeaveDate",@"OverTime",@"Visitor",@"ExpenseCode",@"ExpenseDesc",@"ProjId",@"ClientId",@"SupplierId",@"RentCarFee",@"Pontage",@"MealFee",@"HotelFee",@"OtherFee",@"EstimatedAmount",@"CurrencyCode",@"ExchangeRate",@"DetailList",@"ThirDetailList",@"SecDetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    self.arr_UnShowmsArray=[[NSMutableArray alloc]initWithArray:@[@"RequestorDeptId",@"BranchId",@"CostCenterId",@"RequestorBusDeptId",@"AreaId",@"LocationId",@"Reason",@"ReceptionObj",@"VisitDate",@"LeaveDate",@"Visitor",@"ExpenseCode",@"ExpenseDesc",@"ProjId",@"ClientId",@"SupplierId",@"RentCarFee",@"Pontage",@"MealFee",@"HotelFee",@"OtherFee",@"EstimatedAmount",@"CurrencyCode",@"ExchangeRate",@"DetailList",@"ThirDetailList",@"SecDetailList",@"Reserved1",@"Reserved2",@"Reserved3",@"Reserved4",@"Reserved5",@"Reserved6",@"Reserved7",@"Reserved8",@"Reserved9",@"Reserved10",@"Remark",@"Attachments",@"FirstHandlerUserName",@"CcUsersName"]];
    
    self.arr_CategoryArr=[NSMutableArray array];
    self.str_ExpenseCode=@"";
    self.str_ExpenseType=@"";
    self.str_ExpenseIcon=@"";
    self.str_ExpenseCatCode=@"";
    self.str_ExpenseCat=@"";
    self.int_DetailTypeIndex=0;
    self.str_IsUseCar=@"0";
    self.arr_table = [NSMutableArray array];
    
}

-(void)initializeHasData{
    
    self.str_flowCode=@"F0023";
    self.bool_isOpenDetail=NO;
    self.bool_SecisOpenDetail=NO;
    self.bool_ThirisOpenDetail=NO;
    self.dict_budgetInfo = [NSMutableDictionary dictionary];
}

-(NSString *)OpenFormUrl{
    if (self.int_formStatus==1) {
        return [NSString stringWithFormat:@"%@",NEWENTERTAINMENT];
    }else{
        return [NSString stringWithFormat:@"%@",HASENTERTAINMENT];
    }
}

-(void)DealWithFormBaseData{
    NSDictionary *result=[self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        
        [self getFormSettingBaseData:result];
        
        //获取预算详情
        [self getFormBudgetInfoWithDict:result];
        
        if (self.int_formStatus==1) {
            //币种
            [self getCurrencyData:result];
        }
        self.bool_DetailsShow=[[NSString stringWithFormat:@"%@",result[@"entertainmentDetail"]] isEqualToString:@"1"]?YES:NO;
        self.bool_SecDetailsShow=[[NSString stringWithFormat:@"%@",result[@"entertainmentPlan"]] isEqualToString:@"1"]?YES:NO;
        self.bool_ThirDetailsShow=[[NSString stringWithFormat:@"%@",result[@"entertainmentVisitor"]] isEqualToString:@"1"]?YES:NO;

        
        //主表数据
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        if (![formDict isKindOfClass:[NSNull class]]) {
            
            [self getFirGroupDetail:formDict];
            [self getSecGroupDetail:formDict WithTableName:@"detailFilesFld"];
            [self getThirGroupDetail:formDict WithTableName:@"entertainmentVisitorFld"];

            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dict in mainFld) {
                    [self getMainFormShowAndData:dict WithAttachmentsMaxCount:5];
                    if ([dict[@"fieldName"]isEqualToString:@"Type"]) {
                        self.str_Type = [dict objectForKey:@"fieldValue"];
                    }
                    if ([dict[@"fieldName"]isEqualToString:@"TypeId"]) {
                        self.str_TypeId = [dict objectForKey:@"fieldValue"];
                    }
                }
            }
        }
        
        //明细数据
        NSDictionary *formDataDict=[result objectForKey:@"formData"];
        if ([formDataDict isKindOfClass:[NSDictionary class]]) {
            if ([formDataDict[@"sa_EntertainmentDetail"]isKindOfClass:[NSArray class]]) {
                NSArray *sa_DetailArray=formDataDict[@"sa_EntertainmentDetail"];
                for (NSDictionary *dict in sa_DetailArray) {
                    EntertainmentDeatil *model=[[EntertainmentDeatil alloc]init];
                    if (![dict[@"expenseCode"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseCode=[NSString stringWithFormat:@"%@",dict[@"expenseCode"]];
                    }
                    if (![dict[@"expenseType"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseType=[NSString stringWithFormat:@"%@",dict[@"expenseType"]];
                    }
                    if (![dict[@"expenseIcon"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseIcon=[NSString stringWithFormat:@"%@",dict[@"expenseIcon"]];
                    }
                    if (![dict[@"expenseCatCode"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseCatCode=[NSString stringWithFormat:@"%@",dict[@"expenseCatCode"]];
                    }
                    if (![dict[@"expenseCat"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseCat=[NSString stringWithFormat:@"%@",dict[@"expenseCat"]];
                    }
                    if (![dict[@"expenseDesc"] isKindOfClass:[NSNull class]]) {
                        model.ExpenseDesc=[NSString stringWithFormat:@"%@",dict[@"expenseDesc"]];
                    }
                    if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                        model.Amount = [NSString reviseString:dict[@"amount"]];
                    }
                    if (![dict[@"remark"] isKindOfClass:[NSNull class]]) {
                        model.Remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
                    }
                    [self.arr_DetailsDataArray addObject:model];
                }
            }
            
            if ([formDataDict[@"sa_EntertainmentVisitor"]isKindOfClass:[NSArray class]]) {
                NSArray *sa_DetailArray=formDataDict[@"sa_EntertainmentVisitor"];
                for (NSDictionary *dict in sa_DetailArray) {
                    EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
                    if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
                        model.Name=[NSString stringWithFormat:@"%@",dict[@"name"]];
                    }
                    if (![dict[@"jobTitle"] isKindOfClass:[NSNull class]]) {
                        model.JobTitle=[NSString stringWithFormat:@"%@",dict[@"jobTitle"]];
                    }
                    if (![dict[@"department"] isKindOfClass:[NSNull class]]) {
                        model.Department=[NSString stringWithFormat:@"%@",dict[@"department"]];
                    }
                    if (![dict[@"visitDate"] isKindOfClass:[NSNull class]]) {
                        model.VisitDate=[NSString stringWithFormat:@"%@",dict[@"visitDate"]];
                    }
                    if (![dict[@"leaveDate"] isKindOfClass:[NSNull class]]) {
                        model.LeaveDate=[NSString stringWithFormat:@"%@",dict[@"leaveDate"]];
                    }
                    if (![dict[@"costCenter"] isKindOfClass:[NSNull class]]) {
                        model.CostCenter=[NSString stringWithFormat:@"%@",dict[@"costCenter"]];
                    }
                    if (![dict[@"costCenterId"] isKindOfClass:[NSNull class]]) {
                        model.CostCenterId=[NSString stringWithFormat:@"%@",dict[@"costCenterId"]];
                    }
                    if (![dict[@"budgetAmt"] isKindOfClass:[NSNull class]]) {
                        model.BudgetAmt=[NSString stringWithFormat:@"%@",dict[@"budgetAmt"]];
                    }
                    if (![dict[@"remark"] isKindOfClass:[NSNull class]]) {
                        model.Remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
                    }
                    [self.arr_ThirDetailsDataArray addObject:model];
                }
            }
            
            if ([formDataDict[@"sa_EntertainmentPlan"]isKindOfClass:[NSArray class]]) {
                NSArray *sa_DetailArray=formDataDict[@"sa_EntertainmentPlan"];
                for (NSDictionary *dict in sa_DetailArray) {
                    EntertainmentSchDeatil *model=[[EntertainmentSchDeatil alloc]init];
                    if (![dict[@"entertainDate"] isKindOfClass:[NSNull class]]) {
                        model.EntertainDate=[NSString stringWithFormat:@"%@",dict[@"entertainDate"]];
                    }
                    if (![dict[@"entertainAddr"] isKindOfClass:[NSNull class]]) {
                        model.EntertainAddr=[NSString stringWithFormat:@"%@",dict[@"entertainAddr"]];
                    }
                    if (![dict[@"entertainContent"] isKindOfClass:[NSNull class]]) {
                        model.EntertainContent=[NSString stringWithFormat:@"%@",dict[@"entertainContent"]];
                    }
                    [self.arr_SecDetailsDataArray addObject:model];
                }
            }
        }
    }
}

-(void)inModelContent{
    self.SubmitData=[[EntertainmentData alloc]init];
    
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

    
    self.SubmitData.BudgetInfo=@"";
    self.SubmitData.IsOverBud=@"0";
    
    self.SubmitData.Type = self.str_Type;
    self.SubmitData.TypeId = self.str_TypeId;

    self.SubmitData.ClientId = self.personalData.ClientId;
    self.SubmitData.ClientName = self.personalData.ClientName;
    self.SubmitData.SupplierId = self.personalData.SupplierId;
    self.SubmitData.SupplierName = self.personalData.SupplierName;
    
    self.SubmitData.ProjId = self.personalData.ProjId;
    self.SubmitData.ProjName = self.personalData.ProjName;
    self.SubmitData.ProjMgrUserId = self.personalData.ProjMgrUserId;
    self.SubmitData.ProjMgr = self.personalData.ProjMgr;
    self.SubmitData.IsProjMgr = [[NSString stringWithFormat:@"%@",self.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.personalData.ProjMgrUserId]] ? @"1":@"0";

    self.SubmitData.IsUseCar = self.str_IsUseCar;

    self.SubmitData.CurrencyCode=self.str_CurrencyCode;
    self.SubmitData.Currency=self.str_Currency;
    self.SubmitData.ExchangeRate=self.str_ExchangeRate;
    
    
    self.SubmitData.ExpenseCode=self.str_ExpenseCode;
    self.SubmitData.ExpenseType=self.str_ExpenseType;
    self.SubmitData.ExpenseIcon=self.str_ExpenseIcon;
    self.SubmitData.ExpenseCatCode=self.str_ExpenseCatCode;
    self.SubmitData.ExpenseCat=self.str_ExpenseCat;
    self.SubmitData.CapitalizedAmount=@"";
}

-(NSString *)testModel{
    EntertainmentData *model=self.SubmitData;
    NSString *returnTips;
    NSMutableDictionary *modeldic = [EntertainmentData initDicByModel:model];
    for (NSString *str in self.arr_isShowmsArray) {
        NSString *key = str;
        if ([key isEqualToString:@"DetailList"]) {
            for (NSString *str in self.arr_isShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_isRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (EntertainmentDeatil *model in self.arr_DetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"ExpenseCode"]){
                            detailStr=model.ExpenseCode;
                        }else if ([str isEqualToString:@"ExpenseDesc"]){
                            detailStr=model.ExpenseDesc;
                        }else if ([str isEqualToString:@"Amount"]){
                            detailStr=model.Amount;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"ThirDetailList"]){
            for (NSString *str in self.arr_ThirisShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_ThirisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (EntertainmentVisitorDeatil *model in self.arr_ThirDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"Name"]){
                            detailStr=model.Name;
                        }else if ([str isEqualToString:@"JobTitle"]){
                            detailStr=model.JobTitle;
                        }else if ([str isEqualToString:@"Department"]){
                            detailStr=model.Department;
                        }else if ([str isEqualToString:@"VisitDate"]){
                            detailStr=model.VisitDate;
                        }else if ([str isEqualToString:@"LeaveDate"]){
                            detailStr=model.LeaveDate;
                        }else if ([str isEqualToString:@"CostCenter"]){
                            detailStr=model.CostCenter;
                        }else if ([str isEqualToString:@"BudgetAmt"]){
                            detailStr=model.BudgetAmt;
                        }else if ([str isEqualToString:@"Remark"]){
                            detailStr=model.Remark;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorThirDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else if ([key isEqualToString:@"SecDetailList"]){
            for (NSString *str in self.arr_SecisShowmDetailArray) {
                NSString *i=[NSString stringWithFormat:@"%@",[self.dict_SecisRequiredmsDetaildic objectForKey:str]];
                if ([i isEqualToString:@"1"]) {
                    for (EntertainmentSchDeatil *model in self.arr_SecDetailsDataArray) {
                        NSString *detailStr;
                        if ([str isEqualToString:@"EntertainDate"]){
                            detailStr=model.EntertainDate;
                        }else if ([str isEqualToString:@"EntertainAddr"]){
                            detailStr=model.EntertainAddr;
                        }else if ([str isEqualToString:@"EntertainContent"]){
                            detailStr=model.EntertainContent;
                        }
                        if (![NSString isEqualToNull:detailStr]) {
                            returnTips=[self showerrorDetail:str];
                            goto when_failed;
                        }
                    }
                }
            }
        }else{
            if ([key isEqualToString:@"OverTime"]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"VisitDate"]]&&[NSString isEqualToNullAndZero:[modeldic objectForKey:@"LeaveDate"]]) {
                
                NSDate *date1 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"LeaveDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:[modeldic objectForKey:@"VisitDate"] WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0)
                {
                    returnTips=[self showerror:@"OverTime"];
                    break ;
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
        showinfo = Custing(@"请输入接待事由", nil);
    }else if([info isEqualToString:@"ReceptionObj"]) {
        showinfo = Custing(@"请输入接待对象", nil);
    }else if([info isEqualToString:@"VisitDate"]) {
        showinfo = Custing(@"请选择来访时间", nil);
    }else if([info isEqualToString:@"LeaveDate"]) {
        showinfo = Custing(@"请选择离开时间", nil);
    }else if([info isEqualToString:@"OverTime"]) {
        showinfo = Custing(@"来访时间不能大于等于离开时间", nil);
    }else if([info isEqualToString:@"Visitor"]) {
        showinfo = Custing(@"请输入主要来访人员", nil);
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if([info isEqualToString:@"ExpenseDesc"]) {
        showinfo = Custing(@"请输入费用描述", nil);
    }else if([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称", nil);
    }else if([info isEqualToString:@"ClientId"]) {
        showinfo = Custing(@"请选择客户", nil);
    }else if([info isEqualToString:@"SupplierId"]) {
        showinfo = Custing(@"请选择供应商", nil);
    }else if([info isEqualToString:@"RentCarFee"]) {
        showinfo = Custing(@"请输入租车费", nil);
    }else if([info isEqualToString:@"Pontage"]) {
        showinfo = Custing(@"请输入路桥费", nil);
    }else if([info isEqualToString:@"MealFee"]) {
        showinfo = Custing(@"请输入餐费", nil);
    }else if([info isEqualToString:@"HotelFee"]) {
        showinfo = Custing(@"请输入住宿费", nil);
    }else if([info isEqualToString:@"OtherFee"]) {
        showinfo = Custing(@"请输入其他费用", nil);
    }else if([info isEqualToString:@"EstimatedAmount"]) {
        showinfo = Custing(@"请输入预计总金额", nil);
    }else if([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种", nil);
    }else if([info isEqualToString:@"ExchangeRate"]) {
        showinfo = Custing(@"请输入汇率", nil);
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
    if ([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if ([info isEqualToString:@"ExpenseDesc"]) {
        showinfo = Custing(@"请输入费用描述", nil);
    }else if ([info isEqualToString:@"Amount"]) {
        showinfo = Custing(@"请输入预估金额", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }else if ([info isEqualToString:@"EntertainDate"]) {
        showinfo = Custing(@"请选择日期", nil);
    }else if ([info isEqualToString:@"EntertainAddr"]) {
        showinfo = Custing(@"请输入地点", nil);
    }else if ([info isEqualToString:@"EntertainContent"]) {
        showinfo = Custing(@"请输入内容", nil);
    }
    return showinfo;
}

-(NSString *)showerrorThirDetail:(NSString*)info{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"Name"]) {
        showinfo = Custing(@"请输入来访人员姓名", nil);
    }else if ([info isEqualToString:@"JobTitle"]) {
        showinfo = Custing(@"请输入来访人员职位", nil);
    }else if ([info isEqualToString:@"Department"]) {
        showinfo = Custing(@"请输入来访人员部门", nil);
    }else if ([info isEqualToString:@"VisitDate"]) {
        showinfo = Custing(@"请选择来访时间", nil);
    }else if ([info isEqualToString:@"LeaveDate"]) {
        showinfo = Custing(@"请选择离开时间", nil);
    }else if ([info isEqualToString:@"CostCenter"]) {
        showinfo = Custing(@"请选择成本中心", nil);
    }else if ([info isEqualToString:@"BudgetAmt"]) {
        showinfo = Custing(@"请输入预算费用", nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注", nil);
    }
    return showinfo;
}

-(void)contectData{
    self.dict_parametersDict=[NSDictionary dictionary];
    NSMutableArray *mainArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_EntertainmentApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *modelDic=[EntertainmentData initDicByModel:self.SubmitData];
    for(id key in modelDic)
    {
        [fieldNamesArr addObject:key];
        [fieldValuesArr addObject:[modelDic objectForKey:key]];
    }
    [Sa_EntertainmentApp setObject:@"Sa_EntertainmentApp" forKey:@"tableName"];
    [Sa_EntertainmentApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_EntertainmentApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainArray addObject:Sa_EntertainmentApp];
    
    
    NSMutableArray *detailedArray=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *Sa_EntertainmentDetail = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames = [NSArray array];
    NSMutableArray *Values=[NSMutableArray array];
    if (self.arr_DetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[EntertainmentDeatil initDicByModel:self.arr_DetailsDataArray[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (EntertainmentDeatil *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    if ([key isEqualToString:@"Amount"]) {
                        [array addObject:@"0"];
                    }else{
                        [array addObject:(id)[NSNull null]];
                    }
                }
            }
            [Values addObject:array];
        }
        [Sa_EntertainmentDetail setObject:@"Sa_EntertainmentDetail" forKey:@"tableName"];
        [Sa_EntertainmentDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_EntertainmentDetail setObject:Values forKey:@"fieldBigValues"];
    }else{
        [Sa_EntertainmentDetail setObject:@"Sa_EntertainmentDetail" forKey:@"tableName"];
        [Sa_EntertainmentDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_EntertainmentDetail setObject:Values forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_EntertainmentDetail];
    
    
    NSMutableDictionary *Sa_EntertainmentVisitor = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames1 = [NSArray array];
    NSMutableArray *Values1 = [NSMutableArray array];
    if (self.arr_ThirDetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[EntertainmentVisitorDeatil initDicByModel:self.arr_ThirDetailsDataArray[0]];
        fieldNames1 = [modelsDic allKeys];
        for (NSString *key in fieldNames1) {
            NSMutableArray  *array=[NSMutableArray array];
            for (EntertainmentVisitorDeatil *model in self.arr_ThirDetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values1 addObject:array];
        }
        [Sa_EntertainmentVisitor setObject:@"Sa_EntertainmentVisitor" forKey:@"tableName"];
        [Sa_EntertainmentVisitor setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_EntertainmentVisitor setObject:Values1 forKey:@"fieldBigValues"];
    }else{
        [Sa_EntertainmentVisitor setObject:@"Sa_EntertainmentVisitor" forKey:@"tableName"];
        [Sa_EntertainmentVisitor setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_EntertainmentVisitor setObject:Values1 forKey:@"fieldBigValues"];
    }
    [detailedArray addObject:Sa_EntertainmentVisitor];
    
    
    NSMutableDictionary *Sa_EntertainmentPlan = [[NSMutableDictionary alloc]init];
    NSArray *fieldNames2 = [NSArray array];
    NSMutableArray *Values2 = [NSMutableArray array];
    if (self.arr_SecDetailsDataArray.count!=0) {
        NSMutableDictionary *modelsDic=[EntertainmentSchDeatil initDicByModel:self.arr_SecDetailsDataArray[0]];
        fieldNames2 = [modelsDic allKeys];
        for (NSString *key in fieldNames2) {
            NSMutableArray  *array=[NSMutableArray array];
            for (EntertainmentSchDeatil *model in self.arr_SecDetailsDataArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values2 addObject:array];
        }
        [Sa_EntertainmentPlan setObject:@"Sa_EntertainmentPlan" forKey:@"tableName"];
        [Sa_EntertainmentPlan setObject:fieldNames2 forKey:@"fieldNames"];
        [Sa_EntertainmentPlan setObject:Values2 forKey:@"fieldBigValues"];
    }else{
        [Sa_EntertainmentPlan setObject:@"Sa_EntertainmentPlan" forKey:@"tableName"];
        [Sa_EntertainmentPlan setObject:fieldNames2 forKey:@"fieldNames"];
        [Sa_EntertainmentPlan setObject:Values2 forKey:@"fieldBigValues"];
    }
    
    [detailedArray addObject:Sa_EntertainmentPlan];

    self.dict_parametersDict=@{@"mainDataList":mainArray,@"detailedDataList":detailedArray};
}
-(void)contectHasDataWithTableName:(NSString *)tableName{
    //    NSLog(@"子类必须实现方法%s",__FUNCTION__);
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate", nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName,self.str_BudgetSubDate, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(NSString *)getTableName{
    return [NSString stringWithFormat:@"%@",@"Sa_EntertainmentApp"];
}
-(NSString *)getCommonField{
    NSDictionary *dict=@{@"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
    return [NSString transformToJson:dict];
}
-(NSDictionary *)getCheckSubmitOtherPar{
    
    return  @{@"AdvanceTaskId":@"",@"OtherTaskId":@"",@"OtherFlowCode":@""};
}

@end
