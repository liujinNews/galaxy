//
//  ItemHasRequestController.m
//  galaxy
//
//  Created by hfk on 2018/3/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "ItemHasRequestController.h"

@interface ItemHasRequestController ()

@end

@implementation ItemHasRequestController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormDatas=[[ItemRequestFormData alloc]initWithStatus:2];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    _View_Usage=[[UIView alloc]init];
    _View_Usage.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Usage];
    [_View_Usage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Type=[[UIView alloc]init];
    _View_Type.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Type];
    [_View_Type makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Usage.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ContractName = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0013"];
    _View_ContractName.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_ContractName];
    [_View_ContractName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Type.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Project = [[UIView alloc]init];
    _View_Project.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Project];
    [_View_Project mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ContractName.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_PurchaseForm=[[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0005"];
    _View_PurchaseForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_PurchaseForm];
    [_View_PurchaseForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Project.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_InventoryForm = [[MulChooseShowView alloc]initWithStatus:2 withFlowCode:@"F0029"];
    _View_InventoryForm.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_InventoryForm];
    [_View_InventoryForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_PurchaseForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Client = [[UIView alloc]init];
    _View_Client.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Client];
    [_View_Client mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InventoryForm.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Client.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _View_TotalMoney=[[UIView alloc]init];
    _View_TotalMoney.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_TotalMoney];
    [_View_TotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Capitalized=[[UIView alloc]init];
    _View_Capitalized.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Capitalized];
    [_View_Capitalized mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TotalMoney.bottom);
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
        make.top.equalTo(self.View_Capitalized.bottom);
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

//MARK:审批人点击
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
    contactVC.itemType = 7;
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
    
    for (MyProcurementModel *model in self.FormDatas.arr_FormMainArray) {
        if ([model.fieldName isEqualToString:@"Usage"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateUsageViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"Type"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateTypeWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ContractName"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateContractNameViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"ProjId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateProjectViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"PurchaseNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updatePurchaseNumberViewWithModel:model];
        }
//        else if ([model.fieldName isEqualToString:@"InventoryNumber"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
//            _int_line1=1;
//            [self updateInventoryNumberViewWithModel:model];
//        }
        else if ([model.fieldName isEqualToString:@"ClientId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateClientViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"SupplierId"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateSupplierViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"TotalAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateTotalMoneyViewWithModel:model];
        }else if ([model.fieldName isEqualToString:@"CapitalizedAmount"]&&[[model.isShow stringValue]isEqualToString:@"1"]) {
            _int_line1=1;
            [self updateCapitalizedAmountViewWithModel:model];
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
    
    if (self.FormDatas.bool_DetailsShow&&self.FormDatas.arr_DetailsDataArray.count!=0) {
        [self updateDetailsTableView];
        [_View_DetailsTable reloadData];
    }
    
    if (self.FormDatas.arr_noteDateArray.count!=0) {
        [self updateNotesTableView];
    }
    
    [self updateBottomView];
}
//MARK:更新用途
-(void)updateUsageViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Usage addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Usage updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新类型
-(void)updateTypeWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Type addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Type updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新合同名称
-(void)updateContractNameViewWithModel:(MyProcurementModel *)model{
    
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_ContractAppNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_ContractName],
                           @"Model":model
                           };
    [_View_ContractName updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_ContractName.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新项目
-(void)updateProjectViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.ProjName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.ProjName]:@"";
    [_View_Project addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Project updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新采购单请单
-(void)updatePurchaseNumberViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_PurchaseInfo],
                           @"Model":model
                           };
    [_View_PurchaseForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_PurchaseForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新入库单
-(void)updateInventoryNumberViewWithModel:(MyProcurementModel *)model{
    NSDictionary *dict = @{@"Id":[NSString stringWithIdOnNO:self.FormDatas.str_InventoryNumber],
                           @"Value":[NSString stringWithIdOnNO:self.FormDatas.str_InventoryInfo],
                           @"Model":model
                           };
    [_View_InventoryForm updateView:dict];
    __weak typeof(self) weakSelf = self;
    _View_InventoryForm.CellClickBlock = ^(NSDictionary *dict, NSInteger status) {
        [weakSelf LookViewLinkToFormWithTaskId:dict[@"taskId"] WithFlowCode:dict[@"flowcode"]];
    };
}
//MARK:更新客户
-(void)updateClientViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.ClientName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.ClientName]:@"";
    [_View_Client addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Client updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新供应商
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    model.fieldValue = [NSString isEqualToNull:self.FormDatas.personalData.SupplierName]?[NSString stringWithFormat:@"%@",self.FormDatas.personalData.SupplierName]:@"";
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新金额
-(void)updateTotalMoneyViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_TotalMoney addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_TotalMoney updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新金额大写
-(void)updateCapitalizedAmountViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_Capitalized addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Capitalized updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新明细
-(void)updateDetailsTableView{
    if (self.FormDatas.bool_isOpenDetail) {
        NSInteger height=10;
        for (ItemRequestDetail *model in self.FormDatas.arr_DetailsDataArray) {
            height=height+[ProcureDetailsCell ItemCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        }
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        ItemRequestDetail *model=self.FormDatas.arr_DetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell ItemCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
        [_View_DetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.FormDatas.arr_DetailsDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemRequestDetail *model=self.FormDatas.arr_DetailsDataArray[indexPath.row];
    return [ProcureDetailsCell ItemCellHeightWithArray:self.FormDatas.arr_DetailsArray WithModel:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
        view.backgroundColor=Color_White_Same_20;
        return view;
    }else{
        return [UIView new];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
    if (cell==nil) {
        cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
    }
    [cell configItemCellWithArray:self.FormDatas.arr_DetailsArray withDetailsModel:self.FormDatas.arr_DetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.FormDatas.arr_DetailsDataArray.count] ;
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
