//
//  ConferenceBookHasController.m
//  galaxy
//
//  Created by hfk on 2017/12/18.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ConferenceBookHasController.h"
#import "ConferenceBookController.h"

@interface ConferenceBookHasController ()

@end

@implementation ConferenceBookHasController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[ConferenceFormData alloc]initWithStatus:2];
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
    [self requestHasApp];

}

-(void)createDealBtns{
    __weak typeof(self) weakSelf = self;
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus==8){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil),Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }else if (index==1){
                [weakSelf reCallBack];
            }
        };
    }else if(self.FormDatas.int_comeStatus==9){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }
        };
    }else if (self.FormDatas.int_comeStatus==3){
        if ([self.FormDatas.str_canEndorse isEqualToString:@"1"]) {
            [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
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
            self.dockView.btnClickBlock = ^(NSInteger index) {
                if (index==0){
                    [weakSelf dockViewClick:0];
                }else if (index==1){
                    [weakSelf dockViewClick:2];
                }
            };
        }
    }
}

//MARK:创建主scrollView
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    if (self.FormDatas.int_comeStatus==2||self.FormDatas.int_comeStatus==3||self.FormDatas.int_comeStatus==7||self.FormDatas.int_comeStatus==8||self.FormDatas.int_comeStatus==9) {
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
    [self createContentView];
    [self createMainView];
}
-(void)createContentView{
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
        make.top.equalTo(self.contentView.top).offset(@10);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line1=[[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_Name=[[UIView alloc]init];
    _View_Name.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Name];
    [_View_Name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Name.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_RoomName=[[UIView alloc]init];
    _View_RoomName.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_RoomName];
    [_View_RoomName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FromDate=[[UIView alloc]init];
    _View_FromDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_FromDate];
    [_View_FromDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_RoomName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ToDate=[[UIView alloc]init];
    _View_ToDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ToDate];
    [_View_ToDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FromDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Staff=[[UIView alloc]init];
    _View_Staff.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Staff];
    [_View_Staff makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ToDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_MeetingNum=[[UIView alloc]init];
    _View_MeetingNum.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_MeetingNum];
    [_View_MeetingNum makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Staff.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Equipment=[[UIView alloc]init];
    _View_Equipment.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Equipment];
    [_View_Equipment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_MeetingNum.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OpenMethod=[[UIView alloc]init];
    _View_OpenMethod.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_OpenMethod];
    [_View_OpenMethod makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Equipment.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OpenMethod.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_DetailsTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_DetailsTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_DetailsTable.delegate=self;
    _View_DetailsTable.dataSource=self;
    _View_DetailsTable.scrollEnabled=NO;
    _View_DetailsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_View_DetailsTable];
    [_View_DetailsTable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line2=[[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DetailsTable.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Remark=[[UIView alloc]init];
    _View_Remark.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Remark];
    [_View_Remark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reserved.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Remark.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_AttachImg=[[UIView alloc]init];
    _View_AttachImg.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_AttachImg];
    [_View_AttachImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
   
    _View_Approve=[[UIView alloc]init];
    _View_Approve.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Approve];
    [_View_Approve makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AttachImg.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Note=[[UIView alloc]init];
    _View_Note.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Note];
    [_View_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Approve.bottom);
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
        case 1:
        {
            NSString * successRespone = [NSString stringWithFormat:@"%@",[self.FormDatas.dict_resultDict objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:successRespone];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackTo) userInfo:nil repeats:NO];
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

-(void)goBackTo{
    self.dockView.userInteractionEnabled=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:撤回跳到重新提交
-(void)goToReSubmit{
    self.dockView.userInteractionEnabled=YES;
    [self goToReSubmitWithModel:self.FormDatas];

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
    contactVC.itemType = 18;
    contactVC.menutype=4;
    contactVC.universalDelegate = self;
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
//0:退单 1加签 2同意
-(void)dockViewClick:(NSInteger)type{
    examineViewController *vc=[[examineViewController alloc]init];
    vc.ProcId=self.FormDatas.str_procId;
    vc.TaskId=self.FormDatas.str_taskId;
    vc.FlowCode=self.FormDatas.str_flowCode;
    if (type==0) {
        vc.Type=@"0";
    }else if (type==1){
        vc.Type=@"1";
    }else if (type==2){
        vc.Type = @"2";
        [self.FormDatas contectHasDataWithTableName:[self.FormDatas getTableName]];
        vc.dic_APPROVAL = self.FormDatas.dict_parametersDict;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:撤回操作
-(void)reCallBack{
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas reCallUrl] Parameters:[self.FormDatas reCallParameters] Delegate:self SerialNum:2 IfUserCache:NO];
}
//MARK:催办操作
-(void)goUrge{
    NSLog(@"催办操作");
    self.dockView.userInteractionEnabled=NO;
    [[GPClient shareGPClient]REquestByPostWithPath:[self.FormDatas urgeUrl] Parameters:[self.FormDatas urgeParameters] Delegate:self SerialNum:1 IfUserCache:NO];
}
//MARK:查看更多明细
-(void)LookMore:(UIButton *)btn{
    self.FormDatas.bool_isOpenDetail=!self.FormDatas.bool_isOpenDetail;
    [btn setImage: self.FormDatas.bool_isOpenDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.FormDatas.bool_isOpenDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updateDetailsTableView];
}

//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];

    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    [_FormRelatedView initOnlyApproveFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithBaseModel:self.FormDatas];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Name"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TypeId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"RoomId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateRoomViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FromDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateFromDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ToDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateToDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"StaffId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"MeetingNum"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateMeetingNumViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Equipment"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateEquipmentViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OpenMethod"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateOpenMethodViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line2=1;
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    
    if (self.FormDatas.arr_DetailsDataArray.count!=0) {
        [self updateDetailsTableView];
        [_View_DetailsTable reloadData];
    }
    
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    [self updateBottomView];
}

//MARK:会议名称
-(void)updateNameViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Name addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Name updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议类型
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_Type]?[NSString stringWithFormat:@"%@",self.FormDatas.str_Type]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Type addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Type updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议室名称
-(void)updateRoomViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_RoomName]?[NSString stringWithFormat:@"%@",self.FormDatas.str_RoomName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_RoomName addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_RoomName updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议开始时间
-(void)updateFromDateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_FromDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_FromDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议结束时间
-(void)updateToDateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_ToDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ToDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议人员
-(void)updateStaffViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_StaffName]?[NSString stringWithFormat:@"%@",self.FormDatas.str_StaffName]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_Staff addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Staff updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议人数
-(void)updateMeetingNumViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_MeetingNum addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_MeetingNum updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议设备
-(void)updateEquipmentViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Equipment addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Equipment updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:会议公开方式
-(void)updateOpenMethodViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[self.FormDatas getOpenMethodId:model.fieldValue];
    __weak typeof(self) weakSelf = self;
    [_View_OpenMethod addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_OpenMethod updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateDetailsTableView{

    if (self.FormDatas.bool_isOpenDetail) {
        NSInteger height=10;
        for (ConferenceDeatil *model in self.FormDatas.arr_DetailsDataArray) {
            height=height+[ProcureDetailsCell ConferenceCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        }
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        ConferenceDeatil *model=self.FormDatas.arr_DetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell ConferenceCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}
//MARK:更新自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[ReserverdLookMainView initArr:self.FormDatas.arr_FormMainArray view:_View_Reserved block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
}
//MARK:更新备注
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_CcToPeople addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CcToPeople updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
  
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
}



//MARK:更新审批人
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
//MARK:更新底层视图
-(void)updateBottomView{
    if (_int_line1==1) {
        [_view_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line2==1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
   
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
}
#pragma mark - UITableViewDataSource 协议方法
// 返回参数2指定分组的行数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FormDatas.arr_DetailsDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConferenceDeatil *model=self.FormDatas.arr_DetailsDataArray[indexPath.row];
    return [ProcureDetailsCell ConferenceCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        return [UIView new];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
    if (cell==nil) {
        cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
    }
    [cell configConferenceCellWithArray:self.FormDatas.arr_DetailsArray withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_DetailsDataArray.count] ;
    if (cell.LookMore) {
        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
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
