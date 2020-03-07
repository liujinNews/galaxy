//
//  PerformanceNewController.m
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceNewController.h"
#import "PerformanceDetailCell.h"
@interface PerformanceNewController ()

@end

@implementation PerformanceNewController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[PerformanceFormData alloc]initWithStatus:1];
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
    if (self.FormDatas.int_comeStatus==1) {
        [self setTitle:self.FormDatas.str_TypeName backButton:YES];
    }else{
        [self setTitle:nil backButton:YES];
    }
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
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _View_tableScore=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_tableScore.backgroundColor=Color_WhiteWeak_Same_20;
    _View_tableScore.delegate=self;
    _View_tableScore.dataSource=self;
    _View_tableScore.scrollEnabled=NO;
    _View_tableScore.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_tableScore];
    [_View_tableScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Score=[[UIView alloc]init];
    _View_Score.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Score];
    [_View_Score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_tableScore.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ChooseDate=[[UIView alloc]init];
    _View_ChooseDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ChooseDate];
    [_View_ChooseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Score.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Appraise=[[UIView alloc]init];
    _View_Appraise.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Appraise];
    [_View_Appraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ChooseDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Appraise.bottom);
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
            if (self.FormDatas.int_comeStatus!=1) {
                self.navigationItem.title = [NSString isEqualToNull:self.FormDatas.str_TypeName]?[NSString stringWithFormat:@"%@",self.FormDatas.str_TypeName]:@"";
            }
            if (self.FormDatas.int_comeStatus==3){
                [self requestApproveNote];
            }else{
                [self.FormDatas dealTheScoreViewShowSetting];
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
            [self.FormDatas dealTheScoreViewShowSetting];
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
    if (self.FormDatas.int_comeStatus==1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)goSubmitSuccessTo:(NSTimer *)timer{
    self.dockView.userInteractionEnabled = YES;
    [self goSubmitSuccessToWithModel:self.FormDatas];

}
//MARK:视图更新
-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:self.FormDatas.arr_FormMainArray WithRequireDict:self.FormDatas.dict_isRequiredmsdic WithUnShowArray:self.FormDatas.arr_UnShowmsArray WithSumbitBaseModel:self.FormDatas Withcontroller:self];
    __weak typeof(self) weakSelf = self;
    _SubmitPersonalView.SubmitPersonalViewBackBlock = ^(id backObj) {
        NSDictionary *SelectDict=(NSDictionary *)backObj;
        if ([SelectDict[@"formFields"]isKindOfClass:[NSDictionary class]]) {
            if ([SelectDict[@"formFields"][@"mainFld"]isKindOfClass:[NSArray class]]) {
                NSArray *arr=SelectDict[@"formFields"][@"mainFld"];
                if (arr.count>0) {
                    for (NSDictionary *dict in arr) {
                        if ([dict[@"fieldName"]isEqualToString:@"PerformanceYear"]) {
                            weakSelf.FormDatas.str_PerformanceYear=[NSString stringWithIdOnNO:dict[@"fieldValue"]];
                        }else if ([dict[@"fieldName"]isEqualToString:@"PerformanceMth"]){
                            weakSelf.FormDatas.str_PerformanceMth=[NSString stringWithIdOnNO:dict[@"fieldValue"]];
                        }else if ([dict[@"fieldName"]isEqualToString:@"PerformanceQuarter"]){
                            weakSelf.FormDatas.str_PerformanceQuarter=[NSString stringWithIdOnNO:dict[@"fieldValue"]];
                        }
                    }
                    if (weakSelf.FormDatas.int_performanceTime==1){
                        weakSelf.txf_ChooseDate.text=[GPUtils getSelectResultWithArray:@[weakSelf.FormDatas.str_PerformanceYear,weakSelf.FormDatas.str_PerformanceQuarter]];
                        weakSelf.FormDatas.str_PerformanceMth=@"";
                    }else if (weakSelf.FormDatas.int_performanceTime==2){
                        weakSelf.txf_ChooseDate.text=[GPUtils getSelectResultWithArray:@[weakSelf.FormDatas.str_PerformanceYear,weakSelf.FormDatas.str_PerformanceMth]];
                        weakSelf.FormDatas.str_PerformanceQuarter=@"";
                    }
                }
            }
        }
    };
    
    if (self.FormDatas.arr_DetailsDataArray.count>0) {
        [self updateTableView];
    }
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"SelfTotalScore"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_EditType==1) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateScoreViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LeaderTotalScore"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_EditType==2) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updateScoreViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceMth"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==2) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatChooseDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceQuarter"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==1) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatChooseDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceYear"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==0) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatChooseDateViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"SelfComment"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_EditType ==1) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatAppraiseViewWithModel:model];
                [self.FormDatas.arr_UnShowmsArray removeObject:model.fieldName];
            }
        }else if ([model.fieldName isEqualToString:@"LeaderComment"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_EditType==2) {
                [self.FormDatas.dict_isRequiredmsdic setValue:model.isRequired forKey:model.fieldName];
                [self updatAppraiseViewWithModel:model];
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
    if (self.FormDatas.arr_noteDateArray.count>=2&&self.FormDatas.int_comeStatus==3) {
        [self updateNotesTableView];
    }
    [self updateContentView];
    [self.FormDatas getEndShowArray];
    [self getTotalScore];
}
//MARK:更新
-(void)updateTableView{
    NSInteger heigth=0;
    for (PerformanceDetail *model in self.FormDatas.arr_DetailsDataArray) {
        heigth+=27;
        NSMutableArray *arr=model.performanceDetailItem;
        for (int i=0; i<arr.count; i++) {
            PerformanceDetailSub *subModel=arr[i];
            heigth+=[PerformanceDetailCell cellHeightWithObj:subModel IsLast:(i==arr.count-1)];
        }
    }
    [_View_tableScore updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heigth));
    }];
    [_View_tableScore reloadData];
}
//MARK:更新评价分数视图
-(void)updateScoreViewWithModel:(MyProcurementModel *)model{
    [_View_Score updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
    }];
    UIView *SegmentLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    SegmentLineView.backgroundColor=Color_White_Same_20;
    [_View_Score addSubview:SegmentLineView];
    
    UIImageView *bottomLine=[GPUtils createImageViewFrame:CGRectMake(0, 99.5, Main_Screen_Width, 0.5) imageName:nil];
    bottomLine.backgroundColor=Color_GrayLight_Same_20;
    [_View_Score addSubview:bottomLine];
    
    UILabel *titleLab=[GPUtils createLable:CGRectMake(0, 60, Main_Screen_Width, 15) text:[NSString stringWithFormat:@"%@",model.Description] font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    [_View_Score addSubview:titleLab];
    
    if (self.FormDatas.int_EditType==1) {
        self.Lab_SelfScore=[GPUtils createLable:CGRectMake(0, 35, Main_Screen_Width, 25) text:[NSString stringWithFormat:@"%@",model.fieldValue] font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
        [_View_Score addSubview:self.Lab_SelfScore];
    }else if (self.FormDatas.int_EditType==2){
        self.Lab_LeaderScore=[GPUtils createLable:CGRectMake(0, 35, Main_Screen_Width, 25) text:[NSString stringWithFormat:@"%@",model.fieldValue] font:Font_Amount_21_20 textColor:Color_Green_Weak_20 textAlignment:NSTextAlignmentCenter];
        [_View_Score addSubview:self.Lab_LeaderScore];
    }
}
//MARK:更新评价月季度年视图
-(void)updatChooseDateViewWithModel:(MyProcurementModel *)model{
    _txf_ChooseDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ChooseDate WithContent:_txf_ChooseDate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf chooseDate];
    }];
    [_View_ChooseDate addSubview:view];
    if (self.FormDatas.int_performanceTime==1){
        _txf_ChooseDate.text=[GPUtils getSelectResultWithArray:@[self.FormDatas.str_PerformanceYear,self.FormDatas.str_PerformanceQuarter]];
    }else if (self.FormDatas.int_performanceTime==2){
        _txf_ChooseDate.text=[GPUtils getSelectResultWithArray:@[self.FormDatas.str_PerformanceYear,self.FormDatas.str_PerformanceMth]];
    }
}
//MARK:更新评价视图
-(void)updatAppraiseViewWithModel:(MyProcurementModel *)model{
    _txv_Appraise=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Appraise WithContent:_txv_Appraise WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_View_Appraise addSubview:view];
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
    //    [_View_CcToPeople addSubview:[[ExmineApproveView alloc]initWithBaseView:_View_CcToPeople Withmodel:model WithInfodict:@{@"array":self.FormDatas.arr_CcToArr}]];
    
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
//MARK:选择评价月季度年
-(void)chooseDate{
    STNewPickView *picker = [[STNewPickView alloc]init];
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STNewPickModel *firstModel, STNewPickSubModel *secondModel, NSInteger type) {
        if (weakSelf.FormDatas.int_performanceTime==0) {
            weakSelf.FormDatas.str_PerformanceYear=firstModel.Type;
            weakSelf.txf_ChooseDate.text=firstModel.Type;
        }else if (weakSelf.FormDatas.int_performanceTime==1){
            weakSelf.FormDatas.str_PerformanceYear=firstModel.Type;
            weakSelf.FormDatas.str_PerformanceQuarter=secondModel.Type;
            weakSelf.txf_ChooseDate.text=[NSString stringWithFormat:@"%@/%@",firstModel.Type,secondModel.Type];
        }else if (weakSelf.FormDatas.int_performanceTime==2){
            weakSelf.FormDatas.str_PerformanceYear=firstModel.Type;
            weakSelf.FormDatas.str_PerformanceMth=secondModel.Type;
            weakSelf.txf_ChooseDate.text=[NSString stringWithFormat:@"%@/%@",firstModel.Type,secondModel.Type];
        }
    }];
    if (self.FormDatas.int_performanceTime==0) {
        picker.int_compRows=1;
        picker.typeTitle=Custing(@"年sel", nil);
        picker.DateSourceArray=[NSMutableArray arrayWithArray:[STNewPickModel getYearDataArray]];
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString isEqualToNull:self.FormDatas.str_PerformanceYear]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PerformanceYear]:@"";
        picker.first_Model=model;
    }else if (self.FormDatas.int_performanceTime==1){
        picker.int_compRows=2;
        picker.typeTitle=Custing(@"年/季度", nil);
        picker.DateSourceArray=[NSMutableArray arrayWithArray:[STNewPickModel getYearQuarterDataArray]];
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString isEqualToNull:self.FormDatas.str_PerformanceYear]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PerformanceYear]:@"";
        picker.first_Model=model;
        
        STNewPickSubModel *sub=[[STNewPickSubModel alloc]init];
        sub.Type=[NSString isEqualToNull:self.FormDatas.str_PerformanceQuarter]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PerformanceQuarter]:@"";
        picker.second_Model=sub;
    }else if (self.FormDatas.int_performanceTime==2){
        picker.int_compRows=2;
        picker.typeTitle=Custing(@"年/月", nil);
        picker.DateSourceArray=[NSMutableArray arrayWithArray:[STNewPickModel getYearMonthDataArray]];
        STNewPickModel *model=[[STNewPickModel alloc]init];
        model.Type=[NSString isEqualToNull:self.FormDatas.str_PerformanceYear]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PerformanceYear]:@"";
        picker.first_Model=model;
        
        STNewPickSubModel *sub=[[STNewPickSubModel alloc]init];
        sub.Type=[NSString isEqualToNull:self.FormDatas.str_PerformanceMth]?[NSString stringWithFormat:@"%@",self.FormDatas.str_PerformanceMth]:@"";
        picker.second_Model=sub;
    }
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
    contactVC.itemType = 22;
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

