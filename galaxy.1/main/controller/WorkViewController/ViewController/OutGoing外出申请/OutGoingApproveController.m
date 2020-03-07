//
//  OutGoingApproveController.m
//  galaxy
//
//  Created by hfk on 2018/5/15.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "OutGoingApproveController.h"

@interface OutGoingApproveController ()

@end

@implementation OutGoingApproveController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[OutGoingFormData alloc]initWithStatus:3];
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
        self.FormDatas.str_flowCode=self.pushFlowCode;
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
    [self requestHasApp];
}

-(void)createDealBtns{
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==7) {
        [self createReCallBtn];
    }else if (self.FormDatas.int_comeStatus==3){
        [self saveAndSubmitBtn];
    }
}
//MARK:待审批按钮
-(void)saveAndSubmitBtn{
    if ([self.FormDatas.str_canEndorse isEqualToString:@"1"]) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf dockViewClick:1];
            }else if (index==1){
                [weakSelf dockViewClick:0];
            }else if (index==2){
                [weakSelf dockViewClick:2];
            }
        };
    }else{
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"退回", nil),Custing(@"同意", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf dockViewClick:0];
            }else if (index==1){
                [weakSelf dockViewClick:2];
            }
        };
    }
}
//MARK:撤回按钮
-(void)createReCallBtn{
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf reCallBack:nil];
        }
    };
}
//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    if (self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==7) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(@-50);
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
    }else{
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    self.contentView =[[BottomView alloc]init];
    self.contentView.userInteractionEnabled=YES;
    self.contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
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
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StartTime=[[UIView alloc]init];
    _View_StartTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StartTime];
    [_View_StartTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EndTime=[[UIView alloc]init];
    _View_EndTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EndTime];
    [_View_EndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StartTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OutTime=[[UIView alloc]init];
    _View_OutTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OutTime];
    [_View_OutTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ActualFromDate=[[UIView alloc]init];
    _View_ActualFromDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ActualFromDate];
    [_View_ActualFromDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OutTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ActualToDate=[[UIView alloc]init];
    _View_ActualToDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ActualToDate];
    [_View_ActualToDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ActualFromDate.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_ActualOutTime=[[UIView alloc]init];
    _View_ActualOutTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ActualOutTime];
    [_View_ActualOutTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ActualToDate.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OutPlace=[[UIView alloc]init];
    _View_OutPlace.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OutPlace];
    [_View_OutPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ActualOutTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Visitor=[[UIView alloc]init];
    _View_Visitor.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Visitor];
    [_View_Visitor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OutPlace.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Visitor.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Fellow=[[UIView alloc]init];
    _View_Fellow.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Fellow];
    [_View_Fellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CityTransFee=[[UIView alloc]init];
    _View_CityTransFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CityTransFee];
    [_View_CityTransFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Fellow.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EntertainmentFee=[[UIView alloc]init];
    _View_EntertainmentFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EntertainmentFee];
    [_View_EntertainmentFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CityTransFee.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_MealFee=[[UIView alloc]init];
    _View_MealFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_MealFee];
    [_View_MealFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EntertainmentFee.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherFee=[[UIView alloc]init];
    _View_OtherFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OtherFee];
    [_View_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MealFee.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalBudget=[[UIView alloc]init];
    _View_TotalBudget.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalBudget];
    [_View_TotalBudget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherFee.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalBudget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Remark];
    [_View_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
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

}

//MARK:-网络请求
//MARK:第一次打开表单和保存后打开表单接口
-(void)requestHasApp
{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:3 IfUserCache:NO];
}
//MARK:审批记录
-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getFlowChartUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:11 IfUserCache:NO];
}
//MARK:打印链接
-(void)GoToPush{
    self.PrintfBtn.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas PrintLinkUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:10 IfUserCache:NO];
}
//MARK:下载成功
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSLog(@"====%@",responceDic);
    self.FormDatas.dict_resultDict=responceDic;
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        self.dockView.userInteractionEnabled=YES;
        self.PrintfBtn.userInteractionEnabled=YES;
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"resultCode"]] isEqualToString:@"1001"]) {
            [self updateAprovalProcess:self.FormDatas.str_flowGuid WithProcId:[NSString stringWithFormat:@"%@",responceDic[@"procId"]]];
        }else{
            NSString * error = [responceDic objectForKey:@"msg"];
            if (![error isKindOfClass:[NSNull class]]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            }
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self.FormDatas DealWithFormBaseData];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormDatas.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            [self requestApproveNote];
        }
            break;
        case 2:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            if ([NSString isEqualToNull:successRespone]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            }else{
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"撤回成功", nil)];
            }
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goToReSubmit) userInfo:nil repeats:NO];
        }
            break;
        case 3:
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            [self createDealBtns];
            break;
        case 10:
        {
            self.PrintfBtn.userInteractionEnabled=YES;
            NSDictionary *dict=self.FormDatas.dict_resultDict[@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                     @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                     @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                     @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                     @"flowCode":self.FormDatas.str_flowCode,
                                                                     @"requestor":self.FormDatas.personalData.Requestor
                                                                     }]];
                
            }
        }
            break;
        case 11:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        default:
            break;
    }
    
}

