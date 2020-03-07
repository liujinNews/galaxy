//
//  TravelRequestsViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 16/4/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "TravelRequestsViewController.h"
#import "BottomView.h"
#import "NewAddressViewController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ChooseCategoryController.h"
#import "ChooseCategoryModel.h"
#import "NewBusinessPlanViewController.h"

#import "TravelHotelDetailModel.h"
#import "TravelFlightDetailModel.h"
#import "TravelTrainDetailModel.h"
#import "travelPlanViewCell.h"
#import "FieldNamesModel.h"
#import "JKAlertDialog.h"
#import "SexEditTableViewCell.h"
#import "NewAddressViewController.h"
#import "approvalNoteModel.h"
#import "approvalNoteCell.h"
#import "FormSubChildView.h"
#import "TravelPeopleInfoModel.h"
#import "TravelInfoModel.h"
#import "FeeBudgetInfoModel.h"
#import "AddTravelRouteController.h"
#import "TravelRouteDetailCell.h"
#import "TravelCarDetailView.h"
#import "TravelCarDetailNewController.h"

@interface TravelRequestsViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,NewAddressVCDelegate,ByvalDelegate,chooseTravelDateViewDelegate,NewBusinessPlanViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,NewAddressVCDelegate,chooseTravelDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *Arr_mainFld;//视图加载数据
@property (nonatomic, strong) NSMutableArray *Arr_detailFld;//物品明细加载数据
@property (nonatomic, strong) NSDictionary *Dic_requset;//下载的数据
@property (nonatomic, strong) NSMutableDictionary *reservedDic;//附加数据显示集合
//拼数据专用
@property (nonatomic, strong) NSMutableDictionary *alldic;//总数据
@property (nonatomic, strong) FieldNamesModel *filedModel;//拼接数据Model
@property (nonatomic, strong) NSMutableArray *isShowmsdic;//验证字典
@property (nonatomic, strong) NSString *str_isRelateTravelForm;
/**
 *  验证必填项字典/验证必填项时填写框类型字段
 */
@property(nonatomic,strong)NSMutableDictionary *isRequiredmsdic,*isCtrlTypdic;
@property (nonatomic, strong)NSMutableArray *Arr_Demand;//预定数组
@property (nonatomic,strong)NSMutableArray *Arr_planeTicketArray;//机票需求数组
@property (nonatomic,strong)NSMutableArray *Arr_homeArray;//住宿需求单数组
@property (nonatomic,strong)NSMutableArray *Arr_trainArray;//火车需求数组

@property (nonatomic, strong)UIScrollView *scr_rootScrollView;//底层滚动视图
@property (nonatomic, strong)BottomView *contentView; //滚动视图contentView
@property (nonatomic, strong)DoneBtnView * dockView; //底部按钮视图
@property (nonatomic, strong)UIButton *saveBtn;//保存按钮
@property (nonatomic, strong)UIButton *submitBtn;//提交按钮
@property (nonatomic, strong)UIButton *backSubBtn;//退单提交按钮
//直送Button
@property(nonatomic,strong)UIButton *Direct_Btn;
@property (nonatomic, strong) NSString *str_lastAmount;
@property (nonatomic, strong) NSString *str_directType;

@property (nonatomic, strong) SubmitPersonalView *SubmitPersonalView;

@property(nonatomic,strong)UIView *view_TravelReason;//出差事由view
@property(nonatomic,strong)UITextView *txf_TravelReason;//出差事由textField


@property(nonatomic,strong)UIView *view_BusinessType;//出差类型view
@property (nonatomic, strong) UITextField *Txf_BusinessType;//出差类型文本
@property (nonatomic, strong) JKAlertDialog *alert;//出差类型的弹窗。。。
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSString *str_BusinessType_id;
@property (nonatomic, strong) NSString *str_businesstype_pro;

//出差类别
@property (nonatomic, strong) WorkFormFieldsModel *model_TravelCat;


@property(nonatomic,strong)UIView *view_Date;//时间view
@property (nonatomic, strong) UIView *view_ToDate;//时间view
@property(nonatomic,strong)UIDatePicker * datePicker;//弹出的时间图
@property (nonatomic,strong)chooseTravelDateView * datelView;//采购日期选择弹出框
//@property(nonatomic,strong)NSString *str_startDate;//开始日期
@property (nonatomic, strong) UITextField *txf_StartDay;//开始日
//@property(nonatomic,strong)UIButton *btn_StartDate;//开始时间点击
//@property(nonatomic,strong)NSString *str_endDate;//结束日期
@property (nonatomic, strong) UITextField *txf_EndDay;//结束日
//@property(nonatomic,strong)UIButton *btn_EndDate;//结束时间点击
@property (nonatomic, assign) NSInteger int_traveltimeparams;//1日期0时间

@property (nonatomic, strong) UIView *view_Origin;//出发地view
@property (nonatomic, strong) UITextField *txf_Origin;//出发地文本
@property (nonatomic, strong) NSString *str_Origin_tips;
@property (nonatomic, strong) NSString *str_OriginCode;//出发地id
@property (nonatomic ,strong) NSMutableArray *Arr_Origin;//出发地数组

@property (nonatomic, strong) UIView *view_ToCity;//目的地view
@property (nonatomic, strong) UITextField *txf_ToCity;//目的地文本
@property (nonatomic, strong) NSString *str_ToCityCode;//目的地id
@property (nonatomic, strong) NSMutableArray *Arr_ToCity;//目的地数组
@property (nonatomic, strong) NSString *tocitytip;//目的地tip

@property (nonatomic, strong) UIView *view_BusinessPersonnel;//出差人员view
@property (nonatomic, strong) UITextField *txf_BusinessPersonnel;//出差人员文本
@property (nonatomic, strong) NSString *str_BusinessPersonnel;//出差人员id
@property (nonatomic, strong) NSString *str_BusinessPersonnelDeptId;//出差人员部门id

@property (nonatomic, strong) UIView *View_IsUseCar;//是否用车
@property (nonatomic, strong) UITextField *txf_IsUseCar;//是否用车
@property (nonatomic, copy) NSString *str_IsUseCar;//是否用车
@property (nonatomic, strong) NSMutableArray *arr_IsUseCar;//是否用车数组


@property(nonatomic,strong)UIView *view_AdvanceAmount;//预支金额view
@property(nonatomic,strong)UITextField *txf_AdvanceAmount;//预支金额textField

@property (nonatomic, strong) UIView *view_CurrencyCode;//币种视图
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
@property (nonatomic, strong) NSMutableArray *muarr_CurrencyCode;//项目名称显示用数据
@property (nonatomic, strong) NSString *str_CurrencyCode;
@property (nonatomic, strong) NSString *str_CurrencyCode_PlaceHolder;
@property (nonatomic, strong) NSString *str_Currency;

@property (nonatomic, strong) UIView *view_ExchangeRate;//汇率
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
@property (nonatomic, strong) NSString *str_ExchangeRate;

@property (nonatomic, strong) UIView *view_LocalCyAmount;//本位币视图
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;

@property (nonatomic, strong) UIView *view_Duration;//还款日期
@property (nonatomic, strong) UITextField *txf_DurationData;
@property (nonatomic, strong) NSString *str_selectDataString;

@property (nonatomic, strong) UIView *RemarkView;//采购备注视图
@property (nonatomic, strong) UITextView *txv_Remark;

@property (nonatomic, strong) UIPickerView *pic_HasInvoice;
@property (nonatomic, strong) NSArray *arr_HasInvoice;
//@property(nonatomic,strong)UIView *view_ContractHotel;//住合约酒店view
//@property(nonatomic,strong)UIButton *btn_ContractHotel_Yes;//住合约酒店是按钮
//@property(nonatomic,strong)UIButton *btn_ContractHotel_No;//住合约酒店否按钮
@property (nonatomic, strong) WorkFormFieldsModel *model_ContractHotel;
@property (nonatomic, strong) UITextView *txv_ContractHotel;//不住合约酒店理由
@property (nonatomic, strong) NSString *str_ContractHotel_tips;

//@property(nonatomic,strong)UIView *view_Supplier;//供应商承担view
//@property(nonatomic,strong)UIButton *btn_Supplier_Yes;//供应商承担是按钮
//@property(nonatomic,strong)UIButton *btn_Supplier_No;//供应商承担否按钮
@property (nonatomic, strong) WorkFormFieldsModel *model_Supplier;
@property(nonatomic,strong)UITextView *txv_Supplier;//供应商承担理由
@property (nonatomic, strong) NSString *str_Supplier_tips;

//@property(nonatomic,strong)UIView *view_Drive;//自驾车view
//@property(nonatomic,strong)UIButton *btn_Drive_Yes;//自驾车是按钮
//@property(nonatomic,strong)UIButton *btn_Drive_No;//自驾车否按钮
@property (nonatomic, strong) WorkFormFieldsModel *model_Drive;
@property(nonatomic,strong)UITextView *txv_Drive;//自驾车理由
@property (nonatomic, strong) NSString *str_Drive_tips;

@property (nonatomic, strong) WorkFormFieldsModel *model_Attachments;
@property (nonatomic, strong) NSMutableArray *arr_Attachments_Totle;
@property (nonatomic, strong) NSMutableArray *arr_Attachments_Image;
//自定义字段
@property(nonatomic,strong)UIView *Reserved1View;

@property (nonatomic, strong) ReserverdMainModel *model_rs;

@property (nonatomic,strong)UIView *NoteView;//审批记录
@property (nonatomic,strong)NSMutableArray *noteDateArray;//审批记录数据
@property(nonatomic,assign)NSInteger NotesTableHeight;//审批记录tableView高度
@property (nonatomic,strong)NSDictionary *resultDict;


@property(nonatomic,strong)UIView *view_ApproveView;//采购审批人视图
@property(nonatomic,strong)UIImageView *img_ApproveImgView;//审批人头像
@property(nonatomic,strong)UITextField *txf_Approver;//审批人Label
@property (nonatomic,strong)UIAlertView *alt_deleteDetilsAler;//删除明细警告框
@property (nonatomic,strong)UIAlertView *alt_deleteImagesAler;//删除图片警告框
@property (nonatomic,strong)MyProcurementModel *ApprovelPeoModel;

@property (nonatomic, strong)buildCellInfo *firstinfo;//代理人
@property(nonatomic,strong)NSString *firstHanderId;//第一审批人Id
@property(nonatomic,strong)NSString *firstHanderName;//第一审批人姓名
@property(nonatomic,strong)NSString *firstHanderHeadView;//第一审批人头像
@property(nonatomic,strong)NSString *firstHandlerGender;//第一审批人性别
@property(nonatomic,strong)UIView *view_Demand;//需求视图
@property(nonatomic,strong)UITableView *tbv_Demand;//需求视图表单

@property(nonatomic,strong)NSString *requestorDate;//请求时间

@property(nonatomic,strong)NSString *ProjectPlaceHolder;

@property (nonatomic, strong) UIView *view_travelRoute;//行程安排
@property (nonatomic, strong) NSString *str_travelRoute;//是否显示行程安排
@property (nonatomic, strong) UITableView *tbv_travelRoute;//行程安排表单
@property (nonatomic, strong) NSMutableArray *arr_travelRoute;//行程安排数组
@property (nonatomic, assign) BOOL bool_isControlTripDate;//行程日期在出差期间 0不控制1控制



@property (nonatomic, assign) BOOL bool_showEstimated;//预估总金额是否显示
@property (nonatomic, strong) UIView *view_EstimatedHead;//预估总金额标题
@property (nonatomic, strong) UIView *view_TicketFee;
@property (nonatomic, strong) UIView *view_TrafficFee;
@property (nonatomic, strong) UIView *view_HotelFee;
@property (nonatomic, strong) UIView *view_MealFee;
@property (nonatomic, strong) UIView *view_AllowanceFee;
@property (nonatomic, strong) UIView *view_EntertainmentFee;
@property (nonatomic, strong) UIView *view_OtherFee;
@property (nonatomic, strong) UIView *view_EstimatedAmount;//预估总金额
@property (nonatomic, strong) GkTextField *txf_TicketFee;//票务费
@property (nonatomic, strong) GkTextField *txf_TrafficFee;//交通费
@property (nonatomic, strong) GkTextField *txf_HotelFee;//住宿费
@property (nonatomic, strong) GkTextField *txf_MealFee;//出差餐费
@property (nonatomic, strong) GkTextField *txf_AllowanceFee;//出差餐费
@property (nonatomic, strong) GkTextField *txf_EntertainmentFee;//业务招待费
@property (nonatomic, strong) GkTextField *txf_OtherFee;//其他费用
@property (nonatomic, strong) GkTextField *txf_EstimatedAmount;//预计费用合计

@property (nonatomic, strong) NSArray *arr_routeFormFields;//添加行程显示数组
@property (nonatomic, strong) NSArray *arr_Business;

/**
 *  费用类别视图
 */
@property (nonatomic, strong) UIView *View_Cate;
@property (nonatomic, strong) UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property (nonatomic, strong) UIImageView * Imv_category;
/**
 *  费用类别选择视图
 */
@property (nonatomic, strong) UIView *CategoryView;
@property (nonatomic, strong) UICollectionView *CategoryCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *CategoryLayOut;
@property (nonatomic, strong) CategoryCollectCell *cell;
/**
 费用类别视图是否打开
 */
@property (nonatomic, assign) BOOL bool_isOpenCate;
/**
 费用类别相关参数
 */
@property(nonatomic,strong)NSDictionary * dict_CategoryParameter;


/**
 费用类别数组
 */
@property(nonatomic,strong)NSMutableArray * arr_CategoryArr;
/**
 费用类别相关数据
 */
@property(nonatomic,copy)NSString *str_ExpenseCode;
@property(nonatomic,copy)NSString *str_ExpenseType;
@property(nonatomic,copy)NSString *str_ExpenseIcon;
@property(nonatomic,copy)NSString *str_ExpenseCatCode;
@property(nonatomic,copy)NSString *str_ExpenseCat;


//超预算显示数组
@property (nonatomic, strong) NSMutableArray *arr_table;
/**
 *  成本中心超预算提示
 */
@property(nonatomic,strong)UITableView *View_table;

/**
 *  1保存 2提交或者退回提交 3直送
 */
@property(nonatomic,assign)NSInteger int_SubmitSaveType;

@property (nonatomic, strong) NSMutableArray *arr_BudgetInfo;


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
 经费来源视图
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

#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@implementation TravelRequestsViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.FormData = [[FormBaseModel alloc]initBaseWithStatus:1];
        self.comeStatus = self.FormData.int_comeStatus;
    }
    return self;
}
-(NSMutableArray *)arr_IsUseCar{
    if (_arr_IsUseCar==nil) {
        _arr_IsUseCar=[NSMutableArray array];
        NSArray *type=@[Custing(@"是", nil),Custing(@"否", nil)];
        NSArray *code=@[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_IsUseCar addObject:model];
        }
    }
    return _arr_IsUseCar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.pushTaskId) {
        _taskId = self.pushTaskId;
        _userId = self.pushUserId;
        _procId = self.pushProcId;
        _comeStatus = [self.pushComeStatus integerValue];
        if (!self.backIndex&&self.pushBackIndex) {
            self.backIndex=self.pushBackIndex;
        }
    }
    if (self.pushFlowGuid) {
        self.FormData.str_flowGuid = self.pushFlowGuid;
    }
    self.FormData.str_flowCode=@"F0001";
    [self setTitle:nil backButton:YES];
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    if (![NSString isEqualToNull:_taskId]) {
        _taskId = @"0";
    }
    if (![NSString isEqualToNull:_userId]) {
        _userId = @"0";
    }
    if (![NSString isEqualToNull:_procId]) {
        _procId = @"0";
    }
    //空数组初始化
    _Arr_Demand = [[NSMutableArray alloc]init];
    _Arr_homeArray = [[NSMutableArray alloc]init];
    _Arr_trainArray = [[NSMutableArray alloc]init];
    _Arr_planeTicketArray = [[NSMutableArray alloc]init];
    _Arr_Origin = [[NSMutableArray alloc]init];
    _Arr_ToCity = [[NSMutableArray alloc]init];
    _isShowmsdic = [[NSMutableArray array]init];
    _isRequiredmsdic = [[NSMutableDictionary alloc]init];
    _isCtrlTypdic=[[NSMutableDictionary alloc]init];
    _reservedDic = [[NSMutableDictionary alloc]init];
    _arr_travelRoute = [[NSMutableArray array]init];
    _arr_routeFormFields = [NSArray array];
    _arr_Business = [NSArray array];
    _str_ExchangeRate = @"";
//    _str_startDate = @"";
//    _str_endDate = @"";
    _str_OriginCode = @"";
    _str_ToCityCode = @"";
    _ProjectPlaceHolder = @"";
    _tocitytip = @"";
    _int_traveltimeparams = 0;
    _muarr_CurrencyCode = [NSMutableArray array];
    _str_Currency = @"";
    _str_directType = @"0";
    _firstHanderHeadView = @"";
    _firstHanderId = @"";
    _str_isRelateTravelForm = @"0";
    _model_rs = [[ReserverdMainModel alloc]init];
    _arr_Attachments_Image = [NSMutableArray array];
    _arr_Attachments_Totle = [NSMutableArray array];
    
    
    _model_TravelCat = [[WorkFormFieldsModel alloc]initialize];
    _model_Attachments = [[WorkFormFieldsModel alloc]initialize];
    _model_ContractHotel = [[WorkFormFieldsModel alloc]initialize];
    _model_Supplier = [[WorkFormFieldsModel alloc]initialize];
    _model_Drive = [[WorkFormFieldsModel alloc]initialize];
    _model_RelevantDept = [[WorkFormFieldsModel alloc]initialize];
    _model_FinancialSource = [[WorkFormFieldsModel alloc]initialize];
    _arr_CategoryArr=[NSMutableArray array];
    self.str_ExpenseCode=@"";
    self.str_ExpenseType=@"";
    self.str_ExpenseIcon=@"";
    self.str_ExpenseCatCode=@"";
    self.str_ExpenseCat=@"";
    self.str_IsUseCar=@"0";
    self.arr_table = [NSMutableArray array];
    
    [self requestTravelApprovalList];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
      
}

#pragma mark - 方法

#pragma mark 视图创建
//创建滚动视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_rootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@-50);
    }];
    
    _contentView =[[BottomView alloc]init];
    _contentView.userInteractionEnabled=YES;
    _contentView.backgroundColor=Color_White_Same_20;
    [_scr_rootScrollView addSubview:_contentView];
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scr_rootScrollView);
        make.width.equalTo(self.scr_rootScrollView);
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
    
    if (_comeStatus==1||_comeStatus==2) {
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"保存", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf saveProcurementInfo];
            }else{
                [weakSelf submitProcurementInfo];
            }
        };
    }else if (_comeStatus==3&&![_str_directType isEqualToString:@"0"]){
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"直送", nil),Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf btn_Direct];
            }else{
                [weakSelf backProcurementSubmit];
            }
        };
    }else{
        [self.dockView updateNewFormViewWithTitleArray:@[Custing(@"提交", nil)]];
        __weak typeof(self) weakSelf = self;
        self.dockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                [weakSelf backProcurementSubmit];
            }
        };
    }
    
    _View_table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 200) style:UITableViewStylePlain];
    _View_table.delegate = self;
    _View_table.dataSource = self;
    _View_table.separatorStyle = UITableViewCellSeparatorStyleNone;

}

