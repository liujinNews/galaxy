//
//  OvertimeViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "OvertimeViewController.h"
#import "OvertimeModel.h"
#import "LookOverTimeViewController.h"
#import "OverTimeHistoryOutputView.h"

@interface OvertimeViewController ()<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

//框架用view
@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView
@property (nonatomic, strong) UIView *DockBottomView;//底部视图
@property (nonatomic, strong) DoneBtnView * dockView; //底部按钮视图
@property (nonatomic, strong) UIButton *Btn_save;//保存按钮
@property (nonatomic, strong) UIButton *Btn_submit;//提交按钮
@property (nonatomic, strong) UIButton *Btn_backSub;//退单提交按钮
@property (nonatomic, strong) UIButton *Btn_Direct;//直送按钮
@property (nonatomic, assign) NSInteger int_Sub_State;
@property (nonatomic, strong) OvertimeModel *model_Submit;
@property (nonatomic, strong) NSMutableDictionary *dic_Submit;

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;
@property (nonatomic, strong) FormBaseModel *FormData;

@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) NSMutableArray *muarr_MainView;
@property (nonatomic, strong) NSMutableArray *muarr_DetailFld;
@property (nonatomic, strong) NSString *str_directType;
@property (nonatomic, strong) NSString *str_overtimeDetail;

@property (nonatomic, strong) WorkFormFieldsModel *model_Reason;
@property (nonatomic, strong) WorkFormFieldsModel *model_ClientId;
@property (nonatomic, strong) WorkFormFieldsModel *model_SupplierId;
@property (nonatomic, strong) WorkFormFieldsModel *model_CostCenterId;
@property (nonatomic, strong) WorkFormFieldsModel *model_ProjId;
@property (nonatomic, strong) NSString *str_ProjMgrUserId;
@property (nonatomic, strong) NSString *str_ProjMgr;
@property (nonatomic, strong) WorkFormFieldsModel *model_FromDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_ToDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_TotalTime;
@property (nonatomic, strong) WorkFormFieldsModel *model_Type;
@property (nonatomic, strong) WorkFormFieldsModel *model_AccountingModeId;
@property (nonatomic, strong) UIView *view_OverTimeDetail;
@property (nonatomic, strong) UITableView *tbv_OverTimeDetail;
@property (nonatomic, strong) UIView *view_OverTimeDetail_btn;
@property (nonatomic, strong) WorkFormFieldsModel *model_Remark;
@property (nonatomic, strong) UITextView *txv_Remark;
@property (nonatomic, strong) WorkFormFieldsModel *model_Attachments;
@property (nonatomic, strong) NSMutableArray *arr_Attachments_Totle;
@property (nonatomic, strong) NSMutableArray *arr_Attachments_Image;
@property (nonatomic, strong) WorkFormFieldsModel *model_Reserved1;
@property (nonatomic, strong) WorkFormFieldsModel *model_overtimeHistoryOutput;
@property (nonatomic, strong) NSDictionary *dic_overtimeHistoryOutput;
@property (nonatomic, strong) WorkFormFieldsModel *model_FirstHandlerUserName;

@property (nonatomic, strong) ReserverdMainModel *model_rs;

@property (nonatomic, strong) NSString *str_FirstHandlerPhotoGraph;
@property (nonatomic, strong) UIImageView *img_FirstHandlerUserName;

@property (nonatomic, strong) UIView *NoteView;//审批记录
@property (nonatomic, strong) NSMutableArray *muarr_noteDateArray;//审批记录数据
@property (nonatomic, strong) NSDictionary *dic_RequestNote;
@property (nonatomic, strong) NSMutableArray *arr_OverTimeType;
@property (nonatomic, strong) NSMutableArray *arr_AccountingModeId;

/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;
/**
 *  抄送人id
 */
@property(nonatomic,strong)NSString *str_CcUsersId;
/**
 *  抄送人名称
 */
@property(nonatomic,strong)NSString *str_CcUsersName;


@end

@implementation OvertimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowCode];
    [self setTitle:dict[@"Title"] backButton:YES];
    [self requestOverTime];
}

#pragma mark - function
#pragma mark 视图
-(void)creationRootView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    self.view_ContentView =[[BottomView alloc]init];
    self.view_ContentView.userInteractionEnabled=YES;
    self.view_ContentView.backgroundColor=Color_White_Same_20;
    [_scr_RootScrollView addSubview:self.view_ContentView];
    
    [self.view_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_RootScrollView);
        make.width.equalTo(self.scr_RootScrollView);
    }];
}

-(void)creationMainView{
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    _SubmitPersonalView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ContentView.top);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Reason.view_View = [[UIView alloc]init];
    _model_Reason.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Reason.view_View];
    [_model_Reason.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_ClientId.view_View = [[UIView alloc]init];
    _model_ClientId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_ClientId.view_View];
    [_model_ClientId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Reason.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_SupplierId.view_View = [[UIView alloc]init];
    _model_SupplierId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_SupplierId.view_View];
    [_model_SupplierId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_ClientId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_CostCenterId.view_View = [[UIView alloc]init];
    _model_CostCenterId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_CostCenterId.view_View];
    [_model_CostCenterId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_SupplierId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_ProjId.view_View = [[UIView alloc]init];
    _model_ProjId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_ProjId.view_View];
    [_model_ProjId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_CostCenterId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_FromDate.view_View = [[UIView alloc]init];
    _model_FromDate.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_FromDate.view_View];
    [_model_FromDate.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_ProjId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_ToDate.view_View = [[UIView alloc]init];
    _model_ToDate.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_ToDate.view_View];
    [_model_ToDate.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_FromDate.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_TotalTime.view_View = [[UIView alloc]init];
    _model_TotalTime.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_TotalTime.view_View];
    [_model_TotalTime.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_ToDate.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Type.view_View = [[UIView alloc]init];
    _model_Type.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Type.view_View];
    [_model_Type.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_TotalTime.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_AccountingModeId.view_View = [[UIView alloc]init];
    _model_AccountingModeId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_AccountingModeId.view_View];
    [_model_AccountingModeId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Type.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _view_OverTimeDetail = [[UIView alloc]init];
    _view_OverTimeDetail.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_OverTimeDetail];
    [_view_OverTimeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_AccountingModeId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _tbv_OverTimeDetail = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tbv_OverTimeDetail.backgroundColor=Color_WhiteWeak_Same_20;
    _tbv_OverTimeDetail.delegate=self;
    _tbv_OverTimeDetail.dataSource=self;
    _tbv_OverTimeDetail.scrollEnabled=NO;
    _tbv_OverTimeDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbv_OverTimeDetail.allowsMultipleSelection=NO;
    _tbv_OverTimeDetail.scrollEnabled = NO;
    [_view_OverTimeDetail addSubview:_tbv_OverTimeDetail];
    [_tbv_OverTimeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OverTimeDetail.top);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _view_OverTimeDetail_btn = [[UIView alloc]init];
    _view_OverTimeDetail_btn.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_OverTimeDetail_btn];
    [_view_OverTimeDetail_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OverTimeDetail.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Reserved1.view_View = [[UIView alloc]init];
    _model_Reserved1.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Reserved1.view_View];
    [_model_Reserved1.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OverTimeDetail_btn.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Remark.view_View = [[UIView alloc]init];
    _model_Remark.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Remark.view_View];
    [_model_Remark.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Reserved1.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Attachments.view_View = [[UIView alloc]init];
    _model_Attachments.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Attachments.view_View];
    [_model_Attachments.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Remark.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
   
    
    //加班时长
    _model_overtimeHistoryOutput.view_View = [[UIView alloc]init];
    _model_overtimeHistoryOutput.view_View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview: _model_overtimeHistoryOutput.view_View];
    [_model_overtimeHistoryOutput.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Attachments.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _NoteView = [[UIView alloc]init];
    _NoteView.backgroundColor=[UIColor whiteColor];
    [self.view_ContentView addSubview:_NoteView];
    [_NoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_overtimeHistoryOutput.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //审批人
    _model_FirstHandlerUserName.view_View = [[UIView alloc]init];
    _model_FirstHandlerUserName.view_View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview: _model_FirstHandlerUserName.view_View];
    [_model_FirstHandlerUserName.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NoteView.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_FirstHandlerUserName.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _DockBottomView=[[UIView alloc]init];
    _DockBottomView.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_DockBottomView];
    [_DockBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.view_ContentView);
        make.width.equalTo(self.view_ContentView.width);
    }];
}

