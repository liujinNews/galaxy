//
//  LookOverTimeViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/14.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "LookOverTimeViewController.h"
#import "OverTimeHistoryOutputView.h"

@interface LookOverTimeViewController ()<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scr_RootScrollView;//滚动视图
@property (nonatomic, strong) UIView *view_ContentView;//滚动视图contentView
@property (nonatomic, strong) DoneBtnView *dockView;//下部按钮底层视图
@property (nonatomic, strong) UIButton *backBtn;//退单按钮
@property (nonatomic, strong) UIButton *recallBtn;//撤回按钮
@property (nonatomic, strong) UIButton *refuseBtn;//拒绝按钮
@property (nonatomic, strong) UIButton *agreeBtn;//同意按钮
@property (nonatomic, assign) BOOL isOpenDetail;//查看更多明细打开是否

@property (nonatomic, strong) NSDictionary *dic_request;
@property (nonatomic, strong) NSDictionary *dic_approve;//审批数据
@property (nonatomic, strong) NSDictionary *dic_operatorUser;
@property (nonatomic, strong) NSString *canEndorsel;//是否显示加签
@property (nonatomic, strong) NSString *Str_SerialNo;
@property (nonatomic, strong) NSMutableArray *arr_MainView;
@property (nonatomic, strong) NSMutableArray *arr_Approve;
@property (nonatomic, strong) NSString *noteStatus;//表单当前状态
@property (nonatomic, assign) NSInteger NotesTableHeight;//审批记录tableView高度

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;

@property (nonatomic, strong) NSMutableArray *arr_img_total;
@property (nonatomic, strong) NSMutableArray *arr_img;
//@property (nonatomic, assign) NSInteger int_firstHandlerGender;// 第一审批人性别

@property (nonatomic, strong) NSString *twoHandeId;//第二审批人Id
@property (nonatomic, strong) NSString *twoApprovalName;//第二审批人名字
@property (nonatomic, strong) NSString *commentIdea;//提交退单拒绝意见
@property (nonatomic, strong) NSDictionary *parametersDict;//提交和保存的提交字典
@property (nonatomic, assign) NSInteger int_isBeforehand;//1事前0事后
@property (nonatomic, strong) NSDictionary *dic_OvertimeHistoryOutput;//加班记录

@property (nonatomic, strong) WorkFormFieldsModel *model_Reason;
@property (nonatomic, strong) WorkFormFieldsModel *model_ClientId;
@property (nonatomic, strong) WorkFormFieldsModel *model_SupplierId;
@property (nonatomic, strong) WorkFormFieldsModel *model_CostCenterId;
@property (nonatomic, strong) WorkFormFieldsModel *model_ProjId;
@property (nonatomic, strong) WorkFormFieldsModel *model_FromDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_ToDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_TotalTime;
@property (nonatomic, strong) WorkFormFieldsModel *model_Type;
@property (nonatomic, strong) WorkFormFieldsModel *model_AccountingModeId;
@property (nonatomic, strong) UIView *view_OverTimeDetail;
@property (nonatomic, strong) UITableView *tbv_OverTimeDetail;
@property (nonatomic, strong) WorkFormFieldsModel *model_Remark;
@property (nonatomic, strong) WorkFormFieldsModel *model_Attachments;
@property (nonatomic, strong) WorkFormFieldsModel *model_Reserved1;
@property (nonatomic, strong) WorkFormFieldsModel *model_FirstHandlerUserName;
@property (nonatomic, strong) UIImageView *img_FirstHandlerUserName;
@property (nonatomic, strong) NSString *str_overtimeDetail;
@property (nonatomic, strong) WorkFormFieldsModel *model_overtimeHistoryOutput;
@property (nonatomic, strong) NSDictionary *dic_overtimeHistoryOutput;

@property (nonatomic, strong) WorkFormFieldsModel *model_Line1;
@property (nonatomic, strong) WorkFormFieldsModel *model_Line2;
@property (nonatomic, strong) WorkFormFieldsModel *model_Line3;

@property (nonatomic, strong) UIView *NoteView;//审批记录
@property (nonatomic, strong) NSDictionary *dic_RequestNote;
@property (nonatomic, strong) NSMutableArray *arr_OverTimeType;
@property (nonatomic, strong) NSMutableArray *arr_AccountingModeId;

