//
//  AskingLeaveController.m
//  galaxy
//
//  Created by hfk on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "AskingLeaveController.h"

@implementation AskingLeaveController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[MyAskLeaveFormData alloc]initWithStatus:1];
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
}
//MARK:创建主视图
-(void)createMainView{
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
   
    _View_Type = [[UIView alloc]init];
    _View_Type.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LeaveHoliday=[[UIView alloc]init];
    _View_LeaveHoliday.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_LeaveHoliday];
    [_View_LeaveHoliday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StartTime=[[UIView alloc]init];
    _View_StartTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StartTime];
    [_View_StartTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LeaveHoliday.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_StartNoon=[[UIView alloc]init];
    _View_StartNoon.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_StartNoon];
    [_View_StartNoon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StartTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_EndTime=[[UIView alloc]init];
    _View_EndTime.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EndTime];
    [_View_EndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_StartNoon.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_EndNoon=[[UIView alloc]init];
    _View_EndNoon.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_EndNoon];
    [_View_EndNoon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndTime.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LeaveTolDay =[[UIView alloc]init];
    _View_LeaveTolDay.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LeaveTolDay];
    [_View_LeaveTolDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndNoon.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Reason];
    [_View_Reason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LeaveTolDay.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
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
//MARK:第一次打开请假表单
-(void)getFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas OpenFormUrl] Parameters:[self.FormDatas OpenFormParameters] Delegate:self SerialNum:0 IfUserCache:NO];
}
//MARK:获取审批记录
-(void)requestApproveNote{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas ApproveNoteUrl] Parameters:[self.FormDatas ApproveNoteOrFlowChartOrPushLinkParameters] Delegate:self SerialNum:7 IfUserCache:NO];
}
//MARK:获取调休情况假期
-(void)requestResidueHoliday{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas HolidayUrl] Parameters:[self.FormDatas HolidayParametersWithFromDate:self.txf_StartTime.text] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:获取日历
-(void)requestLeaveCalendar{
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas LeaveCalendarUrl] Parameters:[self.FormDatas LeaveCalendarParameters] Delegate:self SerialNum:4 IfUserCache:NO];
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
            [self requestResidueHoliday];
        }
            break;
        case 1:
        {
            [self.FormDatas getHolidayDaysInfoWithDict:responceDic];
            if (self.FormDatas.bool_firstRequest) {
                if (self.FormDatas.int_comeStatus==3){
                    [self requestApproveNote];
                }else{
                    [self updateMainView];
                    if (self.FormDatas.int_comeStatus == 1) {
                        [self getAskLeaveDays];
                    }
                    [self createDealBtns];
                }
                self.FormDatas.bool_firstRequest=NO;
            }else{
                [self updateLeaveHolidayView];
                [self getAskLeaveDays];
            }
        }
            break;
        case 2:
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
        case 4:
        {
            [self.FormDatas getWorkCalendarWithDict:responceDic];
            [self.FormDatas getAskLeaveTotolDays];
            self.txf_LeaveTolDay.text=self.FormDatas.str_TotolDays;
        }
            break;
        case 7:
        {
            [self.FormDatas getApproveNoteData];
            [self updateMainView];
            if (self.FormDatas.int_comeStatus == 1) {
                [self getAskLeaveDays];
            }
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
    __weak typeof(self) weakSelf = self;
    _SubmitPersonalView.SubmitPersonalViewBackBlock = ^(id backObj) {
        [weakSelf requestResidueHoliday];
    };
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"ProjId"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateProjectViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LeaveType"]) {
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateLeaveTypeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FromDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateStartTimeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"FromTime"]){
            if (self.FormDatas.int_LeaveTimeType == 2) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateFromNoonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ToDate"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateEndTimeViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"ToTime"]){
            if (self.FormDatas.int_LeaveTimeType == 2) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateToNoonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"TotalDays"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateLeaveTolDayViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reason"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateReasonViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Attachments"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateAttachImgViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                [self updateReservedViewWithModel:model];
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
    [self updateLeaveHolidayView];
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    [self updateContentView];
    [self.FormDatas getEndShowArray];
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
//MARK:更新请假类型
-(void)updateLeaveTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Type=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Type WithContent:_txf_Type WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf TypeClick];
    }];
    [_View_Type addSubview:view];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_Type.text=model.fieldValue;
        self.FormDatas.str_LeaveType=model.fieldValue;
    }
}
-(void)updateLeaveHolidayView{
    if (!_lab_LeaveHoliday) {
        _lab_LeaveHoliday=[GPUtils createLable:CGRectZero text:nil font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_LeaveHoliday.numberOfLines=0;
        [_View_LeaveHoliday addSubview:_lab_LeaveHoliday];
        [_lab_LeaveHoliday makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_LeaveHoliday.top).offset(@10);
            make.left.equalTo(self.View_LeaveHoliday.left).offset(@12);
            make.right.equalTo(self.View_LeaveHoliday.right).offset(@-12);
            make.bottom.equalTo(self.View_LeaveHoliday.bottom);
        }];
    }
    if ([self.FormDatas.dict_HolidayStatus[@"totalDays"] floatValue]!=0) {
        
        NSString *title=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@ : %@",[self.FormDatas.dict_HolidayStatus[@"leaveInLieu"] floatValue]==1?Custing(@"调休天数", nil):[NSString stringWithFormat:@"%@%@",self.FormDatas.str_LeaveType,Custing(@"天数", nil)],[NSString stringWithIdOnNO:self.FormDatas.dict_HolidayStatus[@"totalDays"]]],[NSString stringWithFormat:@"%@ : %@",Custing(@"已用天数", nil),[NSString stringWithIdOnNO:self.FormDatas.dict_HolidayStatus[@"usedDays"]]],[NSString stringWithFormat:@"%@ : %@",Custing(@"剩余天数", nil),[NSString stringWithIdOnNO:self.FormDatas.dict_HolidayStatus[@"remainingDays"]]]] WithCompare:@"    "];
        
        CGSize size = [title sizeCalculateWithFont:Font_Same_14_20 constrainedToSize:CGSizeMake(Main_Screen_Width-24, 10000) lineBreakMode:NSLineBreakByCharWrapping];
        [_View_LeaveHoliday updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(size.height+10));
        }];
        _lab_LeaveHoliday.text=title;
    }else{
        [_View_LeaveHoliday updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
//MARK:开始时间
-(void)updateStartTimeViewWithModel:(MyProcurementModel *)model{
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSString *DateFormat = self.FormDatas.int_LeaveTimeType == 2 ? @"yyyy/MM/dd":@"yyyy/MM/dd HH:mm";
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter *Formatter = [[NSDateFormatter alloc]init];
        Formatter.timeZone = [NSTimeZone localTimeZone];
        [Formatter setDateFormat:DateFormat];
        NSString *currDateStr= [NSString stringWithFormat:@"%@",[Formatter stringFromDate:pickerDate]];
        model.fieldValue=currDateStr;
    }else{
        NSString *str=model.fieldValue;
        if (self.FormDatas.int_LeaveTimeType == 2) {
            model.fieldValue = model.fieldValue;
        }else{
            model.fieldValue=[model.fieldValue substringToIndex:str.length-3];
        }
    }
    self.FormDatas.str_FromDate=model.fieldValue;
    
    _txf_StartTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StartTime WithContent:_txf_StartTime WithFormType:self.FormDatas.int_LeaveTimeType == 2 ? formViewSelectDate:formViewSelectYearDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_FromDate=selectTime;
        weakSelf.FormDatas.str_WcStartTime=[weakSelf.FormDatas getYearMonthDayWithString:weakSelf.FormDatas.str_FromDate];
        [weakSelf requestResidueHoliday];
    }];
    [_View_StartTime addSubview:view];
    
    self.FormDatas.str_WcStartTime=[self.FormDatas getYearMonthDayWithString:self.FormDatas.str_FromDate];
}
//MARK:更新开始日期上下午
-(void)updateFromNoonViewWithModel:(MyProcurementModel *)model{
    if (![NSString isEqualToNull:model.fieldValue]) {
        model.fieldValue = Custing(@"上午", nil);
        self.FormDatas.str_FromNoon = @"1";
    }else{
        if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
            model.fieldValue = Custing(@"上午", nil);
            self.FormDatas.str_FromNoon = @"1";
        }else{
            model.fieldValue = Custing(@"下午", nil);
            self.FormDatas.str_FromNoon = @"2";
        }
    }
    _txf_StartNoon=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_StartNoon WithContent:_txf_StartNoon WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_FromNoon=Model.Id;
            weakSelf.txf_StartNoon.text=Model.Type;
            [weakSelf getAskLeaveDays];
        }];
        picker.typeTitle=Custing(@"上/下午", nil);
        picker.DateSourceArray=weakSelf.FormDatas.arr_TimeNoon;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=weakSelf.FormDatas.str_FromNoon;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_StartNoon addSubview:view];
}