-(void)creationDockView{
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    UIButton *btn = [UIButton new];
    if (_comeStatus==1||_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 5;
                [weakSelf btn_Click:btn];
            }else{
                btn.tag = 6;
                [weakSelf btn_Click:btn];
            }
        };
    }else if (_comeStatus==3&&![_str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 4;
                [weakSelf btn_Click:btn];
            }else{
                btn.tag = 3;
                [weakSelf btn_Click:btn];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                btn.tag = 3;
                [weakSelf btn_Click:btn];
            }
        };
    }
}

//创建付款方式表头文件
-(UIView *)createPayModeDetailFldWithSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor blackColor];
    [view addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text=Custing(@"加班明细", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"加班明细", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(OverTimeModeDetail_Click:) delegate:self title:Custing(@"删除", nil) font:Font_Same_12_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-30, 13.5);
            deleteBtn.tag = section;
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [view addSubview:deleteBtn];
        }
    }
    view.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineUp];
    
    UIView *downUp=[[UIView alloc]initWithFrame:CGRectMake(0,26.5, Main_Screen_Width,0.5)];
    downUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:downUp];
    return view;
}

-(void)updateMainView{
    [_SubmitPersonalView initSubmitPersonalViewWithDate:_muarr_MainView WithRequireDict:[NSMutableDictionary dictionary] WithUnShowArray:[NSMutableArray array] WithSumbitBaseModel:self.FormData Withcontroller:self];

    for (MyProcurementModel *model in _muarr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]) {
                [self updateReasonViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ClientId"]) {
                [self updateClientIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
                [self updateSupplierIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"CostCenterId"]) {
                [self updateCostCenterIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ProjId"]) {
                [self updateProjIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FromDate"]) {
                [self updateFromDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ToDate"]) {
                [self updateToDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TotalTime"]) {
                [self updateTotalTimeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Type"]) {
                [self updateTypeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"AccountingModeId"]) {
                [self updateAccountingModeIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Remark"]) {
                [self updateRemarkViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Attachments"]) {
                [self updateAttachmentsViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]) {
                [self updateReserved1ViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
                [self updateFirstHandlerUserNameViewWithModel:_model_FirstHandlerUserName.model];
            }else if ([model.fieldName isEqualToString:@"CcUsersName"]){
                [self updateCcPeopleViewWithModel:model];
            }
        }
    }
    if ([_str_overtimeDetail integerValue]==1&&_muarr_DetailFld.count>0) {
        [self updateDetailView];
        [self updateDetail_btn_View];
    }
    if (_muarr_noteDateArray.count>=2&&_comeStatus==3) {
        [self updateNotesTableView];
    }
    if (_dic_overtimeHistoryOutput.count>0) {
        [self updateOvertimeHistoryOutputView];
    }
}

//更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _model_Reason.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Reason.view_View WithContent:_model_Reason.txf_TexfField WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_Reason.view_View addSubview:view];
}

//更新客户视图
-(void)updateClientIdViewWithModel:(MyProcurementModel *)model{
    _model_ClientId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_ClientId.view_View WithContent:_model_ClientId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_ClientId.view_View addSubview:view];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_ClientId.Id = model.fieldValue;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
        vc.ChooseCategoryId = weakSelf.model_ClientId.Id;
        __weak typeof(self) weakSelf = self;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_ClientId.Id = model.Id;
            weakSelf.model_ClientId.Value = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.model_ClientId.txf_TexfField.text = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_ClientId.Id = model.fieldValue;
    }
    if ([NSString isEqualToNull:_model_ClientId.Value]) {
        _model_ClientId.txf_TexfField.text = _model_ClientId.Value;
    }
}

//更新供应商视图
-(void)updateSupplierIdViewWithModel:(MyProcurementModel *)model{
    _model_SupplierId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_SupplierId.view_View WithContent:_model_SupplierId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_SupplierId.view_View addSubview:view];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_SupplierId.Id = model.fieldValue;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
        vc.ChooseCategoryId = weakSelf.model_SupplierId.Id;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_SupplierId.Id = model.Id;
            weakSelf.model_SupplierId.txf_TexfField.text =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.model_SupplierId.Value =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_SupplierId.Id = model.fieldValue;
    }
    if ([NSString isEqualToNull:_model_SupplierId.Value]) {
        _model_SupplierId.txf_TexfField.text = _model_SupplierId.Value;
    }
}

//更新成本中心视图
-(void)updateCostCenterIdViewWithModel:(MyProcurementModel *)model{
    _model_CostCenterId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_CostCenterId.view_View WithContent:_model_CostCenterId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model_CostCenterId.Value}];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_CostCenterId.Id = model.fieldValue;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
        vc.ChooseCategoryId = weakSelf.model_CostCenterId.Id;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_CostCenterId.Id = model.Id;
            weakSelf.model_CostCenterId.txf_TexfField.text = model.costCenter;
            weakSelf.model_CostCenterId.Value = model.costCenter;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_model_CostCenterId.view_View addSubview:view];
}

//更新项目视图
-(void)updateProjIdViewWithModel:(MyProcurementModel *)model{
    _model_ProjId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_ProjId.view_View WithContent:_model_ProjId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model_ProjId.Value}];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_ProjId.Id = model.fieldValue;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
        vc.ChooseCategoryId = weakSelf.model_ProjId.Id;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_ProjId.Id = model.Id;
            weakSelf.model_ProjId.Value = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
            weakSelf.model_ProjId.txf_TexfField.text = weakSelf.model_ProjId.Value;
            weakSelf.str_ProjMgrUserId = model.projMgrUserId;
            weakSelf.str_ProjMgr = model.projMgr;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_model_ProjId.view_View addSubview:view];
}

//更新开始时间视图
-(void)updateFromDateViewWithModel:(MyProcurementModel *)model{
    _model_FromDate.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_FromDate.view_View WithContent:_model_FromDate.txf_TexfField WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        if (weakSelf.model_FromDate.txf_TexfField && weakSelf.model_ToDate.txf_TexfField && weakSelf.model_TotalTime.txf_TexfField) {
            NSString *lastTime = [NSDate CountDateTime:weakSelf.model_FromDate.txf_TexfField.text to:weakSelf.model_ToDate.txf_TexfField.text];
            if (![lastTime isEqualToString:@"-1"]&&[NSString isEqualToNull:lastTime]) {
                weakSelf.model_TotalTime.txf_TexfField.text = lastTime;
                [self updateCountTime];
            }else if([lastTime isEqualToString:@"-1"]){
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开始时间不能大于结束时间", nil) duration:1.0];
                weakSelf.model_FromDate.txf_TexfField.text = weakSelf.model_ToDate.txf_TexfField.text;
            }
        }
    }];
    [_model_FromDate.view_View addSubview:view];
}