//MARK:请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    self.dockView.userInteractionEnabled=YES;
    self.PrintfBtn.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
//MARK:撤回跳到重新提交
-(void)goToReSubmit{
    self.dockView.userInteractionEnabled=YES;
    [self goToReSubmitWithModel:self.FormDatas];
}

//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];

    [_FormRelatedView initFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithBaseModel:self.FormDatas Withcontroller:self];

    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OutTypeId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateOutTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateStartTimeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ToDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEndTimeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OutTime"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateOutTimeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ActualFromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateActualFromDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ActualToDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateActualToDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ActualOutTime"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateActualOutTimeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OutLocation"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateOutLocationViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VisitObject"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateVisitObjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EntourageId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEntourageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CityTransFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCityTransFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EntertainmentFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateEntertainmentFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"MealFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateMealFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OtherFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateOtherFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalBudget"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateTotalBudgetViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    [self updateContentView];
}

//MARK:外出原因
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Reason addSubview:view];
}
//MARK:外出类型
-(void)updateOutTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_OutType}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId=weakSelf.FormDatas.str_OutTypeId;
        vc.ChooseModel=model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.txf_Type.text=model.name;
            weakSelf.FormDatas.str_OutType=model.name;
            weakSelf.FormDatas.str_OutTypeId=model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_OutTypeId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_Type addSubview:view];
}
//MARK:外出开始区间
-(void)updateStartTimeViewWithModel:(MyProcurementModel *)model{
    _txf_StartTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StartTime WithContent:_txf_StartTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.txf_OutTime.text=[NSDate DateDuringFromTime:selectTime to:weakSelf.txf_EndTime.text WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:1];
    }];
    [_View_StartTime addSubview:view];
}
//MARK:外出结束区间
-(void)updateEndTimeViewWithModel:(MyProcurementModel *)model{
    _txf_EndTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndTime WithContent:_txf_EndTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.txf_OutTime.text=[NSDate DateDuringFromTime:weakSelf.txf_StartTime.text to:selectTime WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:1];
    }];
    [_View_EndTime addSubview:view];
}
//MARK:外出时长
-(void)updateOutTimeViewWithModel:(MyProcurementModel *)model{
    _txf_OutTime=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OutTime WithContent:_txf_OutTime WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_OutTime addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_OutTime.text=[GPUtils removeFloatAllZero:[NSString stringWithFormat:@"%@",model.fieldValue]];
    }
}

//MARK:外出实际开始区间
-(void)updateActualFromDateViewWithModel:(MyProcurementModel *)model{
    _txf_ActualFromDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ActualFromDate WithContent:_txf_ActualFromDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.txf_ActualOutTime.text=[NSDate DateDuringFromTime:selectTime to:weakSelf.txf_ActualToDate.text WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:1];
    }];
    [_View_ActualFromDate addSubview:view];
}
//MARK:外出实际结束区间
-(void)updateActualToDateViewWithModel:(MyProcurementModel *)model{
    _txf_ActualToDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ActualToDate WithContent:_txf_ActualToDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.txf_ActualOutTime.text=[NSDate DateDuringFromTime:weakSelf.txf_ActualFromDate.text to:selectTime WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:1];
    }];
    [_View_ActualToDate addSubview:view];
}
//MARK:外出实际时长
-(void)updateActualOutTimeViewWithModel:(MyProcurementModel *)model{
    _txf_ActualOutTime=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ActualOutTime WithContent:_txf_ActualOutTime WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ActualOutTime addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_ActualOutTime.text=[GPUtils removeFloatAllZero:[NSString stringWithFormat:@"%@",model.fieldValue]];
    }
}
//MARK:外出地点
-(void)updateOutLocationViewWithModel:(MyProcurementModel *)model{
    _txf_OutPlace=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OutPlace WithContent:_txf_OutPlace WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_OutPlace addSubview:view];
}
//MARK:外出对象
-(void)updateVisitObjectViewWithModel:(MyProcurementModel *)model{
    _txf_Visitor=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Visitor WithContent:_txf_Visitor WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Visitor addSubview:view];
}
//MARK:外出同行人员
-(void)updateEntourageViewWithModel:(MyProcurementModel *)model{
    _txf_Fellow = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Fellow WithContent:_txf_Fellow WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.FormDatas.str_Entourage}];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf EntourageClick];
    }];
    [_View_Fellow addSubview:view];
    if ([NSString isEqualToNullAndZero:model.fieldValue]) {
        self.FormDatas.str_EntourageId=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
}
//MARK:市内交通
-(void)updateCityTransFeeViewWithModel:(MyProcurementModel *)model{
    _txf_CityTransFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CityTransFee WithContent:_txf_CityTransFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_CityTransFee addSubview:view];
}
//MARK:业务招待
-(void)updateEntertainmentFeeViewWithModel:(MyProcurementModel *)model{
    _txf_EntertainmentFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EntertainmentFee WithContent:_txf_EntertainmentFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_EntertainmentFee addSubview:view];
}
//MARK:误餐费
-(void)updateMealFeeViewWithModel:(MyProcurementModel *)model{
    _txf_MealFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_MealFee WithContent:_txf_MealFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_MealFee addSubview:view];
}
//MARK:其他费用
-(void)updateOtherFeeViewWithModel:(MyProcurementModel *)model{
    _txf_OtherFee=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_OtherFee WithContent:_txf_OtherFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        [weakSelf getTotalBudgetAmount];
    }];
    [_View_OtherFee addSubview:view];
}
//MARK:合计
-(void)updateTotalBudgetViewWithModel:(MyProcurementModel *)model{
    _txf_TotalBudget=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_TotalBudget WithContent:_txf_TotalBudget WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TotalBudget addSubview:view];
}
//MARK:合计预算金额计算
-(void)getTotalBudgetAmount{
    NSString *totol = @"0";
    totol = [GPUtils decimalNumberAddWithString:self.txf_CityTransFee.text with:self.txf_EntertainmentFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_MealFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_OtherFee.text];
    self.txf_TotalBudget.text = totol;
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
    model.Description=Custing(@"审批人", nil);
    model.fieldValue=@"";
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Approve WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.View_ApproveImg=image;
        [self SecondApproveClick];
    }];
    [_View_Approve addSubview:view];
}
//MARK:更新滚动视图
-(void)updateContentView{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Approve.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
}
//MARK:修改同行人员
-(void)EntourageClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"3";
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_EntourageId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactVC.arrClickPeople =array;
    contactVC.menutype=2;
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
        weakSelf.FormDatas.str_EntourageId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.FormDatas.str_Entourage=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_Fellow.text=weakSelf.FormDatas.str_Entourage;
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

