//
//  NewAddCostApproveViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/9/4.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NewAddCostApproveViewController.h"
#import "CategoryCollectCell.h"
#import "HClActionSheet.h"
#import "ChooseCategoryModel.h"
#import "NewAddCostModel.h"
#import "NewAddressViewController.h"
#import "buildCellInfo.h"
#import "PdfReadViewController.h"
#import "PDFLookViewController.h"
#import "MyProcurementModel.h"
#import "ReservedView.h"
#import "RouteDetailView.h"
#import "MapRecordController.h"

static NSString *const CellIdentifier = @"addCostCell";

@interface NewAddCostApproveViewController ()<GPClientDelegate,UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

//框架用view
@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView
@property (nonatomic, strong) UIView *view_DockView; //底部按钮视图

@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

@property (nonatomic, strong) UIAlertView *alt_Warring;//弹出超预算框
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *imageTypeArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;//图片数组
//内部视图
@property (nonatomic, strong) UIView *view_Amount;//金额视图
@property (nonatomic, strong) UITextField *txf_Amount;

@property (nonatomic, strong) UIView *view_CurrencyCode;//币种视图
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
@property (nonatomic, strong) NSMutableArray *muarr_CurrencyCode;//项目名称显示用数据
@property (nonatomic, strong) NSString *str_CurrencyCode;
@property (nonatomic, strong) NSString *str_CurrencyCode_PlaceHolder;
@property (nonatomic, strong) UIPickerView *pic_CurrencyCode;
@property (nonatomic, strong) NSString *str_Currency;

@property (nonatomic, strong) UIView *view_ExchangeRate;//汇率
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
@property (nonatomic, strong) NSString *str_ExchangeRate;

@property (nonatomic, strong) UIView *view_LocalCyAmount;//本位币视图
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;

@property (nonatomic, strong) UIView *view_InvoiceType;//发票类型
@property (nonatomic, strong) UITextField *txf_InvoiceType;
@property (nonatomic, strong) NSMutableArray *arr_InvoiceType;
@property (nonatomic, strong) UIPickerView *pic_InvoiceType;
@property (nonatomic, strong) NSString *str_InvoiceType;

@property (nonatomic, strong) UIView *view_TaxRate;//税率
@property (nonatomic, strong) UITextField *txf_TaxRate;

@property (nonatomic, strong) UIView *view_Tax;//税额
@property (nonatomic, strong) UITextField *txf_Tax;

@property (nonatomic, strong) UIView *view_ExclTax;//不含税金额
@property (nonatomic, strong) UITextField *txf_ExclTax;

@property (nonatomic, strong) UIView *view_ClaimType;//报销类型
@property (nonatomic, strong) UITextField *txf_ClaimType;
@property (nonatomic, strong) UIPickerView *pic_ClaimType;
@property (nonatomic, strong) NSString *str_ClaimType;

@property (nonatomic, strong) UIView *view_ExpenseCode;//费用类别
@property (nonatomic, strong) UITextField *txf_ExpenseCode;
@property (nonatomic, strong) UIImageView *img_ExpenseCode;
@property (nonatomic, strong) UICollectionView *col_CategoryCollectView;//费用类别collectView
@property (nonatomic, strong) UICollectionViewFlowLayout *colayout_CategoryLayOut;
@property (nonatomic, strong) CategoryCollectCell *col_cell;
@property (nonatomic, strong) UIImageView *img_CateImage;//费用类别image
@property (nonatomic, strong) UIView *view_ExpenseCode_Click;//费用类别选择后
@property (nonatomic, strong) NSString *str_expenseCode;//费用类别编码
@property (nonatomic, strong) NSString *str_expenseIcon;//费用类别图片编码
@property (nonatomic, strong) NSString *str_ExpenseCat;//费用大类
@property (nonatomic, strong) NSString *expenseType;


@property (nonatomic, strong) UILabel *lab_ChangeExpenseAlert;//费用类别


@property (nonatomic, strong) WorkFormFieldsModel *model_Files;
@property (nonatomic, strong) NSMutableArray *arr_FilesTotle;
@property (nonatomic, strong) NSMutableArray *arr_FilesImage;

@property (nonatomic, strong) NSDictionary *dic_ExpenseCode_requst;
@property (nonatomic, strong) NSMutableArray *muarr_ExpenseCode;//更新后显示用数据

@property (nonatomic, strong) NSString *str_ExpenseCode_level;
@property (nonatomic, assign) NSInteger inte_ExpenseCode_Rows;
@property (nonatomic, assign) BOOL bool_isOpenGener;//费用类型是否打开的
@property (nonatomic, strong) NSString *str_ExpenseCatCode;//费用大类代码
@property (nonatomic, strong) NSString *str_expenseCode_tag;//费用大类
@property (nonatomic, strong) SubmitFormView *sub_Expense;

@property (nonatomic, strong) UIView *view_ExpenseDate;//日期
@property (nonatomic, strong) UITextField *txf_ExpenseDate;
@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;//

@property (nonatomic, strong) UIView *view_InvoiceNo;//发票号码
@property (nonatomic, strong) UITextField *txf_InvoiceNo;

@property (nonatomic, strong) UIView *view_HasInvoice;//是否有发票
@property (nonatomic, copy) NSString *str_HasInvoice;
@property (nonatomic, strong) NSMutableArray *array_HasInvoice;


@property (nonatomic, strong) UIView *view_NoInvReason;//原因
@property (nonatomic, strong) UITextField *txf_NoInvReason;

@property (nonatomic, strong) UIView *view_ReplExpense;//替票费用类别
@property (nonatomic, strong) UITextField *txf_ReplExpense;//替票费用类别文字
@property (nonatomic, copy) NSString *str_ReplExpenseType;//替票类型



@property (nonatomic, strong) UIView *view_ThreePartPdf;//三方PDF

@property (nonatomic, strong) UIView *view_Attachments;//上传发票
@property (nonatomic, strong) UICollectionViewFlowLayout *col_layOut;//网格规则
@property (nonatomic, strong) NSString *str_imageDataString;//上传服务器图片
@property (nonatomic, strong) UIAlertView *art_deleteImagesAler;//删除图片警告框

@property (nonatomic, strong) UIView *view_CostCenterId;//成本中心
@property (nonatomic, strong) UITextField *txf_CostCenterId;
@property (nonatomic, strong) NSString *str_CostCenterId;
@property (nonatomic, strong) NSString *str_CostCenterId_PlaceHolder;

@property (nonatomic, strong) UIView *view_ProjId;//项目名称
@property (nonatomic, strong) UITextField *txf_ProjId;
@property (nonatomic, strong) NSString *str_ProjId;
@property (nonatomic, strong) NSString *str_ProjId_PlaceHolder;
@property (nonatomic, strong) NSString *str_ProjMgrUserId;//项目负责人ID
@property (nonatomic, strong) NSString *str_ProjMgr;//项目负责人

@property (nonatomic, strong) UIView *View_ProjActivity;//项目活动视图
@property (nonatomic, strong) UITextField *txf_ProjActivity;
@property (nonatomic, copy) NSString *str_ProjectActivityLv1;
@property (nonatomic, copy) NSString *str_ProjectActivityLv1Name;
@property (nonatomic, copy) NSString *str_ProjectActivityLv2;
@property (nonatomic, copy) NSString *str_ProjectActivityLv2Name;


@property (nonatomic, strong) UIView *view_ClientId;//客户名称
@property (nonatomic, strong) UITextField *txf_ClientId;
@property (nonatomic, strong) NSString *str_ClientId;

@property (nonatomic, strong) UIView *View_Supplier;
@property (nonatomic, strong) UITextField *txf_Supplier;
@property (nonatomic, strong) NSString *str_Supplier;

@property (nonatomic, strong) NSString *str_RequestUserId;

//费用描述
@property (nonatomic, strong) UIView *view_ExpenseDesc;
@property (nonatomic, strong) UITextField *txf_ExpenseDesc;

@property (nonatomic, strong) UIView *view_Remark;//备注
@property (nonatomic, strong) UITextView *txv_Remark;

@property (nonatomic, strong) UIView *view_RouteDetail;

//住宿
@property (nonatomic, strong) NSString *str_CityCode;
@property (nonatomic, strong) UITextField *txf_CityName;
@property (nonatomic, strong) NSString *str_CityType;
@property (nonatomic, strong) UITextField *txf_TotalDays;
@property (nonatomic, strong) UITextField *txf_Rooms;
@property (nonatomic, strong) UITextField *txf_HotelPrice;
@property (nonatomic, strong) NSDictionary *dic_CityCode;
@property (nonatomic, strong) UITextField *txf_CheckInDate;
@property (nonatomic, strong) UITextField *txf_CheckOutDate;

//餐饮
@property (nonatomic, strong) NSString *str_FellowOfficersId;
@property (nonatomic, strong) NSMutableArray *arr_FellowOfficersId;
@property (nonatomic, strong) UITextField *txf_FellowOfficers;
@property (nonatomic, strong) UITextField *txf_Breakfast;
@property (nonatomic, strong) UITextField *txf_Lunch;
@property (nonatomic, strong) UITextField *txf_Supper;
@property (nonatomic, strong) UITextField *txf_Flight;
@property (nonatomic, strong) UITextField *txf_CateringCo;//餐饮公司
@property (nonatomic, strong) UITextField *txf_TotalPeople;
@property (nonatomic, strong) UITextField *txf_MealsTotalDays;

//机票
@property (nonatomic, strong) UITextField *txf_FDCityName;
@property (nonatomic, strong) UITextField *txf_FACityName;
@property (nonatomic, strong) UITextField *txf_ClassName;
@property (nonatomic, strong) UITextField *txf_Discount;
@property (nonatomic, strong) UIPickerView *pic_Flight;
@property (nonatomic, strong) NSArray *arr_Flight;
@property (nonatomic, strong) NSString *str_Flight;

@property (nonatomic, strong) UITextField *txf_TDCityName;
@property (nonatomic, strong) UITextField *txf_TACityName;
@property (nonatomic, strong) UITextField *txf_SeatName;

@property (nonatomic, strong) UITextField *txf_SDCityName;
@property (nonatomic, strong) UITextField *txf_SACityName;
@property (nonatomic, strong) UITextField *txf_Mileage;
@property (nonatomic, strong) UITextField *txf_OilPrice;
@property (nonatomic, strong) NSString *str_OilPrice;
@property (nonatomic, strong) UITextField *txf_CarStd;
@property (nonatomic, strong) UITextField *txf_FuelBills;
@property (nonatomic, strong) UITextField *txf_Pontage;
@property (nonatomic, strong) UITextField *txf_ParkingFee;
@property (nonatomic, strong) UITextField *txf_StartMeter;//开始咪表
@property (nonatomic, strong) UITextField *txf_EndMeter;//结束咪表
@property (nonatomic, strong) UITextField *txf_SDepartureTime;
@property (nonatomic, strong) UITextField *txf_SArrivalTime;


@property (nonatomic, strong) UITextField *txf_AllowanceAmount;
@property (nonatomic, strong) UITextField *txf_AllowanceUnit;
@property (nonatomic, strong) UITextField *txf_OverStd;
@property (nonatomic, strong) UITextField *txf_Tag;
@property (nonatomic, strong) UITextField *txf_TransDCityName;
@property (nonatomic, strong) UITextField *txf_TransACityName;
@property (nonatomic, strong) UITextField *txf_TransFromDate;
@property (nonatomic, strong) UITextField *txf_TransToDate;
@property (nonatomic, strong) UITextField *txf_TransTotalDays;
@property (nonatomic, strong) UITextField *txf_TransType;
@property (nonatomic, strong) NSString *str_TransType;
@property (nonatomic, assign) NSInteger int_TransTimeType;//市内交通选择时间格式1:日期 2时间(默认)


//补贴
@property (nonatomic, strong) UITextField *txf_Day;
@property (nonatomic, strong) UITextField *txf_Money;
@property (nonatomic, strong) UITextField *txf_City;
@property (nonatomic, strong) NSString *str_City;
@property (nonatomic, strong) NSString *str_Day;
@property (nonatomic, strong) UITextField *txf_MealType;
@property (nonatomic, strong) UITextField *txf_MealAmount;
@property (nonatomic, strong) NSString *str_MealType;
@property (nonatomic, strong) NSString *str_MealAmount;
@property (nonatomic, strong) NSString *str_MealAmount1;
@property (nonatomic, strong) NSString *str_AllowanceCurrency;
@property (nonatomic, strong) NSString *str_AllowanceCurrencyCode;
@property (nonatomic, strong) NSString *str_AllowanceCurrencyRate;
@property (nonatomic, strong) NSArray *arr_Meal;
@property (nonatomic, strong) UIPickerView *pic_Meal;



//接待
@property (nonatomic, strong) UITextField *txf_ReceptionObject;//接待对象
@property (nonatomic, strong) UITextField *txf_ReceptionReason;//接待事由
@property (nonatomic, strong) UITextField *txf_ReceptionLocation;//接待地点
@property (nonatomic, strong) UITextField *txf_Visitor;//来访人员姓名和职位
@property (nonatomic, strong) UITextField *txf_VisitorDate;//来访时间
@property (nonatomic, strong) UITextField *txf_LeaveDate;//离开时间

//公司车辆
@property (nonatomic, strong) UITextField *txf_CorpCarDCityName;//起点
@property (nonatomic, strong) UITextField *txf_CorpCarACityName;//终点
@property (nonatomic, strong) UITextField *txf_CorpCarMileage;//里程(公里)
@property (nonatomic, strong) UITextField *txf_CorpCarFuelBills;//油费
@property (nonatomic, strong) UITextField *txf_CorpCarPontage;//路桥费
@property (nonatomic, strong) UITextField *txf_CorpCarParkingFee;//停车费
@property (nonatomic, strong) UITextField *txf_CorpCarNo;//车牌号
@property (nonatomic, strong) UITextField *txf_CorpCarFromDate;//用车期间开始
@property (nonatomic, strong) UITextField *txf_CorpCarToDate;//用车期间开始
@property (nonatomic, copy) NSString *str_CorpCarFromDate;//用车期间开始
@property (nonatomic, copy) NSString *str_CorpCarToDate;//用车期间结束

//加班用车Taxi
@property (nonatomic, strong) UITextField *txf_TaxiDCityName;//出发地
@property (nonatomic, strong) UITextField *txf_TaxiACityName;//目的
@property (nonatomic, strong) UITextField *txf_TaxiFromDate;//开始时间
@property (nonatomic, strong) UITextField *txf_TaxiToDate;//结束时间

//驻办
@property (nonatomic, strong) NSString *str_LocationId;
@property (nonatomic, strong) NSString *str_Location;
@property (nonatomic, strong) UITextField *txf_Location;
@property (nonatomic, strong) NSString *str_OfficeFromDate;
@property (nonatomic, strong) UITextField *txf_OfficeFromDate;
@property (nonatomic, strong) NSString *str_OfficeToDate;
@property (nonatomic, strong) UITextField *txf_OfficeToDate;
@property (nonatomic, strong) NSString *str_OfficeTotalDays;
@property (nonatomic, strong) UITextField *txf_OfficeTotalDays;
//驻外
@property (nonatomic, strong) NSString *str_BranchId;
@property (nonatomic, strong) NSString *str_Branch;
@property (nonatomic, strong) UITextField *txf_Branch;
@property (nonatomic, strong) NSString *str_OverseasFromDate;
@property (nonatomic, strong) UITextField *txf_OverseasFromDate;
@property (nonatomic, strong) NSString *str_OverseasToDate;
@property (nonatomic, strong) UITextField *txf_OverseasToDate;
@property (nonatomic, strong) NSString *str_OverseasTotalDays;
@property (nonatomic, strong) UITextField *txf_OverseasTotalDays;





//验证信息
@property (nonatomic, strong) NSString *str_Status;
@property (nonatomic, strong) NSString *str_Amount;
@property (nonatomic, strong) NSString *str_Amount2;
@property (nonatomic, strong) NSString *str_Amount3;
@property (nonatomic, strong) NSString *str_Unit;
@property (nonatomic, strong) NSString *str_Class;
@property (nonatomic, strong) NSString *str_Discount;
@property (nonatomic, strong) NSString *str_IsExpensed;
@property (nonatomic, strong) NSString *str_LimitMode;

//自定义字段
@property (nonatomic, strong) UIView *Reserved1View;
@property (nonatomic, strong) ReserverdMainModel *model_rs;

//存储数据
@property (nonatomic, strong) NSDictionary *dic_request;//请求后保存的数据
@property (nonatomic, strong) NSMutableArray *muarr_MainView;//显示用数组
@property (nonatomic, strong) NewAddCostModel *model_NewAddCost;//上传需用数据
@property (nonatomic, assign) int int_update;
@property (nonatomic, assign) int int_load;
@property (nonatomic, strong) NSArray *arr_expenseCodeList;
@property (nonatomic, assign) NSInteger before_Type;


@property (nonatomic, strong)MyProcurementModel *model_AllowanceFromDate;
@property (nonatomic, strong)MyProcurementModel *model_AllowanceToDate;
@property (nonatomic, strong)MyProcurementModel *model_TravelUserName;
@property (nonatomic, copy) NSString *str_TravelUserId;
@property (nonatomic, strong) UITextField *txf_AllowanceFromDate;
@property (nonatomic, strong) UITextField *txf_AllowanceToDate;

@property (nonatomic, copy) NSString *str_ReceptionFellowOfficers;//同行人员

@property (nonatomic, strong) NSString *str_Basis;//获取住宿报销类型

@property (nonatomic, assign) BOOL bool_firstIn;//是否第一次进


//验证信息
@property (nonatomic, strong) NSDictionary *dict_Standard;//标准集合1
@property (nonatomic, strong) NSDictionary *dict_Standard_StdOutput;//标准集合2
@property (nonatomic, strong) NSArray *arr_stdSelfDriveDtoList;


@property (nonatomic, strong) UIView *view_ReimPolicyUp;//报销政策视图
@property (nonatomic, strong) UIView *view_ReimPolicyDown;//报销政策视图
@property (nonatomic, strong) NSDictionary *dic_ReimPolicy;// 报销政策字典
@property (nonatomic, strong) UIView *view_PayType;//支付方式

@property (nonatomic, strong) NSString *str_AllowanceAmount;


@property (nonatomic, strong) NSMutableArray *arr_TaxRates;//税率数组
@property (nonatomic, strong) NSMutableArray *arr_ClaimType;//报销类型
@property (nonatomic, strong) NSString *str_InvoiceTypeName;
@property (nonatomic, strong) NSString *str_InvoiceTypeCode;

@property (nonatomic, strong) MyProcurementModel *model_mealType;//补贴类型(餐补)



@property (nonatomic, strong) UITableView *View_shareTable;//费用分摊视图
@property (nonatomic, strong) UIView *View_shareTotal;//费用分摊合计
@property (nonatomic, assign) BOOL bool_shareShow;//是否开启显示费用分摊
@property (nonatomic, strong) NSMutableArray *array_shareForm;//费用分摊控制显示数组
@property (nonatomic, strong) NSMutableArray *array_shareData;//费用分摊数据
@property (nonatomic, copy) NSString *str_shareTotal;//费用分摊合计
@property (nonatomic, copy) NSString *str_shareRatio;//费用分摊百分比
@property (nonatomic, copy) NSString *str_shareId;//费用分摊id
@property (nonatomic, assign) BOOL bool_isOpenShare;//费用分摊是否展开

/**
 辅助项目核算项
 */
@property (nonatomic, strong) UIView *View_AccountItem;
@property (nonatomic, strong) UITextField *txf_AccountItem;
@property (nonatomic, strong) NSString *str_AccountItemCode;
@property (nonatomic, strong) NSString *str_AccountItem;

/**
 发票币种对支付币种汇率视图
 */
@property (nonatomic, strong) UIView *View_InvCyPmtExchangeRate;
@property (nonatomic, strong) UITextField *txf_InvCyPmtExchangeRate;
@property (nonatomic, copy) NSString *str_InvCyPmtExchangeRate;
/**
 付款金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmount;
@property (nonatomic, strong) UITextField *txf_InvPmtAmount;
/**
 付款税额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtTax;
@property (nonatomic, strong) UITextField *txf_InvPmtTax;
/**
 付款不含税金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmountExclTax;
@property (nonatomic, strong) UITextField *txf_InvPmtAmountExclTax;

/**
 机票和燃油附加费合计视图
 */
@property (nonatomic, strong) UIView *View_AirlineFuelFee ;
@property (nonatomic, strong) GkTextField *txf_AirlineFuelFee ;
@property (nonatomic, copy) NSString *str_AirlineFuelFee ;

@property (nonatomic, strong) UIView *View_AirTicketPrice;
@property (nonatomic, strong) GkTextField *txf_AirTicketPrice;
@property (nonatomic, copy) NSString *str_AirTicketPrice;

