//
//  VoiceDataManger.m
//  galaxy
//
//  Created by hfk on 2017/12/6.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceDataManger.h"
#import "userData.h"

@interface VoiceDataManger ()

@property (nonatomic , copy) VoiceBase_DealData_Block block;

@property(nonatomic,strong)NSString *baseUrl;

@property(nonatomic,strong)NSMutableArray *totalFileArray;

@property(nonatomic,strong)NSMutableArray *imageTypeArray;

@property (nonatomic , copy) GetBaseShowDataBlock showDataBlock;



@end
@implementation VoiceDataManger

+ (instancetype)sharedManager {
    static VoiceDataManger *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)getUserCustomsDateWithDict:(NSDictionary *)result WithFormArray:(NSMutableArray *)resultArray{
    if (result==nil || [result isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([result[@"customsV2"] isKindOfClass:[NSArray class]] && [result[@"customsV2"] count] > 0) {
        for (NSDictionary *dic in result[@"customsV2"]) {
            MyProcurementModel *model = [[MyProcurementModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [resultArray addObject:model];
        }
    }
}

-(void)uploadImageDataWithImgSoure:(NSMutableArray *)totalImageArray WithUrl:(NSString *)url  WithBlock:(VoiceBase_DealData_Block)block{
    self.block=block;
    self.baseUrl=url;
    self.totalFileArray=totalImageArray;
    if (self.totalFileArray&&self.totalFileArray.count!=0) {
        NSMutableArray *loadImageArray=[NSMutableArray array];
        self.imageTypeArray=[NSMutableArray array];
        for (int i=0; i<self.totalFileArray.count; i++) {
            id asset = self.totalFileArray[i];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                [loadImageArray addObject:Source == 1 ? [asset originImage]:[[asset originImage]dataForXBUpload]];
                [self.imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                [loadImageArray addObject:Source == 1 ? [asset photoImage]:[[asset photoImage]dataForXBUpload]];
                [self.imageTypeArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        if (loadImageArray.count!=0) {
            NSString *url=[NSString stringWithFormat:@"%@",self.baseUrl];
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            pickerFormatter.timeZone = [NSTimeZone localTimeZone];
            [pickerFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *name= [pickerFormatter stringFromDate:pickerDate];
            name=[name stringByReplacingOccurrencesOfString:@" " withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@"-" withString:@""];
            name=[name stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSMutableArray *names=[[NSMutableArray alloc]init];
            for (int i=0; i<loadImageArray.count; i++) {
                [names addObject:[NSString stringWithFormat:@"%@%d",name,i]];
            }
            [[GPClient shareGPClient]RequestByPostOnImageWithPath:url Parameters:nil NSArray:loadImageArray name:names type:@"image/png" Delegate:self SerialNum:0 IfUserCache:NO];
        }else{
            if (self.block) {
                self.block([NSString transformToJsonWithOutEnter:self.totalFileArray],NO);
            }
        }
    }else{
        if (self.block) {
            self.block(@"", NO);
        }
    }
}

-(void)getBaseShowDataWithBlock:(GetBaseShowDataBlock)block{
    self.showDataBlock = block;
    userData *userdatas = [userData shareUserData];
    NSString *UserRoles = @"1";
    NSString *MenuHides = @"1";
    NSString *Apps = @"1";
    NSString *Process = @"1";
    UserRoles = [[NSString stringWithFormat:@"%@",userdatas.cacheItems[@"UserRoles"][@"update"]]isEqualToString:@"0"] ? @"0":@"1";
    MenuHides = [[NSString stringWithFormat:@"%@",userdatas.cacheItems[@"MenuHides"][@"update"]]isEqualToString:@"0"] ? @"0":@"1";
    Apps = [[NSString stringWithFormat:@"%@",userdatas.cacheItems[@"Apps"][@"update"]]isEqualToString:@"0"] ? @"0":@"1";
    Process = [[NSString stringWithFormat:@"%@",userdatas.cacheItems[@"Process"][@"update"]]isEqualToString:@"0"] ? @"0":@"1";
    if ([UserRoles isEqualToString:@"0"]&&[MenuHides isEqualToString:@"0"]&&[Apps isEqualToString:@"0"]&&[Process isEqualToString:@"0"]) {
        self.showDataBlock(YES);
    }else{
        NSDictionary *parameters = @{@"UserRole":UserRoles,
                                     @"MenuHides":MenuHides,
                                     @"Apps":Apps,
                                     @"Process":Process,
                                     @"UserId":userdatas.userId,
                                     @"CompanyId":userdatas.companyId
                                     };
        [[GPClient shareGPClient]REquestByPostWithPath:XB_SettingInfo Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
    }
}


- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            if (self.block) {
                self.block(error, YES);
            }
            if (self.showDataBlock) {
                self.showDataBlock(NO);
            }
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]]];
            for (int i=0; i<array.count; i++) {
                [self.totalFileArray replaceObjectAtIndex:[_imageTypeArray[i] integerValue] withObject:array[i]];
            }
            if (self.block) {
                self.block([NSString transformToJsonWithOutEnter:self.totalFileArray], NO);
            }
        }
            break;
        case 1:
        {
            if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = responceDic[@"result"];
                userData *userdatas = [userData shareUserData];
                if ([NSString isEqualToNull:result[@"menuHide"]]) {
                    userdatas.menuHide = [NSString stringWithIdOnNO:result[@"menuHide"]];
                }
                if ([result[@"userRoles"] isKindOfClass:[NSArray class]]) {
                    userdatas.userRole = [NSMutableArray array];
                    for (NSDictionary *dict in result[@"userRoles"]) {
                        [userdatas.userRole addObject:[NSString stringWithFormat:@"%@",dict[@"roleId"]]];
                    }
                }
                [VoiceDataManger getFlowAndApplicationInfoWithDict:result];
                [userdatas storeUserInfo];
                if (self.showDataBlock) {
                    self.showDataBlock(YES);
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    if (self.block) {
        self.block(Custing(@"网络请求失败", nil), YES);
    }
}
+(void)getFlowAndApplicationInfoWithDict:(NSDictionary *)result{
    userData *userdatas=[userData shareUserData];
    
    if ([result[@"process"] isKindOfClass:[NSArray class]]) {
        userdatas.arr_ReimMeumArray = [NSMutableArray array];
        userdatas.arr_WorkMeumArray = [NSMutableArray array];
        userdatas.arr_XBOpenFlowcode = [NSMutableArray array];
        userdatas.dict_XBAllFlowInfo = [NSMutableDictionary dictionary];
        userdatas.arr_XBFlowcode = [NSMutableArray array];
        
        NSArray *arr=result[@"process"];
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                
                NSString *flowKey = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",dict[@"flowGuid"]],[NSString stringWithFormat:@"%@",dict[@"expenseCode"]]] WithCompare:@"|"];
                NSString *flowCode = [NSString stringWithFormat:@"%@",dict[@"flowCode"]];
                
                [userdatas.arr_XBOpenFlowcode addObject:flowKey];
                [userdatas.dict_XBAllFlowInfo setObject:dict forKey:flowKey];
                
                if ([[NSString stringWithFormat:@"%@",dict[@"isPermission"]]isEqualToString:@"1"]) {
                    [userdatas.arr_XBFlowcode addObject:flowCode];
                    
                    if ([flowCode isEqualToString:@"F0001"]||[flowCode isEqualToString:@"F0004"]||[flowCode isEqualToString:@"F0005"]||[flowCode isEqualToString:@"F0007"]||[flowCode isEqualToString:@"F0008"]||[flowCode isEqualToString:@"F0012"]||[flowCode isEqualToString:@"F0013"]||[flowCode isEqualToString:@"F0014"]||[flowCode isEqualToString:@"F0015"]||[flowCode isEqualToString:@"F0016"]||[flowCode isEqualToString:@"F0017"]||[flowCode isEqualToString:@"F0018"]||[flowCode isEqualToString:@"F0019"]||[flowCode isEqualToString:@"F0020"]||[flowCode isEqualToString:@"F0021"]||[flowCode isEqualToString:@"F0022"]||[flowCode isEqualToString:@"F0023"]||[flowCode isEqualToString:@"F0024"]||[flowCode isEqualToString:@"F0025"]||[flowCode isEqualToString:@"F0026"]||[flowCode isEqualToString:@"F0027"]||[flowCode isEqualToString:@"F0028"]||[flowCode isEqualToString:@"F0029"]||[flowCode isEqualToString:@"F0030"]||[flowCode isEqualToString:@"F0031"]||[flowCode isEqualToString:@"F0032"]||[flowCode isEqualToString:@"F0033"]||[flowCode isEqualToString:@"F0034"]||[flowCode isEqualToString:@"F0035"]||[flowCode isEqualToString:@"F0036"]||[flowCode isEqualToString:@"F0037"]||[flowCode isEqualToString:@"F0038"]) {
                        [userdatas.arr_WorkMeumArray addObject:flowKey];
                    }else if([flowCode isEqualToString:@"F0002"]||[flowCode isEqualToString:@"F0003"]||[flowCode isEqualToString:@"F0006"]||[flowCode isEqualToString:@"F0009"]||[flowCode isEqualToString:@"F0010"]||[flowCode isEqualToString:@"F0011"]){
                        [userdatas.arr_ReimMeumArray addObject:flowKey];
                    }
                }
            }
        }
    }
    if ([result[@"apps"] isKindOfClass:[NSArray class]]) {
        userdatas.arr_XBCode = [NSMutableArray array];
        userdatas.arr_AppMeumArray = [NSMutableArray array];
        NSArray *arr=result[@"apps"];
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                [userdatas.arr_XBCode addObject:code];
                if([code isEqualToString:@"Attendance"]||[code isEqualToString:@"Schedule"]||[code isEqualToString:@"InvoiceMgr"]||[code isEqualToString:@"Announcement"]||[code isEqualToString:@"Pay"]||[code isEqualToString:@"CashAdvance"]){
                    [userdatas.arr_AppMeumArray addObject:dict];
                }
            }
        }
    }
}


+(NSMutableDictionary *)getFlowShowInfo:(NSString *)flowKey{
    NSString *flowCode = @"";
    NSArray *array = [flowKey componentsSeparatedByString:@"|"];
    if ([array containsObject:@"F0000"]) {
        flowCode = @"F0000";
    }else if (array.count >= 2){
        flowCode = array[1];
    }
    
    NSString *flowGuid = @"";
    NSString *title = @"";
    NSString *Description = @"";
    userData *userdatas = [userData shareUserData];
    NSDictionary *infoDict = userdatas.dict_XBAllFlowInfo[flowKey];
    if (infoDict) {
        flowCode = infoDict[@"flowCode"];
        flowGuid = infoDict[@"flowGuid"];
        userData *userdatas=[userData shareUserData];
        if ([userdatas.language isEqualToString:@"ch"]) {
            title=[infoDict[@"flowChName"] isKindOfClass:[NSNull class]]?@"":infoDict[@"flowChName"];
            Description=[NSString stringIsExist:infoDict[@"remarkCh"]];
        }else{
            title=[infoDict[@"flowEnName"] isKindOfClass:[NSNull class]]?@"":infoDict[@"flowEnName"];
            Description=[NSString stringIsExist:infoDict[@"remarkEn"]];
        }
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:@{@"Title":title,
                                                                                  @"Description":Description,
                                                                                  @"FlowCode":flowCode,
                                                                                  @"FlowGuid":flowKey,
                                                                                  @"IsNew":@"0",
                                                                                  @"EnterImage":@"",
                                                                                  @"FlowBaseIcon":@""
                                                                                  }];
    if ([flowCode isEqualToString:@"F0000"]){
        [result setObject:Custing(@"全部", nil) forKey:@"Title"];
        
    }else{
        
        [result setObject:[NSString stringWithFormat:@"flow_enter_%@",flowCode] forKey:@"EnterImage"];
        [result setObject:Custing(([NSString stringWithFormat:@"flow_list_%@",flowCode]), nil) forKey:@"FlowBaseIcon"];
        if ([flowCode isEqualToString:@"F0010"]){
            [result setObject:(infoDict&&[NSString isEqualToNull:infoDict[@"expenseCode"]]) ? title:Description forKey:@"Description"];
            
        }
    }
    return result;
}

+(NSString *)getFlowMoneyLabelInfo:(MyApplyModel *)model withType:(NSInteger)type{
    NSString *str=@"";
    
    userData *userdatas=[userData shareUserData];
    
    if ([model.flowCode isEqualToString:@"F0001"]||[model.flowCode isEqualToString:@"F0002"]||[model.flowCode isEqualToString:@"F0003"]||[model.flowCode isEqualToString:@"F0005"]||[model.flowCode isEqualToString:@"F0006"]||[model.flowCode isEqualToString:@"F0009"]||[model.flowCode isEqualToString:@"F0010"]||[model.flowCode isEqualToString:@"F0011"]||[model.flowCode isEqualToString:@"F0012"]||[model.flowCode isEqualToString:@"F0013"]||[model.flowCode isEqualToString:@"F0019"]||[model.flowCode isEqualToString:@"F0023"]||[model.flowCode isEqualToString:@"F0024"]||[model.flowCode isEqualToString:@"F0025"]||[model.flowCode isEqualToString:@"F0034"]||[model.flowCode isEqualToString:@"F0035"]||[model.flowCode isEqualToString:@"F0036"]||[model.flowCode isEqualToString:@"F0037"]||[model.flowCode isEqualToString:@"F0038"]) {
        if (type == 2) {
            str = [GPUtils transformNsNumber:model.amountPayable];
        }else{
            if ([userdatas.multiCyPayment isEqualToString:@"1"] && ([model.flowCode isEqualToString:@"F0002"]||[model.flowCode isEqualToString:@"F0003"]||[model.flowCode isEqualToString:@"F0009"])) {
                str = [GPUtils transformNsNumber:model.paymentAmount];
            }else{
                str = [GPUtils transformNsNumber:model.amount];
            }
        }
    }else if ([model.flowCode isEqualToString:@"F0004"]){
        str=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.totalDays]]?[NSString stringWithFormat:@"%@%@",[NSString reviseString:model.totalDays],Custing(@"天", nil)]:@"";
    }else if ([model.flowCode isEqualToString:@"F0017"]){
        str=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.reserved1]]?[NSString stringWithFormat:@"%@%@",[NSString reviseString:model.reserved1],Custing(@"小时", nil)]:@"";
    }
    return str;
}