// 创建主视图
-(void)createMainView{
    
    _ReimPolicyUpView=[[UIView alloc]init];
    _ReimPolicyUpView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyUpView];
    [_ReimPolicyUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.left.right.equalTo(self.contentView);
    }];

    //出差事由
    _view_TravelReason=[[UIView alloc]init];
    _view_TravelReason.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_TravelReason];
    [_view_TravelReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ReimPolicyUpView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _SubmitPersonalView=[[SubmitPersonalView alloc]init];
    [_contentView addSubview:_SubmitPersonalView];
    [_SubmitPersonalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TravelReason.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //出差类型
    _view_BusinessType=[[UIView alloc]init];
    _view_BusinessType.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_BusinessType];
    [_view_BusinessType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SubmitPersonalView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_TravelCat.view_View = [[UIView alloc]init];
    _model_TravelCat.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_model_TravelCat.view_View];
    [_model_TravelCat.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_BusinessType.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_RelevantDept.view_View = [[UIView alloc]init];
    _model_RelevantDept.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_model_RelevantDept.view_View];
    [_model_RelevantDept.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_TravelCat.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_FinancialSource.view_View = [[UIView alloc]init];
    _model_FinancialSource.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_model_FinancialSource.view_View];
    [_model_FinancialSource.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_RelevantDept.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //出差时间
    _view_Date=[[UIView alloc]init];
    _view_Date.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_Date];
    [_view_Date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_FinancialSource.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    _view_ToDate = [[UIView alloc]init];
    _view_ToDate.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_ToDate];
    [_view_ToDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Date.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //出发地
    _view_Origin=[[UIView alloc]init];
    _view_Origin.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_Origin];
    [_view_Origin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ToDate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //目的地
    _view_ToCity=[[UIView alloc]init];
    _view_ToCity.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_ToCity];
    [_view_ToCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Origin.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //出差人员
    _view_BusinessPersonnel=[[UIView alloc]init];
    _view_BusinessPersonnel.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_BusinessPersonnel];
    [_view_BusinessPersonnel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ToCity.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //是否用车
    _View_IsUseCar=[[UIView alloc]init];
    _View_IsUseCar.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _View_IsUseCar];
    [_View_IsUseCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_BusinessPersonnel.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_Cate = [[UIView alloc]init];
    _View_Cate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_Cate];
    [_View_Cate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_IsUseCar.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryView = [[UIView alloc]init];
    _CategoryView.backgroundColor = Color_White_Same_20;
    [self.contentView addSubview:_CategoryView];
    [_CategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Cate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _CategoryLayOut.minimumInteritemSpacing = 1;
    _CategoryLayOut.minimumLineSpacing = 1;
    _CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_CategoryLayOut];
    _CategoryCollectView.delegate = self;
    _CategoryCollectView.dataSource = self;
    _CategoryCollectView.backgroundColor = Color_White_Same_20;
    _CategoryCollectView.scrollEnabled = NO;
    [_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [_CategoryView addSubview:_CategoryCollectView];
    [_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryView.top);
        make.left.right.equalTo(self.contentView);
    }];
    
    //预支金额
    _view_AdvanceAmount=[[UIView alloc]init];
    _view_AdvanceAmount.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_AdvanceAmount];
    [_view_AdvanceAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.CategoryCollectView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //币种视图
    _view_CurrencyCode = [[UIView alloc]init];
    _view_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_CurrencyCode];
    [_view_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_AdvanceAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //汇率视图
    _view_ExchangeRate = [[UIView alloc]init];
    _view_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_ExchangeRate];
    [_view_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_CurrencyCode.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //本位币视图
    _view_LocalCyAmount = [[UIView alloc]init];
    _view_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_LocalCyAmount];
    [_view_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExchangeRate.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //还款日期
    _view_Duration=[[UIView alloc]init];
    _view_Duration.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_Duration];
    [_view_Duration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_LocalCyAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_EstimatedHead = [[UIView alloc]init];
    _view_EstimatedHead.backgroundColor = Color_White_Same_20;
    [_contentView addSubview: _view_EstimatedHead];
    [_view_EstimatedHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Duration.bottom);
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

    _FormRelatedView = [[FormRelatedView alloc]init];
    [_contentView addSubview:_FormRelatedView];
    [_FormRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_EstimatedAmount.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _Reserved1View=[[UIView alloc]init];
    _Reserved1View.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_Reserved1View];
    [_Reserved1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FormRelatedView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //备注视图
    _RemarkView=[[UIView alloc]init];
    _RemarkView.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _RemarkView];
    [_RemarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _model_Attachments.view_View = [[UIView alloc]init];
    _model_Attachments.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [_contentView addSubview:_model_Attachments.view_View];
    [_model_Attachments.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.RemarkView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    
    //合约酒店视图
    _model_ContractHotel.view_View = [[UIView alloc]init];
    _model_ContractHotel.view_View.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _model_ContractHotel.view_View];
    [_model_ContractHotel.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Attachments.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //供应商视图
    _model_Supplier.view_View = [[UIView alloc]init];
    _model_Supplier.view_View.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _model_Supplier.view_View];
    [_model_Supplier.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_ContractHotel.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //自驾车视图
    _model_Drive.view_View = [[UIView alloc]init];
    _model_Drive.view_View.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _model_Drive.view_View];
    [_model_Drive.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Supplier.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _NoteView=[[UIView alloc]init];
    _NoteView.backgroundColor=Color_form_TextFieldBackgroundColor;
    [_contentView addSubview:_NoteView];
    [_NoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Drive.view_View.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //审批人
    _view_ApproveView=[[UIView alloc]init];
    _view_ApproveView.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_ApproveView];
    [_view_ApproveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NoteView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _View_CcToPeople=[[UIView alloc]init];
    _View_CcToPeople.backgroundColor=Color_WhiteWeak_Same_20;
    [self.contentView addSubview:_View_CcToPeople];
    [_View_CcToPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ApproveView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_travelPeople = [[FormSubChildView alloc]initWithType:1 withStatus:1];
    [_contentView addSubview:_view_travelPeople];
    [_view_travelPeople updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_CcToPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_travelInfo = [[FormSubChildView alloc]initWithType:2 withStatus:1];
    [_contentView addSubview:_view_travelInfo];
    [_view_travelInfo updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelPeople.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _view_feeBudget = [[FormSubChildView alloc]initWithType:3 withStatus:1];
    [_contentView addSubview:_view_feeBudget];
    [_view_feeBudget updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelInfo.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //行程安排
    _view_travelRoute = [[UIView alloc]init];
    _view_travelRoute.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview: _view_travelRoute];
    [_view_travelRoute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_feeBudget.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //需求视图视图
    _view_Demand=[[UIView alloc]init];
    _view_Demand.backgroundColor=Color_WhiteWeak_Same_20;
    [_contentView addSubview:_view_Demand];
    [_view_Demand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_travelRoute.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    //用车需求单
    _TravelCarDetailView = [[TravelCarDetailView alloc]init];
    [self.contentView addSubview:_TravelCarDetailView];
    [_TravelCarDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Demand.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
    _ReimPolicyDownView=[[UIView alloc]init];
    _ReimPolicyDownView.backgroundColor=Color_White_Same_20;
    [self.contentView addSubview:_ReimPolicyDownView];
    [_ReimPolicyDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TravelCarDetailView.bottom);
        make.left.right.equalTo(self.contentView);
    }];
    
}

#pragma mark 视图更新
-(void)updateMainView{
    
    [_SubmitPersonalView initSubmitPersonalViewWithDate:_Arr_mainFld WithRequireDict:[NSMutableDictionary dictionary] WithUnShowArray:[NSMutableArray array] WithSumbitBaseModel:self.FormData Withcontroller:self];

    [_FormRelatedView initFormRelatedViewWithDate:_Arr_mainFld WithRequireDict:[NSMutableDictionary dictionary] WithUnShowArray:[NSMutableArray array] WithBaseModel:self.FormData Withcontroller:self];

    for (MyProcurementModel *model in _Arr_mainFld) {
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Reason"]) {
                [self updateReasonViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TravelType"]) {
                [self updateTravelTypeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"TravelCat"]) {
                [self updateTravelCatViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"RelevantDept"]) {
                [self updateRelevantDeptViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FinancialSource"]) {
                [self updateFinancialSourceViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FromDate"]) {
                [self updateFromDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FromCityCode"]) {
                [self updateFromCityCodeTableView:model];
            }else if ([model.fieldName isEqualToString:@"ToCityCode"]) {
                [self updateToCityCodeTableView:model];
            }else if ([model.fieldName isEqualToString:@"FellowOfficers"]) {
                [self updateFellowOfficersTableView:model];
            }else if ([model.fieldName isEqualToString:@"IsUseCar"]) {
                [self updateIsUseCarView:model];
            }else if ([model.fieldName isEqualToString:@"ExpenseCode"]){
                [self updateExpenseTypeViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
                [self updateAdvanceAmountTableView:model];
            }else if ([model.fieldName isEqualToString:@"CurrencyCode"]) {
                [self update_CurrencyCodeView:model];
            }else if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
                [self update_ExchangeRateView:model];
            }else if ([model.fieldName isEqualToString:@"AdvanceAmount"]) {
                [self update_LocalCyAmountView:model];
            }else if ([model.fieldName isEqualToString:@"RepayDate"]) {
                [self updateRepaymentDateViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Remark"]) {
                [self updateRemarkViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"IsContractsHotel"]) {
                [self updateIsContractsHotelViewWithModel:model];
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
            }else if ([model.fieldName isEqualToString:@"Attachments"]) {
                [self updateAttachmentsViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]){
                [self updateReserved1ViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"ApprovalMode"]){
                [self updateApproveViewWithModel:_ApprovelPeoModel];
            }else if ([model.fieldName isEqualToString:@"CcUsersName"]){
                [self updateCcPeopleViewWithModel:model];
            }else if ([model.fieldName isEqualToString:@"FlightPlan"]){
                [_Arr_Demand addObject:model];
            }else if ([model.fieldName isEqualToString:@"RoomPlan"]){
                [_Arr_Demand addObject:model];
            }else if ([model.fieldName isEqualToString:@"TrainPlan"]){
                [_Arr_Demand addObject:model];
            }
        }
    }
    if ([_str_travelRoute isEqualToString:@"1"]) {
        [self updateTravelRouteView];
    }
    if (_noteDateArray.count>=2&&_comeStatus==3) {
        [self updateNotesTableView];
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
    //MARK:用车需求单
    if (self.bool_carPlan) {
        [self updateTravelCarDetail];
    }
    
    for (MyProcurementModel *model in _Arr_mainFld) {
        //数据解析
        //到达时间
        if ([model.fieldName isEqualToString:@"ToDate"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                
                _txf_EndDay.text = model.fieldValue;
            }else{
                _txf_EndDay.text = [NSString stringWithDate:[NSDate date]];
            }
        }
        //出发地
        if ([model.fieldName isEqualToString:@"FromCity"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_Origin.text = model.fieldValue;
            }
        }
        //目的地
        if ([model.fieldName isEqualToString:@"ToCity"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_ToCity.text = model.fieldValue;
            }
        }
        //出差人员ID
        if ([model.fieldName isEqualToString:@"FellowOfficersId"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _str_BusinessPersonnel = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
        }
        //出差人员部门id
        if ([model.fieldName isEqualToString:@"ShareDeptIds"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _str_BusinessPersonnelDeptId = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
        }
        //出差申请类型ID
        if ([model.fieldName isEqualToString:@"TravelTypeId"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _str_BusinessType_id = model.fieldValue;
            }
        }
        //归口部门Id
        if ([model.fieldName isEqualToString:@"RelevantDeptId"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _model_RelevantDept.Id = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
        }
        //经费来源
        if ([model.fieldName isEqualToString:@"FinancialSourceId"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _model_FinancialSource.Id = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
        }
        
        if ([model.fieldName isEqualToString:@"Currency"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_CurrencyCode.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"FirstHandlerUserName"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_Approver.text=model.fieldValue;
                _firstHanderName=model.fieldValue;
            }
        }
        //请提供不住合约酒店的原因
        if ([model.fieldName isEqualToString:@"NotContractsReason"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_ContractHotel.text = model.fieldValue;
            }
            else
            {
                _txv_ContractHotel.text = [NSString stringWithFormat:@"%@%@",Custing(model.tips, nil),[model.isRequired integerValue]==1?Custing(@"(必填)",nil):@""];
                _txv_ContractHotel.textColor = [UIColor lightGrayColor];
                _str_ContractHotel_tips = _txv_ContractHotel.text;
            }
        }
        //对供应商的评价
        if ([model.fieldName isEqualToString:@"SupplierEvaluation"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_Supplier.text = model.fieldValue;
            }
            else
            {
                _txv_Supplier.text = [NSString stringWithFormat:@"%@%@",Custing(model.tips, nil),[model.isRequired integerValue]==1?Custing(@"(必填)",nil):@""];;
                _txv_Supplier.textColor = [UIColor lightGrayColor];
                _str_Supplier_tips = _txv_Supplier.text;
            }
        }
        //请提供需要自驾车的理由
        if ([model.fieldName isEqualToString:@"SelfDriveReason"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txv_Drive.text = model.fieldValue;
            }else{
                _txv_Drive.text = [NSString stringWithFormat:@"%@%@",Custing(model.tips, nil),[model.isRequired integerValue]==1?Custing(@"(必填)",nil):@""];;
                _txv_Drive.textColor = [UIColor lightGrayColor];
                _str_Drive_tips = _txv_Drive.text;
            }
        }
        //预估金额
        if ([model.fieldName isEqualToString:@"TicketFee"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_TicketFee.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"TrafficFee"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_TrafficFee.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"HotelFee"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_HotelFee.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"MealFee"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_MealFee.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"TravelAllowance"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_AllowanceFee.text = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"OtherFee"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_OtherFee.text = model.fieldValue;
            }
        }
    }
    
    if (_Arr_Demand.count>0) {
        [self updateDemandViewWithModel];
    }
    if (self.dict_ReimPolicyDict) {
        [self updateReimPolicyView];
    }
    [self updateContentView];
    [YXSpritesLoadingView dismiss];
}

//更新出差事由
-(void)updateReasonViewWithModel:(MyProcurementModel *)model{
    _txf_TravelReason=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_TravelReason WithContent:_txf_TravelReason WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_TravelReason addSubview:view];
}
//更新出差类型
-(void)updateTravelTypeViewWithModel:(MyProcurementModel *)model{
    _Txf_BusinessType = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_BusinessType WithContent:_Txf_BusinessType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 100;
        [weakSelf btn_Click:btn];
    }];
    [_view_BusinessType addSubview:view];
}
//MARK:更新出差类别
-(void)updateTravelCatViewWithModel:(MyProcurementModel *)model{
    _model_TravelCat.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_model_TravelCat.view_View WithContent:_model_TravelCat.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.model_TravelCat.Id;
        vc.ChooseCategoryName = weakSelf.model_TravelCat.Value;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_TravelCat.txf_TexfField.text = model.name;
            weakSelf.model_TravelCat.Value = model.name;
            weakSelf.model_TravelCat.Id = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_model_TravelCat.view_View addSubview:view];
}

//MARK:更新归口部门
-(void)updateRelevantDeptViewWithModel:(MyProcurementModel *)model{
    _model_RelevantDept.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_RelevantDept.view_View WithContent:_model_RelevantDept.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId=weakSelf.model_RelevantDept.Id;
        vc.ChooseModel=model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_RelevantDept.txf_TexfField.text=model.name;
            weakSelf.model_RelevantDept.Id=model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_model_RelevantDept.view_View addSubview:view];
}
//MARK:更新经费来源
-(void)updateFinancialSourceViewWithModel:(MyProcurementModel *)model{
    _model_FinancialSource.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_FinancialSource.view_View WithContent:_model_FinancialSource.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.model_FinancialSource.Id;
        vc.ChooseModel=model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_FinancialSource.txf_TexfField.text = model.name;
            weakSelf.model_FinancialSource.Id = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_model_FinancialSource.view_View addSubview:view];
}



//更新出差时间
-(void)updateFromDateViewWithModel:(MyProcurementModel *)model{
    if ([model.ctrlTyp isEqualToString:@"travelday"]) {
        _int_traveltimeparams = 1;
    }else{
        _int_traveltimeparams = 0;
    }
    [_view_Date updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    [_view_Date addSubview:[self createLineView]];
    
    NSDate *date = [NSDate date];
    _txf_StartDay = [[UITextField alloc]init];
    model.Description = Custing(@"出发时间",nil);
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Date WithContent:_txf_StartDay WithFormType:_int_traveltimeparams==1?formViewSelectDate:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_Date addSubview:view];
    
    _txf_EndDay = [[UITextField alloc]init];
    model.Description = Custing(@"返回时间",nil);
    SubmitFormView *view_end = [[SubmitFormView alloc]initBaseView:_view_ToDate WithContent:_txf_EndDay WithFormType:_int_traveltimeparams==1?formViewSelectDate:formViewSelectDateTime WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_ToDate addSubview:view_end];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_StartDay.text = model.fieldValue;
    }else{
        _txf_StartDay.text = _int_traveltimeparams==1?[NSString stringWithDate:date]:[NSString stringFromDateByHHmm:date];
        _txf_EndDay.text = _int_traveltimeparams==1?[NSString stringWithDate:date]:[NSString stringFromDateByHHmm:date];
    }
}

//更新出发地明细
-(void)updateFromCityCodeTableView:(MyProcurementModel *)model{
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_OriginCode = model.fieldValue;
        [_Arr_Origin addObject:@{@"cityCode":model.fieldValue}];
    }
    
    _txf_Origin = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Origin WithContent:_txf_Origin WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 104;
        [weakSelf btn_Click:btn];
    }];
    [_view_Origin addSubview:view];
}

//更新目的地明细
-(void)updateToCityCodeTableView:(MyProcurementModel *)model{
    _txf_ToCity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ToCity WithContent:_txf_ToCity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 105;
        [weakSelf btn_Click:btn];
    }];
    [_view_ToCity addSubview:view];
}

//更新出差人员明细
-(void)updateFellowOfficersTableView:(MyProcurementModel *)model{
    _txf_BusinessPersonnel = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_BusinessPersonnel WithContent:_txf_BusinessPersonnel WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 106;
        [weakSelf btn_Click:btn];
    }];
    [_view_BusinessPersonnel addSubview:view];
    if (![NSString isEqualToNull:model.fieldValue]) {
        _txf_BusinessPersonnel.text = [NSString stringWithIdOnNO:self.FormData.personalData.Requestor];
        _str_BusinessPersonnel =[NSString stringWithIdOnNO:self.FormData.personalData.RequestorUserId];
        _str_BusinessPersonnelDeptId=[NSString stringWithIdOnNO:self.FormData.personalData.RequestorDeptId];
    }
}

//MARK:更新是否用车
-(void)updateIsUseCarView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        self.str_IsUseCar=@"1";
        model.fieldValue=Custing(@"是", nil);
    }else{
        self.str_IsUseCar=@"0";
        model.fieldValue=Custing(@"否", nil);
    }
    _txf_IsUseCar = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_IsUseCar WithContent:_txf_IsUseCar WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf IsUseCarClick];
    }];
    [_View_IsUseCar addSubview:view];
}