@property (nonatomic, strong) UIView *View_DevelopmentFund;
@property (nonatomic, strong) GkTextField *txf_DevelopmentFund;
@property (nonatomic, copy) NSString *str_DevelopmentFund;

@property (nonatomic, strong) UIView *View_FuelSurcharge;
@property (nonatomic, strong) GkTextField *txf_FuelSurcharge;
@property (nonatomic, copy) NSString *str_FuelSurcharge;

@property (nonatomic, strong) UIView *View_OtherTaxes;
@property (nonatomic, strong) GkTextField *txf_OtherTaxes;
@property (nonatomic, copy) NSString *str_OtherTaxes;


@property (nonatomic, strong) UIView *View_Overseas;
@property (nonatomic, copy) NSString *str_Overseas;
@property (nonatomic, strong) UIView *View_Nationality;
@property (nonatomic, strong) UIView *View_TransactionCode;
@property (nonatomic, strong) UIView *View_HandmadePaper;


@end

@implementation NewAddCostApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"记一笔", nil) backButton:YES];
    [self initializeData];
    [self requestExpuserGetFormDataByProcIdAndTaskId];
}

#pragma mark - function
#pragma mark 视图处理
//创建根滚动视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    [_scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
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
    
    _view_DockView=[[UIView alloc]init];
    _view_DockView.backgroundColor=[UIColor grayColor];
    _view_DockView.userInteractionEnabled=YES;
    [self.view addSubview:_view_DockView];
    
    [_view_DockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    UIButton *addSave=[GPUtils createButton:CGRectMake(ScreenRect.size.width*3/7, 0, ScreenRect.size.width*4/7, 50)action:@selector(btn_block:) delegate:self];
    addSave.tag = 0;
    addSave.backgroundColor = Color_Blue_Important_20;
    [addSave setTitle:Custing(@"保存", nil)  forState:UIControlStateNormal];
    addSave.titleLabel.font=Font_filterTitle_17 ;
    [addSave setTitleColor:Color_form_TextFieldBackgroundColor forState:UIControlStateNormal];
    [_view_DockView addSubview:addSave];
    addSave.frame = CGRectMake(0, 0, ScreenRect.size.width, 50);
}

// 创建主视图
-(void)createMainView{
    
    _view_ReimPolicyUp=[[UIView alloc]init];
    _view_ReimPolicyUp.backgroundColor=Color_White_Same_20;
    [self.view_ContentView addSubview:_view_ReimPolicyUp];
    [_view_ReimPolicyUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view_ContentView);
    }];
    
    //报销类型视图
    _view_ClaimType = [[UIView alloc]init];
    _view_ClaimType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ClaimType];
    [_view_ClaimType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ReimPolicyUp.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //成本中心视图
    _view_CostCenterId = [[UIView alloc]init];
    _view_CostCenterId.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_CostCenterId];
    [_view_CostCenterId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ClaimType.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //费用类别视图
    _view_ExpenseCode = [[UIView alloc]init];
    _view_ExpenseCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseCode];
    [_view_ExpenseCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_CostCenterId.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _lab_ChangeExpenseAlert = [GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_Red_Weak_20 textAlignment:NSTextAlignmentLeft];
    _lab_ChangeExpenseAlert.backgroundColor = Color_White_Same_20;
    _lab_ChangeExpenseAlert.numberOfLines = 0;
    [self.view_ContentView addSubview:_lab_ChangeExpenseAlert];
    [_lab_ChangeExpenseAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseCode.bottom);
        make.left.right.equalTo(self.view_ContentView).offset(@12);
        make.right.equalTo(self.view_ContentView).offset(@-12);
        make.height.equalTo(0);
    }];

    //费用类别选择后试图
    _view_ExpenseCode_Click = [[UIView alloc]init];
    _view_ExpenseCode_Click.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseCode_Click];
    [_view_ExpenseCode_Click mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_ChangeExpenseAlert.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //金额视图
    _view_Amount = [[UIView alloc]init];
    _view_Amount.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Amount];
    [_view_Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseCode_Click.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //币种视图
    _view_CurrencyCode = [[UIView alloc]init];
    _view_CurrencyCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_CurrencyCode];
    [_view_CurrencyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Amount.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //汇率视图
    _view_ExchangeRate = [[UIView alloc]init];
    _view_ExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExchangeRate];
    [_view_ExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_CurrencyCode.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //本位币视图
    _view_LocalCyAmount = [[UIView alloc]init];
    _view_LocalCyAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_LocalCyAmount];
    [_view_LocalCyAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExchangeRate.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_InvCyPmtExchangeRate = [[UIView alloc]init];
    _View_InvCyPmtExchangeRate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_InvCyPmtExchangeRate];
    [_View_InvCyPmtExchangeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_LocalCyAmount.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_InvPmtAmount = [[UIView alloc]init];
    _View_InvPmtAmount.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_InvPmtAmount];
    [_View_InvPmtAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvCyPmtExchangeRate.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //发票类型视图
    _view_InvoiceType=[[UIView alloc]init];
    _view_InvoiceType.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_InvoiceType];
    [_view_InvoiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmount.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_AirTicketPrice = [[UIView alloc]init];
    _View_AirTicketPrice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_AirTicketPrice];
    [_View_AirTicketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_InvoiceType.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_DevelopmentFund = [[UIView alloc]init];
    _View_DevelopmentFund.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_DevelopmentFund];
    [_View_DevelopmentFund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirTicketPrice.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_FuelSurcharge = [[UIView alloc]init];
    _View_FuelSurcharge.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_FuelSurcharge];
    [_View_FuelSurcharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_DevelopmentFund.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_OtherTaxes = [[UIView alloc]init];
    _View_OtherTaxes.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_OtherTaxes];
    [_View_OtherTaxes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_FuelSurcharge.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];

    _View_AirlineFuelFee = [[UIView alloc]init];
    _View_AirlineFuelFee.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_AirlineFuelFee];
    [_View_AirlineFuelFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_OtherTaxes.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //税率视图
    _view_TaxRate=[[UIView alloc]init];
    _view_TaxRate.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_TaxRate];
    [_view_TaxRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AirlineFuelFee.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //税额视图
    _view_Tax=[[UIView alloc]init];
    _view_Tax.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Tax];
    [_view_Tax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TaxRate.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //不含税金额视图
    _view_ExclTax=[[UIView alloc]init];
    _view_ExclTax.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExclTax];
    [_view_ExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Tax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_InvPmtTax = [[UIView alloc]init];
    _View_InvPmtTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_InvPmtTax];
    [_View_InvPmtTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExclTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_InvPmtAmountExclTax = [[UIView alloc]init];
    _View_InvPmtAmountExclTax.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_InvPmtAmountExclTax];
    [_View_InvPmtAmountExclTax mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];

    
    //日期视图
    _view_ExpenseDate = [[UIView alloc]init];
    _view_ExpenseDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDate];
    [_view_ExpenseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_PayType = [[UIView alloc]init];
    _view_PayType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_PayType];
    [_view_PayType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //发票号码视图
    _view_InvoiceNo = [[UIView alloc]init];
    _view_InvoiceNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_InvoiceNo];
    [_view_InvoiceNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_PayType.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //是否有发票视图
    _view_HasInvoice = [[UIView alloc]init];
    _view_HasInvoice.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_HasInvoice];
    [_view_HasInvoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_InvoiceNo.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //无发票要原因视图
    _view_NoInvReason = [[UIView alloc]init];
    _view_NoInvReason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_NoInvReason];
    [_view_NoInvReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_HasInvoice.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //替票费用类别
    _view_ReplExpense = [[UIView alloc]init];
    _view_ReplExpense.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ReplExpense];
    [_view_ReplExpense mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_NoInvReason.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //三方PDF
    _view_ThreePartPdf = [[UIView alloc]init];
    _view_ThreePartPdf.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ThreePartPdf];
    [_view_ThreePartPdf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ReplExpense.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //上传发票视图
    _view_Attachments = [[UIView alloc]init];
    _view_Attachments.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Attachments];
    [_view_Attachments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ThreePartPdf.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _model_Files.view_View = [[UIView alloc]init];
    _model_Files.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Files.view_View];
    [_model_Files.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Attachments.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
  
    //项目名称视图
    _view_ProjId = [[UIView alloc]init];
    _view_ProjId.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ProjId];
    [_view_ProjId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Files.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_ProjActivity = [[UIView alloc]init];
    _View_ProjActivity.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_ProjActivity];
    [_View_ProjActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ProjId.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //客户视图
    _view_ClientId = [[UIView alloc]init];
    _view_ClientId.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ClientId];
    [_view_ClientId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_ProjActivity.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //客户视图
    _View_Supplier= [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ClientId.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_Overseas = [[UIView alloc]init];
    _View_Overseas.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Overseas];
    [_View_Overseas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_Nationality = [[UIView alloc]init];
    _View_Nationality.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Nationality];
    [_View_Nationality mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Overseas.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_TransactionCode = [[UIView alloc]init];
    _View_TransactionCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_TransactionCode];
    [_View_TransactionCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Nationality.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_HandmadePaper = [[UIView alloc]init];
    _View_HandmadePaper.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_HandmadePaper];
    [_View_HandmadePaper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_TransactionCode.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //费用描述
    _view_ExpenseDesc = [[UIView alloc]init];
    _view_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDesc];
    [_view_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_HandmadePaper.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_AccountItem = [[UIView alloc]init];
    _View_AccountItem.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_AccountItem];
    [_View_AccountItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseDesc.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //备注视图
    _view_Remark = [[UIView alloc]init];
    _view_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Remark];
    [_view_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AccountItem.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _Reserved1View=[[UIView alloc]init];
    _Reserved1View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved1View];
    [_Reserved1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Remark.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    _View_shareTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _View_shareTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_shareTable.delegate=self;
    _View_shareTable.dataSource=self;
    _View_shareTable.scrollEnabled=NO;
    _View_shareTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view_ContentView addSubview:_View_shareTable];
    [_View_shareTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_shareTotal = [[UIView alloc]init];
    _View_shareTotal.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_shareTotal];
    [_View_shareTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_shareTable.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_RouteDetail = [[UIView alloc]init];
    _view_RouteDetail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_RouteDetail];
    [_view_RouteDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_shareTotal.bottom).offset(@10);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_ReimPolicyDown=[[UIView alloc]init];
    _view_ReimPolicyDown.backgroundColor=Color_White_Same_20;
    [self.view_ContentView addSubview:_view_ReimPolicyDown];
    [_view_ReimPolicyDown updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_RouteDetail.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
}

//更新底视图
-(void)updateContentView{
    [self.view_ContentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_ReimPolicyDown.bottom).offset(@10);
    }];
    [self.view_ContentView layoutIfNeeded];
}

//更新视图
-(void)updateMainView{
    if (_muarr_MainView.count>0) {
        for (int i = 0; i<_muarr_MainView.count; i++) {
            MyProcurementModel *model = _muarr_MainView[i];
            if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
                if ([model.fieldName isEqualToString:@"Amount"]) {
                    [self update_AmountView:model];
                }else if ([model.fieldName isEqualToString:@"CurrencyCode"]) {
                    [self update_CurrencyCodeView:model];
                }else if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
                    [self update_ExchangeRateView:model];
                }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
                    [self update_LocalCyAmountView:model];
                }else if ([model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]) {
                    [self updateInvCyPmtExchangeRateView:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtAmount"]) {
                    [self updateInvPmtAmountView:model];
                }else if ([model.fieldName isEqualToString:@"InvoiceType"]) {
                    [self update_InvoiceTypeView:model];
                }else if ([model.fieldName isEqualToString:@"TaxRate"]) {
                    [self update_TaxRateView:model];
                }else if ([model.fieldName isEqualToString:@"Tax"]) {
                    [self update_TaxView:model];
                }else if ([model.fieldName isEqualToString:@"ExclTax"]) {
                    [self update_ExclTaxView:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtTax"]) {
                    [self updateInvPmtTaxViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]) {
                    [self updateInvPmtAmountExclTaxViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"ClaimType"]) {
                    [self update_ClaimTypeView:model];
                }else if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
                    [self update_ExpenseCodeView:model];
                }else if ([model.fieldName isEqualToString:@"ExpenseDate"]) {
                    [self update_ExpenseDateView:model];
                }else if ([model.fieldName isEqualToString:@"PayTypeId"]) {
                    [self update_PayTypeIdView:model];
                }else if ([model.fieldName isEqualToString:@"InvoiceNo"]) {
                    [self update_InvoiceNoView:model];
                }else if ([model.fieldName isEqualToString:@"HasInvoice"]) {
                    [self update_HasInvoiceView:model];
                }else if ([model.fieldName isEqualToString:@"NoInvReason"]) {
                    if (([self.str_HasInvoice isEqualToString:@"0"]||[self.str_HasInvoice isEqualToString:@"2"])&&[model.isShow floatValue]==1) {
                        [self update_NoInvReasonView:model];
                    }
                }else if ([model.fieldName isEqualToString:@"ReplExpenseCode"]) {
                    if ([self.str_HasInvoice isEqualToString:@"2"]&&[model.isShow floatValue]==1) {
                        [self update_ReplExpenseView:model];
                    }
                }else if ([model.fieldName isEqualToString:@"Attachments"]&&_totalArray.count>0) {
                    [self update_AttachmentsView:model];
                }else if ([model.fieldName isEqualToString:@"Files"]) {
                    [self update_FilesView:model];
                }else if ([model.fieldName isEqualToString:@"CostCenterId"]) {
                    [self update_CostCenterIdView:model];
                }else if ([model.fieldName isEqualToString:@"ProjId"]) {
                    [self update_ProjIdView:model];
                }else if ([model.fieldName isEqualToString:@"ProjectActivityLv1Name"]) {
                    [self updateProjectActivityView:model];
                }else if ([model.fieldName isEqualToString:@"ClientId"]) {
                    [self update_ClientIdView:model];
                }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
                    [self updateSupplierViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Overseas"]) {
                    [self updateOverseasView:model];
                }else if ([model.fieldName isEqualToString:@"Nationality"] && [self.str_Overseas isEqualToString:@"1"]) {
                    [self updateNationalityView:model];
                }else if ([model.fieldName isEqualToString:@"TransactionCode"] && [self.str_Overseas isEqualToString:@"1"]) {
                    [self updateTransactionCodeView:model];
                    
                }else if ([model.fieldName isEqualToString:@"HandmadePaper"] && [self.str_Overseas isEqualToString:@"1"]) {
                    [self updateHandmadePaperView:model];
                }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]) {
                    [self update_ExpenseDescView:model];
                }else if ([model.fieldName isEqualToString:@"AccountItem"]) {
                    [self updateAccountItemView:model];
                }else if ([model.fieldName isEqualToString:@"Remark"]) {
                    [self update_RemarkView:model];
                }else if ([model.fieldName isEqualToString:@"Reserved1"]){
                    [self updateReserved1ViewWithModel:model];
                }
            }
            //更新修改费用类别警告框
            if ((self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) && [self.ClaimType integerValue] != 3 && self.bool_IsAllowModCostCgyOrInvAmt) {
                  [self updateChangeExpenseAlertLab];
              }
            
            //显示数据
            if ([model.fieldName isEqualToString:@"ExpenseType"]) {
                _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_str_ExpenseCat,model.fieldValue]];;
            }
            if ([model.fieldName isEqualToString:@"ExpenseIcon"]) {
                if (_img_ExpenseCode==nil) {
                    _img_ExpenseCode = [UIImageView new];
                }
                _img_ExpenseCode.image = [UIImage imageNamed:model.fieldValue];
                _str_expenseIcon = model.fieldValue;
                [_sub_Expense setCateImg:_str_expenseIcon];
            }
            if ([model.fieldName isEqualToString:@"CostCenter"]) {
                _txf_CostCenterId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ProjName"]) {
                _txf_ProjId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ProjMgrUserId"]) {
                _str_ProjMgrUserId = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ProjMgr"]) {
                _str_ProjMgr = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ClientName"]) {
                _txf_ClientId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"Currency"]) {
                _txf_CurrencyCode.text = [NSString isEqualToNull:model.fieldValue]?model.fieldValue:Custing(@"人民币", nil);
            }
            
            if ([model.fieldName isEqualToString:@"Tag"]) {
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _str_expenseCode_tag = model.fieldValue;
//                    [self update_View_ExpenseCode_Click:model.fieldValue];
                }
            }
        }
        [self updateAirlineFuelFeeView];
    }
    if (_dic_route!=nil) {
        [self updateRouteDetailView];
    }
    if (_dic_ReimPolicy) {
        [self update_ReimPolicyView];
    }
    if ([NSString isEqualToNull:_dateSource]) {
        [self updatePdflookView];
    }
    
    if (self.bool_shareShow && self.array_shareData.count > 0 ) {
        [self updateShareTableView];
        [self createShareFootView];
        [_View_shareTable reloadData];
    }
}

//MARK:更新费用分摊明细
-(void)updateShareTableView{
    if (self.bool_isOpenShare) {
        NSInteger height=10;
        for (AddReimShareModel *model in self.array_shareData) {
            height=height+[ProcureDetailsCell AddReimShareCellHeightWithArray:self.array_shareForm WithModel:model];
        }
        [_View_shareTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        AddReimShareModel *model=self.array_shareData[0];
        NSInteger height=10+[ProcureDetailsCell AddReimShareCellHeightWithArray:self.array_shareForm WithModel:model];
        [_View_shareTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }
}

-(void)createShareFootView{
    [_View_shareTotal mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(50);
    }];
    UILabel *totol=[GPUtils createLable:CGRectMake(12, 0, XBHelper_Title_Width, 50) text:Custing(@"合计 :", nil)  font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_View_shareTotal addSubview:totol];
    
    UILabel *lab_sharePercent = [GPUtils createLable:CGRectMake(12+XBHelper_Title_Width+10, 0, Main_Screen_Width-12-XBHelper_Title_Width-10-12, 50) text:[NSString stringWithFormat:@"%@(%@%%)",[NSString isEqualToNull:self.str_shareTotal]?self.str_shareTotal:@"0",[NSString isEqualToNull:self.str_shareRatio]?self.str_shareRatio:@"0"] font:Font_Important_15_20 textColor:[self.str_shareRatio floatValue] > 100 ? Color_Red_Weak_20:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    [_View_shareTotal addSubview:lab_sharePercent];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 0, Main_Screen_Width-12, 0.5)];
    line.backgroundColor = Color_LineGray_Same_20;
    [_View_shareTotal addSubview:line];
}

//更新报销政策视图
-(void)update_ReimPolicyView{
    __weak typeof(self) weakSelf = self;
    ReimPolicyView *view=[[ReimPolicyView alloc]initWithFlowCode:@"" withBodydict:_dic_ReimPolicy withBaseViewHeight:^(NSInteger height, NSDictionary *date) {
        if ([date[@"location"]floatValue]==1) {
            [weakSelf.view_ReimPolicyDown updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }else{
            [weakSelf.view_ReimPolicyUp updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height);
            }];
        }
    }];
    view.clickBlock = ^(NSString *bodyUrl) {
        PDFLookViewController *pdf = [[PDFLookViewController alloc]init];
        pdf.url =bodyUrl;
        [self.navigationController pushViewController:pdf animated:YES];
    };
    if ([_dic_ReimPolicy[@"location"]floatValue]==1) {
        [_view_ReimPolicyDown addSubview:view];
    }else{
        [_view_ReimPolicyUp addSubview:view];
    }
}

//更新金额视图
-(void)update_AmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票金额", nil);
    }
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_Amount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Amount WithContent:_txf_Amount WithFormType:formViewEnterAmout WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    _txf_Amount.delegate = self;
    _txf_Amount.font = Font_Amount_21_20;
    [_view_Amount addSubview:view];
}

//更新币种视图
-(void)update_CurrencyCodeView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票币种", nil);
    }
    _txf_CurrencyCode = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_CurrencyCode WithContent:_txf_CurrencyCode WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    [_view_CurrencyCode addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_CurrencyCode = model.fieldValue;
        _txf_CurrencyCode.text = _str_Currency;
    }else{
        _txf_CurrencyCode.text = _str_Currency;
    }
}

//更新汇率视图
-(void)update_ExchangeRateView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款汇率", nil);
    }
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_ExchangeRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExchangeRate WithContent:_txf_ExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    _txf_ExchangeRate.delegate = self;
    [_view_ExchangeRate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_ExchangeRate=model.fieldValue;
        _txf_ExchangeRate.text=model.fieldValue;
    }else{
        _txf_ExchangeRate.text=[NSString stringWithFormat:@"%@",_str_ExchangeRate];
    }
}

//更新本位币金额视图
-(void)update_LocalCyAmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"报销金额", nil);
    }
    _txf_LocalCyAmount=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    _txf_LocalCyAmount.delegate = self;
    [_view_LocalCyAmount addSubview:view];
}

