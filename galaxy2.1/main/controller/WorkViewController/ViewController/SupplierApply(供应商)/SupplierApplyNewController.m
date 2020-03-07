//
//  SupplierApplyNewController.m
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "SupplierApplyNewController.h"

@interface SupplierApplyNewController ()

@end

@implementation SupplierApplyNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[SupplierFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;
    
    if (self.pushTaskId) {
        self.FormDatas.str_taskId=self.pushTaskId;
        self.FormDatas.str_procId=self.pushProcId;
        self.FormDatas.str_userId=self.pushUserId;
        self.FormDatas.int_comeStatus=[self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
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
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SupplierName=[[UIView alloc]init];
    _View_SupplierName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SupplierName];
    [_View_SupplierName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SupplierCode=[[UIView alloc]init];
    _View_SupplierCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SupplierCode];
    [_View_SupplierCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SupplierName.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_SupplierCat=[[UIView alloc]init];
    _View_SupplierCat.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SupplierCat];
    [_View_SupplierCat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SupplierCode.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VMSCode = [[UIView alloc]init];
    _View_VMSCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_VMSCode];
    [_View_VMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SupplierCat.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DetailsTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_DetailsTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_DetailsTable.delegate=self;
    _View_DetailsTable.dataSource=self;
    _View_DetailsTable.scrollEnabled=NO;
    _View_DetailsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VMSCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails=[[UIView alloc]init];
    _View_AddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankAccount=[[UIView alloc]init];
    _View_BankAccount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankAccount];
    [_View_BankAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankOutlets = [[UIView alloc]init];
    _View_BankOutlets.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankOutlets];
    [_View_BankOutlets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankAccount.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BankName = [[UIView alloc]init];
    _View_BankName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankName];
    [_View_BankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankOutlets.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_BankCity = [[UIView alloc]init];
    _View_BankCity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BankCity];
    [_View_BankCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankName.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Contacts=[[UIView alloc]init];
    _View_Contacts.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Contacts];
    [_View_Contacts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BankCity.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Tel=[[UIView alloc]init];
    _View_Tel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Tel];
    [_View_Tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Contacts.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Addr=[[UIView alloc]init];
    _View_Addr.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Addr];
    [_View_Addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Tel.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ZipCode=[[UIView alloc]init];
    _View_ZipCode.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ZipCode];
    [_View_ZipCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Addr.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ZipCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Note.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
}
//MARK:网络部分
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
    self.FormDatas.dict_resultDict=responceDic;
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
        
        if ([model.fieldName isEqualToString:@"SupplierName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SupplierCat"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateSupplierCatViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"VmsCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateVmsCodeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvBankAccount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvBankAccountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankOutlets"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankOutletsViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvBankName"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvBankNameViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"BankCity"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBankCityViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvContacts"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvContactsViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvTel"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvTelViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvAddr"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvAddrViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"InvZipCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateInvZipCodeViewWithModel:model];
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
            SupplierDetail *model=[[SupplierDetail alloc]init];
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

//MARK:更新供应商名称
-(void)updateSupplierNameViewWithModel:(MyProcurementModel *)model{
    _txf_SupplierName=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SupplierName WithContent:_txf_SupplierName WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_SupplierName addSubview:view];
}

//MARK:更新供应商code
-(void)updateSupplierCodeViewWithModel:(MyProcurementModel *)model{
    _txf_SupplierCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SupplierCode WithContent:_txf_SupplierCode WithFormType:self.FormDatas.int_codeIsSystem == 0 ? formViewShowText:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    if (self.FormDatas.int_codeIsSystem != 0) {
        __weak typeof(self) weakSelf = self;
        view.TextChangedBlock = ^(NSString *text) {
            weakSelf.FormDatas.str_SupplierCode = text;
        };
    }
    if (self.FormDatas.int_comeStatus == 1 && self.FormDatas.int_codeIsSystem == 0) {
        _txf_SupplierCode.text = Custing(@"系统自动生成", nil);
    }
    [_View_SupplierCode addSubview:view];
}
//MARK:更新供应商分类
-(void)updateSupplierCatViewWithModel:(MyProcurementModel *)model{
    _txf_SupplierCat=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_SupplierCat WithContent:_txf_SupplierCat WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf ChangeSupplierCat];
    }];
    [_View_SupplierCat addSubview:view];
    
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_SupplierCat=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}