//MARK:更新费用类别
-(void)updateExpenseTypeViewWithModel:(MyProcurementModel *)model{
    _txf_Cate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Cate WithContent:_txf_Cate WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":[GPUtils getSelectResultWithArray:@[self.str_ExpenseCat,self.str_ExpenseType]]}];
    __weak typeof(self) weakSelf = self;
    [view setCateClickedBlock:^(MyProcurementModel *model,UIImageView *image){
        weakSelf.Imv_category=image;
        [weakSelf CateBtnClick:nil];
    }];
    [_View_Cate addSubview:view];
    
    if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        self.str_ExpenseCode=[NSString stringWithFormat:@"%@",model.fieldValue];
        [view setCateImg:self.str_ExpenseIcon];
    }
}
//更新预支金额
-(void)updateAdvanceAmountTableView:(MyProcurementModel *)model{
    _txf_AdvanceAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_AdvanceAmount WithContent:_txf_AdvanceAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:amount with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
    }];
    [_view_AdvanceAmount addSubview:view];
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _str_lastAmount = model.fieldValue;
    }
}

//更新币种视图
-(void)update_CurrencyCodeView:(MyProcurementModel *)model{
    _txf_CurrencyCode=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 2;
        [weakSelf btn_Click:btn];
    }];
    [_view_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text=_str_Currency;
    }else{
        _txf_CurrencyCode.text=_str_Currency;
    }
}

//更新汇率视图
-(void)update_ExchangeRateView:(MyProcurementModel *)model{
    _txf_ExchangeRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.str_ExchangeRate=exchange;
        weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_AdvanceAmount.text with:([NSString isEqualToNull:weakSelf.str_ExchangeRate]?weakSelf.str_ExchangeRate:@"1.0000")]];
    }];
    [_view_ExchangeRate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_ExchangeRate=model.fieldValue;
    }else{
        _txf_ExchangeRate.text=[NSString stringWithFormat:@"%@",_str_ExchangeRate];
    }
}

//更新本位币金额视图
-(void)update_LocalCyAmountView:(MyProcurementModel *)model{
    _txf_LocalCyAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_LocalCyAmount addSubview:view];
}

//更新还款日期
-(void)updateRepaymentDateViewWithModel:(MyProcurementModel *)model{
    _txf_DurationData = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Duration WithContent:_txf_DurationData WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        [weakSelf RepaymentDateClick:[UIButton new]];
    }];
    [_view_Duration addSubview:view];
}

//更新备注视图
-(void)updateRemarkViewWithModel:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_RemarkView WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_RemarkView addSubview:view];
}


//更新是否住合约酒店
-(void)updateIsContractsHotelViewWithModel:(MyProcurementModel *)model{
    [_model_ContractHotel.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_ContractHotel.view_View WithContent:_model_ContractHotel.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_ContractHotel.view_View addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        weakSelf.arr_HasInvoice = @[Custing(@"是",nil),Custing(@"否",nil)];
        if (weakSelf.pic_HasInvoice == nil) {
            weakSelf.pic_HasInvoice = [[UIPickerView alloc]init];
            weakSelf.pic_HasInvoice.dataSource = self;
            weakSelf.pic_HasInvoice.delegate = self;
        }
        
        if (![NSString isEqualToNull:weakSelf.model_ContractHotel.txf_TexfField.text]) {
            weakSelf.model_ContractHotel.txf_TexfField.text = Custing(@"是",nil);
        }
        
        [weakSelf.pic_HasInvoice selectRow:[weakSelf.model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是",nil)]?0:1 inComponent:0 animated:YES];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"是否住合约酒店",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:nil delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [sureDataBtn bk_whenTapped:^{
            NSInteger i = [weakSelf.pic_HasInvoice selectedRowInComponent:0];
            weakSelf.model_ContractHotel.txf_TexfField.text = weakSelf.arr_HasInvoice[i];
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
            if (i == 0) {
                [weakSelf.model_ContractHotel.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                weakSelf.txv_ContractHotel.hidden = YES;
            }else{
                [weakSelf.model_ContractHotel.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@140);
                }];
                weakSelf.txv_ContractHotel.hidden = NO;
            }
            
        }];
        [view addSubview:sureDataBtn];
        
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        [cancelDataBtn bk_whenTapped:^{
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
        }];
        
        if (!self.datelView) {
            self.datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pic_HasInvoice.frame.size.height+40) pickerView:self.pic_HasInvoice titleView:view];
            self.datelView.delegate = self;
        }
        [self.datelView showUpView:self.pic_HasInvoice];
        [self.datelView show];
    }];
    _txv_ContractHotel = [GPUtils createUITextView:CGRectMake(0, 0, ScreenRect.size.width-30,80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txv_ContractHotel.tag = 301;
    _txv_ContractHotel.center=CGPointMake(Main_Screen_Width/2, 95);
    if ([NSString isEqualToNull:model.tips]){
        if ([model.isRequired integerValue]==1) {
            _txv_ContractHotel.text=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)",nil)];
            _txv_ContractHotel.textColor = Color_White_Same_20;
        }else{
            _txv_ContractHotel.text=model.tips;
        }
    }
    _txv_ContractHotel.textAlignment = NSTextAlignmentLeft;
    _txv_ContractHotel.returnKeyType = UIReturnKeyDefault;
    [_model_ContractHotel.view_View addSubview:_txv_ContractHotel];
    
    if ([model.fieldValue isEqualToString:@"0"]) {
        _model_ContractHotel.txf_TexfField.text = Custing(@"否", nil);
    }else{
        _model_ContractHotel.txf_TexfField.text = Custing(@"是", nil);
    }
    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"否", nil)]) {
            [_model_ContractHotel.view_View updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@140);
            }];
            _txv_ContractHotel.hidden = NO;
        }else{
            _txv_ContractHotel.hidden = YES;
        }
    }else{
        _txv_ContractHotel.hidden = YES;
    }
}

//更新是否由供应商承担费用
-(void)updateIsSupplierBearViewWithModel:(MyProcurementModel *)model{
    [_model_Supplier.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Supplier.view_View WithContent:_model_Supplier.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_Supplier.view_View addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        weakSelf.arr_HasInvoice = @[Custing(@"是",nil),Custing(@"否",nil)];
        if (weakSelf.pic_HasInvoice == nil) {
            weakSelf.pic_HasInvoice = [[UIPickerView alloc]init];
            weakSelf.pic_HasInvoice.dataSource = self;
            weakSelf.pic_HasInvoice.delegate = self;
        }
        if (![NSString isEqualToNull:weakSelf.model_Supplier.txf_TexfField.text]) {
            weakSelf.model_Supplier.txf_TexfField.text = Custing(@"是",nil);
        }
        [weakSelf.pic_HasInvoice selectRow:[weakSelf.model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是",nil)]?0:1 inComponent:0 animated:YES];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"是否由供应商承担费用",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:nil delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [sureDataBtn bk_whenTapped:^{
            NSInteger i = [weakSelf.pic_HasInvoice selectedRowInComponent:0];
            weakSelf.model_Supplier.txf_TexfField.text = weakSelf.arr_HasInvoice[i];
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
            if (i == 1) {
                [weakSelf.model_Supplier.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                weakSelf.txv_Supplier.hidden = YES;
            }else{
                [weakSelf.model_Supplier.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@140);
                }];
                weakSelf.txv_Supplier.hidden = NO;
            }
            
        }];
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        [cancelDataBtn bk_whenTapped:^{
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
        }];
        if (!self.datelView) {
            self.datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pic_HasInvoice.frame.size.height+40) pickerView:self.pic_HasInvoice titleView:view];
            self.datelView.delegate = self;
        }
        [self.datelView showUpView:self.pic_HasInvoice];
        [self.datelView show];
    }];
    _txv_Supplier = [GPUtils createUITextView:CGRectMake(0, 0, ScreenRect.size.width-30,100) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txv_Supplier.center=CGPointMake(Main_Screen_Width/2, 95);
    _txv_Supplier.tag = 302;
    if ([NSString isEqualToNull:model.tips]){
        if ([model.isRequired integerValue]==1) {
            _txv_Supplier.text=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)",nil)];
        }else{
            _txv_Supplier.text=model.tips;
        }
    }
    
    _txv_Supplier.textAlignment = NSTextAlignmentLeft;
    _txv_Supplier.returnKeyType = UIReturnKeyDefault;
    [_model_Supplier.view_View addSubview:_txv_Supplier];
    if ([model.fieldValue isEqualToString:@"1"]) {
        _model_Supplier.txf_TexfField.text = Custing(@"是", nil);
    }else{
        _model_Supplier.txf_TexfField.text = Custing(@"否", nil);
    }
    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([model.fieldValue isEqualToString:@"1"]) {
            [_model_Supplier.view_View updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@140);
            }];
            _txv_Supplier.hidden = NO;
        }else{
            _txv_Supplier.hidden = YES;
        }
    }else{
        _txv_Supplier.hidden = YES;
    }
}

//更新是否需要自驾车
-(void)updateIsSelfDriveViewWithModel:(MyProcurementModel *)model{
    [_model_Drive.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
    }];
    
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_Drive.view_View WithContent:_model_Drive.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_model_Drive.view_View addSubview:view];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        weakSelf.arr_HasInvoice = @[Custing(@"是",nil),Custing(@"否",nil)];
        if (weakSelf.pic_HasInvoice == nil) {
            weakSelf.pic_HasInvoice = [[UIPickerView alloc]init];
            weakSelf.pic_HasInvoice.dataSource = self;
            weakSelf.pic_HasInvoice.delegate = self;
        }
        if (![NSString isEqualToNull:weakSelf.model_Drive.txf_TexfField.text]) {
            weakSelf.model_Drive.txf_TexfField.text = Custing(@"是",nil);
        }
        [weakSelf.pic_HasInvoice selectRow:[weakSelf.model_Drive.txf_TexfField.text isEqualToString:Custing(@"是",nil)]?0:1 inComponent:0 animated:YES];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"是否需要自驾车",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:nil delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [sureDataBtn bk_whenTapped:^{
            NSInteger i = [weakSelf.pic_HasInvoice selectedRowInComponent:0];
            weakSelf.model_Drive.txf_TexfField.text = weakSelf.arr_HasInvoice[i];
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
            if (i == 1) {
                [weakSelf.model_Drive.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                weakSelf.txv_Drive.hidden = YES;
            }else{
                [weakSelf.model_Drive.view_View updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@140);
                }];
                weakSelf.txv_Drive.hidden = NO;
            }
            
        }];
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        [view addSubview:cancelDataBtn];
        [cancelDataBtn bk_whenTapped:^{
            [weakSelf.datelView remove];
            weakSelf.pic_HasInvoice = nil;
            weakSelf.datelView = nil;
        }];
        if (!self.datelView) {
            self.datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, self.pic_HasInvoice.frame.size.height+40) pickerView:self.pic_HasInvoice titleView:view];
            self.datelView.delegate = self;
        }
        [self.datelView showUpView:self.pic_HasInvoice];
        [self.datelView show];
    }];
    _txv_Drive = [GPUtils createUITextView:CGRectMake(0, 0, ScreenRect.size.width-30,100) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
    _txv_Drive.center=CGPointMake(Main_Screen_Width/2, 95);
    _txv_Drive.tag = 303;
    if ([NSString isEqualToNull:model.tips]){
        if ([model.isRequired integerValue]==1) {
            _txv_Drive.text=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必填)",nil)];
        }else{
            _txv_Drive.text=model.tips;
        }
    }
    
    _txv_Drive.textAlignment = NSTextAlignmentLeft;
    _txv_Drive.returnKeyType = UIReturnKeyDefault;
    [_model_Drive.view_View addSubview:_txv_Drive];
    if ([model.fieldValue isEqualToString:@"1"]) {
        _model_Drive.txf_TexfField.text = Custing(@"是", nil);
    }else{
        _model_Drive.txf_TexfField.text = Custing(@"否", nil);
    }
    if ([NSString isEqualToNull:model.fieldValue]) {
        if ([model.fieldValue isEqualToString:@"1"]) {
            [_model_Drive.view_View updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@140);
            }];
            _txv_Drive.hidden = NO;
        }else{
            _txv_Drive.hidden = YES;
        }
    }else{
        _txv_Drive.hidden = YES;
    }
}
//MARK:更新票务费
-(void)updateTicketFeeViewWithModel:(MyProcurementModel *)model{
    _txf_TicketFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_TicketFee WithContent:_txf_TicketFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_TicketFee addSubview:view];
    
    [_view_TicketFee addSubview:[self createLineViewOfHeight:49.5]];
}
//MARK:更新交通费
-(void)updateTrafficFeeViewWithModel:(MyProcurementModel *)model{
    _txf_TrafficFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_TrafficFee WithContent:_txf_TrafficFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_TrafficFee addSubview:view];
    [_view_TrafficFee addSubview:[self createLineViewOfHeight:49.5]];
}
//MARK:更新住宿费
-(void)updateHotelFeeViewWithModel:(MyProcurementModel *)model{
    _txf_HotelFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_HotelFee WithContent:_txf_HotelFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_HotelFee addSubview:view];
    [_view_HotelFee addSubview:[self createLineViewOfHeight:49.5]];

}
//MARK:更新出差餐费
-(void)updateMealFeeViewWithModel:(MyProcurementModel *)model{
    _txf_MealFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_MealFee WithContent:_txf_MealFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_MealFee addSubview:view];
    [_view_MealFee addSubview:[self createLineViewOfHeight:49.5]];

}
//MARK:更新出差补贴
-(void)updateTravelAllowanceViewWithModel:(MyProcurementModel *)model{
    _txf_AllowanceFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_AllowanceFee WithContent:_txf_AllowanceFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_AllowanceFee addSubview:view];
    [_view_AllowanceFee addSubview:[self createLineViewOfHeight:49.5]];

}
//MARK:更新业务招待
-(void)updateEntertainmentFeeViewWithModel:(MyProcurementModel *)model{
    _txf_EntertainmentFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_EntertainmentFee WithContent:_txf_EntertainmentFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_EntertainmentFee addSubview:view];
    [_view_EntertainmentFee addSubview:[self createLineViewOfHeight:49.5]];

}
//MARK:更新其他费用
-(void)updateOtherFeeViewWithModel:(MyProcurementModel *)model{
    _txf_OtherFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_OtherFee WithContent:_txf_OtherFee WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount){
        [weakSelf getAllFeeTotolAmount];
    }];
    [_view_OtherFee addSubview:view];
    [_view_OtherFee addSubview:[self createLineViewOfHeight:49.5]];
}
-(void)getAllFeeTotolAmount{
    NSString *totol = @"0";
    totol = [GPUtils decimalNumberAddWithString:self.txf_TicketFee.text with:self.txf_TrafficFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_HotelFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_MealFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_AllowanceFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_EntertainmentFee.text];
    totol = [GPUtils decimalNumberAddWithString:totol with:self.txf_OtherFee.text];
    self.txf_EstimatedAmount.text = totol;
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
    
    _txf_EstimatedAmount = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_EstimatedAmount WithContent:_txf_EstimatedAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
    _view_EstimatedAmount.userInteractionEnabled = NO;
    [_view_EstimatedAmount addSubview:view];

}

//更新附件视图
-(void)updateAttachmentsViewWithModel:(MyProcurementModel *)model{
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_model_Attachments.view_View withEditStatus:1 withModel:model];
    view.maxCount = 10;
    [_model_Attachments.view_View addSubview:view];
    [view updateWithTotalArray:_arr_Attachments_Totle WithImgArray:_arr_Attachments_Image];
}

//MARK:更新通用审批自定义字段
-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved1View addSubview:[[ReserverdMainView alloc]initArr:_Arr_mainFld isRequiredmsdic:[NSMutableDictionary dictionary] reservedDic:[NSMutableDictionary dictionary] UnShowmsArray:[NSMutableArray array] view:_Reserved1View model:_model_rs block:^(NSInteger height) {
        [weakSelf.Reserved1View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}


//更新采购审批人
-(void)updateApproveViewWithModel:(MyProcurementModel *)model{
    _txf_Approver = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ApproveView WithContent:_txf_Approver WithFormType:formViewShowAppover WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":_firstHanderHeadView,@"value2":_firstHandlerGender}];
    __weak typeof(self) weakSelf = self;
    [view setApproverClickedBlock:^(MyProcurementModel *model, UIImageView *image){
        weakSelf.img_ApproveImgView=image;
        UIButton *btn = [UIButton new];
        [weakSelf ApproveClick:btn];
    }];
    [_view_ApproveView addSubview:view];
    
    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]) {
        _txf_Approver.text=model.fieldValue;
        _firstHanderName=model.fieldValue;
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

-(void)updateTravelRouteView{
    CGFloat height = [self getTravelRouteTableHeight];
    [_view_travelRoute updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height + 60);
    }];
    UIView *headview =[[UIView alloc]init];
    [_view_travelRoute addSubview:headview];
    [headview makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view_travelRoute);
        make.height.equalTo(60);
    }];
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:headview withTitle:Custing(@"添加", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:1];
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        UIButton *btn=[UIButton new];
        btn.tag=301;
        [self btn_Click:btn];
    }];
    [headview addSubview:view];
    UILabel *lab_title = [GPUtils createLable:CGRectMake(12, 10, 200, 50) text:Custing(@"行程安排", nil) font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [headview addSubview:lab_title];
    
    _tbv_travelRoute = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, Main_Screen_Width, height) style:UITableViewStylePlain];
    _tbv_travelRoute.backgroundColor = Color_form_TextFieldBackgroundColor;
    _tbv_travelRoute.delegate = self;
    _tbv_travelRoute.dataSource = self;
    _tbv_travelRoute.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_view_travelRoute addSubview:_tbv_travelRoute];
    if (_arr_travelRoute.count>0) {
        [_tbv_travelRoute reloadData];
    }
}

//审批记录
-(void)updateNotesTableView{
    [_NoteView addSubview:[[FlowChartView alloc] init:_noteDateArray Y:0 HeightBlock:^(NSInteger height) {
        [self.NoteView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.Reserved1View.bottom).offset(@10);
            make.height.equalTo(height);
        }];
    } BtnBlock:^{
        [self goTo_Webview];
    }]];
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
    __weak typeof(self) weakSelf = self;
    [_view_feeBudget setBudgetTotalAmountBlock:^(NSString *amount) {
        weakSelf.txf_EstimatedAmount.text = amount;
    }];
}

//更新需求视图
-(void)updateDemandViewWithModel{
    [_view_Demand updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.Arr_Demand.count*60+self.Arr_homeArray.count*58+self.Arr_trainArray.count*58+self.Arr_planeTicketArray.count*58);
    }];
    
    _tbv_Demand = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, _Arr_Demand.count*60+_Arr_homeArray.count*58+_Arr_trainArray.count*58+_Arr_planeTicketArray.count*58) style:UITableViewStylePlain];
    _tbv_Demand.backgroundColor = Color_form_TextFieldBackgroundColor;
    _tbv_Demand.delegate = self;
    _tbv_Demand.dataSource = self;
    _tbv_Demand.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_view_Demand addSubview:_tbv_Demand];
}

