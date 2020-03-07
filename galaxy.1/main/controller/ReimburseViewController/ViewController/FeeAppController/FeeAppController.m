//
//  FeeAppController.m
//  galaxy
//
//  Created by hfk on 2017/6/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FeeAppController.h"

@interface FeeAppController ()

@end

@implementation FeeAppController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[FeeAppFormData alloc]initWithStatus:1];
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
    
    _View_table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 200) style:UITableViewStylePlain];
    _View_table.delegate = self;
    _View_table.dataSource = self;
    _View_table.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//MARK:创建主视图
-(void)createMainView{
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //申请类型
    _View_AppType=[[UIView alloc]init];
    _View_AppType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AppType];
    [_View_AppType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //关联费用申请
    _View_FeeAppForm=[[MulChooseShowView alloc]initWithStatus:3 withFlowCode:@"F0012"];
    _View_FeeAppForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FeeAppForm];
    [_View_FeeAppForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AppType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate=[[UIView alloc]init];
    _View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FeeAppForm.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CateDes=[[UIView alloc]init];
    _View_CateDes.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CateDes];
    [_View_CateDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CateDes.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Acount=[[UIView alloc]init];
    _View_Acount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Acount];
    [_View_Acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //币种视图
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Acount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //汇率视图
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //本位币视图
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //资本性支出
    _View_CapexAmount = [[UIView alloc] init];
    _View_CapexAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CapexAmount];
    [_View_CapexAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //费用
    _View_CostAmount = [[UIView alloc] init];
    _View_CostAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CostAmount];
    [_View_CostAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CapexAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //业务经理
    _View_BusinessMgr = [[UIView alloc] init];
    _View_BusinessMgr.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BusinessMgr];
    [_View_BusinessMgr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CostAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //业务负责人
    _View_BusinessOwner = [[UIView alloc] init];
    _View_BusinessOwner.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_BusinessOwner];
    [_View_BusinessOwner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BusinessMgr.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BusinessOwner.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsDeptBearExps = [[UIView alloc]init];
    _View_IsDeptBearExps.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsDeptBearExps];
    [_View_IsDeptBearExps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsDeptBearExps.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
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
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails=[[UIView alloc]init];
    _View_AddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.bottom);
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
-(void)requestCate{
    NSString *url=[NSString stringWithFormat:@"%@",GETCATEList];
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
            [self requestCate];
        }
            break;
        case 10:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        case 14:
        {
            if ([self.FormDatas getVerifyBudegt]==0) {
                [self dealWithImagesArray];
            }else{
                [self showBudgetTab];
            }
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
-(void)showBudgetTab{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"超预算提示", nil) message:@"" canDismis:NO];
    alert.contentView = self.View_table;
    [self.View_table reloadData];
    [alert addButton:Button_OTHER withTitle:Custing(@"取消", nil) handler:^(JKAlertDialogItem *item) {
    }];
    self.dockView.userInteractionEnabled=YES;
    [alert show];
}
//MARK:视图更新
-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];

    [_FormRelatedView initFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithBaseModel:self.FormDatas Withcontroller:self];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpenseTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateExpenseDescViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAmountViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"CurrencyCode"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_CurrencyCodeView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_ExchangeRateView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_LocalCyAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"ApplicationType"]){//申请类型
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_AppTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"FeeAppNumber"]){//费用申请单
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_FeeAppNumberViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"CapexAmount"]){//资本性支出
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_CapexAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"CostAmount"]){//费用
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self update_CostAmountView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"BusinessMgr"]){//业务经理
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBusinessMgrView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if([model.fieldName isEqualToString:@"BusinessOwner"]){//业务负责人
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateBusinessOwnerView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }
        else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"IsDeptBearExps"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIsDeptBearExpsViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
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
            FeeAppDeatil *model=[[FeeAppDeatil alloc]init];
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

//MARK:更新报销事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.FormDatas.str_ExpenseCat,self.FormDatas.str_ExpenseType]]}];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.Imv_category=image;
        [weakSelf CateBtnClick:nil];
    }];
    [_View_Cate addSubview:view];
    
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_ExpenseCode=[NSString stringWithFormat:@"%@",model.fieldValue];
        [view setCateImg:self.FormDatas.str_ExpenseIcon];
    }
}
//MARK:更新费用描述
-(void)updateExpenseDescViewWithModel:(MyProcurementModel *)model{
    _txv_CateDes = [[UITextView alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CateDes WithContent:_txv_CateDes WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CateDes addSubview:view];
}
//MARK:更新借款金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Acount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Acount WithContent:_txf_Acount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_Acount.keyboardType = UIKeyboardTypeASCIICapable;//为了让_txf_Acount可以输入负号
    _txf_Acount.delegate = self;//为了让_txf_Acount可以输入负号
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
        weakSelf.FormDatas.str_LocalCyAmount = [GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
    }];
    [_View_Acount addSubview:view];
    
    if (!self.FormDatas.bool_DetailsShow) {
        _txf_Acount.userInteractionEnabled=YES;
    }else{
        _txf_Acount.userInteractionEnabled=NO;
        _txf_Acount.placeholder=@"";
    }
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_lastAmount = model.fieldValue;
    }
}
//MARK:更新币种视图
-(void)update_CurrencyCodeView:(MyProcurementModel *)model{
    _txf_CurrencyCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf changeCurrency];
    }];
    [_View_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text=self.FormDatas.str_Currency;
    }else{
        _txf_CurrencyCode.text=self.FormDatas.str_Currency;
    }
}
//MARK:更新汇率视图
-(void)update_ExchangeRateView:(MyProcurementModel *)model{
    _txf_ExchangeRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.FormDatas.str_ExchangeRate=exchange;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")]];
        weakSelf.FormDatas.str_LocalCyAmount = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
    }];
    [_View_ExchangeRate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.FormDatas.str_ExchangeRate=model.fieldValue;
    }else{
        _txf_ExchangeRate.text=[NSString stringWithFormat:@"%@",self.FormDatas.str_ExchangeRate];
    }
}