-(void)SecondApproveClick{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.FormDatas.str_twoHandeId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"1";
    contactVC.Radio = @"1";
    contactVC.arrClickPeople = array;
    contactVC.itemType = 16;
    contactVC.menutype=4;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        self.FormDatas.str_twoApprovalName = bul.requestor;
        self.FormDatas.str_twoHandeId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.txf_Approver.text= bul.requestor;
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
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

//MARK:撤回操作
-(void)reCallBack:(id)btn{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
}
//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    if (type == 2) {
        [self.FormDatas inModelHasApproveContent];
        [self configModelOtherData];
        [self.FormDatas contectData];
        [self dealWithImagesArray];
    }else{
        examineViewController *vc=[[examineViewController alloc]init];
        vc.ProcId=self.FormDatas.str_procId;
        vc.TaskId=self.FormDatas.str_taskId;
        vc.FlowCode=self.FormDatas.str_flowCode;
        vc.Type=[NSString stringWithFormat:@"%ld",(long)type];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)configModelOtherData{
    self.FormDatas.SubmitData.Reason=_txv_Reason.text;
    self.FormDatas.SubmitData.FromDate=_txf_StartTime.text;
    self.FormDatas.SubmitData.ToDate=_txf_EndTime.text;
    self.FormDatas.SubmitData.OutTime=_txf_OutTime.text;
    self.FormDatas.SubmitData.OutLocation=_txf_OutPlace.text;
    self.FormDatas.SubmitData.VisitObject=_txf_Visitor.text;
    self.FormDatas.SubmitData.ActualFromDate=_txf_ActualFromDate.text;
    self.FormDatas.SubmitData.ActualToDate=_txf_ActualToDate.text;
    self.FormDatas.SubmitData.ActualOutTime=_txf_ActualOutTime.text;
    self.FormDatas.SubmitData.CityTransFee=_txf_CityTransFee.text;
    self.FormDatas.SubmitData.EntertainmentFee=_txf_EntertainmentFee.text;
    self.FormDatas.SubmitData.MealFee=_txf_MealFee.text;
    self.FormDatas.SubmitData.OtherFee=_txf_OtherFee.text;
    self.FormDatas.SubmitData.TotalBudget=_txf_TotalBudget.text;
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
}

//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:STAFFOUTLoadImage WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.dockView.userInteractionEnabled=YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:1.0];
        }else{
            weakSelf.FormDatas.str_imageDataString=data;
            [weakSelf.FormDatas addImagesInfo];
            [weakSelf readySubmitAndSave];
        }
    }];
}
-(void)readySubmitAndSave{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.ProcId=self.FormDatas.str_procId;
    vc.TaskId=self.FormDatas.str_taskId;
    vc.FlowCode=self.FormDatas.str_flowCode;
    vc.Type=@"2";
    vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
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
