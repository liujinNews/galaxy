//
//  FormBaseModel.m
//  galaxy
//
//  Created by hfk on 2017/12/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "userData.h"
#import "pmtMethodDetail.h"
#import "CurrencySumModel.h"

@implementation FormBaseModel
-(instancetype)initBaseWithStatus:(NSInteger)status{
    self = [super init];
    if (self) {
        self.int_formStatus = status;
        self.userdatas = [userData shareUserData];
        if (self.int_formStatus == 1) {
            [self FormBase_initNewData];
        }else{
            [self FormBase_initHasData];
        }
    }
    return self;
}

-(void)FormBase_initNewData{
    
    self.str_taskId = @"0";
    self.str_procId = @"0";
    self.str_userId = @"0";
    self.int_comeStatus = 1;
    self.personalData = [[SubmitPersonalModel alloc]init];
    self.model_ReserverModel = [[ReserverdMainModel alloc]init];
    self.model_ApprovelPeoModel = [[MyProcurementModel alloc]init];
    self.dict_isRequiredmsdic = [[NSMutableDictionary alloc]init];
    self.dict_isCtrlTypdic = [[NSMutableDictionary alloc]init];
    self.dict_reservedDic = [[NSMutableDictionary alloc]init];
    self.arr_FormMainArray = [NSMutableArray array];
    self.arr_noteDateArray = [NSMutableArray array];
    self.str_imageDataString = @"";
    self.arr_imagesArray = [NSMutableArray array];
    self.arr_totalFileArray = [NSMutableArray array];
    self.str_lastAmount = @"";
    self.arr_CurrencyCode = [NSMutableArray array];
    self.str_Currency = @"";
    self.str_CurrencyCode = @"";
    self.arr_TaxRates = [NSMutableArray array];
    
    self.str_firstHanderId = @"";
    self.str_firstHanderPhotoGraph = @"";
    self.str_firstHandlerGender = @"";
    self.str_firstHanderName = @"";
    
    self.str_BudgetSubDate = (id)[NSNull null];
    self.bool_isOpenDetail = NO;
    self.bool_SecisOpenDetail = NO;
    self.bool_ThirisOpenDetail = NO;
    self.bool_FourisOpenDetail = NO;
    self.bool_ThirdHaveAttchs = NO;
    self.bool_FourthHaveAttchs = NO;
    self.str_IsDeptBearExps = @"1";
    
}
-(void)FormBase_initHasData{
    
    self.int_comeStatus = 1;
    self.personalData = [[SubmitPersonalModel alloc]init];
    self.model_ReserverModel = [[ReserverdMainModel alloc]init];
    self.dict_isRequiredmsdic = [[NSMutableDictionary alloc]init];
    self.dict_isCtrlTypdic = [[NSMutableDictionary alloc]init];
    self.dict_reservedDic = [[NSMutableDictionary alloc]init];
    self.arr_FormMainArray = [NSMutableArray array];
    self.arr_noteDateArray = [NSMutableArray array];
    self.arr_TaxRates = [NSMutableArray array];
    self.str_imageDataString = @"";
    self.arr_imagesArray = [NSMutableArray array];
    self.arr_totalFileArray = [NSMutableArray array];
    self.arr_CurrencyCode = [NSMutableArray array];
    self.bool_isOpenDetail = NO;
    self.bool_SecisOpenDetail = NO;
    self.bool_ThirisOpenDetail = NO;
    self.bool_FourisOpenDetail = NO;
    self.str_twoHandeId = @"";
    self.str_twoApprovalName = @"";
    self.str_BudgetSubDate = (id)[NSNull null];;
    self.str_beforeBudgetSubDate = (id)[NSNull null];;
    self.str_IsDeptBearExps = @"1";
    
}

