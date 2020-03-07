//
//  WareHouseEntryNewController.m
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "WareHouseEntryNewController.h"

@interface WareHouseEntryNewController ()

@end

@implementation WareHouseEntryNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas = [[WareHouseEntryFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color_White_Same_20;
    if (self.pushTaskId) {
        self.FormDatas.str_taskId = self.pushTaskId;
        self.FormDatas.str_procId = self.pushProcId;
        self.FormDatas.str_userId = self.pushUserId;
        self.FormDatas.int_comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex && self.pushBackIndex) {
            self.backIndex = self.pushBackIndex;
        }
    }
    if (self.pushFlowGuid) {
        self.FormDatas.str_flowGuid = self.pushFlowGuid;
    }
    [self setTitle:nil backButton:YES];
    [self createScrollView];
    [self createMainView];
    [self getFormData];
}

-(void)createDealBtns{
    if (self.FormDatas.int_comeStatus==1||self.FormDatas.int_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf saveInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else if (self.FormDatas.int_comeStatus==3&&![self.FormDatas.str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf directInfo];
            }else{
                [weakSelf submitInfo];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf submitInfo];
            }
        };
    }
}

//MARK:创建scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
//MARK:创建主视图
-(void)createMainView{
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason = [[UIView alloc]init];
    _View_Reason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StoreDate = [[UIView alloc]init];
    _View_StoreDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StoreDate];
    [_View_StoreDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StoreDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm = [[MulChooseShowView alloc]initWithStatus:1 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ReceivedDate = [[UIView alloc]init];
    _View_ReceivedDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ReceivedDate];
    [_View_ReceivedDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StoreType = [[UIView alloc]init];
    _View_StoreType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StoreType];
    [_View_StoreType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ReceivedDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
   
    _View_InvStorage = [[UIView alloc]init];
    _View_InvStorage.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvStorage];
    [_View_InvStorage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StoreType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InvStorageAddr = [[UIView alloc]init];
    _View_InvStorageAddr.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InvStorageAddr];
    [_View_InvStorageAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvStorage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
   
    _View_DetailsTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_DetailsTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_DetailsTable.delegate = self;
    _View_DetailsTable.dataSource = self;
    _View_DetailsTable.scrollEnabled = NO;
    _View_DetailsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvStorageAddr.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails = [[UIView alloc]init];
    _View_AddDetails.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalMoney = [[UIView alloc]init];
    _View_TotalMoney.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalMoney];
    [_View_TotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized = [[UIView alloc]init];
    _View_Capitalized.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalMoney.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved = [[UIView alloc]init];
    _View_Reserved.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark = [[UIView alloc]init];
    _View_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg = [[UIView alloc]init];
    _View_AttachImg.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note = [[UIView alloc]init];
    _View_Note.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve = [[UIView alloc]init];
    _View_Approve.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople = [[UIView alloc]init];
    _View_CcToPeople.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}
//MARK:网络部分
//MARK:第一次打开采购表单
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:7 IfUserCache:NO];
}

//MARK:请求成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    self.FormDatas.dict_resultDict = responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        return;
    }
    
    switch (serialNum) {
        case 0:
        {
            [self.FormDatas DealWithFormBaseData];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            if (self.FormDatas.int_comeStatus==3){
                [self requestApproveNote];
            }else{
                [self updateMainView];
                [self createDealBtns];
            }
        }
            break;
        case 1:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
            
        }
            break;
        case 3:
        {
            
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"result"]] forKey:@"TaskId"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goSubmitSuccessTo:) userInfo:dict repeats:NO];
        }
            break;
        case 7:
        {
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
        }
            break;
        case 10:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        default:
            break;
    }
}

