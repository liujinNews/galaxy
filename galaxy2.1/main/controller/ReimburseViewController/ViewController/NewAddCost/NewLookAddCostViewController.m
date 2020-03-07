//
//  NewLookAddCostViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/4/5.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NewLookAddCostViewController.h"
#import "NewAddCostModel.h"
#import "ChooseCategoryModel.h"
#import "PdfReadViewController.h"
#import "PDFLookViewController.h"
#import "RouteDetailView.h"
#import "MapRecordController.h"

static NSString *const CellIdentifier = @"addCostCell";

@interface NewLookAddCostViewController ()<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

//框架用view
@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView

@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

@property (nonatomic, strong) UIAlertView *alt_Warring;//弹出超预算框

//内部视图
@property (nonatomic, strong) UIView *view_Amount;//金额视图
@property (nonatomic, strong) UILabel *lab_Amount;

@property (nonatomic, strong) UIView *view_CurrencyCode;//币种视图
@property (nonatomic, strong) UILabel *lab_CurrencyCode;
@property (nonatomic, strong) NSString *str_CurrencyCode_PlaceHolder;

@property (nonatomic, strong) UIView *view_ExchangeRate;//汇率
@property (nonatomic, strong) NSString *str_ExchangeRate;

@property (nonatomic, strong) UIView *view_LocalCyAmount;//本位币视图

@property (nonatomic, strong) UIView *view_InvoiceType;//发票类型
@property (nonatomic, strong) NSString *str_InvoiceType;
@property (nonatomic, strong) UILabel *lab_InvoiceType;

@property (nonatomic, strong) UIView *view_TaxRate;//税率
@property (nonatomic, strong) UILabel *lab_TaxRate;

@property (nonatomic, strong) UIView *view_Tax;//税额
@property (nonatomic, strong) UILabel *lab_Tax;

@property (nonatomic, strong) UIView *view_ExclTax;//不含税金额
@property (nonatomic, strong) UILabel *lab_ExclTax;

@property (nonatomic, strong) UIView *view_ClaimType;//报销类型
@property (nonatomic, strong) UILabel *lab_ClaimType;
@property (nonatomic, strong) UIPickerView *pic_ClaimType;
//@property (nonatomic, strong) NSString *str_ClaimType;

@property (nonatomic, strong) UIView *view_ExpenseCode;//费用类别
@property (nonatomic, strong) UILabel *lab_ExpenseCode;
@property (nonatomic, strong) UIImageView *img_ExpenseCode;
@property (nonatomic, strong) UIImageView *img_CateImage;//费用类别image
@property (nonatomic, strong) UIView *view_ExpenseCode_Click;//费用类别选择后

@property (nonatomic, strong) NSDictionary *dic_ExpenseCode_requst;
@property (nonatomic, strong) NSMutableArray *muarr_ExpenseCode;//更新后显示用数据
@property (nonatomic, strong) NSString *str_CurrencyCode;

@property (nonatomic, strong) NSString *str_ExpenseCode_level;
@property (nonatomic, strong) NSString *str_expenseCode;//费用类别编码
@property (nonatomic, strong) NSString *str_expenseIcon;//费用类别图片编码
@property (nonatomic, assign) NSInteger inte_ExpenseCode_Rows;
@property (nonatomic, assign) BOOL bool_isOpenGener;//费用类型是否打开的
@property (nonatomic, strong) NSString *str_ExpenseCatCode;//费用大类代码
@property (nonatomic, strong) NSString *str_ExpenseCat;//费用大类
@property (nonatomic, strong) NSString *str_expenseCode_tag;//费用大类

@property (nonatomic, strong) UIView *view_ExpenseDate;//日期
@property (nonatomic, strong) UILabel *lab_ExpenseDate;
@property (nonatomic, strong) NSString *str_day;
//@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;//

@property (nonatomic, strong) UIView *view_InvoiceNo;//发票号码
//@property (nonatomic, strong) UITextField *txf_InvoiceNo;

@property (nonatomic, strong) UIView *view_HasInvoice;//是否有发票
@property (nonatomic, strong) UILabel *lab_HasInvoice;
@property (nonatomic, copy) NSString *str_HasInvoice;
@property (nonatomic, strong) NSMutableArray *array_HasInvoice;

//@property (nonatomic, strong) UIButton *btn_HasInvoice_Yes;
//@property (nonatomic, strong) UIButton *btn_HasInvoice_No;

@property (nonatomic, strong) UIView *view_NoInvReason;//原因
//@property (nonatomic, strong) UITextField *txf_NoInvReason;

@property (nonatomic, strong) UIView *view_ReplExpense;//替票费用类别
@property (nonatomic, copy) NSString *str_ReplExpenseType;//替票类型


@property (nonatomic, strong) UIView *view_ThreePartPdf;//三方PDF


@property (nonatomic, strong) UIView *view_Attachments;//上传发票
@property (nonatomic, strong) UICollectionViewFlowLayout *col_layOut;//网格规则
@property (nonatomic, strong) NSString *str_imageDataString;//上传服务器图片
@property (nonatomic, strong) NSMutableArray *imagesArray;//图片数组
@property (nonatomic, strong) NSMutableArray *muarr_imageTypeArray;//为相册和相机返回的类型图片数组
@property (nonatomic, strong) UIAlertView *art_deleteImagesAler;//删除图片警告框

@property (nonatomic, strong) WorkFormFieldsModel *model_Files;
@property (nonatomic, strong) NSMutableArray *arr_FilesTotle;
@property (nonatomic, strong) NSMutableArray *arr_FilesImage;

@property (nonatomic, strong) UIView *view_CostCenterId;//成本中心
@property (nonatomic, strong) UILabel *lab_CostCenterId;

@property (nonatomic, strong) UIView *view_ProjId;//项目名称
@property (nonatomic, strong) UILabel *lab_ProjId;


@property (nonatomic, strong) UIView *View_ProjActivity;//项目活动视图
@property (nonatomic, copy) NSString *str_ProjectActivityLv1;
@property (nonatomic, copy) NSString *str_ProjectActivityLv1Name;
@property (nonatomic, copy) NSString *str_ProjectActivityLv2;
@property (nonatomic, copy) NSString *str_ProjectActivityLv2Name;

@property (nonatomic, strong) UIView *view_ClientId;//客户名称
@property (nonatomic, strong) UILabel *lab_ClientId;

@property (nonatomic, strong) UIView *View_Supplier;
@property (nonatomic, strong) NSString *str_Supplier;


@property (nonatomic, strong) UIView *view_ExpenseDesc;//费用描述

@property (nonatomic, strong) UIView *view_Remark;//备注

@property (nonatomic, strong) NSString *str_RequstUserId;

//自定义字段
@property (nonatomic, strong) UIView *Reserved1View;
@property (nonatomic, strong) UIView *Reserved2View;
@property (nonatomic, strong) UIView *Reserved3View;
@property (nonatomic, strong) UIView *Reserved4View;
@property (nonatomic, strong) UIView *Reserved5View;
@property (nonatomic, strong) UIView *Reserved6View;
@property (nonatomic, strong) UIView *Reserved7View;
@property (nonatomic, strong) UIView *Reserved8View;
@property (nonatomic, strong) UIView *Reserved9View;
@property (nonatomic, strong) UIView *Reserved10View;

@property (nonatomic, strong) UIView *view_RouteDetail;

//住宿
@property (nonatomic, strong) NSString *str_CityCode;
@property (nonatomic, strong) UITextField *txf_CityName;
@property (nonatomic, strong) NSString *str_CityType;
@property (nonatomic, strong) UITextField *txf_TotalDays;
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
@property (nonatomic, strong) UITextField *txf_AllowanceAmount;
@property (nonatomic, strong) UITextField *txf_AllowanceUnit;
@property (nonatomic, strong) UITextField *txf_OverStd;
@property (nonatomic, strong) UITextField *txf_Tag;
@property (nonatomic, strong) UITextField *txf_TransDCityName;
@property (nonatomic, strong) UITextField *txf_TransACityName;
@property (nonatomic, strong) UITextField *txf_TransFromDate;
@property (nonatomic, strong) UITextField *txf_TransToDate;
@property (nonatomic, strong) UITextField *txf_TransTotalDays;
@property (nonatomic, strong) UITextField *txf_TransTypeId;
@property (nonatomic, strong) NSString *str_TransType;
@property (nonatomic, assign) NSInteger int_TransTimeType;//市内交通选择时间格式1:日期 2时间(默认)


//驻办
@property (nonatomic, strong) NSString *str_LocationId;
@property (nonatomic, strong) NSString *str_Location;
@property (nonatomic, strong) NSString *str_OfficeFromDate;
@property (nonatomic, strong) NSString *str_OfficeToDate;
@property (nonatomic, strong) NSString *str_OfficeTotalDays;
//驻外
@property (nonatomic, strong) NSString *str_BranchId;
@property (nonatomic, strong) NSString *str_Branch;
@property (nonatomic, strong) NSString *str_OverseasFromDate;
@property (nonatomic, strong) NSString *str_OverseasToDate;
@property (nonatomic, strong) NSString *str_OverseasTotalDays;


@property (nonatomic, strong) NSString *str_City;
@property (nonatomic, strong) NSString *str_AllowanceAmount;

@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;

@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;

//验证信息
@property (nonatomic, strong) NSString *str_Status;
@property (nonatomic, strong) NSString *str_Amount;
@property (nonatomic, strong) NSString *str_Amount1;
@property (nonatomic, strong) NSString *str_Amount2;
@property (nonatomic, strong) NSString *str_Amount3;
@property (nonatomic, strong) NSString *str_Unit;
@property (nonatomic, strong) NSString *str_Class;
@property (nonatomic, strong) NSString *str_Discount;
@property (nonatomic, strong) NSString *str_IsExpensed;
@property (nonatomic, strong) NSString *str_LimitMode;