-(NSDictionary *)OpenFormParameters{
    return @{@"TaskId":self.str_taskId,
             @"ProcId":self.str_procId,
             @"FlowGuid":self.str_flowGuid
             };
}
-(NSDictionary *)ApproveNoteOrFlowChartOrPushLinkParameters{
    
    return @{@"TaskId":self.str_taskId
             };
}
-(NSString *)ApproveNoteUrl{
    return [NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
}

-(NSString *)PrintLinkUrl{
    return [NSString stringWithFormat:@"%@",GETPrintLink];
}

-(NSString *)reCallUrl{
    return [NSString stringWithFormat:@"%@",RecallList];
}

-(NSDictionary *)reCallParameters{
    return @{@"FlowCode":self.str_flowCode,
             @"TaskId":self.str_taskId,
             @"RecallType":self.int_comeStatus==7?@"2":@"1"
             };
}

-(NSString *)urgeUrl{
    return [NSString stringWithFormat:@"%@",BPMURGE];
}

-(NSDictionary *)urgeParameters{
    return @{@"FlowCode":self.str_flowCode,
             @"TaskId":self.str_taskId
             };
}

-(void)getFormSettingBaseData:(NSDictionary *)result{
    if (self.int_formStatus==1) {

        self.str_directType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"directType"]]]?[NSString stringWithFormat:@"%@",result[@"directType"]]:@"0";
    }else{

        self.str_canEndorse = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"canEndorse"]]]?[NSString stringWithFormat:@"%@",result[@"canEndorse"]]:@"0";

        self.str_SerialNo = [NSString stringWithFormat:@"%@",[result objectForKey:@"serialNo"]];

        self.bool_isPrint = [[NSString stringWithFormat:@"%@",result[@"isPrint"]]isEqualToString:@"1"] ? YES:NO;
    }
    

    if ([[NSString stringWithFormat:@"%@",result[@"deadlineDateTime"]] length] == 10) {
        self.str_deadlineDateTime = result[@"deadlineDateTime"];
    }else{
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.dateFormat = @"yyyy/MM/dd";
        self.str_deadlineDateTime = [pickerFormatter stringFromDate:[NSDate date]];
    }
    self.str_deadlineDateTime = [self.str_deadlineDateTime substringToIndex:7];
    self.arr_overDueList = [result[@"overduePeriodOfList"] isKindOfClass:[NSArray class]] ? [NSMutableArray arrayWithArray:result[@"overduePeriodOfList"]]:[NSMutableArray array];
    if ([NSString isEqualToNullAndZero:result[@"expirationTime"]] && ![result[@"expirationTime"] isEqualToString:@"0001/01/01"]) {
        self.str_expirationTime = result[@"expirationTime"];
        self.bool_limitExpirationTime = ([result[@"isLimitExpirationTime"] floatValue] == 1 ? YES:NO);
    }
    

    if ([result[@"isReceiptOfInv"]floatValue] == 1 && self.int_comeStatus == 3) {
        self.bool_ReceiptOfInv = YES;
    }
    

    if ([result[@"signInfo"] isKindOfClass:[NSDictionary class]]) {
        self.dict_SignInfo = result[@"signInfo"];
    }
    
    self.bool_IsAllowModCostCgyOrInvAmt = ([result[@"isAllowModCostCgyOrInvAmt"] floatValue] == 1 ? YES:NO);


    
    self.str_flowGuid = [NSString stringIsExist:result[@"flowGuid"]];
    
    self.str_SupplierParam = [NSString isEqualToNull:result[@"beneficiaryParam"]] ? [NSString stringWithFormat:@"%@",result[@"beneficiaryParam"]]:@"0";
    

    if ([result[@"formRule"]isKindOfClass:[NSDictionary class]]) {
        NSDictionary *formRule = result[@"formRule"];

        if ([formRule[@"claimPolicy"]isKindOfClass:[NSDictionary class]]) {
            self.dict_ReimPolicyDict = formRule[@"claimPolicy"];
        }

        self.bool_IsHasShowProject = [formRule[@"isHasShowAllProject"] boolValue];
        
        if (self.int_formStatus != 1) {

            self.bool_IsAllowExpand = [formRule[@"isAllowExpand"] boolValue];
        }
    }
    

    if (![result[@"isDataIntegrity"]isKindOfClass:[NSNull class]]) {
        self.bool_isDataIntegrity =  [result[@"isDataIntegrity"] boolValue];
    }
    

    if ([result[@"taxRates"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getTaxRatesWithDate:result[@"taxRates"] WithResult:self.arr_TaxRates];
    }
    

    self.arr_New_InvoiceTypes = [NSMutableArray array];
    if ([result[@"invoiceTypes"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getInvoiceTypesWithDate:result[@"invoiceTypes"] WithResult:self.arr_New_InvoiceTypes];
    }
    self.arr_CurrencyCode = [NSMutableArray array];
    if ([result[@"currencys"]isKindOfClass:[NSArray class]]) {
        [self getCurrencyData:result];
    }

    if ([result[@"customsV2"] isKindOfClass:[NSArray class]]) {
        NSArray *array = result[@"customsV2"];
        for (NSDictionary *dic in array) {
            MyProcurementModel *model=[[MyProcurementModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.arr_FormMainArray addObject:model];
            
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved1"]) {
                self.personalData.UserReserved1=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved2"]) {
                self.personalData.UserReserved2=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved3"]) {
                self.personalData.UserReserved3=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved4"]) {
                self.personalData.UserReserved4=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved5"]) {
                self.personalData.UserReserved5=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved6"]) {
                self.personalData.UserReserved6=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved7"]) {
                self.personalData.UserReserved7=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved8"]) {
                self.personalData.UserReserved8=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved9"]) {
                self.personalData.UserReserved9=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([dic[@"fieldName"] isEqualToString:@"UserReserved10"]) {
                self.personalData.UserReserved10=[NSString stringWithFormat:@"%@",model.fieldValue];
            }
        }
    }
}

-(void)getCurrencyData:(NSDictionary *)dict{

    NSMutableDictionary *Currencydict=[NSMutableDictionary dictionary];
    NSMutableArray *arr;
    
    if (dict[@"currencys"]&&[dict[@"currencys"] isKindOfClass:[NSArray class]]) {
        arr=[NSMutableArray arrayWithArray:dict[@"currencys"]];
    }else if (dict[@"currency"]&&[dict[@"currency"] isKindOfClass:[NSArray class]]){
        arr=[NSMutableArray arrayWithArray:dict[@"currency"]];
    }else{
        arr=[NSMutableArray array];
    }
    [STOnePickModel getCurrcyWithDate:arr WithResult:self.arr_CurrencyCode WithCurrencyDict:Currencydict];
    self.str_CurrencyCode=Currencydict[@"CurrencyCode"];
    self.str_ExchangeRate=Currencydict[@"ExchangeRate"];
    self.str_Currency=Currencydict[@"Currency"];
    self.dict_CurrencyCodeParameter = Currencydict;
}

-(void)getFirGroupDetail:(NSDictionary *)dict{
    if (self.bool_DetailsShow) {
        
        self.dict_isRequiredmsDetaildic=[[NSMutableDictionary alloc]init];
        self.arr_isShowmDetailArray=[[NSMutableArray alloc]init];
        self.arr_DetailsArray=[NSMutableArray array];
        self.arr_DetailsDataArray=[NSMutableArray array];

        if ([[dict objectForKey:@"detailFld"] isKindOfClass:[NSArray class]]) {
            NSArray *detailFld = [dict objectForKey:@"detailFld"];
            for (NSDictionary *dic in detailFld) {
                if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (![model.fieldName isEqualToString:@"Attachments"]) {
                        [self.arr_DetailsArray addObject:model];
                    }
                    [self.arr_isShowmDetailArray addObject:model.fieldName];
                    [self.dict_isRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                }
            }
        }
    }
}
-(void)getSecGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName{
    if (self.bool_SecDetailsShow) {
        self.dict_SecisRequiredmsDetaildic=[[NSMutableDictionary alloc]init];
        self.arr_SecisShowmDetailArray=[[NSMutableArray alloc]init];
        self.arr_SecDetailsArray=[NSMutableArray array];
        self.arr_SecDetailsDataArray=[NSMutableArray array];

        if ([[dict objectForKey:tabName] isKindOfClass:[NSArray class]]) {
            NSArray *detailFld = [dict objectForKey:tabName];
            for (NSDictionary *dic in detailFld) {
                if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    if ([model.fieldName isEqualToString:@"Attachments"]) {
                        self.bool_SecHaveAttchs = YES;
                    }
                    [self.arr_SecDetailsArray addObject:model];
                    [self.arr_SecisShowmDetailArray addObject:model.fieldName];
                    [self.dict_SecisRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                }
            }
        }
    }
}
-(void)getThirGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName{
    if (self.bool_ThirDetailsShow) {
        self.dict_ThirisRequiredmsDetaildic=[[NSMutableDictionary alloc]init];
        self.arr_ThirisShowmDetailArray=[[NSMutableArray alloc]init];
        self.arr_ThirDetailsArray=[NSMutableArray array];
        self.arr_ThirDetailsDataArray=[NSMutableArray array];

        if ([[dict objectForKey:tabName] isKindOfClass:[NSArray class]]) {
            NSArray *detailFld = [dict objectForKey:tabName];
            for (NSDictionary *dic in detailFld) {
                if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    if ([model.fieldName isEqualToString:@"Attachments"]) {
                        self.bool_ThirdHaveAttchs = YES;
                    }
                    [self.arr_ThirDetailsArray addObject:model];
                    [self.arr_ThirisShowmDetailArray addObject:model.fieldName];
                    [self.dict_ThirisRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                }
            }
        }
    }
}
- (void)getFouGroupDetail:(NSDictionary *)dict WithTableName:(NSString *)tabName{
    if (self.bool_FouDetailsShow) {
        self.dict_FouisRequiredmsDetaildic = [[NSMutableDictionary alloc] init];
        self.arr_FouisShowmDetailArray = [[NSMutableArray alloc] init];
        self.arr_FouDetailsArray = [NSMutableArray array];
        self.arr_FouDetailsDataArray = [NSMutableArray array];
        if ([[dict objectForKey:tabName] isKindOfClass:[NSArray class]]) {
            NSArray *detailFld = [dict objectForKey:tabName];
            for (NSDictionary *dic in detailFld) {
                if ([[[dic objectForKey:@"isShow"]stringValue]isEqualToString:@"1"]) {
                    MyProcurementModel *model = [[MyProcurementModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    if ([model.fieldName isEqualToString:@"Attachments"]) {
                        self.bool_FourthHaveAttchs = YES;
                    }
                    [self.arr_FouDetailsArray addObject:model];
                    [self.arr_FouisShowmDetailArray addObject:model.fieldName];
                    [self.dict_FouisRequiredmsDetaildic setValue:model.isRequired forKey:model.fieldName];
                }
            }
        }
    }
}

-(void)getMainFormShowAndData:(NSDictionary *)dict WithAttachmentsMaxCount:(NSInteger)maxCount{
    
    MyProcurementModel *model=[[MyProcurementModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    if (self.int_formStatus == 1) {
        if ([self.str_flowCode isEqualToString:@"F0004"]) {
            model.isOnlyRead = [NSString stringWithId:dict[@"isReadOnly"]];
        }
    }else if (self.int_formStatus == 3){
        if ([self.str_flowCode isEqualToString:@"F0002"]||[self.str_flowCode isEqualToString:@"F0003"]||[self.str_flowCode isEqualToString:@"F0009"]||[self.str_flowCode isEqualToString:@"F0010"]) {
            model.isOnlyRead = @"1";
        }
    }
    
    [self.arr_FormMainArray addObject:model];
    
    [self.dict_isCtrlTypdic setValue:model.ctrlTyp forKey:model.fieldName];
    
    if (self.int_formStatus==1) {
        
        if ([dict[@"fieldName"] isEqualToString:@"FirstHandlerUserName"]) {
            self.model_ApprovelPeoModel=model;
        }
        if ([model.fieldName isEqualToString:@"ApprovalMode"]) {
            self.model_ApprovalMode=model;
        }
        if ([dict[@"fieldName"]isEqualToString:@"FirstHandlerUserId"]) {
            self.str_firstHanderId = dict[@"fieldValue"];
        }
        
        if ([dict[@"fieldName"]isEqualToString:@"FirstHandlerGender"]) {
            self.str_firstHandlerGender = dict[@"fieldValue"];
        }
        
        if ([dict[@"fieldName"] isEqualToString:@"FirstHandlerPhotoGraph"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:model.fieldValue];
                self.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
            }
        }
    }else{
        if ([dict[@"fieldName"] isEqualToString:@"RequestorPhotoGraph"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:model.fieldValue];
                self.personalData.RequestorPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
            }
        }
        if ([dict[@"fieldName"] isEqualToString:@"RequestorGender"]) {
            self.personalData.RequestorGender = dict[@"fieldValue"];
        }
    }
    

    if ([dict[@"fieldName"] isEqualToString:@"Operator"]) {
        self.personalData.Operator = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"OperatorUserId"]) {
        self.personalData.OperatorUserId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"OperatorDept"]) {
        self.personalData.OperatorDept = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"OperatorDeptId"]) {
        self.personalData.OperatorDeptId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"Requestor"]) {
        self.personalData.Requestor = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorUserId"]) {
        self.personalData.RequestorUserId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"Contact"]) {
        self.personalData.Contact=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorDept"]) {
        self.personalData.RequestorDept=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorDeptId"]) {
        self.personalData.RequestorDeptId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"JobTitle"]) {
        self.personalData.JobTitle=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"JobTitleCode"]) {
        self.personalData.JobTitleCode=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"JobTitleLvl"]) {
        self.personalData.JobTitleLvl=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"UserLevel"]) {
        self.personalData.UserLevel=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"UserLevelId"]) {
        self.personalData.UserLevelId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"HRID"]) {
        self.personalData.Hrid=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"Branch"]) {
        self.personalData.Branch=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"BranchId"]) {
        self.personalData.BranchId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CostCenter"]) {
        self.personalData.CostCenter=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CostCenterId"]) {
        self.personalData.CostCenterId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CostCenterMgrUserId"]) {
        self.personalData.CostCenterMgrUserId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CostCenterMgr"]) {
        self.personalData.CostCenterMgr = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorBusDept"]) {
        self.personalData.RequestorBusDept=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorBusDeptId"]) {
        self.personalData.RequestorBusDeptId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"Area"]) {
        self.personalData.Area=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"AreaId"]) {
        self.personalData.AreaId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"Location"]) {
        self.personalData.Location=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"LocationId"]) {
        self.personalData.LocationId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"UserLevelNo"]) {
        self.personalData.UserLevelNo=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ApproverId1"]) {
        self.personalData.ApproverId1=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ApproverId2"]) {
        self.personalData.ApproverId2=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ApproverId3"]) {
        self.personalData.ApproverId3=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ApproverId4"]) {
        self.personalData.ApproverId4=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ApproverId5"]) {
        self.personalData.ApproverId5=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorAccount"]) {
        self.personalData.RequestorAccount=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"RequestorDate"]) {
        self.personalData.RequestorDate=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CompanyId"]) {
        self.personalData.CompanyId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    
    

    if ([dict[@"fieldName"] isEqualToString:@"ProjId"]) {
        self.personalData.ProjId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjName"]) {
        self.personalData.ProjName = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjMgrUserId"]) {
        self.personalData.ProjMgrUserId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjMgr"]) {
        self.personalData.ProjMgr = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjectActivityLv1"]) {
        self.personalData.ProjectActivityLv1 = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjectActivityLv1Name"]) {
        self.personalData.ProjectActivityLv1Name = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjectActivityLv2"]) {
        self.personalData.ProjectActivityLv2 = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ProjectActivityLv2Name"]) {
        self.personalData.ProjectActivityLv2Name = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ClientId"]) {
        self.personalData.ClientId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ClientName"]) {
        self.personalData.ClientName = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"SupplierId"]) {
        self.personalData.SupplierId = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"SupplierName"]) {
        self.personalData.SupplierName = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExpenseIcon"]) {
        self.str_ExpenseIcon = dict[@"fieldValue"];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExpenseCatCode"]) {
        self.str_ExpenseCatCode = dict[@"fieldValue"];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExpenseCat"]) {
        self.str_ExpenseCat= dict[@"fieldValue"];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExpenseCode"]) {
        self.str_ExpenseCode = dict[@"fieldValue"];
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExpenseType"]) {
        self.str_ExpenseType = dict[@"fieldValue"];
    }
    
    if ([dict[@"fieldName"] isEqualToString:@"Currency"]) {
        self.str_Currency = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]?dict[@"fieldValue"]:self.str_Currency;
    }
    if ([dict[@"fieldName"] isEqualToString:@"CurrencyCode"]) {
        self.str_CurrencyCode = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]?dict[@"fieldValue"]:self.str_CurrencyCode;
    }
    if ([dict[@"fieldName"] isEqualToString:@"ExchangeRate"]) {
        self.str_ExchangeRate = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"fieldValue"]]]?dict[@"fieldValue"]:self.str_ExchangeRate;
    }
    
    if ([dict[@"fieldName"] isEqualToString:@"Attachments"]) {
        if (![model.fieldValue isKindOfClass:[NSNull class]]) {
            self.str_imageDataString=model.fieldValue;
            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
            for (NSDictionary *dict in array) {
                [self.arr_totalFileArray addObject:dict];
            }
            [GPUtils updateImageDataWithTotalArray:self.arr_totalFileArray WithImageArray:self.arr_imagesArray WithMaxCount:maxCount];
        }else{
            self.str_imageDataString=@"";
        }
    }
    if ([dict[@"fieldName"] isEqualToString:@"CcUsersId"]) {
        self.str_CcUsersId = dict[@"fieldValue"];
    }
    if ([dict[@"fieldName"] isEqualToString:@"CcUsersName"]) {
        self.str_CcUsersName = dict[@"fieldValue"];
    }
    
    if ([dict[@"fieldName"] isEqualToString:@"IsDeptBearExps"]) {
        self.str_IsDeptBearExps = [[NSString stringWithFormat:@"%@",dict[@"fieldValue"]] isEqualToString:@"0"] ? @"0":@"1";
    }
    if([dict[@"fieldName"] isEqualToString:@"FeeAppInfo"]){
        self.str_FeeAppInfo = [NSString stringWithFormat:@"%@",dict[@"fieldValue"]];
    }
}