//MARK:结束时间
-(void)updateEndTimeViewWithModel:(MyProcurementModel *)model{
    if (![NSString isEqualToNull:model.fieldValue]) {
        NSString *DateFormat = self.FormDatas.int_LeaveTimeType == 2 ? @"yyyy/MM/dd":@"yyyy/MM/dd HH:mm";
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter *Formatter = [[NSDateFormatter alloc]init];
        Formatter.timeZone = [NSTimeZone localTimeZone];
        [Formatter setDateFormat:DateFormat];
        NSString *currDateStr= [NSString stringWithFormat:@"%@",[Formatter stringFromDate:pickerDate]];
        model.fieldValue=currDateStr;
    }else{
        NSString *str=model.fieldValue;
        if (self.FormDatas.int_LeaveTimeType == 2) {
            model.fieldValue = model.fieldValue;
        }else{
            model.fieldValue=[model.fieldValue substringToIndex:str.length-3];
        }
    }
    self.FormDatas.str_ToDate=model.fieldValue;
    
    _txf_EndTime=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndTime WithContent:_txf_EndTime WithFormType:self.FormDatas.int_LeaveTimeType == 2 ? formViewSelectDate:formViewSelectYearDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.FormDatas.str_ToDate=selectTime;
        weakSelf.FormDatas.str_WcEndTime=[weakSelf.FormDatas getYearMonthDayWithString:weakSelf.FormDatas.str_ToDate];
        [weakSelf getAskLeaveDays];
    }];
    [_View_EndTime addSubview:view];
    
    self.FormDatas.str_WcEndTime=[self.FormDatas getYearMonthDayWithString:self.FormDatas.str_ToDate];
}
//MARK:更新结束日期上下午
-(void)updateToNoonViewWithModel:(MyProcurementModel *)model{
    
    if (![NSString isEqualToNull:model.fieldValue]) {
        model.fieldValue = Custing(@"上午", nil);
        self.FormDatas.str_ToNoon = @"1";
    }else{
        if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
            model.fieldValue = Custing(@"上午", nil);
            self.FormDatas.str_ToNoon = @"1";
        }else{
            model.fieldValue = Custing(@"下午", nil);
            self.FormDatas.str_ToNoon = @"2";
        }
    }
    _txf_EndNoon=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_EndNoon WithContent:_txf_EndNoon WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.FormDatas.str_ToNoon=Model.Id;
            weakSelf.txf_EndNoon.text=Model.Type;
            [weakSelf getAskLeaveDays];
        }];
        picker.typeTitle=Custing(@"上/下午", nil);
        picker.DateSourceArray=weakSelf.FormDatas.arr_TimeNoon;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=weakSelf.FormDatas.str_ToNoon;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_View_EndNoon addSubview:view];
    
}
//MARK:更新请假天数
-(void)updateLeaveTolDayViewWithModel:(MyProcurementModel *)model{
    _txf_LeaveTolDay=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_LeaveTolDay WithContent:_txf_LeaveTolDay WithFormType:formViewEnterDays WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *text) {
        weakSelf.FormDatas.str_TotolDays = text;
    }];
    [_View_LeaveTolDay addSubview:view];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_LeaveTolDay.text = [GPUtils removeFloatAllZero:[NSString stringWithFormat:@"%@",model.fieldValue]];
        self.FormDatas.str_TotolDays = [GPUtils removeFloatAllZero:[NSString stringWithFormat:@"%@",model.fieldValue]];
    }
}


