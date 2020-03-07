//
//  EntertainmentNewController.m
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "EntertainmentNewController.h"

@interface EntertainmentNewController ()

@end

@implementation EntertainmentNewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[EntertainmentFormData alloc]initWithStatus:1];
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
        make.top.left.right.equalTo(self.view);
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
        make.left.right.bottom.equalTo(self.view);
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
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Object=[[UIView alloc]init];
    _View_Object.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Object];
    [_View_Object mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StartTime=[[UIView alloc]init];
    _View_StartTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StartTime];
    [_View_StartTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Object.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EndTime=[[UIView alloc]init];
    _View_EndTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EndTime];
    [_View_EndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StartTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Visitor=[[UIView alloc]init];
    _View_Visitor.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Visitor];
    [_View_Visitor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type = [[UIView alloc]init];
    _View_Type.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Visitor.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate=[[UIView alloc]init];
    _View_Cate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.mas_bottom);
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

    
    _View_IsUseCar=[[UIView alloc]init];
    _View_IsUseCar.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_IsUseCar];
    [_View_IsUseCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RentCarFee=[[UIView alloc]init];
    _View_RentCarFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RentCarFee];
    [_View_RentCarFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsUseCar.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Pontage=[[UIView alloc]init];
    _View_Pontage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Pontage];
    [_View_Pontage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RentCarFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_MealFee=[[UIView alloc]init];
    _View_MealFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_MealFee];
    [_View_MealFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Pontage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_HotelFee=[[UIView alloc]init];
    _View_HotelFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_HotelFee];
    [_View_HotelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MealFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherFee=[[UIView alloc]init];
    _View_OtherFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OtherFee];
    [_View_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HotelFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    
    _View_Acount=[[UIView alloc]init];
    _View_Acount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Acount];
    [_View_Acount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CurrencyCode = [[UIView alloc]init];
    _View_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CurrencyCode];
    [_View_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Acount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExchangeRate = [[UIView alloc]init];
    _View_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ExchangeRate];
    [_View_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LocalCyAmount = [[UIView alloc]init];
    _View_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LocalCyAmount];
    [_View_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExchangeRate.bottom);
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
        make.top.equalTo(self.View_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AddDetails=[[UIView alloc]init];
    _View_AddDetails.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_AddDetails];
    [_View_AddDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_VisitorTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_VisitorTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_VisitorTable.delegate=self;
    _View_VisitorTable.dataSource=self;
    _View_VisitorTable.scrollEnabled=NO;
    _View_VisitorTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_VisitorTable];
    [_View_VisitorTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddDetails.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VisitorAdd=[[UIView alloc]init];
    _View_VisitorAdd.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_VisitorAdd];
    [_View_VisitorAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VisitorTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PlanTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_PlanTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_PlanTable.delegate=self;
    _View_PlanTable.dataSource=self;
    _View_PlanTable.scrollEnabled=NO;
    _View_PlanTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_PlanTable];
    [_View_PlanTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VisitorAdd.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PlanAdd=[[UIView alloc]init];
    _View_PlanAdd.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_PlanAdd];
    [_View_PlanAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PlanTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PlanAdd.bottom);
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
        self.dockView.userInteractionEnabled=YES;
    }];
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
        }else if ([model.fieldName isEqualToString:@"ReceptionObj"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateObjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"VisitDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStartTimeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LeaveDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEndTimeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Visitor"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateVisitorViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Type"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateTypeViewWithModel:model];
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
        }else if ([model.fieldName isEqualToString:@"IsUseCar"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateIsUseCarView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"RentCarFee"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateRentCarFeeView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Pontage"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatePontageView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"MealFee"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateMealFeeView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"HotelFee"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateHotelFeeView:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"OtherFee"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateOtherFeeView:model];
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
            EntertainmentDeatil *model=[[EntertainmentDeatil alloc]init];
            [self.FormDatas.arr_DetailsDataArray addObject:model];
        }
        [self.FormDatas.arr_UnShowmsArray removeObject:@"DetailList"];
        [self updateDetailsTableView];
        [self updateAddDetailsView];
    }
    if (self.FormDatas.bool_ThirDetailsShow) {
        if (self.FormDatas.arr_ThirDetailsDataArray.count==0) {
            EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
            [self.FormDatas.arr_ThirDetailsDataArray addObject:model];
        }
        [self.FormDatas.arr_UnShowmsArray removeObject:@"ThirDetailList"];
        [self updateThirDetailsTableView];
        [self updateThirAddDetailsView];
    }
    
    
    if (self.FormDatas.bool_SecDetailsShow) {
        if (self.FormDatas.arr_SecDetailsDataArray.count==0) {
            EntertainmentSchDeatil *model=[[EntertainmentSchDeatil alloc]init];
            [self.FormDatas.arr_SecDetailsDataArray addObject:model];
        }
        [self.FormDatas.arr_UnShowmsArray removeObject:@"SecDetailList"];
        [self updateSecDetailsTableView];
        [self updateSecAddDetailsView];
    }
    
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    [self updateContentView];
    
    [self.FormDatas getEndShowArray];
}
//MARK:更新类型
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryName = weakSelf.FormDatas.str_Type;
        vc.ChooseModel=model;
        vc.ChooseCategoryId = weakSelf.FormDatas.str_TypeId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_Type.text=model.name;
            weakSelf.FormDatas.str_Type = model.name;
            weakSelf.FormDatas.str_TypeId = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_View_Type addSubview:view];
}