//MARK:更新本位币金额视图
-(void)update_LocalCyAmountView:(MyProcurementModel *)model{
    _txf_LocalCyAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_LocalCyAmount addSubview:view];
}

//MARK:更新资本性支出
- (void)update_CapexAmountView:(MyProcurementModel *)model{
    _txf_CapexAmount = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_CapexAmount WithContent:_txf_CapexAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CapexAmount addSubview:view];
}
//MARK:更新费用
- (void)update_CostAmountView:(MyProcurementModel *)model{
    _txf_CostAmount = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_CostAmount WithContent:_txf_CostAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CostAmount addSubview:view];
    
}
//申请类型数组
- (NSMutableArray *)arr_AppType{
    if (!_arr_AppType) {
        _arr_AppType = [NSMutableArray array];
        NSArray *idArr = [NSArray arrayWithObjects:@"0",@"1", nil];
        NSArray *typeArr = [NSArray arrayWithObjects:Custing(@"项目", nil),Custing(@"非项目", nil), nil];
        for (int i = 0 ; i < 2; i ++) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idArr[i];
            model.Type = typeArr[i];
            [_arr_AppType addObject:model];
        }
    }
    return _arr_AppType;
}
//MARK:更新申请类型
- (void)update_AppTypeViewWithModel:(MyProcurementModel *)model{
    for (STOnePickModel *pickModel in self.arr_AppType) {
        if ([model.fieldValue isEqualToString:pickModel.Id]) {
            model.fieldValue = pickModel.Type;
        }
    }
    _txf_AppType = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_AppType WithContent:_txf_AppType WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc] init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_AppTypeId = Model.Id;
            weakSelf.str_AppTypeInfo = Model.Type;
            weakSelf.txf_AppType.text = Model.Type;
            weakSelf.FormDatas.str_ApplicationType = Model.Id;
        }];
        picker.typeTitle = Custing(@"申请类型", nil);
        picker.DateSourceArray = weakSelf.arr_AppType;
        [picker setContentMode:STPickerContentModeBottom];
        [picker UpdatePickUI];
        [picker show];
    }];
    [_View_AppType addSubview:view];
}
//MARK:更新关联费用申请
- (void)update_FeeAppNumberViewWithModel:(MyProcurementModel *)model{

    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.FormDatas.str_FeeAppNumber = [NSString stringWithFormat:@"%@",model.fieldValue];
    }else{
        self.FormDatas.str_FeeAppInfo = @"";
        self.FormDatas.str_FeeAppNumber = @"";
    }
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],@"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo],@"Model":model};
    [_View_FeeAppForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_FeeAppForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf FeeFormClick];
    };
}
- (void)FeeFormClick{
    [self keyClose];
    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc] initWithType:@"FeeAppForms"];
    vc.ChooseCategoryId = self.FormDatas.str_FeeAppNumber;
    vc.isMultiSelect = NO;
    vc.dict_otherPars = @{@"Type":@"0",@"UserId":self.FormDatas.personalData.RequestorUserId};
    __weak typeof(self) weakSelf = self;
    
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        NSMutableArray *name = [NSMutableArray array];
        NSMutableArray *Id = [NSMutableArray array];
        weakSelf.FormDatas.str_EstimatedAmount = @"0";
        for (ChooseCateFreModel *model in array) {
            [name addObject:[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.serialNo],[NSString stringWithIdOnNO:model.reason]] WithCompare:@"/"]];
            [Id addObject:[NSString stringWithIdOnNO:model.taskId]];
            weakSelf.FormDatas.str_EstimatedAmount = [GPUtils decimalNumberAddWithString:model.localCyAmount with:weakSelf.FormDatas.str_EstimatedAmount];
           }
        weakSelf.FormDatas.str_FeeAppInfo = [GPUtils getSelectResultWithArray:name WithCompare:@"⊕"];
        weakSelf.FormDatas.str_FeeAppNumber = [GPUtils getSelectResultWithArray:Id WithCompare:@","];
        NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppNumber],@"Value":[NSString stringWithIdOnNO:self.FormDatas.str_FeeAppInfo]};
        [weakSelf.View_FeeAppForm updateView:dict];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//MARK:更新业务经理