@property (nonatomic, strong) NSMutableArray *muarr_DetailFld;
@property (nonatomic, strong) FormBaseModel *FormData;
@property (nonatomic, strong) UIButton *LookMore;

@property (nonatomic, strong) NSMutableArray *arr_More;//更多按钮显示数组

/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;


@end

@implementation LookOverTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=Color_White_Same_20;
    [self initializeData];
    NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowCode];
    [self setTitle:dict[@"Title"] backButton:YES];
    [self requestOvertimeGetFormData];
}

#pragma mark - function
#pragma mark view
-(void)creationRootView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    self.view_ContentView =[[BottomView alloc]init];
    self.view_ContentView.userInteractionEnabled=YES;
    self.view_ContentView.backgroundColor=Color_White_Same_20;
    [_scr_RootScrollView addSubview:self.view_ContentView];
    
    [self.view_ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_RootScrollView);
        make.width.equalTo(self.scr_RootScrollView);
    }];
    
    if (_comeStatus==2||_comeStatus==3||_comeStatus==7||_comeStatus==8||_comeStatus==9) {
        [self.scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(@-50);
        }];
        
        self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavBarHeight-50, Main_Screen_Width, 50)];
        self.dockView.userInteractionEnabled=YES;
        [self.view addSubview:self.dockView];
        [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }else{
        [self.scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self createDealBtns];
    
    [self createMoreBtnWithArray:self.arr_More WithDict:@{@"ProcId":_procId,@"TaskId":_taskId,@"FlowCode":@"F0017"}];
}

