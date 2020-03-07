//
//  LookTravelRequestsViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "LookTravelRequestsViewController.h"
#import "ProcureCollectCell.h"
#import "MyProcurementModel.h"
#import "approvalNoteModel.h"
#import "TravelHotelDetailModel.h"
#import "TravelFlightDetailModel.h"
#import "TravelTrainDetailModel.h"
#import "travelPlanViewCell.h"
#import "approvalNoteCell.h"
#import "contactsVController.h"
#import "TAlertView.h"
#import "TravelRequestsViewController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "FormSubChildView.h"
#import "TravelPeopleInfoModel.h"
#import "TravelInfoModel.h"
#import "FeeBudgetInfoModel.h"
#import "TravelRouteDetailCell.h"
#import "TravelCarDetailView.h"
#import "TravelCarDetailNewController.h"

@interface LookTravelRequestsViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSDictionary *resultDict;//请求数据
@property (nonatomic,strong)NSDictionary *personDict;//申请人相关数据字典

@property (nonatomic,strong)NSMutableArray *ProcurementArray;//出差申请主表数组
@property (nonatomic,assign)NSInteger DetailsMeunNum;//出差申请明细显示列表
@property(nonatomic,assign)NSInteger numRowTable;//明细的组数
@property(nonatomic,assign)NSInteger NotesTableHeight;//审批记录tableView高度

@property (nonatomic, strong) UIImageView *requestorImage;

@property(nonatomic,strong)NSString *noteStatus;//表单当前状态
@property (nonatomic, strong)NSMutableArray * meItemArray;//审批记录数组
@property(nonatomic,strong)NSString *twoHandeId;//第二审批人Id
@property(nonatomic,strong)NSString *twoApprovalName;//第二审批人名字
@property(nonatomic,strong)NSString *commentIdea;//提交退单拒绝意见
@property(nonatomic,strong)NSDictionary *parametersDict;//提交和保存的提交字典
@property(nonatomic,assign)BOOL isOpenDetail;//查看更多明细打开是否
@property (nonatomic, strong) DoneBtnView *dockView;//下部按钮底层视图
@property (nonatomic, strong) NSString *canEndorse;//是否显示加签
@property(nonatomic,strong)UIButton *backBtn;//退单按钮
@property(nonatomic,strong)UIButton *recallBtn;//撤回按钮
@property(nonatomic,strong)UIButton *refuseBtn;//拒绝按钮
@property(nonatomic,strong)UIButton *agreeBtn;//同意按钮
@property (nonatomic,strong)UIScrollView * scrollView;//滚动视图
@property (nonatomic,strong)UIView *contentView;//滚动视图contentView
@property(nonatomic,strong)UICollectionView *collView;//网格视图
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;//网格规则
@property(nonatomic,strong)ProcureCollectCell *cell;//网格cell
//@property (nonatomic,strong)UIView *thirdView;//自定义字段
@property (nonatomic,strong)UIView *needsView;//需求单视图
@property (nonatomic,strong)UIView *fourthView;//审批记录
@property (nonatomic,strong)UIView *fifthView;//审批人
@property (nonatomic, strong) NSMutableArray *arr_img_total;
@property (nonatomic, strong) NSMutableArray *arr_img;
//视图元素
@property(nonatomic,strong)UIView *view_TravelReason;//出差事由view

@property(nonatomic,strong)UIView *view_BusinessType;//出差类型view

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;

@property(nonatomic,strong)UIView *view_Date;//时间view
@property (nonatomic, strong) UIView *view_ToDate;
@property(nonatomic,strong)UIDatePicker * datePicker;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * datelView;//出差申请日期选择弹出框
@property(nonatomic,strong)NSString *str_startDate;//开始日期
//@property(nonatomic,strong)UILabel *lab_StartMonth;//开始月
@property(nonatomic,strong)UILabel *lab_StartDay;//开始日
@property(nonatomic,strong)UIButton *btn_StartDate;//开始时间点击
@property(nonatomic,strong)NSString *str_endDate;//结束日期
//@property(nonatomic,strong)UILabel *lab_EndMonth;//结束月
@property(nonatomic,strong)UILabel *lab_EndDay;//结束日
@property(nonatomic,strong)UIButton *btn_EndDate;//结束时间点击

@property (nonatomic, strong) UIView *view_Origin;//出发地view
@property (nonatomic, strong) UILabel *lab_OriginName;
@property (nonatomic, strong) NSString *str_OriginName;

@property (nonatomic, strong) UIView *view_ToCity;//目的地view
@property (nonatomic, strong) UILabel *lab_ToCityName;
@property (nonatomic, strong) NSString *str_ToCityName;

@property(nonatomic,strong)UIView *view_BusinessPersonnel;//出差人员view

@property(nonatomic,strong)UIView *view_IsUseCar;//是否用车


/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_ExpenseType;
@property (nonatomic, strong) UILabel *lab_ExpenseType;
@property(nonatomic,copy)NSString *str_ExpenseType;
@property(nonatomic,copy)NSString *str_ExpenseCat;

@property (nonatomic, strong) WorkFormFieldsModel *model_TravelCat;



@property(nonatomic,strong)UIView *view_AdvanceAmount;//预支金额view

@property (nonatomic, strong) UIView *view_CurrencyCode;//币种视图
@property (nonatomic, strong) UILabel *lab_CurrencyCode;

@property (nonatomic, strong) UIView *view_ExchangeRate;//汇率

@property (nonatomic, strong) UIView *view_LocalCyAmount;//本位币视图

@property(nonatomic,strong)UIView *RepayDateView;//还款日期VIEW




@property(nonatomic,strong)UIView *RemarkView;//出差申请备注视图

@property(nonatomic,strong)UIView *view_ContractHotel;//住合约酒店view
//@property(nonatomic,strong)UIButton *btn_ContractHotel_Yes;//住合约酒店是按钮
//@property(nonatomic,strong)UIButton *btn_ContractHotel_No;//住合约酒店否按钮
@property(nonatomic,strong)UITextView *txv_ContractHotel;//不住合约酒店理由

@property(nonatomic,strong)UIView *view_Supplier;//供应商承担view
//@property(nonatomic,strong)UIButton *btn_Supplier_Yes;//供应商承担是按钮
//@property(nonatomic,strong)UIButton *btn_Supplier_No;//供应商承担否按钮
@property(nonatomic,strong)UITextView *txv_Supplier;//供应商承担理由

@property(nonatomic,strong)UIView *view_Drive;//自驾车view
@property(nonatomic,strong)UITextView *txv_Drive;//自驾车理由

@property(nonatomic,strong)UITableView *NeedsTableView;//申请单视图

@property (nonatomic, strong) WorkFormFieldsModel *model_Attachments;

//自定义字段
@property(nonatomic,strong)UIView *Reserved1View;

@property(nonatomic,strong)UIView *ApproveView;//出差申请审批人视图
@property(nonatomic,strong)UIImageView *ApproveImgView;//审批人头像
@property(nonatomic,strong)NSString *str_Approve;//审批人Label
@property(nonatomic,strong)UITextField *txf_Approver;

@property (nonatomic,strong)NSMutableArray *Arr_planeTicketArray;//机票需求数组
@property (nonatomic,strong)NSMutableArray *Arr_homeArray;//住宿需求单数组
@property (nonatomic,strong)NSMutableArray *Arr_trainArray;//火车需求数组
@property (nonatomic, strong)NSMutableArray *Arr_Demand;//预定数组

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) NSString *SerialNo;//单号

@property(nonatomic, assign)int firstHandlerGender;// 第一审批人性别
@property (nonatomic, strong) NSDictionary *paymentDict;//支付数组

@property (nonatomic, strong) UIView *view_travelRoute;//行程安排
@property (nonatomic, strong) NSString *str_travelRoute;//是否显示行程安排
@property (nonatomic, strong) UITableView *tbv_travelRoute;//行程安排表单
@property (nonatomic, strong) NSMutableArray *arr_travelRoute;//行程安排数组

@property (nonatomic, assign) BOOL bool_showEstimated;//预估总金额是否显示
@property (nonatomic, strong) UIView *view_EstimatedHead;//预估总金额标题
@property (nonatomic, strong) UIView *view_TicketFee;
@property (nonatomic, strong) UIView *view_TrafficFee;
@property (nonatomic, strong) UIView *view_HotelFee;
@property (nonatomic, strong) UIView *view_MealFee;
@property (nonatomic, strong) UIView *view_AllowanceFee;
@property (nonatomic, strong) UIView *view_EntertainmentFee;
@property (nonatomic, strong) UIView *view_OtherFee;
@property (nonatomic, strong) UIView *view_EstimatedAmount;