//更新结束时间视图
-(void)updateToDateViewWithModel:(MyProcurementModel *)model{
    _model_ToDate.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_ToDate.view_View WithContent:_model_ToDate.txf_TexfField WithFormType:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        if (weakSelf.model_FromDate.txf_TexfField && weakSelf.model_ToDate.txf_TexfField && weakSelf.model_TotalTime.txf_TexfField) {
            NSString *lastTime = [NSDate CountDateTime:weakSelf.model_FromDate.txf_TexfField.text to:weakSelf.model_ToDate.txf_TexfField.text];
            if (![lastTime isEqualToString:@"-1"]&&[NSString isEqualToNull:lastTime]) {
                weakSelf.model_TotalTime.txf_TexfField.text = lastTime;
                [self updateCountTime];
            }else if([lastTime isEqualToString:@"-1"]){
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.0];
                weakSelf.model_ToDate.txf_TexfField.text = weakSelf.model_FromDate.txf_TexfField.text;
            }
        }
    }];
    [_model_ToDate.view_View addSubview:view];
}

//更新合计（小时）视图
-(void)updateTotalTimeViewWithModel:(MyProcurementModel *)model{
    _model_TotalTime.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_TotalTime.view_View WithContent:_model_TotalTime.txf_TexfField WithFormType:formViewEnterNum WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_TotalTime.view_View addSubview:view];
}

//更新加班类型视图
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    _model_Type.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Type.view_View WithContent:_model_Type.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model_Type.Value}];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_Type.Id = model.fieldValue;
        STOnePickModel *models = _arr_OverTimeType[[model.fieldValue integerValue]-1];
        _model_Type.txf_TexfField.text = models.Type;
    }else{
        _model_Type.txf_TexfField.text = Custing(@"工作日", nil);
        _model_Type.Id = @"1";
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.model_Type.txf_TexfField.text = Model.Type;
            weakSelf.model_Type.Id = Model.Id;
        }];
        picker.typeTitle = Custing(@"加班类型", nil);
        picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_OverTimeType];
        STOnePickModel *stmodel = [[STOnePickModel alloc]init];
        stmodel.Id = [NSString isEqualToNull:weakSelf.model_Type.Id]?weakSelf.model_Type.Id:@"";
        picker.Model = stmodel;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_Type.view_View addSubview:view];
}

//更新加班加班核算方式视图
-(void)updateAccountingModeIdViewWithModel:(MyProcurementModel *)model{
    _model_AccountingModeId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_AccountingModeId.view_View WithContent:_model_AccountingModeId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_model_AccountingModeId.Value}];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_AccountingModeId.Id = model.fieldValue;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf keyClose];
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.model_AccountingModeId.txf_TexfField.text = Model.Type;
            weakSelf.model_AccountingModeId.Id = Model.Id;
        }];
        picker.typeTitle = Custing(@"加班核算方式", nil);
        picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_AccountingModeId];
        STOnePickModel *stmodel = [[STOnePickModel alloc]init];
        stmodel.Id = [NSString isEqualToNull:weakSelf.model_AccountingModeId.Id]?weakSelf.model_AccountingModeId.Id:@"";
        picker.Model = stmodel;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_AccountingModeId.view_View addSubview:view];
}

//更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark = [[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Remark.view_View WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_model_Remark.view_View addSubview:view];
}

//更新附件视图
-(void)updateAttachmentsViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_model_Attachments.view_View withEditStatus:1 withModel:model];
    view.maxCont=5;
    [_model_Attachments.view_View addSubview:view];
    [view updateWithTotalArray:_arr_Attachments_Totle WithImgArray:_arr_Attachments_Image];
}

-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_Reserved1.view_View addSubview:[[ReserverdMainView alloc]initArr:_muarr_MainView isRequiredmsdic:[NSMutableDictionary dictionary] reservedDic:[NSMutableDictionary dictionary] UnShowmsArray:[NSMutableArray array] view:_model_Reserved1.view_View model:_model_rs block:^(NSInteger height) {
        [weakSelf.model_Reserved1.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新审批人
-(void)updateFirstHandlerUserNameViewWithModel:(MyProcurementModel *)model{
    _model_FirstHandlerUserName.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_FirstHandlerUserName.view_View WithContent:_model_FirstHandlerUserName.txf_TexfField WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_str_FirstHandlerPhotoGraph}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.img_FirstHandlerUserName = image;
        UIButton *btn = [UIButton new];
        btn.tag = 7;
        [weakSelf btn_Click:btn];
    }];
    [_model_FirstHandlerUserName.view_View addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _model_FirstHandlerUserName.txf_TexfField.text=model.fieldValue;
    }
}

-(void)updateOvertimeHistoryOutputView{
    NSArray *arr = _dic_overtimeHistoryOutput[@"overtimeHistoryDtos"];
    if (arr.count>0) {
        OverTimeHistoryOutputView *view = [OverTimeHistoryOutputView createViewByDic:_dic_overtimeHistoryOutput];
        __block NSInteger view_height = view.zl_height;
        [_model_overtimeHistoryOutput.view_View addSubview:view];
        [_model_overtimeHistoryOutput.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(view_height);
        }];
    }
}

-(void)updateDetailView{
    NSInteger row = 0;
    for (int i = 0; i<_muarr_DetailFld.count; i++) {
        NSArray *arr = _muarr_DetailFld[i];
        row = row + arr.count;
    }
    [_view_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(row*50+self.muarr_DetailFld.count*27);
    }];
    [_tbv_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(row*50+self.muarr_DetailFld.count*27);
    }];
    [_tbv_OverTimeDetail reloadData];
}

//更新付款方式按钮
-(void)updateDetail_btn_View{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_view_OverTimeDetail_btn withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        NSMutableArray *Arr = weakSelf.muarr_DetailFld[0];
        NSMutableArray *new = [NSMutableArray array];
        for (int i = 0; i<Arr.count; i++) {
            WorkFormFieldsModel *new_model = [[WorkFormFieldsModel alloc]initialize];
            WorkFormFieldsModel *old_model = Arr[i];
            new_model.model = old_model.model;
            if ([new_model.model.fieldName isEqualToString:@"Type"]) {
                new_model.model.fieldValue = @"1";
            }
            [new addObject:new_model];
        }
        [weakSelf.muarr_DetailFld addObject:new];
        [weakSelf updateDetailView];
    }];
    [_view_OverTimeDetail_btn updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_OverTimeDetail_btn addSubview:view];
}

#pragma mark--更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    
    _txf_CcToPeople = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_CcToPeople WithContent:_txf_CcToPeople WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf CcPeopleClick];
    }];
    [_View_CcToPeople addSubview:view];
}

#pragma mark--选择抄送人
-(void)CcPeopleClick{
    contactsVController *contactVC=[[contactsVController alloc]init];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [self.str_CcUsersId componentsSeparatedByString:@","];
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
            weakSelf.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
            weakSelf.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            weakSelf.txf_CcToPeople.text=weakSelf.str_CcUsersName;
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//更新滚动视图 基本方法
-(void)updateContentView{
    [_DockBottomView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
    }];
    [_DockBottomView addSubview:[self createUpLineView]];
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.DockBottomView.bottom);
    }];
}