-(void)createDealBtns{
    __weak typeof(self) weakSelf = self;
    if (_comeStatus==2||_comeStatus==7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack];
            }
        };
    }else if(_comeStatus==8){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil),Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }else if (index==1){
                [weakSelf reCallBack];
            }
        };
    }else if(_comeStatus==9){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }
        };
    }else if (_comeStatus==3){
        if ([_canEndorsel isEqualToString:@"1"]) {
            [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"加签", nil),Custing(@"退回", nil),Custing(@"同意", nil)]];
            self.dockView.btnClickBlock = ^(NSInteger index) {
                if (index==0) {
                    [weakSelf refuseclick:nil];
                }else if (index==1){
                    [weakSelf backclick:nil];
                }else if (index==2){
                    [weakSelf agreeclick:nil];
                }
            };
        }else{
            [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"退回", nil),Custing(@"同意", nil)]];
            self.dockView.btnClickBlock = ^(NSInteger index) {
                if (index==0){
                    [weakSelf backclick:nil];
                }else if (index==1){
                    [weakSelf agreeclick:nil];
                }
            };
        }
    }
}
-(void)createMainView{
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    _SubmitPersonalView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ContentView.top);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Line1.view_View = [[UIView alloc]init];
    _model_Line1.view_View.backgroundColor = Color_White_Same_20;
    [self.view_ContentView addSubview:_model_Line1.view_View];
    [_model_Line1.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Reason.view_View = [[UIView alloc]init];
    _model_Reason.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Reason.view_View];
    [_model_Reason.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Line1.view_View.bottom);
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
    _model_Line2.view_View = [[UIView alloc]init];
    _model_Line2.view_View.backgroundColor = Color_White_Same_20;
    [self.view_ContentView addSubview:_model_Line2.view_View];
    [_model_Line2.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_AccountingModeId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _view_OverTimeDetail = [[UIView alloc]init];
    _view_OverTimeDetail.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_OverTimeDetail];
    [_view_OverTimeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Line2.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _tbv_OverTimeDetail = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tbv_OverTimeDetail.backgroundColor=Color_WhiteWeak_Same_20;
    _tbv_OverTimeDetail.delegate=self;
    _tbv_OverTimeDetail.dataSource=self;
    _tbv_OverTimeDetail.scrollEnabled=NO;
    _tbv_OverTimeDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbv_OverTimeDetail.allowsMultipleSelection=NO;
    _tbv_OverTimeDetail.tableHeaderView = [[UIView alloc]init];
    [_view_OverTimeDetail addSubview:_tbv_OverTimeDetail];
    [_tbv_OverTimeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OverTimeDetail.top);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Line3.view_View = [[UIView alloc]init];
    _model_Line3.view_View.backgroundColor = Color_White_Same_20;
    [self.view_ContentView addSubview:_model_Line3.view_View];
    [_model_Line3.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OverTimeDetail.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Reserved1.view_View = [[UIView alloc]init];
    _model_Reserved1.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Reserved1.view_View];
    [_model_Reserved1.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Line3.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Remark.view_View = [[UIView alloc]init];
    _model_Remark.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Remark.view_View];
    [_model_Remark.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Reserved1.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Remark.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Attachments.view_View = [[UIView alloc]init];
    _model_Attachments.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Attachments.view_View];
    [_model_Attachments.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
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
}

-(void)updateMainView{
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:_arr_MainView WithApproveModel:self.FormData withType:2];
    UILabel *lab = [GPUtils createLable:CGRectMake(Main_Screen_Width-75, 55, 63, 18) text:_int_isBeforehand == 1?Custing(@"事前加班", nil):Custing(@"事后加班", nil) font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
    lab.layer.cornerRadius = 8.5;
    lab.layer.masksToBounds = YES;
    lab.layer.borderWidth = 0.5;
    lab.layer.borderColor = Color_GrayLight_Same_20.CGColor;
    lab.layer.backgroundColor = Color_White_Same_20.CGColor;
    [_SubmitPersonalView addSubview:lab];
    if ([_noteStatus isEqualToString:@"4"]) {
        lab.frame = CGRectMake(Main_Screen_Width-150, 55, 63, 18);
    }else if ([_noteStatus isEqualToString:@"5"]||[_noteStatus isEqualToString:@"6"]){
        CGSize size = [NSString sizeWithText:Custing(@"审批完成(已支付)",nil) font:Font_Same_12_20 maxSize:CGSizeMake(MAXFLOAT, 17)];
        if (size.width>=26) {
            lab.frame = CGRectMake(Main_Screen_Width-size.width-29-75, 55, 63, 18);
        }
    }
    
    for (MyProcurementModel *model in _arr_MainView) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]) {
                _model_Line2.Value = @"1";
                [self updateReasonViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ClientId"]) {
                _model_Line2.Value = @"1";
                [self updateClientIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
                _model_Line2.Value = @"1";
                [self updateSupplierIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"CostCenterId"]) {
                _model_Line2.Value = @"1";
                [self updateCostCenterIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ProjId"]) {
                _model_Line2.Value = @"1";
                [self updateProjIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FromDate"]) {
                _model_Line2.Value = @"1";
                [self updateFromDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ToDate"]) {
                _model_Line2.Value = @"1";
                [self updateToDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TotalTime"]) {
                _model_Line2.Value = @"1";
                [self updateTotalTimeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Type"]) {
                _model_Line2.Value = @"1";
                [self updateTypeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"AccountingModeId"]) {
                _model_Line2.Value = @"1";
                [self updateAccountingModeIdViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Remark"]) {
                [self updateRemarkViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"CcUsersName"]) {
                [self updateCcPeopleViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Attachments"]&&_arr_img.count>0) {
                [self updateAttachmentsViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]) {
                [self updateReserved1ViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
                if (_comeStatus==3||_comeStatus==4) {
                    [self updateFirstHandlerUserNameViewWithModel:_model_FirstHandlerUserName.model];
                }
            }
        }
    }
    if ([_str_overtimeDetail integerValue]==1&&_muarr_DetailFld.count>0) {
        _model_Line3.Value = @"1";
        [self updateDetailView];
    }
    if (_arr_Approve.count!=0) {
        [self updateNotesTableView];
    }
    if (_dic_overtimeHistoryOutput.count>0) {
        [self updateOvertimeHistoryOutputView];
    }
}



//更新事由视图
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_Reason.view_View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_Reason.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新客户视图
-(void)updateClientIdViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNull:_model_ClientId.Value]) {
        model.fieldValue = _model_ClientId.Value;
    }
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_ClientId.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_ClientId.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新供应商视图
-(void)updateSupplierIdViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNull:_model_SupplierId.Value]) {
        model.fieldValue = _model_SupplierId.Value;
    }
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_SupplierId.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_SupplierId.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新成本中心视图
-(void)updateCostCenterIdViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNull:_model_CostCenterId.Value]) {
        model.fieldValue = _model_CostCenterId.Value;
    }
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_CostCenterId.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_CostCenterId.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新项目视图
-(void)updateProjIdViewWithModel:(MyProcurementModel *)model{
    if ([NSString isEqualToNull:_model_ProjId.Value]) {
        model.fieldValue = _model_ProjId.Value;
    }
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_ProjId.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_ProjId.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新开始时间视图
-(void)updateFromDateViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_FromDate.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_FromDate.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新结束时间视图
-(void)updateToDateViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_ToDate.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_ToDate.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新合计（小时）视图
-(void)updateTotalTimeViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_TotalTime.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_TotalTime.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新加班类型视图
-(void)updateTypeViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_Type.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_Type.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    lab.text = @"";
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.text = _arr_OverTimeType[[model.fieldValue integerValue]-1];
    }
}