@property (nonatomic, strong) NSDictionary *dic_stdOutput;
@property (nonatomic, strong) NSString *str_MealType;
@property (nonatomic, strong) NSString *str_MealAmount;
@property (nonatomic, strong) NSString *str_MealAmount1;
@property (nonatomic, strong) NSString *str_AllowanceCurrency;
@property (nonatomic, strong) NSString *str_AllowanceCurrencyCode;
@property (nonatomic, strong) NSString *str_AllowanceCurrencyRate;
@property (nonatomic, strong) NSString *str_Basis;
@property (nonatomic, strong) NSArray *arr_stdSelfDriveDtoList;
@property (nonatomic, strong) NSString *str_MedicalAmount;
//存储数据
@property (nonatomic, strong) NSDictionary *dic_request;//请求后保存的数据
@property (nonatomic, strong) NSMutableArray *muarr_MainView;//显示用数组
@property (nonatomic, strong) NSMutableArray *arr_image;
@property (nonatomic, strong) NewAddCostModel *model_NewAddCost;//上传需用数据
@property (nonatomic, assign) int int_update;
@property (nonatomic, strong) NSArray *arr_expenseCodeList;
@property (nonatomic, strong) NSMutableArray *totalArray;

@property (nonatomic, strong)MyProcurementModel *model_AllowanceFromDate;
@property (nonatomic, strong)MyProcurementModel *model_AllowanceToDate;
@property (nonatomic, strong) UITextField *txf_AllowanceFromDate;
@property (nonatomic, strong) UITextField *txf_AllowanceToDate;
@property (nonatomic, strong)MyProcurementModel *model_TravelUserName;
@property (nonatomic, copy) NSString *str_TravelUserId;

@property (nonatomic, copy) NSString *str_CorpCarFromDate;//用车期间开始
@property (nonatomic, copy) NSString *str_CorpCarToDate;//用车期间结束

@property (nonatomic, copy) NSString *str_ReceptionFellowOfficers;//同行人员

@property (nonatomic, strong) UIView *view_ReimPolicyUp;//报销政策视图
@property (nonatomic, strong) UIView *view_ReimPolicyDown;//报销政策视图
@property (nonatomic, strong) NSDictionary *dic_ReimPolicy;// 报销政策字典
@property (nonatomic, strong) UIView *view_PayType;//支付方式

@property (nonatomic, strong) NSDictionary *dict_Standard;//标准集合1
@property (nonatomic, strong) NSDictionary *dict_Standard_StdOutput;//标准集合2

@property (nonatomic, strong) NSMutableArray *arr_ClaimType;//报销类型
@property (nonatomic, strong) NSString *str_InvoiceTypeName;
@property (nonatomic, strong) NSString *str_InvoiceTypeCode;
@property (nonatomic, strong) NSMutableArray *arr_InvoiceType;//发票类型

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
@property (nonatomic, strong) UILabel *lab_InvPmtTax;
/**
 付款不含税金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmountExclTax;
@property (nonatomic, strong) UILabel *lab_InvPmtAmountExclTax;

/**
 机票和燃油附加费合计视图
 */
@property (nonatomic, strong) UIView *View_AirlineFuelFee ;
@property (nonatomic, strong) UILabel *lab_AirlineFuelFee ;
@property (nonatomic, copy) NSString *str_AirlineFuelFee ;


@property (nonatomic, strong) UIView *View_AirTicketPrice;
@property (nonatomic, strong) UILabel *lab_AirTicketPrice;
@property (nonatomic, copy) NSString *str_AirTicketPrice;

@property (nonatomic, strong) UIView *View_DevelopmentFund;
@property (nonatomic, strong) UILabel *lab_DevelopmentFund;
@property (nonatomic, copy) NSString *str_DevelopmentFund;

@property (nonatomic, strong) UIView *View_FuelSurcharge;
@property (nonatomic, strong) UILabel *lab_FuelSurcharge;
@property (nonatomic, copy) NSString *str_FuelSurcharge;

@property (nonatomic, strong) UIView *View_OtherTaxes;
@property (nonatomic, strong) UILabel *lab_OtherTaxes;
@property (nonatomic, copy) NSString *str_OtherTaxes;


@property (nonatomic, strong) UIView *view_Overseas;
@property (nonatomic, copy) NSString *str_Overseas;
@property (nonatomic, strong) UIView *view_Nationality;
@property (nonatomic, strong) UIView *view_TransactionCode;
@property (nonatomic, strong) UIView *view_HandmadePaper;



//礼品费明细
@property(nonatomic,strong)UITableView *View_GiftDetailsTable;//礼品费明细列表视图
@property (nonatomic, assign) BOOL bool_expenseGiftDetail;//是否开启显示礼品费明细
@property(nonatomic,strong)UIView *View_AddGiftDetails;//增加礼品费明细按钮视图
@property (nonatomic, strong) NSMutableArray *arr_DetailsArray;//礼品费详情数组
@property (nonatomic, strong) NSMutableArray *arr_DetailsDataArray;//礼品费数量数组
@property(nonatomic,strong)UIView *View_Head;
//@property (nonatomic,strong)GkTextField * txf_Acount;
//@property (nonatomic,strong)UIAlertView *Aler_deleteDetils;//删除明细警告框
@property (nonatomic, copy) NSString *expenseGiftDetailCodes;
@property (nonatomic, assign) BOOL bool_isOpenGiftDetail;
@end

@implementation NewLookAddCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:Custing(@"费用详情", nil) backButton:YES];
    [self initializeData];
    [self requestExpuserGetFormData];
}

#pragma mark - function
#pragma mark 视图处理
//创建根滚动视图
-(void)createScrollView{
    UIScrollView *scrollView = UIScrollView.new;
    _scr_RootScrollView = scrollView;
    scrollView.backgroundColor =Color_White_Same_20;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    [_scr_RootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@0);
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
    //费用类别选择后试图
    _view_ExpenseCode_Click = [[UIView alloc]init];
    _view_ExpenseCode_Click.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseCode_Click];
    [_view_ExpenseCode_Click mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseCode.bottom);
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

    
    _view_line1 = [[UIView alloc]init];
    [self.view_ContentView addSubview:_view_line1];
    [_view_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //日期视图
    _view_ExpenseDate = [[UIView alloc]init];
    _view_ExpenseDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDate];
    [_view_ExpenseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line1.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_PayType = [[UIView alloc]init];
    _view_PayType.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_PayType];
    [_view_PayType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseDate.bottom);
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
    
    //PDF查看视图
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
    //附件视图
    _model_Files.view_View = [[UIView alloc]init];
    _model_Files.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Files.view_View];
    [_model_Files.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Attachments.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_line2 = [[UIView alloc]init];
    [self.view_ContentView addSubview:_view_line2];
    [_view_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Files.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //项目名称视图
    _view_ProjId = [[UIView alloc]init];
    _view_ProjId.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ProjId];
    [_view_ProjId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_line2.bottom);
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

    _View_Supplier = [[UIView alloc]init];
    _View_Supplier.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_Supplier];
    [_View_Supplier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ClientId.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_Overseas = [[UIView alloc]init];
    _view_Overseas.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Overseas];
    [_view_Overseas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_Supplier.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_Nationality = [[UIView alloc]init];
    _view_Nationality.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Nationality];
    [_view_Nationality mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Overseas.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_TransactionCode = [[UIView alloc]init];
    _view_TransactionCode.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_TransactionCode];
    [_view_TransactionCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Nationality.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_HandmadePaper = [[UIView alloc]init];
    _view_HandmadePaper.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_HandmadePaper];
    [_view_HandmadePaper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_TransactionCode.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    //费用描述视图
    _view_ExpenseDesc = [[UIView alloc]init];
    _view_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDesc];
    [_view_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_HandmadePaper.bottom);
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
    _Reserved2View=[[UIView alloc]init];
    _Reserved2View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved2View];
    [_Reserved2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved3View=[[UIView alloc]init];
    _Reserved3View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved3View];
    [_Reserved3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved2View .bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved4View=[[UIView alloc]init];
    _Reserved4View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved4View];
    [_Reserved4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved3View .bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved5View=[[UIView alloc]init];
    _Reserved5View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved5View];
    [_Reserved5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved4View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved6View=[[UIView alloc]init];
    _Reserved6View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved6View];
    [_Reserved6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved5View .bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved7View=[[UIView alloc]init];
    _Reserved7View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved7View];
    [_Reserved7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved6View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved8View=[[UIView alloc]init];
    _Reserved8View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved8View];
    [_Reserved8View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved7View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    _Reserved9View=[[UIView alloc]init];
    _Reserved9View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved9View];
    [_Reserved9View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved8View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _Reserved10View=[[UIView alloc]init];
    _Reserved10View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved10View];
    [_Reserved10View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved9View.bottom);
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
        make.top.equalTo(self.Reserved10View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_shareTotal = [[UIView alloc]init];
    _View_shareTotal.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_shareTotal];
    [_View_shareTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_shareTable.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_GiftDetailsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_GiftDetailsTable.backgroundColor = Color_WhiteWeak_Same_20;
    _View_GiftDetailsTable.clipsToBounds = YES;
    _View_GiftDetailsTable.delegate = self;
    _View_GiftDetailsTable.dataSource = self;
    _View_GiftDetailsTable.scrollEnabled = NO;
    _View_GiftDetailsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view_ContentView addSubview:_View_GiftDetailsTable];
    [_View_GiftDetailsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_shareTable.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _view_RouteDetail = [[UIView alloc]init];
    _view_RouteDetail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_RouteDetail];
    [_view_RouteDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_GiftDetailsTable.bottom).offset(@10);
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
}