//审批记录
-(void)updateNotesTableView{
    __weak typeof(self) weakSelf = self;
    [_NoteView addSubview:[[FlowChartView alloc] init:_muarr_noteDateArray Y:0 HeightBlock:^(NSInteger height) {
        [weakSelf.NoteView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.model_Reserved1.view_View.bottom).offset(@10);
            make.height.equalTo(height);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}


-(void)readyRequest
{
    NSUInteger index=[_dic_Submit[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Attachments"];
    [_dic_Submit[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:_model_Attachments.Value];
    //3退单 4直送 5保存 6提交
    if (_int_Sub_State == 3) {
        [self requestOvertimeAppApprovalAppData];
    }else if(_int_Sub_State == 4){
        [self requestOvertimeAppDirectAppData];
    }else if (_int_Sub_State == 5){
        [self requestOvertimeAppSaveAppData];
    }else{
        [self requestOvertimeAppSubmitAppData];
    }
}

#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _procId = self.pushProcId;
        _comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    if (_taskId == nil) {
        _taskId = @"";
    }
    if (_procId == nil) {
        _procId = @"";
    }
    _dic_request = [NSDictionary dictionary];
    _muarr_MainView = [NSMutableArray array];
    _str_directType = @"";
    _str_ProjMgrUserId = @"";
    _str_ProjMgr = @"";
    _model_Reason = [[WorkFormFieldsModel alloc]initialize];
    _model_ClientId = [[WorkFormFieldsModel alloc]initialize];
    _model_SupplierId = [[WorkFormFieldsModel alloc]initialize];
    _model_CostCenterId = [[WorkFormFieldsModel alloc]initialize];
    _model_ProjId = [[WorkFormFieldsModel alloc]initialize];
    _model_FromDate = [[WorkFormFieldsModel alloc]initialize];
    _model_ToDate = [[WorkFormFieldsModel alloc]initialize];
    _model_TotalTime = [[WorkFormFieldsModel alloc]initialize];
    _model_Type = [[WorkFormFieldsModel alloc]initialize];
    _model_AccountingModeId = [[WorkFormFieldsModel alloc]initialize];
    _model_Remark = [[WorkFormFieldsModel alloc]initialize];
    _model_Attachments = [[WorkFormFieldsModel alloc]initialize];
    _arr_Attachments_Image = [NSMutableArray array];
    _arr_Attachments_Totle = [NSMutableArray array];
    _model_Reserved1 = [[WorkFormFieldsModel alloc]initialize];
    _model_FirstHandlerUserName = [[WorkFormFieldsModel alloc]initialize];
    _model_overtimeHistoryOutput = [[WorkFormFieldsModel alloc]initialize];
    _muarr_DetailFld = [NSMutableArray array];
    _dic_Submit = [NSMutableDictionary dictionary];
    self.FormData=[[FormBaseModel alloc]initBaseWithStatus:1];
    self.FormData.str_flowCode=@"F0017";
    _dic_RequestNote = [NSDictionary dictionary];
    _muarr_noteDateArray = [NSMutableArray array];
    _dic_overtimeHistoryOutput = [NSDictionary dictionary];
    _str_FirstHandlerPhotoGraph = @"";
    NSArray *arr = @[Custing(@"工作日", nil),Custing(@"双休日", nil),Custing(@"法定节假日", nil),Custing(@"公司节假日", nil)];
    _arr_OverTimeType = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Id = [NSString stringWithFormat:@"%d",i+1];
        model.Type = arr[i];
        [_arr_OverTimeType addObject:model];
    }
    _arr_AccountingModeId = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Id = [NSString stringWithFormat:@"%d",i+1];
        model.Type = i==0?Custing(@"申请加班费", nil):Custing(@"申请调休", nil);
        [_arr_AccountingModeId addObject:model];
    }
    _model_rs = [[ReserverdMainModel alloc]init];
}

//处理请求后数据
-(void)analysisRequestData{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dic_request[@"result"][@"formFields"][@"mainFld"]];
    _str_directType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"directType"]]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"directType"]]:@"0";
    _str_overtimeDetail = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"overtimeDetail"]]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"overtimeDetail"]]:@"0";
    _dic_overtimeHistoryOutput = _dic_request[@"result"][@"overtimeHistoryOutput"];
    
    [self.FormData getFormSettingBaseData:[self.dic_request objectForKey:@"result"]];

    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [_muarr_MainView addObject:model];
            
            [_FormData getMainFormShowAndData:dic WithAttachmentsMaxCont:5];

            if ([model.fieldName isEqualToString:@"ClientName"]) {
                _model_ClientId.Value = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"SupplierName"]) {
                _model_SupplierId.Value = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"CostCenter"]) {
                _model_CostCenterId.Value = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"ProjName"]) {
                _model_ProjId.Value = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"ProjMgrUserId"]) {
                _str_ProjMgrUserId = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"ProjMgr"]) {
                _str_ProjMgr = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"AccountingMode"]) {
                _model_AccountingModeId.Value = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Attachments"]) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = [self transformToNSArrayFromString:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_arr_Attachments_Totle addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_arr_Attachments_Totle WithImageArray:_arr_Attachments_Image WithMaxConut:5];
                }
            }
            if ([model.fieldName isEqualToString:@"FirstHandlerUserName"]) {
                _model_FirstHandlerUserName.model = model;
            }
            if ([model.fieldName isEqualToString:@"FirstHandlerUserId"]) {
                _model_FirstHandlerUserName.Id = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FirstHandlerPhotoGraph"]) {
                if ([NSString isEqualToNull:model.fieldValue]) {
                    NSDictionary * dic = [GPUtils transformToDictionaryFromString:model.fieldValue];
                    NSString *str =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                    _str_FirstHandlerPhotoGraph = [NSString isEqualToNull:str]?str:@"";
                }
            }
            if ([model.fieldName isEqualToString:@"CcUsersId"]) {
                self.str_CcUsersId = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"CcUsersName"]) {
                self.str_CcUsersName = [NSString stringWithIdOnNO:model.fieldValue];
            }
        }
    }
   
    [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:_dic_request[@"result"] WithFormArray:_muarr_MainView];
    NSMutableArray *muarr = [NSMutableArray array];
    if ([_str_overtimeDetail integerValue]==1) {
        if ([_dic_request[@"result"][@"formFields"][@"detailFld"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = _dic_request[@"result"][@"formFields"][@"detailFld"];
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                if ([model.fieldName isEqualToString:@"Type"]) {
                    model.fieldValue=@"1";
                }
                WorkFormFieldsModel *models = [[WorkFormFieldsModel alloc]initialize];
                models.model = model;
                [muarr addObject:models];
            }
            [_muarr_DetailFld addObject:muarr];
        }
        if (muarr.count>0&&[_dic_request[@"result"][@"formData"] isKindOfClass:[NSDictionary class]]) {
            NSArray *arr = _dic_request[@"result"][@"formData"][@"sa_OvertimeDetail"];
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count>0) {
                    [_muarr_DetailFld removeAllObjects];
                    for (int i = 0; i<arr.count; i++) {
                        NSDictionary *dic = arr[i];
                        NSMutableArray *newarr = [NSMutableArray array];
                        for (int a = 0; a<muarr.count; a++) {
                            WorkFormFieldsModel *work = [[WorkFormFieldsModel alloc]initialize];
                            WorkFormFieldsModel *oldwork = muarr[a];
                            work.model = [oldwork.model copy];
                            if ([work.model.fieldName isEqualToString:@"Type"]&&[NSString isEqualToNull:dic[@"type"]]) {
                                work.model.fieldValue = dic[@"type"];
                            }else if ([work.model.fieldName isEqualToString:@"FromDate"]&&[NSString isEqualToNull:dic[@"fromDate"]]) {
                                work.model.fieldValue = dic[@"fromDate"];
                            }else if ([work.model.fieldName isEqualToString:@"ToDate"]&&[NSString isEqualToNull:dic[@"toDate"]]) {
                                work.model.fieldValue = dic[@"toDate"];
                            }else if ([work.model.fieldName isEqualToString:@"OverTime"]&&[NSString isEqualToNull:dic[@"overTime"]]) {
                                work.model.fieldValue = dic[@"overTime"];
                            }else if ([work.model.fieldName isEqualToString:@"Reason"]&&[NSString isEqualToNull:dic[@"reason"]]) {
                                work.model.fieldValue = dic[@"reason"];
                            }else if ([work.model.fieldName isEqualToString:@"AccountingModeId"]&&[NSString isEqualToNull:dic[@"accountingModeId"]]) {
                                work.model.fieldValue = dic[@"accountingModeId"];
                            }
                            [newarr addObject:work];
                        }
                        [_muarr_DetailFld addObject:newarr];
                    }
                }
            }
        }
    }
}