#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.FormDatas.arr_DetailsDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PerformanceDetail *model=self.FormDatas.arr_DetailsDataArray[section];
    NSMutableArray *arr=model.performanceDetailItem;
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceDetail *model=self.FormDatas.arr_DetailsDataArray[indexPath.section];
    NSMutableArray *arr=model.performanceDetailItem;
    PerformanceDetailSub *subModel=arr[indexPath.row];
    return [PerformanceDetailCell cellHeightWithObj:subModel IsLast:(indexPath.row==arr.count-1)];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PerformanceDetailCell"];
    if (cell==nil) {
        cell=[[PerformanceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PerformanceDetailCell"];
    }
    cell.IndexPath=indexPath;
    __weak typeof(self) weakSelf = self;
    
    [cell setScoreChangeBlock:^(NSInteger type) {
        [weakSelf getTotalScore];
    }];
    [cell configCellWithDataArray:self.FormDatas.arr_DetailsDataArray WithType:self.FormDatas.int_EditType];
    return cell;
}
#pragma mar-创建tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _View_head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    _View_head.backgroundColor=Color_White_Same_20;
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_head addSubview:ImgView];
    
    PerformanceDetail *model=self.FormDatas.arr_DetailsDataArray[section];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, 27) text:[GPUtils getSelectResultWithArray:@[model.weightName,model.weight] WithCompare:@":"] font:Font_Same_14_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_head addSubview:titleLabel];
}
-(void)getTotalScore{
    [self.FormDatas getTheTotalScore];
    self.Lab_SelfScore.text=self.FormDatas.str_SelfTotalScore;
    self.Lab_LeaderScore.text=self.FormDatas.str_LeaderTotalScore;
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
    self.FormDatas.SubmitData.Remark=_txv_Remark.text;
    if (self.FormDatas.int_EditType==1) {
        self.FormDatas.SubmitData.SelfComment=_txv_Appraise.text;
        self.FormDatas.SubmitData.LeaderComment=@"";
    }else if(self.FormDatas.int_EditType==2){
        self.FormDatas.SubmitData.SelfComment=@"";
        self.FormDatas.SubmitData.LeaderComment=_txv_Appraise.text;
    }
}
//MARK:处理图片数组
-(void)dealWithImagesArray{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:self.FormDatas.arr_totalFileArray WithUrl:UPLOADPERHASFORM WithBlock:^(id data, BOOL hasError) {
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