//更新加班加班核算方式视图
-(void)updateAccountingModeIdViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_AccountingModeId.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_AccountingModeId.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    lab.text = @"";
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.text = _arr_AccountingModeId[[model.fieldValue integerValue]-1];
    }
}

//更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_model_Remark.view_View addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_Remark.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
#pragma mark--更新抄送人
-(void)updateCcPeopleViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_CcToPeople addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_CcToPeople updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新附件视图
-(void)updateAttachmentsViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_model_Attachments.view_View withEditStatus:2 withModel:model];
    view.maxCont=5;
    [_model_Attachments.view_View addSubview:view];
    [view updateWithTotalArray:_arr_img_total WithImgArray:_arr_img];
}

-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_Reserved1.view_View addSubview:[ReserverdLookMainView initArr:_arr_MainView view:_model_Reserved1.view_View block:^(NSInteger height) {
        [weakSelf.model_Reserved1.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    } ]];
}


//更新审批人
-(void)updateFirstHandlerUserNameViewWithModel:(MyProcurementModel *)model{
    _model_FirstHandlerUserName.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_FirstHandlerUserName.view_View WithContent:_model_FirstHandlerUserName.txf_TexfField WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.img_FirstHandlerUserName=image;
        [self SecondApproveClick:[UIButton new]];
    }];
    [_model_FirstHandlerUserName.view_View addSubview:view];
}

-(void)updateOvertimeHistoryOutputView{
    NSArray *arr = _dic_overtimeHistoryOutput[@"overtimeHistoryDtos"];
    if (arr.count>0) {
        OverTimeHistoryOutputView *view = [OverTimeHistoryOutputView createViewByDic:_dic_overtimeHistoryOutput];
        __block float view_height = view.zl_height;
        [_model_overtimeHistoryOutput.view_View addSubview:view];
        [_model_overtimeHistoryOutput.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(view_height);
        }];
    }
}

-(void)updateDetailView{
    NSArray *arr = _muarr_DetailFld[0];
    if (_isOpenDetail == NO) {
        [_view_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1*(38+(arr.count*38)));
        }];
        [_tbv_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1*(38+(arr.count*38)));
        }];
    }else{
        [_view_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.muarr_DetailFld.count*(38+(arr.count*38)));
        }];
        [_tbv_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.muarr_DetailFld.count*(38+(arr.count*38)));
        }];
    }
    [_tbv_OverTimeDetail reloadData];
}

//审批记录
-(void)updateNotesTableView{
    __weak typeof(self) weakSelf = self;
    [_NoteView addSubview:[[FlowChartView alloc] init:_arr_Approve Y:0 HeightBlock:^(NSInteger height) {
        [weakSelf.NoteView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.model_overtimeHistoryOutput.view_View.bottom).offset(@10);
            make.height.equalTo(height);
        }];
    } BtnBlock:^{
        [weakSelf goTo_Webview];
    }]];
}

-(void)updateBottomView{
    [_model_Line1.view_View mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
    }];
    if ([_model_Line2.Value isEqualToString:@"1"]) {
        [_model_Line2.view_View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if ([_model_Line3.Value isEqualToString:@"1"]) {
        [_model_Line3.view_View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.model_FirstHandlerUserName.view_View.bottom);
    }];
    
}