//审批记录数据
-(void)analysisRequestNoteData
{
    NSDictionary *result = [_dic_RequestNote objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        NSArray *array = result[@"taskProcList"];
        _muarr_noteDateArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model=[[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_muarr_noteDateArray addObject:model];
        }
    }
}

-(void)jointResponse{
    _model_Submit = [[OvertimeModel alloc]init];
    _model_Submit.Requestor = self.FormData.personalData.Requestor;
    _model_Submit.RequestorUserId = self.FormData.personalData.RequestorUserId;
    _model_Submit.CompanyId = self.FormData.personalData.CompanyId;
    _model_Submit.RequestorAccount = self.FormData.personalData.RequestorAccount;
    _model_Submit.RequestorDeptId = self.FormData.personalData.RequestorDeptId;
    _model_Submit.RequestorDept = self.FormData.personalData.RequestorDept;
    _model_Submit.JobTitleCode = self.FormData.personalData.JobTitleCode;
    _model_Submit.JobTitle = self.FormData.personalData.JobTitle;
    _model_Submit.JobTitleLvl = self.FormData.personalData.JobTitleLvl;
    _model_Submit.UserLevelId = self.FormData.personalData.UserLevelId;
    _model_Submit.UserLevel = self.FormData.personalData.UserLevel;
    _model_Submit.HRID = self.FormData.personalData.Hrid;
    _model_Submit.BranchId = self.FormData.personalData.BranchId;
    _model_Submit.Branch = self.FormData.personalData.Branch;
    _model_Submit.RequestorBusDeptId = self.FormData.personalData.RequestorBusDeptId;
    _model_Submit.RequestorBusDept = self.FormData.personalData.RequestorBusDept;
    _model_Submit.AreaId = self.FormData.personalData.AreaId;
    _model_Submit.Area = self.FormData.personalData.Area;
    _model_Submit.LocationId=self.FormData.personalData.LocationId;
    _model_Submit.Location=self.FormData.personalData.Location;
    _model_Submit.UserReserved1 = self.FormData.personalData.UserReserved1;
    _model_Submit.UserReserved2 = self.FormData.personalData.UserReserved2;
    _model_Submit.UserReserved3 = self.FormData.personalData.UserReserved3;
    _model_Submit.UserReserved4 = self.FormData.personalData.UserReserved4;
    _model_Submit.UserReserved5 = self.FormData.personalData.UserReserved5;
    _model_Submit.RequestorDate = self.FormData.personalData.RequestorDate;
    
    _model_Submit.ApproverId1=self.FormData.personalData.ApproverId1;
    _model_Submit.ApproverId2=self.FormData.personalData.ApproverId2;
    _model_Submit.ApproverId3=self.FormData.personalData.ApproverId3;
    _model_Submit.ApproverId4=self.FormData.personalData.ApproverId4;
    _model_Submit.ApproverId5=self.FormData.personalData.ApproverId5;
    _model_Submit.UserLevelNo=self.FormData.personalData.UserLevelNo;
    
    _model_Submit.OperatorUserId=self.FormData.operatorData.OperatorUserId;
    _model_Submit.Operator=self.FormData.operatorData.Operator;
    _model_Submit.OperatorDeptId=self.FormData.operatorData.OperatorDeptId;
    _model_Submit.OperatorDept=self.FormData.operatorData.OperatorDept;

    _model_Submit.CcUsersId=self.str_CcUsersId;
    _model_Submit.CcUsersName=self.str_CcUsersName;

    
    _model_Submit.Reason = _model_Reason.txf_TexfField.text;
    _model_Submit.ClientId = _model_ClientId.Id;
    _model_Submit.ClientName = _model_ClientId.txf_TexfField.text;
    _model_Submit.SupplierId = _model_SupplierId.Id;
    _model_Submit.SupplierName = _model_SupplierId.txf_TexfField.text;
    _model_Submit.CostCenterId = _model_CostCenterId.Id;
    _model_Submit.CostCenter = _model_CostCenterId.txf_TexfField.text;
    _model_Submit.ProjId = _model_ProjId.Id;
    _model_Submit.ProjName = _model_ProjId.txf_TexfField.text;
    _model_Submit.ProjMgrUserId = _str_ProjMgrUserId;
    _model_Submit.ProjMgr = _str_ProjMgr;
    _model_Submit.FromDate = _model_FromDate.txf_TexfField.text;
    _model_Submit.ToDate = _model_ToDate.txf_TexfField.text;
    _model_Submit.TotalTime = _model_TotalTime.txf_TexfField.text;
    _model_Submit.Type = _model_Type.Id;
    _model_Submit.AccountingMode = _model_AccountingModeId.txf_TexfField.text;
    _model_Submit.AccountingModeId = _model_AccountingModeId.Id;
    _model_Submit.Remark = _txv_Remark.text;
    _model_Submit.Attachments = _model_Attachments.Value;
    _model_Submit.Reserved1 = _model_rs.Reserverd1;
    _model_Submit.Reserved2 = _model_rs.Reserverd2;
    _model_Submit.Reserved3 = _model_rs.Reserverd3;
    _model_Submit.Reserved4 = _model_rs.Reserverd4;
    _model_Submit.Reserved5 = _model_rs.Reserverd5;
    _model_Submit.Reserved6 = _model_rs.Reserverd6;
    _model_Submit.Reserved7 = _model_rs.Reserverd7;
    _model_Submit.Reserved8 = _model_rs.Reserverd8;
    _model_Submit.Reserved9 = _model_rs.Reserverd9;
    _model_Submit.Reserved10 = _model_rs.Reserverd10;
    _model_Submit.FirstHandlerUserId = _model_FirstHandlerUserName.Id;
    _model_Submit.FirstHandlerUserName = _model_FirstHandlerUserName.txf_TexfField.text;
    _model_Submit.TwoHandlerUserId = @"";
    _model_Submit.TwoHandlerUserName = @"";
}