//MARK:更新用车需求单
-(void)updateTravelCarDetail{
    __weak typeof(self) weakSelf = self;
    [_TravelCarDetailView updateTravelCarDetailViewWithData:self.arr_carPlanData WithEditType:1];
    _TravelCarDetailView.TravelCarDetailBackClickedBlock = ^(NSInteger type, NSInteger index, TravelCarDetail * _Nonnull model) {
        TravelCarDetailNewController *vc = [[TravelCarDetailNewController alloc]init];
        vc.type = type;
        vc.TravelCarDetail = [model copy];
        vc.arr_show = weakSelf.arr_carPlanShow;
        vc.TravelCarAddEditBlock = ^(TravelCarDetail * _Nonnull model, NSInteger type) {
            if (type==1) {
                [weakSelf.arr_carPlanData addObject:model];
            }else{
                [weakSelf.arr_carPlanData replaceObjectAtIndex:index withObject:model];
            }
            [weakSelf.TravelCarDetailView updateTableView];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
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

#pragma mark 更新滚动视图 基本方法
-(void)updateContentView{
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ReimPolicyDownView.bottom).offset(10);
    }];
    [self.contentView layoutIfNeeded];
    
}

#pragma mark 网络请求
//第一次打开表单和保存后打开表单接口
-(void)requestTravelApprovalList{
    NSString *url=[NSString stringWithFormat:@"%@",tr_GetTravelDataV2];
    NSDictionary *parameters = @{@"TaskId": _taskId,@"ProcId":_procId?_procId:@"",@"UserId":self.userdatas.userId,@"FlowGuid":self.FormData.str_flowGuid};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

//获取审批记录
-(void)requestApproveNote{
    NSString *url=[NSString stringWithFormat:@"%@",approvalNotesRequestNotesList];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:7 IfUserCache:NO];
}
//MARK:获取费用类别
-(void)requestCate{
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    NSDictionary *parameters = @{@"Type":@"7"};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:5 IfUserCache:NO];
}

//保存提交
-(void)network:(NSInteger )type
{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:_arr_Attachments_Totle WithUrl:Overtimeuploader WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.model_Attachments.Value = data;;
            [weakSelf readyRequest:type];
        }
    }];
}