//MARK:-请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
    
}
-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled=YES;
    [self goSubmitSuccessToWithModel:self.FormDatas];
}
//MARK:视图更新
-(void)updateMainView{
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        } else if ([model.fieldName isEqualToString:@"StoreDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStoreDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ContractName"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateContractNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ProjId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePurchaseNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ReceivedDate"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReceivedDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"StoreType"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStoreTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvStorageName"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvStorageViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvStorageAddr"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvStorageAddrViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTotalMoneyViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCapitalizedAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Remark"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRemarkViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAttachImgViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:@"1" forKey:self.FormDatas.model_ApprovelPeoModel.fieldName];
                [self updateApproveViewWithModel:self.FormDatas.model_ApprovelPeoModel];
                [self.FormDatas.arr_UnShowmsArray removeObject:@"FirstHandlerUserName"];
            }
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateCcPeopleViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }
    }
    if (self.FormDatas.bool_DetailsShow) {
        if (self.FormDatas.arr_DetailsDataArray.count==0) {
            WareHouseEntryDetail *model = [[WareHouseEntryDetail alloc]init];
            [self.FormDatas.arr_DetailsDataArray addObject:model];
        }
        [self.FormDatas.arr_UnShowmsArray removeObject:@"DetailList"];
        [self updateDetailsTableView];
        [self updateAddDetailsView];
    }
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    [self updateContentView];
    
    [self.FormDatas getEndShowArray];
}

//MARK:更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新入库日期视图
-(void)updateStoreDateViewWithModel:(MyProcurementModel *)model{
    _txf_StoreDate = [[UITextField alloc]init];
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr = [pickerFormatter stringFromDate:pickerDate];
        model.fieldValue = currStr;
    }
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_StoreDate WithContent:_txf_StoreDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_StoreDate addSubview:view];
}
//MARK:更新供应商视图
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.SupplierName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf SupplierClick];
    }];
    [_View_Supplier addSubview:view];
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName],
                           @"Model":model
                           };
    [_View_ContractName updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ContractName.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf ContractClick];
    };
}
//MARK:更新项目视图
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    _txf_Project = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Project WithContent:_txf_Project WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.personalData.ProjName}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ProjectClick];
    }];
    [_View_Project addSubview:view];
}
//MARK:更新采购申请单视图
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_PurchaseNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_PurchaseInfo=@"";
        self.FormDatas.str_PurchaseNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo],
                           @"Model":model
                           };
    [_View_PurchaseForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_PurchaseForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf PurchaseFormClick];
    };
}
//MARK:更新收货日期视图
-(void)updateReceivedDateViewWithModel:(MyProcurementModel *)model{
    _txf_ReceivedDate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ReceivedDate WithContent:_txf_ReceivedDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ReceivedDate addSubview:view];
}
//MARK:更新入库类型
-(void)updateStoreTypeViewWithModel:(MyProcurementModel *)model{
    _txf_StoreType = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StoreType WithContent:_txf_StoreType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_StoreTypeId;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_StoreType.text = model.name;
            weakSelf.FormDatas.str_StoreType = model.name;
            weakSelf.FormDatas.str_StoreTypeId = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_StoreType addSubview:view];
}
//MARK:更新仓库
-(void)updateInvStorageViewWithModel:(MyProcurementModel *)model{
    _txf_InvStorage = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvStorage WithContent:_txf_InvStorage WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"InventoryStorage"];
        vc.ChooseCategoryId = weakSelf.FormDatas.str_InvStorageId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.FormDatas.str_InvStorageId = model.Id;
            weakSelf.FormDatas.str_InvStorageCode = model.code;
            weakSelf.FormDatas.str_InvStorageName = [GPUtils getSelectResultWithArray:@[model.code, model.name] WithCompare:@"/"];
            weakSelf.txf_InvStorage.text = weakSelf.FormDatas.str_InvStorageName;
            weakSelf.txf_InvStorageAddr.text = model.address;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_InvStorage addSubview:view];
}
//MARK:更新仓库地址
-(void)updateInvStorageAddrViewWithModel:(MyProcurementModel *)model{
    _txf_InvStorageAddr = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvStorageAddr WithContent:_txf_InvStorageAddr WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_InvStorageAddr addSubview:view];
}
//MARK:更新采购明细
-(void)updateDetailsTableView{
    [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_DetailsArray.count*50+27)*self.FormDatas.arr_DetailsDataArray.count));
    }];
    [_View_DetailsTable reloadData];
}
//MARK:更新采购增加按钮
-(void)updateAddDetailsView{
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_AddDetails withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf keyClose];
        WareHouseEntryDetail *model1 = [[WareHouseEntryDetail alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
}
//MARK:更新采购合计金额
-(void)updateTotalMoneyViewWithModel:(MyProcurementModel *)model{
    _txf_TotalMoney = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TotalMoney WithContent:_txf_TotalMoney WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalMoney addSubview:view];
}
//MARK:更新金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Capitalized addSubview:view];
}
//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[[ReserverdMainView alloc]initArr:self.FormDatas.arr_FormMainArray isRequiredmsdic:self.FormDatas.dict_isRequiredmsdic reservedDic:self.FormDatas.dict_reservedDic UnShowmsArray:self.FormDatas.arr_UnShowmsArray view:_View_Reserved model:self.FormDatas.model_ReserverModel block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购备注
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Remark addSubview:view];
}
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}
//MARK:审批记录
-(void)updateNotesTableView{
    __weak typeof(self) weakSelf = self;
    [_View_Note addSubview:[[FlowChartView alloc] init:self.FormDatas.arr_noteDateArray Y:10 HeightBlock:^(NSInteger height) {
        [weakSelf.View_Note addSubview:[weakSelf createLineView]];
        [weakSelf.View_Note updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height+10+15);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}
//MARK:更新采购审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_firstHanderPhotoGraph,@"value2":self.FormDatas.str_firstHandlerGender}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.View_ApproveImg=image;
        [self ApproveClick];
    }];
    [_View_Approve addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _txf_Approver.text=model.fieldValue;
        self.FormDatas.str_firstHanderName=model.fieldValue;
    }
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_CcToPeople.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:修改供应商
-(void)SupplierClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"Supplier"];
    vc.ChooseCategoryId = self.FormDatas.personalData.SupplierId;
    vc.dict_otherPars = @{@"DateType":self.FormDatas.str_SupplierParam};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.SupplierId = model.Id;
        weakSelf.FormDatas.personalData.SupplierName = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        weakSelf.txf_Supplier.text = weakSelf.FormDatas.personalData.SupplierName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改合同