#pragma mark data
//初始化数据
-(void)initializeData{
    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _procId = self.pushProcId;
        _flowGuid = self.pushFlowGuid;
        _comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    _str_overtimeDetail = @"";
    _dic_request = [NSDictionary dictionary];
    _dic_approve = [NSDictionary dictionary];
    _dic_operatorUser = [NSDictionary dictionary];
    _arr_MainView = [NSMutableArray array];
    _arr_Approve = [NSMutableArray array];
    _canEndorsel = @"";
    _Str_SerialNo = @"";
    _int_isBeforehand = 0;
    _dic_OvertimeHistoryOutput = [NSDictionary dictionary];
    _NotesTableHeight = 0;
    _isOpenDetail=NO;
    _arr_img_total = [NSMutableArray array];
    _arr_img = [NSMutableArray array];
    _muarr_DetailFld = [NSMutableArray array];
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
    _model_Reserved1 = [[WorkFormFieldsModel alloc]initialize];
    _model_FirstHandlerUserName = [[WorkFormFieldsModel alloc]initialize];
    _model_overtimeHistoryOutput = [[WorkFormFieldsModel alloc]initialize];
    _dic_overtimeHistoryOutput = [NSDictionary dictionary];
    _model_Line1 = [[WorkFormFieldsModel alloc]initialize];
    _model_Line2 = [[WorkFormFieldsModel alloc]initialize];
    _model_Line3 = [[WorkFormFieldsModel alloc]initialize];
    _FormData = [[FormBaseModel alloc]initBaseWithStatus:2];
    _FormData.str_flowCode=@"F0017";
    _arr_OverTimeType = [NSMutableArray arrayWithArray:@[Custing(@"工作日", nil),Custing(@"双休日", nil),Custing(@"法定节假日", nil),Custing(@"公司节假日", nil)]];
    _arr_AccountingModeId = [NSMutableArray arrayWithArray:@[Custing(@"申请加班费", nil),Custing(@"申请调休", nil)]];
}

