//
//  MyProcurementController.m
//  galaxy
//
//  Created by hfk on 16/4/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//
#import "MyProcurementController.h"

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
@interface MyProcurementController ()

@end

@implementation MyProcurementController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[MyProcureFormData alloc]initWithStatus:1];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
//是否跨部门数组
- (NSMutableArray *)arr_IsCrossD{
    if (!_arr_IsCrossD) {
        _arr_IsCrossD = [NSMutableArray array];
        for (int i = 0 ; i < 2; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc]init];
            if (i == 0) {
                model.Id = @"0";
                model.Type = @"No";
            }else{
                model.Id = @"1";
                model.Type = @"Yes";
            }
            [_arr_IsCrossD addObject:model];
        }
    }
    return _arr_IsCrossD;
}
//单据可见范围
- (NSMutableArray *)arr_FormScope{
    if (!_arr_FormScope) {
        _arr_FormScope = [NSMutableArray array];
        NSArray *idArray = [NSArray arrayWithObjects:@"0",@"1",@"2", nil];
        NSArray *typeArray = [NSArray arrayWithObjects:Custing(@"仅自己可见", nil),Custing(@"相同成本中心内均可见", nil),Custing(@"全公司可见", nil), nil];
        for (int i = 0 ; i < 3; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idArray[i];
            model.Type = typeArray[i];
            [_arr_FormScope addObject:model];
        }
    }
    return _arr_FormScope;
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
    
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];

    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //创建单据可见范围视图
    _View_FormScope=[[UIView alloc]init];
    _View_FormScope.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FormScope];
    [_View_FormScope mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //创建费用申请单视图
    _View_FeeAppForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0012"];
         _View_FeeAppForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppForm];
    [_View_FeeAppForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FormScope.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FeeAppForm.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
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
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails=[[UIView alloc]init];
    _View_AddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //    采购项目
    _View_purBusinessTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_purBusinessTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_purBusinessTable.delegate=self;
    _View_purBusinessTable.dataSource=self;
    _View_purBusinessTable.scrollEnabled=NO;
    _View_purBusinessTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_purBusinessTable];
    [_View_purBusinessTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_BuAddDetails=[[UIView alloc]init];
    _View_BuAddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_BuAddDetails];
    [_View_BuAddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_purBusinessTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
//    采购项目明细及金额
    _View_purAmountTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_purAmountTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_purAmountTable.delegate=self;
    _View_purAmountTable.dataSource=self;
    _View_purAmountTable.scrollEnabled=NO;
    _View_purAmountTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_purAmountTable];
    [_View_purAmountTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BuAddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _View_AmAddDetails=[[UIView alloc]init];
    _View_AmAddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AmAddDetails];
    [_View_AmAddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_purAmountTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //单一采购来源清单显示项
    _View_soPurSource=[[UIView alloc]init];
    _View_soPurSource.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_soPurSource];
    [_View_soPurSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AmAddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
//    单一采购来源清单
    _View_purSourceTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_purSourceTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_purSourceTable.delegate=self;
    _View_purSourceTable.dataSource=self;
    _View_purSourceTable.scrollEnabled=NO;
    _View_purSourceTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_purSourceTable];
    [_View_purSourceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_soPurSource.bottom);
        make.left.right.equalTo(self.contentView);
    }];
//    _View_SoAddDetails=[[UIView alloc]init];
//    _View_SoAddDetails.backgroundColor=Color_White_Same_20;
//    [self.contentView addSubview:_View_SoAddDetails];
//    [_View_SoAddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.View_purSourceTable.bottom);
//        make.left.right.equalTo(self.contentView);
//    }];
    _View_PayWay=[[UIView alloc]init];
    _View_PayWay.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayWay];
    [_View_PayWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_purSourceTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PayDate=[[UIView alloc]init];
    _View_PayDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PayDate];
    [_View_PayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayWay.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalMoney=[[UIView alloc]init];
    _View_TotalMoney.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalMoney];
    [_View_TotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PayDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized=[[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalMoney.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Capitalized.bottom);
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
    
    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
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
//MARK:获取费用类别
- (void)requestCate{
    NSString *url = [NSString stringWithFormat:@"%@",GETCATEList];
    NSDictionary *parameters = @{@"Type":@"0"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
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
                [self requestCate];
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
        case 5:
        {
            [self.FormDatas dealWithCateDateWithType:2];
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
    
    [_FormRelatedView initFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithBaseModel:self.FormDatas Withcontroller:self];

    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PurchaseType"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PayMode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayWayViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"DeliveryDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePayDateViewWithModel:model];
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
        }else if([model.fieldName isEqualToString:@"FeeAppNumber"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateFeeAppFormViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FormScope"]){
            if ([[model.isShow stringValue] isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateFormScopeWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }
    }
    if (self.FormDatas.bool_DetailsShow) {
        [self.FormDatas initProcureItemDate];
        [self.FormDatas.arr_UnShowmsArray removeObject:@"DetailList"];
        [self updateDetailsTableView];
        [self updateAddDetailsView];
    }
    //更新采购项目明细及金额
    if (self.FormDatas.bool_SecDetailsShow) {
        [self.FormDatas.arr_UnShowmsArray removeObject:@"SecondDetailList"];
        [self updateAmDetailsTableView];
        [self updateAmAddDetailsView];
    }
    //更新采购项目
    if (self.FormDatas.bool_ThirDetailsShow) {
        [self.FormDatas.arr_UnShowmsArray removeObject:@"ThirdDetailList"];
        [self updateBuDetailsTableView];
        [self updateBuAddDetailsView];
    }
    //更新单一采购来源清单
    if (self.FormDatas.bool_FouDetailsShow) {
        [self updateViewPurSource];
//        [self updateSoDetailsTableView];
        [self.FormDatas.arr_UnShowmsArray removeObject:@"FourthDetailList"];
//        [self updateSoAddDetailsView];
    }
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    
    if (self.FormDatas.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    
    [self updateContentView];
    
    [self.FormDatas getEndShowArray];
}

//MARK:更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新单据可见范围
-(void)updateFormScopeWithModel:(MyProcurementModel *)model{
    
    for (STOnePickModel *pickModel in self.arr_FormScope) {
        if ([pickModel.Id isEqualToString: model.fieldValue]) {
            model.fieldValue = pickModel.Type;
        }
    }
    if (![NSString isEqualToNull:model.fieldValue]) {
        self.str_FormScopeCode = @"1";
        self.str_FormScopeType = Custing(@"相同成本中心内均可见", nil);
        self.FormDatas.str_FormScope = self.str_FormScopeCode;
        model.fieldValue = Custing(@"相同成本中心内均可见", nil);
    }
    _txf_FormScope=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_FormScope WithContent:_txf_FormScope WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc] init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![weakSelf.str_FormScopeCode isEqualToString:Model.Id]) {
                weakSelf.str_FormScopeCode = Model.Id;
                weakSelf.str_FormScopeType = Model.Type;
                self.FormDatas.str_FormScope = Model.Id;
                weakSelf.txf_FormScope.text = Model.Type;
            }
        }];
        picker.typeTitle = Custing(@"单据可见范围", nil);
        picker.DateSourceArray = weakSelf.arr_FormScope;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_FormScope addSubview:view];
}

