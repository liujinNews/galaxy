//
//  PerformanceHasController.m
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "PerformanceHasController.h"
#import "PerformanceDetailCell.h"

@interface PerformanceHasController ()

@end

@implementation PerformanceHasController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[PerformanceFormData alloc]initWithStatus:2];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    _View_tableScore=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

    _View_SelfAppraise=[[UIView alloc]init];
    _View_SelfAppraise.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_SelfAppraise];
    [_View_SelfAppraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ChooseDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_LeaderAppraise=[[UIView alloc]init];
    _View_LeaderAppraise.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_LeaderAppraise];
    [_View_LeaderAppraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_SelfAppraise.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line1=[[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_LeaderAppraise.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
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
-(void)requestHasApp{
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
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
            [self.FormDatas DealWithFormBaseData];
            if (self.FormDatas.int_comeStatus!=1) {
                self.navigationItem.title = [NSString isEqualToNull:self.FormDatas.str_TypeName]?[NSString stringWithFormat:@"%@",self.FormDatas.str_TypeName]:@"";
            }
            [self requestApproveNote];
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
            [self.FormDatas dealTheScoreViewShowSetting];
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
    contactVC.itemType = 22;
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
    if (self.FormDatas.model_LeaderComments&&type==2) {
        if ([self.FormDatas.model_LeaderComments.isRequired floatValue]==1&&self.txv_LeaderAppraise.text.length==0) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[NSString stringWithFormat:@"%@",self.FormDatas.model_LeaderComments.Description]] duration:2.0];
            return;
        }
    }
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
        self.FormDatas.str_LeaderComments=_txv_LeaderAppraise.text;
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
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];

    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    
    if (self.FormDatas.arr_DetailsDataArray.count>0) {
        [self updateTableView];
    }

    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        
        if ([model.fieldName isEqualToString:@"SelfTotalScore"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&(self.FormDatas.int_EditType==3||self.FormDatas.int_EditType==4||self.FormDatas.int_EditType==6)) {
                self.FormDatas.bool_selfScore=YES;
                [self updateScoreViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"LeaderTotalScore"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&(self.FormDatas.int_EditType==3||self.FormDatas.int_EditType==5||self.FormDatas.int_EditType==6)) {
                self.FormDatas.bool_leaderScore=YES;
                [self updateScoreViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceMth"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==2) {
                [self updatChooseDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceQuarter"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==1) {
                [self updatChooseDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"PerformanceYear"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.int_performanceTime==0) {
                [self updatChooseDateViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"SelfComment"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&(self.FormDatas.int_EditType ==3||self.FormDatas.int_EditType ==4||self.FormDatas.int_EditType ==6)) {
                [self updatSelfAppraiseViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"LeaderComment"]){
            if ([[model.isShow stringValue]isEqualToString:@"1"]&&(self.FormDatas.int_EditType==3||self.FormDatas.int_EditType==5||self.FormDatas.int_EditType==6)) {
                self.FormDatas.model_LeaderComments=model;
                [self updatLeaderAppraiseViewWithModel:model];
            }
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line1=1;
            [self updateAttachImgViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ApprovalMode"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            if (self.FormDatas.int_comeStatus==3) {
                [self updateApproveViewWithModel:model];
            }
        }
    }
    //更新最终分数结果
    if (self.FormDatas.bool_leaderScore||self.FormDatas.bool_selfScore) {
        [self updateEndScoreView];
    }
    
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    if (self.FormDatas.int_EditType==3) {
        [self getTotalScore];
    }
    [self updateBottomView];
    
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
//MARK:更新分数
-(void)updateScoreViewWithModel:(MyProcurementModel *)model{
    if (!_View_selfScore) {
        
        [_View_Score updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@100);
        }];
        UIView *SegmentLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        SegmentLineView.backgroundColor=Color_White_Same_20;
        [_View_Score addSubview:SegmentLineView];

        _View_selfScore=[[UIView alloc]init];
        [_View_Score addSubview:_View_selfScore];
        _View_LeaderScore=[[UIView alloc]init];
        [_View_Score addSubview:_View_LeaderScore];
        
        _img_middleLine=[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width/2, 40, 0.5, 30) imageName:nil];
        _img_middleLine.backgroundColor=Color_GrayLight_Same_20;
        [_View_Score addSubview:_img_middleLine];
        
        UIImageView *bottomLine=[GPUtils createImageViewFrame:CGRectMake(0, 99.5, Main_Screen_Width, 0.5) imageName:nil];
        bottomLine.backgroundColor=Color_GrayLight_Same_20;
        [_View_Score addSubview:bottomLine];
        
        [_View_selfScore makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_Score.top).offset(@10);
            make.left.equalTo(self.View_Score.left);
            make.width.equalTo(@(Main_Screen_Width/2));
            make.height.equalTo(@90);
        }];
        [_View_LeaderScore makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_Score.top).offset(@10);
            make.left.equalTo(self.View_selfScore.right);
            make.right.equalTo(self.View_Score.right);
            make.height.equalTo(@90);
        }];
        
        _lab_selfScore=[GPUtils createLable:CGRectZero text:nil font:Font_Amount_21_20 textColor:Color_Orange_Weak_20 textAlignment:NSTextAlignmentCenter];
        [_View_selfScore addSubview:_lab_selfScore];
        _lab_selfTitle=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [_View_selfScore addSubview:_lab_selfTitle];

        [_lab_selfScore makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_selfScore.top).offset(@25);
            make.left.equalTo(self.View_selfScore.left);
            make.width.equalTo(self.View_selfScore.width);
            make.height.equalTo(@25);
        }];
        
        [_lab_selfTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_selfScore.top).offset(@50);
            make.left.equalTo(self.View_selfScore.left);
            make.width.equalTo(self.View_selfScore.width);
            make.height.equalTo(@15);
        }];
        
        _lab_LeaderScore=[GPUtils createLable:CGRectZero text:nil font:Font_Amount_21_20 textColor:Color_Green_Weak_20 textAlignment:NSTextAlignmentCenter];
        [_View_LeaderScore addSubview:_lab_LeaderScore];
        _lab_leaderTitle=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [_View_LeaderScore addSubview:_lab_leaderTitle];
        
        [_lab_LeaderScore makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_LeaderScore.top).offset(@25);
            make.left.equalTo(self.View_LeaderScore.left);
            make.width.equalTo(self.View_LeaderScore.width);
            make.height.equalTo(@25);
        }];

        [_lab_leaderTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_LeaderScore.top).offset(@50);
            make.left.equalTo(self.View_LeaderScore.left);
            make.width.equalTo(self.View_LeaderScore.width);
            make.height.equalTo(@15);
        }];
    }
    if ([model.fieldName isEqualToString:@"SelfTotalScore"]) {
        _lab_selfScore.text=[NSString stringWithFormat:@"%@",model.fieldValue];
        _lab_selfTitle.text=[NSString stringWithFormat:@"%@",model.Description];
    }else{
        _lab_LeaderScore.text=[NSString stringWithFormat:@"%@",model.fieldValue];
        _lab_leaderTitle.text=[NSString stringWithFormat:@"%@",model.Description];
    }
}
-(void)updateEndScoreView{
    if (self.FormDatas.bool_selfScore&&!self.FormDatas.bool_leaderScore) {
        [_View_selfScore updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(Main_Screen_Width));
        }];
        _img_middleLine.hidden=YES;
    }else if(!self.FormDatas.bool_selfScore&&self.FormDatas.bool_leaderScore){
        [_View_selfScore updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        _img_middleLine.hidden=YES;
    }
}
//MARK:更新评价月季度年
-(void)updatChooseDateViewWithModel:(MyProcurementModel *)model{
    UITextField *tf=[[UITextField alloc]init];
    if (self.FormDatas.int_performanceTime==1){
        model.fieldValue=[GPUtils getSelectResultWithArray:@[self.FormDatas.str_PerformanceYear,self.FormDatas.str_PerformanceQuarter]];
    }else if (self.FormDatas.int_performanceTime==2){
        model.fieldValue=[GPUtils getSelectResultWithArray:@[self.FormDatas.str_PerformanceYear,self.FormDatas.str_PerformanceMth]];
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ChooseDate WithContent:tf WithFormType:formViewShowText WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    [_View_ChooseDate addSubview:view];
}
//MARK:更新自己评价
-(void)updatSelfAppraiseViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_SelfAppraise addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:10 block:^(NSInteger height) {
        [weakSelf.View_SelfAppraise updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height+10));
        }];
        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        lineview.backgroundColor=Color_White_Same_20;
        [weakSelf.View_SelfAppraise addSubview:lineview];
    }]];
}
//MARK:更新领导评论评价
-(void)updatLeaderAppraiseViewWithModel:(MyProcurementModel *)model{
    if (self.FormDatas.int_EditType==3) {
        _txv_LeaderAppraise=[[UITextView alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_LeaderAppraise WithContent:_txv_LeaderAppraise WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        view.iflyRecognizerView=_iflyRecognizerView;
        [_View_LeaderAppraise addSubview:view];
    }else{
        __weak typeof(self) weakSelf = self;
        [_View_LeaderAppraise addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:10 block:^(NSInteger height) {
            [weakSelf.View_LeaderAppraise updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height+10));
            }];
            UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
            lineview.backgroundColor=Color_White_Same_20;
            [weakSelf.View_LeaderAppraise addSubview:lineview];
        }]];
    }
}
//MARK:更新采购自定义字段
-(void)updateReservedViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reserved addSubview:[ReserverdLookMainView initArr:self.FormDatas.arr_FormMainArray view:_View_Reserved block:^(NSInteger height) {
        [weakSelf.View_Reserved updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购备注
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
//MARK:更新采购图片
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{

    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_View_AttachImg withEditStatus:2 withModel:model];
    view.maxCount=5;
    [_View_AttachImg addSubview:view];
    [view updateWithTotalArray:self.FormDatas.arr_totalFileArray WithImgArray:self.FormDatas.arr_imagesArray];
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

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
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
    self.lab_LeaderScore.text=self.FormDatas.str_LeaderTotalScore;

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