-(void)getHasTaxExpenseList:(NSDictionary *)result{
    self.arr_hasTaxExpense = [NSMutableArray array];
    if ([result[@"expenseCodeList"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in result[@"expenseCodeList"]) {
            [self.arr_hasTaxExpense addObject:dict[@"expenseCode"]];
        }
    }
}

-(void)getApproveNoteData{
    NSDictionary *result=self.dict_resultDict[@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        if (self.int_formStatus == 2) {
            self.str_noteStatus = [NSString stringWithFormat:@"%@",result[@"statusCode"]];
        }
        NSArray *array = result[@"taskProcList"];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model = [[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.arr_noteDateArray addObject:model];
        }
    }
}

-(void)getEndShowArray{
    self.arr_isShowmsArray=[GPUtils filtOutSamefromData:self.arr_isShowmsArray toFiltData:self.arr_UnShowmsArray];
}

-(NSString *)getFlowChartUrl{
    return [NSString stringWithFormat:@"%@",GetTaskIdString];
}

-(void)inModelContent{
    
}
-(void)inModelHasApproveContent{
    
}

-(void)contectData{
    
}
-(void)showerror:(NSString*)info WithShowTips:(NSString *)tips{
    
}
-(void)showerrorDetail:(NSString*)info WithShowTips:(NSString *)tips{
    
}
-(NSString *)testModel{
    
    return nil;
}
-(void)addImagesInfo{
    NSUInteger index=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Attachments"];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:self.str_imageDataString];
}

-(void)addAttFileInfoWithKey:(NSString *)key withData:(NSString *)data{
    NSUInteger index=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:key];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:data];
}

-(void)contectHasDataWithTableName:(NSString *)tableName{

    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName", nil];
    if (![NSString isEqualToNull:self.str_twoHandeId]) {
        self.str_twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:self.str_twoHandeId,self.str_twoApprovalName, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
}

-(void)contectHasPayDataWithTableName:(NSString *)tableName{
    
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"twohandleruserid",@"twohandlerusername", nil];
    NSArray *travelfieldValues=[NSArray arrayWithObjects:@"",@"", nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":tableName};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    self.dict_parametersDict=@{@"mainDataList":mainArray};
    
}
-(NSString *)getCommonField{
    return nil;
}
-(NSString *)getSaveUrl;
{
    return [NSString stringWithFormat:@"%@",SAVE];
}
-(NSDictionary *)SaveFormDateWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField{
    NSDictionary *dict=@{@"RequestorUserId":self.personalData.RequestorUserId,
                         @"FlowGuid":self.str_flowGuid,
                         @"FlowCode":self.str_flowCode,
                         @"ActionLinkName":@"保存",
                         @"TaskId":self.str_taskId,
                         @"FormData":[NSString transformToJson:self.dict_parametersDict],
                         @"ExpIds":ExpIds,
                         @"Comment":Comment,
                         @"FeeNumber":[self getFeeNumber:self.dict_parametersDict],
                         @"ContractNumber":[self getContractNumber:self.dict_parametersDict],
                         @"AdvanceNumber":[self getAdvanceNumber:self.dict_parametersDict],
                         @"CommonField":CommonField
                         };
    return dict;
}


-(NSString *)getCheckSubmitUrl{
    return [NSString stringWithFormat:@"%@",CLAIMBUDGET];
}
-(NSDictionary *)getCheckSubmitOtherPar{
    return nil;
}
-(NSDictionary *)GetCheckSubmitWithAmount:(NSString *)Amount WithExpIds:(NSString *)ExpIds otherParameters:(NSDictionary *)parDict{
    NSDictionary *parameters = @{@"ExpenseCatCode":self.str_ExpenseCatCode,
                                 @"ExpenseCat":self.str_ExpenseCat,
                                 @"ExpenseType":self.str_ExpenseType,
                                 @"ExpenseCode":self.str_ExpenseCode,
                                 @"CostCenterId":self.personalData.CostCenterId,
                                 @"CostCenter":self.personalData.CostCenter,
                                 @"Amount":Amount,
                                 @"ExpIds":ExpIds,
                                 @"FlowCode":self.str_flowCode,
                                 @"ProjId":self.personalData.ProjId,
                                 @"ProjName":self.personalData.ProjName,
                                 @"ProjectActivityLv1":[NSString isEqualToNull:self.personalData.ProjectActivityLv1]?self.personalData.ProjectActivityLv1:(id)[NSNull null],
                                 @"ProjectActivityLv1Name":self.personalData.ProjectActivityLv1Name,
                                 @"ProjectActivityLv2":[NSString isEqualToNull:self.personalData.ProjectActivityLv2]?self.personalData.ProjectActivityLv2:(id)[NSNull null],
                                 @"ProjectActivityLv2Name":self.personalData.ProjectActivityLv2Name,
                                 @"AdvanceTaskId":parDict[@"AdvanceTaskId"]?parDict[@"AdvanceTaskId"]:@"",
                                 @"OtherTaskId":parDict[@"OtherTaskId"]?parDict[@"OtherTaskId"]:@"",
                                 @"OtherFlowCode":parDict[@"OtherFlowCode"]?parDict[@"OtherFlowCode"]:@"",
                                 @"PaymentExpDetails":parDict[@"PaymentExpDetails"] ? parDict[@"PaymentExpDetails"]:@"",
                                 @"PaymentTyp":parDict[@"PaymentTyp"]?parDict[@"PaymentTyp"]:@"",
                                 @"RelateContNo":parDict[@"RelateContNo"]?parDict[@"RelateContNo"]:@"",
                                 @"UserId":self.personalData.RequestorUserId
                                 };
    return parameters;
}


-(NSString *)getSubmitUrl{
    return [NSString stringWithFormat:@"%@",SUBMIT];
}
-(NSDictionary *)SubmitFormDateWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField{
    NSDictionary *dict=@{@"RequestorUserId":self.personalData.RequestorUserId,
                         @"FlowGuid":self.str_flowGuid,
                         @"FlowCode":self.str_flowCode,
                         @"ActionLinkName":@"提交",
                         @"TaskId":self.str_taskId,
                         @"FormData":[NSString transformToJson:self.dict_parametersDict],
                         @"ExpIds":ExpIds,
                         @"Comment":Comment,
                         @"FeeNumber":[self getFeeNumber:self.dict_parametersDict],
                         @"ContractNumber":[self getContractNumber:self.dict_parametersDict],
                         @"AdvanceNumber":[self getAdvanceNumber:self.dict_parametersDict],
                         @"CommonField":CommonField
                         };
    return dict;
}



-(NSString *)getBackSubmitUrl{
    return [NSString stringWithFormat:@"%@",APPROVAL];
}
-(NSDictionary *)SubmitFormAgainWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField{//
    NSDictionary *dict=@{@"ActionLinkName":@"提交",
                         @"Comment":Comment,
                         @"FlowCode":self.str_flowCode,
                         @"TaskId":self.str_taskId,
                         @"ProcId":self.str_procId,
                         @"FormData":[NSString transformToJson:self.dict_parametersDict],
                         @"ExpIds":ExpIds,
                         @"FeeNumber":[self getFeeNumber:self.dict_parametersDict],
                         @"ContractNumber":[self getContractNumber:self.dict_parametersDict],
                         @"AdvanceNumber":[self getAdvanceNumber:self.dict_parametersDict],
                         @"CommonField":CommonField
                         };
    
    return dict;
}


-(NSString *)getDirectUrl{
    return [NSString stringWithFormat:@"%@",Direct];
}
-(NSDictionary *)DirectFormWithExpIds:(NSString *)ExpIds WithComment:(NSString *)Comment WithCommonField:(NSString *)CommonField{
    NSDictionary *dict=@{@"FlowGuid":self.str_flowGuid,
                         @"FlowCode":self.str_flowCode,
                         @"TaskId":self.str_taskId,
                         @"ProcId":self.str_procId,
                         @"FormData":[NSString transformToJson:self.dict_parametersDict],
                         @"ExpIds":ExpIds,
                         @"FeeNumber":[self getFeeNumber:self.dict_parametersDict],
                         @"ContractNumber":[self getContractNumber:self.dict_parametersDict],
                         @"AdvanceNumber":[self getAdvanceNumber:self.dict_parametersDict],
                         @"CommonField":CommonField,
                         @"Comment":Comment
                         };
    return dict;
}

-(NSString *)getFeeNumber:(NSDictionary *)parm{
    NSString *FeeNumber=@"0";
    if ([parm[@"mainDataList"][0][@"fieldNames"]containsObject:@"FeeAppNumber"]) {
        NSUInteger indexFee= [parm[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"FeeAppNumber"];
        FeeNumber=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexFee]]]?[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexFee]]:@"0";
    }
    return FeeNumber;
}