//更新视图
-(void)updateMainView{
    if (_muarr_MainView.count>0) {
        for (int i = 0; i<_muarr_MainView.count; i++) {
            MyProcurementModel *model = _muarr_MainView[i];
            [self updateLineState:model];
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
                }else if ([model.fieldName isEqualToString:@"Attachments"]&&self.totalArray.count>0) {
                    [self updateAttachImgViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Remark"]) {
                    [self update_RemarkView:model];
                }else if ([model.fieldName isEqualToString:@"Reserved1"]){
                    [self updateReserved1ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved2"]){
                    [self updateReserved2ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved3"]){
                    [self updateReserved3ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved4"]){
                    [self updateReserved4ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved5"]){
                    [self updateReserved5ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved6"]){
                    [self updateReserved6ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved7"]){
                    [self updateReserved7ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved8"]){
                    [self updateReserved8ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved9"]){
                    [self updateReserved9ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Reserved10"]){
                    [self updateReserved10ViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"Files"]&&_arr_FilesTotle.count>0){
                    [self update_FilesView:model];
                }
            }
            //显示数据
            if ([model.fieldName isEqualToString:@"ExpenseType"]) {
                _lab_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_str_ExpenseCat,model.fieldValue]];
            }
            if ([model.fieldName isEqualToString:@"ExpenseIcon"]) {
                _img_ExpenseCode.image = [UIImage imageNamed:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"CostCenter"]) {
                _lab_CostCenterId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ProjName"]) {
                _lab_ProjId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ClientName"]) {
                _lab_ClientId.text = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"Currency"]) {
                _lab_CurrencyCode.text = [NSString isEqualToNull:model.fieldValue]?model.fieldValue:Custing(@"人民币", nil);
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

    if ([NSString isEqualToNull:_lab_HasInvoice.text]&&[_lab_HasInvoice.text isEqualToString:Custing(@"是", nil)]) {
        [_view_NoInvReason mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _view_NoInvReason.hidden = YES;
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
    
    if (self.bool_expenseGiftDetail&&self.arr_DetailsDataArray.count!=0) {
           [self updateGiftDetailsTableView];
           [_View_GiftDetailsTable reloadData];
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
-(void)updateLineState:(MyProcurementModel *)model{
    if ([model.isShow integerValue]==1) {
        if ([model.fieldName isEqualToString:@"ClaimType"]||[model.fieldName isEqualToString:@"ExpenseCode"]||[model.fieldName isEqualToString:@"Amount"]||[model.fieldName isEqualToString:@"CurrencyCode"]||[model.fieldName isEqualToString:@"ExchangeRate"]||[model.fieldName isEqualToString:@"LocalCyAmount"]||[model.fieldName isEqualToString:@"Tax"]||[model.fieldName isEqualToString:@"ExclTax"]) {
            _int_line1 = 1;
        }
        if ([model.fieldName isEqualToString:@"ExpenseDate"]||[model.fieldName isEqualToString:@"InvoiceNo"]||[model.fieldName isEqualToString:@"HasInvoice"]||[model.fieldName isEqualToString:@"NoInvReason"]||_totalArray.count>0) {
            _int_line2 = 1;
        }
    }
}

//更新金额视图
-(void)update_AmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票金额", nil);
    }
    _lab_Amount = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_Amount addSubview:[XBHepler creation_Lable:_lab_Amount model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Amount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新币种视图
-(void)update_CurrencyCodeView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"发票币种", nil);
    }
    _lab_CurrencyCode = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_CurrencyCode addSubview:[XBHepler creation_Lable:_lab_CurrencyCode model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_CurrencyCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _str_CurrencyCode = model.fieldValue;
}

//更新汇率视图
-(void)update_ExchangeRateView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"付款汇率", nil);
    }
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ExchangeRate addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.text=model.fieldValue;
    }else{
        lab.text = @"1.00";
    }
    _str_ExchangeRate = lab.text;
}

//更新本位币金额视图
-(void)update_LocalCyAmountView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",self.userdatas.companyId] isEqualToString:@"9676"]) {
        model.Description = Custing(@"报销金额", nil);
    }
    __weak typeof(self) weakSelf = self;
    [_view_LocalCyAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_LocalCyAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
    UILabel *lab = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_InvCyPmtExchangeRate addSubview:[XBHepler creation_Lable:lab model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvCyPmtExchangeRate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    if ([NSString isEqualToNull:model.fieldValue]) {
        lab.text=model.fieldValue;
    }else{
        lab.text = @"1.00";
    }
}

//MARK:更新付款金额视图
-(void)updateInvPmtAmountView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_InvPmtAmount addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvPmtAmount updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新发票类型视图
-(void)update_InvoiceTypeView:(MyProcurementModel *)model{
    _lab_InvoiceType = [UILabel new] ;
    __weak typeof(self) weakSelf = self;
    [_view_InvoiceType addSubview:[XBHepler creation_Lable:_lab_InvoiceType model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_InvoiceType.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    _lab_InvoiceType.text = [NSString stringWithIdOnNO:_str_InvoiceTypeName];
}

//MARK:更新机票和燃油附加费合计视图
-(void)updateAirlineFuelFeeView{
    __weak typeof(self) weakSelf = self;
    MyProcurementModel *model = [[MyProcurementModel alloc]init];
    model.Description = Custing(@"机票和燃油附加费合计", nil);
    model.isShow = @1;
    model.fieldValue = [NSString stringWithIdOnNO:self.str_AirlineFuelFee];
    _lab_AirlineFuelFee = [UILabel new];
    [_View_AirlineFuelFee addSubview:[XBHepler creation_Lable:_lab_AirlineFuelFee model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_AirlineFuelFee.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    
    
    MyProcurementModel *model1 = [[MyProcurementModel alloc]init];
    model1.Description = Custing(@"票价", nil);
    model1.isShow = @1;
    model1.fieldValue = [NSString stringWithIdOnNO:self.str_AirTicketPrice];
    _lab_AirTicketPrice = [UILabel new];
    [_View_AirTicketPrice addSubview:[XBHepler creation_Lable:_lab_AirTicketPrice model:model1 Y:0 block:^(NSInteger height) {
        [weakSelf.View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_AirTicketPrice.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    
    MyProcurementModel *model2 = [[MyProcurementModel alloc]init];
    model2.Description = Custing(@"民航发展基金", nil);
    model2.isShow = @1;
    model2.fieldValue = [NSString stringWithIdOnNO:self.str_DevelopmentFund];
    _lab_DevelopmentFund = [UILabel new];
    [_View_DevelopmentFund addSubview:[XBHepler creation_Lable:_lab_DevelopmentFund model:model2 Y:0 block:^(NSInteger height) {
        [weakSelf.View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_DevelopmentFund.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    
    MyProcurementModel *model3 = [[MyProcurementModel alloc]init];
    model3.Description = Custing(@"燃油费附加费", nil);
    model3.isShow = @1;
    model3.fieldValue = [NSString stringWithIdOnNO:self.str_FuelSurcharge];
    _lab_FuelSurcharge = [UILabel new];
    [_View_FuelSurcharge addSubview:[XBHepler creation_Lable:_lab_FuelSurcharge model:model3 Y:0 block:^(NSInteger height) {
        [weakSelf.View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_FuelSurcharge.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    
    MyProcurementModel *model4 = [[MyProcurementModel alloc]init];
    model4.Description = Custing(@"其他税费", nil);
    model4.isShow = @1;
    model4.fieldValue = [NSString stringWithIdOnNO:self.str_OtherTaxes];
    _lab_OtherTaxes = [UILabel new];
    [_View_OtherTaxes addSubview:[XBHepler creation_Lable:_lab_OtherTaxes model:model4 Y:0 block:^(NSInteger height) {
        [weakSelf.View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_OtherTaxes.tag = height;
            make.height.equalTo(0);
        }];
    }]];
    
}

//更新税率视图
-(void)update_TaxRateView:(MyProcurementModel *)model{
    _lab_TaxRate = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_TaxRate addSubview:[XBHepler creation_Lable:_lab_TaxRate model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_TaxRate.tag = height;
            make.height.equalTo(0);
        }];
    }]];
}

//更新税额视图
-(void)update_TaxView:(MyProcurementModel *)model{
    _lab_Tax = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_Tax addSubview:[XBHepler creation_Lable:_lab_Tax model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Tax updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_Tax.tag = height;
            make.height.equalTo(0);
        }];
    }]];
}

//更新不含税金额视图
-(void)update_ExclTaxView:(MyProcurementModel *)model{
    _lab_ExclTax = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ExclTax addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_ExclTax.tag = height;
            make.height.equalTo(0);
        }];
    }]];
}
//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
    _lab_InvPmtTax = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_InvPmtTax addSubview:[XBHepler creation_Lable:_lab_InvPmtTax model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_InvPmtTax.tag = height;
            make.height.equalTo(0);
        }];
    }]];
}
//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
    _lab_InvPmtAmountExclTax = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_View_InvPmtAmountExclTax addSubview:[XBHepler creation_Lable:_lab_InvPmtAmountExclTax model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.lab_InvPmtAmountExclTax.tag = height;
            make.height.equalTo(0);
        }];
    }]];
}
//更新报销类型视图
-(void)update_ClaimTypeView:(MyProcurementModel *)model{
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", [NSString stringWithFormat:@"%ld",(long)_Type]];
    NSArray *filterArray = [_arr_ClaimType filteredArrayUsingPredicate:pred1];
    if (filterArray.count > 0) {
        STOnePickModel *model1 = filterArray[0];
        model.fieldValue = model1.Type;

    }
    _lab_ClaimType = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ClaimType addSubview:[XBHepler creation_Lable:_lab_ClaimType model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ClaimType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新费用类别视图
-(void)update_ExpenseCodeView:(MyProcurementModel *)model{
    _lab_ExpenseCode = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ExpenseCode addSubview:[XBHepler creation_Lable:_lab_ExpenseCode model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _str_expenseCode = model.fieldValue;
}

//更新日期视图
-(void)update_ExpenseDateView:(MyProcurementModel *)model{
    _lab_ExpenseDate =[UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ExpenseDate addSubview:[XBHepler creation_Lable:_lab_ExpenseDate model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExpenseDate updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:支付方式
-(void)update_PayTypeIdView:(MyProcurementModel *)model{
    model.fieldValue = [[NSString stringWithFormat:@"%@",model.fieldValue] isEqualToString:@"2"] ? Custing(@"企业支付", nil):Custing(@"个人支付", nil);
    [_view_PayType addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.view_PayType updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新发票号码视图
-(void)update_InvoiceNoView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_InvoiceNo addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_InvoiceNo updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新是否有发票视图
-(void)update_HasInvoiceView:(MyProcurementModel *)model{
    for (STOnePickModel *model1 in _array_HasInvoice) {
        if ([self.str_HasInvoice isEqualToString:model1.Id]) {
            model.fieldValue=model1.Type;
        }
    }
    _lab_HasInvoice =[UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_HasInvoice addSubview:[XBHepler creation_Lable:_lab_HasInvoice model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_HasInvoice updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];

}

//更新无发票要原因视图
-(void)update_NoInvReasonView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_NoInvReason addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_NoInvReason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新替票费用类别
-(void)update_ReplExpenseView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    model.fieldValue=[NSString stringWithIdOnNO:self.str_ReplExpenseType];
    [_view_ReplExpense addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ReplExpense updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
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
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ThreePartPdf WithContent:nil WithFormType:formViewOnlySelect WithSegmentType:lineViewNone WithString:Custing(@"电子发票pdf文件", nil) WithTips:nil WithInfodict:nil];
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
-(void)updateAttachImgViewWithModel:(MyProcurementModel *)model{
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_view_Attachments withEditStatus:2 withModel:model];
    view.maxCount=10;
    [_view_Attachments addSubview:view];
    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];

    
//    [_view_Attachments updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@128);
//    }];
//
//    UILabel * titleLbl = [GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 40) text:Custing(@"发票", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
//    [_view_Attachments addSubview:titleLbl];
//
//    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 30, Main_Screen_Width, 88) withEditStatus:2];
//    view.maxCount=5;
//    [_view_Attachments addSubview:view];
//    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
//
//    if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"12"]) {
//        UILabel *BillTItle=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 10, Main_Screen_Width-XBHelper_Title_Width-42, 50) text:Custing(@"电子发票pdf文件", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
//        [_view_Attachments addSubview:BillTItle];
//        UIButton *billBtn= [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 40) action:@selector(btn_Click:) delegate:self];
//        billBtn.tag = 16;
//        [_view_Attachments addSubview:billBtn];
//    }
//    //微信卡包
//    if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"16"]) {
//        if ([_dic_request[@"result"][@"weiXinCardInv"] isKindOfClass:[NSDictionary class]]) {
//            if ([NSString isEqualToNull:_dic_request[@"result"][@"weiXinCardInv"][@"pdf_url"]]) {
//                UILabel *BillTItle=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 40) text:Custing(@"电子发票pdf文件", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
//                [_view_Attachments addSubview:BillTItle];
//                UIButton *billBtn= [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 40) action:@selector(btn_Click:) delegate:self];
//                billBtn.tag = 16;
//                [_view_Attachments addSubview:billBtn];
//            }
//        }
//    }
//    //百望云
//    if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"15"]) {
//        if ([_dic_request[@"result"][@"baiWCloudInv"] isKindOfClass:[NSDictionary class]]) {
//            if ([NSString isEqualToNull:_dic_request[@"result"][@"baiWCloudInv"][@"formatFile"]]) {
//                UILabel *BillTItle=[GPUtils createLable:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 40) text:Custing(@"电子发票pdf文件", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
//                [_view_Attachments addSubview:BillTItle];
//                UIButton *billBtn= [GPUtils createButton:CGRectMake(XBHelper_Title_Width+27, 0, Main_Screen_Width-XBHelper_Title_Width-42, 40) action:@selector(btn_Click:) delegate:self];
//                billBtn.tag = 16;
//                [_view_Attachments addSubview:billBtn];
//            }
//        }
//    }
}

//更新附件视图
-(void)update_FilesView:(MyProcurementModel *)model{
    [_model_Files.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@128);
    }];
    
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_model_Files.view_View addSubview:titleLbl];
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 30, Main_Screen_Width, 88) withEditStatus:2];
    view.maxCount=10;
    [_model_Files.view_View addSubview:view];
    [view updateWithTotalArray:_arr_FilesTotle WithImgArray:_arr_FilesImage];
}

//更新成本中心视图
-(void)update_CostCenterIdView:(MyProcurementModel *)model{
    _lab_CostCenterId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_CostCenterId addSubview:[XBHepler creation_Lable:_lab_CostCenterId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_CostCenterId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
    _lab_CostCenterId.text = @"";
}

//更新项目名称视图
-(void)update_ProjIdView:(MyProcurementModel *)model{
    _lab_ProjId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ProjId addSubview:[XBHepler creation_Lable:_lab_ProjId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ProjId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新项目活动视图
-(void)updateProjectActivityView:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.str_ProjectActivityLv1Name,self.str_ProjectActivityLv2Name] WithCompare:@"/"];
    __weak typeof(self) weakSelf = self;
    [_View_ProjActivity addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_ProjActivity updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新客户视图
-(void)update_ClientIdView:(MyProcurementModel *)model{
    _lab_ClientId = [UILabel new];
    __weak typeof(self) weakSelf = self;
    [_view_ClientId addSubview:[XBHepler creation_Lable:_lab_ClientId model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ClientId updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)updateSupplierViewWithModel:(MyProcurementModel *)model{
    model.fieldValue=[NSString stringWithIdOnNO:_str_Supplier];
    __weak typeof(self) weakSelf = self;
    [_View_Supplier addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_Supplier updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否境外
-(void)updateOverseasView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
    }else{
        model.fieldValue = Custing(@"否", nil);
    }
    __weak typeof(self) weakSelf = self;
    [_view_Overseas addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Overseas updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:国别
-(void)updateNationalityView:(MyProcurementModel *)model{
    [_view_Nationality addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.view_Nationality updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:交易代码
-(void)updateTransactionCodeView:(MyProcurementModel *)model{
    [_view_TransactionCode addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.view_TransactionCode updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//MARK:是否手工票据
-(void)updateHandmadePaperView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
    }else{
        model.fieldValue = Custing(@"否", nil);
    }
    [_view_HandmadePaper addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [self.view_HandmadePaper updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新费用描述
-(void)update_ExpenseDescView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_ExpenseDesc addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_ExpenseDesc updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
//更新辅助核算视图
-(void)updateAccountItemView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_View_AccountItem addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.View_AccountItem updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//更新备注视图
-(void)update_RemarkView:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_view_Remark addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.view_Remark updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//MARK:更新通用审批自定义字段
-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved1View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved1View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved2ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved2View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved2View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved3ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved3View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved3View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved4ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved4View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved4View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved5ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved5View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved5View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved6ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved6View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved6View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved7ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved7View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved7View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved8ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved8View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved8View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved9ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved9View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved9View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}
-(void)updateReserved10ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved10View addSubview:[XBHepler creation_Lable:[UILabel new] model:model Y:0 block:^(NSInteger height) {
        [weakSelf.Reserved10View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

//费用类别选择后
-(void)update_View_ExpenseCode_Click:(NSString *)tip{
    NSMutableArray *_arr_Expense_Click = [NSMutableArray array];
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
                [_arr_Expense_Click addObject:model];
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
                [_arr_Expense_Click addObject:model];
            }
        }
    }else if ([tip isEqualToString:@"Flight"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"flightFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"flightFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_arr_Expense_Click addObject:model];
            }
        }
    }else if ([tip isEqualToString:@"Train"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"trainFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"trainFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_arr_Expense_Click addObject:model];
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
                [_arr_Expense_Click addObject:model];
            }
            if ([[NSString stringWithFormat:@"%@",self.dict_Standard[@"basis"]] isEqualToString:@"3"]) {
                cell_height = cell_height+1;
                NSArray *arr=@[@{@"isShow": @1,
                                 @"tips": Custing(@"请输入油价", nil),
                                 @"isRequired": @0,
                                 @"fieldName": @"OilPrice",
                                 @"description":Custing(@"油价", nil)}];
                for (NSDictionary *dic in arr) {
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [_arr_Expense_Click insertObject:model atIndex:0];
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
                [_arr_Expense_Click addObject:model];
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
                    [_arr_Expense_Click addObject:model];
                    
                    MyProcurementModel *model1 = [MyProcurementModel new];
                    model1.Description=Custing(@"结束时间", nil);
                    model1.isShow=[NSNumber numberWithInteger:[dic[@"isShow"]integerValue]];
                    model1.fieldName=@"CorpCarToDate";
                    model1.fieldValue=[NSString stringWithIdOnNO:_str_CorpCarToDate];
                    [_arr_Expense_Click addObject:model1];
                }else{
                    cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                    MyProcurementModel *model = [MyProcurementModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [_arr_Expense_Click addObject:model];
                }
            }
        }
    }else if ([tip isEqualToString:@"Trans"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"transFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"transFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            if ([[NSString stringWithFormat:@"%@",self.dict_Standard[@"unit"]] isEqualToString:@"天"]) {
                MyProcurementModel *model1 = [MyProcurementModel new];
                model1.isShow=@1;
                model1.fieldName=@"AllowanceAmount";
                model1.Description=Custing(@"补贴标准", nil);
                cell_height++;
                [_arr_Expense_Click addObject:model1];
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
                    [_arr_Expense_Click addObject:model];
                }
            }
        }
    }else if ([tip isEqualToString:@"Taxi"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"taxi"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"taxi"]:[NSArray array];
        for (NSDictionary *dic in arr_Expense_temporary) {
            cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [_arr_Expense_Click addObject:model];
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
            [_arr_Expense_Click addObject:model];
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
            [_arr_Expense_Click addObject:model];
        }
    }
    
    if ([tip isEqualToString:@"Allowance"]||[tip isEqualToString:@"Other"]||[tip isEqualToString:@"Medical"]||[tip isEqualToString:@"Trans"]) {
        [self requestGetExpStd];
    }
    for(UIView *view in [_view_ExpenseCode_Click subviews])
    {
        [view removeFromSuperview];
    }
    
    [_view_ExpenseCode_Click updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(cell_height*32);
    }];
    
    for (int i = 0; i<_arr_Expense_Click.count; i++) {
        MyProcurementModel *model = _arr_Expense_Click[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            UILabel *title=[GPUtils createLable:CGRectMake(12,(i*32),XBHelper_Title_Width, 32) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            title.numberOfLines = 2;
            [_view_ExpenseCode_Click addSubview:title];
            if ([model.fieldName isEqualToString:@"CityCode"]) {
                _txf_CityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_CityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_CityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _str_CityCode = model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CheckInDate"]) {
                _txf_CheckInDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_CheckInDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_CheckInDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_CheckInDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CheckOutDate"]) {
                _txf_CheckOutDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_CheckOutDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_CheckOutDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_CheckOutDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TotalDays"]) {
                _txf_TotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TotalDays.userInteractionEnabled = NO;
                _txf_TotalDays.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_TotalDays];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TotalDays.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"HotelName"]) {
                UITextField *txf_HotelName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_HotelName.userInteractionEnabled = NO;
                txf_HotelName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:txf_HotelName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_HotelName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Rooms"]) {
                UITextField *txf_Rooms = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_Rooms.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_Rooms];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_Rooms.text=[NSString stringWithFormat:@"%@",model.fieldValue];
                }
            }else if ([model.fieldName isEqualToString:@"HotelPrice"]) {
                _txf_HotelPrice = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_HotelPrice.userInteractionEnabled = NO;
                _txf_HotelPrice.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_HotelPrice];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_HotelPrice.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"FellowOfficersId"]) {
                _txf_FellowOfficers = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_FellowOfficers.userInteractionEnabled = NO;
                _txf_FellowOfficers.keyboardType =UIKeyboardTypeNumberPad;
                _txf_FellowOfficers.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_FellowOfficers];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _str_FellowOfficersId=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TotalPeople"]) {
                UITextField *TotalPeople = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                TotalPeople.userInteractionEnabled = NO;
                TotalPeople.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:TotalPeople];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    TotalPeople.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"MealsTotalDays"]) {
                UITextField *MealsTotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                MealsTotalDays.userInteractionEnabled = NO;
                MealsTotalDays.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:MealsTotalDays];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    MealsTotalDays.text = [NSString stringWithFormat:@"%@",model.fieldValue];
                }
            }else if ([model.fieldName isEqualToString:@"Breakfast"]) {
                _txf_Breakfast = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Breakfast.userInteractionEnabled = NO;
                _txf_Breakfast.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Breakfast];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Breakfast.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Lunch"]) {
                _txf_Lunch = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Lunch.userInteractionEnabled = NO;
                _txf_Lunch.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Lunch];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Lunch.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Supper"]) {
                _txf_Supper = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Supper.userInteractionEnabled = NO;
                _txf_Supper.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Supper];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Supper.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Flight"]) {
                _txf_Flight = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Flight.userInteractionEnabled = NO;
                _txf_Flight.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Flight];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Flight.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CateringCo"]) {
                _txf_CateringCo = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_CateringCo.userInteractionEnabled = NO;
                _txf_CateringCo.keyboardType =UIKeyboardTypeDefault;
                [_view_ExpenseCode_Click addSubview:_txf_CateringCo];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_CateringCo.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"FDCityName"]) {
                _txf_FDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_FDCityName.userInteractionEnabled = NO;
                _txf_FDCityName.keyboardType = UIKeyboardTypeDefault;
                [_view_ExpenseCode_Click addSubview:_txf_FDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_FDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"FACityName"]) {
                _txf_FACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_FACityName.userInteractionEnabled = NO;
                _txf_FACityName.keyboardType =UIKeyboardTypeDefault;
                [_view_ExpenseCode_Click addSubview:_txf_FACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_FACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ClassName"]) {
                _txf_ClassName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_ClassName.userInteractionEnabled = NO;
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
            }else if ([model.fieldName isEqualToString:@"Discount"]) {
                _txf_Discount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Discount.userInteractionEnabled = NO;
                _txf_Discount.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Discount];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Discount.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TDCityName"]) {
                _txf_TDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TDCityName.userInteractionEnabled = NO;
                _txf_TDCityName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_TDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TACityName"]) {
                _txf_TACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TACityName.userInteractionEnabled = NO;
                _txf_TACityName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_TACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"SeatName"]) {
                _txf_SeatName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_SeatName.userInteractionEnabled = NO;
                _txf_SeatName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_SeatName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_SeatName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"SDCityName"]) {
                _txf_SDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_SDCityName.userInteractionEnabled = NO;
                _txf_SDCityName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_SDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_SDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"SACityName"]) {
                _txf_SACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_SACityName.userInteractionEnabled = NO;
                _txf_SACityName.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_SACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_SACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"StartMeter"]) {
                UITextField *txf_StartMeter = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_StartMeter.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_StartMeter];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_StartMeter.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"EndMeter"]) {
                UITextField *txf_EndMeter = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_EndMeter.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_EndMeter];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_EndMeter.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Mileage"]) {
                _txf_Mileage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Mileage.userInteractionEnabled = NO;
                _txf_Mileage.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Mileage];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Mileage.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"OilPrice"]) {
                _txf_OilPrice = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_OilPrice.userInteractionEnabled = NO;
                _txf_OilPrice.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_OilPrice];
                if ([NSString isEqualToNull:self.str_OilPrice]) {
                    _txf_OilPrice.text = self.str_OilPrice;
                }
            }else if ([model.fieldName isEqualToString:@"CarStd"]) {
                _txf_CarStd = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_CarStd.keyboardType =UIKeyboardTypeNumberPad;
                _txf_CarStd.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_CarStd];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_CarStd.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"FuelBills"]) {
                _txf_FuelBills = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_FuelBills.keyboardType =UIKeyboardTypeNumberPad;
                _txf_FuelBills.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_FuelBills];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_FuelBills.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Pontage"]) {
                _txf_Pontage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Pontage.userInteractionEnabled = NO;
                _txf_Pontage.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_Pontage];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_Pontage.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ParkingFee"]) {
                _txf_ParkingFee = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_ParkingFee.userInteractionEnabled = NO;
                _txf_ParkingFee.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_ParkingFee];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_ParkingFee.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"SDepartureTime"]) {
                UITextField *txf_SDepartureTime = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_SDepartureTime.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_SDepartureTime];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_SDepartureTime.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"SArrivalTime"]) {
                UITextField *txf_SArrivalTime = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_SArrivalTime.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_SArrivalTime];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_SArrivalTime.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"AllowanceAmount"]) {
                _txf_AllowanceAmount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_AllowanceAmount.userInteractionEnabled = NO;
                _txf_AllowanceAmount.keyboardType =UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_AllowanceAmount];
            }else if ([model.fieldName isEqualToString:@"TransDCityName"]) {
                _txf_TransDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransDCityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TransDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TransACityName"]) {
                _txf_TransACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransACityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TransACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TransFromDate"]) {
                _txf_TransFromDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransFromDate.userInteractionEnabled = NO;
                _txf_TransFromDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransFromDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TransFromDate.text=_int_TransTimeType==1?[model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TransToDate"]) {
                _txf_TransToDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransToDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransToDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TransToDate.text=_int_TransTimeType==1?[model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TransTotalDays"]) {
                _txf_TransTotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransTotalDays.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransTotalDays];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_TransTotalDays.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TransTypeId"]) {
                _txf_TransTypeId = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_TransTypeId.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_TransTypeId];
                if ([NSString isEqualToNull:_str_TransType]) {
                    _txf_TransTypeId.text=_str_TransType;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionObject"]) {
                UITextField *txf_ReceptionObject = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionObject.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionObject];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_ReceptionObject.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionReason"]) {
                UITextField *txf_ReceptionReason = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionReason.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionReason];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_ReceptionReason.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionLocation"]) {
                UITextField *txf_ReceptionLocation = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionLocation.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionLocation];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_ReceptionLocation.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Visitor"]) {
                UITextField *txf_Visitor = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_Visitor.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_Visitor];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_Visitor.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"VisitorDate"]) {
                UITextField *txf_VisitorDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_VisitorDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_VisitorDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_VisitorDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"LeaveDate"]) {
                UITextField *txf_LeaveDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_LeaveDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_LeaveDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_LeaveDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionFellowOfficersId"]) {
                UITextField *txf_ReceptionFellowOfficersId = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionFellowOfficersId.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionFellowOfficersId];
                if ([NSString isEqualToNull:self.str_ReceptionFellowOfficers]) {
                    txf_ReceptionFellowOfficersId.text=self.str_ReceptionFellowOfficers;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionTotalPeople"]) {
                UITextField *txf_ReceptionTotalPeople = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionTotalPeople.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionTotalPeople];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_ReceptionTotalPeople.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"ReceptionCateringCo"]) {
                UITextField *txf_ReceptionCateringCo = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_ReceptionCateringCo.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_ReceptionCateringCo];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_ReceptionCateringCo.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarDCityName"]) {
                UITextField *txf_CorpCarDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarDCityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarACityName"]) {
                UITextField *txf_CorpCarACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarACityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarMileage"]) {
                UITextField *txf_CorpCarMileage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarMileage.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarMileage];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarMileage.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarFuelBills"]) {
                UITextField *txf_CorpCarFuelBills = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarFuelBills.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarFuelBills];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarFuelBills.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarPontage"]) {
                UITextField *txf_CorpCarPontage = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarPontage.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarPontage];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarPontage.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarParkingFee"]) {
                UITextField *txf_CorpCarParkingFee = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarParkingFee.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarParkingFee];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarParkingFee.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarNo"]) {
                UITextField *txf_CorpCarNo = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarNo.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarNo];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarNo.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarFromDate"]) {
                UITextField *txf_CorpCarFromDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarFromDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarFromDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarFromDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"CorpCarToDate"]) {
                UITextField *txf_CorpCarToDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_CorpCarToDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_CorpCarToDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_CorpCarToDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TaxiDCityName"]) {
                UITextField *txf_TaxiDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_TaxiDCityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_TaxiDCityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TaxiDCityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TaxiACityName"]) {
                UITextField *txf_TaxiACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_TaxiACityName.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_TaxiACityName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TaxiACityName.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TaxiFromDate"]) {
                UITextField *txf_TaxiFromDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_TaxiFromDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_TaxiFromDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TaxiFromDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TaxiToDate"]) {
                UITextField *txf_TaxiToDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_TaxiToDate.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_TaxiToDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TaxiToDate.text=model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"Location"]) {
                UITextField *txf_Location = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_Location.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf_Location];
                txf_Location.text=[NSString stringWithIdOnNO:self.str_Location];
            }else if ([model.fieldName isEqualToString:@"OfficeFromDate"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OfficeFromDate];
            }else if ([model.fieldName isEqualToString:@"OfficeToDate"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OfficeToDate];
            }else if ([model.fieldName isEqualToString:@"OfficeTotalDays"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OfficeTotalDays];
            }else if ([model.fieldName isEqualToString:@"Branch"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_Branch];
            }else if ([model.fieldName isEqualToString:@"OverseasFromDate"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OverseasFromDate];
            }else if ([model.fieldName isEqualToString:@"OverseasToDate"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OverseasToDate];
            }else if ([model.fieldName isEqualToString:@"OverseasTotalDays"]) {
                UITextField *txf = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:txf];
                txf.text=[NSString stringWithIdOnNO:self.str_OverseasTotalDays];
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
            }
        }
        if ([model.fieldName isEqualToString:@"CityType"]) {
            if ([NSString isEqualToNull:model.fieldValue]) {
                _str_CityType = model.fieldValue;
            }
        }
    }
}