//MARK:更新请假事由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txv_Reason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Reason WithContent:_txv_Reason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Reason addSubview:view];
}

//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:1 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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
//MARK:请假类型选择
-(void)TypeClick{
    NSLog(@"请假类型选择");
    [self keyClose];
    ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"LeaveType"];
    vc.ChooseCategoryId=self.FormDatas.str_LeaveTypeId;
    __weak typeof(self) weakSelf = self;
    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
        ChooseCateFreModel *model = array[0];
        weakSelf.FormDatas.str_LeaveTypecCode=model.leaveCode;
        weakSelf.FormDatas.str_LeaveTypeId=model.Id;
        weakSelf.FormDatas.str_LeaveType=model.leaveType;
        weakSelf.FormDatas.str_LimitDay=model.limitDay;
        weakSelf.txf_Type.text=model.leaveType;
        [weakSelf requestResidueHoliday];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getAskLeaveDays{
    
    NSString *during=[self.FormDatas DateDuring];
    if (during) {
        if ([self.FormDatas.dict_HolidayStatus[@"workType"] floatValue]==0) {
            [self.FormDatas getAskLeaveTotolDays];
            self.txf_LeaveTolDay.text=self.FormDatas.str_TotolDays;
        }else{
            [self requestLeaveCalendar];
        }
    }else{
        self.FormDatas.str_TotolDays=@"";
        self.txf_LeaveTolDay.text=self.FormDatas.str_TotolDays;
        [self.FormDatas.arr_SubmitDaysArray removeAllObjects];
    }
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
    contactVC.itemType =4;
    contactVC.Radio = @"1";
    contactVC.universalDelegate = self;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.txf_Approver.text=bul.requestor;
        weakSelf.FormDatas.str_firstHanderName=bul.requestor;
        weakSelf.FormDatas.str_firstHanderId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                weakSelf.FormDatas.str_firstHanderPhotoGraph=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                [weakSelf.View_ApproveImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.FormDatas.str_firstHanderPhotoGraph]];
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
//MARK:保存操作
-(void)saveInfo{
    [self keyClose];
    NSLog(@"请假保存操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=1;
    [self mainDataList];
}
//MARK:提交操作
-(void)submitInfo{
    [self keyClose];
    NSLog(@"请假提交操作");
    self.dockView.userInteractionEnabled=NO;
    self.FormDatas.int_SubmitSaveType=2;
    [self mainDataList];
}
//MARK:直送操作
-(void)directInfo
{
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
    if (self.FormDatas.int_SubmitSaveType==2||self.FormDatas.int_SubmitSaveType==3){
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
    
    self.FormDatas.SubmitData.TotalDays=self.txf_LeaveTolDay.text;
    self.FormDatas.SubmitData.Reason=_txv_Reason.text;
}

//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:AskingLeaveLoadImage WithBlock:^(id data, BOOL hasError) {
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
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas getSaveUrl] Parameters:[self.FormDatas SaveFormDateWithExpIds:@"" WithComment:@"" WithCommonField:@""] Delegate:self SerialNum:2 IfUserCache:NO];
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

@end