-(NSString *)getContractNumber:(NSDictionary *)parm{
    NSString *ContractNumber=@"0";
    if ([parm[@"mainDataList"][0][@"fieldNames"]containsObject:@"ContractAppNumber"]) {
        NSUInteger indexContract=[parm[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"ContractAppNumber"];
        ContractNumber=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexContract]]]?[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexContract]]:@"0";
    }
    return ContractNumber;
}

-(NSString *)getAdvanceNumber:(NSDictionary *)parm{
    NSString *AdvanceNumber=@"0";
    if ([parm[@"mainDataList"][0][@"fieldNames"]containsObject:@"AdvanceNumber"]) {
        NSUInteger indexAdvance= [parm[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"AdvanceNumber"];
        AdvanceNumber=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexAdvance]]]?[NSString stringWithFormat:@"%@",[parm[@"mainDataList"][0][@"fieldValues"] objectAtIndex:indexAdvance]]:@"0";
    }
    return AdvanceNumber;
}
-(NSString *)getSinglePayUrl{
    return [NSString stringWithFormat:@"%@",SinglePay];
}
-(NSDictionary *)SinglePayFormWithComment:(NSString *)Comment WithAdvanceNumber:(NSString *)AdvanceNumber WithExpIds:(NSString *)ExpIds WithMainForm:(NSMutableDictionary *)MainForm WithCommonField:(NSString *)CommonField{
    NSDictionary * parameters = @{@"ActionLinkName":@"同意",
                                  @"Comment":@"",
                                  @"TaskId":self.str_taskId,
                                  @"ProcId":self.str_procId,
                                  @"FormData":[NSString transformToJson:self.dict_parametersDict],
                                  @"ExpIds":@"",
                                  @"MainForm":MainForm?[NSString transformToJson:MainForm]:@"",
                                  @"AdvanceNumber":AdvanceNumber,
                                  @"FlowCode":self.str_flowCode,
                                  @"CommonField":CommonField
                                  };
    return parameters;
}



-(NSString *)getApproveJudgeUrl{
    return [NSString stringWithFormat:@"%@",BPMJUDGETBUDGET];
}
-(NSDictionary *)getApproveJudgeParameter{
    NSDictionary * parameters = @{@"MainForm":self.dict_JudgeAmount?[NSString transformToJson:self.dict_JudgeAmount]:@""};
    return parameters;
}