//更新
-(void)updateAllowanceView:(NSDictionary *)dict{
    NSInteger basis=[dict[@"result"][@"basis"] integerValue];
    NSMutableArray *_arr_Expense_Click = [NSMutableArray array];
    NSMutableArray *arr_Expense_temporary;
    NSInteger cell_height = 0;
    
    if (basis == 1) {
        arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
                                                                   @"tips": Custing(@"请输入补贴标准", nil),
                                                                   @"isRequired": @1,
                                                                   @"fieldName": @"MealAmount",
                                                                   @"description":Custing(@"补贴标准", nil),
                                                                   @"fieldValue":@""},
                                                                  ]];
    }else if (basis == 2) {
        arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
        arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
                                                                   @"fieldValue":@""},
                                                                  ]];
    }else if (basis == 4) {
        arr_Expense_temporary = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
        [arr_Expense_temporary addObject:@{@"isShow": @1,
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
            [arr_Expense_temporary insertObjects:@[[MyProcurementModel initDicByModel:_model_AllowanceFromDate],[MyProcurementModel initDicByModel:_model_AllowanceToDate]] atIndexes:index];
        }else{
            NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange: NSMakeRange(1, 2)];
            [arr_Expense_temporary insertObjects:@[[MyProcurementModel initDicByModel:_model_AllowanceFromDate],[MyProcurementModel initDicByModel:_model_AllowanceToDate]] atIndexes:index];
        }
    }
    if ([_model_TravelUserName.isShow integerValue] == 1) {
        [arr_Expense_temporary addObject:[MyProcurementModel initDicByModel:_model_TravelUserName]];
    }
    
    if (arr_Expense_temporary.count>0) {
        for (int i = 0; i<arr_Expense_temporary.count; i++) {
            NSDictionary *dic = arr_Expense_temporary[i];
            if ([dic[@"isShow"]integerValue]==1) {
                cell_height += 1;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_arr_Expense_Click addObject:model];
            }
        }
    }
    
    for(UIView *view in [_view_ExpenseCode_Click subviews])
    {
        [view removeFromSuperview];
    }
    
    [_view_ExpenseCode_Click updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(cell_height*32);
    }];
    
    for (int i = 0; i<_arr_Expense_Click.count; i++) {
        MyProcurementModel *model = _arr_Expense_Click[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]) {
            UILabel *title=[GPUtils createLable:CGRectMake(12,(i*32),XBHelper_Title_Width, 32) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            title.numberOfLines = 2;
            [_view_ExpenseCode_Click addSubview:title];
            if ([model.fieldName isEqualToString:@"TotalDays"]) {
                UITextField *_txf_Day = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Day.keyboardType =UIKeyboardTypeNumberPad;
                _txf_Day.userInteractionEnabled = NO;
                [_view_ExpenseCode_Click addSubview:_txf_Day];
                if ([NSString isEqualToNull:_str_day]) {
                    _txf_Day.text = _str_day;
                }
            }else if ([model.fieldName isEqualToString:@"Money"]) {
                UITextField *_txf_Money = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_Money.userInteractionEnabled = NO;
                _txf_Money.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_Money];
                if ([NSString isEqualToNull:_str_Amount]) {
                    _txf_Money.text = [NSString stringWithFormat:@"%@",_str_Amount];
                }
            }else if ([model.fieldName isEqualToString:@"City"]) {
                UITextField *_txf_City = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_City.userInteractionEnabled = NO;
                _txf_City.keyboardType = UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_txf_City];
                if ([NSString isEqualToNull:_str_City]) {
                    _txf_City.text = [NSString stringWithFormat:@"%@",_str_City];
                }
            }else if ([model.fieldName isEqualToString:@"MealType"]) {
                UITextField *_txf_MealType = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_MealType.userInteractionEnabled = NO;
                _txf_MealType.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_MealType];
                if ([[NSString stringWithFormat:@"%@",self.str_MealType]isEqualToString:@"0"]) {
                    _txf_MealType.text = Custing(@"半天餐补", nil);
                }else{
                    _txf_MealType.text = Custing(@"一天餐补", nil);
                }
            }else if ([model.fieldName isEqualToString:@"MealAmount"]) {
                UITextField *_txf_MealAmount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_MealAmount.userInteractionEnabled = NO;
                _txf_MealAmount.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_MealAmount];
                
                if (basis == 1||basis == 2||basis == 4) {
                    _txf_MealAmount.text = [NSString stringWithFormat:@"%@",_str_Amount];
                }else{
                    if ([[NSString stringWithFormat:@"%@",self.str_MealType]isEqualToString:@"0"]) {
                        _txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[_str_AllowanceCurrencyCode,_str_MealAmount] WithCompare:@" "];
                    }else{
                        _txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[_str_AllowanceCurrencyCode,_str_MealAmount1] WithCompare:@" "];
                    }
                }
                if (![NSString isEqualToNullAndZero:_txf_MealAmount.text]&&[NSString isEqualToNullAndZero:_str_AllowanceAmount]) {
                    _txf_MealAmount.text=[NSString stringWithFormat:@"%@",_str_AllowanceAmount];
                }
            }else if ([model.fieldName isEqualToString:@"AllowanceFromDate"]) {
                _txf_AllowanceFromDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_AllowanceFromDate.userInteractionEnabled = NO;
                _txf_AllowanceFromDate.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_AllowanceFromDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_AllowanceFromDate.text = [model.ctrlTyp isEqualToString:@"day"]? [model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                _txf_AllowanceToDate = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _txf_AllowanceToDate.userInteractionEnabled = NO;
                _txf_AllowanceToDate.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:_txf_AllowanceToDate];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _txf_AllowanceToDate.text = [model.ctrlTyp isEqualToString:@"day"]? [model.fieldValue substringToIndex:10]:model.fieldValue;
                }
            }else if ([model.fieldName isEqualToString:@"TravelUserName"]) {
                UITextField *txf_TravelUserName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*32),Main_Screen_Width-XBHelper_Title_Width-42, 32) placeholder:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                txf_TravelUserName.userInteractionEnabled = NO;
                txf_TravelUserName.keyboardType = UIKeyboardTypeDecimalPad;
                [_view_ExpenseCode_Click addSubview:txf_TravelUserName];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    txf_TravelUserName.text = [NSString stringWithIdOnNO:model.fieldValue];
                }
            }
        }
    }
}

