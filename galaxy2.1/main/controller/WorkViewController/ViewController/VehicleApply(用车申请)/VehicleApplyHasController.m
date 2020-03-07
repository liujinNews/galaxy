//
//  VehicleApplyHasController.m
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VehicleApplyHasController.h"

@interface VehicleApplyHasController ()

@end

@implementation VehicleApplyHasController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[VehicleApplyFormData alloc]initWithStatus:2];
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
    
    _View_Reason=[[UIView alloc]init];
    _View_Reason.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reason];
    [_View_Reason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Reason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_DepartCity=[[UIView alloc]init];
    _View_DepartCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DepartCity];
    [_View_DepartCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BackCity=[[UIView alloc]init];
    _View_BackCity.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackCity];
    [_View_BackCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DepartCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_VehicleDate=[[UIView alloc]init];
    _View_VehicleDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_VehicleDate];
    [_View_VehicleDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BackDate=[[UIView alloc]init];
    _View_BackDate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_BackDate];
    [_View_BackDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_VehicleStaff=[[UIView alloc]init];
    _View_VehicleStaff.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_VehicleStaff];
    [_View_VehicleStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BackDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InitialMileage=[[UIView alloc]init];
    _View_InitialMileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_InitialMileage];
    [_View_InitialMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_VehicleStaff.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_EndMileage=[[UIView alloc]init];
    _View_EndMileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_EndMileage];
    [_View_EndMileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InitialMileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Mileage=[[UIView alloc]init];
    _View_Mileage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Mileage];
    [_View_Mileage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_EndMileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PteCarAllowance=[[UIView alloc]init];
    _View_PteCarAllowance.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_PteCarAllowance];
    [_View_PteCarAllowance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Mileage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_FuelBills=[[UIView alloc]init];
    _View_FuelBills.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_FuelBills];
    [_View_FuelBills mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PteCarAllowance.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Pontage=[[UIView alloc]init];
    _View_Pontage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Pontage];
    [_View_Pontage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FuelBills.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ParkingFee=[[UIView alloc]init];
    _View_ParkingFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_ParkingFee];
    [_View_ParkingFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Pontage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_OtherFee=[[UIView alloc]init];
    _View_OtherFee.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_OtherFee];
    [_View_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ParkingFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TotalBudget=[[UIView alloc]init];
    _View_TotalBudget.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TotalBudget];
    [_View_TotalBudget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_IsPassNight=[[UIView alloc]init];
    _View_IsPassNight.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_IsPassNight];
    [_View_IsPassNight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalBudget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line2=[[UIView alloc]init];
    [self.contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsPassNight.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_TravelForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0001"];
    _View_TravelForm.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_TravelForm];
    [_View_TravelForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TravelForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_CarNo=[[UIView alloc]init];
    _View_CarNo.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_CarNo];
    [_View_CarNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Driver=[[UIView alloc]init];
    _View_Driver.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Driver];
    [_View_Driver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CarNo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_DriverTel=[[UIView alloc]init];
    _View_DriverTel.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DriverTel];
    [_View_DriverTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Driver.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Entourage=[[UIView alloc]init];
    _View_Entourage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_Entourage];
    [_View_Entourage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DriverTel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_DispatcherReview=[[UIView alloc]init];
    _View_DispatcherReview.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview: _View_DispatcherReview];
    [_View_DispatcherReview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Entourage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line3=[[UIView alloc]init];
    [self.contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DispatcherReview.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _View_Reserved=[[UIView alloc]init];
    _View_Reserved.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Reserved];
    [_View_Reserved makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
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
    contactVC.menutype=4;
    contactVC.itemType = 14;
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
//MARK:视图更新
-(void)updateMainView{
    
    [self createMoreBtnWithArray:[self.FormDatas getMoreBtnList] WithDict:@{@"ProcId":self.FormDatas.str_procId,@"TaskId":self.FormDatas.str_taskId,@"FlowCode":self.FormDatas.str_flowCode}];
    
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:self.FormDatas.arr_FormMainArray WithApproveModel:self.FormDatas withType:2];
    
    [_FormRelatedView initOnlyApproveFormRelatedViewWithDate:self.FormDatas.arr_FormMainArray WithBaseModel:self.FormDatas];
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Reason"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateReasonViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleType"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateVehicleTypeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DepartCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateDepartCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BackCity"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateBackCityViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateVehicleDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"BackDate"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateBackDateViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"VehicleStaffId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateVehicleStaffViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"InitialMileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateInitialMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"EndMileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateEndMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Mileage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateMileageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PteCarAllowance"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&[self.FormDatas.str_TypeFlag isEqualToString:@"1"]) {
            _int_line1=1;
            [self updatePteCarAllowanceViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"FuelBills"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateFuelBillsViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Pontage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updatePontageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ParkingFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateParkingFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"OtherFee"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateOtherFeeViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalBudget"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateTotalBudgetViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"IsPassNight"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateIsPassNightViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TravelNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateTravelFormViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CarNo"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateCarNoViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Driver"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateDriverViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DriverTel"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateDriverTelViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Entourage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateEntourageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"DispatcherReview"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateDispatcherReviewViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Reserved1"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateReservedViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Remark"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line3=1;
            [self updateRemarkViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line2=1;
            [self updateCcPeopleViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Attachments"]&&[[model.isShow stringValue]isEqualToString:@"1"]&&self.FormDatas.arr_totalFileArray.count!=0) {
            _int_line3=1;
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
    [self updateBottomView];
}
//MARK:原因
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Reason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Reason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:类型
-(void)updateVehicleTypeViewWithModel:(MyProcurementModel *)model{
    [_View_Type addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Type updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出发地
-(void)updateDepartCityViewWithModel:(MyProcurementModel *)model{
    [_View_DepartCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_DepartCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新目的地
-(void)updateBackCityViewWithModel:(MyProcurementModel *)model{
    [_View_BackCity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BackCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出发时间
-(void)updateVehicleDateViewWithModel:(MyProcurementModel *)model{
    [_View_VehicleDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_VehicleDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新返回时间
-(void)updateBackDateViewWithModel:(MyProcurementModel *)model{
    [_View_BackDate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_BackDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:同车人员
-(void)updateVehicleStaffViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString isEqualToNull:self.FormDatas.str_VehicleStaff]?[NSString stringWithFormat:@"%@",self.FormDatas.str_VehicleStaff]:@"";
    __weak typeof(self) weakSelf = self;
    [_View_VehicleStaff addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_VehicleStaff updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:起始里程
-(void)updateInitialMileageViewWithModel:(MyProcurementModel *)model{
    [_View_InitialMileage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_InitialMileage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:预计结束里程
-(void)updateEndMileageViewWithModel:(MyProcurementModel *)model{
    [_View_EndMileage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_EndMileage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:实际里程
-(void)updateMileageViewWithModel:(MyProcurementModel *)model{
    [_View_Mileage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Mileage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:私车公用补贴
-(void)updatePteCarAllowanceViewWithModel:(MyProcurementModel *)model{
    [_View_PteCarAllowance addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_PteCarAllowance updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:燃油费
-(void)updateFuelBillsViewWithModel:(MyProcurementModel *)model{
    [_View_FuelBills addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_FuelBills updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:路桥费
-(void)updatePontageViewWithModel:(MyProcurementModel *)model{
    [_View_Pontage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_Pontage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:停车费
-(void)updateParkingFeeViewWithModel:(MyProcurementModel *)model{
    [_View_ParkingFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_ParkingFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:其他费用
-(void)updateOtherFeeViewWithModel:(MyProcurementModel *)model{
    [_View_OtherFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_OtherFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:合计
-(void)updateTotalBudgetViewWithModel:(MyProcurementModel *)model{
    [_View_TotalBudget addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.View_TotalBudget updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新是否用车视图
-(void)updateIsPassNightViewWithModel:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue=Custing(@"是", nil);
    }else{
        model.fieldValue=Custing(@"否", nil);
    }
    [_View_IsPassNight addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_IsPassNight updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出差申请单视图
-(void)updateTravelFormViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormId],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_travelFormInfo],
                           @"Model":model
                           };
    [_View_TravelForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_TravelForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新车辆视图
-(void)updateCarNoViewWithModel:(MyProcurementModel *)model{
    [_View_CarNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_CarNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新司机
-(void)updateDriverViewWithModel:(MyProcurementModel *)model{
    [_View_Driver addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Driver updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新司机
-(void)updateDriverTelViewWithModel:(MyProcurementModel *)model{
    [_View_DriverTel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_DriverTel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:同行人员
-(void)updateEntourageViewWithModel:(MyProcurementModel *)model{
    [_View_Entourage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Entourage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新车辆评价
-(void)updateDispatcherReviewViewWithModel:(MyProcurementModel *)model{
    [_View_DispatcherReview addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_DispatcherReview updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
    if (_int_line2==1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line3==1) {
        [_view_line3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.View_Note.bottom).offset(10);
    }];
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