//MARK:更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txf_Reason=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txf_Reason WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:更新接待对象视图
-(void)updateObjectViewWithModel:(MyProcurementModel *)model{
    _txf_Object=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Object WithContent:_txf_Object WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Object addSubview:view];
}
//MARK:来访时间
-(void)updateStartTimeViewWithModel:(MyProcurementModel *)model{
    _txf_StartTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StartTime WithContent:_txf_StartTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_StartTime addSubview:view];
}
//MARK:离开时间
-(void)updateEndTimeViewWithModel:(MyProcurementModel *)model{
    _txf_EndTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndTime WithContent:_txf_EndTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_EndTime addSubview:view];
}
//MARK:来访人员
-(void)updateVisitorViewWithModel:(MyProcurementModel *)model{
    _txf_Visitor=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Visitor WithContent:_txf_Visitor WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Visitor addSubview:view];
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
    _txf_CateDes=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CateDes WithContent:_txf_CateDes WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_CateDes addSubview:view];
}
//MARK:更新是否用车视图
-(void)updateIsUseCarView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        self.FormDatas.str_IsUseCar=@"1";
        model.fieldValue=Custing(@"是", nil);
    }else{
        self.FormDatas.str_IsUseCar=@"0";
        model.fieldValue=Custing(@"否", nil);
    }
    _txf_IsUseCar=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsUseCar WithContent:_txf_IsUseCar WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_IsUseCar=Model.Id;
            weakSelf.txf_IsUseCar.text=Model.Type;
        }];
        picker.typeTitle=Custing(@"是否用车", nil);
        picker.DateSourceArray=weakSelf.FormDatas.arr_IsOrNot;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=weakSelf.FormDatas.str_IsUseCar;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_IsUseCar addSubview:view];
}

//MARK:更新租车费
-(void)updateRentCarFeeView:(MyProcurementModel *)model{
    _txf_RentCarFee=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_RentCarFee WithContent:_txf_RentCarFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_View_RentCarFee addSubview:view];
    
}
//MARK:更新路桥费
-(void)updatePontageView:(MyProcurementModel *)model{
    _txf_Pontage=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Pontage WithContent:_txf_Pontage WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_View_Pontage addSubview:view];
    
}
//MARK:更新餐费
-(void)updateMealFeeView:(MyProcurementModel *)model{
    _txf_MealFee=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_MealFee WithContent:_txf_MealFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_View_MealFee addSubview:view];
    
}
//MARK:更新住宿费
-(void)updateHotelFeeView:(MyProcurementModel *)model{
    _txf_HotelFee=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_HotelFee WithContent:_txf_HotelFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_View_HotelFee addSubview:view];
}
//MARK:更新其他费
-(void)updateOtherFeeView:(MyProcurementModel *)model{
    _txf_OtherFee=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OtherFee WithContent:_txf_OtherFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_View_OtherFee addSubview:view];
}