-(void)ContractClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"RelaContract"];
    vc.ChooseCategoryId = self.FormDatas.str_ContractAppNumber;
    vc.dict_otherPars=@{@"Type":@"2",@"FlowGuid":self.FormDatas.str_flowGuid};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_ContractAppNumber = model.taskId;
        weakSelf.FormDatas.str_ContractNo = model.contractNo;
        weakSelf.FormDatas.str_ContractName = [GPUtils getSelectResultWithArray:@[model.serialNo,model.contractName]];
        
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName]                               };
        [weakSelf.View_ContractName updateView:dict];

        weakSelf.FormDatas.personalData.ProjId = model.projId;
        weakSelf.FormDatas.personalData.ProjName = model.projName;
        weakSelf.txf_Project.text = model.projName;
        weakSelf.FormDatas.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.FormDatas.personalData.ProjMgr = model.projMgr;
        weakSelf.FormDatas.str_PurchaseInfo = model.purchaseInfo;
        weakSelf.FormDatas.str_PurchaseNumber = model.purchaseNumber;
        
        NSDictionary *dict1 = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo]                               };
        [weakSelf.View_PurchaseForm updateView:dict1];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改项目名称
-(void)ProjectClick{
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"projectName"];
    vc.ChooseCategoryId = self.FormDatas.personalData.ProjId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.personalData.ProjId = model.Id;
        weakSelf.FormDatas.personalData.ProjName = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        weakSelf.txf_Project.text = weakSelf.FormDatas.personalData.ProjName;
        weakSelf.FormDatas.personalData.ProjMgrUserId = model.projMgrUserId;
        weakSelf.FormDatas.personalData.ProjMgr = model.projMgr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:修改采购申请单