//MARK:更新费用申请单视图
-(void)updateFeeAppFormViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_FeeAppNumber=[NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_FeeAppInfo=@"";
        self.FormDatas.str_FeeAppNumber=@"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo],
                           @"Model":model
                           };
    [_View_FeeAppForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_FeeAppForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf FeeFormClick];
    };
}
//MARK:修改费用申请单
-(void)FeeFormClick{
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId=self.FormDatas.str_FeeAppNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars=@{@"Type":@"2",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
        }
        
        weakSelf.FormDatas.str_FeeAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        NSString *feeAppNumStr = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        weakSelf.FormDatas.str_FeeAppNumber = feeAppNumStr;
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],
                               @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo]
                               };
        //将费用申请单的值赋于金额明细的每个字表里面（字段FeeAppNumber）
        for (DeatilsModel *amModel in weakSelf.FormDatas.arr_SecDetailsDataArray) {
            amModel.FeeAppNumber = feeAppNumStr;
        }
        [weakSelf.View_FeeAppForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:更新采购类型
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf TypeClick];
    }];
    [_View_Type addSubview:view];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_PurchaseType=model.fieldValue;
    }
}
//MARK:更新采购明细
-(void)updateDetailsTableView{
    [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_DetailsArray.count*42+27)*self.FormDatas.arr_DetailsDataArray.count));
    }];
    [_View_DetailsTable reloadData];
}
//MARK:更新采购增加按钮
-(void)updateAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_AddDetails withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf keyClose];
        DeatilsModel *model1=[[DeatilsModel alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
}
//MARK:更新采购项目明细及金额
- (void)updateAmDetailsTableView{
    if (self.FormDatas.arr_SecDetailsDataArray.count==0) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        model.No = @"1";
        [self.FormDatas.arr_SecDetailsDataArray addObject:model];
    }
    __weak typeof(self) weakSelf = self;
    [_View_purAmountTable updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.FormDatas.bool_SecHaveAttchs) {
            make.height.equalTo(@((self.FormDatas.arr_SecDetailsArray.count*42+76+27)*self.FormDatas.arr_SecDetailsDataArray.count));
        }else{
            make.height.equalTo(@((self.FormDatas.arr_SecDetailsArray.count*42+27)*self.FormDatas.arr_SecDetailsDataArray.count));
        }
    }];
    [_View_purAmountTable reloadData];
}
//MARK:更新采购项目明细及金额增加按钮
- (void)updateAmAddDetailsView{
    SubmitFormView *view = [[SubmitFormView alloc] initAddBtbWithBaseView:_View_AmAddDetails withTitle:Custing(@"增加采购项目明细及金额", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf keyClose];
        DeatilsModel *model2 = [[DeatilsModel alloc] init];
        [weakSelf.FormDatas.arr_SecDetailsDataArray addObject:model2];
        model2.No = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.FormDatas.arr_SecDetailsDataArray.count];
        [weakSelf updateAmDetailsTableView];
    }];
    [_View_AmAddDetails addSubview:view];
}
//MARK:更新采购项目
- (void)updateBuDetailsTableView{
    if (self.FormDatas.arr_ThirDetailsDataArray.count == 0) {
        DeatilsModel *model = [[DeatilsModel alloc]init];
        model.No = @"1";
        [self.FormDatas.arr_ThirDetailsDataArray addObject:model];
    }
    __weak typeof(self) weakSelf = self;
    [_View_purBusinessTable updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.FormDatas.bool_ThirdHaveAttchs) {
            make.height.equalTo(@((self.FormDatas.arr_ThirDetailsArray.count*42+76+27)*self.FormDatas.arr_ThirDetailsDataArray.count));
        }else{
            make.height.equalTo(@((self.FormDatas.arr_ThirDetailsArray.count*42+27)*self.FormDatas.arr_ThirDetailsDataArray.count));
        }
    }];
    [_View_purBusinessTable reloadData];
}
//MARK:更新采购项目增加按钮
- (void)updateBuAddDetailsView{
    SubmitFormView *view = [[SubmitFormView alloc] initAddBtbWithBaseView:_View_BuAddDetails withTitle:Custing(@"增加采购项目", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf keyClose];
        DeatilsModel *model3 = [[DeatilsModel alloc] init];
        [weakSelf.FormDatas.arr_ThirDetailsDataArray addObject:model3];
        model3.No = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.FormDatas.arr_ThirDetailsDataArray.count];
        [weakSelf updateBuDetailsTableView];
    }];
    [_View_BuAddDetails addSubview:view];
}
//MARK:更新单一采购来源显示项和tablefootview
- (void)updateViewPurSource{
    __weak typeof(self) weakSelf = self;
    SubmitFormView *view=[[SubmitFormView alloc]initWithBaseView:_View_soPurSource WithSwitch:[[UISwitch alloc]init] WithString:Custing(@"开启单一采购来源清单", nil) WithInfo:self.FormDatas.arr_FouDetailsDataArray.count WithTips:nil];
    [view.lab_title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110));
    }];
    view.viewClickedBackBlock = ^(id object) {
        if ([object floatValue] == 1) {
            DeatilsModel *model = [[DeatilsModel alloc] init];
            model.No = @"1";
            [weakSelf.FormDatas.arr_FouDetailsDataArray addObject:model];
        }else{
            [weakSelf.FormDatas.arr_FouDetailsDataArray removeAllObjects];
        }
        [weakSelf updateSoDetailsTableView];
    };
    [_View_soPurSource addSubview:view];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    footView.userInteractionEnabled = YES;
    
    UIButton *btns=[GPUtils createButton:CGRectZero action:@selector(addSoPurDetailClick:) delegate:self title:nil font:Font_Important_15_20 titleColor:Color_Blue_Important_20];
    [btns setImage:[UIImage imageNamed:@"commom_addDetails_Icon"] forState:UIControlStateNormal];
    [btns setImage:[UIImage imageNamed:@"commom_addDetails_Icon"] forState:UIControlStateSelected];
    CGSize size = [[NSString stringWithFormat:@" %@",Custing(@"增加单一采购来源清单", nil)] sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(1000, 50) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat titleWidth=size.width;
    CGFloat imageWidth = 15;
    CGFloat btnWidth = titleWidth + imageWidth + 20;
    [btns setTitle:[NSString stringWithFormat:@" %@",Custing(@"增加单一采购来源清单", nil)] forState:UIControlStateNormal];
    [btns setTitle:[NSString stringWithFormat:@" %@",Custing(@"增加单一采购来源清单", nil)] forState:UIControlStateSelected];
    btns.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    btns.frame = CGRectMake(Main_Screen_Width - 12-btnWidth, 0, btnWidth, 50);
    [footView addSubview:btns];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 1)];
    lineView.backgroundColor=Color_White_Same_20;
    [footView addSubview:lineView];
    _View_purSourceTable.tableFooterView = footView;
}
- (void)addSoPurDetailClick:(UIButton *)sender{
    [self keyClose];
    DeatilsModel *model4 = [[DeatilsModel alloc] init];
    [self.FormDatas.arr_FouDetailsDataArray addObject:model4];
    model4.No = [NSString stringWithFormat:@"%lu",(unsigned long)self.FormDatas.arr_FouDetailsDataArray.count];
    [self updateSoDetailsTableView];
}
//MARK:更新单一采购来源清单
- (void)updateSoDetailsTableView{
    __weak typeof(self) weakSelf = self;
    [_View_purSourceTable mas_updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.FormDatas.arr_FouDetailsDataArray.count > 0) {
            if (weakSelf.FormDatas.bool_FourthHaveAttchs) {
                make.height.equalTo(@((self.FormDatas.arr_FouDetailsArray.count*42+76+27)*self.FormDatas.arr_FouDetailsDataArray.count+50));
            }else{
                make.height.equalTo(@((self.FormDatas.arr_FouDetailsArray.count*42+27)*self.FormDatas.arr_FouDetailsDataArray.count+50));
            }
        }else{
            make.height.equalTo(@0);
        }
        
    }];
    [_View_purSourceTable reloadData];
}