//MARK:更新明细
-(void)updateDetailsTableView{
    [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_DetailsArray.count*42+27)*self.FormDatas.arr_DetailsDataArray.count));
    }];
    [_View_DetailsTable reloadData];
}
//MARK:更新增加按钮
-(void)updateAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_AddDetails withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        SupplierDetail *model1=[[SupplierDetail alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
}
//MARK:更新VmsCode
-(void)updateVmsCodeViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_VMSCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_VMSCode WithContent:_txf_VMSCode WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.TextChangedBlock = ^(NSString *text) {
        weakSelf.FormDatas.str_VmsCode = text;
    };
    [_View_VMSCode addSubview:view];
    _txf_VMSCode.keyboardType = UIKeyboardTypeEmailAddress;
}
//MARK:更新供应商开户账号
-(void)updateInvBankAccountViewWithModel:(MyProcurementModel *)model{
    model.enterLimit = 100;
    _txf_BankAccount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankAccount WithContent:_txf_BankAccount WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankAccount addSubview:view];
    _txf_BankAccount.keyboardType = UIKeyboardTypeEmailAddress;
}
//MARK:更新开户行网点
-(void)updateBankOutletsViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    _txf_BankOutlets = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_BankOutlets WithContent:_txf_BankOutlets WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ClearingBank"];
        vc.ChooseBankOutletsBlock = ^(NSMutableArray *array) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_BankOutlets.text = model.bankName;
            weakSelf.txf_BankName.text = model.clearingBank;
            weakSelf.txf_BankCity.text = [GPUtils getSelectResultWithArray:@[model.provinceName,model.cityName] WithCompare:@"/"];
            weakSelf.FormDatas.str_BankNo = model.clearingBankNo;
            weakSelf.FormDatas.str_BankCode = model.clearingBankCode;
            weakSelf.FormDatas.str_CNAPS = model.bankNo;
            weakSelf.FormDatas.str_BankProvinceCode = model.provinceCode;
            weakSelf.FormDatas.str_BankProvince = model.provinceName;
            weakSelf.FormDatas.str_BankCityCode = model.cityCode;
            weakSelf.FormDatas.str_BankCity = model.cityName;
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    [_View_BankOutlets addSubview:view];
}
//MARK:更新供应商开户行
-(void)updateInvBankNameViewWithModel:(MyProcurementModel *)model{
    _txf_BankName = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankName WithContent:_txf_BankName WithFormType:formViewShowText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_BankName addSubview:view];
}
//MARK:更新开户行城市
-(void)updateBankCityViewWithModel:(MyProcurementModel *)model{
    _txf_BankCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BankCity WithContent:_txf_BankCity WithFormType:formViewShowText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_BankProvince,self.FormDatas.str_BankCity] WithCompare:@"/"]}];
    [_View_BankCity addSubview:view];
}
//MARK:更新供应商联系人
-(void)updateInvContactsViewWithModel:(MyProcurementModel *)model{
    _txf_Contacts=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Contacts WithContent:_txf_Contacts WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Contacts addSubview:view];
}
//MARK:更新供应商电话
-(void)updateInvTelViewWithModel:(MyProcurementModel *)model{
    _txf_Tel=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Tel WithContent:_txf_Tel WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Tel addSubview:view];
}
//MARK:更新供应商地址
-(void)updateInvAddrViewWithModel:(MyProcurementModel *)model{
    _txf_Addr=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Addr WithContent:_txf_Addr WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Addr addSubview:view];
}
//MARK:更新供应商邮编
-(void)updateInvZipCodeViewWithModel:(MyProcurementModel *)model{
    _txf_ZipCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ZipCode WithContent:_txf_ZipCode WithFormType:formViewEnterText  WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ZipCode addSubview:view];
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