//更新金额计算
-(void)update_Amount:(NSString *)newString textField:(UITextField *)textField{
    if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
        if (textField == _txf_TotalDays) {
            _txf_HotelPrice.text = [NSString isEqualToNull:newString]?[NSString stringWithFormat:@"%.2f",[_lab_Amount.text floatValue]/[newString floatValue]]:@"";
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
        }
    }
}

-(void)updateExpenseCodeList_View{
    _view_Tax.hidden = YES;
    _view_ExclTax.hidden = YES;
    _view_InvoiceType.hidden = YES;
    _view_TaxRate.hidden = YES;
    _View_InvPmtTax.hidden = YES;
    _View_InvPmtAmountExclTax.hidden = YES;
    _View_AirlineFuelFee.hidden = YES;
    _View_AirTicketPrice.hidden = YES;
    _View_DevelopmentFund.hidden = YES;
    _View_FuelSurcharge.hidden = YES;
    _View_OtherTaxes.hidden = YES;

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
    if ([NSString isEqualToNull:_str_expenseCode]) {
        for (int i = 0; i<_arr_expenseCodeList.count; i++) {
            NSDictionary *dic = _arr_expenseCodeList[i];
            if ([_str_expenseCode isEqualToString:dic[@"expenseCode"]]) {
                if ([_str_InvoiceType isEqualToString:@"1"]) {
                    if ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"]) {
                        if ([NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.lab_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                            if ([self.str_InvoiceTypeCode isEqualToString:@"1004"]) {
                                _View_AirlineFuelFee.hidden = NO;
                                [_View_AirlineFuelFee updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_AirlineFuelFee.tag);
                                }];
                                
                                _View_AirTicketPrice.hidden = NO;
                                [_View_AirTicketPrice updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_AirTicketPrice.tag);
                                }];
                                
                                _View_DevelopmentFund.hidden = NO;
                                [_View_DevelopmentFund updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_DevelopmentFund.tag);
                                }];
                                
                                _View_FuelSurcharge.hidden = NO;
                                [_View_FuelSurcharge updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_FuelSurcharge.tag);
                                }];
                                
                                _View_OtherTaxes.hidden = NO;
                                [_View_OtherTaxes updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_OtherTaxes.tag);
                                }];
                                
                            }
                            if (_lab_Tax != nil) {
                                _view_Tax.hidden = NO;
                                [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_Tax.tag);
                                }];
                            }
                            if (_lab_ExclTax != nil) {
                                _view_ExclTax.hidden = NO;
                                [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_ExclTax.tag);
                                }];
                            }
                            if (_lab_InvPmtTax != nil) {
                                _View_InvPmtTax.hidden = NO;
                                [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_InvPmtTax.tag);
                                }];
                            }
                            if (_lab_InvPmtAmountExclTax != nil) {
                                _View_InvPmtAmountExclTax.hidden = NO;
                                [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_InvPmtAmountExclTax.tag);
                                }];
                            }
                            if (_lab_TaxRate != nil) {
                                _view_TaxRate.hidden = NO;
                                [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.equalTo(self.lab_TaxRate.tag);
                                }];
                            }
                        }
                    }else{
                        if (_lab_Tax != nil) {
                            _view_Tax.hidden = NO;
                            [_view_Tax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(self.lab_Tax.tag);
                            }];
                        }
                        if (_lab_ExclTax != nil) {
                            _view_ExclTax.hidden = NO;
                            [_view_ExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(self.lab_ExclTax.tag);
                            }];
                        }
                        if (_lab_InvPmtTax != nil) {
                            _View_InvPmtTax.hidden = NO;
                            [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(self.lab_InvPmtTax.tag);
                            }];
                        }
                        if (_lab_InvPmtAmountExclTax != nil) {
                            _View_InvPmtAmountExclTax.hidden = NO;
                            [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(self.lab_InvPmtAmountExclTax.tag);
                            }];
                        }
                        if (_lab_TaxRate != nil) {
                            _view_TaxRate.hidden = NO;
                            [_view_TaxRate updateConstraints:^(MASConstraintMaker *make) {
                                make.height.equalTo(self.lab_TaxRate.tag);
                            }];
                        }
                    }
                }
                if (_lab_InvoiceType!=nil) {
                    _view_InvoiceType.hidden = NO;
                    [_view_InvoiceType updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(self.lab_InvoiceType.tag);
                    }];
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