-(void)getAllFeeTotolAmount{
    NSString *totol = @"0";
    totol = [GPUtils decimalNumberAddWithString:self.txf_RentCarFee.text with:self.txf_Pontage.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_MealFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_HotelFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_OtherFee.text];
    self.txf_Acount.text = totol;
    self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:self.txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")]];
}
//MARK:更新金额
-(void)updateAmountViewWithModel:(MyProcurementModel *)model{
    _txf_Acount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Acount WithContent:_txf_Acount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:weakSelf.FormDatas.str_ExchangeRate]?weakSelf.FormDatas.str_ExchangeRate:@"1.0000")]];
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
        EntertainmentDeatil *model1=[[EntertainmentDeatil alloc]init];
        [weakSelf.FormDatas.arr_DetailsDataArray addObject:model1];
        [weakSelf updateDetailsTableView];
    }];
    [_View_AddDetails addSubview:view];
}

//MARK:更新明细
-(void)updateThirDetailsTableView{
    [_View_VisitorTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_ThirDetailsArray.count*42+27)*self.FormDatas.arr_ThirDetailsDataArray.count));
    }];
    [_View_VisitorTable reloadData];
}
//MARK:更新增加按钮
-(void)updateThirAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_VisitorAdd withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        EntertainmentVisitorDeatil *model1=[[EntertainmentVisitorDeatil alloc]init];
        [weakSelf.FormDatas.arr_ThirDetailsDataArray addObject:model1];
        [weakSelf updateThirDetailsTableView];
    }];
    [_View_VisitorAdd addSubview:view];
}