-(void)PurchaseFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"PurchaseNumber"];
    vc.ChooseCategoryId=self.FormDatas.str_PurchaseNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        weakSelf.FormDatas.str_PurchaseInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_PurchaseNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo]                               };
        [weakSelf.View_PurchaseForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:审批人选择
-(void)ApproveClick{
    NSLog(@"审批人选择");
    [self keyClose];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_firstHanderId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.arrClickPeople = array;
    contactVC.status = @"1";
    contactVC.menutype=3;
    contactVC.itemType = 29;
    contactVC.Radio = @"1";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.txf_Approver.text=bul.requestor;
        self.FormDatas.str_firstHanderName=bul.requestor;
        self.FormDatas.str_firstHanderId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                self.FormDatas.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:self.FormDatas.str_firstHanderPhotoGraph]];
            }
        }else{
            if ([[NSString stringWithFormat:@"%d",bul.gender] isEqualToString:@"0"]) {
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Man"];
            }else{
                weakSelf.View_ApproveImg.image=[UIImage imageNamed:@"Message_Woman"];
            }
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
    
}
//MARK:选择抄送人
-(void)CcPeopleClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_CcUsersId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.status = @"12";
    contactVC.isCleanSelf = YES;
    contactVC.arrClickPeople =array;
    contactVC.menutype=3;
    contactVC.itemType = 99;
    contactVC.Radio = @"2";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr=[NSMutableArray array];
        NSMutableArray *idArr=[NSMutableArray array];
        if (array.count>0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                }
            }
        }
        weakSelf.FormDatas.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_CcToPeople.text=weakSelf.FormDatas.str_CcUsersName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}
#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.FormDatas.arr_DetailsDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.FormDatas.arr_DetailsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FormDetailBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FormDetailBaseCell"];
    if (cell==nil) {
        cell=[[FormDetailBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormDetailBaseCell"];
    }
    cell.IndexPath=indexPath;
    [cell configWareHouseEntryCellWithModel:self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.CellBackDataBlock = ^(NSIndexPath * _Nonnull index, UITextField * _Nonnull tf, MyProcurementModel * _Nonnull model, id  _Nonnull dModel) {
        WareHouseEntryDetail *item = (WareHouseEntryDetail*)dModel;
        if ([model.fieldName isEqualToString:@"Name"]) {
            if ([model.ctrlTyp isEqualToString:@"dialog"]) {
                [weakSelf keyClose];
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"PurchaseItems"];
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    item.ItemId = model.purId;
                    item.ItemCatId = model.purItemCatId;
                    item.ItemCatName = model.purItemCatName;
                    item.Code = model.purCode;
                    item.Name = [GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];
                    item.Spec = model.purSize;
                    item.Unit = model.purUnit;
                    item.Brand = model.purBrand;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index.section];
                    [weakSelf.View_DetailsTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf.FormDatas getTotolAmount];
                    weakSelf.txf_TotalMoney.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_TotalMoney];
                    weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.FormDatas.str_TotalMoney];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                item.Name = tf.text;
            }
        }else if ([model.fieldName isEqualToString:@"Brand"]) {
            item.Brand = tf.text;
        }else if ([model.fieldName isEqualToString:@"Spec"]) {
            item.Spec = tf.text;
        }else if ([model.fieldName isEqualToString:@"Unit"]) {
            item.Unit = tf.text;
        }else if ([model.fieldName isEqualToString:@"Qty"]) {
            item.Qty = tf.text;
            item.Amount = [GPUtils decimalNumberMultipWithString:item.Qty with:item.Price];
            [weakSelf.View_DetailsTable reloadData];
            FormDetailBaseCell *cell = [weakSelf.View_DetailsTable cellForRowAtIndexPath:index];
            [cell.txf_Contet becomeFirstResponder];
            [weakSelf.FormDatas getTotolAmount];
            weakSelf.txf_TotalMoney.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_TotalMoney];
            weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.FormDatas.str_TotalMoney];
        }else if ([model.fieldName isEqualToString:@"Price"]) {
            item.Price = tf.text;
            item.Amount = [GPUtils decimalNumberMultipWithString:item.Qty with:item.Price];
            [weakSelf.View_DetailsTable reloadData];
            FormDetailBaseCell *cell = [weakSelf.View_DetailsTable cellForRowAtIndexPath:index];
            [cell.txf_Contet becomeFirstResponder];
            [weakSelf.FormDatas getTotolAmount];
            weakSelf.txf_TotalMoney.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_TotalMoney];
            weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.FormDatas.str_TotalMoney];
        }else if ([model.fieldName isEqualToString:@"Amount"]) {
            item.Amount = tf.text;
            [weakSelf.FormDatas getTotolAmount];
            weakSelf.txf_TotalMoney.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_TotalMoney];
            weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.FormDatas.str_TotalMoney];
        }else if ([model.fieldName isEqualToString:@"Remark"]) {
            item.Remark = tf.text;
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self createHeadViewWithSection:section];
    return _View_head;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}