@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, strong) UIView *view_line4;
@property (nonatomic, strong) UIView *view_line5;
@property (nonatomic, strong) UIView *view_line6;
@property (nonatomic, strong) UIView *view_line7;
@property (nonatomic, strong) UIView *view_line8;


@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;
@property (nonatomic, assign) NSInteger int_line4;
@property (nonatomic, assign) NSInteger int_line5;
@property (nonatomic, assign) NSInteger int_line6;
@property (nonatomic, assign) NSInteger int_line7;
@property (nonatomic, assign) NSInteger int_line8;

/**
 *  预算核算日字段
 */
@property(nonatomic,strong)NSString *str_BudgetSubDate;
/**
 *  之前预算核算日字段
 */
@property(nonatomic,strong)NSString *str_beforeBudgetSubDate;
/**
 *  预算扣除日view
 */
@property(nonatomic,strong)UIView *View_BudgetSubDate;
/**
 *  预算扣除日txf
 */
@property(nonatomic,strong)UITextField *txf_BudgetSubDate;

@property (nonatomic, strong) NSMutableArray *arr_More;//更多按钮显示数组

/**
 分摊部门Ids
 */
@property(nonatomic,copy)NSString *str_ShareDeptIds;

@property (nonatomic, assign) BOOL bool_travelPeople;
@property (nonatomic, strong) FormSubChildView *view_travelPeople;
@property (nonatomic, strong) NSMutableArray *arr_travelPeopleShowSet;
@property (nonatomic, strong) NSMutableArray *arr_travelPeopleShowData;

@property (nonatomic, assign) BOOL bool_travelInfo;
@property (nonatomic, strong) FormSubChildView *view_travelInfo;
@property (nonatomic, strong) NSMutableArray *arr_travelInfoShowSet;
@property (nonatomic, strong) NSMutableArray *arr_travelInfoShowData;

@property (nonatomic, assign) BOOL bool_feeBudget;
@property (nonatomic, strong) FormSubChildView *view_feeBudget;
@property (nonatomic, strong) NSMutableArray *arr_feeBudgetShowSet;
@property (nonatomic, strong) NSMutableArray *arr_feeBudgetShowData;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;

/**
 *  归口部门视图
 */
@property (nonatomic, strong) WorkFormFieldsModel *model_RelevantDept;
/**
  报销政策字典
 */
@property (nonatomic, strong) NSDictionary *dict_ReimPolicyDict;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyUpView;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;

/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  经费来源视图
 */
@property (nonatomic, strong) WorkFormFieldsModel *model_FinancialSource;

/**
 *  用车需求单是否显示
 */
@property (nonatomic, assign) BOOL bool_carPlan;
@property (nonatomic, strong) NSMutableArray *arr_carPlanShow;
@property (nonatomic, strong) NSMutableArray *arr_carPlanData;
/**
 用车需求单明细
 */
@property (nonatomic,strong)TravelCarDetailView *TravelCarDetailView;


@end

@implementation LookTravelRequestsViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormData = [[FormBaseModel alloc]initBaseWithStatus:2];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Color_White_Same_20;

    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _userId = self.pushUserId;
        _procId = self.pushProcId;
        _flowCode = self.pushFlowCode;
        _comeStatus = [self.pushComeStatus integerValue];
        self.FormData.int_comeEditType=[self.pushComeEditType integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    [self initializeData_lt];
    _FormData.str_flowCode=@"F0001";
    if (self.pushFlowGuid) {
        self.FormData.str_flowGuid = self.pushFlowGuid;
    }
    [self setTitle:nil backButton:YES];
    [self requestHasProcurement_lt];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
}

#pragma mark - 方法
#pragma mark 创建视图
-(void)createScrollView_lt{
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    if (_comeStatus==2||_comeStatus==3||_comeStatus==4||_comeStatus==7||_comeStatus==8||_comeStatus==9) {
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
    [self createContentView_lt];
    [self createDealBtns];
    [self createMainView_lt];
    
    [self createMoreBtnWithArray:self.arr_More WithDict:@{@"ProcId":_procId,@"TaskId":_taskId,@"FlowCode":@"F0001"}];
}

-(void)createDealBtns{
    __weak typeof(self) weakSelf = self;
    if (_comeStatus==2||_comeStatus==7) {
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf reCallBack_ap];
            }
        };
    }else if(_comeStatus==8){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"催办", nil),Custing(@"撤回", nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf goUrge];
            }else if (index==1){
                [weakSelf reCallBack_ap];
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
        if ([_canEndorse isEqualToString:@"1"]) {
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
    }else if (_comeStatus==4){
        [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"确认支付" , nil)]];
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0){
                [weakSelf PayBtn_click:nil];
            }
        };
    }
}