//MARK:更新明细
-(void)updateSecDetailsTableView{
    [_View_PlanTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.FormDatas.arr_SecDetailsArray.count*42+27)*self.FormDatas.arr_SecDetailsDataArray.count));
    }];
    [_View_PlanTable reloadData];
}
//MARK:更新增加按钮
-(void)updateSecAddDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_PlanAdd withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        EntertainmentSchDeatil *model1=[[EntertainmentSchDeatil alloc]init];
        [weakSelf.FormDatas.arr_SecDetailsDataArray addObject:model1];
        [weakSelf updateSecDetailsTableView];
    }];
    [_View_PlanAdd addSubview:view];
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
//MARK:费用类别选择
-(void)CateBtnClick:(UIButton *)btn{
    [self keyClose];
    STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
    pickerArea.typeTitle=Custing(@"费用类别", nil);
    pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:self.FormDatas.arr_CategoryArr];
    CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
    if (btn.tag) {
      EntertainmentDeatil  *Detailmodel=self.FormDatas.arr_DetailsDataArray[btn.tag-1];
        model.expenseCode=Detailmodel.ExpenseCode;
        self.FormDatas.int_DetailTypeIndex=btn.tag;
    }else{
        self.FormDatas.int_DetailTypeIndex=0;
        model.expenseCode=self.FormDatas.str_ExpenseCode;
    }
    pickerArea.CateModel=model;
    [pickerArea UpdatePickUI];
    [pickerArea setContentMode:STPickerContentModeBottom];
    pickerArea.str_flowCode=@"F0023";
    __weak typeof(self) weakSelf = self;
    [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
        if (weakSelf.FormDatas.int_DetailTypeIndex>0) {
            EntertainmentDeatil *Detailmodel=weakSelf.FormDatas.arr_DetailsDataArray[weakSelf.FormDatas.int_DetailTypeIndex-1];
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
    contactVC.itemType = 23;
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
    }else if (tableView==_View_PlanTable){
        return self.FormDatas.arr_SecDetailsDataArray.count;
    }else if (tableView==_View_VisitorTable){
        return self.FormDatas.arr_ThirDetailsDataArray.count;
    }else if (tableView==_View_table){
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_View_DetailsTable) {
        return self.FormDatas.arr_DetailsArray.count;
    }else if (tableView==_View_PlanTable){
        return self.FormDatas.arr_SecDetailsArray.count;
    }else if (tableView==_View_VisitorTable){
        return self.FormDatas.arr_ThirDetailsArray.count;
    }else if (tableView==_View_table) {
        return self.FormDatas.arr_table.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_View_DetailsTable||tableView==_View_PlanTable||tableView==_View_VisitorTable) {
        return 42;
    }else  if (tableView==_View_table){
        return 40;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_View_DetailsTable) {
        
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        [cell configEntertainmentDeatilCellWithModel:self.FormDatas.arr_DetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_DetailsArray.count WithIndex:indexPath.row];
        
        [cell.ExpenseTypeBtn addTarget:self action:@selector(CateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.ExpenseTypeBtn.tag=1+indexPath.section;

        [cell.ExpenseDescTF addTarget:self action:@selector(ExpenseDescChange:) forControlEvents:UIControlEventEditingChanged];
        cell.ExpenseDescTF.tag=100+indexPath.section;
        cell.ExpenseDescTF.delegate = self;
        
        [cell.AmountTF addTarget:self action:@selector(AmountChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag=1000+indexPath.section;
        cell.AmountTF.delegate = self;
        
        [cell.RemarkTextField addTarget:self action:@selector(RemarkxtChange:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarkTextField.tag=100+indexPath.section;
        cell.RemarkTextField.delegate = self;

        return cell;
    }else if (tableView==_View_VisitorTable){
        
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        [cell configEntertainVistorDeatilCellWithModel:self.FormDatas.arr_ThirDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_ThirDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_ThirDetailsArray.count WithIndex:indexPath.row];
        cell.IndexPath=indexPath;
        [cell.NameTextField addTarget:self action:@selector(NameChange:) forControlEvents:UIControlEventEditingChanged];
        cell.NameTextField.tag=100+indexPath.section;
        cell.NameTextField.delegate = self;
        
        [cell.SizeTextField addTarget:self action:@selector(JobTitleChange:) forControlEvents:UIControlEventEditingChanged];
        cell.SizeTextField.tag=100+indexPath.section;
        cell.SizeTextField.delegate = self;
        
        [cell.QtyTextField addTarget:self action:@selector(DepartmentChange:) forControlEvents:UIControlEventEditingChanged];
        cell.QtyTextField.tag=100+indexPath.section;
        cell.QtyTextField.delegate = self;
        
        if (cell.DateTextField) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedWithModelBlock:^(NSIndexPath *index, UITextField *tf, MyProcurementModel *model) {
                [weakSelf keyClose];
                EntertainmentVisitorDeatil *model1=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:index.section];
                if (!model1) {
                    EntertainmentVisitorDeatil *model1=[[EntertainmentVisitorDeatil alloc]init];
                    [weakSelf.FormDatas.arr_ThirDetailsDataArray insertObject:model1 atIndex:index.section];
                    if ([model.fieldName isEqualToString:@"VisitDate"]) {
                        model1.VisitDate=tf.text;
                    }else{
                        model1.LeaveDate=tf.text;
                    }
                }else{
                    if ([model.fieldName isEqualToString:@"VisitDate"]) {
                        model1.VisitDate=tf.text;
                    }else{
                        model1.LeaveDate=tf.text;
                    }
                }
            }];
        }
        if (cell.SupplierBtn) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                [weakSelf keyClose];
                EntertainmentVisitorDeatil *model1=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:index.section];
                if (!model1) {
                    EntertainmentVisitorDeatil *model1=[[EntertainmentVisitorDeatil alloc]init];
                    [weakSelf.FormDatas.arr_ThirDetailsDataArray insertObject:model1 atIndex:index.section];
                }
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
                vc.ChooseCategoryId = model1.CostCenterId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    model1.CostCenter = [NSString stringWithIdOnNO:model.costCenter];
                    model1.CostCenterId = model.Id;
                    tf.text =model1.CostCenter;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
        
        [cell.AmountTF addTarget:self action:@selector(AmounttextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag=160+indexPath.section;
        cell.AmountTF.delegate = self;

        [cell.RemarkTextField addTarget:self action:@selector(RemarkChange:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarkTextField.tag=100+indexPath.section;
        cell.RemarkTextField.delegate = self;
        return cell;
    }else if (tableView==_View_PlanTable){
        
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        cell.IndexPath=indexPath;
        [cell configEntertainmentDeatilCellWithModel:self.FormDatas.arr_SecDetailsArray[indexPath.row] withDetailsModel:self.FormDatas.arr_SecDetailsDataArray[indexPath.section] WithCount:self.FormDatas.arr_SecDetailsArray.count WithIndex:indexPath.row];
        
        if (cell.DateTextField) {
            __weak typeof(self) weakSelf = self;
            [cell setCellClickedBlock:^(NSIndexPath *index,UITextField *tf){
                EntertainmentSchDeatil *model=[weakSelf.FormDatas.arr_SecDetailsDataArray objectAtIndex:index.section];
                if (!model) {
                    EntertainmentSchDeatil *model=[[EntertainmentSchDeatil alloc]init];
                    [weakSelf.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:index.section];
                    model.EntertainDate=tf.text;
                }else{
                    model.EntertainDate=tf.text;
                }
            }];
        }

        [cell.AddressTF addTarget:self action:@selector(AddressChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AddressTF.tag=100+indexPath.section;
        cell.AddressTF.delegate = self;
        
        [cell.ContentTF addTarget:self action:@selector(ContentChange:) forControlEvents:UIControlEventEditingChanged];
        cell.ContentTF.tag=100+indexPath.section;
        cell.ContentTF.delegate = self;
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_View_DetailsTable||tableView==_View_PlanTable||tableView==_View_VisitorTable) {
        return 27;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView==_View_DetailsTable) {
        [self createHeadViewWithSection:section];
        return _View_Head;
    }else if (tableView==_View_PlanTable){
        [self createPlanHeadViewWithSection:section];
        return _View_PlanHead;
    }else if (tableView==_View_VisitorTable){
        [self createVistorHeadViewWithSection:section];
        return _View_VisitorHead;
    }else{
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 0.01);
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
    if ((textField.tag>=1000&&textField.tag<=1250)||(textField.tag>=160&&textField.tag<=210)){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:toBeString options:0 range:NSMakeRange(0, [toBeString length])];
        return match!= 0;
    }else if (textField.tag>=100&&textField.tag<=250){
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


#pragma mar-创建tableView头视图
-(void)createVistorHeadViewWithSection:(NSInteger)section{
    _View_VisitorHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_VisitorHead addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_VisitorHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_ThirDetailsDataArray.count==1) {
        titleLabel.text=Custing(@"来访人员信息", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"来访人员信息", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=3200+section;
            [_View_VisitorHead addSubview:deleteBtn];
        }
    }
    _View_VisitorHead.backgroundColor=Color_White_Same_20;
}

#pragma mar-创建tableView头视图
-(void)createPlanHeadViewWithSection:(NSInteger)section{
    _View_PlanHead=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_PlanHead addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_PlanHead addSubview:titleLabel];
    
    if (self.FormDatas.arr_SecDetailsDataArray.count==1) {
        titleLabel.text=Custing(@"接待安排", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"接待安排", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=2200+section;
            [_View_PlanHead addSubview:deleteBtn];
        }
    }
    _View_PlanHead.backgroundColor=Color_White_Same_20;
}

//MARK:采购明细详情填写
-(void)ExpenseDescChange:(UITextField *)text
{
    EntertainmentDeatil *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentDeatil *model=[[EntertainmentDeatil alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.ExpenseDesc=text.text;
    }else{
        model.ExpenseDesc=text.text;
    }
}
-(void)AmountChange:(UITextField *)text
{
    EntertainmentDeatil *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        EntertainmentDeatil *model=[[EntertainmentDeatil alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
    NSString *TotalMoney=@"";
    for (EntertainmentDeatil *models in self.FormDatas.arr_DetailsDataArray) {
        TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
    }
    _txf_Acount.text=TotalMoney;
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")]];
}
-(void)RemarkxtChange:(UITextField *)text{
    EntertainmentDeatil *model=[self.FormDatas.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentDeatil *model=[[EntertainmentDeatil alloc]init];
        [self.FormDatas.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Remark=text.text;
    }else{
        model.Remark=text.text;
    }
}

-(void)NameChange:(UITextField *)text{
    EntertainmentVisitorDeatil *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Name=text.text;
    }else{
        model.Name=text.text;
    }
}
-(void)JobTitleChange:(UITextField *)text{
    EntertainmentVisitorDeatil *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.JobTitle=text.text;
    }else{
        model.JobTitle=text.text;
    }
}
-(void)DepartmentChange:(UITextField *)text{
    EntertainmentVisitorDeatil *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Department=text.text;
    }else{
        model.Department=text.text;
    }
}

-(void)AmounttextChange:(UITextField *)text{
    EntertainmentVisitorDeatil *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-160];
    if (!model) {
        EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-160];
        model.BudgetAmt=text.text;
    }else{
        model.BudgetAmt=text.text;
    }
    [self getEstimatedAmount];
}

-(void)RemarkChange:(UITextField *)text{
    EntertainmentVisitorDeatil *model=[self.FormDatas.arr_ThirDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentVisitorDeatil *model=[[EntertainmentVisitorDeatil alloc]init];
        [self.FormDatas.arr_ThirDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Remark=text.text;
    }else{
        model.Remark=text.text;
    }
}

-(void)AddressChange:(UITextField *)text{
    EntertainmentSchDeatil *model=[self.FormDatas.arr_SecDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentSchDeatil *model=[[EntertainmentSchDeatil alloc]init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.EntertainAddr=text.text;
    }else{
        model.EntertainAddr=text.text;
    }
}
-(void)ContentChange:(UITextField *)text{
    EntertainmentSchDeatil *model=[self.FormDatas.arr_SecDetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        EntertainmentSchDeatil *model=[[EntertainmentSchDeatil alloc]init];
        [self.FormDatas.arr_SecDetailsDataArray insertObject:model atIndex:text.tag-100];
        model.EntertainContent=text.text;
    }else{
        model.EntertainContent=text.text;
    }
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    [self keyClose];
    NSString *title;
    if (btn.tag>=3200){
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除来访人员信息", nil),(long)(btn.tag-3200+1)];
    }else if (btn.tag>=2200) {
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除接待安排", nil),(long)(btn.tag-2200+1)];
    }else{
        title=[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除费用明细", nil),(long)(btn.tag-1200+1)];
    }
    _Aler_deleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:title delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    _Aler_deleteDetils.tag=btn.tag;
    [_Aler_deleteDetils show];
    
}

#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView==_Aler_deleteDetils) {
            if(alertView.tag>=3200){
                [self.FormDatas.arr_ThirDetailsDataArray removeObjectAtIndex:alertView.tag-3200];
                [self getEstimatedAmount];
                [self updateThirDetailsTableView];
            }else if (alertView.tag>=2200) {
                [self.FormDatas.arr_SecDetailsDataArray removeObjectAtIndex:alertView.tag-2200];
                [self updateSecDetailsTableView];
            }else{
                [self.FormDatas.arr_DetailsDataArray removeObjectAtIndex:alertView.tag-1200];
                NSString *TotalMoney=@"";
                for (EntertainmentDeatil *models in self.FormDatas.arr_DetailsDataArray) {
                    TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
                }
                _txf_Acount.text=TotalMoney;
                [self updateDetailsTableView];
            }
        }
    }
}

-(void)getEstimatedAmount{
    NSString *totol = @"0";
    for (EntertainmentVisitorDeatil *model in self.FormDatas.arr_ThirDetailsDataArray) {
        totol = [GPUtils decimalNumberAddWithString:totol with:model.BudgetAmt];
    }
    self.txf_Acount.text = totol;
    self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:self.txf_Acount.text with:([NSString isEqualToNull:self.FormDatas.str_ExchangeRate]?self.FormDatas.str_ExchangeRate:@"1.0000")]];
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
    
    self.FormDatas.SubmitData.Reason=self.txf_Reason.text;
    self.FormDatas.SubmitData.ReceptionObj=self.txf_Object.text;
    self.FormDatas.SubmitData.Visitor=self.txf_Visitor.text;
    self.FormDatas.SubmitData.ExpenseDesc=self.txf_CateDes.text;
    self.FormDatas.SubmitData.VisitDate=self.txf_StartTime.text;
    self.FormDatas.SubmitData.LeaveDate=self.txf_EndTime.text;
    
    self.FormDatas.SubmitData.RentCarFee=self.txf_RentCarFee.text;
    self.FormDatas.SubmitData.Pontage=self.txf_Pontage.text;
    self.FormDatas.SubmitData.MealFee=self.txf_MealFee.text;
    self.FormDatas.SubmitData.HotelFee=self.txf_HotelFee.text;
    self.FormDatas.SubmitData.OtherFee=self.txf_OtherFee.text;

    
    self.FormDatas.SubmitData.EstimatedAmount=[NSString isEqualToNull:_txf_Acount.text]?_txf_Acount.text:@"0";//(id)[NSNull null]
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
-(void)checkTravelReimSubmit{
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