- (void)updateBusinessMgrView:(MyProcurementModel *)model{

    _txf_BusinessMgr = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_BusinessMgr WithContent:_txf_BusinessMgr WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":model.fieldValue}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf businessMgrClick];
    }];
    [_View_BusinessMgr addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_BusinessMgr = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
}
//MARK:选择业务经理
- (void)businessMgrClick{
    contactsVController *contactVC = [[contactsVController alloc] init];
    contactVC.status = @"15";//15业务经理 16业务负责人
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idArr =[self.FormDatas.str_BusinessMgrId componentsSeparatedByString:@","];
    for (int i = 0; i < idArr.count; i ++) {
        NSDictionary *dic = @{@"requestorUserId":idArr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople = array;
    contactVC.menutype = 2;
    contactVC.itemType = 99;
    contactVC.Radio = @"1";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];
        if (array.count > 0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",bul.requestorUserId]];
                }
            }
        }
//        weakSelf.FormDatas.str_BusinessMgrId = [GPUtils getSelectResultWithArray:idArr WithCompare:@","];
//        weakSelf.FormDatas.str_BusinessMgr = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.FormDatas.str_BusinessMgrId = [idArr lastObject];
        weakSelf.FormDatas.str_BusinessMgr = [nameArr lastObject];
        weakSelf.txf_BusinessMgr.text = weakSelf.FormDatas.str_BusinessMgr;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:更新业务负责人