-(void)mainDataList{
    NSMutableDictionary *dic_detailedDataList = [[NSMutableDictionary alloc]init];
    NSDictionary *dic = [NSObject getObjectData:_model_Submit];
    NSMutableArray *arr_key = [NSMutableArray arrayWithArray:[dic allKeys]];
    NSMutableArray *arr_value = [NSMutableArray arrayWithArray:[dic allValues]];
    NSMutableArray *arr_mainDataList = [NSMutableArray arrayWithArray:@[@{@"fieldNames":arr_key,@"fieldValues":arr_value,@"tableName":@"Sa_OvertimeApp"}]];
    
    //拼接加班申请
    NSMutableArray *arr_OvertimeDetail_name = [NSMutableArray arrayWithArray:@[@"type",@"fromdate",@"todate",@"overtime",@"reason",@"accountingmodeid",@"accountingmode"]];
    NSMutableArray *arr_OvertimeDetail_Type = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_FromDate = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_ToDate = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_OverTime = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_Reason = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_AccountingModeId = [NSMutableArray array];
    NSMutableArray *arr_OvertimeDetail_AccountingMode = [NSMutableArray array];
    NSMutableDictionary *dic_OvertimeDetail = [[NSMutableDictionary alloc]init];
    [dic_OvertimeDetail setObject:@"Sa_OvertimeDetail" forKey:@"tableName"];
    if (_muarr_DetailFld.count>0) {
        for (int i = 0; i<_muarr_DetailFld.count; i++) {
            [arr_OvertimeDetail_Type addObject:[NSNull null]];
            [arr_OvertimeDetail_FromDate addObject:[NSNull null]];
            [arr_OvertimeDetail_ToDate addObject:[NSNull null]];
            [arr_OvertimeDetail_OverTime addObject:[NSNull null]];
            [arr_OvertimeDetail_Reason addObject:[NSNull null]];
            [arr_OvertimeDetail_AccountingModeId addObject:[NSNull null]];
            [arr_OvertimeDetail_AccountingMode addObject:[NSNull null]];
            NSArray *arr = _muarr_DetailFld[i];
            for (int a = 0; a<arr.count; a++) {
                WorkFormFieldsModel *model = arr[a];
                if ([model.model.fieldName isEqualToString:@"Type"]) {
                    if ([NSString isEqualToNull:model.txf_TexfField.text]) {
                        BOOL is = NO;
                        for (int s = 0; s<_arr_OverTimeType.count; s++) {
                            STOnePickModel *models = _arr_OverTimeType[s];
                            if ([model.txf_TexfField.text isEqualToString:models.Type]) {
                                [arr_OvertimeDetail_Type replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",s+1]];
                                is = YES;
                            }
                        }
                        if (!is) {
                            [arr_OvertimeDetail_Type replaceObjectAtIndex:i withObject:[NSNull null]];
                        }
                    }else{
                        [arr_OvertimeDetail_Type replaceObjectAtIndex:i withObject:[NSNull null]];
                    }
                }
                if ([model.model.fieldName isEqualToString:@"FromDate"]) {
                    [arr_OvertimeDetail_FromDate replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.txf_TexfField.text]?model.txf_TexfField.text:[NSNull null]];
                }else if ([model.model.fieldName isEqualToString:@"ToDate"]) {
                    [arr_OvertimeDetail_ToDate replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.txf_TexfField.text]?model.txf_TexfField.text:[NSNull null]];
                }else if ([model.model.fieldName isEqualToString:@"OverTime"]) {
                    [arr_OvertimeDetail_OverTime replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.txf_TexfField.text]?model.txf_TexfField.text:[NSNull null]];
                }else if ([model.model.fieldName isEqualToString:@"Reason"]) {
                    [arr_OvertimeDetail_Reason replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.txf_TexfField.text]?model.txf_TexfField.text:[NSNull null]];
                }else if ([model.model.fieldName isEqualToString:@"AccountingModeId"]) {
                    [arr_OvertimeDetail_AccountingModeId replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.Id]?model.Id:[NSNull null]];
                    [arr_OvertimeDetail_AccountingMode replaceObjectAtIndex:i withObject:[NSString isEqualToNull:model.txf_TexfField.text]?model.txf_TexfField.text:[NSNull null]];
                }
            }
        }
    }else{
        [arr_OvertimeDetail_Type addObject:[NSNull null]];
        [arr_OvertimeDetail_FromDate addObject:[NSNull null]];
        [arr_OvertimeDetail_ToDate addObject:[NSNull null]];
        [arr_OvertimeDetail_OverTime addObject:[NSNull null]];
        [arr_OvertimeDetail_Reason addObject:[NSNull null]];
        [arr_OvertimeDetail_AccountingModeId addObject:[NSNull null]];
        [arr_OvertimeDetail_AccountingMode addObject:[NSNull null]];
    }
    [dic_OvertimeDetail setObject:arr_OvertimeDetail_name forKey:@"fieldNames"];
    [dic_OvertimeDetail setObject:@[arr_OvertimeDetail_Type,arr_OvertimeDetail_FromDate,arr_OvertimeDetail_ToDate,arr_OvertimeDetail_OverTime,arr_OvertimeDetail_Reason,arr_OvertimeDetail_AccountingModeId,arr_OvertimeDetail_AccountingMode] forKey:@"fieldBigValues"];
    [dic_detailedDataList setObject:[NSMutableArray arrayWithArray:@[dic_OvertimeDetail]] forKey:@"detailedDataList"];
    
    [dic_detailedDataList setObject:arr_mainDataList forKey:@"mainDataList"];
    _dic_Submit = dic_detailedDataList;
}