-(void)readyRequest:(NSInteger )type{
    //网络请求
    NSString *url=nil;
    NSUInteger index=[_alldic[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"Attachments"];
    [_alldic[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:_model_Attachments.Value];
    //临时解析用的数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_alldic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"ActionLinkName":type==1?@"提交":@"保存",@"flowCode":@"F0001",@"RequestorUserId": [NSString stringWithIdOnNO:self.FormData.personalData.RequestorUserId],@"FlowGuid":self.FormData.str_flowGuid,@"TaskId":_taskId ,@"FormData":stri,@"ExpIds":@"",@"ProcId":self.procId?self.procId:@""};
    
    if (type==2) {
        url =[NSString stringWithFormat:@"%@",SAVE];
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];

    }else{
    
         if(self.int_SubmitSaveType==2){
            if (self.comeStatus==3) {
                FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
                FormDatas.str_flowCode=@"F0001";
                FormDatas.str_taskId=_taskId;
                FormDatas.str_procId=_procId;
                FormDatas.dict_parametersDict=_alldic;
                self.dockView.userInteractionEnabled=YES;
                BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
                vc.FormDatas=FormDatas;
                vc.type=1;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.comeStatus==4){
                url =[NSString stringWithFormat:@"%@",APPROVAL];
                [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
            }else{
                url =[NSString stringWithFormat:@"%@",SUBMIT];
                [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
            }
        }else if (self.int_SubmitSaveType ==3){
            [self requestDirect];
        }
    }

}

//直送提交
-(void)requestDirect{
    
    FormBaseModel *FormDatas=[[FormBaseModel alloc]init];
    FormDatas.str_flowGuid=[NSString isEqualToNull:self.FormData.str_flowGuid]?[NSString stringWithFormat:@"%@",self.FormData.str_flowGuid]:@"";
    FormDatas.str_flowCode=@"F0001";
    FormDatas.str_taskId=_taskId;
    FormDatas.str_procId=_procId;
    FormDatas.dict_parametersDict=_alldic;
    
    self.dockView.userInteractionEnabled=YES;
    BackSubmitCommentController *vc=[[BackSubmitCommentController alloc]init];
    vc.FormDatas=FormDatas;
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)goTo_Webview{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"TaskId":_taskId};
    NSString *url=[NSString stringWithFormat:@"%@",GetTaskIdString];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:10 IfUserCache:NO];
}

#pragma mark 数据解析
//请求后数据解析
-(void)getBusinessApproval
{
    _str_directType = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"directType"]]]?[NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"directType"]]:@"0";
    
    //报销政策
    if ([_Dic_requset[@"result"][@"formRule"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *formRule = _Dic_requset[@"result"][@"formRule"];
        if ([formRule[@"claimPolicy"]isKindOfClass:[NSDictionary class]]) {
            self.dict_ReimPolicyDict=formRule[@"claimPolicy"];
        }
    }
    
    [self.FormData getFormSettingBaseData:[self.Dic_requset objectForKey:@"result"]];

    //行程日期在出差期间 0不控制1控制
    self.bool_isControlTripDate = [[NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"isControlTripDate"]] isEqualToString:@"1"] ? YES:NO;
    
    
    NSArray *mainarr = _Dic_requset[@"result"][@"formFields"];
    [self getChildDetialiSetting];
    //币种
    NSMutableDictionary *Currencydict=[NSMutableDictionary dictionary];
    [STOnePickModel getCurrcyWithDate:[NSMutableArray arrayWithArray:[_Dic_requset[@"result"][@"currency"] isKindOfClass:[NSNull class]]?[NSMutableArray array]:_Dic_requset[@"result"][@"currency"]] WithResult:_muarr_CurrencyCode WithCurrencyDict:Currencydict];
    _str_CurrencyCode = Currencydict[@"CurrencyCode"];
    _str_ExchangeRate = Currencydict[@"ExchangeRate"];
    _str_Currency = Currencydict[@"Currency"];
    
    _str_travelRoute = [NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"travelRoute"]];
    _str_isRelateTravelForm = [NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"isRelateTravelForm"]];
    
    self.bool_carPlan = [[NSString stringWithFormat:@"%@",_Dic_requset[@"result"][@"carPlan"]]isEqualToString:@"1"] ? YES:NO;
    if (self.bool_carPlan) {
        self.arr_carPlanShow = [NSMutableArray array];
        self.arr_carPlanData = [NSMutableArray array];
        if ([_Dic_requset[@"result"][@"carFormFields"]isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in _Dic_requset[@"result"][@"carFormFields"]) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arr_carPlanShow addObject:model];
            }
        }
    }
    _Arr_mainFld = [[NSMutableArray alloc]init];
    MyProcurementModel *fidmodel;
    MyProcurementModel *approveModel;
    for (int i = 0; i<mainarr.count; i++) {
        NSDictionary *dict=mainarr[i];
        MyProcurementModel *model = [MyProcurementModel new];
        [model setValuesForKeysWithDictionary:mainarr[i]];
        [_isCtrlTypdic setValue:model.ctrlTyp forKey:model.fieldName];
        fidmodel = model;
        if ([[NSString stringWithFormat:@"%@",fidmodel.isShow] isEqualToString:@"1"]) {
            [_isShowmsdic addObject:mainarr[i]];
        }
        [_isRequiredmsdic setValue:[mainarr[i] objectForKey:@"isRequired"] forKey:[mainarr[i] objectForKey:@"fieldName"] ];
        [_reservedDic setValue:[mainarr[i] objectForKey:@"description"] forKey:[mainarr[i] objectForKey:@"fieldName"]];
        if ([fidmodel.fieldName isEqualToString:@"RequestorDate"]) {
            _requestorDate = fidmodel.fieldValue;
        }
        if ([fidmodel.fieldName isEqualToString:@"FirstHandlerUserName"]) {
            approveModel = fidmodel;
            _ApprovelPeoModel = fidmodel;
        }
        else
        {
            [_Arr_mainFld addObject:fidmodel];
        }
        if ([fidmodel.fieldName isEqualToString:@"FirstHandlerUserId"]){
            if ([NSString isEqualToNull:model.fieldValue]) {
                _firstHanderId = model.fieldValue;
            }
        }
        if ([fidmodel.fieldName isEqualToString:@"FirstHandlerGender"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _firstHandlerGender=fidmodel.fieldValue;
            }
        }
        if ([fidmodel.fieldName isEqualToString:@"FirstHandlerPhotoGraph"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:model.fieldValue];
                _firstHanderHeadView=[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
            }
        }
        [self.FormData getMainFormShowAndData:dict WithAttachmentsMaxCount:10];
        
        if ([model.fieldName isEqualToString:@"ExpenseIcon"]) {
            self.str_ExpenseIcon=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"ExpenseCatCode"]) {
            self.str_ExpenseCatCode=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"ExpenseCat"]) {
            self.str_ExpenseCat=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"ExpenseType"]) {
            self.str_ExpenseType=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"TravelCatId"]) {
            self.model_TravelCat.Id=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"TravelCat"]) {
            self.model_TravelCat.Value=[NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"Currency"]) {
            self.str_Currency=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[dict objectForKey:@"fieldValue"]:self.str_Currency;
        }
        if ([model.fieldName isEqualToString:@"CurrencyCode"]) {
            self.str_CurrencyCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[dict objectForKey:@"fieldValue"]:self.str_CurrencyCode;
        }
        if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
            self.str_ExchangeRate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"fieldValue"]]]?[dict objectForKey:@"fieldValue"]:self.str_ExchangeRate;
        }
        
        if ([model.fieldName isEqualToString:@"EstimatedAmount"]) {
            self.bool_showEstimated = [[model.isShow stringValue]isEqualToString:@"1"];
        }
    
        if ([model.fieldName isEqualToString:@"Attachments"]) {
            if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                for (NSDictionary *dict in array) {
                    [_arr_Attachments_Totle addObject:dict];
                }
                [GPUtils updateImageDataWithTotalArray:_arr_Attachments_Totle WithImageArray:_arr_Attachments_Image WithMaxCount:5];
            }
        }
        if ([model.fieldName isEqualToString:@"CcUsersId"]) {
            self.str_CcUsersId = [NSString stringWithIdOnNO:model.fieldValue];
        }
        if ([model.fieldName isEqualToString:@"CcUsersName"]) {
            self.str_CcUsersName = [NSString stringWithIdOnNO:model.fieldValue];
        }
    }
    if (approveModel) {
        [_Arr_mainFld setObject:approveModel atIndexedSubscript:_Arr_mainFld.count];
    }
    
    [[VoiceDataManger sharedManager] getUserCustomsDateWithDict:_Dic_requset[@"result"] WithFormArray:_Arr_mainFld];
    
    //用户添加行程字段
    NSMutableArray *muarr_route = [NSMutableArray array];
    if (![_Dic_requset[@"result"][@"routeFormFields"] isKindOfClass:[NSNull class]]) {
        NSArray *array=_Dic_requset[@"result"][@"routeFormFields"];
        if (array.count!=0) {
            for (NSDictionary *dic in array) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isShow=[NSNumber numberWithInt:1];
                [muarr_route addObject:model];
            }
        }
    }
    _arr_routeFormFields = muarr_route;
    
    //用户需求单字段
    NSMutableArray *muarr_all = [NSMutableArray array];
    //机票
    NSMutableArray *muarr_flightFormFields = [NSMutableArray array];
    if (![_Dic_requset[@"result"][@"flightFormFields"] isKindOfClass:[NSNull class]]) {
        NSArray *array=_Dic_requset[@"result"][@"flightFormFields"];
        if (array.count!=0) {
            for (NSDictionary *dic in array) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isShow=[NSNumber numberWithInt:1];
                [muarr_flightFormFields addObject:model];
            }
        }
        [muarr_all addObject:muarr_flightFormFields];
    }
    //住宿
    NSMutableArray *muarr_hotelFormFields = [NSMutableArray array];
    if (![_Dic_requset[@"result"][@"hotelFormFields"] isKindOfClass:[NSNull class]]) {
        NSArray *array=_Dic_requset[@"result"][@"hotelFormFields"];
        if (array.count!=0) {
            for (NSDictionary *dic in array) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isShow=[NSNumber numberWithInt:1];
                [muarr_hotelFormFields addObject:model];
            }
        }
        [muarr_all addObject:muarr_hotelFormFields];
    }
    //火车票
    NSMutableArray *muarr_trainFormFields = [NSMutableArray array];
    if (![_Dic_requset[@"result"][@"trainFormFields"] isKindOfClass:[NSNull class]]) {
        NSArray *array=_Dic_requset[@"result"][@"trainFormFields"];
        if (array.count!=0) {
            for (NSDictionary *dic in array) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isShow=[NSNumber numberWithInt:1];
                [muarr_trainFormFields addObject:model];
            }
        }
        [muarr_all addObject:muarr_trainFormFields];
    }
    _arr_Business = muarr_all;
    
    //解析出差单据
    NSDictionary *result=[_Dic_requset objectForKey:@"result"];
    if ([result[@"formData"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *detail = result[@"formData"][@"detail"];
        
        if (self.bool_carPlan) {
            if ([result[@"formData"][@"detail"] isKindOfClass:[NSDictionary class]]&&[result[@"formData"][@"detail"][@"sa_travelcardetail"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result[@"formData"][@"detail"][@"sa_travelcardetail"]) {
                    TravelCarDetail *model=[[TravelCarDetail alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.arr_carPlanData addObject:model];
                }
            }            
        }
        
        NSArray *planearray = [detail objectForKey:@"sa_travelflightdetail"];
        NSArray *tocityarr = [NSMutableArray arrayWithArray:[detail objectForKey:@"sa_travelcitydetail"]];
        for (int i = 0; i<tocityarr.count; i++) {
            NSDictionary *dic = tocityarr[i];
            [_Arr_ToCity addObject:@{@"cityName":dic[@"toCity"],@"cityCode":dic[@"toCityCode"]}];
        }
        NSArray *homearray = [detail objectForKey:@"sa_travelhoteldetail"];
        NSArray *trainarray = [detail objectForKey:@"sa_traveltraindetail"];
        for (int i = 0 ; i<planearray.count; i++) {
            if (![planearray[i][@"departureDate"] isEqual:[NSNull null]]) {
                [_Arr_planeTicketArray addObject: [[TravelFlightDetailModel alloc]initDicToModel:planearray[i]]];
            }
        }
        for (int i = 0 ; i<homearray.count; i++) {
            if(![homearray[i][@"checkInCity"] isEqual:[NSNull null]])
            {
                [_Arr_homeArray addObject: [[TravelHotelDetailModel alloc]initDicToModel:homearray[i]]];
            }
        }
        for (int i = 0 ; i<trainarray.count; i++) {
            if (![trainarray[i][@"departureDate"] isEqual:[NSNull null]]) {
                [_Arr_trainArray addObject:[[TravelTrainDetailModel alloc]initDicToModel:trainarray[i]]];
            }
        }
        for (int i = 0 ; i<tocityarr.count; i++) {
            if (i == 0) {
                _str_ToCityCode = tocityarr[i][@"toCityCode"];
                _txf_ToCity.text = tocityarr[i][@"toCity"];
            }else{
                _str_ToCityCode = [NSString stringWithFormat:@"%@,%@",_str_ToCityCode,tocityarr[i][@"toCityCode"]];
                _txf_ToCity.text = [NSString stringWithFormat:@"%@,%@",_txf_ToCity.text,tocityarr[i][@"toCity"]];
            }
        }
        _arr_travelRoute =  [NSMutableArray arrayWithArray:[detail objectForKey:@"sa_TravelRouteDetail"]];
    }
    
}
-(void)getChildDetialiSetting{

    NSDictionary *result = _Dic_requset[@"result"];
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
    }
}

//审批记录数据
-(void)getNoteData
{
    NSDictionary *result=[_resultDict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        NSArray *array=result[@"taskProcList"];
        _noteDateArray=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            approvalNoteModel *model=[[approvalNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_noteDateArray addObject:model];
        }
    }
}

#pragma mark 数据拼接
//拼接数据
-(void)mainDataList:(NSInteger )type
{
    [self mainDataLists:type];
}

-(void)mainDataLists:(NSInteger)type{
    _alldic = [[NSMutableDictionary alloc]init];
    NSMutableArray *mainDataListarr = [[NSMutableArray alloc]init];
    NSMutableDictionary *Sa_TravelApp = [[NSMutableDictionary alloc]init];
    NSMutableArray *fieldNamesArr = [[NSMutableArray alloc]init];
    NSMutableArray *fieldValuesArr = [[NSMutableArray alloc]init];
    _filedModel = [self inModelContent];
    //第一大数组中第一大分类
    NSMutableDictionary *modeldic = [FieldNamesModel initDicByModel:_filedModel];
    NSArray *arr_key = [modeldic allKeys];
    for(int i = 0;i<modeldic.count;i++)
    {
        NSString *key = arr_key[i];
        [fieldNamesArr addObject:key];
        if ([key isEqualToString:@"ToDate"]&&![NSString isEqualToNull:[modeldic objectForKey:key]]) {
            [fieldValuesArr addObject:[NSNull null]];
        }
        else if([key isEqualToString:@"FromDate"]&&![NSString isEqualToNull:[modeldic objectForKey:key]]) {
            [fieldValuesArr addObject:[NSNull null]];
        }
        else if([key isEqualToString:@"FellowOfficers"]&&![NSString isEqualToNull:[modeldic objectForKey:key]]) {
            [fieldValuesArr addObject:[NSNull null]];
        }
        else if([key isEqualToString:@"FellowOfficersId"]&&![NSString isEqualToNull:[modeldic objectForKey:key]]) {
            [fieldValuesArr addObject:[NSNull null]];
        }
        else if ([key isEqualToString:@"AdvanceAmount"]&&[_txf_AdvanceAmount.text isEqualToString:@""])
        {
            [fieldValuesArr addObject:[NSNull null]];
        }else{
            [fieldValuesArr addObject:[modeldic objectForKey:key]];
        }
    }
    [Sa_TravelApp setObject:@"Sa_TravelApp" forKey:@"tableName"];
    [Sa_TravelApp setObject:fieldNamesArr forKey:@"fieldNames"];
    [Sa_TravelApp setObject:fieldValuesArr forKey:@"fieldValues"];
    [mainDataListarr addObject:Sa_TravelApp];
    
    [_alldic setObject:mainDataListarr forKey:@"mainDataList"];
    //第二大数组中第一大分类
    NSMutableArray *detailedDataList = [[NSMutableArray alloc]init];
    
    if ([NSString isEqualToNull:_filedModel.ToCity]) {
        NSMutableDictionary *Sa_TravelCityDetail = [[NSMutableDictionary alloc]init];
        [Sa_TravelCityDetail setObject:@"Sa_TravelCityDetail" forKey:@"tableName"];
        [Sa_TravelCityDetail setObject:@[@"tocity",@"tocitycode",@"CityType"] forKey:@"fieldNames"];
        //        NSMutableArray *fieldBigValuesCodeArr = [[NSMutableArray alloc]init];
        NSMutableArray * fieldBigValuesArr = [NSMutableArray arrayWithArray:[_filedModel.ToCity componentsSeparatedByString:@","]];
        NSMutableArray *fieldBigValuesCodeArr =[NSMutableArray arrayWithArray:[_filedModel.ToCityCode componentsSeparatedByString:@","]];
        NSMutableArray *fieldBigValueTypeArr = [NSMutableArray array];
        for (int i = 0; i<fieldBigValuesCodeArr.count; i++) {
            NSString *code = fieldBigValuesCodeArr[i];
            [fieldBigValueTypeArr addObject:code.length>3?@"1":@"2"];
        }
        if (fieldBigValuesArr.count>0&&fieldBigValuesCodeArr.count>0) {
            [Sa_TravelCityDetail setObject:@[fieldBigValuesArr,fieldBigValuesCodeArr,fieldBigValueTypeArr] forKey:@"fieldBigValues"];
            [detailedDataList addObject:Sa_TravelCityDetail];
        }
    }
    
    //第二大数组中第二大分类
    NSMutableDictionary *Sa_TravelStaffDetail = [[NSMutableDictionary alloc]init];
    [Sa_TravelStaffDetail setObject:@"Sa_TravelStaffDetail" forKey:@"tableName"];
    [Sa_TravelStaffDetail setObject:@[@"userid",@"userdspname"] forKey:@"fieldNames"];
    NSMutableArray *Sa_TravelStaffDetailfieldBigValuesid = [[NSMutableArray alloc]init];
    NSArray *arrays = [NSArray arrayWithArray:_filedModel.FellowOfficersId&& _filedModel.FellowOfficersId.length>0?[_filedModel.FellowOfficersId componentsSeparatedByString:@","]:nil];
    for (int i = 0 ; i< arrays.count; i++) {
        [Sa_TravelStaffDetailfieldBigValuesid addObject:@([arrays[i] integerValue])];
    }
    NSMutableArray *Sa_TravelStaffDetailfieldBigValues =[NSMutableArray arrayWithArray:_filedModel.FellowOfficers.length>0?[_filedModel.FellowOfficers componentsSeparatedByString:@","]:nil];
    if (Sa_TravelStaffDetailfieldBigValues.count>0&&Sa_TravelStaffDetailfieldBigValuesid.count>0) {
        [Sa_TravelStaffDetail setObject:@[Sa_TravelStaffDetailfieldBigValuesid,Sa_TravelStaffDetailfieldBigValues] forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelStaffDetail];
    }
    
    //第二大数组中第三大分类
    if (_Arr_planeTicketArray.count>0) {
        NSMutableDictionary *Sa_TravelFlightDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = @[@"departuredate",@"isInternational",@"fromcitycode",@"fromcity",@"fromcitytype",@"tocitycode",@"tocity",@"tocitytype",@"flypeople",@"remark"];
        NSMutableArray *Values = [NSMutableArray array];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (TravelFlightDetailModel *model in self.Arr_planeTicketArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelFlightDetail setObject:@"Sa_TravelFlightDetail" forKey:@"tableName"];
        [Sa_TravelFlightDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelFlightDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelFlightDetail];
    }
    
    //第二大数组中第四大分类
    if (_Arr_homeArray.count>0) {
        NSMutableDictionary *Sa_TravelHotelDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = @[@"checkindate",@"isInternational",@"checkincitycode",@"checkincity",@"citytype",@"checkoutdate",@"numberofrooms",@"remark"];
        NSMutableArray *Values = [NSMutableArray array];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (TravelHotelDetailModel *model in self.Arr_homeArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelHotelDetail setObject:@"Sa_TravelHotelDetail" forKey:@"tableName"];
        [Sa_TravelHotelDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelHotelDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelHotelDetail];
    }
    //第二大数组中第五大分类
    if(_Arr_trainArray.count>0){
        NSMutableDictionary *Sa_TravelTrainDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = @[@"departuredate",@"fromcitycode",@"fromcity",@"fromcitytype",@"tocitycode",@"tocity",@"tocitytype",@"passenger",@"remark"];
        NSMutableArray *Values = [NSMutableArray array];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (TravelTrainDetailModel *model in self.Arr_trainArray) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelTrainDetail setObject:@"Sa_TravelTrainDetail" forKey:@"tableName"];
        [Sa_TravelTrainDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelTrainDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelTrainDetail];
    }
    
    //第二大数组中第七大分类
    NSMutableDictionary *Sa_TravelClientDetail = [[NSMutableDictionary alloc]init];
    [Sa_TravelClientDetail setObject:@"Sa_TravelClientDetail" forKey:@"tableName"];
    [Sa_TravelClientDetail setObject:@[@"ClientId",@"ClientName",@"RequestorUserId"] forKey:@"fieldNames"];
    NSMutableArray *Sa_Request = [[NSMutableArray alloc]init];
    NSArray *array_Clien = [NSArray arrayWithArray:_filedModel.ClientId&& _filedModel.ClientId.length>0?[_filedModel.ClientId componentsSeparatedByString:@","]:nil];
    for (int i = 0 ; i< array_Clien.count; i++) {
        [Sa_Request addObject:[NSString stringWithIdOnNO:self.FormData.personalData.RequestorUserId]];
    }
    NSMutableArray *Sa_TravelClientDetailfieldBigValues =[NSMutableArray arrayWithArray:_filedModel.ClientName.length>0?[_filedModel.ClientName componentsSeparatedByString:@","]:nil];
    if (array_Clien.count>0&&Sa_TravelClientDetailfieldBigValues.count>0) {
        [Sa_TravelClientDetail setObject:@[array_Clien,Sa_TravelClientDetailfieldBigValues,Sa_Request] forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelClientDetail];
    }
    
    //第二大数组中第六大分类--行程安排
    if (_arr_travelRoute.count>0) {
        NSMutableDictionary *Sa_TravelRouteDetail = [[NSMutableDictionary alloc]init];
        [Sa_TravelRouteDetail setObject:@"Sa_TravelRouteDetail" forKey:@"tableName"];
        NSArray *fieldNames = @[@"TravelDate",@"TravelTime",@"FromCity",@"ToCity",@"HotelStd",@"TransName",@"TravelContent"];
        [Sa_TravelRouteDetail setObject:fieldNames forKey:@"fieldNames"];
        NSMutableArray *Values = [NSMutableArray array];
        for (NSString *key in fieldNames) {
            NSMutableString *fieldName = [NSMutableString stringWithFormat:@"%@",key];
            NSString *head = [[fieldName substringToIndex:1] lowercaseString];
            [fieldName replaceCharactersInRange:NSMakeRange(0, 1) withString:head];
            NSMutableArray  *array=[NSMutableArray array];
            for (NSDictionary *dict in self.arr_travelRoute) {
                if ([NSString isEqualToNull:[dict valueForKey:fieldName]]) {
                    [array addObject:[dict valueForKey:fieldName]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        
        [Sa_TravelRouteDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelRouteDetail];
    }
    
    
    if (self.arr_travelPeopleShowData.count > 0) {
        NSMutableDictionary *Sa_TravelUserInfoDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = [NSArray array];
        NSMutableArray *Values=[[NSMutableArray alloc]init];
        NSMutableDictionary *modelsDic=[TravelPeopleInfoModel initDicByModel:self.arr_travelPeopleShowData[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (TravelPeopleInfoModel *model in self.arr_travelPeopleShowData) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelUserInfoDetail setObject:@"Sa_TravelUserInfoDetail" forKey:@"tableName"];
        [Sa_TravelUserInfoDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelUserInfoDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelUserInfoDetail];
    }
    
    if (self.arr_travelInfoShowData.count > 0) {
        NSMutableDictionary *Sa_TravelItineraryDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = [NSArray array];
        NSMutableArray *Values=[[NSMutableArray alloc]init];
        NSMutableDictionary *modelsDic=[TravelInfoModel initDicByModel:self.arr_travelInfoShowData[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (TravelInfoModel *model in self.arr_travelInfoShowData) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
//                    if ([key isEqualToString:@"DepartureAmt"]||[key isEqualToString:@"ReturnAmt"]||[key isEqualToString:@"TotalAmount"]) {
//                        [array addObject:@"0"];
//                    }else{
                        [array addObject:(id)[NSNull null]];
//                    }
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelItineraryDetail setObject:@"Sa_TravelItineraryDetail" forKey:@"tableName"];
        [Sa_TravelItineraryDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelItineraryDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelItineraryDetail];
    }
    
    if (self.arr_feeBudgetShowData.count > 0) {
        NSMutableDictionary *Sa_TravelBudgetDetail = [[NSMutableDictionary alloc]init];
        NSArray *fieldNames = [NSArray array];
        NSMutableArray *Values=[[NSMutableArray alloc]init];
        NSMutableDictionary *modelsDic=[FeeBudgetInfoModel initDicByModel:self.arr_feeBudgetShowData[0]];
        fieldNames = [modelsDic allKeys];
        for (NSString *key in fieldNames) {
            NSMutableArray  *array=[NSMutableArray array];
            for (FeeBudgetInfoModel *model in self.arr_feeBudgetShowData) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
//                    if (![key isEqualToString:@"UserName"]&&![key isEqualToString:@"Remark"]) {
//                        [array addObject:@"0"];
//                    }else{
                        [array addObject:(id)[NSNull null]];
//                    }
                }
            }
            [Values addObject:array];
        }
        [Sa_TravelBudgetDetail setObject:@"Sa_TravelBudgetDetail" forKey:@"tableName"];
        [Sa_TravelBudgetDetail setObject:fieldNames forKey:@"fieldNames"];
        [Sa_TravelBudgetDetail setObject:Values forKey:@"fieldBigValues"];
        [detailedDataList addObject:Sa_TravelBudgetDetail];
    }
    
    //用车需求单明细
    NSMutableDictionary *Sa_TravelCarDetail = [NSMutableDictionary dictionary];
    NSArray *fieldNames1 = [NSArray array];
    NSMutableArray *Values1 = [NSMutableArray array];
    if (self.arr_carPlanData.count != 0) {
        NSMutableDictionary *modelsDic = [TravelCarDetail initDicByModel:self.arr_carPlanData[0]];
        [modelsDic removeObjectForKey:@"TaskId"];
        fieldNames1 = [modelsDic allKeys];
        for (NSString *key in fieldNames1) {
            NSMutableArray  *array = [NSMutableArray array];
            for (TravelCarDetail *model in self.arr_carPlanData) {
                if ([NSString isEqualToNull:[model valueForKey:key]]) {
                    [array addObject:[model valueForKey:key]];
                }else{
                    [array addObject:(id)[NSNull null]];
                }
            }
            [Values1 addObject:array];
        }
        [Sa_TravelCarDetail setObject:@"Sa_TravelCarDetail" forKey:@"tableName"];
        [Sa_TravelCarDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_TravelCarDetail setObject:Values1 forKey:@"fieldBigValues"];
    }else{
        [Sa_TravelCarDetail setObject:@"Sa_PaymentExpDetail" forKey:@"tableName"];
        [Sa_TravelCarDetail setObject:fieldNames1 forKey:@"fieldNames"];
        [Sa_TravelCarDetail setObject:Values1 forKey:@"fieldBigValues"];
    }
    [detailedDataList addObject:Sa_TravelCarDetail];

    [_alldic setObject:detailedDataList forKey:@"detailedDataList"];
}

//获取数据
-(FieldNamesModel *)inModelContent
{
    _filedModel = [[FieldNamesModel alloc]init];
    _filedModel.Reason = [NSString isEqualToNull:self.txf_TravelReason.text]?self.txf_TravelReason.text:@"";
    
    
    _filedModel.HRID=self.FormData.personalData.Hrid;
    _filedModel.Branch=self.FormData.personalData.Branch;
    _filedModel.BranchId=self.FormData.personalData.BranchId;
    _filedModel.CostCenterId = self.FormData.personalData.CostCenterId;
    _filedModel.CostCenter = self.FormData.personalData.CostCenter;
    _filedModel.CostCenterMgrUserId = self.FormData.personalData.CostCenterMgrUserId;
    _filedModel.CostCenterMgr = self.FormData.personalData.CostCenterMgr;
    _filedModel.IsCostCenterMgr = [[NSString stringWithFormat:@"%@",self.FormData.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.FormData.personalData.CostCenterMgrUserId]] ? @"1":@"0";
    _filedModel.RequestorBusDept=self.FormData.personalData.RequestorBusDept;
    _filedModel.RequestorBusDeptId=self.FormData.personalData.RequestorBusDeptId;
    _filedModel.UserReserved1=self.FormData.personalData.UserReserved1;
    _filedModel.UserReserved2=self.FormData.personalData.UserReserved2;
    _filedModel.UserReserved3=self.FormData.personalData.UserReserved3;
    _filedModel.UserReserved4=self.FormData.personalData.UserReserved4;
    _filedModel.UserReserved5=self.FormData.personalData.UserReserved5;
    _filedModel.UserLevelId=self.FormData.personalData.UserLevelId;
    _filedModel.UserLevel=self.FormData.personalData.UserLevel;
    _filedModel.AreaId=self.FormData.personalData.AreaId;
    _filedModel.Area=self.FormData.personalData.Area;
    _filedModel.LocationId=self.FormData.personalData.LocationId;
    _filedModel.Location=self.FormData.personalData.Location;

    
    _filedModel.ApproverId1=self.FormData.personalData.ApproverId1;
    _filedModel.ApproverId2=self.FormData.personalData.ApproverId2;
    _filedModel.ApproverId3=self.FormData.personalData.ApproverId3;
    _filedModel.ApproverId4=self.FormData.personalData.ApproverId4;
    _filedModel.ApproverId5=self.FormData.personalData.ApproverId5;
    _filedModel.UserLevelNo=self.FormData.personalData.UserLevelNo;
    
    _filedModel.OperatorUserId=self.FormData.personalData.OperatorUserId;
    _filedModel.Operator=self.FormData.personalData.Operator;
    _filedModel.OperatorDeptId=self.FormData.personalData.OperatorDeptId;
    _filedModel.OperatorDept=self.FormData.personalData.OperatorDept;

    _filedModel.RequestorDeptId=self.FormData.personalData.RequestorDeptId;
    _filedModel.RequestorDept=self.FormData.personalData.RequestorDept;
    _filedModel.jobTitleCode=self.FormData.personalData.JobTitleCode;
    _filedModel.jobTitle=self.FormData.personalData.JobTitle;
    _filedModel.JobTitleLvl=self.FormData.personalData.JobTitleLvl;

    _filedModel.RequestorUserId=self.FormData.personalData.RequestorUserId;
    _filedModel.RequestorAccount=self.FormData.personalData.RequestorAccount;
    _filedModel.Requestor=self.FormData.personalData.Requestor;
    _filedModel.RequestorDate=self.FormData.personalData.RequestorDate;
    _filedModel.CompanyId=self.FormData.personalData.CompanyId;

    _filedModel.CcUsersId=self.str_CcUsersId;
    _filedModel.CcUsersName=self.str_CcUsersName;
    
    
    _filedModel.TravelType = [NSString isEqualToNull:_Txf_BusinessType.text]?_Txf_BusinessType.text :@"";
    _filedModel.TravelTypeId = _str_BusinessType_id;
    
    _filedModel.TravelCatId = _model_TravelCat.Id;
    _filedModel.TravelCat = _model_TravelCat.Value;

    _filedModel.RelevantDeptId = _model_RelevantDept.Id;
    _filedModel.RelevantDept = _model_RelevantDept.txf_TexfField.text;
    
    _filedModel.FinancialSourceId = _model_FinancialSource.Id;
    _filedModel.FinancialSource = _model_FinancialSource.txf_TexfField.text;
    
    _filedModel.FromDate = _txf_StartDay.text;
    _filedModel.ToDate = _txf_EndDay.text;
    _filedModel.FromCity = [_txf_Origin.text isEqualToString:_str_Origin_tips]?@"":_txf_Origin.text;
    if ([_filedModel.FromCity isEqualToString:@"请选择出发地"]) {
        _filedModel.FromCity = @"";
    }
    _filedModel.FromCityCode = _str_OriginCode;
    _filedModel.FromCityType = _str_OriginCode.length>3?@"1":@"2";
    _filedModel.ToCityCode = _str_ToCityCode;
    _filedModel.ToCity = [_txf_ToCity.text isEqualToString:_tocitytip]?@"":_txf_ToCity.text;
    if ([_filedModel.ToCity isEqualToString:_tocitytip]) {
        _filedModel.ToCity = @"";
    }
    _filedModel.FellowOfficers = [_txf_BusinessPersonnel.text isEqualToString:@"请选择(必填)"]?@"":_txf_BusinessPersonnel.text;
    if ([_filedModel.FellowOfficers isEqualToString:@"请选择"]||_txf_BusinessPersonnel == nil) {
        _filedModel.FellowOfficers = @"";
    }
    _filedModel.FellowOfficersId = [NSString stringWithFormat:@"%@",_str_BusinessPersonnel];
    _filedModel.ShareDeptIds = [NSString stringWithFormat:@"%@",_str_BusinessPersonnelDeptId];

    _filedModel.LocalCyAmount =_txf_AdvanceAmount.text;
    
    _filedModel.ExchangeRate = _txf_ExchangeRate.text;

    NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_AdvanceAmount.text with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")];
    LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    _filedModel.AdvanceAmount=[NSString isEqualToNull:LocalCyAmount]?LocalCyAmount:@"0.00";

    
    if ([NSString isEqualToNull:_txf_DurationData.text]) {
        _filedModel.RepayDate = _txf_DurationData.text;
    }
    _filedModel.CurrencyCode = _str_CurrencyCode;
    _filedModel.Currency = _txf_CurrencyCode.text;
    _filedModel.Remark = _txv_Remark.text;
    _filedModel.IsContractsHotel = [_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]?1:0;
    _filedModel.NotContractsReason = ![NSString isEqualToNull:_txv_ContractHotel.text]?nil:_txv_ContractHotel.text;
    if ([_filedModel.NotContractsReason isEqualToString:_str_ContractHotel_tips]) {
        _filedModel.NotContractsReason = @"";
    }
    _filedModel.IsSupplierBear = [_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]?1:0;
    _filedModel.SupplierEvaluation = ![NSString isEqualToNull:_txv_Supplier.text]?nil:_txv_Supplier.text;
    if ([_filedModel.SupplierEvaluation isEqualToString:_str_Supplier_tips]) {
        _filedModel.SupplierEvaluation = @"";
    }
    _filedModel.IsSelfDrive = [_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]?1:0;
    _filedModel.SelfDriveReason = ![NSString isEqualToNull:_txv_Drive.text]?nil:_txv_Drive.text;
    if ([_filedModel.SelfDriveReason isEqualToString:_str_Drive_tips]) {
        _filedModel.SelfDriveReason = @"";
    }
    _filedModel.FirstHandlerUserId = [_firstHanderId integerValue];
    _filedModel.FirstHandlerUserName = _firstHanderName;


    _filedModel.SupplierId = self.FormData.personalData.SupplierId;
    _filedModel.SupplierName = self.FormData.personalData.SupplierName;
    _filedModel.Attachments = [NSString stringWithIdOnNO:_model_Attachments.Value];
    _filedModel.isexpense = @"0";
    _filedModel.Reserved1 = _model_rs.Reserverd1;
    _filedModel.Reserved2 = _model_rs.Reserverd2;
    _filedModel.Reserved3 = _model_rs.Reserverd3;
    _filedModel.Reserved4 = _model_rs.Reserverd4;
    _filedModel.Reserved5 = _model_rs.Reserverd5;
    _filedModel.Reserved6 = _model_rs.Reserverd6;
    _filedModel.Reserved7 = _model_rs.Reserverd7;
    _filedModel.Reserved8 = _model_rs.Reserverd8;
    _filedModel.Reserved9 = _model_rs.Reserverd9;
    _filedModel.Reserved10 = _model_rs.Reserverd10;
    _filedModel.IsUseCar = self.str_IsUseCar;


    _filedModel.ProjId = self.FormData.personalData.ProjId;
    _filedModel.ProjName = self.FormData.personalData.ProjName;
    _filedModel.ProjMgrUserId = self.FormData.personalData.ProjMgrUserId;
    _filedModel.ProjMgr = self.FormData.personalData.ProjMgr;
    _filedModel.IsProjMgr = [[NSString stringWithFormat:@"%@",self.FormData.personalData.RequestorUserId] isEqualToString:[NSString stringWithFormat:@"%@",self.FormData.personalData.ProjMgrUserId]] ? @"1":@"0";

    if ([NSString isEqualToNull:_txf_TicketFee.text]) {
        _filedModel.TicketFee = _txf_TicketFee.text;
    }
    if ([NSString isEqualToNull:_txf_HotelFee.text]) {
        _filedModel.HotelFee = _txf_HotelFee.text;
    }
    if ([NSString isEqualToNull:_txf_TrafficFee.text]) {
        _filedModel.TrafficFee = _txf_TrafficFee.text;
    }
    if ([NSString isEqualToNull:_txf_MealFee.text]) {
        _filedModel.MealFee = _txf_MealFee.text;
    }
    if ([NSString isEqualToNull:_txf_AllowanceFee.text]) {
        _filedModel.TravelAllowance = _txf_AllowanceFee.text;
    }
    if ([NSString isEqualToNull:_txf_EntertainmentFee.text]) {
        _filedModel.EntertainmentFee = _txf_EntertainmentFee.text;
    }
    if ([NSString isEqualToNull:_txf_OtherFee.text]) {
        _filedModel.OtherFee = _txf_OtherFee.text;
    }
    
    _filedModel.ExpenseCode=self.str_ExpenseCode;
    _filedModel.ExpenseType=self.str_ExpenseType;
    _filedModel.ExpenseIcon=self.str_ExpenseIcon;
    _filedModel.ExpenseCatCode=self.str_ExpenseCatCode;
    _filedModel.ExpenseCat=self.str_ExpenseCat;

    if ([NSString isEqualToNull:_txf_EstimatedAmount.text]) {
        _filedModel.EstimatedAmount = [_txf_EstimatedAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    _filedModel.ClientId = self.FormData.personalData.ClientId;
    _filedModel.ClientName = self.FormData.personalData.ClientName;
    return _filedModel;
}

//检查数据
-(BOOL)testModel:(FieldNamesModel *)model
{
    BOOL isreturn = YES;
    NSMutableDictionary *modeldic = [FieldNamesModel initDicByModel:model];
    for (int a = 0;a<_isShowmsdic.count;a++) {
        NSDictionary *dic = _isShowmsdic[a];
        NSString *key = [dic objectForKey:@"fieldName"];
        NSString *i = [NSString stringWithFormat:@"%@",[_isRequiredmsdic objectForKey:key]];
        NSString *str =[NSString stringWithFormat:@"%@",[modeldic objectForKey:key]];
        if ([i isEqualToString:@"1"]&&![key isEqualToString:@"TwoHandlerUserName"]&&![key isEqualToString:@"NotContractsReason"]&&![key isEqualToString:@"SupplierEvaluation"]&&![key isEqualToString:@"SelfDriveReason"]) {
            if ([key isEqualToString:@"FromDate"]) {
                NSDate *date1 = _int_traveltimeparams==1?[NSDate dateWithstring:[modeldic objectForKey:@"ToDate"]]:[NSDate DateFromString:[modeldic objectForKey:@"ToDate"]];
                NSDate *date2 = _int_traveltimeparams==1?[NSDate dateWithstring:[modeldic objectForKey:@"FromDate"]]:[NSDate DateFromString:[modeldic objectForKey:@"FromDate"]];
                if (!date2) {
                    [self showerror:@"FromDate"];
                    isreturn = NO;
                    break;
                }
                if (!date1) {
                    [self showerror:@"ToDate"];
                    isreturn = NO;
                    break;
                }
                if ([date2 timeIntervalSinceDate:date1]>0.0)
                {
                    [self showerror:@"timeover"];
                    isreturn = NO;
                    break ;
                }
            }
//            else if ([key isEqualToString:@"ToDate"]) {
//                NSDate *date1 = [NSString convertDateFromString:[modeldic objectForKey:@"ToDate"] ];
//                NSDate *date2 = [NSString convertDateFromString:[modeldic objectForKey:@"FromDate"]];
//                if (!date1) {
//                    [self showerror:@"ToDate"];
//                    isreturn = NO;
//                    break;
//                }
//                if ([date2 timeIntervalSinceDate:date1]>0.0)
//                {
//                    [self showerror:@"timeover"];
//                    isreturn = NO;
//                    break ;
//                }
//            }
            else if ([key isEqualToString:@"RequestorDeptId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.RequestorDept]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"TravelType"]) {
                if (![NSString isEqualToNull:_str_BusinessType_id]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"TravelCat"]) {
                if (![NSString isEqualToNull:self.model_TravelCat.Value]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"RelevantDept"]) {
                if (![NSString isEqualToNull:_model_RelevantDept.Id]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"FinancialSource"]) {
                if (![NSString isEqualToNull:_model_FinancialSource.Id]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"RequestorBusDeptId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.RequestorBusDeptId]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"BranchId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.BranchId]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"RequestorDeptId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.RequestorDeptId]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"ExpenseCode"]) {
                if (![NSString isEqualToNull:self.str_ExpenseCode]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"AdvanceAmount"]) {
                if (![NSString isEqualToNull:_txf_AdvanceAmount.text]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"RepayDate"]) {
                if (![NSString isEqualToNull:_txf_DurationData.text]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"ApprovalMode"]) {
                if (![NSString isEqualToNull:_txf_Approver.text]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"ProjId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.ProjId]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"ClientId"]) {
                if (![NSString isEqualToNull:self.FormData.personalData.ClientId]) {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"Reason"]) {
                if(![NSString isEqualToNull:str])
                {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
                if (str.length>250) {
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"当前输入超过最大长度250个字符，已超出%d字符，请删减后重新提交",((int)str.length-250)]];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"Remark"]) {
                if(![NSString isEqualToNull:str])
                {
                    [self showerror:key];
                    isreturn = NO;
                    break ;
                }
                if (str.length>250) {
                    //                    int b = str.length - 250 ;
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"当前输入超过最大长度250个字符，已超出%d字符，请删减后重新提交",((int)str.length-250)]];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"JobTitleCode"]){
                
            }else if ([key isEqualToString:@"IsContractsHotel"]) {
                if (![NSString isEqualToNull:_txv_ContractHotel.text]&&![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_ContractHotel.text isEqualToString:@"请输入原因(必填)"]&&![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_ContractHotel.text isEqualToString:_str_ContractHotel_tips])
                {
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsSupplierBear"]) {
                if (![NSString isEqualToNull:_txv_Supplier.text]&&[_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_Supplier.text isEqualToString:@"请输入原因(必填)"]&&[_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_Supplier.text isEqualToString:_str_Supplier_tips])
                {
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsSelfDrive"]){
                if (![NSString isEqualToNull:_txv_Drive.text]&&[_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_Drive.text isEqualToString:@"请输入原因(必填)"]&&[_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_Drive.text isEqualToString:_str_Drive_tips])
                {
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsContractsHotel"]){
                if (![NSString isEqualToNull:_txv_ContractHotel.text]&&![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_ContractHotel.text isEqualToString:@"请输入原因(必填)"]&&![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)])
                {
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }else if (![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_ContractHotel.text isEqualToString:_str_ContractHotel_tips]){
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }
            }else  if ([key isEqualToString:@"IsSupplierBear"]) {
                if (![NSString isEqualToNull:_txv_Supplier.text]&&[_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_Supplier.text isEqualToString:@"请输入原因(必填)"]&&[_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)])
                {
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }else if ([_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_Supplier.text isEqualToString:_str_Supplier_tips]){
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsSelfDrive"])
            {
                if (![NSString isEqualToNull:_txv_Drive.text]&&[_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }
                else if ([_txv_Drive.text isEqualToString:@"请输入原因(必填)"]&&[_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)])
                {
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }else if ([_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]&&[_txv_Drive.text isEqualToString:_str_Drive_tips]){
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"NotContractsReason"]) {
                if (![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    if (![NSString isEqualToNull:str] ) {
                        [self showerror:key];
                        isreturn = NO;
                        break ;
                    }
                }
            }else if ([key isEqualToString:@"SupplierEvaluation"]){
                if ([_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    if (![NSString isEqualToNull:str] ) {
                        [self showerror:key];
                        isreturn = NO;
                        break ;
                    }
                }
            }else if ([key isEqualToString:@"SelfDriveReason"]){
                if ([_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    if (![NSString isEqualToNull:str]) {
                        [self showerror:key];
                        isreturn = NO;
                        break ;
                    }
                }
            } else if ([key isEqualToString:@"IsContractsHotel"]){
                if (![NSString isEqualToNull:_txv_ContractHotel.text]&&![_model_ContractHotel.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"NotContractsReason"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsSupplierBear"]) {
                if (![NSString isEqualToNull:_txv_Supplier.text]&&[_model_Supplier.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SupplierEvaluation"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"IsSelfDrive"]) {
                if (![NSString isEqualToNull:_txv_Drive.text]&&[_model_Drive.txf_TexfField.text isEqualToString:Custing(@"是", nil)]) {
                    [self showerror:@"SelfDriveReason"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"Attachments"]) {
                if (_arr_Attachments_Totle.count==0) {
                    [self showerror:@"Attachments"];
                    isreturn = NO;
                    break ;
                }
            }else if ([key isEqualToString:@"CcUsersName"]) {
                if (![NSString isEqualToNullAndZero:_str_CcUsersId]) {
                    [self showerror:@"CcUsersName"];
                    isreturn = NO;
                    break ;
                }
            }else if(![NSString isEqualToNull:str]) {
                [self showerror:key];
                isreturn = NO;
                break ;
            }
        }
    }

    //控制行程安排在出差期间内
    if (self.bool_isControlTripDate && [NSString isEqualToNullAndZero:model.FromDate] && [model.FromDate length] >= 10 && [NSString isEqualToNullAndZero:model.ToDate] && [model.ToDate length] >= 10 && self.arr_travelRoute.count > 0) {
        NSDate *fromDate =[GPUtils TimeStringTranFromData:[model.FromDate substringToIndex:10] WithTimeFormart:@"yyyy/MM/dd"];
        NSDate *toDate =[GPUtils TimeStringTranFromData:[model.ToDate substringToIndex:10] WithTimeFormart:@"yyyy/MM/dd"];
        NSInteger i = 1;
        for (NSDictionary *dict in self.arr_travelRoute) {
            if ([NSString isEqualToNullAndZero:dict[@"travelDate"]] && [dict[@"travelDate"] length] >= 10) {
                NSDate *travelDate =[GPUtils TimeStringTranFromData:[dict[@"travelDate"] substringToIndex:10] WithTimeFormart:@"yyyy/MM/dd"];
                if ([fromDate timeIntervalSinceDate:travelDate] > 0.0 || [travelDate timeIntervalSinceDate:toDate] > 0.0 ){
                    [YXSpritesLoadingView dismiss];
                    [[GPAlertView sharedAlertView] showAlertText:self WithText:[NSString stringWithFormat:@"%@%ld%@%@",Custing(@"第", nil),i,Custing(@"条", nil),Custing(@"行程安排不在出差期间内", nil)]duration:2.0];
                    isreturn = NO;
                    break ;
                }
            }
            i++;
        }
    }
    return isreturn;
}

//显示错误信息
-(void)showerror:(NSString*)info
{
    NSString *showinfo = nil;
    if ([info isEqualToString:@"Reason"]) {
        showinfo = Custing(@"出差事由不能为空",nil);
    }else if ([info isEqualToString:@"RequestorBusDeptId"]) {
        showinfo = Custing(@"请选择业务部门",nil);
    }else if ([info isEqualToString:@"RequestorDeptId"]) {
        showinfo = Custing(@"请选择部门",nil);
    }else if([info isEqualToString:@"ExpenseCode"]) {
        showinfo = Custing(@"请选择费用类别", nil);
    }else if ([info isEqualToString:@"BranchId"]) {
        showinfo = Custing(@"请选择公司",nil);
    }else if ([info isEqualToString:@"CostCenterId"]) {
        showinfo = Custing(@"请选择成本中心",nil);
    }else if ([info isEqualToString:@"TravelType"]) {
        showinfo = Custing(@"请选择出差类型",nil);
    }else if ([info isEqualToString:@"RelevantDept"]) {
        showinfo = Custing(@"请选择归口部门",nil);
    }else if ([info isEqualToString:@"FromDate"]) {
        showinfo = Custing(@"请选择出差日期",nil);
    }else if ([info isEqualToString:@"ToDate"]) {
        showinfo = Custing(@"请选择返回日期",nil);
    }else if ([info isEqualToString:@"FromCityCode"]) {
        showinfo = Custing(@"请选择出发地",nil);
    }else if ([info isEqualToString:@"FromCity"]) {
        showinfo = Custing(@"请选择出发地",nil);
    }else if ([info isEqualToString:@"ToCity"]) {
        showinfo = Custing(@"请选择目的地城市",nil);
    }else if ([info isEqualToString:@"ToCityCode"]) {
        showinfo = Custing(@"请选择目的地城市",nil);
    }else if ([info isEqualToString:@"FellowOfficers"]) {
        showinfo = Custing(@"请选择出差人员",nil);
    }else if ([info isEqualToString:@"FellowOfficersid"]) {
        showinfo = Custing(@"请选择出差人员",nil);
    }else if ([info isEqualToString:@"AdvanceAmount"]) {
        showinfo = Custing(@"请输入预支金额",nil);
    }else if ([info isEqualToString:@"RepayDate"]) {
        showinfo = Custing(@"请选择还款日期",nil);
    }else if ([info isEqualToString:@"CurrencyCode"]) {
        showinfo = Custing(@"请选择币种",nil);
    }else if ([info isEqualToString:@"Currency"]) {
        showinfo = Custing(@"请选择币种",nil);
    }else if ([info isEqualToString:@"Remark"]) {
        showinfo = Custing(@"请输入备注",nil);
    }else if ([info isEqualToString:@"IsContractsHotel"]) {
        showinfo = Custing(@"是否合约酒店不能为空",nil);
    }else if ([info isEqualToString:@"NotContractsReason"]) {
        showinfo = Custing(@"不住合约酒店理由不能为空",nil);
    }else if ([info isEqualToString:@"IsSupplierBear"]) {
        showinfo = Custing(@"由供应商承担费用不能为空",nil);
    }else if ([info isEqualToString:@"SupplierEvaluation"]) {
        showinfo = Custing(@"请输入由供应商承担费用理由",nil);
    }else if ([info isEqualToString:@"IsSelfDrive"]) {
        showinfo = Custing(@"是否自驾车不能为空",nil);
    }else if ([info isEqualToString:@"SelfDriveReason"]) {
        showinfo = Custing(@"请输入自驾车理由",nil);
    }else if ([info isEqualToString:@"IsSelfDrive"]) {
        showinfo = Custing(@"是否自驾车不能为空",nil);
    }else if ([info isEqualToString:@"timeover"]) {
        showinfo = Custing(@"出发日期不能大于返回日期",nil);
    }else if ([info isEqualToString:@"FirstHandlerUserName"]) {
        showinfo = Custing(@"请选择审批人",nil);
    }else if ([info isEqualToString:@"ApprovalMode"]) {
        showinfo = Custing(@"请选择审批人",nil);
    }else if ([info isEqualToString:@"ProjId"]) {
        showinfo = Custing(@"请选择项目名称",nil);
    }else if ([info isEqualToString:@"UserLevelId"]||[info isEqualToString:@"AreaId"]||[info isEqualToString:@"SupplierId"]||[info isEqualToString:@"Attachments"]) {
        showinfo = [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[_reservedDic objectForKey:info]];
    }else if ([info isEqualToString:@"CcUsersName"]) {
        showinfo = Custing(@"请选择抄送人",nil);
    }else if ([info isEqualToString:@"Reserved1"]||[info isEqualToString:@"Reserved2"]||[info isEqualToString:@"Reserved3"]||[info isEqualToString:@"Reserved4"]||[info isEqualToString:@"Reserved5"]||[info isEqualToString:@"Reserved6"]||[info isEqualToString:@"Reserved7"]||[info isEqualToString:@"Reserved8"]||[info isEqualToString:@"Reserved9"]||[info isEqualToString:@"Reserved10"]) {
        showinfo =[[_isCtrlTypdic objectForKey:info] isEqualToString:@"dialog"]?[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[_reservedDic objectForKey:info]];
    }else{
        showinfo =[[_isCtrlTypdic objectForKey:info] isEqualToString:@"dialog"]?[NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),[_reservedDic objectForKey:info]]:[NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),[_reservedDic objectForKey:info]];
    }
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView] showAlertText:self WithText:showinfo];
}

//备注分行显示处理
-(void)changeRemarkView
{
    if (_remarksTextView.text.length == 0) {
        _remarkTipField.hidden = NO;
    }else{
        _remarkTipField.hidden = YES;
    }
}


#pragma mark - action
// 出差申请保存操作
-(void)saveProcurementInfo{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [self mainDataList:2];
    [self network:2];
}

// 出差申请提交操作
-(void)submitProcurementInfo{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.dockView.userInteractionEnabled=NO;
    [self mainDataList:1];
    if([self testModel:_filedModel]){
        self.int_SubmitSaveType=2;
        [self checkTravelReimSubmit];
    }else
    {
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        return;
    }
}

// 出差申请退单提交操作
-(void)backProcurementSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    self.dockView.userInteractionEnabled=NO;
    [self mainDataList:1];
    
    if([self testModel:_filedModel])
    {
        self.int_SubmitSaveType=2;
        [self checkTravelReimSubmit];
    }
    else
    {
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        return;
    }
}

//直送
-(void)btn_Direct
{
    [self keyClose];
    NSLog(@"直送操作");
    self.dockView.userInteractionEnabled=NO;
    [self mainDataList:1];
    if([self testModel:_filedModel])
    {
        if (![_filedModel.AdvanceAmount isEqualToString:_str_lastAmount]&&[_str_directType integerValue]==2) {
            self.dockView.userInteractionEnabled = YES;
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您修改了金额，请重新提交", nil) duration:1.0];
        }else if ([_str_lastAmount floatValue]<=[_filedModel.AdvanceAmount floatValue]&&[_str_directType integerValue]== 3){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"您修改了金额，请重新提交", nil) duration:1.0];
            return;
        }else{
            self.int_SubmitSaveType=3;
            [self checkTravelReimSubmit];
        }
    }
}

//全部按钮点击事件
-(void)btn_Click:(UIButton *)btn
{
    [self keyClose];
    __weak typeof(self) weakSelf = self;
    switch (btn.tag) {
            //币种
        case 2 : {
            STOnePickView *picker = [[STOnePickView alloc]init];
            __weak typeof(self) weakSelf = self;
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                weakSelf.str_CurrencyCode=Model.Id;
                weakSelf.str_Currency=Model.Type;
                weakSelf.txf_CurrencyCode.text=Model.Type;
                weakSelf.txf_ExchangeRate.text=Model.exchangeRate;
                weakSelf.str_ExchangeRate=Model.exchangeRate;
                weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_AdvanceAmount.text with:([NSString isEqualToNull:weakSelf.str_ExchangeRate]?weakSelf.str_ExchangeRate:@"1.0000")]];
            }];
            picker.typeTitle=Custing(@"币种", nil);
            picker.DateSourceArray=[NSMutableArray arrayWithArray:_muarr_CurrencyCode];
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Id=[NSString isEqualToNull: _str_CurrencyCode]?_str_CurrencyCode:@"";
            picker.Model=model;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
            break;
        }
        //出差类型点击
        case 100:
        {
            ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BusinessType"];
            vc.ChooseCategoryId=self.str_BusinessType_id;
            __weak typeof(self) weakSelf = self;
            vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                ChooseCateFreModel *model = array[0];
                weakSelf.Txf_BusinessType.text = model.travelType;
                weakSelf.str_BusinessType_id = model.Id;
            };
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        //出发地点击
        case 104:
        {
            NewAddressViewController * address = [[NewAddressViewController alloc]init];
            address.status = @"1";
            address.Type=1;
            address.isGocity=@"1";
            address.delegate = self;
            address.arr_Click_Citys = _Arr_Origin;
            address.OnlyInternal = NO;
            [self.navigationController pushViewController:address animated:YES];
            break;
        }
        //目的地点击点击
        case 105:
        {
            NewAddressViewController * address = [[NewAddressViewController alloc]init];
            address.status = @"2";
            address.Type=2;
            address.isGocity=@"2";
            address.delegate = self;
            address.arr_Click_Citys = _Arr_ToCity;
            address.OnlyInternal = NO;
            [self.navigationController pushViewController:address animated:YES];
            break;
        }
        //出差人员点击
        case 106:
        {
            contactsVController *contactVC=[[contactsVController alloc]init];
            contactVC.status = @"3";
            NSMutableArray *array = [NSMutableArray array];
            NSArray *idarr = [self.str_BusinessPersonnel componentsSeparatedByString:@","];
            for (int i = 0 ; i<idarr.count ; i++) {
                NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                [array addObject:dic];
            }
            contactVC.arrClickPeople = array;
            contactVC.menutype=2;
            contactVC.itemType = 99;
            contactVC.Radio = @"2";
            contactVC.universalDelegate = self;
            __weak typeof(self) weakSelf = self;
            [contactVC setBlock:^(NSMutableArray *array) {
                NSMutableArray *nameArr=[NSMutableArray array];
                NSMutableArray *IdArr=[NSMutableArray array];
                NSMutableArray *DeptIdArr=[NSMutableArray array];
                for (int i = 0 ; i<array.count ; i++) {
                    buildCellInfo *info = array[i];
                    [nameArr addObject:[NSString stringWithFormat:@"%@",info.requestor]];
                    [IdArr addObject:[NSString stringWithFormat:@"%ld",info.requestorUserId]];
                    [DeptIdArr addObject:[NSString stringWithFormat:@"%@",info.requestorDeptId]];
                }
                weakSelf.str_BusinessPersonnel = [GPUtils getSelectResultWithArray:IdArr WithCompare:@","];
                weakSelf.str_BusinessPersonnelDeptId = [GPUtils getSelectResultWithArray:DeptIdArr WithCompare:@","];
                weakSelf.txf_BusinessPersonnel.text = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            }];
            [self.navigationController pushViewController:contactVC animated:YES];
            break;
        }
        //添加行程
        case 301:
        {
            AddTravelRouteController *vc = [[AddTravelRouteController alloc]init];
            vc.arr_ShowArray = _arr_routeFormFields;
            vc.userId = self.FormData.personalData.RequestorUserId;
            __weak typeof(self) weakSelf = self;
            vc.addTravelRouteBlock = ^(NSIndexPath * _Nonnull index, NSDictionary * _Nonnull dict) {
                [weakSelf.arr_travelRoute addObject:dict];
                CGFloat height = [weakSelf getTravelRouteTableHeight];
                [weakSelf.view_travelRoute updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(60 + height);
                }];
                weakSelf.tbv_travelRoute.frame = CGRectMake(0, 60, Main_Screen_Width, height);
                [weakSelf.tbv_travelRoute reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

//还款日期
-(void)RepaymentDateClick:(UIButton *)btn{
    NSLog(@"还款日期");
    [self keyClose];
    _datePicker = [[UIDatePicker alloc]init];
    NSString *dateStr;
    
    if ([NSString isEqualToNull:_txf_DurationData.text]) {
        dateStr=_txf_DurationData.text;
        _str_selectDataString=_txf_DurationData.text;
    }else{
        NSDate *pickerDate = [NSDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        pickerFormatter.timeZone = [NSTimeZone localTimeZone];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
        dateStr=currStr;
        _str_selectDataString=currStr;
    }
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    _datePicker.date=fromDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"时间",nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(DurationsureData:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:sureDataBtn];
    __weak typeof(self) weakSelf = self;
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:nil delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    [view addSubview:cancelDataBtn];
    [cancelDataBtn bk_whenTapped:^{
        [weakSelf.datelView remove];
        weakSelf.datePicker = nil;
        weakSelf.datelView = nil;
    }];
    if (!_datelView) {
        _datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _datelView.delegate = self;
    }
    
    [_datelView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
}
//MARK:自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}
//审批人选择
-(void)ApproveClick:(UIButton *)btn{
    [self keyClose];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *idarr = [_firstHanderId componentsSeparatedByString:@","];
    for (int i = 0 ; i<idarr.count ; i++) {
        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
        [array addObject:dic];
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"1";
    contactVC.arrClickPeople = array;
    contactVC.menutype=3;
    contactVC.itemType = 1;
    contactVC.universalDelegate = self;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        weakSelf.firstinfo = array.lastObject;
        weakSelf.txf_Approver.text=self.firstinfo.requestor;
        weakSelf.firstHanderName=self.firstinfo.requestor;
        weakSelf.firstHanderId=[NSString stringWithFormat:@"%ld",(long)weakSelf.firstinfo.requestorUserId];
        
        if ([NSString isEqualToNull:self.firstinfo.photoGraph]) {
            NSDictionary * dic = (NSDictionary *)[NSString transformToObj:self.firstinfo.photoGraph];
            NSString *str =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
            if ([NSString isEqualToNull:str]) {
                [weakSelf.img_ApproveImgView sd_setImageWithURL:[NSURL URLWithString:str]];
            }else{
                weakSelf.img_ApproveImgView.image=self.firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
            }
        }
        else{
            weakSelf.img_ApproveImgView.image=self.firstinfo.gender==0?[UIImage imageNamed:@"Message_Man"]:[UIImage imageNamed:@"Message_Woman"];
        }
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//MARK:选择抄送人
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
        }
        weakSelf.str_CcUsersId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
        weakSelf.str_CcUsersName=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
        weakSelf.txf_CcToPeople.text=weakSelf.str_CcUsersName;
    }];
    [self.navigationController pushViewController:contactVC animated:YES];
}
//MARK:费用类别选择
-(void)CateBtnClick:(UIButton *)btn{
    [self keyClose];
    if (self.arr_CategoryArr.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
        return;
    }
    NSString *CateLevel = self.dict_CategoryParameter[@"CateLevel"];
    if ([CateLevel isEqualToString:@"1"]) {
        [self updateCateGoryView];
    }else if ([CateLevel isEqualToString:@"2"]){
        STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
        pickerArea.DateSourceArray = self.arr_CategoryArr;
        CostCateNewSubModel *model = [[CostCateNewSubModel alloc]init];
        model.expenseCode = self.str_ExpenseCode;
        pickerArea.CateModel = model;
        [pickerArea UpdatePickUI];
        [pickerArea setContentMode:STPickerContentModeBottom];
        pickerArea.str_flowCode=@"F0001";
        __weak typeof(self) weakSelf = self;
        [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
            [weakSelf keyClose];
            if (![secondModel.expenseCode isEqualToString:weakSelf.str_ExpenseCode]) {
                weakSelf.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                weakSelf.str_ExpenseType = [NSString isEqualToNull:secondModel.expenseType]?secondModel.expenseType:@"";
                weakSelf.str_ExpenseCode = secondModel.expenseCode;
                weakSelf.str_ExpenseIcon = secondModel.expenseIcon;
                weakSelf.str_ExpenseCat = secondModel.expenseCat;
                weakSelf.str_ExpenseCatCode = secondModel.expenseCatCode;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
            }
        }];
        [pickerArea show];
    }else if([CateLevel isEqualToString:@"3"]){
        ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
        ex.arr_DataList = self.arr_CategoryArr;
        ex.str_CateLevel = CateLevel;
        __weak typeof(self) weakSelf = self;
        ex.CellClick = ^(CostCateNewSubModel *model) {
            if (![model.expenseCode isEqualToString:weakSelf.str_ExpenseCode]) {
                weakSelf.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                weakSelf.str_ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
                weakSelf.str_ExpenseCode = model.expenseCode;
                weakSelf.str_ExpenseIcon = model.expenseIcon;
                weakSelf.str_ExpenseCat = model.expenseCat;
                weakSelf.str_ExpenseCatCode = model.expenseCatCode;
                weakSelf.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                [weakSelf updateCateGoryView];
            }
        };
        [self.navigationController pushViewController:ex animated:YES];
    }
}

-(void)IsUseCarClick{
    STOnePickView *picker = [[STOnePickView alloc]init];
    picker.typeTitle=Custing(@"是否用车", nil);
    __weak typeof(self) weakSelf = self;
    [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
        if ([[NSString stringWithFormat:@"%@",Model.Id]isEqualToString:@"1"]) {
            weakSelf.str_IsUseCar=@"1";
            weakSelf.txf_IsUseCar.text =Custing(@"是", nil);
        }else{
            weakSelf.str_IsUseCar=@"0";
            weakSelf.txf_IsUseCar.text=Custing(@"否", nil);
        }
    }];
    picker.DateSourceArray=self.arr_IsUseCar;
    STOnePickModel *model=[[STOnePickModel alloc]init];
    model.Id=self.str_IsUseCar;
    picker.Model=model;
    [picker UpdatePickUI];
    [picker setContentMode:STPickerContentModeBottom];
    [picker show];
}
//还款日期date
-(void)DurationsureData:(UIButton *)btn{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    _str_selectDataString = [pickerFormatter stringFromDate:pickerDate];
    _txf_DurationData.text = _str_selectDataString;
    [self.datelView remove];
}

////时间选择确定按钮
//-(void)sureData:(UIButton *)btn{
//    NSDate * pickerDate = [_datePicker date];
//    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
//    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
//    NSString * str = [pickerFormatter stringFromDate:pickerDate];
//
//    if (btn.tag == 1) {
//        _str_startDate = str;
//
//        NSAttributedString *asta = [NSString transformDateString:_str_startDate];
//        _lab_StartDay.attributedText = asta;
//    }
//    if (btn.tag == 2) {
//        _str_endDate = str;
//        NSAttributedString *send = [NSString transformDateString:_str_endDate];
//        _lab_EndDay.attributedText = send;
//    }
//    [self.datelView remove];
//}

//tableview header点击事件
- (void)headerClick:(UIButton *)view
{
    NewBusinessPlanViewController *bp = [[NewBusinessPlanViewController alloc]init];
    bp.str_isRelateTravelForm = _str_isRelateTravelForm;
    for (NSArray *arr in _arr_Business) {
        for (MyProcurementModel *models in arr) {
            if ([models.fieldName isEqualToString:@"FlyPeopleId"]&&view.tag == 1) {
                bp.arr_Main = arr;
                break;
            }
            if ([models.fieldName isEqualToString:@"PassengerId"]&&view.tag == 3) {
                bp.arr_Main = arr;
                break;
            }
            if ([models.fieldName isEqualToString:@"NumberOfRooms"]&&view.tag == 2) {
                bp.arr_Main = arr;
                break;
            }
        }
    }
    if (bp.Type == 1) {
        TravelFlightDetailModel *flight = [[TravelFlightDetailModel alloc]init];
        flight.departuredate = [NSString stringWithIdOnNO:_txf_StartDay.text];
        flight.fromcity = [NSString isEqualToNull:_txf_Origin.text]?_txf_Origin.text:@"";
        flight.flypeople = @"";
        flight.tocitycode = @"";
        flight.fromcitycode = _str_OriginCode;
        bp.model_Show_flight = flight;
    }else if (bp.Type == 2) {
        TravelHotelDetailModel *hotel = [[TravelHotelDetailModel alloc]init];
        hotel.checkindate = [NSString stringWithIdOnNO:_txf_StartDay.text];
        hotel.checkoutdate = [NSString stringWithIdOnNO:_txf_EndDay.text];
        hotel.checkincitycode = @"";
        bp.model_Show_hotel = hotel;
    }else if (bp.Type == 3) {
        TravelTrainDetailModel *train = [[TravelTrainDetailModel alloc]init];
        train.departuredate = [NSString stringWithIdOnNO:_txf_StartDay.text];
        train.fromcity = [NSString isEqualToNull:_txf_Origin.text]?_txf_Origin.text:@"";
        train.fromcitycode =_str_OriginCode;
        train.tocitycode = @"";
        bp.model_Show_train = train;
    }
    
    bp.Type = view.tag ;
    bp.delegate = self;
    [self.navigationController pushViewController:bp animated:YES];
}

//备注限制字数
-(void)AddRemarkTextViewEditChanged:(NSNotification *)obj{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >255) {
                textField.text = [toBeString substringToIndex:255];
            }
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 255) {
            textField.text = [toBeString substringToIndex:255];
        }
    }
}

//备注语音输入
-(void)VoiceBtnClick:(UIButton *)btn{
    [self keyClose];
    [self startVoice];
}

#pragma mark - 代理
//请求成功
-(void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);

    if ([responceDic[@"success"] intValue] == 0 ) {
        [YXSpritesLoadingView dismiss];
        self.dockView.userInteractionEnabled=YES;
        _submitBtn.userInteractionEnabled = YES;
        _backSubBtn.userInteractionEnabled = YES;
        _saveBtn.userInteractionEnabled = YES;
        self.dockView.userInteractionEnabled=YES;
        if ([[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"resultCode"]] isEqualToString:@"1001"]) {
            [self updateAprovalProcess:self.FormData.str_flowGuid WithProcId:[NSString stringWithFormat:@"%@",responceDic[@"procId"]]];
        }else{
            NSString * error = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"msg"]];
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }
        return;
    }
    if (serialNum == 0) {
        _Dic_requset = responceDic;
        [self getBusinessApproval];
        NSDictionary *dict = [VoiceDataManger getFlowShowInfo:self.FormData.str_flowGuid];
        self.navigationItem.title = dict[@"Title"];
        [self createScrollView];
        [self createMainView];
        if (_comeStatus==3) {
            [self requestApproveNote];
        }else{
            [self updateMainView];
            [self updateContentView];
            [self requestCate];
            [YXSpritesLoadingView dismiss];
        }
    }else if (serialNum == 1||serialNum == 9) {
        [YXSpritesLoadingView dismiss];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            [self returnBack];
        } afterDelay:1.5];
    }else if (serialNum == 2) {
        [YXSpritesLoadingView dismiss];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        [self performBlock:^{
            LookTravelRequestsViewController *look = [[LookTravelRequestsViewController alloc]init];
            look.comeStatus=1;
            if (self.comeStatus==1) {
                look.backIndex=@"0";
            }else{
                look.backIndex=@"1";
            }
            look.taskId = [responceDic objectForKey:@"result"];
            [self.navigationController pushViewController:look animated:YES];
        } afterDelay:1.5];
    }else if (serialNum == 3 ) {
        [YXSpritesLoadingView dismiss];
        [[GPAlertView sharedAlertView]showAlertText:self WithText:responceDic[@"msg"] duration:1.5];
        __weak typeof(self) weakSelf = self;
        [self performBlock:^{
        
//            [UIAlertView bk_showAlertViewWithTitle:Custing(@"提示", nil) message:Custing(@"是否将内容添加到日历？",nil) cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"确定",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                if (buttonIndex == 1) {
                    NSString *str_date = [weakSelf.txf_StartDay.text substringToIndex:10];
                    NSDateFormatter *format=[[NSDateFormatter alloc] init];
                    [format setDateFormat:@"yyyy/MM/dd"];
                    NSDate *fromdate=[format dateFromString:str_date];
                    
                    NSString *str_end = [weakSelf.txf_EndDay.text substringToIndex:10];
                    NSDate *enddate=[format dateFromString:str_end];
                    
                    [[EventCalendar alloc]createEventCalendarTitle:[NSString isEqualToNull:weakSelf.txf_TravelReason.text]?weakSelf.txf_TravelReason.text:Custing(@"出差申请", nil) location:[NSString isEqualToNull:weakSelf.txf_ToCity.text]?weakSelf.txf_ToCity.text:Custing(@"", nil) startDate:fromdate endDate:enddate allDay:YES alarmArray:@[@"-36000"]];
                    
//                }
            
                LookTravelRequestsViewController *look = [[LookTravelRequestsViewController alloc]init];
                look.comeStatus=1;
                if (weakSelf.comeStatus==1) {
                    look.backIndex=@"0";
                }else{
                    look.backIndex=@"1";
                }
                look.taskId = [responceDic objectForKey:@"result"];
                [weakSelf.navigationController pushViewController:look animated:YES];
//            }];
        } afterDelay:1.5];
    }else if (serialNum == 7) {
        _resultDict=responceDic;
        [self getNoteData];
        [self updateMainView];
        [self updateContentView];
        [self requestCate];
        [YXSpritesLoadingView dismiss];
    }else if (serialNum == 10) {
        [self goToFlowChartWithUrl:responceDic[@"result"]];
    }else if (serialNum == 5) {
       self.dict_CategoryParameter = [CostCateNewModel getCostCateByDict:responceDic array:self.arr_CategoryArr withType:1];
    }else if (serialNum == 14) {
        if ([self getVerifyBudegtWithDict:responceDic]==0) {
            [self network:1];
        }else{
            [self showBudgetTab];
        }
    }
    
}