//创建ContentView
-(void)createContentView_lt{
    _contentView =[[UIView alloc]init];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [self.scrollView addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

//创建主视图
-(void)createMainView_lt{
    
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    _SubmitPersonalView = [[SubmitPersonalView alloc]init];
    _SubmitPersonalView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom).offset(@10);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line1=[[UIView alloc]init];
    [self.contentView addSubview:_view_line1];
    [_view_line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //出差事由
    _view_TravelReason=[[UIView alloc]init];
    _view_TravelReason.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_TravelReason];
    [_view_TravelReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_BusinessType=[[UIView alloc]init];
    _view_BusinessType.backgroundColor = Color_form_TextFieldBackgroundColor;
    [self.contentView addSubview:_view_BusinessType];
    [_view_BusinessType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TravelReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_TravelCat.view_View = [[UIView alloc]init];
    _model_TravelCat.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_model_TravelCat.view_View];
    [_model_TravelCat.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_BusinessType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_RelevantDept.view_View = [[UIView alloc]init];
    _model_RelevantDept.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_model_RelevantDept.view_View];
    [_model_RelevantDept.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_TravelCat.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _model_FinancialSource.view_View = [[UIView alloc]init];
    _model_FinancialSource.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_model_FinancialSource.view_View];
    [_model_FinancialSource.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_RelevantDept.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_Date=[[UIView alloc]init];
    _view_Date.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_Date];
    [_view_Date makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_FinancialSource.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_ToDate = [[UIView alloc]init];
    _view_ToDate.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_ToDate];
    [_view_ToDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Date.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_Origin=[[UIView alloc]init];
    _view_Origin.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_Origin];
    [_view_Origin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ToDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_ToCity=[[UIView alloc]init];
    _view_ToCity.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_ToCity];
    [_view_ToCity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Origin.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_BusinessPersonnel=[[UIView alloc]init];
    _view_BusinessPersonnel.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_BusinessPersonnel];
    [_view_BusinessPersonnel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_IsUseCar=[[UIView alloc]init];
    _view_IsUseCar.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_IsUseCar];
    [_view_IsUseCar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_BusinessPersonnel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line2=[[UIView alloc]init];
    [_contentView addSubview:_view_line2];
    [_view_line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_IsUseCar.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_ExpenseType=[[UIView alloc]init];
    _View_ExpenseType.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_ExpenseType];
    [_View_ExpenseType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_AdvanceAmount=[[UIView alloc]init];
    _view_AdvanceAmount.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_AdvanceAmount];
    [_view_AdvanceAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ExpenseType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_CurrencyCode =[[UIView alloc]init];
    _view_CurrencyCode.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_CurrencyCode];
    [_view_CurrencyCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_AdvanceAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_ExchangeRate = [[UIView alloc]init];
    _view_ExchangeRate.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_ExchangeRate];
    [_view_ExchangeRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_LocalCyAmount = [[UIView alloc]init];
    _view_LocalCyAmount.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_LocalCyAmount];
    [_view_LocalCyAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _RepayDateView=[[UIView alloc]init];
    _RepayDateView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_RepayDateView];
    [_RepayDateView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line3=[[UIView alloc]init];
    [_contentView addSubview:_view_line3];
    [_view_line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RepayDateView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_EstimatedHead = [[UIView alloc]init];
    _view_EstimatedHead.backgroundColor = Color_White_Same_20;
    [_contentView addSubview: _view_EstimatedHead];
    [_view_EstimatedHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line3.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_TicketFee = [[UIView alloc]init];
    _view_TicketFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_TicketFee];
    [_view_TicketFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_EstimatedHead.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_HotelFee = [[UIView alloc]init];
    _view_HotelFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_HotelFee];
    [_view_HotelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TicketFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_TrafficFee = [[UIView alloc]init];
    _view_TrafficFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_TrafficFee];
    [_view_TrafficFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_HotelFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_MealFee = [[UIView alloc]init];
    _view_MealFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_MealFee];
    [_view_MealFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TrafficFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_AllowanceFee = [[UIView alloc]init];
    _view_AllowanceFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_AllowanceFee];
    [_view_AllowanceFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_MealFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_EntertainmentFee = [[UIView alloc]init];
    _view_EntertainmentFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_EntertainmentFee];
    [_view_EntertainmentFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_AllowanceFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_OtherFee = [[UIView alloc]init];
    _view_OtherFee.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_OtherFee];
    [_view_OtherFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_EntertainmentFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //预估金额
    _view_EstimatedAmount = [[UIView alloc]init];
    _view_EstimatedAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_EstimatedAmount];
    [_view_EstimatedAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_OtherFee.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_line4=[[UIView alloc]init];
    [_contentView addSubview:_view_line4];
    [_view_line4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_EstimatedAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _FormRelatedView = [[FormRelatedView alloc]init];
    _FormRelatedView.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line4.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _view_ContractHotel=[[UIView alloc]init];
    _view_ContractHotel.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_ContractHotel];
    [_view_ContractHotel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_Supplier=[[UIView alloc]init];
    _view_Supplier.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_Supplier];
    [_view_Supplier makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ContractHotel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_Drive=[[UIView alloc]init];
    _view_Drive.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_view_Drive];
    [_view_Drive makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Supplier.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_BudgetSubDate=[[UIView alloc]init];
    _View_BudgetSubDate.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_View_BudgetSubDate];
    [_View_BudgetSubDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Drive.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _Reserved1View=[[UIView alloc]init];
    _Reserved1View.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_Reserved1View];
    [_Reserved1View makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_BudgetSubDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _RemarkView=[[UIView alloc]init];
    _RemarkView.backgroundColor = Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_RemarkView];
    [_RemarkView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RemarkView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_Attachments.view_View = [[UIView alloc]init];
    _model_Attachments.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_model_Attachments.view_View];
    [_model_Attachments.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
  
    _view_line5=[[UIView alloc]init];
    [_contentView addSubview:_view_line5];
    [_view_line5 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Attachments.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_travelRoute = [[UIView alloc]init];
    _view_travelRoute.backgroundColor = Color_White_Same_20;
    [_contentView addSubview:_view_travelRoute];
    [_view_travelRoute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line5.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_travelPeople = [[FormSubChildView alloc]initWithType:1 withStatus:2];
    [_contentView addSubview:_view_travelPeople];
    [_view_travelPeople updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelRoute.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_travelInfo = [[FormSubChildView alloc]initWithType:2 withStatus:2];
    [_contentView addSubview:_view_travelInfo];
    [_view_travelInfo updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //用车需求单
    _TravelCarDetailView = [[TravelCarDetailView alloc]init];
    [self.contentView addSubview:_TravelCarDetailView];
    [_TravelCarDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_feeBudget = [[FormSubChildView alloc]initWithType:3 withStatus:2];
    [_contentView addSubview:_view_feeBudget];
    [_view_feeBudget updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TravelCarDetailView.bottom);
        make.left.right.equalTo(self.contentView);
    }];

    _needsView=[[UIView alloc]init];
    _needsView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_needsView];
    [_needsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_feeBudget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _NeedsTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _NeedsTableView.delegate=self;
    _NeedsTableView.dataSource=self;
    _NeedsTableView.scrollEnabled=NO;
    _NeedsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_needsView addSubview:_NeedsTableView];
    [_NeedsTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.needsView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_line6=[[UIView alloc]init];
    [_contentView addSubview:_view_line6];
    [_view_line6 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.needsView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _fifthView=[[UIView alloc]init];
    _fifthView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_fifthView];
    [_fifthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line6.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ApproveView=[[UIView alloc]init];
    [_fifthView addSubview:_ApproveView];
    [_ApproveView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fifthView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    _fourthView=[[UIView alloc]init];
    _fourthView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_fourthView];
    [_fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ApproveView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fourthView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
}


#pragma mark 视图更新
-(void)updateMainView{
    [_SubmitPersonalView initOnlyApprovePersonalViewWithDate:_ProcurementArray WithApproveModel:self.FormData withType:2];
    [_FormRelatedView initOnlyApproveFormRelatedViewWithDate:_ProcurementArray WithBaseModel:self.FormData];
    _int_line1 = 1;
    for (MyProcurementModel *model in _ProcurementArray) {
        [self updateLineState:model];
        if ([[model.isShow stringValue]isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]) {
                [self updateReasonViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"TravelType"]) {
                [self updateTravelTypeViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"TravelCat"]) {
                [self updateTravelCatViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"RelevantDept"]) {
                [self updateRelevantDeptViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FinancialSource"]) {
                [self updateFinancialSourceViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FromDate"]) {
                [self updateFromDateViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"FromCityCode"]) {
                [self updateFromCityViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"ToCityCode"]) {
                [self updateToCityViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"FellowOfficers"]) {
                [self updateFellowOfficersViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"IsUseCar"]) {
                [self updateIsUseCarViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
                [self updateAdvanceAmountViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"CurrencyCode"]) {
                [self updateCurrencyCodeWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
                [self updateExchangeRateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
                [self updateExpenseTypeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"AdvanceAmount"]) {
                [self updateAmountRateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"RepayDate"]) {
                [self updateRepayDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"IsContractsHotel"]) {
                [self updateIsContractsHotelViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"IsSupplierBear"]) {
                [self updateIsSupplierBearViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"IsSelfDrive"]) {
                [self updateIsSelfDriveViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TicketFee"] && self.bool_showEstimated) {
                [self updateTicketFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TrafficFee"] && self.bool_showEstimated) {
                [self updateTrafficFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"HotelFee"] && self.bool_showEstimated) {
                [self updateHotelFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"MealFee"] && self.bool_showEstimated) {
                [self updateMealFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TravelAllowance"] && self.bool_showEstimated) {
                [self updateTravelAllowanceViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"EntertainmentFee"] && self.bool_showEstimated) {
                [self updateEntertainmentFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"OtherFee"] && self.bool_showEstimated) {
                [self updateOtherFeeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"EstimatedAmount"]) {
                [self updateEstimatedAmountModel:model];
            }else if ([model.fieldName isEqualToString:@"BudgetSubDate"]&&self.FormData.int_comeEditType == 1&&self.comeStatus==3){
                [self updateBudgetSubDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Remark"]) {
                [self updateRemarkViewWithModel_tr:model];
            }else if ([model.fieldName isEqualToString:@"CcUsersName"]) {
                [self updateCcPeopleViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Attachments"]&&_arr_img.count>0) {
                [self updateAttachmentsViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]) {
                [self updateReserved1ViewWithModel_ap:model];
            }else if ([model.fieldName isEqualToString:@"ApprovalMode"]) {
                if (_comeStatus==3||_comeStatus==4) {
                    [self updateApproveViewWithModel_ap:model];
                }
            }
        }
        if ([model.fieldName isEqualToString:@"RequestorPhotoGraph"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                if (![dic isKindOfClass:[NSNull class]] && dic != nil && dic.count != 0){
                    [_requestorImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
                }else{
                    _requestorImage.image = _firstHandlerGender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
                }
            }
        }
        
    }
    
    
    //MARK:显示出差人员信息
    if (self.bool_travelPeople && self.arr_travelPeopleShowSet.count > 0) {
        [self updateTravelPeople];
    }
    //MARK:显示出行信息
    if (self.bool_travelInfo && self.arr_travelInfoShowSet.count > 0) {
        [self updateTravelInfo];
    }
    //MARK:显示费用预算信息
    if (self.bool_feeBudget && self.arr_feeBudgetShowSet.count > 0) {
        [self updateFeeBudget];
    }
    
    for (MyProcurementModel *model in _ProcurementArray) {
        //数据解析
        //到达时间
        if ([model.fieldName isEqualToString:@"ToDate"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _lab_EndDay.text = model.fieldValue;
            }
        }
        
        //请提供不住合约酒店的原因
        if ([model.fieldName isEqualToString:@"NotContractsReason"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_ContractHotel.text = model.fieldValue;
            }
        }
        //对供应商的评价
        if ([model.fieldName isEqualToString:@"SupplierEvaluation"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_Supplier.text = model.fieldValue;
            }
        }
       
        if ([model.fieldName isEqualToString:@"ExpenseType"]) {
            _str_ExpenseType=[NSString stringWithFormat:@"%@",model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"ExpenseCat"]) {
            _str_ExpenseCat=[NSString stringWithFormat:@"%@",model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"Currency"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _lab_CurrencyCode.text = model.fieldValue;
            }
        }
        //请提供需要自驾车的理由
        if ([model.fieldName isEqualToString:@"SelfDriveReason"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_Drive.text = model.fieldValue;
            }
        }
    }
    _lab_ExpenseType.text=[GPUtils getSelectResultWithArray:@[self.str_ExpenseCat,self.str_ExpenseType]];
    
    if (_Arr_Demand.count!=0) {
        [self updateNeedsTableView_tr];
    }
    if (_meItemArray.count!=0) {
        [self updateNotesTableView_ap];
    }
    if (_arr_travelRoute.count!=0) {
        [self updateTravelRouteView];
    }
    
    //MARK:用车需求单
    if (self.bool_carPlan) {
        [self updateTravelCarDetail];
    }
    
    if (self.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    
    [self updateBottomView_tr];
}

-(void)updateLineState:(MyProcurementModel *)model{
    if ([model.isShow integerValue]==1) {
        if ([model.fieldName isEqualToString:@"TravelType"]||[model.fieldName isEqualToString:@"FromDate"]||[model.fieldName isEqualToString:@"FromCityCode"]||[model.fieldName isEqualToString:@"ToCityCode"]||[model.fieldName isEqualToString:@"FellowOfficers"]) {
            _int_line2 = 1;
        }
        if ([model.fieldName isEqualToString:@"LocalCyAmount"]||[model.fieldName isEqualToString:@"CurrencyCode"]||[model.fieldName isEqualToString:@"ExchangeRate"]||[model.fieldName isEqualToString:@"AdvanceAmount"]||[model.fieldName isEqualToString:@"RepayDate"]) {
            _int_line3 = 1;
        }
        if ([model.fieldName isEqualToString:@"TicketFee"]||[model.fieldName isEqualToString:@"TrafficFee"]||[model.fieldName isEqualToString:@"HotelFee"]||[model.fieldName isEqualToString:@"MealFee"]||[model.fieldName isEqualToString:@"OtherFee"]||[model.fieldName isEqualToString:@"EstimatedAmount"]) {
            _int_line4 = 1;
        }
        if ([model.fieldName isEqualToString:@"ProjId"]||[model.fieldName isEqualToString:@"ClientId"]||[model.fieldName isEqualToString:@"Remark"]||[model.fieldName isEqualToString:@"IsContractsHotel"]||[model.fieldName isEqualToString:@"IsSupplierBear"]||[model.fieldName isEqualToString:@"IsSelfDrive"]||[model.fieldName isEqualToString:@"Reserved1"]||[model.fieldName isEqualToString:@"Reserved2"]||[model.fieldName isEqualToString:@"Reserved3"]||[model.fieldName isEqualToString:@"Reserved4"]||[model.fieldName isEqualToString:@"Reserved5"]||[model.fieldName isEqualToString:@"Reserved6"]||[model.fieldName isEqualToString:@"Reserved7"]||[model.fieldName isEqualToString:@"Reserved8"]||[model.fieldName isEqualToString:@"Reserved9"]||[model.fieldName isEqualToString:@"Reserved10"]) {
            _int_line5 = 1;
        }
        if (_arr_travelRoute.count > 0) {
            _int_line6 = 1;
        }
    }
}
-(void)updateTravelPeople{
    _view_travelPeople.showSetArray = self.arr_travelPeopleShowSet;
    _view_travelPeople.showDataArray = self.arr_travelPeopleShowData;
    [_view_travelPeople refresh];
    
}

-(void)updateTravelInfo{
    _view_travelInfo.showSetArray = self.arr_travelInfoShowSet;
    _view_travelInfo.showDataArray = self.arr_travelInfoShowData;
    [_view_travelInfo refresh];
    
}
-(void)updateFeeBudget{
    _view_feeBudget.showSetArray = self.arr_feeBudgetShowSet;
    _view_feeBudget.showDataArray = self.arr_feeBudgetShowData;
    [_view_feeBudget refresh];
}


//更新出差出差申请事由
-(void)updateReasonViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_TravelReason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_TravelReason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新出差类型事由
-(void)updateTravelTypeViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_BusinessType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_BusinessType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新出差类别
-(void)updateTravelCatViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_TravelCat.view_View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_TravelCat.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新归口部门
-(void)updateRelevantDeptViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_RelevantDept.view_View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_RelevantDept.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新经费来源
-(void)updateFinancialSourceViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_model_FinancialSource.view_View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.model_FinancialSource.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新出差期间
-(void)updateFromDateViewWithModel_tr:(MyProcurementModel *)model{
    _lab_StartDay = [UILabel new];
    model.Description = Custing(@"出发时间", nil);
    __weak typeof(self) weakSelf = self;
    [_view_Date addSubview:[XBHepler creation_Lable:_lab_StartDay model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Date updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
    _lab_EndDay = [UILabel new];
    model.Description = Custing(@"返回时间", nil);
    [_view_ToDate addSubview:[XBHepler creation_Lable:_lab_EndDay model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ToDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    
}

//更新出发地
-(void)updateFromCityViewWithModel_tr:(MyProcurementModel *)model{
    _lab_OriginName = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_Origin addSubview:[XBHepler creation_Lable:_lab_OriginName model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Origin updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _lab_OriginName.text = _str_OriginName;
}

//更新目的地
-(void)updateToCityViewWithModel_tr:(MyProcurementModel *)model{
    _lab_ToCityName = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ToCity addSubview:[XBHepler creation_Lable:_lab_ToCityName model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ToCity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _lab_ToCityName.text = _str_ToCityName;
}

//更新出差人员
-(void)updateFellowOfficersViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_BusinessPersonnel addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_BusinessPersonnel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新是否用车
-(void)updateIsUseCarViewWithModel_tr:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue=Custing(@"是", nil);
    }else{
        model.fieldValue=Custing(@"否", nil);
    }
    __weak typeof(self) weakSelf = self;
    [_view_IsUseCar addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_IsUseCar updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新预支金额
-(void)updateAdvanceAmountViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_AdvanceAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_AdvanceAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateCurrencyCodeWithModel:(MyProcurementModel *)model{
    _lab_CurrencyCode = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_CurrencyCode addSubview:[XBHepler creation_Lable:_lab_CurrencyCode model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_CurrencyCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateExchangeRateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_ExchangeRate addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    _lab_ExpenseType = [UILabel new];
    [_View_ExpenseType addSubview:[XBHepler creation_Lable:_lab_ExpenseType model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ExpenseType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateAmountRateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_view_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新还款日期
-(void)updateRepayDateViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_RepayDateView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.RepayDateView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新住合约酒店
-(void)updateIsContractsHotelViewWithModel_tr:(MyProcurementModel *)model{
    _txv_ContractHotel = [GPUtils createUITextView:CGRectMake(12, Y(_view_ContractHotel)+HEIGHT(_view_ContractHotel), ScreenRect.size.width-50,80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ContractHotel addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ContractHotel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        weakSelf.txv_ContractHotel.frame = CGRectMake(X(weakSelf.txv_ContractHotel), height, WIDTH(weakSelf.txv_ContractHotel), HEIGHT(weakSelf.txv_ContractHotel));
    }]];
    
    if ([NSString isEqualToNull:model.tips]){
        _txv_ContractHotel.text=model.tips;
    }
    _txv_ContractHotel.userInteractionEnabled = NO;
    _txv_ContractHotel.textAlignment = NSTextAlignmentLeft;
    _txv_ContractHotel.keyboardType = UIKeyboardTypeNumberPad;
    _txv_ContractHotel.returnKeyType = UIReturnKeyDefault;
    [_view_ContractHotel addSubview:_txv_ContractHotel];

    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([model.fieldValue isEqualToString:@"0"]) {
            lab.text = Custing(@"否", nil);
            [_view_ContractHotel updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@116);
            }];
            _txv_ContractHotel.hidden = NO;
        }
        else
        {
            lab.text = Custing(@"是", nil);
            _txv_ContractHotel.hidden = YES;
        }
    }
    else
    {
        lab.text = Custing(@"是", nil);
        _txv_ContractHotel.hidden = YES;
    }
    
}

//更新由供应商承担费用
-(void)updateIsSupplierBearViewWithModel:(MyProcurementModel *)model{
    _txv_Supplier = [GPUtils createUITextView:CGRectMake(12, Y(_view_Supplier)+HEIGHT(_view_Supplier), ScreenRect.size.width-50,80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_Supplier addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        weakSelf.txv_Supplier.frame = CGRectMake(X(weakSelf.txv_Supplier), height, WIDTH(weakSelf.txv_Supplier), HEIGHT(weakSelf.txv_Supplier));
    }]];
    
    _txv_Supplier.userInteractionEnabled = NO;
    if ([NSString isEqualToNull:model.tips]){
        _txv_Supplier.text=model.tips;
    }
    
    _txv_Supplier.textAlignment = NSTextAlignmentLeft;
    _txv_Supplier.keyboardType = UIKeyboardTypeNumberPad;
    _txv_Supplier.returnKeyType = UIReturnKeyDefault;
    [_view_Supplier addSubview:_txv_Supplier];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([model.fieldValue isEqualToString:@"1"]) {
            lab.text = Custing(@"是", nil);
            [_view_Supplier updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@116);
            }];
            _txv_Supplier.hidden = NO;
        }
        else
        {
            lab.text = Custing(@"否", nil);
            _txv_Supplier.hidden = YES;
        }
    }
    else
    {
        lab.text = Custing(@"否", nil);
        _txv_Supplier.hidden = YES;
    }
}

//更新是否需要自驾车
-(void)updateIsSelfDriveViewWithModel:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    _txv_Drive = [GPUtils createUITextView:CGRectMake(12, Y(_view_Supplier)+HEIGHT(_view_Supplier), ScreenRect.size.width-50,80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    __weak typeof(self) weakSelf = self;
    [_view_Drive addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Drive updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        weakSelf.txv_Drive.frame = CGRectMake(X(weakSelf.txv_Drive), height, WIDTH(weakSelf.txv_Drive), HEIGHT(weakSelf.txv_Drive));
    }]];
    
    _txv_Drive = [GPUtils createUITextView:CGRectMake(12, Y(_view_Supplier)+HEIGHT(_view_Supplier), ScreenRect.size.width-50,80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    if ([NSString isEqualToNull:model.tips]){
        if ([model.isRequired floatValue]==1) {
            _txv_Drive.text=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)", nil)] ;
        }else{
            _txv_Drive.text=model.tips;
        }
    }
    _txv_Drive.userInteractionEnabled = NO;
    _txv_Drive.textAlignment = NSTextAlignmentLeft;
    _txv_Drive.keyboardType = UIKeyboardTypeNumberPad;
    _txv_Drive.returnKeyType = UIReturnKeyDefault;
    [_view_Drive addSubview:_txv_Drive];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([model.fieldValue isEqualToString:@"1"]) {
            lab.text = Custing(@"是", nil);
            [_view_Drive updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@116);
            }];
            _txv_Drive.hidden = NO;
        }
        else
        {
            lab.text = Custing(@"否", nil);
            _txv_Drive.hidden = YES;
        }
    }
    else
    {
        lab.text = Custing(@"否", nil);
        _txv_Drive.hidden = YES;
    }
}
//MARK:更新预算核算日视图
-(void)updateBudgetSubDateViewWithModel:(MyProcurementModel *)model{
    model.isOnlyRead=@"0";
    _txf_BudgetSubDate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_BudgetSubDate WithContent:_txf_BudgetSubDate WithFormType:formViewSelectDate WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    _txf_BudgetSubDate.textColor=Color_Blue_Important_20;
    __weak typeof(self) weakSelf = self;
    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
        weakSelf.str_BudgetSubDate=selectTime;
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        self.str_beforeBudgetSubDate=[NSString stringWithFormat:@"%@",model.fieldValue];
        self.str_BudgetSubDate=[NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_View_BudgetSubDate addSubview:view];
}

//更新出差申请备注
-(void)updateRemarkViewWithModel_tr:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_RemarkView addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.RemarkView updateConstraints:^(MASConstraintMaker *make) {
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
//更新附件视图
-(void)updateAttachmentsViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_model_Attachments.view_View withEditStatus:2 withModel:model];
    view.maxCount = 10;
    [_model_Attachments.view_View addSubview:view];
    [view updateWithTotalArray:_arr_img_total WithImgArray:_arr_img];
}

//更新申请单的视图
-(void)updateNeedsTableView_ap{

    [_NeedsTableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.DetailsMeunNum*24+22));
    }];
    [_NeedsTableView reloadData];
}

//更新出差申请自定义字段
-(void)updateReserved1ViewWithModel_ap:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_Reserved1View addSubview:[ReserverdLookMainView initArr:_ProcurementArray view:_Reserved1View block:^(NSInteger height) {
        [weakSelf.Reserved1View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateTicketFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_TicketFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_TicketFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateTrafficFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_view_TrafficFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_TrafficFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateHotelFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_view_HotelFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_HotelFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateMealFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_view_MealFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_MealFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateTravelAllowanceViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_AllowanceFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_AllowanceFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateEntertainmentFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_EntertainmentFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_EntertainmentFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateOtherFeeViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;

    [_view_OtherFee addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_OtherFee updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateEstimatedAmountModel:(MyProcurementModel *)model{
    [_view_EstimatedHead mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@27);
    }];
    UIImageView *ImgView = [GPUtils createImageViewFrame:CGRectMake(0, 0.5, 4, 26) imageName:@"Work_HeadBlue"];
    ImgView.backgroundColor = Color_Blue_Important_20;
    [_view_EstimatedHead addSubview:ImgView];
    
    UILabel *titleLabel = [GPUtils createLable:CGRectMake(0, 0, 180, 18) text:Custing(@"预估金额", nil) font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    titleLabel.center = CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    [_view_EstimatedHead addSubview:titleLabel];
    
    [_view_EstimatedAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 IsAmount:1 block:^(NSInteger height) {
        [self.view_EstimatedAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新出差申请审批人
-(void)updateApproveViewWithModel_ap:(MyProcurementModel *)model{
    model.Description=Custing(@"审批人", nil);
    model.fieldValue=@"";
    _txf_Approver=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_ApproveView WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":@"",@"value2":@""}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.ApproveImgView=image;
        [self SecondApproveClick:[UIButton new]];
    }];
    [_ApproveView addSubview:view];
}

//审批记录
-(void)updateNotesTableView_ap{
    __weak typeof(self) weakSelf = self;

    [_fourthView addSubview:[[FlowChartView alloc] init:_meItemArray Y:0 HeightBlock:^(NSInteger height) {
        [weakSelf.fourthView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
            make.top.equalTo(self.ApproveView.bottom).offset(@10);
        }];
    } BtnBlock:^{
        [self goTo_Webview];
    }]];
}

//行程安排
-(void)updateTravelRouteView{
    
    CGFloat height = [self getTravelRouteTableHeight];
    [_view_travelRoute updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(27 + height);
    }];
    
    UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    img_line.image=[UIImage imageNamed:@"Work_HeadBlue"];
    img_line.backgroundColor=Color_Blue_Important_20;
    [_view_travelRoute addSubview:img_line];
    
    UILabel *lab_title = [GPUtils createLable:CGRectMake(0, 0, 180, 18) text:Custing(@"行程安排", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    lab_title.center=CGPointMake(X(img_line)+WIDTH(img_line)+90+8, 13.5);
    [_view_travelRoute addSubview:lab_title];
    
    _tbv_travelRoute = [[UITableView alloc]initWithFrame:CGRectMake(0, 27, Main_Screen_Width, height) style:UITableViewStylePlain];
    _tbv_travelRoute.backgroundColor = Color_form_TextFieldBackgroundColor;
    _tbv_travelRoute.delegate = self;
    _tbv_travelRoute.dataSource = self;
    _tbv_travelRoute.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_view_travelRoute addSubview:_tbv_travelRoute];
    if (_arr_travelRoute.count>0) {
        [_tbv_travelRoute reloadData];
    }
}


//出差单
-(void)updateNeedsTableView_tr{
    [_needsView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.Arr_Demand.count*25+self.Arr_homeArray.count*58+self.Arr_trainArray.count*58+self.Arr_planeTicketArray.count*58+16);
        make.bottom.equalTo(self.NeedsTableView.bottom).offset(@8);
        make.top.equalTo(self.view_feeBudget.bottom).offset(@10);
    }];
    _NeedsTableView.frame = CGRectMake(0, 0, Main_Screen_Width, _Arr_Demand.count*25+_Arr_homeArray.count*58+_Arr_trainArray.count*58+_Arr_planeTicketArray.count*58);
    [self.NeedsTableView reloadData];
}


//MARK:更新用车需求单
-(void)updateTravelCarDetail{
    [_TravelCarDetailView updateTravelCarDetailViewWithData:self.arr_carPlanData WithEditType:2];
}

//MARK:更新报销政策视图
-(void)updateReimPolicyView{
    __weak typeof(self) weakSelf = self;
    ReimPolicyView *view=[[ReimPolicyView alloc]initWithFlowCode:self.FormData.str_flowCode withBodydict:self.dict_ReimPolicyDict withBaseViewHeight:^(NSInteger height, NSDictionary *date) {
        if ([date[@"location"]floatValue]==1) {
            [weakSelf.ReimPolicyDownView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }else{
            [weakSelf.ReimPolicyUpView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }
    }];
    view.clickBlock = ^(NSString *bodyUrl) {
        PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
        pdf.url =bodyUrl;
        [self.navigationController pushViewController:pdf animated:YES];
    };
    if ([self.dict_ReimPolicyDict[@"location"]floatValue]==1) {
        [_ReimPolicyDownView addSubview:view];
    }else{
        [_ReimPolicyUpView addSubview:view];
    }
}


//更新底层视图
-(void)updateBottomView_tr{
    [_fifthView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ApproveView.bottom);
    }];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    
    if (_int_line1 == 1) {
        [_view_line1 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line2 == 1) {
        [_view_line2 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line3 == 1) {
        [_view_line3 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
    }
    if (_int_line4 == 1) {
        [_view_line4 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
    if (_int_line5 == 1) {
        [_view_line5 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
    }
    if (_int_line6 == 1) {
        [_view_line6 updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
        }];
    }
}

#pragma mark 数据
//初始化数据
-(void)initializeData_lt{
    _ProcurementArray=[NSMutableArray array];
    _meItemArray=[NSMutableArray array];
    _DetailsMeunNum=0;
    _isOpenDetail=NO;
    _twoHandeId=@"";
    _twoApprovalName=@"";
    _Arr_Demand = [[NSMutableArray alloc]init];
    _Arr_homeArray = [[NSMutableArray alloc]init];
    _Arr_trainArray = [[NSMutableArray alloc]init];
    _Arr_planeTicketArray = [[NSMutableArray alloc]init];
    _arr_travelRoute = [[NSMutableArray alloc]init];
    _str_startDate = @"";
    _str_endDate = @"";
    _str_Approve = @"";
    _str_OriginName = @"";
    _str_ToCityName = @"";
    _canEndorse = @"";
    _int_line1 = 0;
    _int_line2 = 0;
    _int_line3 = 0;
    _int_line4 = 0;
    _int_line5 = 0;
    _int_line6 = 0;
    _int_line7 = 0;
    _int_line8 = 0;
    
    if (![NSString isEqualToNull:_taskId]) {
        _taskId = @"0";
    }
    if (![NSString isEqualToNull:_userId]) {
        _userId = @"0";
    }
    if (![NSString isEqualToNull:_procId]) {
        _procId = @"0";
    }
    _arr_img_total = [NSMutableArray array];
    _arr_img = [NSMutableArray array];
    _model_Attachments = [[WorkFormFieldsModel alloc]initialize];
    _model_RelevantDept = [[WorkFormFieldsModel alloc]initialize];
    _model_FinancialSource = [[WorkFormFieldsModel alloc]initialize];
    _model_TravelCat = [[WorkFormFieldsModel alloc]initialize];
}

//解析下载的数据
-(void)getMyHasProcurementData_tr{
    NSDictionary *result=[_resultDict objectForKey:@"result"];
    _canEndorse=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"canEndorse"]]]?[NSString stringWithFormat:@"%@",result[@"canEndorse"]]:@"0";
    
    //报销政策
    if ([_resultDict[@"result"][@"formRule"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *formRule = _resultDict[@"result"][@"formRule"];
        if ([formRule[@"claimPolicy"]isKindOfClass:[NSDictionary class]]) {
            self.dict_ReimPolicyDict=formRule[@"claimPolicy"];
        }
    }
    
    [self.FormData getFormSettingBaseData:result];

    self.arr_More=[NSMutableArray arrayWithArray:@[@1,@2,@3]];
    //是否显示打印
    if (![[NSString stringWithFormat:@"%@",result[@"isPrint"]]isEqualToString:@"1"]) {
        [self.arr_More removeObject:@3];
    }
    if (self.comeStatus!=3) {
        [self.arr_More removeObject:@2];
    }
    self.bool_carPlan = [[NSString stringWithFormat:@"%@",_resultDict[@"result"][@"carPlan"]]isEqualToString:@"1"] ? YES:NO;
    if (self.bool_carPlan) {
        self.arr_carPlanShow = [NSMutableArray array];
        self.arr_carPlanData = [NSMutableArray array];
        if ([_resultDict[@"result"][@"carFormFields"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in _resultDict[@"result"][@"carFormFields"]) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_carPlanShow addObject:model];
            }
        }
    }

    [self getChildDetialiSetting];
    

    _flowCode = @"F0001";
    _FormData.str_SerialNo = [NSString isEqualToNull:result[@"serialNo"]]?[NSString stringWithFormat:@"%@",result[@"serialNo"]]:@"";
    if (![result isKindOfClass:[NSNull class]]) {
        _SerialNo=[NSString stringWithFormat:@"%@",[result objectForKey:@"serialNo"]];
        //默认申请人及相关数据
        _personDict=[result objectForKey:@"operatorUser"];
        _SerialNo=[NSString stringWithFormat:@"%@",[result objectForKey:@"serialNo"]];
        NSArray *mainFld = [result objectForKey:@"formFields"];
        if (![mainFld isKindOfClass:[NSNull class]]) {
            if (mainFld.count!=0) {
                for (NSDictionary *dic in mainFld) {
                    MyProcurementModel *model=[[MyProcurementModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_ProcurementArray addObject:model];
                    [_FormData getMainFormShowAndData:dic WithAttachmentsMaxCount:10];
                    if ([model.fieldName isEqualToString:@"RequestorGender"]) {
                        _firstHandlerGender = [model.fieldValue intValue];
                    }
                    //解析图片
                    if ([dic[@"fieldName"] isEqualToString:@"Attachments"]) {
                        if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                            NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                            for (NSDictionary *dict in array) {
                                [_arr_img_total addObject:dict];
                            }
                            [GPUtils updateImageDataWithTotalArray:_arr_img_total WithImageArray:_arr_img WithMaxCount:5];
                        }
                    }
                    
                    if ([model.fieldName isEqualToString:@"EstimatedAmount"]) {
                        self.bool_showEstimated = [model.isShow integerValue]==1;
                    }
                    if ([model.fieldName isEqualToString:@"Requestor"]&&[NSString isEqualToNull:model.fieldValue]) {
                        _str_Approve = model.fieldValue;
                    }
                    if ([model.fieldName isEqualToString:@"FromCity"]&&[NSString isEqualToNull:model.fieldValue]) {
                        _str_OriginName = model.fieldValue;
                    }
                    if ([model.fieldName isEqualToString:@"ToCity"]&&[NSString isEqualToNull:model.fieldValue]) {
                        _str_ToCityName = model.fieldValue;
                    }
                    if ([model.fieldName isEqualToString:@"ShareDeptIds"]) {
                        self.str_ShareDeptIds=[NSString isEqualToNull:model.fieldValue]?model.fieldValue:@"";
                    }
                    if ([[model.isShow stringValue]isEqualToString:@"1"]) {
                        if ([model.fieldName isEqualToString:@"FlightPlan"]){
                            [_Arr_Demand addObject:model];
                        }
                        if ([model.fieldName isEqualToString:@"RoomPlan"]){
                            [_Arr_Demand addObject:model];
                        }
                        if ([model.fieldName isEqualToString:@"TrainPlan"]){
                            [_Arr_Demand addObject:model];
                        }
                    }
                }
            }
        }
        
        [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:result WithFormArray:_ProcurementArray];
        
        //解析出差单据
        if ([result[@"formData"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *detail = result[@"formData"][@"detail"];
            NSArray *planearray = [detail objectForKey:@"sa_travelflightdetail"];
            NSArray *homearray = [detail objectForKey:@"sa_travelhoteldetail"];
            NSArray *trainarray = [detail objectForKey:@"sa_traveltraindetail"];
            _arr_travelRoute = [detail objectForKey:@"sa_TravelRouteDetail"];
            for (int i = 0 ; i<planearray.count; i++) {
                if ([NSString isEqualToNull:planearray[i][@"departureDate"]]||[NSString isEqualToNull:planearray[i][@"fromCityCode"]]||[NSString isEqualToNull:planearray[i][@"toCityCode"]]||[NSString isEqualToNull:planearray[i][@"flyPeople"]]) {
                    [_Arr_planeTicketArray addObject: [[TravelFlightDetailModel alloc]initDicToModel:planearray[i]]];
                }
            }
            for (int i = 0 ; i<homearray.count; i++) {
                if([NSString isEqualToNull:homearray[i][@"checkInDate"]]||[NSString isEqualToNull:homearray[i][@"checkInCityCode"]]||[NSString isEqualToNull:homearray[i][@"checkOutDate"]]||[NSString isEqualToNull:homearray[i][@"numberOfRooms"]]) {
                    [_Arr_homeArray addObject: [[TravelHotelDetailModel alloc]initDicToModel:homearray[i]]];
                }
            }
            for (int i = 0 ; i<trainarray.count; i++) {
                if ([NSString isEqualToNull:trainarray[i][@"departureDate"]]||[NSString isEqualToNull:trainarray[i][@"fromCityCode"]]||[NSString isEqualToNull:trainarray[i][@"toCityCode"]]||[NSString isEqualToNull:trainarray[i][@"passenger"]]) {
                    [_Arr_trainArray addObject:[[TravelTrainDetailModel alloc]initDicToModel:trainarray[i]]];
                }
            }
        }
    }
}

//审批记录数据
-(void)getNoteData_tr
{
    NSDictionary *result=[_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        _noteStatus=[NSString stringWithFormat:@"%@",result[@"statusCode"]];
        _FormData.str_noteStatus = _noteStatus;
        NSArray *array=result[@"taskProcList"];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model=[[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_meItemArray addObject:model];
        }
    }
}
-(void)getChildDetialiSetting{
    
    NSDictionary *result = _resultDict[@"result"];
    if ([[NSString stringWithFormat:@"%@",result[@"userInfoDetail"]]isEqualToString:@"1"]) {
        self.bool_travelPeople  = YES;
        self.arr_travelPeopleShowSet = [NSMutableArray array];
        if ([result[@"userInfoDetailFormFields"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"userInfoDetailFormFields"]) {
                MyProcurementModel *model= [[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.arr_travelPeopleShowSet addObject:model];
            }
        }
        self.arr_travelPeopleShowData =[NSMutableArray array];
    }
    if ([[NSString stringWithFormat:@"%@",result[@"itineraryDetail"]]isEqualToString:@"1"]) {
        self.bool_travelInfo  = YES;
        self.arr_travelInfoShowSet = [NSMutableArray array];
        if ([result[@"itineraryDetailFormFields"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"itineraryDetailFormFields"]) {
                MyProcurementModel *model= [[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.arr_travelInfoShowSet addObject:model];
            }
        }
        self.arr_travelInfoShowData =[NSMutableArray array];
    }
    if ([[NSString stringWithFormat:@"%@",result[@"budgetDetail"]]isEqualToString:@"1"]) {
        self.bool_feeBudget  = YES;
        self.arr_feeBudgetShowSet = [NSMutableArray array];
        if ([result[@"budgetDetailFields"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"budgetDetailFields"]) {
                MyProcurementModel *model= [[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.arr_feeBudgetShowSet addObject:model];
            }
        }
        self.arr_feeBudgetShowData =[NSMutableArray array];
    }
    
    self.arr_travelPeopleShowData = [NSMutableArray array];
    self.arr_travelInfoShowData= [NSMutableArray array];
    self.arr_feeBudgetShowData = [NSMutableArray array];
    if ([result[@"formData"]isKindOfClass:[NSDictionary class]]&&[result[@"formData"][@"detail"]isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = result[@"formData"][@"detail"];
        if ([dict[@"sa_TravelUserInfoDetail"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dict[@"sa_TravelUserInfoDetail"]) {
                TravelPeopleInfoModel *model = [[TravelPeopleInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_travelPeopleShowData addObject:model];
            }
        }
        if ([dict[@"sa_TravelItineraryDetail"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dict[@"sa_TravelItineraryDetail"]) {
                TravelInfoModel *model = [[TravelInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_travelInfoShowData addObject:model];
            }
        }
        if ([dict[@"sa_TravelBudgetDetail"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dict[@"sa_TravelBudgetDetail"]) {
                FeeBudgetInfoModel *model = [[FeeBudgetInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_feeBudgetShowData addObject:model];
            }
        }
        if (self.bool_carPlan) {
            if ([dict[@"sa_travelcardetail"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in dict[@"sa_travelcardetail"]) {
                    TravelCarDetail *model=[[TravelCarDetail alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.arr_carPlanData addObject:model];
                }
            }
        }
    }
}

//同意数据处理
-(void)dealWithData
{
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"FirstHandlerUserId",@"FirstHandlerUserName",@"BudgetSubDate",@"ShareDeptIds",nil];
    if (![NSString isEqualToNull:_twoHandeId]) {
        _twoHandeId=@"";
    }
    NSArray *travelfieldValues=[NSArray arrayWithObjects:_twoHandeId,_twoApprovalName,self.str_BudgetSubDate, self.str_ShareDeptIds, nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_TravelApp"]};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    _parametersDict=@{@"mainDataList":mainArray};
}

#pragma mark 网络请求
//第一次打开表单和保存后打开表单接口
-(void)requestHasProcurement_lt
{
    NSDictionary *parameters = @{@"TaskId":_taskId,@"ProcId":_procId,@"UserId":_userId,@"FlowCode":@"F0001"};
    
    NSString *url=[NSString stringWithFormat:@"%@",tr_GetformdataV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取审批记录
-(void)requestApproveNote_tr{
    NSString *url=[NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}


-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:11 IfUserCache:NO];
}

#pragma mark  打印链接
-(void)GoToPush{
    self.PrintfBtn.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GETPrintLink];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}

#pragma mark - action
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
    contactVC.itemType = 1;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        buildCellInfo *bul = array.lastObject;
        weakSelf.twoApprovalName = bul.requestor;
        weakSelf.twoHandeId=[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId];
        weakSelf.txf_Approver.text= bul.requestor;
        if ([NSString isEqualToNull:bul.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:bul.photoGraph];
            if ([NSString isEqualToNull:[dic objectForKey:@"filepath"]]) {
                [weakSelf.ApproveImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]]]];
            }else{
                weakSelf.ApproveImgView.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
            }
        }else{
            weakSelf.ApproveImgView.image=bul.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//退单
-(void)backclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"0";
    exa.FlowCode = @"F0001";
    [self.navigationController pushViewController:exa animated:YES];
}

//拒绝 改为加签
-(void)refuseclick:(UIButton *)btn
{
    examineViewController *exa = [[examineViewController alloc]init];
    exa.TaskId = _taskId;
    exa.ProcId = _procId;
    exa.Type = @"1";
    exa.FlowCode = @"F0001";
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
    exa.FlowCode = @"F0001";
    exa.dic_APPROVAL = _parametersDict;
    NSDictionary *dict=@{@"IsEdit":[[NSString stringWithFormat:@"%@",self.str_beforeBudgetSubDate] isEqualToString:[NSString stringWithFormat:@"%@",self.str_BudgetSubDate]]?@"0":@"1"};
    exa.str_CommonField = [NSString transformToJson:dict];
    [self.navigationController pushViewController:exa animated:YES];
}

//撤回操作
-(void)reCallBack_ap{
    _recallBtn.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"FlowCode":_flowCode,@"TaskId":_taskId,@"RecallType":self.comeStatus==7?@"2":@"1"};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",RecallList];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
-(void)goUrge{
    NSLog(@"催办操作");
    self.dockView.userInteractionEnabled=NO;
    NSDictionary * parameters = @{@"FlowCode":_flowCode,@"TaskId":_taskId};
    //    NSLog(@"%@",parameters);
    NSString *url=[NSString stringWithFormat:@"%@",BPMURGE];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache :NO];
}
//付款操作
-(void)PayBtn_click:(UIButton *)btn{
    if ([self.userdatas.isOnlinePay isEqualToString:@"1"]) {
        PayMentDetailController *batch=[[PayMentDetailController alloc]init];
        MyApplyModel *model=[[MyApplyModel alloc]init];
        model.taskId=_taskId;
        model.procId=_procId;
        batch.batchPayArray=[NSMutableArray arrayWithObject:model];
        [self.navigationController pushViewController:batch animated:YES];
    }else{
        self.dockView.userInteractionEnabled=NO;
        [self dealPayData];
        //临时解析用的数据
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_paymentDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
        NSDictionary * parameters = @{@"ActionLinkName":@"同意",@"Comment":@"",@"TaskId":_taskId,@"ProcId":_procId,@"FormData":stri,@"ExpIds":@""};
        //    NSLog(@"%@",parameters);
        NSString *url=[NSString stringWithFormat:@"%@",SinglePay];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:7 IfUserCache:NO];
    }
}

//确认支付数据
-(void)dealPayData
{
    NSArray *travelFieldName=[NSArray arrayWithObjects:@"twohandleruserid",@"twohandlerusername",nil];
    NSArray *travelfieldValues=[NSArray arrayWithObjects:@"",@"", nil];
    
    NSDictionary *travelDict=@{@"fieldNames":travelFieldName,@"fieldValues":travelfieldValues,@"tableName":[NSString stringWithFormat:@"%@",@"Sa_TravelApp"]};
    
    NSArray *mainArray=[NSArray arrayWithObjects:travelDict, nil];
    _paymentDict=@{@"mainDataList":mainArray};
}


#pragma mark - 代理
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    _resultDict=responceDic;
    [YXSpritesLoadingView dismiss];
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        [YXSpritesLoadingView dismiss];
        _backBtn.userInteractionEnabled=YES;
        _refuseBtn.userInteractionEnabled=YES;
        _agreeBtn.userInteractionEnabled=YES;
        self.PrintfBtn.userInteractionEnabled=YES;
        self.dockView.userInteractionEnabled=YES;
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"resultCode"]] isEqualToString:@"1001"]) {
            [self updateAprovalProcess:self.FormData.str_flowGuid WithProcId:[NSString stringWithFormat:@"%@",responceDic[@"procId"]]];
        }else{
            NSString * error = [responceDic objectForKey:@"msg"];
            //        NSLog(@"%@",error);
            if (![error isKindOfClass:[NSNull class]]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
            }
        }
        return;
    }
    switch (serialNum) {
        case 0:
        {
            [self getMyHasProcurementData_tr];
            NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowGuid];
            self.navigationItem.title = dict[@"Title"];
            [self requestApproveNote_tr];
        }
            break;
        case 1:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_resultDict[@"msg"] duration:1.5];
            [self performBlock:^{
                [self returnBack];
            } afterDelay:1.5];
            break;
        }
        case 2:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"撤回成功" duration:1.5];
            [self performBlock:^{
                if (self.comeStatus==2||self.comeStatus==8) {
                    TravelRequestsViewController *art=[[TravelRequestsViewController alloc]init];
                    art.taskId=self.taskId;
                    art.userId=self.userId;
                    art.comeStatus= 4;
                    art.backIndex = @"1";
                    art.procId=[NSString stringWithFormat:@"%@",responceDic[@"result"]];
                    art.FormData.str_flowGuid = self.FormData.str_flowGuid;
                    [self.navigationController pushViewController:art animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } afterDelay:1.0];
        }
            break;
        case 3:
            [YXSpritesLoadingView dismiss];
            [self createScrollView_lt];
            [self getNoteData_tr];
            [self updateMainView];
            break;
        case  5:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_resultDict[@"msg"] duration:1.5];
            [self performBlock:^{
                [self returnBack];
            } afterDelay:1.5];
            break;
        }
        case  6:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_resultDict[@"msg"] duration:1.5];
            [self performBlock:^{
                [self returnBack];
            } afterDelay:1.5];
            break;
        }
        case  7:
        {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:_resultDict[@"msg"] duration:1.5];
            [self performBlock:^{
                [self returnBack];
            } afterDelay:1.5];
            break;
        }
        case 10:
        {
            self.PrintfBtn.userInteractionEnabled=YES;
            NSDictionary *dict=_resultDict[@"result"];
            if (![dict isKindOfClass:[NSNull class]]) {
                [self gotoPrintfForm:[SendEmailModel modelWithInfo:@{
                                                                     @"link":[NSString stringWithFormat:@"%@",dict[@"link"]],
                                                                     @"password":[NSString stringWithFormat:@"%@",dict[@"password"]],
                                                                     @"title":[NSString stringWithFormat:@"%@",dict[@"taskName"]],
                                                                     @"flowCode":@"F0001",
                                                                     @"requestor":self.FormData.personalData.Requestor
                                                                     }]];
                
            }
            break;
        }
        case 11:
        {
            [self goToFlowChartWithUrl:responceDic[@"result"]];
        }
            break;
        default:
            break;
    }
}

//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    _backBtn.userInteractionEnabled=YES;
    _refuseBtn.userInteractionEnabled=YES;
    _agreeBtn.userInteractionEnabled=YES;
    self.PrintfBtn.userInteractionEnabled=YES;
    self.dockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}


#pragma mark 表单代理
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_NeedsTableView) {
        return _Arr_Demand.count;
    }else if (tableView==_tbv_travelRoute){
        return 1;
    }else{
        return 1;
    }
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_NeedsTableView) {
        MyProcurementModel *model = _Arr_Demand[section];
        NSString *string = model.fieldName;
        if ([string isEqualToString:@"FlightPlan"]) {
            return _Arr_planeTicketArray.count;
        }
        if ([string isEqualToString:@"RoomPlan"]) {
            return _Arr_homeArray.count;
        }
        if ([string isEqualToString:@"TrainPlan"]) {
            return _Arr_trainArray.count;
        }
    }else if (tableView==_tbv_travelRoute){
        return _arr_travelRoute.count;
    }else{
        return _meItemArray.count;
    }
    return 0;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_NeedsTableView) {
        return 58;
    }else if (tableView==_tbv_travelRoute){
        NSDictionary *dict = self.arr_travelRoute[indexPath.row];
        return [TravelRouteDetailCell cellHeightWithObj:dict];
    }else{
        approvalNoteModel *model=(approvalNoteModel *)_meItemArray[indexPath.row];
        if ([NSString isEqualToNull:model.comment]) {
            CGSize size = [model.comment sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-106, 10000) lineBreakMode:NSLineBreakByTruncatingTail];
            _NotesTableHeight=_NotesTableHeight+75+size.height;
            return 75+size.height;
        }else{
            _NotesTableHeight=_NotesTableHeight+70;
            return 70;
        }
    }
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_NeedsTableView) {
        return 27;
    }
    return 0;
}

//组头加载
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 25)];
    view.backgroundColor = Color_White_Same_20;
    if (tableView==_NeedsTableView) {
        MyProcurementModel *model = _Arr_Demand[section];
        NSString *string = model.fieldName;
        
        UIImageView *img_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, 25)];
        img_line.backgroundColor = Color_Blue_Important_20;
        [view addSubview:img_line];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, Main_Screen_Width-60, 25)];
        lab.font = Font_Important_15_20;
        lab.textColor = Color_GrayDark_Same_20;
        if ([string isEqualToString:@"FlightPlan"]) {
            lab.text = Custing(@"机票需求单", nil);
        }
        if ([string isEqualToString:@"RoomPlan"]) {
            lab.text = Custing(@"住宿需求单",nil);
        }
        if ([string isEqualToString:@"TrainPlan"]) {
            lab.text = Custing(@"火车票需求单",nil);
        }
        [view addSubview:lab];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:view.frame];
        btn.tag = section;
        [view addSubview:btn];
    }
    return view;
}



//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _NeedsTableView) {
        static NSString * cellid = @"travelCell";
        travelPlanViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellid];
        
        
        MyProcurementModel *model = _Arr_Demand[indexPath.section];
        NSString *string = model.fieldName;
        if ([string isEqualToString:@"FlightPlan"]) {
            if (_Arr_planeTicketArray.count>0) {
                TravelFlightDetailModel *flight = _Arr_planeTicketArray[indexPath.row];
                if (cell==nil) {
                    cell=[[travelPlanViewCell alloc] initModelwithByFlightCell:flight ];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.type =1;
                }
            }
        }
        if ([string isEqualToString:@"RoomPlan"]) {
            if (_Arr_homeArray.count>0) {
                TravelHotelDetailModel *home = _Arr_homeArray[indexPath.row];
                if (cell==nil) {
                    cell=[[travelPlanViewCell alloc] initModelwithByHomeCellInLook:home];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.type =1;
                }
            }
        }
        if ([string isEqualToString:@"TrainPlan"]) {
            if (_Arr_trainArray.count>0) {
                TravelTrainDetailModel *train = _Arr_trainArray[indexPath.row];
                if (cell==nil) {
                    cell=[[travelPlanViewCell alloc] initModelwithByTrainCell:train];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.type =1;
                }
            }
        }
        return cell;
    }else if (tableView==_tbv_travelRoute){
        TravelRouteDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TravelRouteDetailCell"];
        if (cell==nil) {
            cell=[[TravelRouteDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelRouteDetailCell"];
        }
        cell.bool_hideLine = (indexPath.row == self.arr_travelRoute.count - 1);
        NSDictionary *dict = _arr_travelRoute[indexPath.row];
        cell.dict_Info = dict;
        return cell;
    }else{
        approvalNoteCell *cell=[tableView dequeueReusableCellWithIdentifier:@"approvalNoteCell"];
        if (cell==nil) {
            cell=[[approvalNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"approvalNoteCell"];
        }
        if (indexPath.row == 0) {
            UIButton *btn = [GPUtils createButton:CGRectMake(Main_Screen_Width-10-30-60, 18, 60, 20) action:@selector(goTo_Webview) delegate:self title:Custing(@"流程图", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            [cell addSubview:btn];
        }
        approvalNoteModel *model=(approvalNoteModel *)_meItemArray[indexPath.row];
        [cell configViewWithModel:model withCount:_meItemArray.count withIndex:indexPath.row];
        NSLog(@"%@%ld",Custing(@"数量", nil),(long)indexPath.section);
        return cell;
    }
}

-(CGFloat)getTravelRouteTableHeight{
    CGFloat height = 0;
    for (NSDictionary *dict in self.arr_travelRoute) {
        height += [TravelRouteDetailCell cellHeightWithObj:dict];
    }
    return height;
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