//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_InvCyPmtExchangeRate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_InvCyPmtExchangeRate WithContent:_txf_InvCyPmtExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.str_InvCyPmtExchangeRate = exchange;
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:local];
        weakSelf.txf_InvPmtTax.text = [NSString countTax:local taxrate:[NSString isEqualToNull:self.txf_TaxRate.text] ? self.txf_TaxRate.text:@"0"];
        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_InvPmtTax.text]];
    }];
    [_View_InvCyPmtExchangeRate addSubview:view];
}
//MARK:更新付款金额视图
-(void)updateInvPmtAmountView:(MyProcurementModel *)model{
    _txf_InvPmtAmount = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtAmount WithContent:_txf_InvPmtAmount WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    [_View_InvPmtAmount addSubview:view];
}
//更新发票类型视图
-(void)update_InvoiceTypeView:(MyProcurementModel *)model{
    if ((self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7)&&self.bool_IsAllowModCostCgyOrInvAmt) {
        model.isOnlyRead = @"0";
    }
    _txf_InvoiceType=[[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_view_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![weakSelf.str_InvoiceTypeCode isEqualToString:Model.Id]) {
                weakSelf.str_InvoiceType = Model.invoiceType;
                weakSelf.str_InvoiceTypeCode = Model.Id;
                weakSelf.str_InvoiceTypeName = Model.Type;
                weakSelf.txf_InvoiceType.text = Model.Type;
                [weakSelf updateInvoiceTypeViesWithType:1];
            }
        }];
        picker.typeTitle = Custing(@"发票类型", nil);
        picker.DateSourceArray = weakSelf.arr_InvoiceType;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    if ([NSString isEqualToNull:_str_InvoiceTypeName]) {
        _txf_InvoiceType.text = _str_InvoiceTypeName;
    }else{
        _txf_InvoiceType.text = @"";
    }
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_InvoiceType = [NSString stringWithFormat:@"%@",model.fieldValue];
    }
    [_view_InvoiceType addSubview:view];
    [_view_InvoiceType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}
//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    
        __weak typeof(self) weakSelf = self;
        BOOL edit = NO;
        if ((self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7)&&self.bool_IsAllowModCostCgyOrInvAmt) {
            edit = YES;
        }
        
        _txf_AirlineFuelFee = [[GkTextField alloc]init];
        SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_AirlineFuelFee WithContent:_txf_AirlineFuelFee WithFormType:edit ? formViewShowText:formViewShowAmount WithSegmentType:lineViewOnlyLine WithString:Custing(@"机票和燃油附加费合计", nil) WithInfodict:@{@"value1":self.str_AirlineFuelFee} WithTips:Custing(@"请输入机票和燃油附加费合计", nil) WithNumLimit:50];
        [_View_AirlineFuelFee addSubview:view];
        
        
        _txf_AirTicketPrice = [[GkTextField alloc]init];
        SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_AirTicketPrice WithContent:_txf_AirTicketPrice WithFormType:edit ? formViewEnterAmout:formViewShowAmount WithSegmentType:lineViewOnlyLine WithString:Custing(@"票价", nil) WithInfodict:@{@"value1":self.str_AirTicketPrice} WithTips:Custing(@"请输入票价", nil) WithNumLimit:50];
        view1.AmountChangedBlock = ^(NSString *amount) {
            weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_FuelSurcharge.text] afterPoint:2];
            NSString *airLoc = [weakSelf getLocalCyAmount];
            NSString *payLoc = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate] ? weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
            NSString *airLoc1 = payLoc;
            if ([weakSelf.str_InvoiceType floatValue] == 1 && [weakSelf.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
            }
            weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[weakSelf getLocalCyAmount] with:weakSelf.txf_Tax.text];
            
            weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
        };
        [_View_AirTicketPrice addSubview:view1];
        
        
        _txf_DevelopmentFund = [[GkTextField alloc]init];
        SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:_View_DevelopmentFund WithContent:_txf_DevelopmentFund WithFormType:edit ? formViewEnterAmout:formViewShowAmount WithSegmentType:lineViewOnlyLine WithString:Custing(@"民航发展基金", nil) WithInfodict:@{@"value1":self.str_DevelopmentFund} WithTips:Custing(@"请输入民航发展基金", nil) WithNumLimit:50];
        [_View_DevelopmentFund addSubview:view2];
        
        
        _txf_FuelSurcharge = [[GkTextField alloc]init];
        SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:_View_FuelSurcharge WithContent:_txf_FuelSurcharge WithFormType:edit ? formViewEnterAmout:formViewShowAmount WithSegmentType:lineViewOnlyLine WithString:Custing(@"燃油费附加费", nil) WithInfodict:@{@"value1":self.str_FuelSurcharge} WithTips:Custing(@"请输入燃油费附加费", nil) WithNumLimit:50];
        view3.AmountChangedBlock = ^(NSString *amount) {
            
            weakSelf.txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:amount with:weakSelf.txf_AirTicketPrice.text] afterPoint:2];
            NSString *airLoc = [weakSelf getLocalCyAmount];
            NSString *payLoc = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate] ? weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
            NSString *airLoc1 = payLoc;
            if ([weakSelf.str_InvoiceType floatValue] == 1 && [weakSelf.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
            }
            weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[weakSelf getLocalCyAmount] with:weakSelf.txf_Tax.text];
            
            weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
        };
        [_View_FuelSurcharge addSubview:view3];
        
        
        _txf_OtherTaxes = [[GkTextField alloc]init];
        SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:_View_OtherTaxes WithContent:_txf_OtherTaxes WithFormType:edit ? formViewEnterAmout:formViewShowAmount WithSegmentType:lineViewOnlyLine WithString:Custing(@"其他税费", nil) WithInfodict:@{@"value1":self.str_OtherTaxes} WithTips:Custing(@"请输入其他税费", nil) WithNumLimit:50];
        [_View_OtherTaxes addSubview:view4];
}
//更新税率视图
-(void)update_TaxRateView:(MyProcurementModel *)model{
    model.isOnlyRead = @"1";
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_TaxRate=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_TaxRate WithContent:_txf_TaxRate WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.txf_TaxRate.text = [NSString stringWithIdOnNO:Model.Type];
            NSString *airLoc = [weakSelf getLocalCyAmount];
            NSString *payLoc = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate] ? weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
            NSString *airLoc1 = payLoc;
            if ([weakSelf.str_InvoiceType floatValue] == 1 && [weakSelf.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:weakSelf.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
            }
            weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[weakSelf getLocalCyAmount] with:weakSelf.txf_Tax.text];
            
            weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
        }];
        picker.typeTitle=Custing(@"税率(%)", nil);
        picker.DateSourceArray=weakSelf.arr_TaxRates;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_view_TaxRate addSubview:view];
    [_view_TaxRate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_TaxRate.text = [NSString stringWithFormat:@"%.4f",[model.fieldValue floatValue]];
    }
}

//更新税额视图2.6.601
-(void)update_TaxView:(MyProcurementModel *)model{
    model.isOnlyRead = @"1";
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_Tax = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Tax WithContent:_txf_Tax WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    _txf_Tax.delegate = self;
    [_view_Tax addSubview:view];
    [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_TaxRate.text = [NSString stringWithFormat:@"%.4f",[model.fieldValue floatValue]];
    }
}

//更新不含税金额视图
-(void)update_ExclTaxView:(MyProcurementModel *)model{
    _txf_ExclTax=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExclTax WithContent:_txf_ExclTax WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    _txf_ExclTax.delegate = self;
    [_view_ExclTax addSubview:view];
    [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}
//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
    model.isOnlyRead = @"1";
    if (self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_InvPmtTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtTax WithContent:_txf_InvPmtTax WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate]?weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
        weakSelf.txf_InvPmtAmountExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:amount]];
    }];
    [_View_InvPmtTax addSubview:view];
    [_View_InvPmtTax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];

}

//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_InvPmtAmountExclTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtAmountExclTax WithContent:_txf_InvPmtAmountExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    [_View_InvPmtAmountExclTax addSubview:view];
    [_View_InvPmtAmountExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}
//更新报销类型视图
-(void)update_ClaimTypeView:(MyProcurementModel *)model{
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", _ClaimType];
    NSArray *filterArray = [_arr_ClaimType filteredArrayUsingPredicate:pred1];
    if (filterArray.count > 0) {
        STOnePickModel *model1 = filterArray[0];
        model.fieldValue = model1.Type;
    }
    _txf_ClaimType = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ClaimType WithContent:_txf_ClaimType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
//    __weak typeof(self) weakSelf = self;
//    [view setFormClickedBlock:^(MyProcurementModel *model){
//        UIButton *btn = [UIButton new];
//        btn.tag = 3;
//        [weakSelf btn_Click:btn];
//    }];
    [_view_ClaimType addSubview:view];

}

//更新费用类别视图
-(void)update_ExpenseCodeView:(MyProcurementModel *)model{
    if ((self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7) && [self.ClaimType integerValue] != 3&&self.bool_IsAllowModCostCgyOrInvAmt) {
        model.isOnlyRead = @"0";
    }

    _txf_ExpenseCode = [[UITextField alloc]init];
    _sub_Expense = [[SubmitFormView alloc]initBaseView:_view_ExpenseCode WithContent:_txf_ExpenseCode WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    _sub_Expense.CateClickedBlock = ^(MyProcurementModel *model, UIImageView *image) {
        weakSelf.img_ExpenseCode = image;
        UIButton *btn = [UIButton new];
        btn.tag = 4;
        [weakSelf btn_Click:btn];
    };
    [_view_ExpenseCode addSubview:_sub_Expense];
    if ([NSString isEqualToNull:_str_expenseIcon]) {
        [_sub_Expense setCateImg:_str_expenseIcon];
    }
    [_sub_Expense setCateImg:[NSString isEqualToNull:_str_expenseIcon]?_str_expenseIcon:@"15"];
    _txf_ExpenseCode.text = [NSString isEqualToNull:_expenseType]?_expenseType:@"";
    _str_expenseCode = [NSString isEqualToNull:model.fieldValue]?model.fieldValue:_str_expenseCode;
    
    _colayout_CategoryLayOut = [[UICollectionViewFlowLayout alloc] init];
    _colayout_CategoryLayOut.minimumInteritemSpacing =1;
    _colayout_CategoryLayOut.minimumLineSpacing =1;
    _col_CategoryCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_colayout_CategoryLayOut];
    _col_CategoryCollectView.delegate = self;
    _col_CategoryCollectView.dataSource = self;
    _col_CategoryCollectView.backgroundColor =Color_White_Same_20;
    _col_CategoryCollectView.scrollEnabled=NO;
    [_col_CategoryCollectView registerClass:[CategoryCollectCell class] forCellWithReuseIdentifier:@"CategoryCollectCell"];
    [_view_ExpenseCode addSubview:_col_CategoryCollectView];
    
    [_col_CategoryCollectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseCode.top).offset(@60);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
}
//MARK:更新修改费用类别警告框
-(void)updateChangeExpenseAlertLab{
    NSString *tips = Custing(@"修改费用类别时,报销标准不会随之改变,若需匹配相应的报销标准,请退回单据重新提交.", nil);
    CGFloat height = [tips sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-24, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height+8;
    [_lab_ChangeExpenseAlert updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    _lab_ChangeExpenseAlert.text = tips;
}
//更新日期视图
-(void)update_ExpenseDateView:(MyProcurementModel *)model{
    _txf_ExpenseDate = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExpenseDate WithContent:_txf_ExpenseDate WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 5;
        [weakSelf btn_Click:btn];
    }];
    [_view_ExpenseDate addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_ExpenseDate.text = model.fieldValue;
    }else{
        _txf_ExpenseDate.text = [NSString stringWithDate:[NSDate date]];
    }
}

-(void)update_PayTypeIdView:(MyProcurementModel *)model{
    model.fieldValue = [[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"2"] ? Custing(@"企业支付", nil):Custing(@"个人支付", nil);
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_PayType WithContent:[UITextField new] WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_PayType addSubview:view];
}

//更新发票
-(void)update_InvoiceNoView:(MyProcurementModel *)model{
    _txf_InvoiceNo=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_InvoiceNo WithContent:_txf_InvoiceNo WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_InvoiceNo addSubview:view];
    _txf_InvoiceNo.keyboardType = UIKeyboardTypeNumberPad;
}

//更新是否有发票视图
-(void)update_HasInvoiceView:(MyProcurementModel *)model{
    
    for (STOnePickModel *model1 in _array_HasInvoice) {
        if ([self.str_HasInvoice isEqualToString:model1.Id]) {
            model.fieldValue=model1.Type;
        }
    }
    UITextField *txf=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_HasInvoice WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_HasInvoice addSubview:view];
}

//更新无发票要原因视图
-(void)update_NoInvReasonView:(MyProcurementModel *)model{
    _txf_NoInvReason=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_NoInvReason WithContent:_txf_NoInvReason WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_NoInvReason addSubview:view];
}
//MARK:更新替票费用类别
-(void)update_ReplExpenseView:(MyProcurementModel *)model{
    _txf_ReplExpense=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ReplExpense WithContent:_txf_ReplExpense WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.str_ReplExpenseType}];
    [_view_ReplExpense addSubview:view];
}
-(void)updatePdflookView{
    BOOL isShow=NO;
    if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"12"]) {
        isShow=YES;
    }else if([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"16"]&&[_dic_request[@"result"][@"weiXinCardInv"] isKindOfClass:[NSDictionary class]]&&[NSString isEqualToNull:_dic_request[@"result"][@"weiXinCardInv"][@"pdf_url"]]){
        isShow=YES;
    }else if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"15"]&&[_dic_request[@"result"][@"baiWCloudInv"] isKindOfClass:[NSDictionary class]]&&[NSString isEqualToNull:_dic_request[@"result"][@"baiWCloudInv"][@"formatFile"]]){
        isShow=YES;
    }
    if (isShow) {
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ThreePartPdf WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNoneLine WithString:Custing(@"电子发票pdf文件", nil) WithTips:nil WithInfodict:nil];
        view.lab_title.textColor=Color_Blue_Important_20;
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            UIButton *btn = [UIButton new];
            btn.tag=16;
            [weakSelf btn_Click:btn];
        }];
        [_view_ThreePartPdf addSubview:view];
    }
}
//更新发票图片视图
-(void)update_AttachmentsView:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_view_Attachments withEditStatus:3 withModel:model];
    view.maxCount=10;
    [_view_Attachments addSubview:view];
    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];

}

//更新附件视图
-(void)update_FilesView:(MyProcurementModel *)model{
    [_model_Files.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@128);
    }];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_model_Files.view_View addSubview:titleLbl];
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 30, Main_Screen_Width, 88) withEditStatus:3];
    view.maxCount=5;
    [_model_Files.view_View addSubview:view];
    [view updateWithTotalArray:_arr_FilesTotle WithImgArray:_arr_FilesImage];
    
    UIView *views= [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    views.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view addSubview:views];
}

//更新成本中心视图
-(void)update_CostCenterIdView:(MyProcurementModel *)model{
    if ((self.int_comeEditType == 1 || self.int_comeEditType == 3 || self.int_comeEditType == 5 || self.int_comeEditType == 7)&&self.bool_IsAllowModCostCgyOrInvAmt) {
        model.isOnlyRead = @"0";
    }
    _txf_CostCenterId = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_CostCenterId WithContent:_txf_CostCenterId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 8;
        [weakSelf btn_Click:btn];
    }];
    [_view_CostCenterId addSubview:view];
    if ([NSString isEqualToNull:_model.costCenterId]) {
        _str_CostCenterId = _model.costCenterId;
    }
}

//更新项目名称视图
-(void)update_ProjIdView:(MyProcurementModel *)model{
    _txf_ProjId = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ProjId WithContent:_txf_ProjId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 9;
        [weakSelf btn_Click:btn];
    }];
    [_view_ProjId addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_ProjId = model.fieldValue;
    }
}
-(void)updateProjectActivityView:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.str_ProjectActivityLv1Name,self.str_ProjectActivityLv2Name] WithCompare:@"/"];
    _txf_ProjActivity = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_ProjActivity WithContent:_txf_ProjActivity WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_ProjActivity addSubview:view];
}
//更新客户视图
-(void)update_ClientIdView:(MyProcurementModel *)model{
    _txf_ClientId = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ClientId WithContent:_txf_ClientId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 18;
        [weakSelf btn_Click:btn];
    }];
    [_view_ClientId addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_ClientId = model.fieldValue;
    }
}
//MARK:供应商
-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    _txf_Supplier=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_Supplier WithContent:_txf_Supplier WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.str_Supplier}];
    [_View_Supplier addSubview:view];
}
//MARK:是否境外
-(void)updateOverseasView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
    }else{
        model.fieldValue = Custing(@"否", nil);
    }
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Overseas WithContent:[[UITextField alloc]init] WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Overseas addSubview:view];
}

//MARK:国别
-(void)updateNationalityView:(MyProcurementModel *)model{
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_Nationality WithContent:[[UITextField alloc]init] WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_Nationality addSubview:view];
}
//MARK:交易代码
-(void)updateTransactionCodeView:(MyProcurementModel *)model{
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_TransactionCode WithContent:[[UITextField alloc]init] WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_TransactionCode addSubview:view];
}
//MARK:是否手工票据
-(void)updateHandmadePaperView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
    }else{
        model.fieldValue = Custing(@"否", nil);
    }
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_HandmadePaper WithContent:[[UITextField alloc]init] WithFormType:formViewShowText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_View_HandmadePaper addSubview:view];
}

//更新费用描述视图
-(void)update_ExpenseDescView:(MyProcurementModel *)model{
    _txf_ExpenseDesc=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExpenseDesc WithContent:_txf_ExpenseDesc WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_ExpenseDesc addSubview:view];
}
//更新辅助核算视图
-(void)updateAccountItemView:(MyProcurementModel *)model{
    if (self.int_comeEditType == 4 || self.int_comeEditType == 5 || self.int_comeEditType == 6 || self.int_comeEditType == 7) {
        model.isOnlyRead = @"0";
    }
    _txf_AccountItem = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_View_AccountItem WithContent:_txf_AccountItem WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"AccountItem"];
//        vc.ChooseCategoryId = self.str_AccountItemCode;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_AccountItemCode = model.accountItemCode;
            weakSelf.txf_AccountItem.text = [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem] WithCompare:@"/"];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_View_AccountItem addSubview:view];
   
}

//更新备注视图
-(void)update_RemarkView:(MyProcurementModel *)model{
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_view_Remark addSubview:view];
}