-(NSInteger)getVerifyBudegtWithDict:(NSDictionary *)dict{
    NSInteger type=0;
    NSDictionary *result=[dict objectForKey:@"result"];
    if (![result isKindOfClass:[NSNull class]]) {
        //超预算是否能提交  超标类型（0未超标，1额度超标，2成本中心预算超标，3项目预算超标）0能提交
        type = [[NSString stringWithFormat:@"%@",[result objectForKey:@"type"]]floatValue];
        self.arr_table = [NSMutableArray array];
            self.arr_BudgetInfo=[NSMutableArray array];
        if (type==0) {
            [self AddclaimLimitWith:result];
            [self AddprojLimit:result];
            [self AddcostCLimit:result];
            [self getVerifyBudegt_addBudgetInfo];
        }else if (type==1){
            [self AddclaimLimitWith:result];
        }else if (type==2){
            [self AddcostCLimit:result];
        }else if (type==3){
            [self AddprojLimit:result];
        }
    }
    return type;
}

//处理额度超标
-(void)AddclaimLimitWith:(NSDictionary *)result{
    if (![result[@"claimLimit"] isKindOfClass:[NSNull class]]) {
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",result[@"claimLimit"][@"amount"]]]) {
            [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@",@"超出本月报销额度",[NSString stringWithFormat:@"%@",result[@"claimLimit"][@"amount"]],@"元"]];
        }
    }
}
//处理项目预算超标
-(void)AddprojLimit:(NSDictionary *)result{
    if (![result[@"projLimit"] isKindOfClass:[NSNull class]]) {
        if (![result[@"projLimit"][@"details"] isKindOfClass:[NSNull class]]) {
            
            NSArray *projArr=result[@"projLimit"][@"details"];
            if (projArr.count>0) {
                
                NSUInteger index=[self.alldic[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"IsOverBud"];
                [self.alldic[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:@"1"];

                for (NSDictionary *dict in projArr) {
                    NSMutableArray *arr=[NSMutableArray array];
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"projName"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@%@",dict[@"projName"],@"项目"]];
                    }
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
                    }
                    [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],Custing(@"超出预算", nil),[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                }
            }
        }
    }
}
//处理成本中心预算超标
-(void)AddcostCLimit:(NSDictionary *)result{
    if (![result[@"costCLimit"] isKindOfClass:[NSNull class]]) {
        if (![result[@"costCLimit"][@"details"] isKindOfClass:[NSNull class]]) {
            NSArray *costArr=result[@"costCLimit"][@"details"];
            if (costArr.count>0) {
                NSUInteger index=[self.alldic[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"IsOverBud"];
                [self.alldic[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:@"1"];

                for (NSDictionary *dict in costArr) {
                    NSMutableArray *arr=[NSMutableArray array];
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"costCenter"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"costCenter"]]];
                    }
                    if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]]) {
                        [arr addObject:[NSString stringWithFormat:@"%@",dict[@"expenseType"]]];
                    }
                    [self.arr_table addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],@"超出预算",[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                    [self.arr_BudgetInfo addObject:[NSString stringWithFormat:@"%@%@%@%@",[arr componentsJoinedByString:@"-"],@"超出预算",[NSString stringWithFormat:@"%@",dict[@"amount"]],@"元"]];
                }
            }
        }
    }
}
//MARK:超预算信息添加
-(void)getVerifyBudegt_addBudgetInfo{
    NSUInteger index=[self.alldic[@"mainDataList"][0][@"fieldNames"]indexOfObject:@"BudgetInfo"];
    [self.alldic[@"mainDataList"][0][@"fieldValues"] replaceObjectAtIndex:index withObject:[self.arr_BudgetInfo componentsJoinedByString:@";"]];
}
//请求失败
-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum
{
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];

}