//MARK:更新采购支付方式
-(void)updatePayWayViewWithModel:(MyProcurementModel *)model{
    _txf_PayWay=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PayWay WithContent:_txf_PayWay WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf PayWayClick];
    }];
    [_View_PayWay addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_PayMode=model.fieldValue;
    }
}
//MARK:更新交付日期
-(void)updatePayDateViewWithModel:(MyProcurementModel *)model{
    _txf_PayDate=[[UITextField alloc]init];
    
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        model.fieldValue=currStr;
    }
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_PayDate WithContent:_txf_PayDate WithFormType:formViewSelectDate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_PayDate addSubview:view];
}
//MARK:更新采购合计金额
-(void)updateTotalMoneyViewWithModel:(MyProcurementModel *)model{
    _txf_TotalMoney=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalMoney WithContent:_txf_TotalMoney WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalMoney addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_TotalMoney=model.fieldValue;
    }
}
//MARK:更新金额大写视图
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Capitalized=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Capitalized WithContent:_txf_Capitalized WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
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

//MARK:更新报销政策视图
-(void)updateReimPolicyView{
    __weak typeof(self) weakSelf = self;
    ReimPolicyView *view=[[ReimPolicyView alloc]initWithFlowCode:self.FormDatas.str_flowCode withBodydict:self.FormDatas.dict_ReimPolicyDict withBaseViewHeight:^(NSInteger height, NSDictionary *date) {
        if ([date[@"location"]floatValue]==1) {
            [weakSelf.ReimPolicyDownView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }else{
            [weakSelf.ReimPolicyUpView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }
    }];
    view.clickBlock = ^(NSString *bodyUrl) {
        PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
        pdf.url =bodyUrl;
        [self.navigationController pushViewController:pdf animated:YES];
    };
    if ([self.FormDatas.dict_ReimPolicyDict[@"location"]floatValue]==1) {
        [_ReimPolicyDownView addSubview:view];
    }else{
        [_ReimPolicyUpView addSubview:view];
    }
}

//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:采购类型选择
-(void)TypeClick{
    NSLog(@"采购类型选择");
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"purchaseType"];
    choose.ChooseCategoryArray = self.FormDatas.arr_procureType;
    choose.ChooseCategoryId = self.FormDatas.str_PurchaseCode;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        if (array) {
            ChooseCategoryModel *model = array[0];
            weakSelf.FormDatas.str_PurchaseCode = [NSString stringWithFormat:@"%@",model.purchaseCode];
            weakSelf.FormDatas.str_PurchaseType = [NSString stringWithFormat:@"%@",model.purchaseType];
            weakSelf.txf_Type.text = [NSString stringWithFormat:@"%@",model.purchaseType];
        }else{
            weakSelf.FormDatas.str_PurchaseCode = @"";
            weakSelf.FormDatas.str_PurchaseType = @"";
            weakSelf.txf_Type.text = @"";
        }
    };
    [self.navigationController pushViewController:choose animated:YES];
}