//MARK:更新通用审批自定义字段
-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved1View addSubview:[[ReserverdMainView alloc]initArr:_muarr_MainView isRequiredmsdic:[NSMutableDictionary dictionary] reservedDic:[NSMutableDictionary dictionary] UnShowmsArray:[NSMutableArray array] view:_Reserved1View model:_model_rs block:^(NSInteger height) {
        [weakSelf.Reserved1View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//费用类别选择后
-(void)update_View_ExpenseCode_Click:(NSString *)tip{
    NSMutableArray *arr_Expense_Click = [NSMutableArray array];
    NSArray *arr_Expense_temporary;
    NSInteger cell_height = 0;
    
    if ([tip isEqualToString:@"Hotel"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"hotelFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"hotelFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
                if ([dic[@"fieldName"]isEqualToString:@"CityCode"]&&[NSString isEqualToNull:dic[@"fieldValue"]]) {
                    _str_CityCode = dic[@"fieldValue"];
                }
                if ([dic[@"fieldName"]isEqualToString:@"CityType"]&&[NSString isEqualToNull:dic[@"fieldValue"]]) {
                    _str_CityType = dic[@"fieldValue"];
                }
            }
            if ([NSString isEqualToNull:_str_CityCode]&&[NSString isEqualToNull:_str_CityType]) {
                [self requestGetExpStd];
            }
        }
    }else if ([tip isEqualToString:@"Meals"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"mealsFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"mealsFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
        }
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Flight"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"flightFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"flightFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
        }
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Train"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"trainFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"trainFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
        }
    }else if ([tip isEqualToString:@"SelfDrive"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"selfDriveFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"selfDriveFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
            if ([[self getStandardAmountWithKey:@"basis"]floatValue] == 3) {
                cell_height = cell_height+1;
                NSArray *arr=@[@{@"isShow": @1,
                                 @"tips": Custing(@"请输入油价", nil),
                                 @"isRequired": @0,
                                 @"fieldName": @"OilPrice",
                                 @"description":Custing(@"油价", nil)}];
                for (NSDictionary *dic in arr) {
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr_Expense_Click insertObject:model atIndex:0];
                }
            }
        }
    }else if ([tip isEqualToString:@"Hospitality"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"hospitality"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"hospitality"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
        }
    }else if ([tip isEqualToString:@"CorpCar"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"corpCar"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"corpCar"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"fieldName"] isEqualToString:@"CorpCarFromDate"]) {
                    cell_height = [dic[@"isShow"]integerValue]==1?cell_height+2:cell_height;
                    MyProcurementModel *model = [MyProcurementModel new];
                    model.Description=Custing(@"开始时间", nil);
                    model.isShow=[NSNumber numberWithInteger:[dic[@"isShow"]integerValue]];
                    model.fieldValue=[NSString stringWithIdOnNO:_str_CorpCarFromDate];
                    model.fieldName=@"CorpCarFromDate";
                    [arr_Expense_Click addObject:model];
                    
                    MyProcurementModel *model1 = [MyProcurementModel new];
                    model1.Description=Custing(@"结束时间", nil);
                    model1.isShow=[NSNumber numberWithInteger:[dic[@"isShow"]integerValue]];
                    model1.fieldName=@"CorpCarToDate";
                    model1.fieldValue=[NSString stringWithIdOnNO:_str_CorpCarToDate];
                    [arr_Expense_Click addObject:model1];
                }else{
                    cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr_Expense_Click addObject:model];
                }
            }
        }
    }else if ([tip isEqualToString:@"Allowance"]||[tip isEqualToString:@"Other"]||[tip isEqualToString:@"Medical"]) {
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Trans"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"transFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"transFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0) {
                MyProcurementModel *model1 = [MyProcurementModel new];
                model1.isShow=@1;
                model1.fieldName=@"AllowanceAmount";
                model1.Description=Custing(@"补贴标准", nil);
                cell_height++;
                [arr_Expense_Click addObject:model1];
            }
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"fieldName"]isEqualToString:@"TransType"]) {
                    _str_TransType=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
                }else{
                    cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    if ([model.fieldName isEqualToString:@"TransFromDate"]) {
                        _int_TransTimeType=[[NSString stringWithFormat:@"%@",model.ctrlTyp]isEqualToString:@"transday"]?1:2;
                    }
                    [arr_Expense_Click addObject:model];
                }
            }
        }
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Taxi"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"taxi"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"taxi"]:[NSArray array];
        for (NSDictionary *dic in arr_Expense_temporary) {
            cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr_Expense_Click addObject:model];
        }
    }else if ([tip isEqualToString:@"Office"]) {
        cell_height = cell_height+4;
        NSArray *arr=@[@{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"Location",
                         @"description":Custing(@"办事处", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OfficeFromDate",
                         @"description":Custing(@"开始时间", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OfficeToDate",
                         @"description":Custing(@"结束时间", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OfficeTotalDays",
                         @"description":Custing(@"天数", nil)}];
        for (NSDictionary *dic in arr) {
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr_Expense_Click addObject:model];
        }
    }else if ([tip isEqualToString:@"Overseas"]) {
        cell_height = cell_height+4;
        NSArray *arr=@[@{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"Branch",
                         @"description":Custing(@"公司", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OverseasFromDate",
                         @"description":Custing(@"开始时间", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OverseasToDate",
                         @"description":Custing(@"结束时间", nil)},
                       @{@"isShow": @1,
                         @"isRequired": @1,
                         @"fieldName": @"OverseasTotalDays",
                         @"description":Custing(@"天数", nil)}];
        for (NSDictionary *dic in arr) {
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr_Expense_Click addObject:model];
        }
    }else{
        _bool_firstIn=NO;
    }

    
    for(UIView *view in [_view_ExpenseCode_Click subviews])
    {
        [view removeFromSuperview];
    }
    
    [_view_ExpenseCode_Click updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(cell_height*50);
    }];
    
    for (int i = 0; i<arr_Expense_Click.count; i++) {
        MyProcurementModel *model = arr_Expense_Click[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            if ([tip isEqualToString:@"CorpCar"]||[tip isEqualToString:@"Hospitality"]||[tip isEqualToString:@"Taxi"]||[tip isEqualToString:@"Office"]||[tip isEqualToString:@"Overseas"]) {
                UIView *baseView=[[UIView alloc]init];
                [_view_ExpenseCode_Click addSubview:baseView];
                [baseView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                    make.left.width.equalTo(self.view_ExpenseCode_Click);
                }];
                if ([model.fieldName isEqualToString:@"ReceptionObject"]) {
                    _txf_ReceptionObject=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionObject WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionReason"]){
                    _txf_ReceptionReason=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionReason WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionLocation"]){
                    _txf_ReceptionLocation=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionLocation WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"Visitor"]){
                    _txf_Visitor=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Visitor WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"VisitorDate"]){
                    _txf_VisitorDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_VisitorDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                    
                }else if ([model.fieldName isEqualToString:@"LeaveDate"]){
                    _txf_LeaveDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_LeaveDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionFellowOfficersId"]){
                    UITextField *txf =[[UITextField alloc]init];
                    model.fieldValue=[NSString stringWithIdOnNO:self.str_ReceptionFellowOfficers];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionTotalPeople"]){
                    UITextField *txf=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionCateringCo"]){
                    UITextField *txf=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:txf WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarDCityName"]){
                    _txf_CorpCarDCityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarDCityName WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarACityName"]){
                    _txf_CorpCarACityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarACityName WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarMileage"]){
                    _txf_CorpCarMileage=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarMileage WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarFuelBills"]){
                    _txf_CorpCarFuelBills=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarFuelBills WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarPontage"]){
                    _txf_CorpCarPontage=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarPontage WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarParkingFee"]){
                    _txf_CorpCarParkingFee=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarParkingFee WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarNo"]){
                    _txf_CorpCarNo=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarNo WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                    
                }else if ([model.fieldName isEqualToString:@"CorpCarFromDate"]){
                    _txf_CorpCarFromDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarFromDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                    
                }else if ([model.fieldName isEqualToString:@"CorpCarToDate"]){
                    _txf_CorpCarToDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarToDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiDCityName"]){
                    _txf_TaxiDCityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiDCityName WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiACityName"]){
                    _txf_TaxiACityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiACityName WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiFromDate"]){
                    _txf_TaxiFromDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiFromDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiToDate"]){
                    _txf_TaxiToDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiToDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"Location"]){
                    _txf_Location=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Location WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_Location}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeFromDate"]){
                    _txf_OfficeFromDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeFromDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeFromDate}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeToDate"]){
                    _txf_OfficeToDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeToDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeToDate}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeTotalDays"]){
                    _txf_OfficeTotalDays=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeTotalDays WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeTotalDays}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Branch"]){
                    _txf_Branch=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Branch WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_Branch}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasFromDate"]){
                    _txf_OverseasFromDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasFromDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasFromDate}];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasToDate"]){
                    _txf_OverseasToDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasToDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasToDate}];
                    self.str_OverseasToDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasTotalDays"]){
                    _txf_OverseasTotalDays=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasTotalDays WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasTotalDays}];
                    [baseView addSubview:view];
                }
            }else{
                [_view_ExpenseCode_Click addSubview:[self createLineViewOfHeight_ByTitle:(i*50)-0.5]];
                UILabel *title=[GPUtils createLable:CGRectMake(12,(i*50),XBHelper_Title_Width, 50) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
                title.numberOfLines = 2;
                [_view_ExpenseCode_Click addSubview:title];
                
                if ([model.fieldName isEqualToString:@"CityCode"]) {
                    _txf_CityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CityName.delegate=self;
                    _txf_CityName.keyboardType =UIKeyboardTypeNumberPad;
                    _txf_CityName.userInteractionEnabled = NO;
                    _txf_ClassName.textAlignment = NSTextAlignmentRight;
                    [_view_ExpenseCode_Click addSubview:_txf_CityName];
                    
                    UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                    iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                    [_view_ExpenseCode_Click addSubview:iconImage];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 12;
                    [_view_ExpenseCode_Click addSubview:btn];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _str_CityCode = model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_CityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"CheckInDate"]) {
                    _txf_CheckInDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CheckInDate.delegate=self;
                    _txf_CheckInDate.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_CheckInDate];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_CheckInDate.text=model.fieldValue;
                    }
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 24;
                    [_view_ExpenseCode_Click addSubview:btn];
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_CheckInDate.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"CheckOutDate"]) {
                    _txf_CheckOutDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CheckOutDate.delegate=self;
                    _txf_CheckOutDate.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_CheckOutDate];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_CheckOutDate.text=model.fieldValue;
                    }
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 25;
                    [_view_ExpenseCode_Click addSubview:btn];
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_CheckOutDate.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"TotalDays"]) {
                    _txf_TotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TotalDays.delegate=self;
                    _txf_TotalDays.keyboardType =UIKeyboardTypeNumberPad;
                    [_view_ExpenseCode_Click addSubview:_txf_TotalDays];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TotalDays.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_TotalDays.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"HotelName"]) {
                    UITextField *txf_TotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    txf_TotalDays.delegate=self;
                    txf_TotalDays.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:txf_TotalDays];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        txf_TotalDays.text=model.fieldValue;
                    }
                   
                }else if ([model.fieldName isEqualToString:@"Rooms"]) {
                    _txf_Rooms = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Rooms.delegate=self;
                    _txf_Rooms.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_Rooms];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Rooms.text=[NSString stringWithFormat:@"%@",model.fieldValue];
                    }
                }else if ([model.fieldName isEqualToString:@"HotelPrice"]) {
                    _txf_HotelPrice = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_HotelPrice.delegate=self;
                    _txf_HotelPrice.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_HotelPrice];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_HotelPrice.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_HotelPrice.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"FellowOfficersId"]) {
                    
                    _txf_FellowOfficers = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    [_view_ExpenseCode_Click addSubview:_txf_FellowOfficers];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FellowOfficers.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"TotalPeople"]) {
                    _txf_TotalPeople = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TotalPeople.delegate=self;
                    [_view_ExpenseCode_Click addSubview:_txf_TotalPeople];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TotalPeople.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"MealsTotalDays"]) {
                    UIView *baseView = [[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_MealsTotalDays = [[UITextField alloc]init];
                    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_MealsTotalDays WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Breakfast"]) {
                    _txf_Breakfast = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Breakfast.delegate=self;
                    _txf_Breakfast.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Breakfast];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Breakfast.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Breakfast.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Lunch"]) {
                    _txf_Lunch = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Lunch.delegate=self;
                    _txf_Lunch.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Lunch];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Lunch.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Lunch.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Supper"]) {
                    _txf_Supper = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Supper.delegate=self;
                    _txf_Supper.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Supper];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Supper.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Supper.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Flight"]) {
                    _txf_Flight = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Flight.delegate=self;
                    _txf_Flight.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Flight];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Flight.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Flight.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"CateringCo"]) {
                    _txf_CateringCo = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CateringCo.delegate=self;
                    _txf_CateringCo.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_CateringCo];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_CateringCo.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_CateringCo.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"FDCityName"]) {
                    _txf_FDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FDCityName.delegate=self;
                    _txf_FDCityName.keyboardType = UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_FDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FDCityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_FDCityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"FACityName"]) {
                    _txf_FACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FACityName.delegate=self;
                    _txf_FACityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_FACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FACityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_FACityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"ClassName"]) {
                    _txf_ClassName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42-10, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_ClassName.delegate=self;
                    _txf_ClassName.keyboardType =UIKeyboardTypeNumberPad;
                    _txf_ClassName.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_ClassName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        if ([model.fieldValue floatValue]==1) {
                            _txf_ClassName.text=Custing(@"经济舱", nil);
                        }else if ([model.fieldValue floatValue]==2){
                            _txf_ClassName.text=Custing(@"商务舱", nil);
                        }else if ([model.fieldValue floatValue]==3){
                            _txf_ClassName.text=Custing(@"头等舱", nil);
                        }
                    }
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 13;
                    [_view_ExpenseCode_Click addSubview:btn];
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_ClassName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Discount"]) {
                    _txf_Discount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Discount.delegate=self;
                    _txf_Discount.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Discount];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Discount.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Discount.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"TDCityName"]) {
                    _txf_TDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TDCityName.delegate=self;
                    _txf_TDCityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_TDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TDCityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_TDCityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"TACityName"]) {
                    _txf_TACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TACityName.delegate=self;
                    _txf_TACityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_TACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TACityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_TACityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"SeatName"]) {
                    _txf_SeatName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_SeatName.delegate=self;
                    _txf_SeatName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_SeatName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_SeatName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_SeatName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"OilPrice"]){
                    _txf_OilPrice = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    [_view_ExpenseCode_Click addSubview:_txf_OilPrice];
                    if ([NSString isEqualToNull:self.str_OilPrice]) {
                        _txf_OilPrice.text=self.str_OilPrice;
                    }
                }else if ([model.fieldName isEqualToString:@"SDCityName"]) {
                    _txf_SDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_SDCityName.delegate=self;
                    _txf_SDCityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_SDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_SDCityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_SDCityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"SACityName"]) {
                    _txf_SACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_SACityName.delegate=self;
                    _txf_SACityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_SACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_SACityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_SACityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"StartMeter"]) {
                    _txf_StartMeter = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_StartMeter.delegate=self;
                    _txf_StartMeter.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_StartMeter];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_StartMeter.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_StartMeter.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"EndMeter"]) {
                    _txf_EndMeter = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_EndMeter.delegate=self;
                    _txf_EndMeter.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_EndMeter];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_EndMeter.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_EndMeter.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Mileage"]) {
                    _txf_Mileage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Mileage.delegate=self;
                    _txf_Mileage.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Mileage];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Mileage.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Mileage.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"CarStd"]) {
                    _txf_CarStd = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CarStd.delegate=self;
                    _txf_CarStd.keyboardType =UIKeyboardTypeDecimalPad;
                    _txf_CarStd.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_CarStd];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_CarStd.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_CarStd.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"FuelBills"]) {
                    _txf_FuelBills = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FuelBills.delegate=self;
                    _txf_FuelBills.keyboardType =UIKeyboardTypeDecimalPad;
                    _txf_FuelBills.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_txf_FuelBills];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FuelBills.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_FuelBills.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"Pontage"]) {
                    _txf_Pontage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Pontage.delegate=self;
                    _txf_Pontage.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Pontage];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Pontage.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_Pontage.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"ParkingFee"]) {
                    _txf_ParkingFee = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_ParkingFee.delegate=self;
                    _txf_ParkingFee.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_ParkingFee];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_ParkingFee.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_ParkingFee.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"SDepartureTime"]) {
                    _txf_SDepartureTime = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_SDepartureTime.delegate=self;
                    _txf_SDepartureTime.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_SDepartureTime];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_SDepartureTime.text=model.fieldValue;
                    }
                    _txf_SDepartureTime.userInteractionEnabled = NO;
                }else if ([model.fieldName isEqualToString:@"SArrivalTime"]) {
                    _txf_SArrivalTime = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_SArrivalTime.delegate=self;
                    _txf_SArrivalTime.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_SArrivalTime];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_SArrivalTime.text=model.fieldValue;
                    }
                    _txf_SArrivalTime.userInteractionEnabled = NO;
                }else if ([model.fieldName isEqualToString:@"AllowanceAmount"]) {
                    _txf_AllowanceAmount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_AllowanceAmount.userInteractionEnabled=NO;
                    _txf_AllowanceAmount.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_AllowanceAmount];
                }else if ([model.fieldName isEqualToString:@"TransDCityName"]) {
                    _txf_TransDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TransDCityName.delegate=self;
                    [_view_ExpenseCode_Click addSubview:_txf_TransDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TransDCityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_TransDCityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"TransACityName"]) {
                    _txf_TransACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TransACityName.delegate=self;
                    [_view_ExpenseCode_Click addSubview:_txf_TransACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TransACityName.text=model.fieldValue;
                    }
                    if ([model.isOnlyRead isEqualToString:@"1"]) {
                        _txf_TransACityName.userInteractionEnabled = NO;
                    }
                }else if ([model.fieldName isEqualToString:@"TransFromDate"]) {
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_TransFromDate=[[UITextField alloc]init];
                    if ([NSString isEqualToNull:model.fieldValue]&&_int_TransTimeType==1) {
                        NSString *str=[NSString stringWithFormat:@"%@",model.fieldValue];
                        if (str.length>10) {
                            model.fieldValue=[str substringToIndex:10];
                        }
                    }
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransFromDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                    
                }else if ([model.fieldName isEqualToString:@"TransToDate"]) {
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_TransToDate=[[UITextField alloc]init];
                    if ([NSString isEqualToNull:model.fieldValue]&&_int_TransTimeType==1) {
                        NSString *str=[NSString stringWithFormat:@"%@",model.fieldValue];
                        if (str.length>10) {
                            model.fieldValue=[str substringToIndex:10];
                        }
                    }
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransToDate WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"TransTotalDays"]) {
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_TransTotalDays=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransTotalDays WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TransTypeId"]) {
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_TransType=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransType WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }
            }
        }
        if ([model.fieldName isEqualToString:@"FellowOfficers"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_FellowOfficers.text=model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"CityName"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _txf_CityName.text=model.fieldValue;
                _str_City = model.fieldValue;
            }
        }
        if ([model.fieldName isEqualToString:@"CityType"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _str_CityType = model.fieldValue;
            }
        }
    }
    _view_ExpenseCode_Click.userInteractionEnabled = NO;
}

//更新点击费用类别视图
-(void)updateCateGoryView{
    if ([_str_ExpenseCode_level isEqualToString:@"1"]) {
        if (_bool_isOpenGener == YES) {
            _img_CateImage.image=[UIImage imageNamed:@"skipImage"];
            _bool_isOpenGener = NO;
            [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }else if(_bool_isOpenGener==NO){
            _img_CateImage.image=[UIImage imageNamed:@"share_Open"];
            _bool_isOpenGener=YES;
            if (_inte_ExpenseCode_Rows == 0) {
                [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@60);
                }];
                [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }else{
                [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@((65*self.inte_ExpenseCode_Rows)+65));
                }];
                [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@((65*self.inte_ExpenseCode_Rows)+65));
                }];
            }
            [self updateImageCollect];
            [_col_CategoryCollectView reloadData];
        }
    }
}

-(void)updateImageCollect{
    [_view_Attachments updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@145);
    }];
    [self.imgCollectView reloadData];
}

//更新金额计算
-(void)update_Amount:(NSString *)newString textField:(UITextField *)textField{
    if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
        if (textField == _txf_TotalDays) {
            _txf_HotelPrice.text = [NSString isEqualToNull:newString]?[NSString stringWithFormat:@"%.2f",[_txf_Amount.text floatValue]/[newString floatValue]]:@"";
        }
        if (textField == _txf_Amount) {
            if ([NSString isEqualToNull:_txf_TotalDays.text]) {
                _txf_HotelPrice.text = [NSString isEqualToNull:newString]?[NSString stringWithFormat:@"%.2f",[newString floatValue]/[_txf_TotalDays.text floatValue]]:@"";
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_Breakfast == textField) {
            }else if (_txf_Supper == textField){
               
            }else if (_txf_Lunch == textField){
               
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_Mileage == textField) {
                _txf_FuelBills.text = [NSString stringWithFormat:@"%.2f",[newString floatValue]*[_txf_CarStd.text floatValue]];
            }else if (_txf_Pontage == textField){
                _txf_FuelBills.text = [NSString stringWithFormat:@"%.2f",[_txf_Mileage.text floatValue]*[_txf_CarStd.text floatValue]];
            }else if (_txf_ParkingFee == textField){
                _txf_FuelBills.text = [NSString stringWithFormat:@"%.2f",[_txf_Mileage.text floatValue]*[_txf_CarStd.text floatValue]];
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_Day == textField) {
            }
        }
    }
}