//测试数据
-(BOOL)testData{
    BOOL bo = YES;
    NSString * str = @"";
    for (MyProcurementModel *model  in _muarr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.isRequired] isEqualToString:@"1"] ) {
            if ([model.fieldName isEqualToString:@"RequestorDeptId"]&&![NSString isEqualToNull:self.FormData.personalData.RequestorDept]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"AreaId"]&&![NSString isEqualToNull:self.FormData.personalData.Area]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"LocationId"]&&![NSString isEqualToNull:self.FormData.personalData.LocationId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@",model.tips];
            }else if ([model.fieldName isEqualToString:@"CcUsersName"]&&![NSString isEqualToNull:self.str_CcUsersName]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@",model.tips];
            }else if ([model.fieldName isEqualToString:@"UserLevelId"]&&![NSString isEqualToNull:self.FormData.personalData.UserLevel]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"BranchId"]&&![NSString isEqualToNull:self.FormData.personalData.BranchId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]&&![NSString isEqualToNull:self.FormData.personalData.RequestorBusDeptId]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reason"]&&![NSString isEqualToNull:_model_Reason.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ClientId"]&&![NSString isEqualToNull:_model_ClientId.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"SupplierId"]&&![NSString isEqualToNull:_model_SupplierId.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"CostCenterId"]&&![NSString isEqualToNull:_model_CostCenterId.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ProjId"]&&![NSString isEqualToNull:_model_ProjId.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"FromDate"]&&![NSString isEqualToNull:_model_FromDate.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ToDate"]&&![NSString isEqualToNull:_model_ToDate.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"TotalTime"]&&![NSString isEqualToNull:_model_TotalTime.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Type"]&&![NSString isEqualToNull:_model_Type.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"AccountingModeId"]&&![NSString isEqualToNull:_model_AccountingModeId.txf_TexfField.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Remark"]&&![NSString isEqualToNull:_txv_Remark.text]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Attachments"]&&_arr_Attachments_Image.count==0) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]&&![NSString isEqualToNull:_model_rs.Reserverd1]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved2"]&&![NSString isEqualToNull:_model_rs.Reserverd2]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved3"]&&![NSString isEqualToNull:_model_rs.Reserverd3]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved4"]&&![NSString isEqualToNull:_model_rs.Reserverd4]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved5"]&&![NSString isEqualToNull:_model_rs.Reserverd5]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved6"]&&![NSString isEqualToNull:_model_rs.Reserverd6]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved7"]&&![NSString isEqualToNull:_model_rs.Reserverd7]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved8"]&&![NSString isEqualToNull:_model_rs.Reserverd8]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved9"]&&![NSString isEqualToNull:_model_rs.Reserverd9]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved10"]&&![NSString isEqualToNull:_model_rs.Reserverd10]) {
                bo = NO;
                str = [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }
            if (!bo) {
                break;
            }
        }
        if([model.fieldName isEqualToString:@"ApprovalMode"]&&[[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"])
        {
            if (![NSString isEqualToNull:_model_FirstHandlerUserName.txf_TexfField.text] ) {
                bo = NO;
                str = Custing(@"请选择审批人",nil);
                break;
            }
        }
    }
    if (bo) {
        if (_muarr_DetailFld.count>0) {
            for (int i = 0; i<_muarr_DetailFld.count; i++) {
                NSArray *arr = _muarr_DetailFld[i];
                for (int a = 0; a<arr.count; a++) {
                    WorkFormFieldsModel *model = arr[a];
                    if ([[NSString stringWithFormat:@"%@",model.model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.model.isRequired] isEqualToString:@"1"]&&![NSString isEqualToNull:model.txf_TexfField.text]) {
                        bo = NO;
                        str = [NSString stringWithFormat:@"%@(%d)%@",Custing(@"请输入加班申请", nil),i+1,model.model.Description];
                        break;
                    }
                }
            }
        }
    }
    
    if (!bo) {
        _dockView.userInteractionEnabled = YES;
        [[GPAlertView sharedAlertView]showAlertText:self WithText:str duration:1.0];
    }
    return bo;
}

#pragma mark 网络请求
-(void)requestOverTime{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",OvertimeGetOvertimeData];
    NSDictionary *parameters = @{@"TaskId": _taskId,@"ProcId":_procId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//处理图片请求 ProcurementLoadImage
-(void)requestUploadImage{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:_arr_Attachments_Totle WithUrl:Overtimeuploader WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.model_Attachments.Value = data;;
            [weakSelf readyRequest];
        }
    }];
}

-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:13 IfUserCache:NO];
}

//保存表单数据
-(void)requestOvertimeAppSaveAppData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = [self SaveFormDateUserId:[NSString stringWithFormat:@"%@",self.FormData.personalData.RequestorUserId] WithFlowGuid:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]] WithFlowCode:@"F0017" WithTaskId:_taskId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
    NSString *url =[NSString stringWithFormat:@"%@",SAVE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

//提交
-(void)requestOvertimeAppSubmitAppData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",SUBMIT];
    NSDictionary *parameters = [self SubmitFormDateUserId:[NSString stringWithFormat:@"%@",self.FormData.personalData.RequestorUserId] WithFlowGuid:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]] WithFlowCode:@"F0017" WithTaskId:_taskId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}

//撤回提交
-(void)requestOvertimeAppApprovalAppData{
    if (_comeStatus==4) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",APPROVAL];
        NSDictionary *parameters = [self SubmitFormAgainTaskId:_taskId WithProcId:_procId WithFormData:_dic_Submit WithExpIds:@"" WithComment:@"" WithCommonField:@""];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
    }else{
        FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
        FormDatas.str_flowCode=@"F0017";
        FormDatas.str_taskId=_taskId;
        FormDatas.str_procId=_procId;
        FormDatas.dict_parametersDict=_dic_Submit;
        self.dockView.userInteractionEnabled=YES;
        BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
        vc.FormDatas=FormDatas;
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//直送提交
-(void)requestOvertimeAppDirectAppData{
    FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
    FormDatas.str_flowGuid=[NSString isEqualToNull:_dic_request[@"result"][@"flowGuid"]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"flowGuid"]]:@"";
    FormDatas.str_flowCode=@"F0017";
    FormDatas.str_taskId=_taskId;
    FormDatas.str_procId=_procId;
    FormDatas.dict_parametersDict=_dic_Submit;
    
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];

}

//获取审批记录
-(void)requestApproveNote{
    NSString *url=[NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:7 IfUserCache:NO];
}

#pragma mark - action
-(void)btn_Click:(UIButton *)btn{
    [self keyClose];
    switch (btn.tag) {
            //退单提交提交
        case 3:
        {
            _int_Sub_State = 3;
            [self jointResponse];
            if ([self testData]) {
                [self mainDataList];
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //直送
        case 4:
        {
            _int_Sub_State = 4;
            [self jointResponse];
            [self mainDataList];
            if ([self testData]) {
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //保存
        case 5:
        {
            _int_Sub_State = 5;
            _dockView.userInteractionEnabled = NO;
            [self jointResponse];
            [self mainDataList];
            [self requestUploadImage];
            break;
        }
            //提交
        case 6:
        {
            _int_Sub_State = 6;
            [self jointResponse];
            [self mainDataList];
            if ([self testData]) {
                _dockView.userInteractionEnabled = NO;
                [self requestUploadImage];
            }
            break;
        }
            //选择审批人
        case 7:
        {
            [self keyClose];
            NSMutableArray *array = [NSMutableArray array];
            NSArray *idarr = [_model_FirstHandlerUserName.Id componentsSeparatedByString:@","];
            for (int i = 0 ; i<idarr.count ; i++) {
                NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                [array addObject:dic];
            }
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"1";
            contactVC.arrClickPeople = array;
            contactVC.menutype=3;
            contactVC.itemType = 17;
            __weak typeof(self) weakSelf = self;
            [contactVC setBlock:^(NSMutableArray *array) {
                buildCellInfo *_firstinfo = array.lastObject;
                weakSelf.model_FirstHandlerUserName.txf_TexfField.text = [NSString stringWithFormat:@"%@",_firstinfo.requestor];
                weakSelf.model_FirstHandlerUserName.Id = [NSString stringWithFormat:@"%ld",(long)_firstinfo.requestorUserId];
                if ([NSString isEqualToNull:_firstinfo.photoGraph]) {
                    NSDictionary * dic = [GPUtils transformToDictionaryFromString:_firstinfo.photoGraph];
                    NSString *str =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                    if ([NSString isEqualToNull:str]) {
                        [weakSelf.img_FirstHandlerUserName sd_setImageWithURL:[NSURL URLWithString:str]];
                    }else{
                        weakSelf.img_FirstHandlerUserName.image=_firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
                    }
                }
                else{
                    weakSelf.img_FirstHandlerUserName.image=_firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
                }
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
            break;
        }
    }
}

-(void)OverTimeModeDetail_Click:(UIButton *)btn{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:@"" message:Custing(@"你确定要删除加班申请明细吗？", nil) cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"删除",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf.muarr_DetailFld removeObjectAtIndex:btn.tag];
            [weakSelf updateDetailView];
        }
    }];
}

//自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dockView.userInteractionEnabled = YES;
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString isEqualToNull:error]?error:Custing(@"网络请求失败", nil) duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self creationRootView];
        [self creationMainView];
        [self creationDockView];
        if (_comeStatus==3) {
            [self requestApproveNote];
        }else{
            [self updateMainView];
            [self updateContentView];
        }
    }
    if (serialNum == 1) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }
    if (serialNum == 2||serialNum == 3) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            LookOverTimeViewController *look = [[LookOverTimeViewController alloc]init];
            look.comeStatus=1;
            if (self.comeStatus==1) {
                look.backIndex=@"0";
            }else{
                look.backIndex=@"1";
            }
            look.taskId = [responceDic objectForKey:@"result"];
            [self.navigationController pushViewController:look animated:YES];
        } afterDelay:1.5];
    }
    if (serialNum == 4) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }
    if (serialNum == 7) {
        _dic_RequestNote = responceDic;
        [self analysisRequestNoteData];
        [self updateMainView];
        [self updateContentView];
    }
    if (serialNum == 13) {
        boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@",ip_web,[responceDic objectForKey:@"result"]]];
        bo.str_title = Custing(@"流程图", nil);
        [self.navigationController pushViewController:bo animated:YES];
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _muarr_DetailFld.count;
}