//MARK:更新备注
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
//MARK:供应商分类选择
-(void)ChangeSupplierCat{
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"SupplierCat"];
    choose.ChooseCategoryId=self.FormDatas.str_SupplierCatId;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCategoryModel *model = array[0];
        weakSelf.FormDatas.str_SupplierCatId = model.Id;
        weakSelf.FormDatas.str_SupplierCat = model.name;
        weakSelf.txf_SupplierCat.text = model.name;
    };
    [self.navigationController pushViewController:choose animated:YES];
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
    contactVC.itemType = 26;
    contactVC.Radio = @"1";
    contactVC.universalDelegate = self;
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
    return 42;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
    if (cell==nil) {
        cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
    }
    [cell configSupplierApplyDeatilCellWithModel :self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
    cell.IndexPath=indexPath;
    
    [cell.NameTextField addTarget:self action:@selector(NameChange:) forControlEvents:UIControlEventEditingChanged];
    cell.NameTextField.tag=100+indexPath.section;
    cell.NameTextField.delegate = self;
    
    if (cell.SupplierBtn) {
        __weak typeof(self) weakSelf = self;
        [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
            [weakSelf keyClose];
            SupplierDetail *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
            if (!modelD) {
                SupplierDetail *modelD=[[SupplierDetail alloc]init];
                [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
            }
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                modelD.Sex=Model.Id;
                tf.text=Model.Type;
            }];
            picker.typeTitle=Custing(@"性别", nil);
            picker.DateSourceArray=weakSelf.FormDatas.arr_SexType;
            STOnePickModel *model1=[[STOnePickModel alloc]init];
            model1.Id=[NSString stringWithFormat:@"%@",modelD.Sex];
            picker.Model=model1;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
    }
    
    
    [cell.BrandTextField addTarget:self action:@selector(DeptChange:) forControlEvents:UIControlEventEditingChanged];
    cell.BrandTextField.tag=100+indexPath.section;
    cell.BrandTextField.delegate = self;
    
    [cell.SizeTextField addTarget:self action:@selector(JobTitleChange:) forControlEvents:UIControlEventEditingChanged];
    cell.SizeTextField.tag=100+indexPath.section;
    cell.SizeTextField.delegate = self;
    
    [cell.QtyTextField addTarget:self action:@selector(TelChange:) forControlEvents:UIControlEventEditingChanged];
    cell.QtyTextField.tag=100+indexPath.section;
    cell.QtyTextField.delegate = self;

    [cell.RemarkTextField addTarget:self action:@selector(EmailChange:) forControlEvents:UIControlEventEditingChanged];
    cell.RemarkTextField.tag=100+indexPath.section;
    cell.RemarkTextField.delegate = self;
    
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
    return _View_Head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}
//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField.tag>=100&&textField.tag<=150){
        if ([toBeString length] >255) {
            textField.text = [toBeString substringToIndex:255];
            return NO;
        }
    }
    return YES;
}

#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _View_Head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_Head addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_Head addSubview:titleLabel];
    
    if (self.FormDatas.arr_DetailsDataArray.count==1) {
        titleLabel.text=Custing(@"联系人", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"联系人", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_View_Head addSubview:deleteBtn];
        }
    }
    _View_Head.backgroundColor=Color_White_Same_20;
}

//MARK:明细详情填写
-(void)NameChange:(UITextField *)text{
    SupplierDetail *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        SupplierDetail *model=[[SupplierDetail alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Name=text.text;
    }else{
        model.Name=text.text;
    }
}
-(void)DeptChange:(UITextField *)text{
    SupplierDetail *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        SupplierDetail *model=[[SupplierDetail alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Dept=text.text;
    }else{
        model.Dept=text.text;
    }
}
-(void)JobTitleChange:(UITextField *)text{
    SupplierDetail *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        SupplierDetail *model=[[SupplierDetail alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.JobTitle=text.text;
    }else{
        model.JobTitle=text.text;
    }
}
-(void)TelChange:(UITextField *)text{
    SupplierDetail *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        SupplierDetail *model=[[SupplierDetail alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Tel=text.text;
    }else{
        model.Tel=text.text;
    }
}
-(void)EmailChange:(UITextField *)text{
    SupplierDetail *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        SupplierDetail *model=[[SupplierDetail alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Email=text.text;
    }else{
        model.Email=text.text;
    }
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    [self keyClose];
    NSLog(@"删除明细");
    _Aler_DeleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除联系人", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    _Aler_DeleteDetils.tag=btn.tag-1200;
    [_Aler_DeleteDetils show];
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView==_Aler_DeleteDetils) {
            [self.FormDatas.arr_DetailsDataArray removeObjectAtIndex:alertView.tag];
            [self updateDetailsTableView];
        }
    }
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
    NSLog(@"保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo{
    [self keyClose];
    NSLog(@"保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=3;
    [self mainDataList];
}
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
    self.FormDatas.SubmitData.SupplierName = _txf_SupplierName.text;
    self.FormDatas.SubmitData.InvBankAccount = _txf_BankAccount.text;
    self.FormDatas.SubmitData.BankOutlets = _txf_BankOutlets.text;
    self.FormDatas.SubmitData.InvBankName = _txf_BankName.text;
    self.FormDatas.SubmitData.InvContacts = _txf_Contacts.text;
    self.FormDatas.SubmitData.InvTel = _txf_Tel.text;
    self.FormDatas.SubmitData.InvAddr = _txf_Addr.text;
    self.FormDatas.SubmitData.InvZipCode = _txf_ZipCode.text;
    self.FormDatas.SubmitData.Remark = _txv_Remark.text;
}

//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:CHOPAppLoadImage WithBlock:^(id data, BOOL hasError) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