- (void)updateBusinessOwnerView:(MyProcurementModel *)model{
    _txf_BusinessOwner = [[UITextField alloc] init];
    SubmitFormView *view = [[SubmitFormView alloc] initBaseView:_View_BusinessOwner WithContent:_txf_BusinessOwner WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":model.fieldValue}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf businessOwnerClick];
    }];
    [_View_BusinessOwner addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_BusinessOwner = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
}
//MARK:选择业务负责人
- (void)businessOwnerClick{
    contactsVController *contactVC = [[contactsVController alloc] init];
    contactVC.status = @"16";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idArr = [self.FormDatas.str_BusinessOwnerId componentsSeparatedByString:@","];
    for (int i = 0 ; i < idArr.count; i ++) {
        NSDictionary *dic = @{@"requestorUserId":idArr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople = array;
    contactVC.menutype = 2;
    contactVC.itemType = 99;
    contactVC.Radio = @"1";
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];
        if (array.count > 0) {
            for (buildCellInfo *bul in array) {
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",bul.requestorUserId]];
                }
            }
        }
        weakSelf.FormDatas.str_BusinessOwnerId = [idArr lastObject];
        weakSelf.FormDatas.str_BusinessOwner = [nameArr lastObject];
        weakSelf.txf_BusinessOwner.text = weakSelf.FormDatas.str_BusinessOwner;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:更新明细
-(void)updateDetailsTableView{
    
    NSString *capexAmount = @"";
    NSString *costAmount = @"";
    
//    for (FeeAppDeatil *models in self.FormDatas.arr_DetailsDataArray) {
//        if ([models.CostType isEqualToString:@"0"]) {//资本性支出汇总
//            capexAmount = [GPUtils decimalNumberAddWithString:capexAmount with:models.Amount];
//        }else if ([models.CostType isEqualToString:@"1"]){//费用汇总
//            costAmount = [GPUtils decimalNumberAddWithString:costAmount with:models.Amount];
//        }
//    }
    self.FormDatas.str_CapexAmount = [GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
    _txf_CapexAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"]];
    self.FormDatas.str_CostAmount = [GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
    _txf_CostAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"]];
    
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
        FeeAppDeatil *model1=[[FeeAppDeatil alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
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
//MARK:更新是否本部门承担费用视图
-(void)updateIsDeptBearExpsViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"]) {
        model.fieldValue = Custing(@"否", nil);
        self.FormDatas.str_IsDeptBearExps = @"0";
    }else{
        model.fieldValue = Custing(@"是", nil);
        self.FormDatas.str_IsDeptBearExps = @"1";
    }
    _txf_IsDeptBearExps = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsDeptBearExps WithContent:_txf_IsDeptBearExps WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_IsDeptBearExps = Model.Id;
            weakSelf.txf_IsDeptBearExps.text = Model.Type;
        }];
        picker.typeTitle = Custing(@"是否本部门承担费用", nil);
        picker.DateSourceArray = weakSelf.FormDatas.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.FormDatas.str_IsDeptBearExps;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_IsDeptBearExps addSubview:view];
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
//MARK:费用类别选择
-(void)CateBtnClick:(UIButton *)btn{
    [self keyClose];
    STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
    pickerArea.typeTitle=Custing(@"费用类别", nil);
    pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:self.FormDatas.arr_CategoryArr];
    CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
    if (btn.tag) {
        FeeAppDeatil *Detailmodel=self.FormDatas.arr_DetailsDataArray[btn.tag-1];
        model.expenseCode=Detailmodel.ExpenseCode;
        self.FormDatas.int_DetailTypeIndex=btn.tag;
    }else{
        self.FormDatas.int_DetailTypeIndex=0;
        model.expenseCode=self.FormDatas.str_ExpenseCode;
    }
    pickerArea.CateModel=model;
    [pickerArea UpdatePickUI];
    [pickerArea setContentMode:STPickerContentModeBottom];
    pickerArea.str_flowCode=@"F0012";
    __weak typeof(self) weakSelf = self;
    [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
        if (weakSelf.FormDatas.int_DetailTypeIndex>0) {
            FeeAppDeatil *Detailmodel=weakSelf.FormDatas.arr_DetailsDataArray[weakSelf.FormDatas.int_DetailTypeIndex-1];
            if (![secondModel.expenseCode isEqualToString:Detailmodel.ExpenseCode]) {
                Detailmodel.ExpenseCode=secondModel.expenseCode;
                Detailmodel.ExpenseType=secondModel.expenseType;
                Detailmodel.ExpenseIcon=secondModel.expenseIcon;
                Detailmodel.ExpenseCatCode=secondModel.expenseCatCode;
                Detailmodel.ExpenseCat=secondModel.expenseCat;
                [weakSelf.View_DetailsTable reloadData];
            }
        }else{
            if (![secondModel.expenseCode isEqualToString:weakSelf.FormDatas.str_ExpenseCode]) {
                weakSelf.Imv_category.image =[UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.FormDatas.str_ExpenseType=[NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.FormDatas.str_ExpenseCode=secondModel.expenseCode;
                weakSelf.FormDatas.str_ExpenseIcon=secondModel.expenseIcon;
                weakSelf.FormDatas.str_ExpenseCat=secondModel.expenseCat;
                weakSelf.FormDatas.str_ExpenseCatCode=secondModel.expenseCatCode;
                weakSelf.txf_Cate.text=[GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
            }
        }
    }];
    [pickerArea show];
}
//MARK:类型选择
- (NSMutableArray *)arr_CostType{
    if (_arr_CostType == nil) {
        _arr_CostType = [NSMutableArray array];
        NSArray *typeArr = @[@"资本性支出",@"费用"];
        NSArray *idAdd = @[@"0",@"1"];
        for (int i = 0 ; i < 2; i ++ ) {
            STOnePickModel *model = [[STOnePickModel alloc] init];
            model.Id = idAdd[i];
            model.Type = typeArr[i];
            [_arr_CostType addObject:model];
        }
    }
    return _arr_CostType;
}
- (void)CostTypeClick:(UIButton *)btn{
    [self keyClose];
    if (self.FormDatas.arr_DetailsDataArray.count <= 0) {
        return;
    }
    FeeAppDeatil *detailModel = [self.FormDatas.arr_DetailsDataArray objectAtIndex:btn.tag - 1];
    STOnePickView *picker = [[STOnePickView alloc] init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
//        if (![detailModel.CostType isEqualToString:Model.Id]) {
//            detailModel.CostType = Model.Id;
//            [weakSelf.View_DetailsTable reloadData];
//        }
        NSString *capexAmount = @"";
        NSString *costAmount = @"";
//        for (FeeAppDeatil *models in weakSelf.FormDatas.arr_DetailsDataArray) {
//            if ([models.CostType isEqualToString:@"0"]) {//资本性支出汇总
//                capexAmount = [GPUtils decimalNumberAddWithString:capexAmount with:models.Amount];
//            }else if ([models.CostType isEqualToString:@"1"]){//费用汇总
//                costAmount = [GPUtils decimalNumberAddWithString:costAmount with:models.Amount];
//            }
//        }
        weakSelf.FormDatas.str_CapexAmount = [GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000"];
        weakSelf.txf_CapexAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000"]];
        weakSelf.FormDatas.str_CostAmount = [GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000"];
        weakSelf.txf_CostAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000"]];
    }];
    picker.typeTitle = Custing(@"类型", nil);
    picker.DateSourceArray = self.arr_CostType;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
    
}
//MARK:币种
-(void)changeCurrency{
    [self keyClose];
    STOnePickView *picker = [[STOnePickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        weakSelf.FormDatas.str_CurrencyCode=Model.Id;
        weakSelf.FormDatas.str_Currency=Model.Type;
        weakSelf.txf_CurrencyCode.text=Model.Type;
        weakSelf.txf_ExchangeRate.text=Model.exchangeRate;
        weakSelf.FormDatas.str_ExchangeRate=Model.exchangeRate;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
        weakSelf.FormDatas.str_LocalCyAmount = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Acount.text with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")];
    }];
    picker.typeTitle=Custing(@"币种", nil);
    picker.DateSourceArray=[NSMutableArray arrayWithArray:self.FormDatas.arr_CurrencyCode];
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=[NSString isEqualToNull: self.FormDatas.str_CurrencyCode]?self.FormDatas.str_CurrencyCode:@"";
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
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
    contactVC.itemType = 12;
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
    if (tableView==_View_DetailsTable) {
        return self.FormDatas.arr_DetailsDataArray.count;
    }else if (tableView==_View_table){
        return 1;
    } else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_View_DetailsTable) {
        return self.FormDatas.arr_DetailsArray.count;
    }else if (tableView==_View_table) {
        return self.FormDatas.arr_table.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_View_DetailsTable) {
        return 42;
    }else  if (tableView==_View_table){
        return 40;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_View_DetailsTable) {

    DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
    if (cell==nil) {
        cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
    }
    [cell configFeeCellWithModel:self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
    [cell.ExpenseDescTF addTarget:self action:@selector(ExpenseDescChange:) forControlEvents:UIControlEventEditingChanged];
    cell.ExpenseDescTF.tag=100+indexPath.section;
    cell.ExpenseDescTF.delegate = self;
    
    [cell.AmountTF addTarget:self action:@selector(AmountChange:) forControlEvents:UIControlEventEditingChanged];
    cell.AmountTF.tag=1000+indexPath.section;
    cell.AmountTF.delegate = self;
    
    [cell.ExpenseTypeBtn addTarget:self action:@selector(CateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.ExpenseTypeBtn.tag=1+indexPath.section;
        
    [cell.CostTypeBtn addTarget:self action:@selector(CostTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.CostTypeBtn.tag = 1+indexPath.section;
    return cell;
    }else if (tableView==_View_table) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text =self.FormDatas.arr_table[indexPath.row];
        cell.textLabel.font = Font_Same_14_20;
        return cell;
    }else{
        return [[UITableViewCell alloc]init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_View_DetailsTable) {
        return 27;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView==_View_DetailsTable) {
        [self createHeadViewWithSection:section];
        return _View_Head;
    }else{
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
        return view;
    }
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
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    if (textField.tag>=1000&&textField.tag<=1250){
//        NSString *pattern;
//        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
//        NSError *error = nil;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
//        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
//        return match!= 0;
//    }
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
        titleLabel.text=Custing(@"费用明细", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用明细", nil),(long)section+1];
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
//MARK:采购明细详情填写
-(void)ExpenseDescChange:(UITextField *)text
{
    FeeAppDeatil *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        FeeAppDeatil *model=[[FeeAppDeatil alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.ExpenseDesc=text.text;
    }else{
        model.ExpenseDesc=text.text;
    }
}
-(void)AmountChange:(UITextField *)text
{
    FeeAppDeatil *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        FeeAppDeatil *model=[[FeeAppDeatil alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
    //新增本位币金额（只上传不显示）
//    model.LocalCyAmount = [GPUtils decimalNumberMultipWithString:model.Amount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
    
    NSString *TotalMoney=@"";
    NSString *capexAmount = @"";
    NSString *costAmount = @"";
    
    for (FeeAppDeatil *models in self.FormDatas.arr_DetailsDataArray) {
        TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
//        if ([models.CostType isEqualToString:@"0"]) {//资本性支出汇总
//            capexAmount = [GPUtils decimalNumberAddWithString:capexAmount with:models.Amount];
//        }else if ([models.CostType isEqualToString:@"1"]){//费用汇总
//            costAmount = [GPUtils decimalNumberAddWithString:costAmount with:models.Amount];
//        }
    }
    _txf_Acount.text=TotalMoney;
    self.FormDatas.str_CapexAmount = [GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
    _txf_CapexAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:capexAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"]];
    
    self.FormDatas.str_CostAmount = [GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
    _txf_CostAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:costAmount with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"]];
    
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")]];
    self.FormDatas.str_LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Acount.text with:[NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000"];
}

//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    
    [self keyClose];
    NSLog(@"删除明细");
    _Aler_deleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除费用明细", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
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
            NSString *TotalMoney=@"";
            for (FeeAppDeatil *models in self.FormDatas.arr_DetailsDataArray) {
                TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
            }
            _txf_Acount.text=TotalMoney;
            NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")];
            self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:LocalCyAmount];
            self.FormDatas.str_LocalCyAmount = LocalCyAmount;
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
//MARK:-提交保存数据处理
//拼接数据
-(void)mainDataList{
    [self.FormDatas inModelContent];
    [self configModelOtherData];
    if (self.FormDatas.int_SubmitSaveType==1) {
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }else if (self.FormDatas.int_SubmitSaveType==2||self.FormDatas.int_SubmitSaveType==3){
        NSString *str=[self.FormDatas testModel];
        if ([NSString isEqualToNull:str]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:2.0];
            self.dockView.userInteractionEnabled=YES;
            return;
        }else{
            if (self.FormDatas.int_SubmitSaveType==3) {
                if (![_txf_Acount.text isEqualToString:self.FormDatas.str_lastAmount]&&[self.FormDatas.str_directType integerValue] == 2) {
                    _dockView.userInteractionEnabled = YES;
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您修改了金额，请重新提交", nil) duration:1.0];
                    return;
                }else if ([[GPUtils decimalNumberSubWithString:_txf_Acount.text with:self.FormDatas.str_lastAmount]floatValue]>0&&[self.FormDatas.str_directType integerValue] ==3){
                    _dockView.userInteractionEnabled = YES;
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您修改了金额，请重新提交", nil) duration:1.0];
                    return;
                }
            }
            [self.FormDatas contectData];
            [self checkTravelReimSubmit];

        }
    }
}
-(void)configModelOtherData{
    
    self.FormDatas.SubmitData.Reason = self.txv_Reason.text;
    self.FormDatas.SubmitData.ExpenseDesc = self.txv_CateDes.text;
    self.FormDatas.SubmitData.EstimatedAmount=[NSString isEqualToNull:_txf_Acount.text]?_txf_Acount.text:(id)[NSNull null];
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;

    NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")];
    LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    self.FormDatas.SubmitData.LocalCyAmount=[NSString isEqualToNull:LocalCyAmount]?LocalCyAmount:@"0.00";

}

//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:FeeAppLoadImage WithBlock:^(id data, BOOL hasError) {
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
//MARK:第一次提交验证
-(void)checkTravelReimSubmit
{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getCheckSubmitUrl] Parameters:[self.FormDatas GetCheckSubmitWithAmount:self.FormDatas.SubmitData.LocalCyAmount WithExpIds:nil otherParameters:[self.FormDatas getCheckSubmitOtherPar]] Delegate:self SerialNum:14 IfUserCache:NO];
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