//更新
-(void)updateAllowanceView:(NSInteger )basis{
    NSMutableArray *arr_Expense_Click = [NSMutableArray array];
    NSMutableArray *_arr_Expense_temporary = [NSMutableArray array];
    NSInteger cell_height = 0;
    
    if (basis == 1) {
        _arr_Expense_temporary = [NSMutableArray arrayWithArray:@[
                                                                  @{@"isShow": @1,
                                                                    @"tips": Custing(@"请输入补贴标准", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"MealAmount",
                                                                    @"description":Custing(@"补贴标准", nil),
                                                                    @"fieldValue":@""}]];
    }else if (basis == 2) {
        _arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
                                                                    @"tips": Custing(@"请选择城市", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"City",
                                                                    @"description":Custing(@"城市", nil),
                                                                    @"fieldValue":@""},
                                                                  @{@"isShow": @1,
                                                                    @"tips": Custing(@"请输入补贴标准", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"MealAmount",
                                                                    @"description":Custing(@"补贴标准", nil),
                                                                    @"fieldValue":@""},
                                                                 
                                                                  ]];
    }else if (basis == 3) {
        _arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
                                                                    @"tips": Custing(@"请选择城市", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"City",
                                                                    @"description":Custing(@"城市", nil),
                                                                    @"fieldValue":@""},
                                                                  @{@"isShow": (_model_mealType&&[_model_mealType.isShow floatValue]==1) ? @1:@0,
                                                                    @"tips": Custing(@"请选择补贴类型", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"MealType",
                                                                    @"description":Custing(@"补贴类型", nil),
                                                                    @"fieldValue":@""},
                                                                  @{@"isShow": @1,
                                                                    @"tips": Custing(@"请输入补贴标准", nil),
                                                                    @"isRequired": @1,
                                                                    @"fieldName": @"MealAmount",
                                                                    @"description":Custing(@"补贴标准", nil),
                                                                    @"fieldValue":@""}
                                                                
                                                                  ]];
    }else if (basis == 4) {
        _arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
                                                                 @"tips": Custing(@"请选择城市", nil),
                                                                 @"isRequired": @1,
                                                                 @"fieldName": @"City",
                                                                 @"description":Custing(@"城市", nil),
                                                                 @"fieldValue":@""},
                                                               @{@"isShow": @1,
                                                                 @"tips": Custing(@"请输入补贴标准", nil),
                                                                 @"isRequired": @0,
                                                                 @"fieldName": @"MealAmount",
                                                                 @"description":Custing(@"补贴标准", nil),
                                                                 @"fieldValue":@""}]];
    }
    
    if ([_str_Unit isEqualToString:@"天"]) {
        [_arr_Expense_temporary addObject:@{@"isShow": @1,
                                         @"tips": Custing(@"请输入天数", nil),
                                         @"isRequired": @1,
                                         @"fieldName": @"TotalDays",
                                         @"description":Custing(@"天数", nil),
                                         @"fieldValue":@"1"}];
    }
    
    
    
    if ([_model_AllowanceFromDate.isShow integerValue]==1) {
        _model_AllowanceFromDate.Description=Custing(@"开始时间", nil);
        _model_AllowanceToDate.isShow=[NSNumber numberWithInteger:1];
        _model_AllowanceToDate.ctrlTyp=_model_AllowanceFromDate.ctrlTyp;
        _model_AllowanceToDate.Description=Custing(@"结束时间", nil);
        if (basis ==1) {
            NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange: NSMakeRange(0, 2)];
            [_arr_Expense_temporary insertObjects:@[[MyProcurementModel initDicByModel:_model_AllowanceFromDate],[MyProcurementModel initDicByModel:_model_AllowanceToDate]] atIndexes:index];
        }else{
            NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange: NSMakeRange(1, 2)];
            [_arr_Expense_temporary insertObjects:@[[MyProcurementModel initDicByModel:_model_AllowanceFromDate],[MyProcurementModel initDicByModel:_model_AllowanceToDate]] atIndexes:index];
        }
    }
    
    if ([_model_TravelUserName.isShow integerValue] == 1) {
        [_arr_Expense_temporary addObject:[MyProcurementModel initDicByModel:_model_TravelUserName]];
    }
    
    if (_arr_Expense_temporary.count>0) {
        for (int i = 0; i<_arr_Expense_temporary.count; i++) {
            NSDictionary *dic = _arr_Expense_temporary[i];
            if ([dic[@"isShow"]integerValue]==1) {
                cell_height += 1;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr_Expense_Click addObject:model];
            }
        }
    }
    
    for(UIView *view in [_view_ExpenseCode_Click subviews])
    {
        [view removeFromSuperview];
    }
    
    [_view_ExpenseCode_Click updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(cell_height*50);
    }];
    
    for (int i = 0; i<arr_Expense_Click.count; i++) {
        MyProcurementModel *model = arr_Expense_Click[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            [_view_ExpenseCode_Click addSubview:[self createLineViewOfHeight_ByTitle:(i*50)-0.5]];
            UILabel *title=[GPUtils createLable:CGRectMake(12,(i*50),XBHelper_Title_Width, 50) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            title.numberOfLines = 2;
            [_view_ExpenseCode_Click addSubview:title];
            if ([model.fieldName isEqualToString:@"TotalDays"]) {
                _txf_Day = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Day.delegate=self;
                _txf_Day.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Day];
                if ([NSString isEqualToNull:_str_Day]) {
                    _txf_Day.text = _str_Day;
                }
            }else if ([model.fieldName isEqualToString:@"Money"]) {
                _txf_Money = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Money.delegate=self;
                _txf_Money.userInteractionEnabled = NO;
                _txf_Money.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_Money];
                if ([NSString isEqualToNull:_str_Amount]) {
                    _txf_Money.text = [NSString stringWithFormat:@"%@",_str_Amount];
                }
            }else if ([model.fieldName isEqualToString:@"City"]) {
                _txf_City = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_City.delegate=self;
                _txf_City.userInteractionEnabled = NO;
                _txf_City.keyboardType = UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_City];
                if ([NSString isEqualToNull:_str_City]) {
                    _txf_City.text = [NSString stringWithFormat:@"%@",_str_City];
                }
                UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                [_view_ExpenseCode_Click addSubview:iconImage];
                UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                btn.tag = 19;
                [_view_ExpenseCode_Click addSubview:btn];
            }else if ([model.fieldName isEqualToString:@"MealType"]) {
                _txf_MealType = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_MealType.delegate=self;
                _txf_MealType.userInteractionEnabled = NO;
                _txf_MealType.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_MealType];
                
                if ([[NSString stringWithFormat:@"%@",_str_MealType]isEqualToString:@"0"]) {
                    _txf_MealType.text = Custing(@"半天餐补", nil);
                    _str_MealType = @"0";
                }else{
                    _txf_MealType.text = Custing(@"一天餐补", nil);
                    _str_MealType = @"1";
                }
                
                UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                [_view_ExpenseCode_Click addSubview:iconImage];
                UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                btn.tag = 30;
                [_view_ExpenseCode_Click addSubview:btn];
            }else if ([model.fieldName isEqualToString:@"MealAmount"]) {
                _txf_MealAmount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_MealAmount.delegate=self;
                _txf_MealAmount.userInteractionEnabled = NO;
                _txf_MealAmount.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_MealAmount];
                
                if (basis == 1||basis == 2||basis == 4) {
                    _txf_MealAmount.text = [NSString stringWithFormat:@"%@",_str_Amount];
                }else{
                    if ([[NSString stringWithFormat:@"%@",_str_MealType]isEqualToString:@"0"]) {
                        _txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[_str_AllowanceCurrencyCode,_str_MealAmount] WithCompare:@" "];
                    }else{
                        _txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[_str_AllowanceCurrencyCode,_str_MealAmount1] WithCompare:@" "];
                    }
                }
                if (![NSString isEqualToNullAndZero:_txf_MealAmount.text]&&[NSString isEqualToNullAndZero:_str_AllowanceAmount]) {
                    _txf_MealAmount.text=[NSString stringWithFormat:@"%@",_str_AllowanceAmount];
                }
            }else if ([model.fieldName isEqualToString:@"AllowanceFromDate"]) {
                _txf_AllowanceFromDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_AllowanceFromDate.delegate=self;
                _txf_AllowanceFromDate.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_AllowanceFromDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_AllowanceFromDate.text = [model.ctrlTyp isEqualToString:@"day"]? [model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                _txf_AllowanceToDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_AllowanceToDate.delegate=self;
                _txf_AllowanceToDate.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_AllowanceToDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_AllowanceToDate.text = [model.ctrlTyp isEqualToString:@"day"]? [model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TravelUserName"]) {
                UITextField *txf_TravelUserName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                [_view_ExpenseCode_Click addSubview:txf_TravelUserName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TravelUserName.text = [NSString stringWithIdOnNO:model.fieldValue];
                }
            }
        }
    }
}

-(void)updateExpenseCodeList_View{
    [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [_view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    _view_TaxRate.userInteractionEnabled = YES;
    
    if ([NSString isEqualToNull:_str_expenseCode]) {
        for (int i = 0; i<_arr_expenseCodeList.count; i++) {
            NSDictionary *dic = _arr_expenseCodeList[i];
            if ([_str_expenseCode isEqualToString:dic[@"expenseCode"]]) {
                if ([_str_InvoiceType floatValue] == 1) {
                    if ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"]) {
                        if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                            _view_TaxRate.userInteractionEnabled = NO;
                            if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                                [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_Tax != nil) {
                                [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_ExclTax != nil) {
                                [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_TaxRate != nil) {
                                [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            
                            if (_txf_InvPmtTax != nil) {
                                [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_InvPmtAmountExclTax != nil) {
                                [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            
                        }
                    }else{
                        
                        if (_txf_Tax != nil) {
                            [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_ExclTax != nil) {
                            [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_TaxRate != nil) {
                            [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        
                        if (_txf_InvPmtTax != nil) {
                            [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_InvPmtAmountExclTax != nil) {
                            [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                    }
                }
                if (_txf_InvoiceType!=nil) {
                    [_view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
            }
        }
    }
}


#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    _bool_firstIn=YES;
    _str_MealType = @"1";
    _str_RequestUserId=@"";
    _txf_ExchangeRate=[[UITextField alloc]init];
    _txf_CarStd=[[UITextField alloc]init];
    _arr_stdSelfDriveDtoList = [NSArray array];
    _str_City = @"";
    _str_Day = @"";
    _int_update = 0;
    _dic_ExpenseCode_requst = [NSDictionary dictionary];
    _muarr_ExpenseCode = [NSMutableArray array];
    _inte_ExpenseCode_Rows = 0;
    _str_CostCenterId_PlaceHolder = @"";
    _muarr_CurrencyCode = [NSMutableArray array];
    _imageTypeArray = [NSMutableArray array];
    _imagesArray = [NSMutableArray array];
    _totalArray = [NSMutableArray array];
    _str_ExpenseCat = @"";
    _str_ExpenseCatCode = @"";
    _str_ProjMgrUserId = @"";
    _str_ProjMgr = @"";
    _dic_CityCode = [NSDictionary dictionary];
    _str_expenseCode_tag = @"";
    _str_CityCode = @"";
    _str_CityType = @"";
    _str_ExchangeRate = @"";
    _arr_expenseCodeList = [NSArray array];
    _str_Status = @"";
    _str_Amount = @"";
    _str_Amount2 = @"";
    _str_Amount3 = @"";
    _str_Unit = @"";
    _str_Class = @"";
    _str_Discount = @"";
    _str_IsExpensed = @"";
    _str_LimitMode = @"";
    _str_InvoiceType= @"";
    _str_Flight = @"";
    _str_Basis = @"";
    _str_FellowOfficersId = @"";
    _arr_FellowOfficersId = [NSMutableArray array];
    _arr_Flight = @[Custing(@"经济舱", nil),Custing(@"商务舱", nil),Custing(@"头等舱", nil)];
    _str_Currency = @"";
    _model_Files = [[WorkFormFieldsModel alloc]initialize];
    _arr_FilesTotle = [NSMutableArray array];
    _arr_FilesImage = [NSMutableArray array];
    _model_rs = [[ReserverdMainModel alloc]init];
    _str_HasInvoice=@"1";
    
    self.array_shareForm = [NSMutableArray array];
    self.array_shareData = [NSMutableArray array];
    self.str_shareTotal = @"0";
    self.str_shareRatio = @"0";


}

//处理请求后数据
-(void)analysisRequestData{
    
    self.bool_shareShow = [_dic_request[@"result"][@"expenseShare"] floatValue] == 1 ? YES:NO;
    if (self.bool_shareShow) {
        if ([_dic_request[@"result"][@"expenseShareFields"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dcit in _dic_request[@"result"][@"expenseShareFields"]) {
                MyProcurementModel *model=[[MyProcurementModel alloc]init];
                [model setValuesForKeysWithDictionary:dcit];
                [self.array_shareForm addObject:model];
            }
        }
        if ([_dic_request[@"result"][@"formData"] isKindOfClass:[NSDictionary class]]) {
            if ([_dic_request[@"result"][@"formData"][@"expenseShareData"]isKindOfClass:[NSDictionary class]]) {
                NSDictionary *expenseShareData = _dic_request[@"result"][@"formData"][@"expenseShareData"];
                if ([expenseShareData[@"sa_ExpenseUserShare"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in expenseShareData[@"sa_ExpenseUserShare"]) {
                        AddReimShareModel *model=[[AddReimShareModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        model.ShareType = @"1";
                        [self.array_shareData addObject:model];
                    }
                }
            }
        }
    }
    
    if ([_dic_request[@"result"][@"expenseInvSettingDtos"]isKindOfClass:[NSArray class]]) {
        _array_HasInvoice=[NSMutableArray array];
        [STOnePickModel getInvoiceTypeWithDate:_dic_request[@"result"][@"expenseInvSettingDtos"] WithResult:_array_HasInvoice];
    }
    
    _arr_ClaimType=[NSMutableArray array];
    if ([_dic_request[@"result"][@"reimbursementTypes"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getClaimTypeWithDate:_dic_request[@"result"][@"reimbursementTypes"] WithResult:_arr_ClaimType];
    }
    
    _arr_InvoiceType=[NSMutableArray array];
    if ([_dic_request[@"result"][@"invoiceTypes"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getInvoiceTypesWithDate:_dic_request[@"result"][@"invoiceTypes"] WithResult:_arr_InvoiceType];
    }
    
    _arr_TaxRates=[NSMutableArray array];
    if ([_dic_request[@"result"][@"taxRates"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getTaxRatesWithDate:_dic_request[@"result"][@"taxRates"] WithResult:_arr_TaxRates];
    }

    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dic_request[@"result"][@"formFields"]];
    _muarr_MainView = [NSMutableArray array];
   
    if (![_dic_request[@"result"][@"driveCar"] isKindOfClass:[NSNull class]]) {
        _dic_route = _dic_request[@"result"][@"driveCar"];
        _model_route = [RouteModel modelWithDict:_dic_route];
    }
    //币种
    NSMutableDictionary *Currencydict=[NSMutableDictionary dictionary];
    [STOnePickModel getCurrcyWithDate:[NSMutableArray arrayWithArray:[_dic_request[@"result"][@"currency"] isKindOfClass:[NSNull class]]?[NSMutableArray array]:_dic_request[@"result"][@"currency"]] WithResult:_muarr_CurrencyCode WithCurrencyDict:Currencydict];
    _str_CurrencyCode=Currencydict[@"CurrencyCode"];
    _str_ExchangeRate=Currencydict[@"ExchangeRate"];
    _txf_ExchangeRate.text=_str_ExchangeRate;
    _str_Currency=Currencydict[@"Currency"];
    
    _arr_expenseCodeList = _dic_request[@"result"][@"expenseCodeList"];
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            model.isOnlyRead = @"1";
            [_muarr_MainView addObject:model];
            if ([model.fieldName isEqualToString:@"CityCode"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CityCode = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CityName"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_City = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CityType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CityType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"TotalDays"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_Day = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ExpenseCat"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ExpenseCat = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"MealType"]) {
                _str_MealType = [[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"] ? @"0":@"1";
                _model_mealType = model;
            }
            if ([model.fieldName isEqualToString:@"RequestUserId"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_RequestUserId = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"InvoiceType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_InvoiceType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CorpCarFromDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarFromDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"SupplierName"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_Supplier= model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
                self.str_ExchangeRate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.fieldValue]]?[NSString reviseString:model.fieldValue]:self.str_ExchangeRate;
            }
            if ([model.fieldName isEqualToString:@"CorpCarToDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarToDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"AllowanceFromDate"]) {
                _model_AllowanceFromDate=model;
            }
            if ([model.fieldName isEqualToString:@"TravelUserName"]) {
                _model_TravelUserName=model;
            }
            if ([model.fieldName isEqualToString:@"TravelUserId"]) {
                self.str_TravelUserId = [NSString stringWithIdOnNO:model.fieldValue];
            }
            
            if ([model.fieldName isEqualToString:@"DataSource"]&&[NSString isEqualToNull:model.fieldValue]) {
                _dateSource = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                _model_AllowanceToDate=model;
            }
            if ([model.fieldName isEqualToString:@"AllowanceAmount"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_AllowanceAmount = model.fieldValue;
            }
            
            if ([model.fieldName isEqualToString:@"ReceptionFellowOfficers"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReceptionFellowOfficers = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ReplExpenseType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReplExpenseType = model.fieldValue;
            }
            
            if ([dic[@"fieldName"] isEqualToString:@"LocationId"]) {
                self.str_LocationId=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"Location"]) {
                self.str_Location=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OfficeFromDate"]) {
                self.str_OfficeFromDate=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OfficeToDate"]) {
                self.str_OfficeToDate=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OfficeTotalDays"]) {
                self.str_OfficeTotalDays=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"BranchId"]) {
                self.str_BranchId=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"Branch"]) {
                self.str_Branch=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OverseasFromDate"]) {
                self.str_OverseasFromDate=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OverseasToDate"]) {
                self.str_OverseasToDate=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"OverseasTotalDays"]) {
                self.str_OverseasTotalDays=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            
            if ([dic[@"fieldName"] isEqualToString:@"Currency"]) {
                self.str_Currency=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_Currency;
            }
            if ([dic[@"fieldName"] isEqualToString:@"CurrencyCode"]) {
                self.str_CurrencyCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_CurrencyCode;
            }
            if ([dic[@"fieldName"] isEqualToString:@"ExchangeRate"]) {
                self.str_ExchangeRate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_ExchangeRate;
                _txf_ExchangeRate.text=self.str_ExchangeRate;
            }
            if ([dic[@"fieldName"] isEqualToString:@"InvoiceTypeName"]) {
                self.str_InvoiceTypeName=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"InvoiceTypeCode"]) {
                self.str_InvoiceTypeCode=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            
            if ([model.fieldName isEqualToString:@"HasInvoice"]) {
                self.str_HasInvoice=[NSString isEqualToNull:model.fieldValue]?[NSString stringWithFormat:@"%@",model.fieldValue]:@"1";
            }
            if ([dic[@"fieldName"] isEqualToString:@"ShareId"]) {
                self.str_shareId = [NSString stringIsExist:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"ShareTotalAmt"]) {
                self.str_shareTotal = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"ShareRatio"]) {
                self.str_shareRatio = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"OilPrice"]) {
                self.str_OilPrice = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"AccountItemCode"]) {
                self.str_AccountItemCode = [NSString stringIsExist:dic[@"AccountItemCode"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"AccountItem"]) {
                self.str_AccountItem = [NSString stringIsExist:dic[@"AccountItem"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"ProjectActivityLv1"]) {
                self.str_ProjectActivityLv1 = [NSString stringWithFormat:@"%@",dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"ProjectActivityLv1Name"]) {
                self.str_ProjectActivityLv1Name = [NSString stringWithFormat:@"%@",dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"ProjectActivityLv2"]) {
                self.str_ProjectActivityLv2 = [NSString stringWithFormat:@"%@",dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"ProjectActivityLv2Name"]) {
                self.str_ProjectActivityLv2Name = [NSString stringWithFormat:@"%@",dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"InvCyPmtExchangeRate"]) {
                self.str_InvCyPmtExchangeRate = [NSString stringIsExist:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"AirlineFuelFee"]) {
                self.str_AirlineFuelFee = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"AirTicketPrice"]) {
                self.str_AirTicketPrice = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"DevelopmentFund"]) {
                self.str_DevelopmentFund = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"FuelSurcharge"]) {
                self.str_FuelSurcharge = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            if ([dic[@"fieldName"] isEqualToString:@"OtherTaxes"]) {
                self.str_OtherTaxes = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"0";
            }
            
            if ([model.fieldName isEqualToString:@"Overseas"]) {
                self.str_Overseas = [NSString isEqualToNull:model.fieldValue] ? [NSString stringWithFormat:@"%@",model.fieldValue]:@"0";
            }
    
            //解析图片
            if ([dic[@"fieldName"] isEqualToString:@"Attachments"]) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_totalArray addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_totalArray WithImageArray:_imagesArray WithMaxCount:10];
                }
            }
            if ([dic[@"fieldName"] isEqualToString:@"Files"]) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_arr_FilesTotle addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_arr_FilesTotle WithImageArray:_arr_FilesImage WithMaxCount:5];
                }
            }
        }
    }
}

//更新地图视图
-(void)updateRouteDetailView{
    if (_model_route!=nil) {
        [_view_RouteDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@265);
        }];
        if (_model_route!=nil) {
            RouteDetailView *view=[[RouteDetailView alloc]initRouteDetail:_model_route withType:1];
            view.frame=CGRectMake(0, 0, Main_Screen_Width, 215);
            [_view_RouteDetail addSubview:view];
            [_view_RouteDetail addSubview:[self createLineViewOfHeight:215]];
            view.backgroundColor = Color_eaeaea_20;
            UIButton *btn = [GPUtils createButton:CGRectMake(0, 215, Main_Screen_Width, 50) action:@selector(btn_route:) delegate:self title:Custing(@"行程轨迹>>", nil) font:Font_Amount_21_20 titleColor:Color_form_TextFieldBackgroundColor];
            [btn setBackgroundImage:[UIImage imageNamed:@"Route_track"] forState:UIControlStateNormal];
            [_view_RouteDetail addSubview:btn];
        }
    }else if (_model_didi!=nil){
        [_view_RouteDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@265);
        }];
        if (_model_didi!=nil){
            RouteModel *route = [RouteDidiModel DidiChangeRouteModle:_model_didi];
            RouteDetailView *view=[[RouteDetailView alloc]initRouteDetail:route withType:2];
            view.frame=CGRectMake(0, 0, Main_Screen_Width, 215);
            [_view_RouteDetail addSubview:view];
            [_view_RouteDetail addSubview:[self createLineViewOfHeight:215]];
            view.backgroundColor = Color_eaeaea_20;
            UILabel *lab = [GPUtils createLable:CGRectMake(0, 215, Main_Screen_Width, 50) text:Custing(@"订单来源：滴滴出行", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
            [_view_RouteDetail addSubview:lab];
        }
    }
}

-(void)updateRouteDeta{
    if (_model_route!=nil) {
        _txf_SDCityName.text = _model_route.departureName;
        _txf_SACityName.text = _model_route.arrivalName;
        _txf_Mileage.text = _model_route.mileage;
    }
}

-(void)updateRouteDetaDidi{
    if (_model_route!=nil&&[_dic_route isKindOfClass:[NSDictionary class]]&&_model_didi!=nil) {
        if ([NSString isEqualToNull:_dic_route[@"expenseCode"]]) {
            [_sub_Expense setCateImg:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
            _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
            _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_dic_route[@"expenseCat"],_dic_route[@"expenseType"]]];
            _str_expenseCode = _dic_route[@"expenseCode"];
            _str_expenseIcon = _dic_route[@"expenseIcon"];
            _str_expenseCode_tag = [NSString isEqualToNull:_dic_route[@"tag"]]?_dic_route[@"tag"]:@"";
            _txf_TransDCityName.text = _model_didi.start_name;
            _txf_TransACityName.text = _model_didi.end_name;
            _txf_TransFromDate.text = _model_didi.departure_time;
            _txf_TransToDate.text = _model_didi.finish_time;
            _txv_Remark.text = _model_didi.remark;
        }
    }
}

-(void)updateAllowanceData{
    if ([_str_CurrencyCode isEqualToString:_str_AllowanceCurrencyCode]) {
    }else if([NSString isEqualToNull:_str_AllowanceCurrencyRate]){
    }else{
    }
}

-(void)updateValue{
    _txf_Amount.text = [NSString stringIsExist:_model.localCyAmount];
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.amount]]?[GPUtils transformNsNumber:_model.amount]:@""];
    
    _txf_ExclTax.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.exclTax]]?[NSString stringWithFormat:@"%@",_model.exclTax]:@"";
    _txf_Tax.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.tax]]?[NSString stringWithFormat:@"%@",_model.tax]:@"";
    _txf_ExchangeRate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.exchangeRate]]?[NSString stringWithFormat:@"%@",_model.exchangeRate]:@"";

    _txf_HotelPrice.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.hotelPrice]]?[NSString stringWithFormat:@"%@",_model.hotelPrice]:@"";

    _txf_TaxRate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.taxRate]]?[NSString stringWithFormat:@"%@",_model.taxRate]:@"";

    _txf_InvCyPmtExchangeRate.text = [NSString isEqualToNull:_model.invCyPmtExchangeRate] ? [NSString stringWithFormat:@"%@",_model.invCyPmtExchangeRate]:@"0.00";
    _txf_InvPmtAmount.text = [NSString isEqualToNull:_model.invPmtAmount] ? [NSString stringWithFormat:@"%@",_model.invPmtAmount]:@"0";
    _txf_InvPmtTax.text = [NSString isEqualToNull:_model.invPmtTax] ? [NSString stringWithFormat:@"%@",_model.invPmtTax]:@"0";
    _txf_InvPmtAmountExclTax.text = [NSString isEqualToNull:_model.invPmtAmountExclTax] ? [NSString stringWithFormat:@"%@",_model.invPmtAmountExclTax]:@"0";

    
    
    _str_expenseCode = [NSString stringIsExist:_model.expenseCode];
    _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_model.expenseCat,_model.expenseType]];;
    _str_expenseIcon = [NSString isEqualToNull:_model.expenseIcon]?_model.expenseIcon:@"15";
    _str_ExpenseCat = [NSString stringIsExist:_model.expenseCat];
    _str_ExpenseCatCode = [NSString stringIsExist:_model.expenseCatCode];
    _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_model.expenseIcon]?_model.expenseIcon:@"15"];
    [_sub_Expense setCateImg:_str_expenseIcon];

    
    _str_InvoiceType = [NSString stringIsExist:_model.invoiceType];
    _str_InvoiceTypeName = [NSString stringIsExist:_model.invoiceTypeName];
    _str_InvoiceTypeCode = [NSString stringIsExist:_model.invoiceTypeCode];
    _txf_InvoiceType.text = [NSString stringIsExist:_model.invoiceTypeName];
    self.txf_AirlineFuelFee.text = [NSString stringIsExist:_model.airlineFuelFee];
    self.txf_AirTicketPrice.text = [NSString stringIsExist:_model.airTicketPrice];
    self.txf_DevelopmentFund.text = [NSString stringIsExist:_model.developmentFund];
    self.txf_FuelSurcharge.text = [NSString stringIsExist:_model.fuelSurcharge];
    self.txf_OtherTaxes.text = [NSString stringIsExist:_model.otherTaxes];

    _str_CostCenterId = [NSString stringIsExist:_model.costCenterId];
    _txf_CostCenterId.text = [NSString stringIsExist:_model.costCenter];

    