//MARK:创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _View_head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_head addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_head addSubview:titleLabel];
    
    if (self.FormDatas.arr_DetailsDataArray.count==1) {
        titleLabel.text=Custing(@"入库物品明细", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"入库物品明细", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_View_head addSubview:deleteBtn];
        }
    }
    _View_head.backgroundColor=Color_White_Same_20;
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    [self keyClose];
    NSString *title;
    if (btn.tag>=1200) {
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除物品明细", nil),(long)(btn.tag-1200+1)];
    }
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:@"" message:title cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"删除",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (btn.tag>=1200) {
                [weakSelf.FormDatas.arr_DetailsDataArray removeObjectAtIndex:btn.tag-1200];
                [weakSelf.FormDatas getTotolAmount];
                weakSelf.txf_TotalMoney.text = [GPUtils transformNsNumber:weakSelf.FormDatas.str_TotalMoney];
                weakSelf.txf_Capitalized.text = [NSString getChineseMoneyByString:weakSelf.FormDatas.str_TotalMoney];
                [weakSelf updateDetailsTableView];
            }
        }
    }];
}
//MARK:保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
}
//MARK:提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"提交操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    [self mainDataList];
}
//MARK:提交保存数据处理
//拼接数据
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    if (self.FormDatas.int_SubmitSaveType == 2 || self.FormDatas.int_SubmitSaveType == 3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }
    }
    [self.FormDatas contectData];
    [self dealWithImagesArray];
}
-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason = _txv_Reason.text;
    self.FormDatas.SubmitData.StoreDate = _txf_StoreDate.text;
    self.FormDatas.SubmitData.ReceivedDate = _txf_ReceivedDate.text;
    self.FormDatas.SubmitData.InvStorageAddr = _txf_InvStorageAddr.text;
    self.FormDatas.SubmitData.Remark = _txv_Remark.text;
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.FormDatas.str_imageDataString=data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf readySubmitAndSave];
        }
    }];
}

-(void)readySubmitAndSave{
    if (self.FormDatas.int_SubmitSaveType==1) {
        [self requestAppSave];
    }else if(self.FormDatas.int_SubmitSaveType==2){
        if (self.FormDatas.int_comeStatus==3) {
            [self requestAppbackSubmit];
        }else if (self.FormDatas.int_comeStatus==4){
            [self requestAppReCallSubmit];
        }else{
            [self requestAppSubmit];
        }
    }else if (self.FormDatas.int_SubmitSaveType ==3){
        [self requestDirect];
    }
}
//MARK:保存
-(void)requestAppSave
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:提交
-(void)requestAppSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSubmitUrl] Parameters:[self.FormDatas SubmitFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:退单提交
-(void)requestAppbackSubmit{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:撤回提交
-(void)requestAppReCallSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getBackSubmitUrl] Parameters:[self.FormDatas SubmitFormAgainWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:直送提交
-(void)requestDirect{
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=self.FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