-(void)analysisRequestData{
    NSDictionary *result=[_dic_request objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _canEndorsel=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"canEndorse"]]]?[NSString stringWithFormat:@"%@",result[@"canEndorse"]]:@"0";
        _FormData.str_SerialNo = [NSString isEqualToNull:result[@"serialNo"]]?[NSString stringWithFormat:@"%@",result[@"serialNo"]]:@"";
        
        [self.FormData getFormSettingBaseData:result];

        self.arr_More=[NSMutableArray arrayWithArray:@[@1,@2,@3]];
        //是否显示打印
        if (![[NSString stringWithFormat:@"%@",result[@"isPrint"]]isEqualToString:@"1"]) {
            [self.arr_More removeObject:@3];
        }
        if (self.comeStatus!=3) {
            [self.arr_More removeObject:@2];
        }
        
        //默认申请人及相关数据
        _dic_operatorUser = [result objectForKey:@"operatorUser"];
        _dic_overtimeHistoryOutput = _dic_request[@"result"][@"overtimeHistoryOutput"];
        _flowGuid=[NSString stringWithFormat:@"%@",result[@"flowGuid"]];
        _int_isBeforehand = [result[@"isBeforehand"]integerValue];
        _Str_SerialNo=[NSString stringWithFormat:@"%@",[result objectForKey:@"serialNo"]];
        NSDictionary *formDict=[result objectForKey:@"formFields"];
        
        if (![formDict isKindOfClass:[NSNull class]]) {
            NSArray *mainFld = [formDict objectForKey:@"mainFld"];
            if (mainFld.count!=0) {
                for (NSDictionary *dic in mainFld) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_arr_MainView addObject:model];
                    //解析图片
                    if ([dic[@"fieldName"] isEqualToString:@"Attachments"]) {
                        if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                            NSArray * array = [self transformToNSArrayFromString:[NSString stringWithFormat:@"%@",model.fieldValue]];
                            for (NSDictionary *dict in array) {
                                [_arr_img_total addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:_arr_img_total WithImageArray:_arr_img WithMaxConut:5];
                        }
                    }
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
                    if ([model.fieldName isEqualToString:@"FirstHandlerUserName"]) {
                        _model_FirstHandlerUserName.model = model;
                    }
                }
            }
        }
        [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:_dic_request[@"result"] WithFormArray:_arr_MainView];
        _str_overtimeDetail = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"overtimeDetail"]]]?[NSString stringWithFormat:@"%@",_dic_request[@"result"][@"overtimeDetail"]]:@"0";
        NSMutableArray *muarr = [NSMutableArray array];
        if ([_str_overtimeDetail integerValue]==1) {
            if ([_dic_request[@"result"][@"formFields"][@"detailFld"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = _dic_request[@"result"][@"formFields"][@"detailFld"];
                for (int i = 0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
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
}

-(void)analysisApproveData{
    NSDictionary *result=[_dic_approve objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _noteStatus=[NSString stringWithFormat:@"%@",result[@"statusCode"]];
        _FormData.str_noteStatus = _noteStatus;
        NSArray *array=result[@"taskProcList"];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model=[[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_arr_Approve addObject:model];
        }
    }
}

-(void)dealWithData
{
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",nil];
    if (![NSString isEqualToNull:_twoHandeId]) {
        _twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:_twoHandeId,_twoApprovalName, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_OvertimeApp"]};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    _parametersDict=@{@"mainDataList":mainArray};
}

#pragma mark network
-(void)requestOvertimeGetFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",OvertimeGetFormData];
    NSDictionary *parameters = @{@"TaskId": _taskId,@"ProcId":_procId?_procId:@"",@"FlowCode":@"F0017"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取审批记录
-(void)requestApproveNote{
    NSString *url=[NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:13 IfUserCache:NO];
}

#pragma mark - action
//退单
-(void)backclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"0";
    exa.FlowCode = @"F0017";
    [self.navigationController pushViewController:exa animated:YES];
}

//撤回操作
-(void)reCallBack{
    _dockView.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"FlowCode":@"F0017",@"TaskId":_taskId,@"RecallType":self.comeStatus==7?@"2":@"1"};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",RecallList];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:4 IfUserCache :NO];
}
-(void)goUrge{
    NSLog(@"催办操作");
    self.dockView.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"FlowCode":@"F0017",@"TaskId":_taskId};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",BPMURGE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache :NO];
}

//拒绝 改为加签
-(void)refuseclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"1";
    exa.FlowCode = @"F0017";
    [self.navigationController pushViewController:exa animated:YES];
}

//同意
-(void)agreeclick:(UIButton *)btn
{
    [self dealWithData];
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"2";
    exa.FlowCode = @"F0017";
    exa.dic_APPROVAL = _parametersDict;
    [self.navigationController pushViewController:exa animated:YES];
}

//审批人点击
-(void)SecondApproveClick:(UIButton *)btn{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [_twoHandeId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"1";
    contactVC.Radio = @"1";
    contactVC.arrClickPeople = array;
    contactVC.menutype=4;
    contactVC.itemType = 17;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.twoApprovalName = bul.requestor;
        weakSelf.twoHandeId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.model_FirstHandlerUserName.txf_TexfField.text= bul.requestor;
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = [GPUtils transformToDictionaryFromString:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                [weakSelf.img_FirstHandlerUserName sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
            }else{
                weakSelf.img_FirstHandlerUserName.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
            }
        }else{
            weakSelf.img_FirstHandlerUserName.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

#pragma mark  打印链接
-(void)GoToPush{
    self.PrintfBtn.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GETPrintLink];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:11 IfUserCache:NO];
}

-(void)LookMore:(UIButton *)btn{
    NSArray *arr = _muarr_DetailFld[0];
    if (_isOpenDetail==NO) {
        _isOpenDetail=YES;
        
        [_LookMore setImage:[UIImage imageNamed:@"work_Close"] forState:UIControlStateNormal];
        [_LookMore setTitle:Custing(@"收起", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        [_view_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.muarr_DetailFld.count*(38+(arr.count*38)));
        }];
        [_tbv_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.muarr_DetailFld.count*(38+(arr.count*38)));
        }];
    }else if (_isOpenDetail==YES){
        _isOpenDetail=NO;
        [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
        [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
        [_view_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1*(38+(arr.count*38)));
        }];
        [_tbv_OverTimeDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(1*(38+(arr.count*38)));
        }];
    }
    [_tbv_OverTimeDetail reloadData];
}