-(void)showBudgetTab{
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:Custing(@"超预算提示", nil) message:@"" canDismis:NO];
    alert.contentView = self.View_table;
    [self.View_table reloadData];
    [alert addButton:Button_OTHER withTitle:Custing(@"取消", nil) handler:^(JKAlertDialogItem *item) {
        self.dockView.userInteractionEnabled=YES;
    }];
    [alert show];
}

//新城市请求
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start{
    //出发城市
    if ([start isEqualToString:@"1"]) {
        _Arr_Origin = [NSMutableArray arrayWithArray:array];
        if (_Arr_Origin.count>0) {
            NSDictionary *dic = _Arr_Origin[0];
            _txf_Origin.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
            _str_OriginCode = dic[@"cityCode"];
        }
    }
    //到达城市
    if ([start isEqualToString:@"2"]) {
        _Arr_ToCity = [NSMutableArray arrayWithArray:array];
        if (_Arr_ToCity.count>0) {
            NSString *str_tocity =@"";
            for (int i = 0; i<_Arr_ToCity.count; i++) {
                NSDictionary *dic = _Arr_ToCity[i];
                if (i == 0) {
                    str_tocity = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:dic[@"cityNameEn"];
                    _str_ToCityCode = dic[@"cityCode"];
                }
                else
                {
                    str_tocity = [NSString stringWithFormat:@"%@,%@",str_tocity,[self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:dic[@"cityNameEn"]];
                    _str_ToCityCode = [NSString stringWithFormat:@"%@,%@",_str_ToCityCode,dic[@"cityCode"]];
                }
            }
            _txf_ToCity.text = [NSString stringWithIdOnNO:str_tocity];
        }else{
            _str_ToCityCode = @"";
            _txf_ToCity.text = _tocitytip;
        }
    }
}
//日期选择底层视图代理
-(void)dimsissPDActionView{
    _datelView=nil;
}

//数值变化的时候代理
-(void)DateChanged:(UIDatePicker *)sender{
    [self keyClose];
}

//出差单代理
-(void)NewBusinessPlanViewController_btnClick_Delegate:(NSArray *)arr Type:(NSInteger )type
{
    if (type == 1) {
        TravelFlightDetailModel *flight = arr[0];
        if (flight.indexid) {
            for (int i = 0; i<_Arr_planeTicketArray.count; i++) {
                TravelFlightDetailModel *flightold = _Arr_planeTicketArray[i];
                if ([flightold.indexid isEqualToString:flight.indexid]) {
                    _Arr_planeTicketArray[i] = arr[0];
                }
            }
        }else{
            flight.indexid = [NSString stringWithFormat:@"%d",(arc4random() % 1000) + 8999];
            [_Arr_planeTicketArray addObject:arr[0]];
        }
    }else if (type == 2) {
        TravelHotelDetailModel *home =arr[0];
        if (home.indexid) {
            for (int i = 0; i<_Arr_homeArray.count; i++) {
                TravelHotelDetailModel *homeold = _Arr_homeArray[i];
                if ([homeold.indexid isEqualToString:home.indexid]) {
                    _Arr_homeArray[i] =arr[0];
                }
            }
        }else{
            home.indexid = [NSString stringWithFormat:@"%d",(arc4random() % 1000) + 8999];
            [_Arr_homeArray addObject:arr[0]];
        }
    }else if (type == 3) {
        TravelTrainDetailModel *train =arr[0];
        if (train.indexid) {
            for (int i = 0; i<_Arr_trainArray.count; i++) {
                TravelTrainDetailModel *trainold = _Arr_trainArray[i];
                if ([trainold.indexid isEqualToString:train.indexid]) {
                    _Arr_trainArray[i] =arr[0];
                }
            }
        }else{
            train.indexid = [NSString stringWithFormat:@"%d",(arc4random() % 1000) + 8999];
            [_Arr_trainArray addObject:arr[0]];
        }
    }
    
    [_view_Demand updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.Arr_Demand.count*60+self.Arr_homeArray.count*58+self.Arr_trainArray.count*58+self.Arr_planeTicketArray.count*58);
    }];
    _tbv_Demand.frame = CGRectMake(0, 0, Main_Screen_Width, _Arr_Demand.count*60+_Arr_homeArray.count*58+_Arr_trainArray.count*58+_Arr_planeTicketArray.count*58);
    [self.tbv_Demand reloadData];
}
#pragma mark textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//textView代理事件
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    NSLog(textView.text);
    if (textView.tag ==301||textView.tag ==302||textView.tag ==303 ) {
        if (textView.tag == 301) {
            if ([textView.text isEqualToString:_str_ContractHotel_tips]) {
                textView.text= @"";
                textView.textColor = Color_form_TextField_20;
            }
        }
        if (textView.tag == 302) {
            if ([textView.text isEqualToString:_str_Supplier_tips]) {
                textView.text= @"";
                textView.textColor = Color_form_TextField_20;
            }
        }
        if (textView.tag == 303) {
            if ([textView.text isEqualToString:_str_Drive_tips]) {
                textView.text= @"";
                textView.textColor = Color_form_TextField_20;
            }
        }
        if (textView.text.length>200) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
            textView.text = [textView.text substringToIndex:199];
        }
    }
    if ([textView class] == [_remarksTextView class]) {
        if (textView.text.length>200) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
            textView.text = [textView.text substringToIndex:199];
        }
        _remarksTextView.text = textView.text;
    }
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
//    NSLog(textView.text);
    if (textView.tag ==301||textView.tag ==302||textView.tag ==303 ) {
        if ([textView.text isEqualToString:@""]) {
            if (textView.tag ==301) {
                textView.text= _str_ContractHotel_tips;
            }
            if (textView.tag ==302) {
                textView.text= _str_Supplier_tips;
            }
            if (textView.tag ==303) {
                textView.text= _str_Drive_tips;
            }
            textView.textColor = [UIColor lightGrayColor];
        }
        if (textView.text.length>200) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
            textView.text = [textView.text substringToIndex:199];
        }
    }
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
    [self changeRemarkView];
}

//textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_txf_AdvanceAmount == textField)  //判断是否时我们想要限定的那个输入框
    {
        _txf_LocalCyAmount.text = [GPUtils decimalNumberMultipWithString:toBeString with:_txf_ExchangeRate.text];
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        return match!= 0;

    }
    
    if (textField == _txf_ExchangeRate) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        return match!= 0;

    }
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        return YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog( @"%@", textField.text);
    if (_txf_AdvanceAmount== textField){
        if (textField.text.length!=0) {
            NSString *subStr = [textField.text substringFromIndex:textField.text.length-1];
            if ([subStr isEqualToString:@"."]) {
                textField.text=[textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
    if (textField.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textField.text = [textField.text substringToIndex:199];
    }
}
//MARK:UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width/5, 65);
    }
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == _CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 10);
    }
    return CGSizeZero;
}
//MARK:CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _CategoryCollectView) {
        return self.arr_CategoryArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _CategoryCollectView) {
        _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
        [_cell configWithArray:self.arr_CategoryArr withRow:indexPath.row];
        return _cell;
    }
    return [UICollectionViewCell new];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _CategoryCollectView) {
        [self keyClose];
        CostCateNewModel *model = self.arr_CategoryArr[indexPath.row];
        if (![model.expenseCode isEqualToString:self.str_ExpenseCode]) {
            self.Imv_category.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
            self.str_ExpenseType = [NSString isEqualToNull:model.expenseType]?model.expenseType:@"";
            self.str_ExpenseCode = model.expenseCode;
            self.str_ExpenseIcon = model.expenseIcon;
            self.str_ExpenseCat = model.expenseCat;
            self.str_ExpenseCatCode = model.expenseCatCode;
            self.txf_Cate.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            [self updateCateGoryView];
        }else{
            [self updateCateGoryView];
        }
    }
}
-(void)updateCateGoryView{
    self.bool_isOpenCate = !self.bool_isOpenCate;
    if (self.bool_isOpenCate) {
        NSInteger categoryRows = [self.dict_CategoryParameter[@"categoryRows"] integerValue];
        if (categoryRows == 0) {
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }else{
            [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*categoryRows)+10));
            }];
            [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((65*categoryRows)+10));
            }];
        }
        [_CategoryCollectView reloadData];
    }else{
        [_CategoryView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}
//表单代理43
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbv_travelRoute) {
        return 1;
    }else if (tableView == _View_table){
        return 1;
    }
    return _Arr_Demand.count;
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbv_travelRoute) {
        return _arr_travelRoute.count;
    }else if (tableView==_View_table) {
        return self.arr_table.count;
    }
    MyProcurementModel *model = _Arr_Demand[section];
    NSString *string = model.fieldName;
    if ([string isEqualToString:@"FlightPlan"]) {
        return _Arr_planeTicketArray.count;
    }else if ([string isEqualToString:@"RoomPlan"]) {
        return _Arr_homeArray.count;
    }else if ([string isEqualToString:@"TrainPlan"]) {
        return _Arr_trainArray.count;
    }else{
        return 0;
    }
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbv_travelRoute) {
        NSDictionary *dict = self.arr_travelRoute[indexPath.row];
        return [TravelRouteDetailCell cellHeightWithObj:dict];
    }else  if (tableView==_View_table){
        return 40;
    }
    return 55;
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbv_travelRoute) {
        return 0.01;
    }else  if (tableView==_View_table){
        return 0.01;
    }
    return 60;
}

//组头加载
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbv_travelRoute) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
        return view;
    }else  if (tableView==_View_table){
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 0.01)];
        return view;
    }
    MyProcurementModel *model = _Arr_Demand[section];
    NSString *string = model.fieldName;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 60)];
    
    UIView *baseView =[[UIView alloc]init];
    [view addSubview:baseView];
    [baseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
    }];
    UIButton *btn =[[UIButton alloc]init];
    NSString *title;
    if ([string isEqualToString:@"FlightPlan"]) {
        title = Custing(@"添加机票需求单", nil);
        btn.tag = 1;
    }
    if ([string isEqualToString:@"RoomPlan"]) {
        title = Custing(@"添加住宿需求单",nil);
        btn.tag = 2;
    }
    if ([string isEqualToString:@"TrainPlan"]) {
        title = Custing(@"添加火车票需求单", nil);
        btn.tag = 3;
    }
    SubmitFormView *view1=[[SubmitFormView alloc]initAddBtbWithBaseView:baseView withTitle:Custing(@"添加", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:1];
    __weak typeof(self) weakSelf = self;
    [view1 setFormClickedBlock:^(MyProcurementModel *model) {
        [weakSelf headerClick:btn];
    }];
    [baseView addSubview:view1];
    
    UILabel *lab =[GPUtils createLable:CGRectMake(12, 10, 200, 50) text:title font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
    [baseView addSubview:lab];
    return view;
}



//显示行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tbv_travelRoute) {
        TravelRouteDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TravelRouteDetailCell"];
        if (cell==nil) {
            cell=[[TravelRouteDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelRouteDetailCell"];
        }
        cell.bool_hideLine = (indexPath.row == self.arr_travelRoute.count - 1);
        NSDictionary *dict = _arr_travelRoute[indexPath.row];
        cell.dict_Info = dict;
        return cell;
    }else if (tableView==_View_table) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text =self.arr_table[indexPath.row];
        cell.textLabel.font = Font_Same_14_20;
        return cell;
    }
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
            }
        }
    }
    if ([string isEqualToString:@"RoomPlan"]) {
        if (_Arr_homeArray.count>0) {
            TravelHotelDetailModel *home = _Arr_homeArray[indexPath.row];
            if (cell==nil) {
                cell=[[travelPlanViewCell alloc] initModelwithByHomeCell:home];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    if ([string isEqualToString:@"TrainPlan"]) {
        if (_Arr_trainArray.count>0) {
            TravelTrainDetailModel *train = _Arr_trainArray[indexPath.row];
            if (cell==nil) {
                cell=[[travelPlanViewCell alloc] initModelwithByTrainCell:train];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//单行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbv_travelRoute) {
        AddTravelRouteController *vc = [[AddTravelRouteController alloc]init];
        vc.arr_ShowArray = _arr_routeFormFields;
        vc.userId = self.FormData.personalData.RequestorUserId;
        vc.dic_Data = _arr_travelRoute[indexPath.row];
        vc.index = indexPath;
        __weak typeof(self) weakSelf = self;
        vc.addTravelRouteBlock = ^(NSIndexPath * _Nonnull index, NSDictionary * _Nonnull dict) {
            [weakSelf.arr_travelRoute replaceObjectAtIndex:index.row withObject:dict];
            CGFloat height = [weakSelf getTravelRouteTableHeight];
            [weakSelf.view_travelRoute updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(60 + height);
            }];
            weakSelf.tbv_travelRoute.frame = CGRectMake(0, 60, Main_Screen_Width, height);
            [weakSelf.tbv_travelRoute reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView!=_tbv_travelRoute){
        
        NewBusinessPlanViewController *bp =[[NewBusinessPlanViewController alloc]init];
        bp.delegate = self;
        MyProcurementModel *model = _Arr_Demand[indexPath.section];
        NSString *string = model.fieldName;
        if ([string isEqualToString:@"FlightPlan"]) {
            bp.Type = 1;
            bp.model_Show_flight = _Arr_planeTicketArray[indexPath.row];
            for (NSArray *arr in _arr_Business) {
                for (MyProcurementModel *models in arr) {
                    if ([models.fieldName isEqualToString:@"FlyPeopleId"]) {
                        bp.arr_Main = arr;
                        break;
                    }
                }
            }
        }
        if ([string isEqualToString:@"RoomPlan"]) {
            bp.Type = 2;
            bp.model_Show_hotel = _Arr_homeArray[indexPath.row];
            for (NSArray *arr in _arr_Business) {
                for (MyProcurementModel *models in arr) {
                    if ([models.fieldName isEqualToString:@"NumberOfRooms"]) {
                        bp.arr_Main = arr;
                        break;
                    }
                }
            }
        }
        if ([string isEqualToString:@"TrainPlan"]) {
            bp.Type = 3;
            bp.model_Show_train = _Arr_trainArray[indexPath.row];
            for (NSArray *arr in _arr_Business) {
                for (MyProcurementModel *models in arr) {
                    if ([models.fieldName isEqualToString:@"PassengerId"]) {
                        bp.arr_Main = arr;
                        break;
                    }
                }
            }
        }
        [self.navigationController pushViewController:bp animated:YES];
    }
}

//删除需求单
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tbv_travelRoute) {
        [_arr_travelRoute removeObjectAtIndex:indexPath.row];
        CGFloat height = [self getTravelRouteTableHeight];
        [_view_travelRoute updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(60 + height);
        }];
        _tbv_travelRoute.frame = CGRectMake(0, 60, Main_Screen_Width, height);
        [_tbv_travelRoute reloadData];
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if (indexPath.section == 0 ) {
                [_Arr_planeTicketArray removeObjectAtIndex:indexPath.row];
            }
            if (indexPath.section == 1 ) {
                [_Arr_homeArray removeObjectAtIndex:indexPath.row];
            }
            if (indexPath.section == 2 ) {
                [_Arr_trainArray removeObjectAtIndex:indexPath.row];
            }
            
            _tbv_Demand.frame = CGRectMake(0, 0, Main_Screen_Width, _Arr_Demand.count*60+_Arr_homeArray.count*58+_Arr_trainArray.count*58+_Arr_planeTicketArray.count*58);
            [_view_Demand updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.Arr_Demand.count*60+self.Arr_homeArray.count*58+self.Arr_trainArray.count*58+self.Arr_planeTicketArray.count*58);
            }];
            [self.tbv_Demand reloadData];
        }
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _pic_HasInvoice) {
        return _arr_HasInvoice.count;
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _pic_HasInvoice) {
        return _arr_HasInvoice[row];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _pic_HasInvoice) {
    }
}

//MARK:第一次提交验证
-(void)checkTravelReimSubmit{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",CLAIMBUDGET];
    NSDictionary *parameters = @{@"ExpenseCatCode":self.str_ExpenseCatCode,
                                 @"ExpenseCat":self.str_ExpenseCat,
                                 @"ExpenseType":self.str_ExpenseType,
                                 @"ExpenseCode":self.str_ExpenseCode,
                                 @"CostCenterId":self.FormData.personalData.CostCenterId,
                                 @"CostCenter":self.FormData.personalData.CostCenter,
                                 @"Amount":self.filedModel.AdvanceAmount,
                                 @"ExpIds":@"",
                                 @"FlowCode":@"F0001",
                                 @"ProjId":self.FormData.personalData.ProjId,
                                 @"ProjName":self.FormData.personalData.ProjName,
                                 @"AdvanceTaskId":@"0",
                                 @"OtherTaskId":@"0",
                                 @"UserId":self.FormData.personalData.RequestorUserId
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:14 IfUserCache:NO];
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