#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    
    if (!_Type) {
        _Type = 1;
    }
    if (!_Action) {
        _Action = 1;
    }
    _totalArray = [NSMutableArray array];
    _int_update = 0;
    _dic_ExpenseCode_requst = [NSDictionary dictionary];
    _muarr_ExpenseCode = [NSMutableArray array];
    _inte_ExpenseCode_Rows = 0;
    _str_expenseIcon = @"";
    _str_expenseCode = @"";
    _imagesArray = [NSMutableArray array];
    _muarr_imageTypeArray = [NSMutableArray array];
    _str_ExpenseCat = @"";
    _str_ExpenseCatCode = @"";
    _dic_CityCode = [NSDictionary dictionary];
    _str_expenseCode_tag = @"";
    _str_CityCode = @"";
    _str_CityType = @"";
    _arr_expenseCodeList = [NSArray array];
    _str_Status = @"";
    _str_Amount = @"";
    _str_Amount1 = @"";
    _str_Amount2 = @"";
    _str_Amount3 = @"";
    _str_Unit = @"";
    _str_Class = @"";
    _str_Discount = @"";
    _str_IsExpensed = @"";
    _str_LimitMode = @"";
    _str_InvoiceType = @"";
    _str_Flight = @"";
    _str_FellowOfficersId = @"";
    _arr_FellowOfficersId = [NSMutableArray array];
    _model_Files = [[WorkFormFieldsModel alloc]initialize];
    _arr_FilesImage = [NSMutableArray array];
    _arr_FilesTotle = [NSMutableArray array];
    _str_RequstUserId = @"";
    _arr_stdSelfDriveDtoList = [NSArray array];
    _str_MealType = @"1";
    _str_MealAmount = @"";
    _str_MealAmount1 = @"";
    _str_AllowanceCurrency = @"";
    _str_AllowanceCurrencyCode = @"";
    _str_AllowanceCurrencyRate = @"";
    _str_Basis = @"";
    _dic_stdOutput = [NSDictionary dictionary];
    _str_MedicalAmount = @"";
    _str_day = @"";
    _str_City = @"";
    _str_CurrencyCode = @"";
    _str_ExchangeRate = @"";
    _str_AllowanceAmount = @"";
    
    _str_HasInvoice=@"1";
    self.array_shareForm = [NSMutableArray array];
    self.array_shareData = [NSMutableArray array];
    self.str_shareTotal = @"0";
    self.str_shareRatio = @"0";
    self.arr_DetailsDataArray = [NSMutableArray array];
    self.arr_DetailsArray = [NSMutableArray array];
    self.bool_expenseGiftDetail = NO;
    self.bool_isOpenGiftDetail = NO;
}