#pragma mark - delegate
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dockView.userInteractionEnabled = YES;
    if ([responceDic[@"success"] intValue] == 0 ) {
        NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self requestApproveNote];
    }else if (serialNum == 1) {
        _dic_approve = responceDic;
        [self analysisApproveData];
        [self creationRootView];
        [self createMainView];
        [self updateMainView];
        [self updateBottomView];
    }else if (serialNum == 4) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"撤回成功" duration:1.5];
        [self performBlock:^{
            if (self.comeStatus==2) {
                OvertimeViewController *art=[[OvertimeViewController alloc]init];
                art.taskId=self.taskId;
                art.comeStatus = 4;
                art.backIndex = @"1";
                art.procId=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                [self.navigationController pushViewController:art animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        } afterDelay:1.0];
    }else if (serialNum == 3) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.0];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.0];
    }else if (serialNum == 11) {
        self.PrintfBtn.userInteractionEnabled=YES;
        NSDictionary *dict = responceDic[@"result"];
        if (![dict isKindOfClass:[NSNull class]]) {
            [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                 @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                 @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                 @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                 @"flowCode":@"F0017",
                                                                 @"requestor":self.FormData.personalData.Requestor
                                                                 }]];
        }
    }else if (serialNum == 13) {
        boWebViewController *bo = [[boWebViewController alloc]initWithType:[NSString stringWithFormat:@"%@%@",ip_web,[responceDic objectForKey:@"result"]]];
        bo.str_title = Custing(@"流程图", nil);
        [self.navigationController pushViewController:bo animated:YES];
    }
}



#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_muarr_DetailFld.count>1) {
        if (_LookMore||_isOpenDetail==NO) {
            if ([_LookMore.titleLabel.text isEqualToString:Custing(@"展开", nil)]||_isOpenDetail==NO) {
                return 1;
            }else{
                return _muarr_DetailFld.count;
            }
        }else{
            return _muarr_DetailFld.count;
        }
    }
    return _muarr_DetailFld.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = _muarr_DetailFld[indexPath.row];
    return arr.count*38+38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = _muarr_DetailFld[indexPath.row];
    UITableViewCell *cell  = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, arr.count*38+38)];
    UILabel *titleLabel=[GPUtils createLable:CGRectMake(10, 10, Main_Screen_Width-55, 18) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    if (arr.count>1) {
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"加班明细", nil),(long)(indexPath.row+1)];
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@",Custing(@"加班明细", nil)];
    }
    [cell addSubview:titleLabel];
    
    NSInteger height=38;
    for (WorkFormFieldsModel *model in arr) {
        UILabel *nameLabel=[GPUtils createLable:CGRectMake(12,height,XBHelper_Title_Width, 38) text:model.model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        nameLabel.numberOfLines=2;
        [cell addSubview:nameLabel];
        
        UILabel *DetailLabel=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27,Y(nameLabel), Main_Screen_Width-XBHelper_Title_Width-39, 38) text:nil font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
        DetailLabel.numberOfLines=0;
        [cell addSubview:DetailLabel];
        DetailLabel.text=[NSString stringWithIdOnNO:model.model.fieldValue];
        if ([model.model.fieldName isEqualToString:@"Type"]) {
            if ([NSString isEqualToNull:model.model.fieldValue]) {
                DetailLabel.text = _arr_OverTimeType[[model.model.fieldValue integerValue]-1];
            }
        }else if ([model.model.fieldName isEqualToString:@"AccountingModeId"]) {
            if ([NSString isEqualToNull:model.model.fieldValue]) {
                DetailLabel.text = _arr_AccountingModeId[[model.model.fieldValue integerValue]];
            }
        }
        height=height+38;
    }
    
    if (indexPath.row==0&&_muarr_DetailFld.count>1) {
        CGSize size = [Custing(@"展开", nil) sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width, 30) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat titleWidth=size.width;
        CGFloat imageWidth = 14;
        CGFloat btnWidth = titleWidth +imageWidth+24;
        if (!_LookMore) {
            _LookMore=[[UIButton alloc]initWithFrame:CGRectMake(Main_Screen_Width-btnWidth, 4, btnWidth, 30)];
            _LookMore.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            _LookMore.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
            [_LookMore setTitle:Custing(@"展开", nil) forState:UIControlStateNormal];
            [_LookMore setTitleColor:Color_Blue_Important_20 forState:UIControlStateNormal];
            _LookMore.titleLabel.font=Font_Important_15_20;
            [_LookMore setImage:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
            [_LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell addSubview:_LookMore];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    _dockView.userInteractionEnabled = YES;
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
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