//MARK:选择支付方式
-(void)PayWayClick{
    NSLog(@"选择支付方式");
    [self keyClose];
    ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"payWay"];
    choose.ChooseCategoryArray=self.FormDatas.arr_payWay;
    choose.ChooseCategoryId=self.FormDatas.str_PayCode;
    __weak typeof(self) weakSelf = self;
    choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        if (array) {
            ChooseCategoryModel *model = array[0];
            weakSelf.FormDatas.str_PayCode=[NSString stringWithFormat:@"%@",model.payCode];
            weakSelf.FormDatas.str_PayMode=[NSString stringWithFormat:@"%@",model.payMode];
            weakSelf.txf_PayWay.text=[NSString stringWithFormat:@"%@",model.payMode];
        }else{
            weakSelf.FormDatas.str_PayCode=@"";
            weakSelf.FormDatas.str_PayMode=@"";
            weakSelf.txf_PayWay.text=@"";
        } 
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
    contactVC.itemType =5;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.FormDatas.arr_DetailsDataArray.count;
    if (tableView == _View_DetailsTable) {
        return self.FormDatas.arr_DetailsDataArray.count;
    }else if(tableView == _View_purAmountTable){
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }else if (tableView == _View_purBusinessTable){
        return  self.FormDatas.arr_ThirDetailsDataArray.count;
    }else if (tableView == _View_purSourceTable){
        return self.FormDatas.arr_FouDetailsDataArray.count;
    }
    return 0;
}
// 返回参数2指定分组的行数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.FormDatas.arr_DetailsArray.count;
    if (tableView == _View_DetailsTable) {
        return self.FormDatas.arr_DetailsArray.count;
    }else if(tableView == _View_purAmountTable){
        return self.FormDatas.arr_SecDetailsArray.count;
    }else if (tableView == _View_purBusinessTable){
        return self.FormDatas.arr_ThirDetailsArray.count;
    }else if (tableView == _View_purSourceTable){
        return self.FormDatas.arr_FouDetailsArray.count;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 42;
    if (tableView == _View_purBusinessTable) {
        MyProcurementModel *model = self.FormDatas.arr_ThirDetailsArray[indexPath.row];
        if ([model.fieldName isEqualToString:@"Attachments"]) {
            return 118;
        }
    }else if (tableView == _View_purSourceTable){
        MyProcurementModel *model = self.FormDatas.arr_FouDetailsArray[indexPath.row];
        if ([model.fieldName isEqualToString:@"Attachments"]) {
            return 118;
        }
    }else if (tableView == _View_purAmountTable){
        MyProcurementModel *model = self.FormDatas.arr_SecDetailsArray[indexPath.row];
        if ([model.fieldName isEqualToString:@"Attachments"]) {
            return 118;
        }
    }
    return 42;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _View_DetailsTable) {
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        [cell configCellWithModel:self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
        
        cell.IndexPath=indexPath;
        [cell.NameTextField addTarget:self action:@selector(NametextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.NameTextField.tag=100+indexPath.section;
        cell.NameTextField.delegate = self;
        if (cell.NameBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setNameCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                DeatilsModel *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    DeatilsModel *modelD=[[DeatilsModel alloc]init];
                    [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
                }
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"PurchaseItems"];
                vc.ChooseCategoryId=modelD.ItemId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    modelD.ItemId = model.purId;
                    modelD.ItemCatId = model.purItemCatId;
                    modelD.ItemCatName = model.purItemCatName;
                    modelD.Size = model.purSize;
                    modelD.Name = [GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];
                    modelD.Brand=model.purBrand;
                    modelD.Unit = model.purUnit;
                    modelD.Code = model.purCode;
                    [weakSelf.View_DetailsTable reloadData];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
        [cell.BrandTextField addTarget:self action:@selector(BrandtextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.BrandTextField.tag=100+indexPath.section;
        cell.BrandTextField.delegate = self;

        [cell.SizeTextField addTarget:self action:@selector(SizetextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.SizeTextField.tag=100+indexPath.section;
        cell.SizeTextField.delegate = self;
        
        [cell.QtyTextField addTarget:self action:@selector(QtytextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.QtyTextField.tag=10000+indexPath.section;
        cell.QtyTextField.delegate = self;
        
        [cell.UnitTextField addTarget:self action:@selector(UnittextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.UnitTextField.tag=1+indexPath.section;
        cell.UnitTextField.delegate = self;
        
        [cell.AmountTF addTarget:self action:@selector(AmounttextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag=160+indexPath.section;
        cell.AmountTF.delegate = self;

        [cell.PriceTextField addTarget:self action:@selector(PricetextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.PriceTextField.tag=1000+indexPath.section;
        cell.PriceTextField.delegate = self;
        
        [cell.RemarkTextField addTarget:self action:@selector(RemarkxtChange:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarkTextField.tag=100+indexPath.section;
        cell.RemarkTextField.delegate = self;
        
        if (cell.SupplierBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                DeatilsModel *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    DeatilsModel *modelD=[[DeatilsModel alloc]init];
                    [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
                }
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
                vc.ChooseCategoryId=modelD.SupplierId;
                vc.dict_otherPars = @{@"DateType":self.FormDatas.str_SupplierParam};
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    modelD.SupplierId = model.Id;
                    modelD.SupplierName=[GPUtils getSelectResultWithArray:@[model.code,model.name]];
                    tf.text =modelD.SupplierName;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
        if (cell.ExpenseTypeBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                DeatilsModel *modelD=[weakSelf.FormDatas.arr_DetailsDataArray objectAtIndex:index.section];
                if (!modelD) {
                    DeatilsModel *modelD=[[DeatilsModel alloc]init];
                    [weakSelf.FormDatas.arr_DetailsDataArray insertObject:modelD atIndex:index.section];
                }
                ChooseCategoryController *vc = [[ChooseCategoryController alloc]initWithType:@"purchaseType"];
                vc.ChooseCategoryArray = self.FormDatas.arr_procureType;
                vc.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    if (array) {
                        ChooseCategoryModel *model = array[0];
                        modelD.PurchaseType = [NSString stringWithFormat:@"%@",model.purchaseType];
                        tf.text =modelD.PurchaseType;
                    }else{
                        modelD.PurchaseType = @"";
                        tf.text =modelD.PurchaseType;
                    }
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
        return cell;
    }else if (tableView == _View_purAmountTable){
        DeatilsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"purAmountViewCell"];
        if (cell == nil) {
            cell = [[DeatilsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"purAmountViewCell"];
        }
        [cell configCellWithModel:self.FormDatas.arr_SecDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_SecDetailsArray.count WithIndex:indexPath.row];
//        cell.IndexPath = indexPath;
        //序号
        [cell.NoTextField addTarget:self action:@selector(AmNoTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.NoTextField.tag = 100+indexPath.section;
        cell.NoTextField.delegate = self;
        //采购项目名称
        [cell.DescTextField addTarget:self action:@selector(AmDescriptionTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.DescTextField.tag = 100+indexPath.section;
        cell.DescTextField.delegate = self;
        //汇率
        [cell.ExRTextField addTarget:self action:@selector(AmExRateTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.ExRTextField.tag = 100+indexPath.section;
        cell.ExRTextField.delegate = self;
        //金额
        [cell.AmountTF addTarget:self action:@selector(AmAmountTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag = 100+indexPath.section;
        cell.AmountTF.delegate = self;
        //本位币金额
        [cell.LocTextField addTarget:self action:@selector(AmLocalAmoTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.LocTextField.tag = 100 + indexPath.section;
        cell.LocTextField.delegate = self;
        //备注
        [cell.RemarksTextField addTarget:self action:@selector(AmRemarkTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarksTextField.tag = 100+indexPath.section;
        cell.RemarksTextField.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        //币种
        if (cell.CurrentCTF) {
            [cell setCellClickedBlock:^(NSIndexPath *index, UITextField *tf) {
                STOnePickView *picker = [[STOnePickView alloc]init];
                [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
//                    tf.text = Model.Type;
                    DeatilsModel *deaModel = [weakSelf.FormDatas.arr_SecDetailsDataArray objectAtIndex:indexPath.section];
                    if (!deaModel) {
                        DeatilsModel *deaModel = [[DeatilsModel alloc] init];
                        [self.FormDatas.arr_SecDetailsDataArray insertObject:deaModel atIndex:indexPath.section];
                    }
                    deaModel.CurrencyCode = Model.Type;
                    deaModel.ExchangeRate = Model.exchangeRate;
                    deaModel.LocalCyAmount = [GPUtils decimalNumberMultipWithString:deaModel.Amount with:Model.exchangeRate];
                    [weakSelf.View_purAmountTable reloadData];
                }];
                picker.typeTitle = Custing(@"币种", nil);
                picker.DateSourceArray = weakSelf.FormDatas.arr_CurrencyCode;
                STOnePickModel *model = [[STOnePickModel alloc] init];
                model.Id = [NSString isEqualToNull:weakSelf.FormDatas.str_CurrencyCode]?weakSelf.FormDatas.str_CurrencyCode:@"";
                picker.Model = model;
                [picker UpdatePickUI];
                [picker setContentMode:STPickerContentModeBottom];
                [picker show];
            }];
        }
        //费用类别
        [cell.ExpenseCBtn addTarget:self action:@selector(AmCateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.ExpenseCBtn.tag = 100+indexPath.section;
        //关联费用申请
        [cell.FeeAppNumBtn addTarget:self action:@selector(AmFeeAppNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.FeeAppNumBtn.tag = 100+indexPath.section;
        
        return cell;
    }else if (tableView == _View_purBusinessTable){//采购项目
        DeatilsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"purBuinessViewCell"];
        if (cell == nil) {
            cell = [[DeatilsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"purBuinessViewCell"];
        }
        [cell configCellWithModel:self.FormDatas.arr_ThirDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_ThirDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_ThirDetailsArray.count WithIndex:indexPath.row];
        //序号
        [cell.NoTextField addTarget:self action:@selector(BuNoTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.NoTextField.tag = 100 + indexPath.section;
        cell.NoTextField.delegate = self;
        //采购项目描述
        [cell.DescTextField addTarget:self action:@selector(BuDescriptionTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.DescTextField.tag = 100 + indexPath.section;
        cell.DescTextField.delegate = self;
        //具体功能/业务需求
        [cell.BusTextField addTarget:self action:@selector(BuBusinessRequirementTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.BusTextField.tag = 100 + indexPath.section;
        cell.BusTextField.delegate = self;
        //具体技能要求
        [cell.TecTextField addTarget:self action:@selector(BuTechRequirementTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.TecTextField.tag = 100 + indexPath.section;
        cell.TecTextField.delegate = self;
        //服务需求及其他
        [cell.SerTextField addTarget:self action:@selector(BuServiceReuirementTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.SerTextField.tag = 100 + indexPath.section;
        cell.SerTextField.delegate = self;
        //附件
        //备注
        [cell.RemarksTextField addTarget:self action:@selector(BuRemarkTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarksTextField.tag = 100+indexPath.section;
        cell.RemarksTextField.delegate = self;
        return cell;
    }else if (tableView == _View_purSourceTable){//单一采购来源说明
        DeatilsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"purSourseViewCell"];
        if (cell == nil) {
            cell = [[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"purSourseViewCell"];
        }
        [cell configCellWithModel:self.FormDatas.arr_FouDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_FouDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_FouDetailsArray.count WithIndex:indexPath.row];
        //序号
        [cell.NoTextField addTarget:self action:@selector(SoNoTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.NoTextField.tag = 100 + indexPath.section;
        cell.NoTextField.delegate = self;
        //采购项目名称
        [cell.DescTextField addTarget:self action:@selector(SoDescriptionTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.DescTextField.tag = 100 + indexPath.section;
        cell.DescTextField.delegate = self;
        //供应商
        [cell.SupplierTextField addTarget:self action:@selector(SoSupplierNameTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.SupplierTextField.tag = 100 + indexPath.section;
        cell.SupplierTextField.delegate = self;
        //申请单一来源原因
        [cell.ReaTextField addTarget:self action:@selector(SoReasonTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.ReaTextField.tag = 100 + indexPath.section;
        cell.ReaTextField.delegate = self;
        //是否跨部门
        [cell.IsCrossDepmBtn addTarget:self action:@selector(SoIsCrossDepmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.IsCrossDepmBtn.tag = 100 + indexPath.section;
        //附件
        //备注
        [cell.RemarksTextField addTarget:self action:@selector(SoRemarkTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarksTextField.tag = 100+indexPath.section;
        cell.RemarksTextField.delegate = self;
        
        
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _View_DetailsTable) {
        [self createHeadViewWithSection:section];
        return _View_head;
    }else if (tableView == _View_purAmountTable){
        [self CreateAmHeadViewWithSection:section];
        return _View_AmHead;
    }else if (tableView == _View_purBusinessTable){
        [self CreateBuHeadViewWithSection:section];
        return _View_BuHead;
    }else if (tableView == _View_purSourceTable){
        [self CreateSoHeadViewWithSection:section];
        return _View_SoHead;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}
//MARK:-textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ((textField.tag>=1000&&textField.tag<=1051)||(textField.tag>=160&&textField.tag<=210))  //判断是否时我们想要限定的那个输入框
    {
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
        
    }else if (textField.tag>=10000&&textField.tag<=10051){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        //        if ((match == 1||[string isEqualToString:@""])&&self.ExchangeChangedBlock) {
        //            self.ExchangeChangedBlock(toBeString);
        //        }
        return match!= 0;
    }else if (textField.tag>=1&&textField.tag<=51){
        if ([toBeString length] >10) { //如果输入框内容大于12
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
    }else if (textField.tag>=100&&textField.tag<=150){
        if ([toBeString length] >255) {
            textField.text = [toBeString substringToIndex:255];
            return NO;
        }
    }
    return YES;
}

#pragma mar-创建tableView头视图
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
    
    UILabel *lab_select=[GPUtils createLable:CGRectMake(Main_Screen_Width-12-150, 0, 150, 27) text:Custing(@"选择采购申请模板", nil) font:Font_Same_14_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
    __weak typeof(self) weakSelf = self;
    [lab_select bk_whenTapped:^{
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"PurchaseItemTpls"];
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            if (weakSelf.FormDatas.arr_DetailsDataArray.count==1) {
                DeatilsModel *model=weakSelf.FormDatas.arr_DetailsDataArray[0];
                if (model.Name==nil&&model.Size==nil&&model.Unit==nil&&model.Price==nil) {
                    [weakSelf.FormDatas.arr_DetailsDataArray removeAllObjects];
                }
            }
            for (ChooseCateFreModel *model in array) {
                DeatilsModel *modelD=[[DeatilsModel alloc]init];
                modelD.ItemId = model.purId;
                modelD.ItemCatId = model.purItemCatId;
                modelD.ItemCatName = model.purItemCatName;
                modelD.Size = model.purSize;
                modelD.Name = [GPUtils getSelectResultWithArray:@[model.purCode,model.purName]];
                modelD.Brand=model.purBrand;
                modelD.Unit = model.purUnit;
                modelD.TplId=model.purTplId;
                modelD.TplName=model.purTplName;
                modelD.Code=model.purCode;
                [weakSelf.FormDatas.arr_DetailsDataArray addObject:modelD];
            }
            [weakSelf updateDetailsTableView];
            [weakSelf.View_DetailsTable reloadData];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    lab_select.userInteractionEnabled=YES;
    lab_select.hidden=YES;
    [_View_head addSubview:lab_select];
    
    if (self.FormDatas.arr_DetailsDataArray.count==1) {
        titleLabel.text=Custing(@"采购明细", nil);
        if (self.FormDatas.bool_PurchaseTpl) {
            lab_select.hidden=NO;
        }
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"采购明细", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_View_head addSubview:deleteBtn];
        }else{
            if (self.FormDatas.bool_PurchaseTpl) {
                lab_select.hidden=NO;
            }
        }
    }
    _View_head.backgroundColor=Color_White_Same_20;
}

//MARK:采购明细详情填写
-(void)NametextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Name=text.text;
    }else{
        model.Name=text.text;
    }
}
-(void)BrandtextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Brand=text.text;
    }else{
        model.Brand=text.text;
    }
}
-(void)SizetextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Size=text.text;
    }else{
        model.Size=text.text;
    }
}
-(void)QtytextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-10000];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-10000];
        model.Qty=text.text;
    }else{
        model.Qty=text.text;
    }
    model.Price=[GPUtils decimalNumberMultipWithString:model.Qty with:model.Amount];
    [self.FormDatas getTotolAmount];
    [self.View_DetailsTable reloadData];
    NSInteger j=0;
    for (int i=0; i<self.FormDatas.arr_DetailsArray.count; i++) {
        MyProcurementModel *model=self.FormDatas.arr_DetailsArray[i];
        if ([model.fieldName isEqualToString:@"Qty"]) {
            j=i;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:text.tag-10000];
    DeatilsViewCell *cell = [self.View_DetailsTable cellForRowAtIndexPath:indexPath];
    [cell.QtyTextField becomeFirstResponder];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
    self.txf_Capitalized.text=[NSString getChineseMoneyByString:self.FormDatas.str_TotalMoney];

}
-(void)UnittextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1];
        model.Unit=text.text;
    }else{
        model.Unit=text.text;
    }
}
-(void)AmounttextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-160];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-160];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
    model.Price=[GPUtils decimalNumberMultipWithString:model.Qty with:model.Amount];
    [self.FormDatas getTotolAmount];
    [self.View_DetailsTable reloadData];
    NSInteger j=0;
    for (int i=0; i<self.FormDatas.arr_DetailsArray.count; i++) {
        MyProcurementModel *model=self.FormDatas.arr_DetailsArray[i];
        if ([model.fieldName isEqualToString:@"Amount"]) {
            j=i;
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:text.tag-160];
    DeatilsViewCell *cell = [self.View_DetailsTable cellForRowAtIndexPath:indexPath];
    [cell.AmountTF becomeFirstResponder];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
    self.txf_Capitalized.text=[NSString getChineseMoneyByString:self.FormDatas.str_TotalMoney];
    

}
-(void)PricetextChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Price=text.text;
    }else{
        model.Price=text.text;
    }
    [self.FormDatas getTotolAmount];
    _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
    self.txf_Capitalized.text=[NSString getChineseMoneyByString:self.FormDatas.str_TotalMoney];
}
-(void)RemarkxtChange:(UITextField *)text{
    DeatilsModel *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        DeatilsModel *model=[[DeatilsModel alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Remark=text.text;
    }else{
        model.Remark=text.text;
    }
}

//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    
    [self keyClose];
    NSLog(@"删除明细");
    _Aler_deleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除采购明细", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    _Aler_deleteDetils.tag=btn.tag-1200;
    [_Aler_deleteDetils show];
    
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView==_Aler_deleteDetils) {
            [self.FormDatas.arr_DetailsDataArray removeObjectAtIndex:alertView.tag];
            [self.FormDatas getTotolAmount];
            [self.View_DetailsTable reloadData];
            _txf_TotalMoney.text=[GPUtils transformNsNumber:self.FormDatas.str_TotalMoney];
            self.txf_Capitalized.text=[NSString getChineseMoneyByString:self.FormDatas.str_TotalMoney];
            [self updateDetailsTableView];
        }
    }
}
#pragma mark 创建View_purAmountTable头试图
- (void)CreateAmHeadViewWithSection:(NSInteger)section{
    _View_AmHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    imgView.image = [UIImage imageNamed:@"Work_HeadBlue"];
    imgView.backgroundColor = Color_Blue_Important_20;
    [_View_AmHead addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center = CGPointMake(X(imgView)+WIDTH(imgView)+90+8, 13.5);
    titleLabel.font = Font_Important_15_20;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = Color_Unsel_TitleColor;
    [_View_AmHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_SecDetailsDataArray.count == 1) {
        titleLabel.text = Custing(@"采购项目明细及金额", nil);
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Custing(@"采购项目明细及金额", nil),(long)section+1];
        if (section != 0) {
            UIButton *deleteBtn = [GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(AmDeleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center = CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag = 100 + section;
            [_View_AmHead addSubview:deleteBtn];
        }
    }
    _View_AmHead.backgroundColor = Color_White_Same_20;
}

//MARK:采购项目明细及金额填写
- (void)AmNoTextChanged:(UITextField *)txf{//序号
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.No = txf.text;
    }else{
        model.No = txf.text;
    }
}
- (void)AmDescriptionTextChanged:(UITextField *)txf{//采购项目名称
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Description = txf.text;
    }else{
        model.Description = txf.text;
    }
}
- (void)AmExRateTextChanged:(UITextField *)txf{//汇率
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.ExchangeRate = txf.text;
    }else{
        model.ExchangeRate = txf.text;
    }
    model.LocalCyAmount = [GPUtils decimalNumberMultipWithString:model.Amount with:model.ExchangeRate];
//    [self.View_purAmountTable reloadData];
}
- (void)AmAmountTextChanged:(UITextField *)txf{//金额
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Amount = txf.text;
    }else{
        model.Amount = txf.text;
    }
    model.LocalCyAmount = [GPUtils decimalNumberMultipWithString:model.Amount with:model.ExchangeRate];
//    [self.View_purAmountTable reloadData];
}
- (void)AmLocalAmoTextChanged:(UITextField *)txf{//本位币
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.LocalCyAmount = txf.text;
    }else{
        model.LocalCyAmount = txf.text;
    }
}
- (void)AmRemarkTextChanged:(UITextField *)txf{
    
    DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Remarks = txf.text;
    }else{
        model.Remarks = txf.text;
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.View_purAmountTable reloadData];
}


//费用类别选择按钮
- (void)AmCateBtnClick:(UIButton *)btn{
    [self keyClose];
    STPickerCategory *pickerArea = [[STPickerCategory alloc] init];
    pickerArea.typeTitle = Custing(@"费用类别", nil);
    pickerArea.DateSourceArray = [NSMutableArray arrayWithArray:self.FormDatas.arr_CategoryArr];
    CostCateNewSubModel *model = [[CostCateNewSubModel alloc] init];
    DeatilsModel *deatilM = self.FormDatas.arr_SecDetailsDataArray[btn.tag - 100];
    model.expenseCode = deatilM.ExpenseCode;
    pickerArea.CateModel = model;
    [pickerArea UpdatePickUI];
    [pickerArea setContentMode:STPickerContentModeBottom];
    pickerArea.str_flowCode = @"F0023";
    __weak typeof(self) weakSelf = self;
    [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
        deatilM.ExpenseCode = secondModel.expenseCode;
        deatilM.ExpenseCat = secondModel.expenseCat;
        deatilM.ExpenseType = secondModel.expenseType;
        deatilM.ExpenseIcon = secondModel.expenseIcon;
        deatilM.ExpenseCatCode = secondModel.expenseCatCode;
        [weakSelf.View_purAmountTable reloadData];
    }];
    [pickerArea show];
}
//关联费用申请
- (void)AmFeeAppNumBtnClick:(UIButton *)btn{
    [self keyClose];
    DeatilsModel *deatilM = self.FormDatas.arr_SecDetailsDataArray[btn.tag - 100];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc] initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId = self.FormDatas.str_FeeAppNumber;
    vc.isMultiSelect = YES;
    vc.dict_otherPars = @{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:model.taskId];
        }
        deatilM.str_FeeAppInfo = [GPUtils getSelectResultWithArray:array WithCompare:@"⊕"];
        deatilM.str_FeeAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        deatilM.FeeAppNumber = deatilM.str_FeeAppInfo;
        [weakSelf.View_purAmountTable reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//删除金额明细
- (void)AmDeleteDetails:(UIButton *)btn{
    [self keyClose];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除采购项目明细及金额", nil),(long)(btn.tag - 99)] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:Custing(@"删除", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.FormDatas.arr_SecDetailsDataArray removeObjectAtIndex:btn.tag - 100];
        [weakSelf updateAmDetailsTableView];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Custing(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:deleteAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark 创建View_purBusinessTable头试图
- (void)CreateBuHeadViewWithSection:(NSInteger)section{
    _View_BuHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    imgView.image = [UIImage imageNamed:@"Work_HeadBlue"];
    imgView.backgroundColor = Color_Blue_Important_20;
    [_View_BuHead addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center = CGPointMake(X(imgView)+WIDTH(imgView)+90+8, 13.5);
    titleLabel.font = Font_Important_15_20;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = Color_Unsel_TitleColor;
    [_View_BuHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_ThirDetailsDataArray.count == 1) {
        titleLabel.text = Custing(@"采购项目", nil);
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Custing(@"采购项目", nil),(long)section+1];
        if (section != 0) {
            UIButton *deleteBtn = [GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(BuDeleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center = CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag = 100 + section;
            [_View_BuHead addSubview:deleteBtn];
        }
    }
    _View_BuHead.backgroundColor = Color_White_Same_20;
}

//MARK:采购项目填写
- (void)BuNoTextChanged:(UITextField *)txf{//序号
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.No = txf.text;
    }else{
        model.No = txf.text;
    }
}
- (void)BuDescriptionTextChanged:(UITextField *)txf{//采购项目描述
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Description = txf.text;
    }else{
        model.Description = txf.text;
    }
}
- (void)BuBusinessRequirementTextChanged:(UITextField *)txf{//具体功能/业务描述
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.BusinessRequirement = txf.text;
    }else{
        model.BusinessRequirement = txf.text;
    }
}
- (void)BuTechRequirementTextChanged:(UITextField *)txf{//具体技能要求
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.TechRequirement = txf.text;
    }else{
        model.TechRequirement = txf.text;
    }
}
- (void)BuServiceReuirementTextChanged:(UITextField *)txf{//服务需求及其他
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.ServiceRequirement = txf.text;
    }else{
        model.ServiceRequirement = txf.text;
    }
}
- (void)BuRemarkTextChanged:(UITextField *)txf{
    
    DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Remarks = txf.text;
    }else{
        model.Remarks = txf.text;
        NSLog(@"remarks : %@",model.Remarks);
    }
}
//删除内容明细
- (void)BuDeleteDetails:(UIButton *)btn{
    [self keyClose];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除采购项目", nil),(long)(btn.tag - 99)] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:Custing(@"删除", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.FormDatas.arr_ThirDetailsDataArray removeObjectAtIndex:btn.tag - 100];
        [weakSelf updateBuDetailsTableView];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Custing(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:deleteAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark 创建View_purSourceTable头试图
- (void)CreateSoHeadViewWithSection:(NSInteger)section{
    _View_SoHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    imgView.image = [UIImage imageNamed:@"Work_HeadBlue"];
    imgView.backgroundColor = Color_Blue_Important_20;
    [_View_SoHead addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center = CGPointMake(X(imgView)+WIDTH(imgView)+90+8, 13.5);
    titleLabel.font = Font_Important_15_20;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = Color_Unsel_TitleColor;
    [_View_SoHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_FouDetailsDataArray.count == 1) {
        titleLabel.text = Custing(@"单一采购来源清单", nil);
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",Custing(@"单一采购来源清单", nil),(long)section+1];
        if (section != 0) {
            UIButton *deleteBtn = [GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(SoDeleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center = CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag = 100 + section;
            [_View_SoHead addSubview:deleteBtn];
        }
    }
    _View_SoHead.backgroundColor = Color_White_Same_20;
}

//MARK:单一采购来源清单明细
- (void)SoNoTextChanged:(UITextField *)txf{//序号
    DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_FouDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.No = txf.text;
    }else{
        model.No = txf.text;
    }
}
- (void)SoDescriptionTextChanged:(UITextField *)txf{//采购项目名称
    DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_FouDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Description = txf.text;
    }else{
        model.Description = txf.text;
    }
}
- (void)SoSupplierNameTextChanged:(UITextField *)txf{//供应商
    DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_FouDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.SupplierName = txf.text;
    }else{
        model.SupplierName = txf.text;
    }
}
- (void)SoReasonTextChanged:(UITextField *)txf{//申请单一来源说明
    DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_FouDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Reason = txf.text;
    }else{
        model.Reason = txf.text;
    }
}
- (void)SoIsCrossDepmBtnClicked:(UIButton *)btn{//是否跨部门
    DeatilsModel *deatilModel = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:btn.tag - 100];
    __weak typeof(self) weakSelf = self;
    STOnePickView *picker = [[STOnePickView alloc] init];
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
//        deatilModel.str_IsCrossDepartment = Model.Type;
        deatilModel.IsCrossDepartment = Model.Id;
        [weakSelf.View_purSourceTable reloadData];
    }];
    picker.typeTitle = @"是否跨部门";
    picker.DateSourceArray = self.arr_IsCrossD;
//    STOnePickModel *model1 = [[STOnePickModel alloc] init];
//    model1.Id = [NSString ];
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
- (void)SoRemarkTextChanged:(UITextField *)txf{
    
    DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:txf.tag - 100];
    if (!model) {
        DeatilsModel *model = [[DeatilsModel alloc] init];
        [self.FormDatas.arr_FouDetailsDataArray insertObject:model atIndex:txf.tag - 100];
        model.Remarks = txf.text;
    }else{
        model.Remarks = txf.text;
    }
}
//删除单一采购来源清单
- (void)SoDeleteDetails:(UIButton *)btn{
    [self keyClose];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除单一采购来源清单", nil),(long)(btn.tag-99)] preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:Custing(@"删除", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.FormDatas.arr_FouDetailsDataArray removeObjectAtIndex:btn.tag - 100];
        [weakSelf updateSoDetailsTableView];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Custing(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:deleteAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
//MARK:保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"采购保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
    
}
//MARK:提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"采购提交操作");
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
    if (self.FormDatas.int_SubmitSaveType==2||self.FormDatas.int_SubmitSaveType==3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }
    }
//    [self.FormDatas contectData];
//    [self dealWithImagesArray];
    NSInteger thirdArrCount = self.FormDatas.arr_ThirDetailsDataArray.count;
    NSInteger secondArrCount = self.FormDatas.arr_SecDetailsDataArray.count;
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;
//    上传采购项目和单一采购来源清单图片
    if (thirdArrCount > 0) {
        [self uploadBuThirdArrWithIndex:0];
    }else if (secondArrCount>0) {
        [self uploadAmSecondArrWithIndex:0];
    }else if (fourthArrCount>0) {
        [self uploadSoFourthArrWithIndex:0];
    }else{
        //拼接字表数据
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }
}
//上传采购项目图片
- (void)uploadBuThirdArrWithIndex:(NSInteger)index{
       NSInteger thirdArrCount = self.FormDatas.arr_ThirDetailsDataArray.count;
       NSInteger secondArrCount = self.FormDatas.arr_SecDetailsDataArray.count;
       NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;

    for (NSInteger i = index; i < thirdArrCount; i ++) {
        DeatilsModel *model = [self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:i];
        if (model.arr_FilesTotal.count > 0) {
           [self dealWithBuImagesArray:model.arr_FilesTotal withIndexThird:i];
            break;
        }else{
            //没有图片时
            model.Attachments = @"";
            //上传单一采购来源清单图片
            if (i == thirdArrCount - 1) {
                if (secondArrCount>0) {
                    [self uploadAmSecondArrWithIndex:0];
                }else if (fourthArrCount>0) {
                    [self uploadSoFourthArrWithIndex:0];
                }else{
                    //拼接字表数据
                    [self.FormDatas contectData];
                    [self dealWithImagesArray];
                }
            }
        }
    }
}
//上传采购项目明细及金额图片
- (void)uploadAmSecondArrWithIndex:(NSInteger)index{
    NSInteger secondArrCount = self.FormDatas.arr_SecDetailsDataArray.count;
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;

    for (NSInteger i = index; i < secondArrCount; i ++) {
        DeatilsModel *model = [self.FormDatas.arr_SecDetailsDataArray objectAtIndex:i];
        if (model.arr_FilesTotal.count > 0) {
           [self dealWithAmImagesArray:model.arr_FilesTotal withIndexSecond:i];
            break;
        }else{
            //没有图片时
            model.Attachments = @"";
            //上传单一采购来源清单图片
            if (i == secondArrCount - 1) {
                if (fourthArrCount>0) {
                    [self uploadSoFourthArrWithIndex:0];
                }else{
                    //拼接字表数据
                    [self.FormDatas contectData];
                    [self dealWithImagesArray];
                }
            }
        }
    }
}
//上传单一采购来源清单图片
- (void)uploadSoFourthArrWithIndex:(NSInteger)index{
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;
    for (NSInteger i = index; i < fourthArrCount; i ++) {
        DeatilsModel *model = [self.FormDatas.arr_FouDetailsDataArray objectAtIndex:i];
        if (model.arr_FilesTotal.count > 0) {
            [self dealWithSoImagesArray:model.arr_FilesTotal withIndexFourth:i];
            break;
        }else{
            //没有图片时
            model.Attachments = @"";
            //上传采购申请图片
            if (i == fourthArrCount - 1) {
                [self.FormDatas contectData];
                [self dealWithImagesArray];
            }
        }
    }
}
-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason = _txv_Reason.text;
    self.FormDatas.SubmitData.DeliveryDate = _txf_PayDate.text;
    self.FormDatas.SubmitData.CapitalizedAmount = [NSString getChineseMoneyByString:self.FormDatas.str_TotalMoney];
    self.FormDatas.SubmitData.Remark = _txv_Remark.text;
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        NSLog(@"data==%@",data);
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
//上传采购项目图片
- (void)dealWithBuImagesArray:(NSMutableArray *)imgTotalArray withIndexThird:(NSInteger)indexThird {
    [YXSpritesLoadingView showWithText:Custing(@"光速加速中...", nil) andShimmering:NO andBlurEffect:NO];
    NSInteger thirdArrCount = self.FormDatas.arr_ThirDetailsDataArray.count;
    NSInteger secondArrCount = self.FormDatas.arr_SecDetailsDataArray.count;
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:imgTotalArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        NSLog(@"indexThird==%ld,data==%@",(long)indexThird,data);
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:data duration:2.0];
        }else{
            DeatilsModel *model = [weakSelf.FormDatas.arr_ThirDetailsDataArray objectAtIndex:indexThird];
//            model.Attachments = [NSString stringWithFormat:@"%@",data];
            model.Attachments = [NSString stringWithId:data];
            if (indexThird <thirdArrCount - 1) {
                [weakSelf uploadBuThirdArrWithIndex:indexThird+1];
            }else if (secondArrCount > 0){
                [weakSelf uploadAmSecondArrWithIndex:0];
            }else if (fourthArrCount > 0){
                [weakSelf uploadSoFourthArrWithIndex:0];
            }else{
                [weakSelf.FormDatas contectData];
                [weakSelf dealWithImagesArray];
            }
        }
    }];
}

//上传采购项目明细及金额图片
- (void)dealWithAmImagesArray:(NSMutableArray *)imgTotalArray withIndexSecond:(NSInteger)indexSecond {
    [YXSpritesLoadingView showWithText:Custing(@"光速加速中...", nil) andShimmering:NO andBlurEffect:NO];
    NSInteger secondArrCount = self.FormDatas.arr_SecDetailsDataArray.count;
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:imgTotalArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        NSLog(@"indexSecond==%ld,data==%@",(long)indexSecond,data);
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:data duration:2.0];
        }else{
            DeatilsModel *model = [weakSelf.FormDatas.arr_SecDetailsDataArray objectAtIndex:indexSecond];
//            model.Attachments = [NSString stringWithFormat:@"%@",data];
            model.Attachments = [NSString stringWithId:data];
            if (indexSecond <secondArrCount - 1) {
                [weakSelf uploadAmSecondArrWithIndex:indexSecond+1];
            }else if (fourthArrCount > 0){
                [weakSelf uploadSoFourthArrWithIndex:0];
            }else{
                [weakSelf.FormDatas contectData];
                [weakSelf dealWithImagesArray];
            }
        }
    }];
}

//上传单一采购来源清单图片
- (void)dealWithSoImagesArray:(NSMutableArray *)imgTotalArray withIndexFourth:(NSInteger)indexFourth{
    [YXSpritesLoadingView showWithText:Custing(@"光速加速中...", nil) andShimmering:NO andBlurEffect:NO];
    NSInteger fourthArrCount = self.FormDatas.arr_FouDetailsDataArray.count;
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:imgTotalArray WithUrl:ProcurementLoadImage WithBlock:^(id data, BOOL hasError) {
        NSLog(@"indexFouth==%ld,data==%@",(long)indexFourth,data);
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:data duration:2.0];
        }else{
            DeatilsModel *model = [weakSelf.FormDatas.arr_FouDetailsDataArray objectAtIndex:indexFourth];
            model.Attachments = [NSString stringWithId:data];
            if (indexFourth < fourthArrCount - 1) {
                [weakSelf uploadSoFourthArrWithIndex:indexFourth + 1];
            }else{
                [weakSelf.FormDatas contectData];
                [weakSelf dealWithImagesArray];
            }
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