// 返回参数2指定分组的行数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = _muarr_DetailFld[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *arr = _muarr_DetailFld[indexPath.section];
    WorkFormFieldsModel *model = arr[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];
    if (indexPath.row!=arr.count-1) {
        [cell addSubview:[self createLineViewOfHeight:49.5 X:12]];
    }
    if ([NSString isEqualToNull:model.txf_TexfField.text]) {
        model.Value = model.txf_TexfField.text;
    }
    SubmitFormView *view;
    if ([model.model.fieldName isEqualToString:@"FromDate"]||[model.model.fieldName isEqualToString:@"ToDate"]) {
        view =[[SubmitFormView alloc]initBaseView:model.view_View WithContent:model.txf_TexfField WithFormType:formViewSelectDateTime WithSegmentType:lineViewNone Withmodel:model.model WithInfodict:nil];
        model.txf_TexfField.tag = indexPath.section;
        __block UITextField *txf = model.txf_TexfField;
        [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
            [weakSelf countDate:txf];
        }];
    }else if ([model.model.fieldName isEqualToString:@"Type"]) {
        view =[[SubmitFormView alloc]initBaseView:model.view_View WithContent:model.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNone Withmodel:model.model WithInfodict:nil];
        if ([NSString isEqualToNull:model.model.fieldValue]) {
            STOnePickModel *models = _arr_OverTimeType[[model.model.fieldValue integerValue]-1];
            model.txf_TexfField.text = models.Type;
        }
        __weak WorkFormFieldsModel *weakModel = model;
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakModel.txf_TexfField.text = Model.Type;
                weakModel.Id = Model.Id;
            }];
            picker.typeTitle = Custing(@"加班类型", nil);
            picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_OverTimeType];
            STOnePickModel *stmodel = [[STOnePickModel alloc]init];
            stmodel.Id = [NSString isEqualToNull:weakModel.Id]?weakModel.Id:@"";
            picker.Model = stmodel;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
    }else if ([model.model.fieldName isEqualToString:@"AccountingModeId"]) {
        view =[[SubmitFormView alloc]initBaseView:model.view_View WithContent:model.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNone Withmodel:model.model WithInfodict:nil];
        if ([NSString isEqualToNull:model.model.fieldValue]) {
            STOnePickModel *models = _arr_AccountingModeId[[model.model.fieldValue integerValue]-1];
            model.txf_TexfField.text = models.Type;
        }
        __weak typeof(self) weakSelf = self;
        __weak WorkFormFieldsModel *weakModel = model;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakModel.txf_TexfField.text = Model.Type;
                weakModel.Id = Model.Id;
            }];
            picker.typeTitle = Custing(@"加班核算方式", nil);
            picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_AccountingModeId];
            STOnePickModel *stmodel = [[STOnePickModel alloc]init];
            stmodel.Id = [NSString isEqualToNull:weakModel.Id]?weakModel.Id:@"";
            picker.Model = stmodel;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
    }else{
        if ([model.model.fieldName isEqualToString:@"OverTime"]) {
            view=[[SubmitFormView alloc]initBaseView:model.view_View WithContent:model.txf_TexfField WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model.model WithInfodict:nil];
            model.txf_TexfField.tag = 999+indexPath.row;
            [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                [weakSelf updateCountTime];
            }];
            model.txf_TexfField.bk_shouldEndEditingBlock = ^BOOL(UITextField * txf) {
                [weakSelf updateCountTime];
                return YES;
            };
        }else{
            view=[[SubmitFormView alloc]initBaseView:model.view_View WithContent:model.txf_TexfField WithFormType:formViewEnterText WithSegmentType:lineViewNone Withmodel:model.model WithInfodict:nil];
        }
    }
    
    if ([NSString isEqualToNull:model.Value]) {
        model.txf_TexfField.text = model.Value;
    }
    [cell addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createPayModeDetailFldWithSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =Color_WhiteWeak_Same_20;
    return view;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextField *tx = object;
    if ([keyPath isEqualToString:@"text"]) {
        if (tx.tag>=0&&tx.tag<_muarr_DetailFld.count) {
            [self countDate:tx];
        }
        if (tx.tag>990) {
            [self updateCountTime];
        }
    }
}


-(void)countDate:(UITextField *)tx{
    NSArray *arr = _muarr_DetailFld[tx.tag];
    WorkFormFieldsModel *form = [[WorkFormFieldsModel alloc]initialize];
    WorkFormFieldsModel *to = [[WorkFormFieldsModel alloc]initialize];
    WorkFormFieldsModel *time = [[WorkFormFieldsModel alloc]initialize];
    for (int i = 0; i<arr.count; i++) {
        WorkFormFieldsModel *model = arr[i];
        if ([model.model.fieldName isEqualToString:@"FromDate"]) {
            form = model;
        }else if ([model.model.fieldName isEqualToString:@"ToDate"]) {
            to = model;
        }else if ([model.model.fieldName isEqualToString:@"OverTime"]) {
            time = model;
        }
    }
    if (form.txf_TexfField && to.txf_TexfField && time.txf_TexfField) {
        NSString *lastTime = [NSDate CountDateTime:form.txf_TexfField.text to:to.txf_TexfField.text];
        if (![lastTime isEqualToString:@"-1"]&&[NSString isEqualToNull:lastTime]) {
            time.txf_TexfField.text = lastTime;
            [self updateCountTime];
        }else if([lastTime isEqualToString:@"-1"]){
            if (tx == form.txf_TexfField) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开始时间不能大于结束时间", nil) duration:1.0];
                form.txf_TexfField.text = to.txf_TexfField.text;
            }
            if (tx == to.txf_TexfField) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.0];
                to.txf_TexfField.text = form.txf_TexfField.text;
            }
        }
    }
}

-(void)updateCountTime{
    float time = 0.00;
    for (int i = 0; i<_muarr_DetailFld.count; i++) {
        NSArray *arr = _muarr_DetailFld[i];
        for (int a = 0; a<arr.count; a++) {
            WorkFormFieldsModel *model = arr[a];
            if ([model.model.fieldName isEqualToString:@"OverTime"]) {
                time = time + [model.txf_TexfField.text floatValue];
            }
        }
    }
    if (time>0) {
        _model_TotalTime.txf_TexfField.text = [NSString notRounding:[NSString stringWithFormat:@"%f",time] afterPoint:2];
    }
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