//处理请求后数据
-(void)analysisRequestData{
//    费用分摊
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
//    礼品费明细
     self.bool_expenseGiftDetail = [_dic_request[@"result"][@"expenseGiftDetail"] floatValue] == 1? YES : NO;
        if (self.bool_expenseGiftDetail) {
    //        礼品费明细
            if ([_dic_request[@"result"][@"expenseGiftDetailFields"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in _dic_request[@"result"][@"expenseGiftDetailFields"]) {
                    MyProcurementModel *model = [[MyProcurementModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.arr_DetailsArray addObject:model];
                }
            }
            if ([_dic_request[@"result"][@"formData"] isKindOfClass:[NSDictionary class]]) {
                if ([_dic_request[@"result"][@"formData"][@"expenseGiftDetailData"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *expenseGiftDetailData = _dic_request[@"result"][@"formData"][@"expenseGiftDetailData"];
                    if ([expenseGiftDetailData[@"sa_ExpenseUserGiftDetail"] isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in expenseGiftDetailData[@"sa_ExpenseUserGiftDetail"]) {
                            GiftFeeDetail *model = [[GiftFeeDetail alloc] init];
                            [model setValuesForKeysWithDictionary:dic];
                            [self.arr_DetailsDataArray addObject:model];
                        }
                    }
                }
            }
        }
    
    _array_HasInvoice=[NSMutableArray array];
    if ([_dic_request[@"result"][@"expenseInvSettingDtos"]isKindOfClass:[NSArray class]]) {
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

    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dic_request[@"result"][@"formFields"]];
    _muarr_MainView = [NSMutableArray array];
    if (![_dic_request[@"result"][@"driveCar"] isKindOfClass:[NSNull class]]) {
        _dic_route = _dic_request[@"result"][@"driveCar"];
        _model_route = [RouteModel modelWithDict:_dic_route];
    }
    
    if (![_dic_request[@"result"][@"claimPolicy"] isKindOfClass:[NSNull class]]) {
        _dic_ReimPolicy = _dic_request[@"result"][@"claimPolicy"];
    }
    _arr_expenseCodeList = _dic_request[@"result"][@"expenseCodeList"];
    
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [_muarr_MainView addObject:model];
            if ([model.fieldName isEqualToString:@"ExpenseCat"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ExpenseCat = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"InvoiceType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_InvoiceType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"Tag"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_expenseCode_tag = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"TotalDays"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_day = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"RequestUserId"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_RequstUserId = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CityCode"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CityCode = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CityName"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_City = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CityType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CityType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"AllowanceAmount"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_AllowanceAmount = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"SupplierName"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_Supplier= model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"MealType"]) {
                _str_MealType = [[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"] ? @"0":@"1";
                _model_mealType = model;
            }
            if ([model.fieldName isEqualToString:@"CorpCarFromDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarFromDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CorpCarToDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarToDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"DataSource"]&&[NSString isEqualToNull:model.fieldValue]) {
                _dateSource = model.fieldValue;
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
            if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                _model_AllowanceToDate=model;
            }
            if ([model.fieldName isEqualToString:@"ReceptionFellowOfficers"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReceptionFellowOfficers = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ReplExpenseType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReplExpenseType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"HasInvoice"]) {
                self.str_HasInvoice=[NSString isEqualToNull:model.fieldValue]?[NSString stringWithFormat:@"%@",model.fieldValue]:@"1";
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
            if ([dic[@"fieldName"] isEqualToString:@"InvoiceTypeName"]) {
                self.str_InvoiceTypeName=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"InvoiceTypeCode"]) {
                self.str_InvoiceTypeCode=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
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
            //解析图片
            if ([dic[@"fieldName"] isEqualToString:@"Files"]) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_arr_FilesTotle addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_arr_FilesTotle WithImageArray:_arr_FilesImage WithMaxCount:10];
                }
            }
        }
    }
}

//处理请求后费用类型
-(void)analysisRequestDataByExpenseCode{
    _muarr_ExpenseCode=[NSMutableArray array];
    NSDictionary *parDict= [CostCateNewModel getCostCateByDict:_dic_ExpenseCode_requst array:_muarr_ExpenseCode withType:1];
    _str_ExpenseCode_level=parDict[@"CateLevel"];
    _inte_ExpenseCode_Rows=[parDict[@"categoryRows"]integerValue];
}


#pragma mark 网络请求
//获取页面数据
-(void)requestExpuserGetFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",expuser_GetFormData];
    NSDictionary *parameters = @{@"Action":[NSString stringWithFormat:@"%ld",(long)_Action],
                                 @"Type":[NSString stringWithFormat:@"%ld",(long)_Type],
                                 @"Id":[NSString stringWithFormat:@"%ld",(long)_Id],
                                 @"TaskId":_TaskId,
                                 @"GridOrder":_GridOrder,
                                 @"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId,
                                 @"ProcId":self.dict_parameter[@"ProcId"] ? self.dict_parameter[@"ProcId"]:@"",
                                 @"FlowGuid":self.dict_parameter[@"FlowGuid"] ? self.dict_parameter[@"FlowGuid"]:@""
                                 };
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

// 获取费用标准
-(void)requestGetExpStd{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_lab_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequstUserId,
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
                                 @"ExpenseDate":_lab_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequstUserId,
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
-(void)btn_Click:(UIButton *)btn{
    //    NSLog(@"%ld", (long)btn.tag);
    if (btn.tag == 16) {
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
            vc.CheckAddModel = _model_has;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)btn_route:(UIButton *)btn{
    MapRecordController *vc=[[MapRecordController alloc]init];
    vc.model=_model_route;
    [self.navigationController pushViewController:vc animated:YES];
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
        }else{
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:1.0];
        }
        [YXSpritesLoadingView dismiss];
        return;
    }
    if (serialNum == 0) {
        _dic_request = responceDic;
        [self analysisRequestData];
        [self createScrollView];
        [self createMainView];
        [self updateMainView];
        [self updateContentView];
        [self updateExpenseCodeList_View];
        [self requestGetExpStdAddFirst];
    }else if (serialNum == 2) {
        _str_Status = responceDic[@"result"][@"status"];
        _str_Amount = [NSString reviseString:responceDic[@"result"][@"amount"]];
        _str_Amount1 = [NSString reviseString:responceDic[@"result"][@"amount1"]];
        _str_Amount2 = [NSString reviseString:responceDic[@"result"][@"amount2"]];
        _str_Amount3 = [NSString reviseString:responceDic[@"result"][@"amount3"]];
        _str_Unit = [responceDic[@"result"][@"unit"] isKindOfClass:[NSNull class]]?@"":responceDic[@"result"][@"unit"];
        _str_Class = responceDic[@"result"][@"class"];
        _str_Discount = [responceDic[@"result"][@"discount"] isKindOfClass:[NSNull class]]?@"":responceDic[@"result"][@"discount"];
        _str_IsExpensed = responceDic[@"result"][@"isExpensed"];
        _str_LimitMode = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"limitMode"]];
        if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
            _dic_stdOutput = responceDic[@"result"][@"stdOutput"];
            _str_MealAmount = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"amount"]]?responceDic[@"result"][@"stdOutput"][@"amount"]:@"";
            _str_MealAmount1 = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"amount1"]]?responceDic[@"result"][@"stdOutput"][@"amount1"]:@"";
            _str_AllowanceCurrency = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"currency"]]?responceDic[@"result"][@"stdOutput"][@"currency"]:@"";
            _str_AllowanceCurrencyCode = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"currencyCode"]]?responceDic[@"result"][@"stdOutput"][@"currencyCode"]:@"";
            _str_AllowanceCurrencyRate = [NSString isEqualToNull:responceDic[@"result"][@"stdOutput"][@"exchangeRate"]]?responceDic[@"result"][@"stdOutput"][@"exchangeRate"]:@"";
        }
        if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
            if (_Id == 0) {
                [self update_Amount:_txf_TotalDays.text textField:[UITextField new]];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]){
            if ([responceDic[@"result"][@"stdSelfDriveDtoList"] isKindOfClass:[NSArray class]]) {
                _arr_stdSelfDriveDtoList = responceDic[@"result"][@"stdSelfDriveDtoList"];
            }
            if (_arr_stdSelfDriveDtoList.count>0) {
                NSString *amount = @"0";
                for (int i = 0; i<_arr_stdSelfDriveDtoList.count; i++) {
                    NSDictionary *dic = _arr_stdSelfDriveDtoList[i];
                    if ([dic[@"mileageFrom"]integerValue]<=[_txf_Mileage.text integerValue]&&[dic[@"mileageTo"]integerValue]>=[_txf_Mileage.text integerValue]) {
                        amount = dic[@"amount"];
                    }
                }
                _txf_CarStd.text = [NSString stringWithFormat:@"%@", amount];
                _txf_FuelBills.text = [GPUtils decimalNumberMultipWithString:!_txf_Mileage?@"0":_txf_Mileage.text with:!_txf_CarStd?@"0":_txf_CarStd.text];
            }else{
                _txf_CarStd.text = [NSString stringWithFormat:@"%@", responceDic[@"result"][@"amount"]];
                _txf_FuelBills.text = [GPUtils decimalNumberMultipWithString:!_txf_Mileage?@"0":_txf_Mileage.text with:!_txf_CarStd?@"0":_txf_CarStd.text];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]){
            if (_Id == 0) {
                _txf_ClassName.text = _arr_Flight[[responceDic[@"result"][@"class"]integerValue]==0?1:[responceDic[@"result"][@"class"]integerValue]-1];
                _txf_Discount.text = [NSString isEqualToNull:responceDic[@"result"][@"discount"]]?responceDic[@"result"][@"discount"]:@"";
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
            if (_Id == 0) {
                if ([NSString isEqualToNull:_str_Amount2]&&[_str_Amount2 integerValue]!=0) {
                    _txf_Breakfast.text = [NSString stringWithFormat:@"%@",_str_Amount];
                    _txf_Lunch.text = [NSString stringWithFormat:@"%@",_str_Amount2];
                    _txf_Supper.text = [NSString stringWithFormat:@"%@",_str_Amount3];
                }
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]){
            if ([_str_Unit isEqualToString:@"天"]||[_str_Unit isEqualToString:@"月"]||[_str_Unit isEqualToString:@"年"]) {
                _str_Basis = responceDic[@"result"][@"basis"] ;
                [self updateAllowanceView:responceDic];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Medical"]){
            if ([responceDic[@"result"][@"staffExpenses"] isKindOfClass:[NSDictionary class]]){
                _str_MedicalAmount = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"staffExpenses"][@"amount"]];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Trans"]){
            _txf_AllowanceAmount.text=[NSString stringWithIdOnNO:_str_Amount];
        }
    }else if (serialNum == 17) {
        if ([NSString isEqualToNull:responceDic[@"result"]]) {
            PdfReadViewController *vc=[[PdfReadViewController alloc]init];
            vc.PdfUrl =[NSString stringWithFormat:@"%@",responceDic[@"result"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (serialNum==20) {
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
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}

#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.array_shareData.count;
    if ([tableView isEqual:self.View_shareTable]) {
        return self.array_shareData.count;
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
        return self.arr_DetailsDataArray.count;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    AddReimShareModel *model = self.array_shareData[indexPath.row];
//    return [ProcureDetailsCell AddReimShareCellHeightWithArray:self.array_shareForm WithModel:model];
    
    if ([tableView isEqual:self.View_shareTable]) {
        AddReimShareModel *model = self.array_shareData[indexPath.row];
        return [ProcureDetailsCell AddReimShareCellHeightWithArray:self.array_shareForm WithModel:model];
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
        GiftFeeDetail *model = self.arr_DetailsDataArray[indexPath.row];
        return [ProcureDetailsCell GiftFeeAppCellHeightWithArray:self.arr_DetailsArray WithModel:model];
    }
    return 0.01;
    
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
//    ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
//    if (cell==nil) {
//        cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
//    }
//    [cell configAddReimShareCellWithArray:self.array_shareForm withDetailsModel:self.array_shareData[indexPath.row] withindex:indexPath.row withCount:self.array_shareData.count] ;
//    if (cell.LookMore) {
//        [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return cell;
//
    
    if ([tableView isEqual:self.View_shareTable]) {
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ProcureDetailsCell"];
        if (cell==nil) {
            cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProcureDetailsCell"];
        }
        [cell configAddReimShareCellWithArray:self.array_shareForm withDetailsModel:self.array_shareData[indexPath.row] withindex:indexPath.row withCount:self.array_shareData.count] ;
        if (cell.LookMore) {
            cell.LookMore.tag = indexPath.row + 100;
            [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
        ProcureDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GiftProcureDetailsCell"];
           if (cell==nil) {
               cell=[[ProcureDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GiftProcureDetailsCell"];
           }
           [cell configGiftFeeCellWithArray:self.arr_DetailsArray withDetailsModel:self.arr_DetailsDataArray[indexPath.row] withindex:indexPath.row withCount:self.arr_DetailsDataArray.count] ;
           if (cell.LookMore) {
               cell.LookMore.tag = indexPath.row + 1000;
               [cell.LookMore addTarget:self action:@selector(LookMore:) forControlEvents:UIControlEventTouchUpInside];
           }
           return cell;
    }
    
    return nil;
    
}
//MARK:查看更多明细
-(void)LookMore:(UIButton *)btn{
    
    if (btn.tag< 1000) {
        self.bool_isOpenShare = !self.bool_isOpenShare;
        [btn setImage: self.bool_isOpenShare ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [btn setTitle: self.bool_isOpenShare ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
        [self updateShareTableView];
    }else{
        self.bool_isOpenGiftDetail=!self.bool_isOpenGiftDetail;
        [btn setImage: self.bool_isOpenGiftDetail ? [UIImage imageNamed:@"work_Close"]:[UIImage imageNamed:@"work_Open"] forState:UIControlStateNormal];
        [btn setTitle: self.bool_isOpenGiftDetail ? Custing(@"收起", nil):Custing(@"展开", nil) forState:UIControlStateNormal];
        [self updateGiftDetailsTableView];
    }
    
}
-(void)updateGiftDetailsTableView{
    if (self.bool_isOpenGiftDetail) {
        NSInteger height=10;
        for (GiftFeeDetail *model in self.arr_DetailsDataArray) {
            height=height+[ProcureDetailsCell GiftFeeAppCellHeightWithArray:self.arr_DetailsArray WithModel:model];
        }
        [_View_GiftDetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
    }else{
        GiftFeeDetail *model=self.arr_DetailsDataArray[0];
        NSInteger height=10+[ProcureDetailsCell GiftFeeAppCellHeightWithArray:self.arr_DetailsArray WithModel:model];
        [_View_GiftDetailsTable updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
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