-(void)getTravel_Daily_OtherReimData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter WithType:(NSInteger)type{
    
    if (![result[@"isShowAddExpense"]isKindOfClass:[NSNull class]]) {
        self.bool_IsNotShowAddExpense = [[NSString stringWithFormat:@"%@",result[@"isShowAddExpense"]]isEqualToString:@"1"] ? YES:NO;
    }
    
    if (![result[@"isNeedAdvance"]isKindOfClass:[NSNull class]]) {
        self.bool_isNeedAdvance = [result[@"isNeedAdvance"] boolValue];
    }
    

    self.bool_isConsistentAmount = [result[@"isConsistentAmount"] boolValue];
    

    if ([result[@"formRule"]isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = result[@"formRule"];
        

        NSArray *ClaimAttRuleList=dict[@"claimAttRuleList"];
        if (![ClaimAttRuleList isKindOfClass:[NSNull class]]&&ClaimAttRuleList.count>0) {
            for (NSDictionary *dic in ClaimAttRuleList) {
                [self.dict_ClaimAttRule setObject:dic forKey:[NSString stringWithFormat:@"%@",dic[@"expenseCode"]]];
            }
        }

        NSArray *ClaimTypeList=dict[@"claimTypeList"];
        if (![ClaimTypeList isKindOfClass:[NSNull class]]) {
            [ChooseCategoryModel getClaimType:ClaimTypeList Array:self.arr_ClaimType];
        }
        
        if (type==1) {

            if ([[NSString stringWithFormat:@"%@",dict[@"isSubmit"]]isEqualToString:@"1"]) {
                self.bool_OvEstimatSubmit=YES;
            }
            

            if ([[NSString stringWithFormat:@"%@",dict[@"costDate"]] floatValue]==1) {
                self.bool_NeedCostDate=YES;
                self.str_travel_FromDate=[NSString stringWithFormat:@"%@",dict[@"fromDate"]];
                self.str_travel_ToDate=[NSString stringWithFormat:@"%@",dict[@"toDate"]];
            }
            

            if ([[NSString stringWithFormat:@"%@",result[@"isTravelEdit"]]isEqualToString:@"0"]) {
                self.bool_editRelateTravelForm = NO;
            }else{
                self.bool_editRelateTravelForm = YES;
            }
        }
    }
    

    NSArray *expsUser=[result objectForKey:@"expsUser"];
    if (![expsUser isKindOfClass:[NSNull class]]&&expsUser.count!=0) {
        for (NSDictionary *dic in expsUser) {
            AddDetailsModel *model = [[AddDetailsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //            model.isIntegrity = [[NSString stringWithFormat:@"%@",model.isIntegrity] isEqualToString:@"1"] ? @"1":@"0";
            //            model.isDataIntegrity = self.bool_isDataIntegrity;
            model.checked = [[NSString stringWithFormat:@"%@",dic[@"checked"]]isEqualToString:@"1"] ? @"1":@"0";
            [self.arr_sonItem addObject:model];

            if ([model.checked isEqualToString:@"1"]) {
                self.str_amountTotal = [GPUtils decimalNumberAddWithString:self.str_amountTotal with:[NSString reviseString:dic[@"localCyAmount"]]];
                self.str_InvTotalAmount = [GPUtils decimalNumberAddWithString:self.str_InvTotalAmount with:[NSString reviseString:dic[@"invPmtAmount"]]];
                if ([[NSString stringWithFormat:@"%@",model.payTypeId]isEqualToString:@"2"]) {
                    self.str_amountCompany = [GPUtils decimalNumberAddWithString:self.str_amountCompany with:[NSString reviseString:dic[@"localCyAmount"]]];
                }
                if ([[NSString stringWithFormat:@"%@",dic[@"hasInvoice"]]floatValue]==0) {
                    self.str_NoInvAmount=[GPUtils decimalNumberAddWithString:self.str_NoInvAmount with:[NSString stringWithFormat:@"%@",[dic objectForKey:@"localCyAmount"]]];
                }
            }
            self.str_amountPrivate = [GPUtils decimalNumberSubWithString:self.str_amountTotal with:self.str_amountCompany];
        }
    }
}
-(void)getFormBudgetInfoWithDict:(NSDictionary *)result{

    if ([result[@"projBud"] isKindOfClass:[NSDictionary class]]) {
        if ([result[@"projBud"][@"projBud"] isKindOfClass:[NSArray class]]) {
            if ([result[@"projBud"][@"projBud"] count] > 0) {
                [self.dict_budgetInfo setObject:result[@"projBud"][@"projBud"] forKey:@"proj"];
            }
        }
    }
    if ([result[@"costCBud"] isKindOfClass:[NSDictionary class]]) {
        if ([result[@"costCBud"][@"costCBud"] isKindOfClass:[NSArray class]]) {
            if ([result[@"costCBud"][@"costCBud"] count] > 0) {
                [self.dict_budgetInfo setObject:result[@"costCBud"][@"costCBud"] forKey:@"cost"];
            }
        }
    }
    
    if ([result[@"actItemBud"] isKindOfClass:[NSDictionary class]]) {
        if ([result[@"actItemBud"][@"actItemBud"] isKindOfClass:[NSArray class]]) {
            if ([result[@"actItemBud"][@"actItemBud"] count] > 0) {
                [self.dict_budgetInfo setObject:result[@"actItemBud"][@"actItemBud"] forKey:@"actItem"];
            }
        }
    }
}

-(void)getTravel_Daily_OtherHasReimData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter WithType:(NSInteger)type{
    

    self.bool_isShowCurrencySum = [[NSString stringWithFormat:@"%@",result[@"isShowCurrencySum"]] isEqualToString:@"1"] ? YES:NO;
    if (self.bool_isShowCurrencySum && [result[@"expUserCurrencySum"] isKindOfClass :[NSArray class]]) {
        for (NSDictionary *dict in result[@"expUserCurrencySum"]) {
            CurrencySumModel *model = [[CurrencySumModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.arr_CurrencySum addObject:model];
        }
    }
    
    if ([result[@"detailShowFields"]isKindOfClass:[NSArray class]]) {
        NSArray *arr=result[@"detailShowFields"];
        for (NSDictionary *dict in arr) {
            [self.arr_itemShow addObject:[NSString stringWithFormat:@"%@",dict[@"fieldName"]]];
            [self.arr_itemShowDes addObject:[NSString stringWithFormat:@"%@",dict[@"description"]]];
        }
    }

    if ([result[@"formRule"]isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = result[@"formRule"];

        if (![dict[@"costConfirm"]isKindOfClass:[NSNull class]]) {
            if ((self.int_comeStatus==3||self.int_comeStatus==4)&&[dict[@"costConfirm"]floatValue]==1) {
                self.bool_needSure=YES;
            }else{
                self.bool_needSure=NO;
            }
        }
    }

    [self getHasTaxExpenseList:result];
    

    NSDictionary *formData=result[@"formData"];
    if (![formData isKindOfClass:[NSNull class]]) {
        NSDictionary *detail=formData[@"detail"];
        if (![detail isKindOfClass:[NSNull class]]) {
            NSString *key1=parameter[@"expensedetail"];
            NSArray *array=detail[key1];
            for (NSDictionary *dict in array) {
                HasSubmitDetailModel *model=[[HasSubmitDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [self.arr_ApprovBefoEditExpense addObject:[model copy]];
                
                if (self.bool_needSure&&[NSString isEqualToNull:model.overStd]&&[model.overStd floatValue]>0) {
                    model.hasSured=@"0";
                }
                
                [self getHasSubmitDetailModelSubContent:model];
                
                [self.arr_sonItem addObject:model];
            }
            
            if (type!=3) {
                NSString *key2=parameter[@"expenseSummary"];
                NSArray *sumarray=detail[key2];
                [HasSubmitDetailModel getCostCateSumArrayWithArray:sumarray resultArray:self.arr_travelSum];
            }
            
            NSString *key3 = parameter[@"expenseSettle"];
            if ([detail[key3]isKindOfClass:[NSArray class]]&&self.arr_SecDetailsDataArray) {
                for (NSDictionary *dict in detail[key3]) {
                    pmtMethodDetail *model=[[pmtMethodDetail alloc]init];
                    if (![dict[@"pmtMethod"] isKindOfClass:[NSNull class]]) {
                        model.PmtMethod=[NSString stringWithFormat:@"%@",dict[@"pmtMethod"]];
                    }
                    if (![dict[@"currency"] isKindOfClass:[NSNull class]]) {
                        model.Currency=[NSString stringWithFormat:@"%@",dict[@"currency"]];
                    }
                    if (![dict[@"exchangeRate"] isKindOfClass:[NSNull class]]) {
                        model.ExchangeRate=[NSString stringWithFormat:@"%@",dict[@"exchangeRate"]];
                    }
                    if (![dict[@"amount"] isKindOfClass:[NSNull class]]) {
                        model.Amount=[NSString reviseString:dict[@"amount"]];
                    }
                    [self.arr_SecDetailsDataArray addObject:model];
                }
            }
        }
        
    }
    
}

-(void)getExpenseShareDataWithData:(NSDictionary *)result WithParameter:(NSDictionary *)parameter{
    

    self.bool_isShareRequire = [[NSString stringWithFormat:@"%@",result[@"isPaymentShareRequire"]]isEqualToString:@"1"] ? YES:NO;

    self.bool_isSameShareAMT = [[NSString stringWithFormat:@"%@",result[@"isSameShareAMT"]]isEqualToString:@"1"] ? NO:YES;

    self.bool_ShareShow = [[NSString stringWithFormat:@"%@",[result objectForKey:@"expenseShare"]] isEqualToString:@"1"] ? YES:NO;
    if (self.bool_ShareShow) {

        self.int_ShareShowModel = [[NSString stringWithFormat:@"%@",result[@"showShareModel"]] isEqualToString:@"1"] ? 1:0;

        if ([result[@"expenseShareFields"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dcit in result[@"expenseShareFields"]) {
                MyProcurementModel *model = [[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dcit];
                [self.arr_ShareForm addObject:model];
            }
        }

        if (self.int_ShareShowModel == 1 && self.int_formStatus != 1) {
            if ([result[@"expShares"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result[@"expShares"]) {
                    ReimShareDeptSumModel *model = [[ReimShareDeptSumModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.arr_ShareDeptSumData addObject:model];
                }
            }
        }else{
            if ([result[@"formData"] isKindOfClass:[NSDictionary class]]) {
                if ([result[@"formData"][@"expenseShareData"] isKindOfClass:[NSDictionary class]]) {
                    NSString *key = parameter[@"ExpenseShare"];
                    if ([result[@"formData"][@"expenseShareData"][key] isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dict in result[@"formData"][@"expenseShareData"][key]) {
                            ReimShareModel *model = [[ReimShareModel alloc]init];
                            [model setValuesForKeysWithDictionary:dict];
                            [self.arr_ShareData addObject:model];
                        }
                    }
                }
            }
        }
    }
}
-(void)dealWithCateDateWithType:(NSInteger)type{
    self.dict_CategoryParameter = [CostCateNewModel getCostCateByDict:self.dict_resultDict array:self.arr_CategoryArr withType:type];
}

-(void)getAddFilesShowWithDict:(NSDictionary *)result{
    if (![result[@"detailFilesFld"] isKindOfClass:[NSNull class]]) {
        NSArray *detailFilesFld=result[@"detailFilesFld"];
        if (detailFilesFld.count>0) {
            NSDictionary *detailFilesFld_dict=detailFilesFld[0];
            self.bool_AddFilesShow=[[NSString stringWithFormat:@"%@",detailFilesFld_dict[@"isShow"]]isEqualToString:@"1"]?YES:NO;
        }
    }
}

-(void)travel_daily_otherReimAddCost:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        AddDetailsModel *model=[[AddDetailsModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        model.isIntegrity = @"0";
        model.checked = @"1";
        
        [self.arr_sonItem insertObject:model atIndex:0];
    }else if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]){
        for (NSDictionary *dict in obj) {
            AddDetailsModel *model=[[AddDetailsModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.isIntegrity = @"0";
            model.checked = @"1";
            [self.arr_sonItem insertObject:model atIndex:0];
        }
    }
    
}
-(void)travel_daily_otherReimEditCost:(NSDictionary *)dict{
    AddDetailsModel *model=[[AddDetailsModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    model.isIntegrity = @"0";
    model.amount=[model.amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    model.localCyAmount=[model.localCyAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    [self.arr_sonItem replaceObjectAtIndex:self.index_item withObject:model];
}

-(void)getTravel_Daily_OtherReimTotalAmount{
    self.str_amountTotal = @"0";
    self.str_InvTotalAmount = @"0";
    self.str_amountPrivate = @"0";
    self.str_amountCompany = @"0";
    self.str_NoInvAmount = @"0";
    for (AddDetailsModel *model in self.arr_sonItem) {
        if ([model.checked isEqualToString:@"1"]) {
            self.str_amountTotal = [GPUtils decimalNumberAddWithString:self.str_amountTotal with:[NSString reviseString:model.localCyAmount]];
            self.str_InvTotalAmount = [GPUtils decimalNumberAddWithString:self.str_InvTotalAmount with:[NSString reviseString:model.invPmtAmount]];
            if ([[NSString stringWithFormat:@"%@",model.payTypeId]isEqualToString:@"2"]) {
                self.str_amountCompany = [GPUtils decimalNumberAddWithString:self.str_amountCompany with:[NSString reviseString:model.localCyAmount]];
            }
            if ([[NSString stringWithFormat:@"%@",model.hasInvoice]floatValue]==0) {
                self.str_NoInvAmount=[GPUtils decimalNumberAddWithString:self.str_NoInvAmount with:[NSString stringWithFormat:@"%@",model.localCyAmount]];
            }
        }
    }
    self.str_amountPrivate = [GPUtils decimalNumberSubWithString:self.str_amountTotal with:self.str_amountCompany];
}

-(NSString *)getTravel_Daily_OtherReimImportExpJson{
    NSString *ExpUsers = @"";
    if (self.arr_sonItem.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (AddDetailsModel *model in self.arr_sonItem) {
            [array addObject:@{@"Id":[NSString stringWithFormat:@"%@",model.Id]}];
        }
        ExpUsers = [NSString transformToJson:array];
    }
    return ExpUsers;
}
-(void)getSubmitSaveIdString{

    self.str_submitId = nil;
    NSMutableArray *idArr=[NSMutableArray array];
    if ([self.str_flowCode isEqualToString:@"F0009"]) {
        for (PaymentExpDetail *model in self.arr_DetailsDataArray) {
            if ([NSString isEqualToNullAndZero:model.ExpId]) {
                [idArr addObject:[NSString stringWithFormat:@"%@",model.ExpId]];
            }
        }
    }else{
        for (AddDetailsModel *model in self.arr_sonItem) {
            if ([model.checked isEqualToString:@"1"]) {
                [idArr addObject:[NSString stringWithFormat:@"%@",model.Id]];
            }
        }
    }
    self.str_submitId = [idArr componentsJoinedByString:@","] ? [idArr componentsJoinedByString:@","]:@"";
}


-(NSInteger)getVerifyBudegt{
    NSInteger type = 0;
    NSDictionary *result = [self.dict_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {

        type = [[NSString stringWithFormat:@"%@",[result objectForKey:@"type"]]floatValue];
        self.arr_table = [NSMutableArray array];
        if (self.int_formStatus == 1) {
            self.arr_BudgetInfo = [NSMutableArray array];
            self.arr_projbudinfo = [NSMutableArray array];
        }
        if (type == 0) {
            [self AddclaimLimitWith:result];
            [self AddprojLimit:result];
            [self AddcostCLimit:result];
            if (self.int_formStatus==1) {
                [self getVerifyBudegt_addBudgetInfo];
            }
        }else if (type==1){
            [self AddclaimLimitWith:result];
        }else if (type==2){
            [self AddcostCLimit:result];
        }else if (type==3){
            [self AddprojLimit:result];
        }
    }
    return type;
}

-(void)AddclaimLimitWith:(NSDictionary *)result{
    if (![result[@"claimLimit"] isKindOfClass:[NSNull class]]) {
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"claimLimit"][@"amount"]]]) {
            [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@",@"超出本月报销额度",[NSString stringWithFormat:@"%@",result[@"claimLimit"][@"amount"]],@"元"]];
            if (self.int_formStatus==1) {
                self.str_overlimit=[NSString stringWithFormat:@"%@",result[@"claimLimit"][@"amount"]];
            }
        }
    }
}

-(void)AddprojLimit:(NSDictionary *)result{
    if (![result[@"projLimit"] isKindOfClass:[NSNull class]]) {
        if (![result[@"projLimit"][@"details"] isKindOfClass:[NSNull class]]) {
            NSArray *projArr=result[@"projLimit"][@"details"];
            if (projArr.count>0) {
                if (self.int_formStatus==1) {
                    NSUInteger index=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"IsOverBud"];
                    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:@"1"];
                }else{
                    [self.dict_JudgeAmount setValue:@"1" forKey:@"IsOverBud"];
                }
                for (NSDictionary *dict in projArr) {
                    NSMutableArray *arr=[NSMutableArray array];
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"projName"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@%@",dict[@"projName"],@"项目"]];
                    }
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
                    }
                    [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],Custing(@"超出预算", nil),[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                    if (self.int_formStatus==1) {
                        [self.arr_projbudinfo addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],Custing(@"超出预算", nil),[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                        self.str_projbuddata = [GPUtils decimalNumberAddWithString:self.str_projbuddata with:[NSString stringWithFormat:@"%@",dict[@"amount"]]];
                    }
                }
            }
        }
    }
}

-(void)AddcostCLimit:(NSDictionary *)result{
    if (![result[@"costCLimit"] isKindOfClass:[NSNull class]]) {
        if (![result[@"costCLimit"][@"details"] isKindOfClass:[NSNull class]]) {
            NSArray *costArr=result[@"costCLimit"][@"details"];
            if (costArr.count>0) {
                
                if (self.int_formStatus==1) {
                    NSUInteger index=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"IsOverBud"];
                    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:@"1"];
                }else{
                    [self.dict_JudgeAmount setValue:@"1" forKey:@"IsOverBud"];
                }
                
                for (NSDictionary *dict in costArr) {
                    NSMutableArray *arr=[NSMutableArray array];
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"costCenter"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"costCenter"]]];
                    }
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
                    }
                    [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],@"超出预算",[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                    if (self.int_formStatus==1) {
                        [self.arr_BudgetInfo addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],@"超出预算",[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                    }
                }
            }
        }
    }
}


-(void)getVerifyBudegt_addBudgetInfo{
    NSUInteger index=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"BudgetInfo"];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:[self.arr_BudgetInfo componentsJoinedByString:@";"]];
    
    NSUInteger index1=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Projbudinfo"];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index1 withObject:[self.arr_projbudinfo componentsJoinedByString:@";"]];
    
    NSUInteger index2=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Projbuddata"];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index2 withObject:self.str_projbuddata];
    
    NSUInteger index3=[self.dict_parametersDict[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Overlimit"];
    [self.dict_parametersDict[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index3 withObject:self.str_overlimit];
    
}

-(NSString *)testApporveEditModel{
    return nil;
}
-(NSString *)ApproveAgreeWithPayJudge{
    NSString *returnTips=nil;
    if (self.bool_needSure) {
        for (HasSubmitDetailModel *model in self.arr_sonItem) {
            if ([model.hasSured isEqualToString:@"0"]&&self.bool_needSure&&[NSString isEqualToNull:model.overStd]&&[model.overStd floatValue]>0) {
                returnTips=Custing(@"请确认超标费用明细", nil);
                goto when_failed;
            }
        }
    }
    if (self.bool_IsAllowExpand == NO && [[GPUtils decimalNumberSubWithString:self.str_lastAmount with:self.str_amountTotal]floatValue] < 0) {
        returnTips=Custing(@"金额不能改大", nil);
        goto when_failed;
    }
    if (self.bool_ShareShow && self.bool_isSameShareAMT && self.arr_ShareData.count > 0) {
        NSString *Amout=@"0";
        for (ReimShareModel *model in self.arr_ShareData) {
            Amout=[GPUtils decimalNumberAddWithString:Amout with:[NSString stringWithFormat:@"%@",model.Amount]];
        }
        if ([[GPUtils decimalNumberSubWithString:self.str_amountTotal with:Amout] floatValue]!=0) {
            returnTips=Custing(@"费用分摊金额合计必须与报销金额相同", nil);
            goto when_failed;
        }
    }
    
    [self dealWithAgreeAmount];
when_failed:
    return returnTips;
    
}
-(void)dealWithAgreeAmount{
    NSMutableArray *DetailForms = [NSMutableArray array];
    NSString *IsOverStd=@"0";
    NSString *IsOverStd2=@"0";
    for (HasSubmitDetailModel *model in self.arr_sonItem) {
        if ([NSString isEqualToNull:model.overStd]&&[model.overStd floatValue]>0) {
            IsOverStd=@"1";
        }
        if ([NSString isEqualToNull:model.overStd2]&&[model.overStd2 floatValue]>0) {
            IsOverStd2=@"1";
        }
        NSMutableDictionary *dict = [HasSubmitDetailModel initDicByModel:model];
        AppoverEditModel *Appovermodel = [[AppoverEditModel alloc]init];
        [Appovermodel setValuesForKeysWithDictionary:dict];
        NSMutableDictionary *Aimdict = [AppoverEditModel initDicByModel:Appovermodel];
        [DetailForms addObject:Aimdict];
    }
    NSMutableArray *reimShare=[NSMutableArray array];
    for (ReimShareModel *model in self.arr_ShareData) {
        NSMutableDictionary *modelDic=[ReimShareModel initDicByModel:model];
        [reimShare addObject:modelDic];
    }
    self.dict_JudgeAmount = [NSMutableDictionary dictionaryWithDictionary:@{@"IsOverBud":@"0",
                                                                            @"IsOverStd":IsOverStd,
                                                                            @"IsOverStd2":IsOverStd2,
                                                                            @"Tax":@"0",
                                                                            @"ExclTax":@"0",
                                                                            @"ExchangeRate":@"0",
                                                                            @"ExpenseCatCode":self.str_ExpenseCatCode,
                                                                            @"ExpenseCat":self.str_ExpenseCat,
                                                                            @"ExpenseCode":self.str_ExpenseCode,
                                                                            @"ExpenseType":self.str_ExpenseType,
                                                                            @"CostCenterId":self.personalData.CostCenterId,
                                                                            @"CostCenter":self.personalData.CostCenter,
                                                                            @"ProjId":self.personalData.ProjId,
                                                                            @"ProjName":self.personalData.ProjName,
                                                                            @"ProjectActivityLv1":[NSString isEqualToNull:self.personalData.ProjectActivityLv1]?self.personalData.ProjectActivityLv1:(id)[NSNull null],
                                                                            @"ProjectActivityLv1Name":self.personalData.ProjectActivityLv1Name,
                                                                            @"ProjectActivityLv2":[NSString isEqualToNull:self.personalData.ProjectActivityLv2]?self.personalData.ProjectActivityLv2:(id)[NSNull null],
                                                                            @"ProjectActivityLv2Name":self.personalData.ProjectActivityLv2Name,
                                                                            @"TaskId":self.str_taskId,
                                                                            @"FlowCode":self.str_flowCode,
                                                                            @"TotalAmount":[NSString isEqualToNull:self.str_amountTotal] ? self.str_amountTotal:@"0",
                                                                            @"CapitalizedAmount":[NSString getChineseMoneyByString:self.str_amountTotal],
                                                                            @"Amount":[GPUtils decimalNumberSubWithString:self.str_lastAmount with:self.str_amountTotal],
                                                                            @"DetailForms":DetailForms,
                                                                            @"ExpenseShare":reimShare,
                                                                            @"AmountPayable":[NSString isEqualToNull:self.str_amountActual] ? self.str_amountActual:@"0",
                                                                            @"NoInvAmount":[NSString isEqualToNull:self.str_NoInvAmount] ? self.str_NoInvAmount:@"0",
                                                                            @"InvTotalAmount":[NSString isEqualToNull:self.str_InvTotalAmount] ? self.str_InvTotalAmount:@"0",
                                                                            @"InvActualAmount":[NSString isEqualToNull:self.str_InvActualAmount] ? self.str_InvActualAmount:@"0"
                                                                            }];
    if ([self.str_flowCode isEqualToString:@"F0002"]) {
        [self.dict_JudgeAmount setValue:self.str_amountPrivate forKey:@"SumAmount"];
        [self.dict_JudgeAmount setValue:self.str_amountCompany forKey:@"CorpPayAmount"];
    }
}

-(NSMutableArray *)arr_ReceiptOfInv{
    if (_arr_ReceiptOfInv==nil) {
        _arr_ReceiptOfInv=[NSMutableArray array];
        NSArray *type=@[Custing(@"收到", nil),Custing(@"未收到", nil)];
        NSArray *code=@[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_ReceiptOfInv addObject:model];
        }
    }
    return _arr_ReceiptOfInv;
}

-(NSMutableArray *)arr_InvoiceTypes{
    if (_arr_InvoiceTypes==nil) {
        _arr_InvoiceTypes=[NSMutableArray array];
        NSArray *type=@[Custing(@"增值税普通发票", nil),Custing(@"增值税专用发票", nil)];
        NSArray *code=@[@"2",@"1"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_InvoiceTypes addObject:model];
        }
    }
    return _arr_InvoiceTypes;
}

-(NSMutableArray *)arr_SexType{
    if (_arr_SexType == nil) {
        _arr_SexType = [NSMutableArray array];
        NSArray *type = @[Custing(@"男", nil),Custing(@"女", nil)];
        NSArray *code = @[@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_SexType addObject:model];
        }
    }
    return _arr_SexType;
}
-(NSMutableArray *)arr_IsOrNot{
    if (_arr_IsOrNot == nil) {
        _arr_IsOrNot = [NSMutableArray array];
        NSArray *type = @[Custing(@"是", nil),Custing(@"否", nil)];
        NSArray *code = @[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_IsOrNot addObject:model];
        }
    }
    return _arr_IsOrNot;
}

-(NSMutableArray *)arr_TimeNoon{
    if (_arr_TimeNoon == nil) {
        _arr_TimeNoon = [NSMutableArray array];
        NSArray *type = @[Custing(@"上午", nil),Custing(@"下午", nil)];
        NSArray *code = @[@"1",@"2"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_TimeNoon addObject:model];
        }
    }
    return _arr_TimeNoon;
}

-(NSArray *)getMoreBtnList{
    NSMutableArray *array=[NSMutableArray arrayWithArray:@[@1,@2,@3]];
    if (self.bool_isPrint==NO) {
        [array removeObject:@3];
    }
    if (self.int_comeStatus!=3) {
        [array removeObject:@2];
    }
    return array;
}
-(void)getHasSubmitDetailModelSubContent:(HasSubmitDetailModel *)model{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger i=0;
    for (NSString *str in self.arr_itemShow) {
        if ([str isEqualToString:@"InvoiceType"]) {
            if ([self.arr_hasTaxExpense containsObject:model.expenseCode]) {
                [arr addObject:[NSString stringWithIdOnNO:model.invoiceTypeName]];
            }
        }else if ([str isEqualToString:@"TaxRate"]) {
            if ([self.arr_hasTaxExpense containsObject:model.expenseCode]&&![[NSString stringWithFormat:@"%@",model.invoiceType]isEqualToString:@"2"]) {
                [arr addObject:[NSString stringIsExist:model.taxRate]];
            }
        }else if ([str isEqualToString:@"Tax"]&&[NSString isEqualToNull:model.tax]) {
            if ([self.arr_hasTaxExpense containsObject:model.expenseCode]&&![[NSString stringWithFormat:@"%@",model.invoiceType]isEqualToString:@"2"]) {
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.tax],Custing(@"元", nil)]];
            }
        }else if ([str isEqualToString:@"ExclTax"]&&[NSString isEqualToNull:model.exclTax]) {
            if ([self.arr_hasTaxExpense containsObject:model.expenseCode]&&![[NSString stringWithFormat:@"%@",model.invoiceType]isEqualToString:@"2"]) {
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.exclTax],Custing(@"元", nil)]];
            }
        }else if ([str isEqualToString:@"PayTypeId"]) {
            [arr addObject:[NSString stringIsExist:model.payType]];
        }else if ([str isEqualToString:@"InvoiceNo"]) {
            [arr addObject:[NSString stringIsExist:model.invoiceNo]];
        }else if ([str isEqualToString:@"HasInvoice"]) {
            [arr addObject:[NSString stringIsExist:model.hasInvoiceName]];
        }else if ([str isEqualToString:@"NoInvReason"]) {
            [arr addObject:[NSString stringIsExist:model.noInvReason]];
        }else if ([str isEqualToString:@"ReplExpenseCode"]) {
            [arr addObject:[NSString stringIsExist:model.replExpenseType]];
        }else if ([str isEqualToString:@"CostCenterId"]) {
            [arr addObject:[NSString stringIsExist:model.costCenter]];
        }else if ([str isEqualToString:@"ProjId"]) {
            [arr addObject:[NSString stringIsExist:model.projName]];
        }else if ([str isEqualToString:@"ClientId"]) {
            [arr addObject:[NSString stringIsExist:model.clientName]];
        }else if ([str isEqualToString:@"SupplierId"]) {
            [arr addObject:[NSString stringIsExist:model.supplierName]];
        }else if ([str isEqualToString:@"ExpenseDesc"]) {
            [arr addObject:[NSString stringIsExist:model.expenseDesc]];
        }else if ([str isEqualToString:@"Remark"]) {
            [arr addObject:[NSString stringIsExist:model.remark]];
        }else if ([str isEqualToString:@"Reserved1"]) {
            [arr addObject:[NSString stringIsExist:model.reserved1]];
        }else if ([str isEqualToString:@"Reserved2"]) {
            [arr addObject:[NSString stringIsExist:model.reserved2]];
        }else if ([str isEqualToString:@"Reserved3"]) {
            [arr addObject:[NSString stringIsExist:model.reserved3]];
        }else if ([str isEqualToString:@"Reserved4"]) {
            [arr addObject:[NSString stringIsExist:model.reserved4]];
        }else if ([str isEqualToString:@"Reserved5"]) {
            [arr addObject:[NSString stringIsExist:model.reserved5]];
        }else if ([str isEqualToString:@"Reserved6"]) {
            [arr addObject:[NSString stringIsExist:model.reserved6]];
        }else if ([str isEqualToString:@"Reserved7"]) {
            [arr addObject:[NSString stringIsExist:model.reserved7]];
        }else if ([str isEqualToString:@"Reserved8"]) {
            [arr addObject:[NSString stringIsExist:model.reserved8]];
        }else if ([str isEqualToString:@"Reserved9"]) {
            [arr addObject:[NSString stringIsExist:model.reserved9]];
        }else if ([str isEqualToString:@"Reserved10"]) {
            [arr addObject:[NSString stringIsExist:model.reserved10]];
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Hotel"]) {
            if ([str isEqualToString:@"CityCode"]) {
                [arr addObject:[NSString stringIsExist:model.cityName]];
            }else if ([str isEqualToString:@"HotelName"]){
                [arr addObject:[NSString stringIsExist:model.hotelName]];
            }else if ([str isEqualToString:@"Rooms"]&&[NSString isEqualToNull:model.rooms]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.rooms],Custing(@"间", nil)]];
            }else if ([str isEqualToString:@"CheckInDate"]){
                if ([self.arr_itemShow containsObject:@"CheckOutDate"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.checkInDate,model.checkOutDate] WithCompare:@"~"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.checkInDate]];
                }
            }else if ([str isEqualToString:@"CheckOutDate"]&&![self.arr_itemShow containsObject:@"CheckInDate"]){
                [arr addObject:[NSString stringIsExist:model.checkOutDate]];
            }else if ([str isEqualToString:@"TotalDays"]&&[NSString isEqualToNull:model.totalDays]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.totalDays],Custing(@"天", nil)]];
            }else if ([str isEqualToString:@"HotelPrice"]&&[NSString isEqualToNull:model.hotelPrice]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.hotelPrice],Custing(@"元/间", nil)]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Meals"]){
            if ([str isEqualToString:@"FellowOfficersId"]) {
                [arr addObject:[NSString stringIsExist:model.fellowOfficers]];
            }else if ([str isEqualToString:@"TotalPeople"]&&[NSString isEqualToNull:model.totalPeople]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.totalPeople],Custing(@"人", nil)]];
            }else if ([str isEqualToString:@"CateringCo"]){
                [arr addObject:[NSString stringIsExist:model.cateringCo]];
            }else if ([str isEqualToString:@"Breakfast"]&&[NSString isEqualToNull:model.breakfast]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.breakfast],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"Lunch"]&&[NSString isEqualToNull:model.lunch]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.lunch],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"Supper"]&&[NSString isEqualToNull:model.supper]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.supper],Custing(@"元", nil)]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Hospitality"]){
            if ([str isEqualToString:@"ReceptionObject"]) {
                [arr addObject:[NSString stringIsExist:model.receptionObject]];
            }else if ([str isEqualToString:@"ReceptionReason"]){
                [arr addObject:[NSString stringIsExist:model.receptionReason]];
            }else if ([str isEqualToString:@"ReceptionLocation"]){
                [arr addObject:[NSString stringIsExist:model.receptionLocation]];
            }else if ([str isEqualToString:@"Visitor"]){
                [arr addObject:[NSString stringIsExist:model.visitor]];
            }else if ([str isEqualToString:@"VisitorDate"]){
                if ([self.arr_itemShow containsObject:@"LeaveDate"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.visitorDate,model.leaveDate] WithCompare:@"~"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.visitorDate]];
                }
            }else if ([str isEqualToString:@"LeaveDate"]&&![self.arr_itemShow containsObject:@"VisitorDate"]){
                [arr addObject:[NSString stringIsExist:model.leaveDate]];
            }else if ([str isEqualToString:@"ReceptionFellowOfficersId"]){
                [arr addObject:[NSString stringIsExist:model.receptionFellowOfficers]];
            }else if ([str isEqualToString:@"ReceptionTotalPeople"]&&[NSString isEqualToNull:model.receptionTotalPeople]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.receptionTotalPeople],Custing(@"人", nil)]];
            }else if ([str isEqualToString:@"ReceptionCateringCo"]){
                [arr addObject:[NSString stringIsExist:model.receptionCateringCo]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Flight"]){
            if ([str isEqualToString:@"FDCityName"]){
                if ([self.arr_itemShow containsObject:@"FACityName"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.fdCityName,model.faCityName] WithCompare:@"--"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.fdCityName]];
                }
            }else if ([str isEqualToString:@"FACityName"]&&![self.arr_itemShow containsObject:@"FDCityName"]){
                [arr addObject:[NSString stringIsExist:model.faCityName]];
            }else if ([str isEqualToString:@"ClassName"]) {
                if ([[NSString stringWithFormat:@"%@",model.hasInvoice]isEqualToString:@"1"]) {
                    [arr addObject:Custing(@"经济舱", nil)];
                }else if ([[NSString stringWithFormat:@"%@",model.invoiceType]isEqualToString:@"2"]){
                    [arr addObject:Custing(@"商务舱", nil)];
                }else if ([[NSString stringWithFormat:@"%@",model.invoiceType]isEqualToString:@"3"]){
                    [arr addObject:Custing(@"头等舱", nil)];
                }
            }else if ([str isEqualToString:@"Discount"]){
                [arr addObject:[NSString stringIsExist:model.discount]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Train"]){
            if ([str isEqualToString:@"TDCityName"]){
                if ([self.arr_itemShow containsObject:@"TACityName"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.tdCityName,model.taCityName] WithCompare:@"--"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.tdCityName]];
                }
            }else if ([str isEqualToString:@"TACityName"]&&![self.arr_itemShow containsObject:@"TDCityName"]){
                [arr addObject:[NSString stringIsExist:model.taCityName]];
            }else if ([str isEqualToString:@"SeatName"]){
                [arr addObject:[NSString stringIsExist:model.seatName]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"SelfDrive"]){
            if ([str isEqualToString:@"SDCityName"]){
                if ([self.arr_itemShow containsObject:@"SACityName"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.sdCityName,model.saCityName] WithCompare:@"--"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.sdCityName]];
                }
            }else if ([str isEqualToString:@"SACityName"]&&![self.arr_itemShow containsObject:@"SDCityName"]){
                [arr addObject:[NSString stringIsExist:model.saCityName]];
            }else if ([str isEqualToString:@"Mileage"]&&[NSString isEqualToNull:model.mileage]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.mileage],Custing(@"公里", nil)]];
            }else if ([str isEqualToString:@"CarStd"]&&[NSString isEqualToNull:model.carStd]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.carStd],Custing(@"元/公里", nil)]];
            }else if ([str isEqualToString:@"FuelBills"]&&[NSString isEqualToNull:model.fuelBills]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.fuelBills],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"Pontage"]&&[NSString isEqualToNull:model.pontage]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.pontage],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"ParkingFee"]&&[NSString isEqualToNull:model.parkingFee]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.parkingFee],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"StartMeter"]){
                [arr addObject:[NSString stringIsExist:model.startMeter]];
            }else if ([str isEqualToString:@"EndMeter"]){
                [arr addObject:[NSString stringIsExist:model.endMeter]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"CorpCar"]){
            if ([str isEqualToString:@"CorpCarDCityName"]){
                if ([self.arr_itemShow containsObject:@"CorpCarACityName"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.corpCarDCityName,model.corpCarACityName] WithCompare:@"--"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.corpCarDCityName]];
                }
            }else if ([str isEqualToString:@"CorpCarACityName"]&&![self.arr_itemShow containsObject:@"CorpCarDCityName"]){
                [arr addObject:[NSString stringIsExist:model.corpCarACityName]];
            }else if ([str isEqualToString:@"CorpCarMileage"]&&[NSString isEqualToNull:model.corpCarMileage]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.corpCarMileage],Custing(@"公里", nil)]];
            }else if ([str isEqualToString:@"CorpCarFuelBills"]&&[NSString isEqualToNull:model.corpCarFuelBills]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.corpCarFuelBills],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"CorpCarPontage"]&&[NSString isEqualToNull:model.corpCarPontage]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.corpCarPontage],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"CorpCarParkingFee"]&&[NSString isEqualToNull:model.corpCarParkingFee]){
                [arr addObject:[NSString stringWithFormat:@"%@%@%@",self.arr_itemShowDes[i],[NSString stringWithFormat:@"%@",model.corpCarParkingFee],Custing(@"元", nil)]];
            }else if ([str isEqualToString:@"CorpCarNo"]){
                [arr addObject:[NSString stringIsExist:model.corpCarNo]];
            }else if ([str isEqualToString:@"CorpCarFromDate"]){
                [arr addObject:[GPUtils getSelectResultWithArray:@[model.corpCarFromDate,model.corpCarToDate] WithCompare:@"~"]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Trans"]){
            if ([str isEqualToString:@"TransDCityName"]){
                if ([self.arr_itemShow containsObject:@"TransACityName"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.transDCityName,model.transACityName] WithCompare:@"--"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.transDCityName]];
                }
            }else if ([str isEqualToString:@"TransACityName"]&&![self.arr_itemShow containsObject:@"TransDCityName"]){
                [arr addObject:[NSString stringIsExist:model.transACityName]];
            }else if ([str isEqualToString:@"TransFromDate"]){
                if ([self.arr_itemShow containsObject:@"TransToDate"]) {
                    [arr addObject:[GPUtils getSelectResultWithArray:@[model.transFromDate,model.transToDate] WithCompare:@"~"]];
                }else{
                    [arr addObject:[NSString stringIsExist:model.transFromDate]];
                }
            }else if ([str isEqualToString:@"TransToDate"]&&![self.arr_itemShow containsObject:@"TransFromDate"]){
                [arr addObject:[NSString stringIsExist:model.transToDate]];
            }else if ([str isEqualToString:@"TransTypeId"]){
                [arr addObject:[NSString stringIsExist:model.transType]];
            }else if ([str isEqualToString:@"TransTotalDays"]&&[NSString isEqualToNull:model.transTotalDays]){
                [arr addObject:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",model.transTotalDays],Custing(@"天", nil)]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Allowance"]){
            if ([str isEqualToString:@"AllowanceFromDate"]){
                [arr addObject:[GPUtils getSelectResultWithArray:@[model.allowanceFromDate,model.allowanceToDate] WithCompare:@"~"]];
            }
        }else if ([[NSString stringWithFormat:@"%@",model.tag]isEqualToString:@"Mobile"]){
            if ([str isEqualToString:@"CrspFromDate"]){
                [arr addObject:[GPUtils getSelectResultWithArray:@[model.crspFromDate,model.crspToDate] WithCompare:@"~"]];
            }
        }
        i++;
    }
    model.att_content=[GPUtils getSelectResultWithArray:arr WithCompare:@","];
}