//    _txf_AllowanceAmount.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.allowanceAmount]]?[NSString stringWithFormat:@"%@",_model.allowanceAmount]:@"";
//    _txf_AllowanceUnit.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.allowanceUnit]]?[NSString stringWithFormat:@"%@",_model.allowanceUnit]:@"";
//    _txf_CityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.cityName]]?[NSString stringWithFormat:@"%@",_model.cityName]:@"";
//    _txf_CurrencyCode.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.currency]]?[NSString stringWithFormat:@"%@",_model.currency]:@"";
    
//    _str_expenseCode_tag = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.tag]]?[NSString stringWithFormat:@"%@",_model.tag]:@"";
    
    
//    _txv_Remark.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.remark]]?[NSString stringWithFormat:@"%@",_model.remark]:@"";
//    _txf_Breakfast.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.breakfast]]?[NSString stringWithFormat:@"%@",_model.breakfast]:@"";
//    _txf_CarStd.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.carStd]]?[NSString stringWithFormat:@"%@",_model.carStd]:@"";
//    _txf_CheckInDate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.checkInDate]]?[NSString stringWithFormat:@"%@",_model.checkInDate]:@"";
//    _txf_CheckOutDate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.checkOutDate]]?[NSString stringWithFormat:@"%@",_model.checkOutDate]:@"";
//    _txf_ClassName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.className]]?[NSString stringWithFormat:@"%@",_model.className]:@"";
//    _txf_ClientId.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.clientName]]?[NSString stringWithFormat:@"%@",_model.clientName]:@"";
//    _txf_Discount.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.discount]]?[NSString stringWithFormat:@"%@",_model.discount]:@"";
//    _txf_ExpenseDesc.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.expenseDesc]]?[NSString stringWithFormat:@"%@",_model.expenseDesc]:@"";
//    _txf_FACityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.faCityName]]?[NSString stringWithFormat:@"%@",_model.faCityName]:@"";
//    _txf_FDCityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.fdCityName]]?[NSString stringWithFormat:@"%@",_model.fdCityName]:@"";
//    _txf_FellowOfficers.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.fellowOfficers]]?[NSString stringWithFormat:@"%@",_model.fellowOfficers]:@"";
//    _txf_FuelBills.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.fuelBills]]?[NSString stringWithFormat:@"%@",_model.fuelBills]:@"";
//    _txf_InvoiceNo.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.invoiceNo]]?[NSString stringWithFormat:@"%@",_model.invoiceNo]:@"";
//    _txf_InvoiceType.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.invoiceType]]?[NSString stringWithFormat:@"%@",[_model.invoiceType integerValue] == 1?Custing(@"增值税专用发票", nil):Custing(@"增值税普通发票", nil)]:@"" ;
//    _txf_Lunch.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.lunch]]?[NSString stringWithFormat:@"%@",_model.lunch]:@"";
//    _txf_Mileage.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.mileage]]?[NSString stringWithFormat:@"%@",_model.mileage]:@"";
//    _txf_NoInvReason.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.noInvReason]]?[NSString stringWithFormat:@"%@",_model.noInvReason]:@"";
//    _txf_ParkingFee.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.parkingFee]]?[NSString stringWithFormat:@"%@",_model.parkingFee]:@"";
//    _txf_Pontage.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.pontage]]?[NSString stringWithFormat:@"%@",_model.pontage]:@"";
//    _txf_ProjId.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.projName]]?[NSString stringWithFormat:@"%@",_model.projName]:@"";
//    _txf_SACityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.saCityName]]?[NSString stringWithFormat:@"%@",_model.saCityName]:@"";
//    _txf_SDCityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.sdCityName]]?[NSString stringWithFormat:@"%@",_model.sdCityName]:@"";
//    _txf_SeatName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.seatName]]?[NSString stringWithFormat:@"%@",_model.seatName]:@"";
//    _txf_Supper.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.supper]]?[NSString stringWithFormat:@"%@",_model.supper]:@"";
//    _txf_TACityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.taCityName]]?[NSString stringWithFormat:@"%@",_model.taCityName]:@"";
//    _txf_Tag.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.tag]]?[NSString stringWithFormat:@"%@",_model.tag]:@"";
//    _txf_TDCityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.tdCityName]]?[NSString stringWithFormat:@"%@",_model.tdCityName]:@"";
//    _txf_TransACityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.transACityName]]?[NSString stringWithFormat:@"%@",_model.transACityName]:@"";
//    _txf_TransDCityName.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.transDCityName]]?[NSString stringWithFormat:@"%@",_model.transDCityName]:@"";
//    _txf_TransFromDate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.transFromDate]]?[NSString stringWithFormat:@"%@",_model.transFromDate]:@"";
//    _txf_TransToDate.text = [NSString isEqualToNull:[NSString stringWithFormat:@"%@",_model.transToDate]]?[NSString stringWithFormat:@"%@",_model.transToDate]:@"";
}

#pragma mark 网络请求
//获取页面数据
-(void)requestExpuserGetFormDataByProcIdAndTaskId{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",expuserGetFormDataByProcIdAndTaskId];
    NSDictionary *parameters = @{@"Action":@3,
                                 @"Type":_ClaimType,
                                 @"TaskId":_model.taskId,
                                 @"GridOrder":_model.gridOrder,
                                 @"ProcId":_ProcId,
                                 @"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId,
                                 @"ProcId":self.dict_parameter[@"ProcId"] ? self.dict_parameter[@"ProcId"]:@"",
                                 @"FlowGuid":self.dict_parameter[@"FlowGuid"] ? self.dict_parameter[@"FlowGuid"]:@""
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

// 获取类别选择中的类别
-(void)requestGetTyps{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":self.ClaimType,@"CostCenterId":_str_CostCenterId};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

// 获取费用标准
-(void)requestGetExpStd{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_txf_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequestUserId,
                                 @"LocationId":_str_LocationId,
                                 @"BranchId":_str_BranchId,
                                 @"CheckInDate":[NSString stringWithIdOnNO:_txf_CheckInDate.text],
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_txf_AllowanceFromDate.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_txf_AllowanceToDate.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_str_TravelUserId],
                                 @"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId};
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}

-(void)requestGetExpStdAddFirst{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_txf_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequestUserId,
                                 @"LocationId":_str_LocationId,
                                 @"BranchId":_str_BranchId,
                                 @"CheckInDate":[NSString stringWithIdOnNO:_txf_CheckInDate.text],
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_txf_AllowanceFromDate.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_txf_AllowanceToDate.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_str_TravelUserId],
                                 @"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId};
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:20 IfUserCache:NO];
}