+(NSDictionary *)getApplicationWithInfoDict:(NSDictionary *)infoDict{
    NSDictionary *dict;
    if (infoDict) {
        NSString *code=[NSString stringWithFormat:@"%@",infoDict[@"code"]];
        NSString *title;
        userData *userdatas=[userData shareUserData];
        if ([userdatas.language isEqualToString:@"ch"]) {
            title=[infoDict[@"nameCh"] isKindOfClass:[NSNull class]]?@"":infoDict[@"nameCh"];
        }else{
            title=[infoDict[@"nameEn"] isKindOfClass:[NSNull class]]?@"":infoDict[@"nameEn"];
        }
        if ([code isEqualToString:@"Attendance"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_CheckIn",
                   @"AgentEnterImage":@"Work_AgentCheckIn",
                   @"Code":@"Attendance",
                   @"IsNew":@"0"
                   };
        }else if ([code isEqualToString:@"Schedule"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_Calendar",
                   @"AgentEnterImage":@"Work_AgentCalendar",
                   @"Code":@"Schedule",
                   @"IsNew":@"0"
                   };
        }else if ([code isEqualToString:@"Pay"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_Payment",
                   @"AgentEnterImage":@"Work_AgentPayment",
                   @"Code":@"Pay",
                   @"IsNew":@"0"
                   };
        }else if ([code isEqualToString:@"CashAdvance"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_Collection",
                   @"AgentEnterImage":@"Work_AgentCollection",
                   @"Code":@"CashAdvance",
                   @"IsNew":@"0"
                   };
        }else if ([code isEqualToString:@"InvoiceMgr"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_InvoicceManager",
                   @"AgentEnterImage":@"Work_AgentInvoicceManager",
                   @"Code":@"InvoiceMgr",
                   @"IsNew":@"0"
                   };
        }else if ([code isEqualToString:@"Announcement"]){
            dict=@{
                   @"Title":title,
                   @"EnterImage":@"Work_Notice",
                   @"AgentEnterImage":@"Work_AgentNotice",
                   @"Code":@"Announcement",
                   @"IsNew":@"0"
                   };
        }
    }
    return dict;
}
-(NSDictionary *)getControllerNameWithFlowCode:(NSString *)flowCode{
    NSDictionary *dict;
    if ([flowCode isEqualToString:@"F0001"]){
        dict=@{
               @"pushController":@"TravelRequestsViewController",
               @"pushHasController":@"LookTravelRequestsViewController",
               @"pushAppoverEditController":@"LookTravelRequestsViewController"
               };
    }else if ([flowCode isEqualToString:@"F0002"]) {
        dict=@{
               @"pushController":@"travelReimBusViewController",
               @"pushHasController":@"travelHasSubmitController",
               @"pushAppoverEditController":@"TravelAppoverController"
               };
    }else if ([flowCode isEqualToString:@"F0003"]) {
        dict=@{
               @"pushController":@"dailyReimViewController",
               @"pushHasController":@"dailyHasSumitViewController",
               @"pushAppoverEditController":@"DailyAppoverController"
               };
    }else if ([flowCode isEqualToString:@"F0004"]) {
        dict=@{
               @"pushController":@"AskingLeaveController",
               @"pushHasController":@"HasAskedLeaveController"
               };
    }else if ([flowCode isEqualToString:@"F0005"]){
        dict=@{
               @"pushController":@"MyProcurementController",
               @"pushHasController":@"MyHasProcurementController"
               };
    }else if ([flowCode isEqualToString:@"F0006"]){
        dict=@{
               @"pushController":@"MyAdvanceController",
               @"pushHasController":@"AdvanceHasSubmitController",
               @"pushAppoverEditController":@"AdvanceHasSubmitController"

               };
    }else if ([flowCode isEqualToString:@"F0007"]){
        dict=@{
               @"pushController":@"ItemRequestController",
               @"pushHasController":@"ItemHasRequestController"
               };
    }else if ([flowCode isEqualToString:@"F0008"]){
        dict=@{
               @"pushController":@"MyGeneralApproveController",
               @"pushHasController":@"GeneralAppHasSubmitController"
               };
    }else if ([flowCode isEqualToString:@"F0009"]){
        dict=@{
               @"pushController":@"MyPaymentNewController",
               @"pushHasController":@"MyPaymentHasController",
               @"pushAppoverEditController":@"MyPaymentApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0010"]){
        dict=@{
               @"pushController":@"OtherReimViewController",
               @"pushHasController":@"OtherReimHasViewController",
               @"pushAppoverEditController":@"OtherReimAppoverController"
               };
    }else if ([flowCode isEqualToString:@"F0011"]){
        dict=@{
               @"pushController":@"RepaymentAppController",
               @"pushHasController":@"RepaymentAppHasController",
               @"pushAppoverEditController":@"RepaymentAppHasController"
               };
        
    }else if ([flowCode isEqualToString:@"F0012"]){
        dict=@{
               @"pushController":@"FeeAppController",
               @"pushHasController":@"FeeAppHasController",
               @"pushAppoverEditController":@"FeeAppHasController"

               };
    }else if ([flowCode isEqualToString:@"F0013"]){
        dict=@{
               @"pushController":@"ContractAppNewController",
               @"pushHasController":@"ContractAppHasController",
               @"pushAppoverEditController":@"ContractAppApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0014"]){
        dict=@{
               @"pushController":@"VehicleApplyNewController",
               @"pushHasController":@"VehicleApplyHasController",
               @"pushAppoverEditController":@"VehicleApplyApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0015"]){
        dict=@{
               @"pushController":@"MyChopController",
               @"pushHasController":@"MyChopHasController"
               };
    }else if ([flowCode isEqualToString:@"F0016"]){
        dict=@{
               @"pushController":@"OutGoingController",
               @"pushHasController":@"OutGoingHasController",
               @"pushAppoverEditController":@"OutGoingApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0017"]){
        dict=@{
               @"pushController":@"OverTimeNewViewController",
               @"pushHasController":@"OverTimeHasViewController",
               @"pushAppoverEditController":@"OverTimeApproveViewController"
               };
    }else if ([flowCode isEqualToString:@"F0018"]){
        dict=@{
               @"pushController":@"ConferenceBookController",
               @"pushHasController":@"ConferenceBookHasController"
               };
    }else if ([flowCode isEqualToString:@"F0019"]){
        dict=@{
               @"pushController":@"InvoiceAppNewController",
               @"pushHasController":@"InvoiceAppHasController"
               };
    }else if ([flowCode isEqualToString:@"F0020"]){
        dict=@{
               @"pushController":@"CancelFlowNewController",
               @"pushHasController":@"CancelFlowHasController"
               };
    }else if ([flowCode isEqualToString:@"F0021"]){
        dict=@{
               @"pushController":@"WorkCardNewController",
               @"pushHasController":@"WorkCardHasController"
               };
    }else if ([flowCode isEqualToString:@"F0022"]){
        dict=@{
               @"pushController":@"PerformanceNewController",
               @"pushHasController":@"PerformanceHasController",
               };
    }else if ([flowCode isEqualToString:@"F0023"]){
        dict=@{
               @"pushController":@"EntertainmentNewController",
               @"pushHasController":@"EntertainmentHasController",
               @"pushAppoverEditController":@"EntertainmentHasController"
               };
    }else if ([flowCode isEqualToString:@"F0024"]){
        dict=@{
               @"pushController":@"VehicleRepairNewController",
               @"pushHasController":@"VehicleRepairHasController",
               @"pushAppoverEditController":@"VehicleRepairHasController"
               };
    }else if ([flowCode isEqualToString:@"F0025"]){
        dict=@{
               @"pushController":@"ReceiptNewController",
               @"pushHasController":@"ReceiptHasController",
               };
    }else if ([flowCode isEqualToString:@"F0026"]){
        dict=@{
               @"pushController":@"SupplierApplyNewController",
               @"pushHasController":@"SupplierApplyHasController",
               };
    }else if ([flowCode isEqualToString:@"F0027"]){
        dict=@{
               @"pushController":@"SpecialReqestNewController",
               @"pushHasController":@"SpecialReqestHasController",
               };
    }else if ([flowCode isEqualToString:@"F0028"]){
        dict=@{
               @"pushController":@"EmployeeTrainNewController",
               @"pushHasController":@"EmployeeTrainHasController",
               };
    }else if ([flowCode isEqualToString:@"F0029"]){
        dict=@{
               @"pushController":@"WareHouseEntryNewController",
               @"pushHasController":@"WareHouseEntryHasController",
               @"pushAppoverEditController":@"WareHouseEntryApproveViewController"
               };
    }else if ([flowCode isEqualToString:@"F0030"]){
        dict=@{
               @"pushController":@"InvoiceRegisterNewController",
               @"pushHasController":@"InvoiceRegisterHasController",
               @"pushAppoverEditController":@"InvoiceRegisterApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0031"]){
        dict=@{
               @"pushController":@"StatementNewController",
               @"pushHasController":@"StatementHasController",
               @"pushAppoverEditController":@"StatementApproveController"
               };
    }else if ([flowCode isEqualToString:@"F0032"]){
        dict=@{
               @"pushController":@"RemittanceNewController",
               @"pushHasController":@"RemittanceHasController",
               @"pushAppoverEditController":@"RemittanceApproveController"
               };
    }
    else if ([flowCode isEqualToString:@"F0033"]){
        dict=@{
               @"pushController":@"ContractFrameApp/",
               @"pushHasController":@"ContractFrameAppResult/",
               };
    }
    else if ([flowCode isEqualToString:@"F0034"]){
        dict=@{
               @"pushController":@"OrderContract/",
               @"pushHasController":@"OrderContractResult/",
               };
    }else if ([flowCode isEqualToString:@"F0035"]){
        dict=@{
               @"pushController":@"ContractPayMthApp/",
               @"pushHasController":@"ContractPayMthAppResult/",
               };
    }else if ([flowCode isEqualToString:@"F0036"]){
        dict=@{
               @"pushController":@"ContractFeeApp/",
               @"pushHasController":@"ContractFeeAppResult/",
               };
    }else if ([flowCode isEqualToString:@"F0037"]){
        dict=@{
               @"pushController":@"PurchaseNoContractApp/",
               @"pushHasController":@"PurchaseNoContractAppResult/",
               };
    }else if ([flowCode isEqualToString:@"F0038"]){
        dict=@{
               @"pushController":@"ContractAmountApp/",
               @"pushHasController":@"ContractAmountAppResult/",
               };
    }
    return dict;
}

-(BOOL)isH5FlowFormWithFlowCode:(NSString *)flowCode{
    if ([flowCode isEqualToString:@"F0033"] || [flowCode isEqualToString:@"F0034"] || [flowCode isEqualToString:@"F0035"] || [flowCode isEqualToString:@"F0036"] || [flowCode isEqualToString:@"F0037"] || [flowCode isEqualToString:@"F0038"]) {
        return YES;
    }
    return NO;
}

@end