-(NSDictionary *)getExpShareApprovalIdParam{
    NSMutableArray *array = [NSMutableArray array];
    if (self.bool_ShareShow && self.arr_ShareData.count > 0) {
        for (ReimShareModel *model in self.arr_ShareData) {
            [array addObject:[ReimShareModel initDicByModel:model]];
        }
    }
    NSDictionary *dict = @{@"FlowCode":self.str_flowCode,
                           @"ExpIds":[self.str_flowCode isEqualToString:@"F0009"] ? (id)[NSNull null]:self.str_submitId,
                           @"CostShare":array.count > 0 ? array:(id)[NSNull null]
                           };
    return @{@"JsonData":[NSString transformToJson:dict]
             };
}

-(NSDictionary *)getExpShareInfoParam{
    return @{@"FlowCode":self.str_flowCode,
             @"IdList":self.str_submitId
             };
}


-(NSDictionary *)getProjsByCostcenterParam{
    return @{@"Id":self.personalData.CostCenterId
             };
}
-(NSString *)getProjsByCostcenterCheck:(NSDictionary *)result{
    NSString *returnTips = nil;
    
    if ([result isKindOfClass:[NSArray class]] && [result count] > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            if ([NSString isEqualToNullAndZero:dict[@"id"]]) {
                [array addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
            }
        }
        NSInteger count = 1;
        if ([self.str_flowCode isEqualToString:@"F0002"] || [self.str_flowCode isEqualToString:@"F0003"] || [self.str_flowCode isEqualToString:@"F0010"]) {
            for (AddDetailsModel *model in self.arr_sonItem) {
                if ([NSString isEqualToNullAndZero:model.projId] && ![array containsObject:[NSString stringWithFormat:@"%@",model.projId]]) {
                    returnTips = [NSString stringWithFormat:@"%@%ld%@",Custing(@"您选择的第", nil),count,Custing(@"条费用明细的项目与选择的成本中心不匹配,请重新选择", nil)];
                    goto when_failed;
                }
                count += 1;
            }
        }else if ([self.str_flowCode isEqualToString:@"F0009"] && self.bool_DetailsShow){
            for (PaymentExpDetail *model in self.arr_DetailsDataArray) {
                if ([NSString isEqualToNullAndZero:model.ProjId] && ![array containsObject:[NSString stringWithFormat:@"%@",model.ProjId]]) {
                    returnTips = [NSString stringWithFormat:@"%@%ld%@",Custing(@"第", nil),count,Custing(@"条费用明细的项目与选择的成本中心不匹配,请重新选择", nil)];
                    goto when_failed;
                }
                count += 1;
            }
        }
    }
when_failed:
    return returnTips;
}


@end