#pragma mark - action
-(void)btn_block:(UIButton *)btn{
    [self requestGetSubmitExpStd];
    
}
-(void)saveContinueInfo{
    NSDictionary *dic = [HasSubmitDetailModel initDicByModel:_model];
    _model_NewAddCost = [NewAddCostModel modelWithDict:dic];
    NSString *str_message = [self verifyData];
    if ([NSString isEqualToNull:str_message]||[str_message isEqualToString:@"1"]) {
        _model.overStd = @"1";
    }else{
        _model.overStd = @"0";
    }
    if (![NSString isEqualToNull:str_message]) {
        [self saveInfo];
    }else{
        self.view_DockView.userInteractionEnabled = YES;
        if (![str_message isEqualToString:@"1"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:str_message duration:1.5];
        }
    }
}
-(void)saveInfo{
   
    if (self.Block) {
        _model.amount = [NSString stringWithIdOnNO:_txf_Amount.text];
        _model.hotelPrice = [NSString stringWithIdOnNO:_txf_HotelPrice.text];
        
        
        _model.exchangeRate = [self getEndExchangeRate];
        NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:_model.exchangeRate];
        LocalCyAmount = [GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
        _model.localCyAmount = [NSString isEqualToNull:LocalCyAmount] ? LocalCyAmount:@"0.00";
        _model.taxRate = (_view_TaxRate.zl_height > 0 && [NSString isEqualToNull:_txf_TaxRate.text]) ?_txf_TaxRate.text:@"";
        if (_view_Tax.zl_height > 0 && self.txf_Tax) {
            _model.tax = self.txf_Tax.text;
        }else{
            _model.tax = [NSString countTax:LocalCyAmount taxrate:_model.taxRate];
        }
        _model.exclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:LocalCyAmount with:_model.tax] afterPoint:2];
        
        _model.expenseCode = _str_expenseCode;
        if ([NSString isEqualToNull:_txf_ExpenseCode.text]) {
            _model.expenseType = [_txf_ExpenseCode.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",_str_ExpenseCat] withString:@""];
        }
        _model.expenseIcon = _str_expenseIcon;
        _model.expenseCatCode = _str_ExpenseCatCode;
        _model.expenseCat = _str_ExpenseCat;

        if (self.view_InvoiceType.zl_height > 0) {
            _model.invoiceType = _str_InvoiceType;
            _model.invoiceTypeName = _str_InvoiceTypeName;
            _model.invoiceTypeCode = _str_InvoiceTypeCode;
        }else{
            _model.invoiceType = @"0";
            _model.invoiceTypeName = @"";
            _model.invoiceTypeCode = @"";
        }
        _model.airlineFuelFee = self.View_AirlineFuelFee.zl_height > 0 ?_txf_AirlineFuelFee.text:@"0";
        _model.airTicketPrice = self.View_AirTicketPrice.zl_height > 0 ?_txf_AirTicketPrice.text:@"0";
        _model.developmentFund = self.View_DevelopmentFund.zl_height > 0 ?_txf_DevelopmentFund.text:@"0";
        _model.fuelSurcharge = self.View_FuelSurcharge.zl_height > 0 ?_txf_FuelSurcharge.text:@"0";
        _model.otherTaxes = self.View_OtherTaxes.zl_height > 0 ?_txf_OtherTaxes.text:@"0";

        if (_view_CostCenterId.zl_height > 0) {
            _model.costCenterId = _str_CostCenterId;
            _model.costCenter = _txf_CostCenterId.text;
        }

        _model.invCyPmtExchangeRate = self.str_InvCyPmtExchangeRate;
        NSString *InvPmtAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
        InvPmtAmount = [GPUtils getRoundingOffNumber:InvPmtAmount afterPoint:2];
        _model.invPmtAmount = [NSString isEqualToNull:InvPmtAmount] ? InvPmtAmount:@"0.00";
        if (_View_InvPmtTax.zl_height > 0 && self.txf_InvPmtTax) {
            _model.invPmtTax = self.txf_InvPmtTax.text;
        }else{
            _model.invPmtTax = [NSString countTax:InvPmtAmount taxrate:_model.taxRate];
        }
        _model.invPmtAmountExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:InvPmtAmount with:_model.invPmtTax] afterPoint:2];
        _model.accountItem = [NSString stringWithIdOnNO:_txf_AccountItem.text];
        _model.accountItemCode = self.str_AccountItemCode;
        self.Block(_model,_indexPath);
        [self returnBack];
    }
}
-(NSString *)verifyData{
    _model.overStd2 = @"0";
    _model.overStdAmt = @"0";
    if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {

        if ([NSString isEqualToNull:_txf_TotalDays.text]&&![_txf_TotalDays.text isEqualToString:@"0"]) {
            NSString *standardAmount;
            if ([[self getStandardAmountWithKey:@"basis"]floatValue]==1||[[self getStandardAmountWithKey:@"basis"]floatValue]==3) {
                standardAmount = [self getStandardAmountWithKey:@"amount"];
            }else{
                standardAmount = [self getStandardHasCurrency];
            }
            if (standardAmount) {
                NSString *loan = [GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:([GPUtils decimalNumberMultipWithString:[GPUtils decimalNumberMultipWithString:_txf_TotalDays.text with:standardAmount] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"])];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    NSString *approval = [self getStandardAmountWithKey:@"approval"];
                    if (approval&&[approval floatValue]>100) {
                        NSString *str = [GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:([GPUtils decimalNumberMultipWithString:[GPUtils decimalNumberMultipWithString:_txf_TotalDays.text with:standardAmount] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"])];
                        str = [GPUtils decimalNumberMultipWithString:str with:@"100"];
                        str = [GPUtils decimalNumberSubWithString:str with:[NSString stringWithFormat:@"%@",approval]];
                        if ([str floatValue]>0) {
                            _model.overStd2=@"1";
                        }
                    }
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"住宿标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"住宿标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,请重新填写", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]) {
        if ([NSString isEqualToNull:_txf_Discount.text]&&![_txf_Discount.text isEqualToString:@"0"]) {
            NSString *discount=[self getStandardAmountWithKey:@"discount"];
            if ([NSString isEqualToNullAndZero:discount]) {
                NSString *loan=[GPUtils decimalNumberSubWithString:_txf_Discount.text with:discount];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@",Custing(@"折扣超出限制", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",Custing(@"折扣超出限制", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
        if ([NSString isEqualToNull:_txf_ClassName.text]) {
            NSString *standClass=[self getStandardAmountWithKey:@"class"];
            if ([NSString isEqualToNullAndZero:standClass]) {
                NSString *class=@"";
                if ([_txf_ClassName.text isEqualToString:Custing(@"经济舱", nil)]) {
                    class=@"1";
                }else if ([_txf_ClassName.text isEqualToString:Custing(@"商务舱", nil)]){
                    class=@"2";
                }else if ([_txf_ClassName.text isEqualToString:Custing(@"头等舱", nil)]){
                    class=@"3";
                }
                NSString *loan=[GPUtils decimalNumberSubWithString:class with:standClass];
                if ([loan floatValue]>0) {
                    _model_NewAddCost.OverStd = loan;
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@",Custing(@"舱位出限制", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@",Custing(@"舱位出限制", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Train"]) {
        if ([NSString isEqualToNull:_model_NewAddCost.SeatName]&&_dict_Standard&&[_dict_Standard[@"trainSeats"] isKindOfClass:[NSArray class]]&&[_dict_Standard[@"trainSeats"] count]>0) {
            NSArray *array = _dict_Standard[@"trainSeats"];
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"name MATCHES %@", _model_NewAddCost.SeatName];
            NSArray *filterArray = [array filteredArrayUsingPredicate:pred1];
            if (filterArray.count == 0) {
                _model_NewAddCost.OverStd = @"1";
                if ([_str_LimitMode isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:Custing(@"座位超出标准", nil)
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"座位超出标准", nil) duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return @"1";
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]) {
    
        NSString *amount1=[self getStandardAmountWithKey:@"amount"];
        NSString *amount2=[self getStandardAmountWithKey:@"amount2"];
        NSString *amount3=[self getStandardAmountWithKey:@"amount3"];
        if (amount1||amount2||amount3) {
            NSString *tolAmount=[GPUtils decimalNumberAddWithString:[GPUtils decimalNumberAddWithString:amount1 with:amount2] with:amount3];
            tolAmount=[GPUtils decimalNumberMultipWithString:tolAmount with:([NSString isEqualToNullAndZero:self.txf_TotalPeople.text]?self.txf_TotalPeople.text:@"1")];
            tolAmount = [GPUtils decimalNumberMultipWithString:tolAmount with:([NSString isEqualToNullAndZero:self.txf_MealsTotalDays.text]?self.txf_MealsTotalDays.text:@"1")];
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:tolAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                NSString *approval = [self getStandardAmountWithKey:@"approval"];
                if (approval&&[approval floatValue]>100) {
                    NSString *str = [GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:tolAmount];
                    str = [GPUtils decimalNumberMultipWithString:str with:@"100"];
                    str = [GPUtils decimalNumberSubWithString:str with:[NSString stringWithFormat:@"%@",approval]];
                    if ([str floatValue]>0) {
                        _model.overStd2=@"1";
                    }
                }
                if ([_str_LimitMode isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"餐饮标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"餐饮标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",请重新填写", nil)] duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return @"1";
            }
        }
    }
    else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]) {
        
        if ([NSString isEqualToNull:_txf_Mileage.text]&&![_txf_Mileage.text isEqualToString:@"0"]) {
            NSString *funAmount=nil;
            if ([[self getStandardAmountWithKey:@"basis"]floatValue] == 3) {
                if ([self.dict_Standard[@"getStdPrivateCar"]isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *getStdPrivateCar = self.dict_Standard[@"getStdPrivateCar"];
                    NSString *amount = [GPUtils decimalNumberMultipWithString:self.txf_OilPrice.text with:[NSString stringWithIdOnNO:getStdPrivateCar[@"fuelConsumption"]]];
                    amount = [GPUtils decimalNumberMultipWithString:self.txf_Mileage.text with:amount];
                    amount = [GPUtils decimalNumberDividingWithString:amount with:@"100"];
                    if ([NSString isEqualToNull:amount]) {
                        funAmount = amount;
                    }
                }
            }else if ([[self getStandardAmountWithKey:@"basis"] floatValue]==1) {
                NSString *amount=[self getStandardAmountWithKey:@"amount"];
                if (amount) {
                    funAmount = [GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:amount];
                }
            }else{
                NSString *amount=[self returnSelfCarAmount:_txf_Mileage.text];
                if ([amount floatValue]>0) {
                    funAmount=[GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:amount];
                }
            }
            NSString *tolAmount = [GPUtils decimalNumberAddWithString:funAmount with:[GPUtils decimalNumberAddWithString:_txf_Pontage.text with:_txf_ParkingFee.text]];
            if ([tolAmount floatValue]>0) {
                NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:tolAmount];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"自驾车标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"自驾车标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",请重新填写", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Taxi"]) {
        if ([NSString isEqualToNullAndZero:_model_NewAddCost.TaxiFromDate]) {
            if (self.dict_Standard&&[self.dict_Standard[@"stdTaxis"]isKindOfClass:[NSArray class]]) {
                NSArray *stdTaxis = self.dict_Standard[@"stdTaxis"];
                if (stdTaxis.count>0) {
                    for (NSDictionary *dicts in stdTaxis) {
                        if ([dicts[@"isLimit"]floatValue]==1) {
                            NSDate *date1 =[GPUtils TimeStringTranFromData:dicts[@"toTime"] WithTimeFormart:@"HH:mm"];
                            NSDate *date2 =[GPUtils TimeStringTranFromData:dicts[@"fromTime"] WithTimeFormart:@"HH:mm"];
                            NSDate *date3 =[GPUtils TimeStringTranFromData:([_model_NewAddCost.TaxiFromDate substringFromIndex:11]) WithTimeFormart:@"HH:mm"];
                            if ([date2 timeIntervalSinceDate:date1]>=0.0){
                                if ([date3 timeIntervalSinceDate:date2]>0||[date1 timeIntervalSinceDate:date3]>0) {
                                    return nil;
                                    break;
                                }
                            }else{
                                if ([date3 timeIntervalSinceDate:date2]>0&&[date1 timeIntervalSinceDate:date3]>0) {
                                    return nil;
                                    break;
                                }
                            }
                        }else{
                            return nil;
                            break;
                        }
                    }
                    if ([[NSString stringWithFormat:@"%@",self.dict_Standard[@"limitMode"]] isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@%@",Custing(@"超出租车标准", nil),Custing(@",是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@",Custing(@"超出租车标准", nil),Custing(@",请重新填写", nil)] duration:1.0];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
            return nil;
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]) {
        
        if (([NSString isEqualToNull:_txf_Day.text]&&![_txf_Day.text isEqualToString:@"0"])||![_str_Unit isEqualToString:@"天"]) {
            NSString *days;
            if (![_str_Unit isEqualToString:@"天"]) {
                days  = @"1";
            }else{
                days  = _txf_Day.text;
            }
            NSString *standardAmount;
            if ([[self getStandardAmountWithKey:@"basis"]floatValue]==1||[[self getStandardAmountWithKey:@"basis"]floatValue]==2||[[self getStandardAmountWithKey:@"basis"]floatValue]==4) {
                standardAmount = [self getStandardAmountWithKey:@"amount"];
            }else{
                standardAmount = [self getStandardHasCurrency];
            }
            if (standardAmount) {
                NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:days with:standardAmount]];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"补贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"补贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",请重新填写", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Trans"]) {
        if ([NSString isEqualToNull:_txf_TransTotalDays.text]&&![_txf_TransTotalDays.text isEqualToString:@"0"]) {
            NSString *standardAmount = [self getStandardAmountWithKey:@"amount"];
            if (standardAmount) {
                NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:_txf_TransTotalDays.text with:standardAmount]];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"补贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"补贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@",请重新填写", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Other"]) {
        NSString *standardAmount = [self getStandardAmountWithKey:@"amount"];
        if (standardAmount) {
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:standardAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([_str_LimitMode isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@%@%@",Custing(@"超出标准", nil),_model_NewAddCost.OverStd,Custing(@"元/", nil),_str_Unit,Custing(@",是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@%@%@",Custing(@"超出标准", nil),_model_NewAddCost.OverStd,Custing(@"元/", nil),_str_Unit,Custing(@",请重新填写", nil)] duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return @"1";
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Medical"]) {
        if (_dict_Standard) {
            if ([_dict_Standard[@"staffExpenses"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict=_dict_Standard[@"staffExpenses"];
                NSString *amount=[NSString stringWithIdOnNO:dict[@"amount"]];
                NSString *standardAmount=[NSString stringWithIdOnNO:dict[@"standardAmount"]];
                NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:amount];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    if ([_str_LimitMode isEqualToString:@"1"]) {
                        _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                                 message:[NSString stringWithFormat:@"%@%@%@,%@ %@%@%@%@",Custing(@"您今年的报销标准", nil),standardAmount,Custing(@"元", nil),Custing(@"超出标准", nil),_model_NewAddCost.OverStd,Custing(@"元/", nil),_str_Unit,Custing(@",是否提交?", nil)]
                                                                delegate:self
                                                       cancelButtonTitle:Custing(@"取消", nil)
                                                       otherButtonTitles:Custing(@"确定", nil),nil];
                        [_alt_Warring  show];
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@%@%@,%@%@%@%@%@",Custing(@"您今年的报销标准", nil),standardAmount,Custing(@"元", nil),Custing(@"超出标准", nil),_model_NewAddCost.OverStd,Custing(@"元/", nil),_str_Unit,Custing(@",请重新填写", nil)] duration:1.5];
                        _view_DockView.userInteractionEnabled=YES;
                    }
                    return @"1";
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Office"]) {
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[[self getStandardAmountWithKey:@"unit"]isEqualToString:@"天"]&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:([NSString isEqualToNullAndZero:_txf_OfficeTotalDays.text]?_txf_OfficeTotalDays.text:@"1") with:standardAmount]];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻办津贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻办津贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,请重新填写", nil)] duration:1.5];
                }
                _view_DockView.userInteractionEnabled=YES;
                return @"1";
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Overseas"]){
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[[self getStandardAmountWithKey:@"unit"]isEqualToString:@"天"]&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:([NSString isEqualToNullAndZero:_txf_OverseasTotalDays.text]?_txf_OverseasTotalDays.text:@"1") with:standardAmount]];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻外补助标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻外补助标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,请重新填写", nil)] duration:1.5];
                }
                _view_DockView.userInteractionEnabled=YES;
                return @"1";
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Mobile"]){
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:standardAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model.overStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"通讯费标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"通讯费标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,请重新填写", nil)] duration:1.5];
                }
                _view_DockView.userInteractionEnabled=YES;
                return @"1";
            }
        }
    }
    return @"";
}

-(void)btn_Click:(UIButton *)btn{
    
    //费用类别
    if (btn.tag == 4) {
        if (_muarr_ExpenseCode.count == 0) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
            return;
        }
        if ([_str_ExpenseCode_level isEqualToString:@"1"]) {
            [self updateCateGoryView];
        }else if ([_str_ExpenseCode_level isEqualToString:@"2"]){
            STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
            pickerArea.DateSourceArray = [NSMutableArray arrayWithArray:_muarr_ExpenseCode];
            CostCateNewSubModel *model = [[CostCateNewSubModel alloc]init];
            model.expenseCode=  _str_expenseCode;
            pickerArea.typeTitle = Custing(@"费用类别", nil);
            pickerArea.CateModel = model;
            [pickerArea UpdatePickUI];
            [pickerArea setContentMode:STPickerContentModeBottom];
            
            if ([self.ClaimType integerValue] == 1){
                pickerArea.str_flowCode=@"F0002";
            }else if ([self.ClaimType integerValue] == 2){
                pickerArea.str_flowCode=@"F0003";
            }else if ([self.ClaimType integerValue] == 3){
                pickerArea.str_flowCode=@"F0010";
            }
            __weak typeof(self) weakSelf = self;
            [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
                if (![secondModel.expenseType isEqualToString:weakSelf.txf_ExpenseCode.text]) {
                    [self keyClose];
                    weakSelf.img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                    weakSelf.txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
                    weakSelf.str_expenseCode = secondModel.expenseCode;
                    weakSelf.str_expenseIcon = [NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15";
                    weakSelf.str_ExpenseCat = secondModel.expenseCat;
                    weakSelf.str_ExpenseCatCode = secondModel.expenseCatCode;
                    [weakSelf dealInvoiceDefultValue];
                }
            }];
            [pickerArea show];
        }else if([_str_ExpenseCode_level isEqualToString:@"3"]){
            ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
            ex.arr_DataList = _muarr_ExpenseCode;
            ex.str_CateLevel = _str_ExpenseCode_level;
            if ([self.ClaimType integerValue] == 1) {
                ex.str_flowCode = @"F0002";
            }else if ([self.ClaimType integerValue] == 2){
                ex.str_flowCode = @"F0003";
            }else if ([self.ClaimType integerValue] == 2){
                ex.str_flowCode = @"F0010";
            }
            __weak typeof(self) weakSelf = self;
            ex.CellClick = ^(CostCateNewSubModel *model) {
                if (![model.expenseType isEqualToString:weakSelf.txf_ExpenseCode.text]) {
                    [weakSelf keyClose];
                    weakSelf.img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
                    weakSelf.txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
                    weakSelf.str_expenseCode = model.expenseCode;
                    weakSelf.str_expenseIcon = [NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15";
                    weakSelf.str_ExpenseCat = model.expenseCat;
                    weakSelf.str_ExpenseCatCode = model.expenseCatCode;
                    [weakSelf dealInvoiceDefultValue];
                }
            };
            [self.navigationController pushViewController:ex animated:YES];
        }
    }else if (btn.tag == 8) {//成本中心
        __weak typeof(self) weakSelf = self;
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
        vc.ChooseCategoryId = _str_CostCenterId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            if (![[NSString stringWithFormat:@"%@",weakSelf.str_CostCenterId] isEqualToString:model.Id]) {
                weakSelf.str_CostCenterId = model.Id;
                weakSelf.txf_CostCenterId.text = model.costCenter;
                if ([self.ClaimType integerValue] != 3) {
                    weakSelf.img_ExpenseCode.image = nil;
                    weakSelf.txf_ExpenseCode.text = @"";
                    weakSelf.str_expenseCode = @"";
                    weakSelf.str_expenseIcon = @"";
                    weakSelf.str_ExpenseCat = @"";
                    weakSelf.str_ExpenseCatCode = @"";
                    weakSelf.sub_Expense.img_cate.image = nil;
                    [self requestGetTyps];
                    [weakSelf dealInvoiceDefultValue];
                }
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 16) {  //查看PDF文件
        if ([_dateSource integerValue]==16) {
            [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
            NSString *url=[NSString stringWithFormat:@"%@",GETWECHATPDF];
            NSDictionary *parameters=@{@"InvoiceCode":[NSString stringWithIdOnNO:_dic_request[@"result"][@"weiXinCardInv"][@"billing_no"]],
                                       @"InvoiceNumber":[NSString stringWithIdOnNO:_dic_request[@"result"][@"weiXinCardInv"][@"billing_code"]],
                                       };
            [[GPClient shareGPClient]REquestWeChatPDFByPostWithPath:url Parameters:parameters Delegate:self SerialNum:17 IfUserCache:NO];
        }else if ([_dateSource integerValue]==15) {
            PdfReadViewController *vc=[[PdfReadViewController alloc]init];
            vc.PdfUrl = _dic_request[@"result"][@"baiWCloudInv"][@"formatFile"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            PdfReadViewController *vc=[[PdfReadViewController alloc]init];
            vc.CheckAddModel=_model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)btn_route:(UIButton *)btn{
    MapRecordController *vc=[[MapRecordController alloc]init];
    vc.model=_model_route;
    [self.navigationController pushViewController:vc animated:YES];
}


//自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestGetSubmitExpStd{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_txf_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequestUserId,
                                 @"LocationId":_str_LocationId,
                                 @"BranchId":_str_BranchId,
                                 @"CheckInDate":[NSString stringWithIdOnNO:_txf_CheckInDate.text],
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_txf_AllowanceFromDate.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_txf_AllowanceToDate.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_str_TravelUserId],
                                 @"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId};
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:21 IfUserCache:NO];
}
#pragma mark - delegate
- (void)requestSuccess:(NSDictionary *)responceDic SerialNum:(int)serialNum {
    [YXSpritesLoadingView dismiss];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responceDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *stri = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
    NSLog(@"string%@",stri);
    NSString * success = [NSString stringWithFormat:@"%@",[responceDic objectForKey:@"success"]];
    if ([success isEqualToString:@"0"]){
        NSString * error = [responceDic objectForKey:@"msg"];
        if (![error isKindOfClass:[NSNull class]]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:error duration:1.0];
        }else if (serialNum == 13){
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前发票号码重复", nil) duration:1.0];
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        _view_DockView.userInteractionEnabled=YES;
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self createScrollView];
        [self createMainView];
        [self updateMainView];
        [self updateContentView];
        [self requestGetExpStd];
        [self requestGetExpStdAddFirst];
        [self requestGetTyps];
    }else if (serialNum == 1){
        _muarr_ExpenseCode = [NSMutableArray array];
        NSDictionary *parDict = [CostCateNewModel getCostCateByDict:responceDic array:_muarr_ExpenseCode withType:1];
        _str_ExpenseCode_level = parDict[@"CateLevel"];
        _inte_ExpenseCode_Rows =[parDict[@"categoryRows"]integerValue];
    }else if (serialNum == 17) {
        if ([NSString isEqualToNull:responceDic[@"result"]]) {
            PdfReadViewController *vc=[[PdfReadViewController alloc]init];
            vc.PdfUrl =[NSString stringWithFormat:@"%@",responceDic[@"result"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (serialNum == 2) {
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        _str_Status = responceDic[@"result"][@"status"];
        _str_Amount = [NSString reviseString:responceDic[@"result"][@"amount"]];
        _str_Amount2 = [NSString reviseString:responceDic[@"result"][@"amount2"]];
        _str_Amount3 = [NSString reviseString:responceDic[@"result"][@"amount3"]];
        _str_Unit = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"unit"]];
        _str_Class = responceDic[@"result"][@"class"];
        _str_Discount = responceDic[@"result"][@"discount"];
        _str_IsExpensed = [NSString stringWithIdOnNO:responceDic[@"result"][@"isExpense"]];
        _str_LimitMode = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"limitMode"]];
        if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
//            _dic_stdOutput = responceDic[@"result"][@"stdOutput"];
            _str_MealAmount = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"amount"]]?responceDic[@"result"][@"stdOutput"][@"amount"]:@"";
            _str_MealAmount1 = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"amount1"]]?responceDic[@"result"][@"stdOutput"][@"amount1"]:@"";
            _str_AllowanceCurrency = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"currency"]]?responceDic[@"result"][@"stdOutput"][@"currency"]:@"";
            _str_AllowanceCurrencyCode = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"currencyCode"]]?responceDic[@"result"][@"stdOutput"][@"currencyCode"]:@"";
            _str_AllowanceCurrencyRate = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"exchangeRate"]]?responceDic[@"result"][@"stdOutput"][@"exchangeRate"]:@"";
        }
        if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
            _str_Basis = responceDic[@"result"][@"basis"] ;
            [self update_Amount:_txf_TotalDays.text textField:[UITextField new]];
        }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]){
            if ([responceDic[@"result"][@"stdSelfDriveDtoList"] isKindOfClass:[NSArray class]]) {
                _arr_stdSelfDriveDtoList = responceDic[@"result"][@"stdSelfDriveDtoList"];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]){
        }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
        }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]){
            if ( [_str_Unit isEqualToString:@"天"]||[_str_Unit isEqualToString:@"月"]||[_str_Unit isEqualToString:@"年"]) {
                [self updateAllowanceView:[responceDic[@"result"][@"basis"] integerValue]];
            }else{
               
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Trans"]){
        }
        
        if (_bool_firstIn) {
            [self dealEditEndData];
            [self updateValue];
            [self updateExpenseCodeList_View];
            _bool_firstIn=NO;
        }
    }else if (serialNum == 21){
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        [self saveContinueInfo];
    }else if (serialNum ==20){
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        
        [self update_View_ExpenseCode_Click:_str_expenseCode_tag];
    }
    
}


-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    _view_DockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)dealEditEndData{
    for (MyProcurementModel *model in _muarr_MainView) {
        if ([model.fieldName isEqualToString:@"Amount"]) {
            _txf_Amount.text=[NSString stringWithIdOnNO:model.fieldValue];
        }else if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
            _txf_ExchangeRate.text=[NSString stringWithIdOnNO:model.fieldValue];
        }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
            _txf_LocalCyAmount.text=[NSString stringWithIdOnNO:model.fieldValue];
        }else if ([model.fieldName isEqualToString:@"TaxRate"]) {
            _txf_TaxRate.text=[NSString stringWithIdOnNO:model.fieldValue];
        }else if ([model.fieldName isEqualToString:@"Tax"]) {
            _txf_Tax.text=[NSString stringWithIdOnNO:model.fieldValue];
        }else if ([model.fieldName isEqualToString:@"ExclTax"]) {
            _txf_ExclTax.text=[NSString stringWithIdOnNO:model.fieldValue];
        }
    }
}
#pragma mark  UICollectionViewDelegateFlowLayout  CollectionView Delegate & DataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Main_Screen_Width/5, 65);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView==_col_CategoryCollectView) {
        return CGSizeMake(Main_Screen_Width, 10);
    }else{
        return CGSizeZero;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _muarr_ExpenseCode.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _col_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectCell" forIndexPath:indexPath];
    [_col_cell configWithArray:_muarr_ExpenseCode withRow:indexPath.row];
    return _col_cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==_col_CategoryCollectView) {
        [self keyClose];
        CostCateNewModel *model=_muarr_ExpenseCode[indexPath.row];
        if (![model.expenseType isEqualToString:_txf_ExpenseCode.text]) {
            _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15"];
            _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[model.expenseCat,model.expenseType]];
            _str_expenseCode = model.expenseCode;
            _str_expenseIcon = [NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15";
            _str_ExpenseCat = model.expenseCat;
            _str_ExpenseCatCode = model.expenseCatCode;
            [_sub_Expense setCateImg:_str_expenseIcon];
            [self dealInvoiceDefultValue];
            [self updateCateGoryView];
        }else{
            [self updateCateGoryView];
        }
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        return _arr_Flight.count;
    }else if (pickerView == _pic_CurrencyCode){
        return _muarr_CurrencyCode.count;
    }else if (pickerView == _pic_InvoiceType){
        return _arr_InvoiceType.count;
    }
    return _arr_ClaimType.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        return _arr_Flight[row];
    }else if (pickerView == _pic_InvoiceType){
        return _arr_InvoiceType[row];
    }
    return _arr_ClaimType[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        _str_Flight = _arr_Flight[row];
    }else if (pickerView == _pic_CurrencyCode){
        _str_Currency = [NSString stringWithFormat:@"%ld",(long)row];
    }else if (pickerView == _pic_InvoiceType){
        _str_InvoiceType = _arr_InvoiceType[row];
    }else{
        _str_ClaimType = _arr_ClaimType[row];
        _ClaimType = [NSString stringWithFormat:@"%ld",row+1];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
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
    if (textView.text.length>200) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:@"最长输入200个字符" duration:1.0];
        textView.text = [textView.text substringToIndex:199];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self changeRemarkView];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    BOOL retu = YES;
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {//按下return
        retu = YES;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *pattern;
    if (_txf_Amount == textField||_txf_Tax == textField) {
        pattern = @"^-?((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
    }else if (_txf_ExchangeRate == textField){
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,4})?)?$";
    }
    NSError *error = nil;
    NSUInteger match = 0;
    if (_txf_Amount == textField||_txf_Tax == textField||_txf_ExchangeRate == textField) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if (match==0) {
            return 0;
        }
    }
    if (_txf_Amount == textField) {
        _txf_LocalCyAmount.text =[GPUtils transformNsNumber: [GPUtils decimalNumberMultipWithString:newString with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
        _txf_Tax.text = [GPUtils decimalNumberMultipWithString:_txf_LocalCyAmount.text with: [NSString stringWithFormat:@"%.2f%%",[_txf_TaxRate.text floatValue]/100]];
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?newString:_txf_LocalCyAmount.text with:_txf_Tax.text];
        
        NSString *local1 = [GPUtils decimalNumberMultipWithString:newString with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate]?self.str_InvCyPmtExchangeRate:@"1.0000")];
        local1 = [GPUtils getRoundingOffNumber:local1 afterPoint:2];
        self.txf_InvPmtAmount.text = [GPUtils transformNsNumber:local1];
        _txf_InvPmtTax.text = [NSString countTax:!_txf_LocalCyAmount?newString:_txf_LocalCyAmount.text taxrate:_txf_TaxRate.text];
        self.txf_InvPmtAmountExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local1 with:self.txf_InvPmtTax.text]];
        
        if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
            [self update_Amount:newString textField:textField];
        }
    }else if (_txf_Tax == textField){
        _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:newString];
    }else if (_txf_ExchangeRate == textField){
        _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:newString]];
        _txf_Tax.text = [GPUtils decimalNumberMultipWithString:_txf_LocalCyAmount.text with: [NSString stringWithFormat:@"%.2f%%",[_txf_TaxRate.text floatValue]/100]];
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
    }else if (_txf_TotalDays == textField||_txf_Lunch == textField||_txf_Breakfast == textField||_txf_Supper == textField||_txf_Mileage == textField||_txf_FuelBills == textField||_txf_Pontage == textField||_txf_ParkingFee == textField||_txf_Day == textField){
        [self update_Amount:newString textField:textField];
    }
    if (_txf_Amount == textField) {
        [self AmountChangeAgainWithNewString:newString WithType:1];
    }else if (_txf_ExchangeRate == textField){
        [self AmountChangeAgainWithNewString:newString WithType:2];
    }
    if (retu) {
        return  retu;
    }else{
        return match!= 0;
    }
    return YES;
}

-(void)AmountChangeAgainWithNewString:(NSString *)newstring WithType:(NSInteger)type{
    NSString *local;
    NSString *local1;
    
    if (type==1) {
        local = [GPUtils decimalNumberMultipWithString:newstring with:[self getEndExchangeRate]];
        local1 = [GPUtils decimalNumberMultipWithString:newstring with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
    }else if (type==2){
        local = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:newstring];
        local1 = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
    }else if (type==3){
        local = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:[self getEndExchangeRate]];
        local1 = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
    }
    local = [GPUtils getRoundingOffNumber:local afterPoint:2];
    self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:local];
    
    NSString *airLoc = [NSString stringWithFormat:@"%@",local];
    NSString *payLoc = [GPUtils getRoundingOffNumber:local1 afterPoint:2];
    NSString *airLoc1 = payLoc;
    if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
        airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
    }
    self.txf_Tax.text = [NSString countTax:airLoc taxrate:self.txf_TaxRate.text];
    self.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:local with:self.txf_Tax.text];
    
    self.txf_InvPmtAmount.text = payLoc;
    self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
    self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
    
    _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:local with:_txf_TotalDays.text] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"]) afterPoint:2];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_txf_Amount == textField||_txf_Tax == textField){
        if (textField.text.length!=0) {
            NSString *subStr = [textField.text substringFromIndex:textField.text.length-1];
            if ([subStr isEqualToString:@"."]) {
                textField.text=[textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _alt_Warring) {
        if (buttonIndex==1) {
            [self saveInfo];
        }
    }else{
        if (buttonIndex==1) {
            [_imagesArray removeObjectAtIndex:alertView.tag];
            //            [self updateImageData];
            if (_imagesArray.count>0) {
                [self.imgCollectView reloadData];
            }else{
                [self.imgCollectView reloadData];
                [self updateImageCollect];
            }
        }else{
            _view_DockView.userInteractionEnabled = YES;
        }
    }
}



-(void)dimsissPDActionView{
    _cho_datelView = nil;
}

//MARK:币种代理
- (void)pickerCategory:(STOnePickView *)pickerCategory Model:(STOnePickModel *)Model withType:(NSInteger)type{
    _str_CurrencyCode=Model.Id;
    _str_Currency=Model.Type;
    _txf_CurrencyCode.text=Model.Type;
    _txf_ExchangeRate.text=Model.exchangeRate;
    _str_ExchangeRate=Model.exchangeRate;
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:_str_ExchangeRate]]];
    _txf_Tax.text = [GPUtils decimalNumberMultipWithString:_txf_LocalCyAmount.text with: [NSString stringWithFormat:@"%.2f%%",[_txf_TaxRate.text floatValue]/100]];
    _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:_txf_LocalCyAmount.text with:_txf_Tax.text];
}


//地址返回
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start{
    _dic_CityCode = array[0];
    _str_CityType = _dic_CityCode[@"cityType"];
    _str_CityCode = _dic_CityCode[@"cityCode"];
    _str_City = [self.userdatas.language isEqualToString:@"ch"]?_dic_CityCode[@"cityName"]:[NSString isEqualToNull:_dic_CityCode[@"cityNameEn"]]?_dic_CityCode[@"cityNameEn"]:_dic_CityCode[@"cityName"];
    if ([start isEqualToString:@"1"]) {
        _txf_CityName.text = [self.userdatas.language isEqualToString:@"ch"]?_dic_CityCode[@"cityName"]:[NSString isEqualToNull:_dic_CityCode[@"cityNameEn"]]?_dic_CityCode[@"cityNameEn"]:_dic_CityCode[@"cityName"];
    }else{
        _txf_City.text = [self.userdatas.language isEqualToString:@"ch"]?_dic_CityCode[@"cityName"]:[NSString isEqualToNull:_dic_CityCode[@"cityNameEn"]]?_dic_CityCode[@"cityNameEn"]:_dic_CityCode[@"cityName"];
    }
    [self requestGetExpStd];
}

//选择同行人员
-(void)contactsVCClickedLoadBtn:(NSMutableArray *)array type:(NSString *)type
{
    _arr_FellowOfficersId = [[NSMutableArray alloc]init];
    
    NSString *nameid = @"";
    NSString *name = @"";
    for (int i = 0 ; i<array.count ; i++) {
        buildCellInfo *info = array[i];
        NSDictionary *dic = @{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)info.requestorUserId]};
        if (i == 0) {
            nameid = [NSString stringWithFormat:@"%ld",(long)info.requestorUserId];
            name = info.requestor;
        }
        else
        {
            nameid = [NSString stringWithFormat:@"%@,%ld",nameid,(long)info.requestorUserId];
            name = [NSString stringWithFormat:@"%@,%@",name,info.requestor];
        }
        _str_FellowOfficersId = nameid;
        [_arr_FellowOfficersId addObject:dic];
    }
    _txf_FellowOfficers.text = [NSString isEqualToNull:name]?name:@"";
}

-(NSString *)getLocalCyAmount{
    NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:[self getEndExchangeRate]];
    LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
    LocalCyAmount=[NSString isEqualToNull:LocalCyAmount]?LocalCyAmount:@"0.00";
    return LocalCyAmount;
    
}

-(NSString *)getEndExchangeRate{
    NSString *exchange= [NSString isEqualToNull:self.txf_ExchangeRate.text]?self.txf_ExchangeRate.text:@"1.0000";
    return exchange;
}
-(NSString *)getStandardHasCurrency{
    
    NSString *standard=nil;
    if (_dict_Standard_StdOutput) {
        NSString *amount=[NSString stringWithIdOnNO:_dict_Standard_StdOutput[@"amount"]];
        if ([_str_expenseCode_tag isEqualToString:@"Allowance"]&&[[NSString stringWithFormat:@"%@",_dict_Standard[@"basis"]]isEqualToString:@"3"]&&[_str_MealType isEqualToString:@"1"]) {
            amount=[NSString stringWithIdOnNO:_dict_Standard_StdOutput[@"amount1"]];
        }
        NSString *currencyCode=[NSString stringWithIdOnNO:_dict_Standard_StdOutput[@"currencyCode"]];
        NSString *exchangeRate=[NSString stringWithIdOnNO:_dict_Standard_StdOutput[@"exchangeRate"]];
        if (![NSString isEqualToNull:currencyCode]) {
            standard = amount;
        }else if ([_str_AllowanceCurrencyCode isEqualToString:_str_CurrencyCode]) {
            standard = [GPUtils decimalNumberMultipWithString:amount with:[self getEndExchangeRate]];
        }else{
            standard = [GPUtils decimalNumberMultipWithString:amount with:exchangeRate];
        }
        standard=[GPUtils getRoundingOffNumber:standard afterPoint:2];
        if ([standard floatValue]==0) {
            standard=nil;
        }
    }
    return standard;
}

-(NSString *)getStandardAmountWithKey:(NSString *)key{
    NSString *result=nil;
    if (_dict_Standard) {
        result=[NSString stringWithIdOnNO:_dict_Standard[key]];
        if ([key isEqualToString:@"amount"]||[key isEqualToString:@"amount2"]||[key isEqualToString:@"amount3"]||[key isEqualToString:@"discount"]) {
            result=[GPUtils getRoundingOffNumber:result afterPoint:2];
            if ([result floatValue]==0) {
                result=nil;
            }
        }
    }
    return result;
}
-(BOOL)compareAmountWithStr:(NSString *)str withSecStr:(NSString *)secStr{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *num1 = [numberFormatter numberFromString:str];
    NSNumber *num2 = [numberFormatter numberFromString:secStr];
    NSComparisonResult r = [num1 compare:num2];
    NSLog(@"r = %ld", r);//r = 0
    if (r == NSOrderedAscending) {//可改为if(r == -1L)
        return NO;//NSLog(@"num1小于num2");
    }else if(r == NSOrderedSame) {//可改为if(r == 0L)
        return YES;//NSLog(@"num1等于num2");
    }else if(r == NSOrderedDescending) {//可改为if(r == 1)
        return YES;//NSLog(@"num1大于num2");
    }
    return NO;
}
-(NSString *)returnSelfCarAmount:(NSString *)str{
    if ([NSString isEqualToNull:str]) {
        NSString *returnAmount = @"0";
        if (_arr_stdSelfDriveDtoList.count>0) {
            for (int i = 0; i<_arr_stdSelfDriveDtoList.count; i++) {
                NSDictionary *dic = _arr_stdSelfDriveDtoList[i];
                if ([[GPUtils decimalNumberSubWithString:str with:dic[@"mileageFrom"]]floatValue]>0&&[[GPUtils decimalNumberSubWithString:dic[@"mileageTo"] with:str]floatValue]>=0) {
                    returnAmount = [NSString stringWithFormat:@"%@",dic[@"amount"]];
                }
            }
        }
        return returnAmount;
    }
    return @"0";
}

#pragma mark - UITableViewDataSource 协议方法
// 返回参数2指定分组的行数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array_shareData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddReimShareModel *model = self.array_shareData[indexPath.row];
    return [ProcureDetailsCell AddReimShareCellHeightWithArray:self.array_shareForm WithModel:model];
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
    [cell configAddReimShareCellWithArray:self.array_shareForm withDetailsModel:self.array_shareData[indexPath.row] withindex:indexPath.row withCount:self.array_shareData.count] ;
    if (cell.LookMore) {
        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}
//MARK:查看更多明细
-(void)LookMore:(UIButton *)btn{
    self.bool_isOpenShare = !self.bool_isOpenShare;
    [btn setImage: self.bool_isOpenShare ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
    [btn setTitle: self.bool_isOpenShare ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
    [self updateShareTableView];
}
/**
 更新发票类型相关数据 1发票类型改变 2日期改变
 */
-(void)updateInvoiceTypeViesWithType:(NSInteger)type{
    _view_TaxRate.userInteractionEnabled = YES;
    [self.view_ContentView layoutIfNeeded];
    if ([_str_InvoiceType floatValue] == 1 && _view_InvoiceType.zl_height > 0) {
        if ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"]) {
            if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                _view_TaxRate.userInteractionEnabled = NO;
                if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                    [_View_AirlineFuelFee mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                    
                    _txf_AirlineFuelFee.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberAddWithString:self.txf_AirTicketPrice.text with:self.txf_FuelSurcharge.text] afterPoint:2];
                    
                    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }else{
                    [_View_AirlineFuelFee mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                    _txf_AirlineFuelFee.text = @"";
                    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                    _txf_AirTicketPrice.text = @"";
                    
                    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                    _txf_DevelopmentFund.text = @"";
                    
                    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                    _txf_FuelSurcharge.text = @"";
                    
                    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@0);
                    }];
                    _txf_OtherTaxes.text = @"";
                }
                if (self.txf_TaxRate) {
                    [_view_TaxRate mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
                if (self.txf_Tax) {
                    [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
                if (self.txf_ExclTax) {
                    [_view_ExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
                if (self.txf_InvPmtTax) {
                    [_View_InvPmtTax mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
                if (self.txf_InvPmtAmountExclTax) {
                    [_View_InvPmtAmountExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", self.str_InvoiceTypeCode];
                NSArray *filterArray1 = [self.arr_InvoiceType filteredArrayUsingPredicate:pred1];
                if (filterArray1.count > 0) {
                    STOnePickModel *model = filterArray1[0];
                    _txf_TaxRate.text = model.taxRate;
                    
                    NSString *airLoc = [self getLocalCyAmount];
                    NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                    NSString *airLoc1 = payLoc;
                    if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                        airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
                    }
                    _txf_Tax.text = [NSString countTax:airLoc taxrate:_txf_TaxRate.text];
                    _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
                    
                    self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
                    self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
                    
                }else{
                    _txf_TaxRate.text = @"0";
                    NSString *airLoc = [self getLocalCyAmount];
                    NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                    NSString *airLoc1 = payLoc;
                    if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                        airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
                    }
                    
                    _txf_Tax.text = [NSString countTax:airLoc taxrate:_txf_TaxRate.text];
                    _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
                    
                    self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
                    self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
                    
                }
            }else{
                _view_TaxRate.userInteractionEnabled = YES;
                
                [_View_AirlineFuelFee mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_View_AirTicketPrice mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_View_DevelopmentFund mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_View_FuelSurcharge mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_View_OtherTaxes mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_view_TaxRate mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_view_ExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                
                [_View_InvPmtTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [_View_InvPmtAmountExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                
                _txf_AirlineFuelFee.text = @"";
                _txf_AirTicketPrice.text = @"";
                _txf_DevelopmentFund.text = @"";
                _txf_FuelSurcharge.text = @"";
                _txf_OtherTaxes.text = @"";
                _txf_TaxRate.text = @"";
                _txf_Tax.text = @"";
                _txf_ExclTax.text = @"";
                _txf_InvPmtTax.text = @"";
                _txf_InvPmtAmountExclTax.text = @"";
            }
        }else{
            
            [_View_AirlineFuelFee mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_AirlineFuelFee.text = @"";
            [_View_AirTicketPrice mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_AirTicketPrice.text = @"";
            [_View_DevelopmentFund mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_DevelopmentFund.text = @"";
            [_View_FuelSurcharge mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_FuelSurcharge.text = @"";
            [_View_OtherTaxes mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_OtherTaxes.text = @"";
            
            if (self.txf_TaxRate) {
                [_view_TaxRate mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
            if (self.txf_Tax) {
                [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
            if (self.txf_ExclTax) {
                [_view_ExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
            if (self.txf_InvPmtTax) {
                [_View_InvPmtTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
            if (self.txf_InvPmtAmountExclTax) {
                [_View_InvPmtAmountExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
            }
            if (type == 1) {
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"isDefault MATCHES %@", @"1"];
                NSArray *filterArray2 = [self.arr_TaxRates filteredArrayUsingPredicate:pred2];
                if (filterArray2.count > 0) {
                    STOnePickModel *model = filterArray2[0];
                    _txf_TaxRate.text = model.Type;
                    
                    NSString *airLoc = [self getLocalCyAmount];
                    NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                    NSString *airLoc1 = payLoc;
                    if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                        airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
                    }
                    _txf_Tax.text = [NSString countTax:airLoc taxrate:_txf_TaxRate.text];
                    _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
                    
                    self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
                    self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
                }else{
                    _txf_TaxRate.text = @"0";
                    NSString *airLoc = [self getLocalCyAmount];
                    NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                    NSString *airLoc1 = payLoc;
                    if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                        airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                        airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
                    }
                    _txf_Tax.text = [NSString countTax:airLoc taxrate:_txf_TaxRate.text];
                    _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
                    
                    self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
                    self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
                    
                }
            }
        }
    }else{
        
        [_View_AirlineFuelFee mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_View_AirTicketPrice mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_View_DevelopmentFund mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_View_FuelSurcharge mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_View_OtherTaxes mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_view_TaxRate mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_view_ExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [_View_InvPmtTax mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [_View_InvPmtAmountExclTax mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        
        _txf_AirlineFuelFee.text = @"";
        _txf_AirTicketPrice.text = @"";
        _txf_DevelopmentFund.text = @"";
        _txf_FuelSurcharge.text = @"";
        _txf_OtherTaxes.text = @"";
        _txf_TaxRate.text = @"";
        _txf_Tax.text = @"";
        _txf_ExclTax.text = @"";
        _txf_InvPmtTax.text = @"";
        _txf_InvPmtAmountExclTax.text = @"";
    }
}
-(void)dealInvoiceDefultValue{
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"isDefault MATCHES %@", @"1"];
    NSArray *filterArray = [self.arr_InvoiceType filteredArrayUsingPredicate:pred1];
    if (filterArray.count > 0) {
        STOnePickModel *model = filterArray[0];
        self.str_InvoiceType = model.invoiceType;
        self.str_InvoiceTypeName = model.Type;
        self.str_InvoiceTypeCode = model.Id;
        self.txf_InvoiceType.text = model.Type;
    }
    if ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"]) {
        if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", self.str_InvoiceTypeCode];
            NSArray *filterArray1 = [self.arr_InvoiceType filteredArrayUsingPredicate:pred1];
            if (filterArray1.count > 0) {
                STOnePickModel *model = filterArray1[0];
                _txf_TaxRate.text = model.taxRate;
                NSString *airLoc = [self getLocalCyAmount];
                NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                NSString *airLoc1 = payLoc;
                if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                    airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                    airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
                }
                self.txf_Tax.text = [NSString countTax:airLoc taxrate:self.txf_TaxRate.text];
                self.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:self.txf_Tax.text];
                
                self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
                self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
            }
        }
    }else{
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"isDefault MATCHES %@", @"1"];
        NSArray *filterArray2 = [self.arr_TaxRates filteredArrayUsingPredicate:pred2];
        if (filterArray2.count > 0) {
            STOnePickModel *model = filterArray2[0];
            _txf_TaxRate.text = model.Type;
            NSString *airLoc = [self getLocalCyAmount];
            NSString *payLoc = [GPUtils decimalNumberMultipWithString:self.txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
            NSString *airLoc1 = payLoc;
            if ([_str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:self.txf_AirlineFuelFee.text]];
                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:self.txf_AirlineFuelFee.text]];
            }
            self.txf_Tax.text = [NSString countTax:airLoc taxrate:self.txf_TaxRate.text];
            self.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:self.txf_Tax.text];
            
            self.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:self.txf_TaxRate.text];
            self.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:self.txf_InvPmtTax.text];
        }
    }
    
    [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [_view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    _view_TaxRate.userInteractionEnabled = YES;
    
    if ([NSString isEqualToNull:_str_expenseCode]) {
        for (int i = 0; i<_arr_expenseCodeList.count; i++) {
            NSDictionary *dic = _arr_expenseCodeList[i];
            if ([_str_expenseCode isEqualToString:dic[@"expenseCode"]]) {
                if ([_str_InvoiceType floatValue] == 1) {
                    if ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"]) {
                        if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                            _view_TaxRate.userInteractionEnabled = NO;
                            if ([self.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                                [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                                [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_Tax != nil) {
                                [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_ExclTax != nil) {
                                [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            
                            if (_txf_InvPmtTax != nil) {
                                [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_InvPmtAmountExclTax != nil) {
                                [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                            if (_txf_TaxRate != nil) {
                                [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(@50);
                                }];
                            }
                        }
                    }else{
                        if (_txf_Tax != nil) {
                            [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_ExclTax != nil) {
                            [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        
                        if (_txf_InvPmtTax != nil) {
                            [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_InvPmtAmountExclTax != nil) {
                            [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                        if (_txf_TaxRate != nil) {
                            [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(@50);
                            }];
                        }
                    }
                }
                if (_txf_InvoiceType!=nil) {
                    [_view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@50);
                    }];
                }
            }
        }
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
