//
//  NewAddCostViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/3/23.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "NewAddCostViewController.h"
#import "CategoryCollectCell.h"
#import "HClActionSheet.h"
#import "STPickerCategory.h"
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
#import "STOnePickModel.h"
#import "FormDetailBaseCell.h"
#import "AddReimShareModel.h"
#import "ComPeopleViewController.h"

static NSString *const CellIdentifier = @"addCostCell";

@interface NewAddCostViewController ()<GPClientDelegate,UICollectionViewDelegate,UICollectionViewDataSource,chooseTravelDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate,NewAddressVCDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

//框架用view
@property (nonatomic, strong) UIScrollView *scr_RootScrollView;//底层滚动视图
@property (nonatomic, strong) BottomView *view_ContentView; //滚动视图contentView
@property (nonatomic, strong) DoneBtnView *view_DockView; //底部按钮视图

@property (nonatomic, strong) chooseTravelDateView *cho_datelView;//选择弹出框

@property (nonatomic, strong) UIAlertView *alt_Warring;//弹出超预算框
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *imageTypeArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;//图片数组
//内部视图
@property (nonatomic, strong) UIView *view_ReimPolicyUp;//报销政策视图
@property (nonatomic, strong) UIView *view_ReimPolicyDown;//报销政策视图
@property (nonatomic, strong) NSDictionary *dic_ReimPolicy;// 报销政策字典
@property (nonatomic, strong) NSString *str_RequestUserId;

@property (nonatomic, strong) UIView *view_Amount;//金额视图
@property (nonatomic, strong) UITextField *txf_Amount;

@property (nonatomic, strong) UIView *view_CurrencyCode;//币种视图
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
@property (nonatomic, strong) NSMutableArray *muarr_CurrencyCode;//项目名称显示用数据
@property (nonatomic, strong) NSString *str_CurrencyCode;
@property (nonatomic, strong) NSString *str_Currency;
@property (nonatomic, strong) NSString *str_CurrencyCode_PlaceHolder;

@property (nonatomic, strong) UIView *view_ExchangeRate;//汇率
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
@property (nonatomic, strong) NSString *str_ExchangeRate;

@property (nonatomic, strong) UIView *view_LocalCyAmount;//本位币视图
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;

@property (nonatomic, strong) UIView *view_InvoiceType;//发票类型
@property (nonatomic, strong) UITextField *txf_InvoiceType;

@property (nonatomic, strong) UIView *view_TaxRate;//税率
@property (nonatomic, strong) UITextField *txf_TaxRate;

@property (nonatomic, strong) UIView *view_Tax;//税额
@property (nonatomic, strong) UITextField *txf_Tax;

@property (nonatomic, strong) UIView *view_ExclTax;//不含税金额
@property (nonatomic, strong) UITextField *txf_ExclTax;

@property (nonatomic, strong) UIView *view_ClaimType;//报销类型
@property (nonatomic, strong) UITextField *txf_ClaimType;
@property (nonatomic, strong) NSString *str_ClaimType;

@property (nonatomic, strong) UIView *view_ExpenseCode;//费用类别
@property (nonatomic, strong) UITextField *txf_ExpenseCode;
@property (nonatomic, strong) UIImageView *img_ExpenseCode;
@property (nonatomic, strong) UICollectionView *col_CategoryCollectView;//费用类别collectView
@property (nonatomic, strong) UICollectionViewFlowLayout *colayout_CategoryLayOut;
@property (nonatomic, strong) CategoryCollectCell *col_cell;
@property (nonatomic, strong) UIImageView *img_CateImage;//费用类别image
@property (nonatomic, strong) UIView *view_ExpenseCode_Click;//费用类别选择后
@property (nonatomic, strong) NSString *str_expenseDesc;
@property (nonatomic, strong) UIView *view_ex_expenseDesc;
@property (nonatomic, strong) UILabel *lab_ex_expenseDesc;

@property (nonatomic, strong) NSDictionary *dic_ExpenseCode_requst;
@property (nonatomic, strong) NSMutableArray *muarr_ExpenseCode;//更新后显示用数据

@property (nonatomic, strong) NSString *str_ExpenseCode_level;
@property (nonatomic, strong) NSString *str_isShowExpenseDesc;
@property (nonatomic, assign) NSInteger inte_ExpenseCode_Rows;
@property (nonatomic, assign) BOOL bool_isOpenGener;//费用类型是否打开的
@property (nonatomic, strong) NSString *str_ExpenseCatCode;//费用大类代码
@property (nonatomic, strong) NSString *str_expenseCode_tag;//费用大类
@property (nonatomic, strong) SubmitFormView *sub_Expense;

@property (nonatomic, strong) UIView *view_ExpenseDate;//日期
@property (nonatomic, strong) UITextField *txf_ExpenseDate;
@property (nonatomic, strong) UIDatePicker *dap_ExpenseDate;//

@property (nonatomic, strong) WorkFormFieldsModel *model_PayTypeId;
@property (nonatomic, strong) NSMutableArray *arr_PayTypeId;
@property (nonatomic, strong) WorkFormFieldsModel *model_SupplierId;

@property (nonatomic, strong) UIView *view_InvoiceNo;//发票号码
@property (nonatomic, strong) UITextField *txf_InvoiceNo;

//是否有发票
@property (nonatomic, strong) WorkFormFieldsModel *model_HasInvoice;
@property (nonatomic, strong) NSMutableArray *array_HasInvoice;
@property (nonatomic, copy) NSString *str_HasInvoice;
@property (nonatomic, assign) NSInteger int_requiredReason;//无发票原因
@property (nonatomic, assign) NSInteger int_requiredAtt;//是否要附件


@property (nonatomic, copy) MyProcurementModel *model_NoInvReason;//无发票原因
@property (nonatomic, copy) MyProcurementModel *model_ReplExpense;//替票类型


@property (nonatomic, strong) UIView *view_NoInvReason;//原因
@property (nonatomic, strong) UITextField *txf_NoInvReason;


@property (nonatomic, strong) UIView *view_ReplExpense;//替票费用类别
@property (nonatomic, strong) UITextField *txf_ReplExpense;//替票费用类别文字
//替票
@property (nonatomic, copy) NSString *str_ReplExpenseCode;//替票code
@property (nonatomic, copy) NSString *str_ReplExpenseType;//替票类型
@property (nonatomic, assign)NSInteger int_ReplClick;//1替票类型
/**
 费用类别数组
 */
@property(nonatomic,strong)NSMutableArray * arr_ReplCategoryArr;







@property (nonatomic, strong) UIView *view_ThreePartPdf;//三方PDF

@property (nonatomic, strong) UIView *view_Attachments;//上传发票
@property (nonatomic, strong) UICollectionViewFlowLayout *col_layOut;//网格规则
@property (nonatomic, strong) NSString *str_imageDataString;//上传服务器图片
@property (nonatomic, strong) UIAlertView *art_deleteImagesAler;//删除图片警告框




@property (nonatomic, strong) WorkFormFieldsModel *model_Files;//附件
@property (nonatomic, strong) NSMutableArray *arr_FilesTotal;
@property (nonatomic, strong) NSMutableArray *arr_FilesImage;
@property (nonatomic, strong) NSMutableArray *arr_FilesType;

@property (nonatomic, strong) UIView *view_CostCenterId;//成本中心
@property (nonatomic, strong) UITextField *txf_CostCenterId;
@property (nonatomic, strong) NSString *str_CostCenterId;
@property (nonatomic, strong) NSString *str_CostCenterId_PlaceHolder;
@property (nonatomic, strong) NSString *str_CostCenterMgrUserId;
@property (nonatomic, strong) NSString *str_CostCenterMgr;

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

//费用描述
@property (nonatomic, strong) UIView *view_ExpenseDesc;
@property (nonatomic, strong) UITextView *txv_ExpenseDesc;

@property (nonatomic, strong) UIView *view_Remark;//备注
@property (nonatomic, strong) UITextView *txv_Remark;

@property (nonatomic, strong) UIView *view_RouteDetail;

//住宿
@property (nonatomic, strong) NSString *str_CityCode;
@property (nonatomic, strong) UITextField *txf_CityName;
@property (nonatomic, strong) NSString *str_CityType;
@property (nonatomic, strong) UITextField *txf_TotalDays;
@property (nonatomic, strong) UITextField *txf_HotelPrice;
@property (nonatomic, strong) UITextField *txf_HotelName;
@property (nonatomic, strong) UITextField *txf_Rooms;
@property (nonatomic, strong) NSDictionary *dic_CityCode;
@property (nonatomic, strong) UITextField *txf_CheckInDate;
@property (nonatomic, strong) UITextField *txf_CheckOutDate;
@property (nonatomic, strong) NSString *str_Basis;//获取住宿报销类型

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
@property (nonatomic, strong) NSString *str_FellowOfficers;//餐饮同行人员字符串
@property (nonatomic, strong) NSString *str_TotalPeople;


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
@property (nonatomic, strong) NSString *str_FDCityCode;
@property (nonatomic, strong) NSString *str_FDCityType;
@property (nonatomic, strong) NSString *str_FACityCode;
@property (nonatomic, strong) NSString *str_FACityType;

//自驾车
@property (nonatomic, strong) UITextField *txf_OilPrice;
@property (nonatomic, strong) NSString *str_OilPrice;
@property (nonatomic, strong) UITextField *txf_SDCityName;
@property (nonatomic, strong) UITextField *txf_SACityName;
@property (nonatomic, strong) UITextField *txf_Mileage;
@property (nonatomic, strong) UITextField *txf_CarStd;
@property (nonatomic, strong) UITextField *txf_FuelBills;
@property (nonatomic, strong) UITextField *txf_Pontage;
@property (nonatomic, strong) UITextField *txf_ParkingFee;
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
@property (nonatomic, strong) NSArray *arr_stdSelfDriveDtoList;
@property (nonatomic, strong) UITextField *txf_StartMeter;//开始咪表
@property (nonatomic, strong) UITextField *txf_EndMeter;//结束咪表


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
@property (nonatomic, strong) WorkFormFieldsModel *model_AllowanceFromDate;
@property (nonatomic, strong) WorkFormFieldsModel *model_AllowanceToDate;
@property (nonatomic, strong) NSMutableArray *arr_Allowance_Main;
@property (nonatomic, strong) WorkFormFieldsModel *model_TravelUserName;
@property (nonatomic, strong) WorkFormFieldsModel *model_TransTypeId;
@property (nonatomic, strong) WorkFormFieldsModel *model_CrspFromDate;

//接待
@property (nonatomic, strong) UITextField *txf_ReceptionObject;//接待对象
@property (nonatomic, strong) UITextField *txf_ReceptionReason;//接待事由
@property (nonatomic, strong) UITextField *txf_ReceptionLocation;//接待地点
@property (nonatomic, strong) UITextField *txf_Visitor;//来访人员姓名和职位
@property (nonatomic, strong) UITextField *txf_VisitorDate;//来访时间
@property (nonatomic, strong) UITextField *txf_LeaveDate;//离开时间
@property (nonatomic, strong) UITextField *txf_ReceptionFellowOfficers;//同行人员
@property (nonatomic, copy) NSString *str_ReceptionFellowOfficers;//同行人员
@property (nonatomic, copy) NSString *str_ReceptionFellowOfficerId;//同行人员
@property (nonatomic, strong) UITextField *txf_ReceptionTotalPeople;//总人数
@property (nonatomic, strong) UITextField *txf_ReceptionCateringCo;//餐饮公司




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
@property (nonatomic, strong) NSDictionary *dict_Standard;//标准集合1
@property (nonatomic, strong) NSDictionary *dict_Standard_StdOutput;//标准集合2

@property (nonatomic, strong) NSString *str_Status;
@property (nonatomic, strong) NSString *str_Amount;
@property (nonatomic, strong) NSString *str_Amount2;
@property (nonatomic, strong) NSString *str_Amount3;
@property (nonatomic, strong) NSString *str_Unit;
@property (nonatomic, strong) NSString *str_Class;
@property (nonatomic, strong) NSString *str_Discount;
@property (nonatomic, strong) NSString *str_IsExpensed;
@property (nonatomic, strong) NSString *str_LimitMode;
@property (nonatomic, strong) NSDictionary *dic_stdOutput;
@property (nonatomic, strong) NSString *str_MedicalAmount;

@property (nonatomic, strong) NSString *str_lastExpenseCode;
@property (nonatomic, strong) NSString *str_lastExpenseDate;

//自定义字段
@property (nonatomic, strong) UIView *Reserved1View;
@property (nonatomic, strong) ReserverdMainModel *model_rs;
//存储数据
@property (nonatomic, strong) NSDictionary *dic_request;//请求后保存的数据
@property (nonatomic, strong) NSMutableArray *muarr_MainView;//显示用数组
@property (nonatomic, strong) NSMutableArray *muarr_MainEndData;//编辑状态值

//@property (nonatomic, strong) NSMutableArray *arr_image;
@property (nonatomic, strong) NewAddCostModel *model_NewAddCost;//上传需用数据
@property (nonatomic, assign) int int_update;
@property (nonatomic, assign) int int_load;
@property (nonatomic, strong) NSArray *arr_expenseCodeList;
@property (nonatomic, assign) NSInteger before_Type;


@property (nonatomic, assign) NSInteger int_TransTimeType;//市内交通选择时间格式1:日期 2时间(默认)

@property (nonatomic, assign) BOOL bool_firstIn;//是否第一次进


@property (nonatomic, strong) NSMutableArray *arr_TaxRates;//税率数组
@property (nonatomic, strong) NSMutableArray *arr_ClaimType;//报销类型
@property (nonatomic, strong) NSMutableArray *arr_InvoiceType;//发票类型
@property (nonatomic, strong) NSString *str_InvoiceType;
@property (nonatomic, strong) NSString *str_InvoiceTypeCode;
@property (nonatomic, strong) NSString *str_InvoiceTypeName;

@property (nonatomic, strong) NSMutableArray *arr_TrainSeats;//火车座位
@property (nonatomic, strong) MyProcurementModel *model_mealType;//补贴类型(餐补)


@property (nonatomic, strong) UIView *View_shareTableOpen;//费用分摊是否开启
@property (nonatomic, strong) UITableView *View_shareTable;//费用分摊视图
@property (nonatomic, strong) UILabel *lab_sharePercent;//费用分摊百分比显示
@property (nonatomic, assign) BOOL bool_shareShow;//是否开启显示费用分摊
@property (nonatomic, strong) NSMutableArray *array_shareForm;//费用分摊控制显示数组 row
@property (nonatomic, strong) NSMutableArray *array_shareData;//费用分摊数据 section
@property (nonatomic, copy) NSString *str_shareTotal;//费用分摊合计
@property (nonatomic, copy) NSString *str_shareRatio;//费用分摊百分比
@property (nonatomic, copy) NSString *str_shareId;//费用分摊id

//礼品费明细
@property(nonatomic,strong)UITableView *View_GiftDetailsTable;//礼品费明细列表视图
@property (nonatomic, assign) BOOL bool_expenseGiftDetail;//是否开启显示费用分摊
@property(nonatomic,strong)UIView *View_AddGiftDetails;//增加礼品费明细按钮视图
@property (nonatomic, strong) NSMutableArray *arr_DetailsArray;//礼品费详情数组
@property (nonatomic, strong) NSMutableArray *arr_DetailsDataArray;//礼品费数量数组
@property(nonatomic,strong)UIView *View_Head;
//@property (nonatomic,strong)GkTextField * txf_Acount;
@property (nonatomic,strong)UIAlertView *Aler_deleteDetils;//删除明细警告框
@property (nonatomic, copy) NSString *expenseGiftDetailCodes;

/**
 辅助核算项目
 */
@property (nonatomic, copy) NSString *str_accountItemCode;
@property (nonatomic, copy) NSString *str_accountItem;


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

/**
 机票和燃油附加费合计视图
 */
@property (nonatomic, strong) UIView *View_AirlineFuelFee;
@property (nonatomic, strong) GkTextField *txf_AirlineFuelFee;
@property (nonatomic, copy) NSString *str_AirlineFuelFee;


@property (nonatomic, strong) WorkFormFieldsModel *model_Overseas;

@property (nonatomic, strong) WorkFormFieldsModel *model_Nationality;

@property (nonatomic, strong) WorkFormFieldsModel *model_TransactionCode;

@property (nonatomic, strong) WorkFormFieldsModel *model_HandmadePaper;

/**
 是否数组
 */
@property (nonatomic, strong) NSMutableArray *arr_IsOrNot;


@end

@implementation NewAddCostViewController

-(NSMutableArray *)arr_IsOrNot{
    if (_arr_IsOrNot == nil) {
        _arr_IsOrNot = [NSMutableArray array];
        NSArray *type = @[Custing(@"是", nil),Custing(@"否", nil)];
        NSArray *code = @[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type = type[i];
            model.Id = code[i];
            [_arr_IsOrNot addObject:model];
        }
    }
    return _arr_IsOrNot;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([NSString isEqualToNull:_str_show_title]) {
        [self setTitle:_str_show_title backButton:YES];
    }else{
        [self setTitle:Custing(@"记一笔", nil) backButton:YES];
    }
    [self initializeData];
    [self requestExpuserGetFormData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_Action==2?@"EDITCOST":@"ADDCOST" object:self];
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
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
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
    
    self.view_DockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.view_DockView.userInteractionEnabled=YES;
    [self.view addSubview:self.view_DockView];
    [self.view_DockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    if (_Enabled_addAgain==1) {
        [self.view_DockView updateViewWithTitleArray:@[Custing(@"保存", nil)] WithSizeArray:@[@"1.0"]  WithTitleColorArray:@[Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_Blue_Important_20] WithLineColroArray:@[Color_Blue_Important_20]];
        __weak typeof(self) weakSelf = self;
        self.view_DockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                UIButton *btn=[[UIButton alloc]init];
                btn.tag=0;
                [weakSelf btn_Click:btn];
            }
        };
    }else{
        [self.view_DockView updateViewWithTitleArray:@[Custing(@"再记一笔", nil),Custing(@"保存", nil)] WithSizeArray:@[@"0.428",@"0.572"]  WithTitleColorArray:@[Color_form_TextFieldBackgroundColor,Color_form_TextFieldBackgroundColor] WithBgColor:@[Color_Orange_Weak_20,Color_Blue_Important_20] WithLineColroArray:@[Color_Orange_Weak_20,Color_Blue_Important_20]];
        __weak typeof(self) weakSelf = self;
        self.view_DockView.btnClickBlock = ^(NSInteger index) {
            if (index==0) {
                UIButton *btn=[[UIButton alloc]init];
                btn.tag=1;
                [weakSelf btn_Click:btn];
            }else if (index==1){
                UIButton *btn=[[UIButton alloc]init];
                btn.tag=0;
                [weakSelf btn_Click:btn];
            }
        };
    }
    
    //    UIButton *rightSaveBtn = [[UIButton alloc]init];
    //    rightSaveBtn.tag = 0;
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rightSaveBtn title:nil titleColor:nil titleIndex:0 imageName:self.userdatas.SystemType==1?@"Add_AgentSave":@"NavBarImg_Tick" target:self action:@selector(btn_Click:)];
    
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
    
    //日期视图
    _view_ExpenseDate = [[UIView alloc]init];
    _view_ExpenseDate.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDate];
    [_view_ExpenseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_InvPmtAmountExclTax.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_PayTypeId.view_View = [[UIView alloc]init];
    _model_PayTypeId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_PayTypeId.view_View];
    [_model_PayTypeId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseDate.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //发票号码视图
    _view_InvoiceNo = [[UIView alloc]init];
    _view_InvoiceNo.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_InvoiceNo];
    [_view_InvoiceNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_PayTypeId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //是否有发票视图
    _model_HasInvoice.view_View = [[UIView alloc]init];
    _model_HasInvoice.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_HasInvoice.view_View];
    [_model_HasInvoice.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_InvoiceNo.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    //无发票要原因视图
    _view_NoInvReason = [[UIView alloc]init];
    _view_NoInvReason.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_NoInvReason];
    [_view_NoInvReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_HasInvoice.view_View.bottom);
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
    //附件视图
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
    _model_SupplierId.view_View = [[UIView alloc]init];
    _model_SupplierId.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_SupplierId.view_View];
    [_model_SupplierId.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ClientId.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    _model_Overseas.view_View = [[UIView alloc]init];
    _model_Overseas.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Overseas.view_View];
    [_model_Overseas.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_SupplierId.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_Nationality.view_View = [[UIView alloc]init];
    _model_Nationality.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_Nationality.view_View];
    [_model_Nationality.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Overseas.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_TransactionCode.view_View = [[UIView alloc]init];
    _model_TransactionCode.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_TransactionCode.view_View];
    [_model_TransactionCode.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_Nationality.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _model_HandmadePaper.view_View = [[UIView alloc]init];
    _model_HandmadePaper.view_View.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_model_HandmadePaper.view_View];
    [_model_HandmadePaper.view_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_TransactionCode.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    //费用描述
    _view_ExpenseDesc = [[UIView alloc]init];
    _view_ExpenseDesc.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_ExpenseDesc];
    [_view_ExpenseDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.model_HandmadePaper.view_View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    //备注视图
    _view_Remark = [[UIView alloc]init];
    _view_Remark.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_Remark];
    [_view_Remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_ExpenseDesc.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _Reserved1View=[[UIView alloc]init];
    _Reserved1View.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_Reserved1View];
    [_Reserved1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_Remark.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    _View_shareTableOpen = [[UIView alloc]init];
    _View_shareTableOpen.backgroundColor = Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_View_shareTableOpen];
    [_View_shareTableOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Reserved1View.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    _View_shareTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _View_shareTable.backgroundColor=Color_WhiteWeak_Same_20;
    _View_shareTable.clipsToBounds = YES;
    _View_shareTable.delegate=self;
    _View_shareTable.dataSource=self;
    _View_shareTable.scrollEnabled=NO;
    _View_shareTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view_ContentView addSubview:_View_shareTable];
    [_View_shareTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_shareTableOpen.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    //    jinL新增代码
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
    
    _View_AddGiftDetails = [[UIView alloc]init];
    _View_AddGiftDetails.backgroundColor = Color_White_Same_20;
    [self.view_ContentView addSubview:_View_AddGiftDetails];
    [_View_AddGiftDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_GiftDetailsTable.bottom);
        make.left.right.equalTo(self.view_ContentView);
    }];
    
    
    _view_RouteDetail = [[UIView alloc]init];
    _view_RouteDetail.backgroundColor=Color_WhiteWeak_Same_20;
    [self.view_ContentView addSubview:_view_RouteDetail];
    [_view_RouteDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.View_AddGiftDetails.bottom).offset(@10);
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
                    [_muarr_MainEndData addObject:model];
                    [self update_AmountView:model];
                }else if ([model.fieldName isEqualToString:@"CurrencyCode"]) {
                    [self update_CurrencyCodeView:model];
                }else if ([model.fieldName isEqualToString:@"ExchangeRate"]) {
                    [_muarr_MainEndData addObject:model];
                    [self update_ExchangeRateView:model];
                }else if ([model.fieldName isEqualToString:@"LocalCyAmount"]) {
                    [_muarr_MainEndData addObject:model];
                    [self update_LocalCyAmountView:model];
                }else if ([model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]) {
                    [_muarr_MainEndData addObject:model];
                    [self updateInvCyPmtExchangeRateView:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtAmount"]) {
                    [_muarr_MainEndData addObject:model];
                    [self updateInvPmtAmountView:model];
                }else if ([model.fieldName isEqualToString:@"InvoiceType"]) {
                    [self update_InvoiceTypeView:model];
                }else if ([model.fieldName isEqualToString:@"TaxRate"]) {
                    [_muarr_MainEndData addObject:model];
                    [self update_TaxRateView:model];
                }else if ([model.fieldName isEqualToString:@"Tax"]) {
                    [_muarr_MainEndData addObject:model];
                    [self update_TaxView:model];
                }else if ([model.fieldName isEqualToString:@"ExclTax"]) {
                    [_muarr_MainEndData addObject:model];
                    [self update_ExclTaxView:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtTax"]) {
                    [_muarr_MainEndData addObject:model];
                    [self updateInvPmtTaxViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]) {
                    [_muarr_MainEndData addObject:model];
                    [self updateInvPmtAmountExclTaxViewWithModel:model];
                }else if ([model.fieldName isEqualToString:@"ClaimType"]) {
                    [self update_ClaimTypeView:model];
                }else if ([model.fieldName isEqualToString:@"ExpenseCode"]) {
                    [self update_ExpenseCodeView:model];
                }else if ([model.fieldName isEqualToString:@"ExpenseDate"]) {
                    [self update_ExpenseDateView:model];
                }else if ([model.fieldName isEqualToString:@"PayTypeId"]) {
                    [self update_PayTypeIdView:model];
                }else if ([model.fieldName isEqualToString:@"SupplierId"]) {
                    [self update_SupplierIdView:model];
                }else if ([model.fieldName isEqualToString:@"Overseas"]) {
                    [self updateOverseasView:model];
                }else if ([model.fieldName isEqualToString:@"Nationality"]) {
                    [self updateNationalityView:model];
                }else if ([model.fieldName isEqualToString:@"TransactionCode"]) {
                    [self updateTransactionCodeView:model];
                    
                }else if ([model.fieldName isEqualToString:@"HandmadePaper"]) {
                    [self updateHandmadePaperView:model];
                }else if ([model.fieldName isEqualToString:@"InvoiceNo"]) {
                    [self update_InvoiceNoView:model];
                }else if ([model.fieldName isEqualToString:@"HasInvoice"]) {
                    [self update_HasInvoiceView:model];
                }else if ([model.fieldName isEqualToString:@"NoInvReason"]) {
                    self.model_NoInvReason=model;
                    self.model_NoInvReason.fieldValue=@"";
                    [self update_NoInvReasonView:model];
                }else if ([model.fieldName isEqualToString:@"ReplExpenseCode"]) {
                    self.model_ReplExpense=model;
                    self.model_ReplExpense.fieldValue=@"";
                    self.str_ReplExpenseCode=[NSString stringWithIdOnNO:model.fieldValue];
                    [self update_ReplExpenseView:model];
                }else if ([model.fieldName isEqualToString:@"Attachments"]) {
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
                }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]) {
                    [self update_ExpenseDescView:model];
                }else if ([model.fieldName isEqualToString:@"Remark"]) {
                    [self update_RemarkView:model];
                }else if ([model.fieldName isEqualToString:@"Reserved1"]){
                    [self updateReserved1ViewWithModel:model];
                }
            }
            //显示数据
            if ([model.fieldName isEqualToString:@"ExpenseType"]) {
                _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_str_ExpenseCat,model.fieldValue]];
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
                    _str_expenseCode_tag = [model.fieldValue isKindOfClass:[NSString class]]?model.fieldValue:@"";
                }
            }
        }
        [self updateAirlineFuelFeeView];
    }
    
    [self updateOverseasSubViews];
    
    if (_dic_route!=nil) {
        [self updateRouteDetailView];
    }
    
    if (_dic_ReimPolicy) {
        [self update_ReimPolicyView];
    }
    if ([NSString isEqualToNull:_dateSource]) {
        [self updatePdflookView];
    }
    
    if (self.bool_shareShow) {
        [self createShareHeadFootView];
        [self updateShareTableView];
    }
    if (self.bool_expenseGiftDetail&&self.arr_DetailsDataArray.count > 0) {
        [self updateGiftDetailsTableView];
        [self updateAddGiftDetailsView];
    }
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
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 2;
        [weakSelf btn_Click:btn];
    }];
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
    _txf_LocalCyAmount=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_LocalCyAmount WithContent:_txf_LocalCyAmount WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    _txf_LocalCyAmount.userInteractionEnabled = NO;
    [_view_LocalCyAmount addSubview:view];
}
//MARK:更新发票币种对支付币种汇率视图
-(void)updateInvCyPmtExchangeRateView:(MyProcurementModel *)model{
    _txf_InvCyPmtExchangeRate = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvCyPmtExchangeRate WithContent:_txf_InvCyPmtExchangeRate WithFormType:formViewEnterExchange WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setExchangeChangedBlock:^(NSString *exchange){
        weakSelf.str_InvCyPmtExchangeRate = exchange;
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:exchange]?exchange:@"1.0000")];
        local = [GPUtils getRoundingOffNumber:local afterPoint:2];
        weakSelf.txf_InvPmtAmount.text = [GPUtils transformNsNumber:local];
        weakSelf.txf_InvPmtTax.text = [NSString countTax:local taxrate:[NSString isEqualToNull:self.txf_TaxRate.text] ? self.txf_TaxRate.text:@"0"];
        weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:weakSelf.txf_InvPmtTax.text]];
    }];
    if (![NSString isEqualToNull:model.fieldValue]) {
        _txf_InvCyPmtExchangeRate.text = [NSString stringWithFormat:@"%@",_str_ExchangeRate];
        _str_InvCyPmtExchangeRate = _str_ExchangeRate;
    }
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
    _txf_InvoiceType=[[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_InvoiceType WithContent:_txf_InvoiceType WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
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
        picker.typeTitle=Custing(@"发票类型", nil);
        picker.DateSourceArray=weakSelf.arr_InvoiceType;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
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
    _txf_AirlineFuelFee = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_AirlineFuelFee WithContent:_txf_AirlineFuelFee WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine WithString:Custing(@"机票和燃油附加费合计", nil) WithInfodict:@{@"value1":self.str_AirlineFuelFee} WithTips:Custing(@"请输入机票和燃油附加费合计", nil) WithNumLimit:50];
    [_View_AirlineFuelFee addSubview:view];
    
    _txf_AirTicketPrice = [[GkTextField alloc]init];
    SubmitFormView *view1 = [[SubmitFormView alloc]initBaseView:_View_AirTicketPrice WithContent:_txf_AirTicketPrice WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine WithString:Custing(@"票价", nil) WithInfodict:@{@"value1":self.str_AirTicketPrice} WithTips:Custing(@"请输入票价(必填)", nil) WithNumLimit:50];
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
    SubmitFormView *view2 = [[SubmitFormView alloc]initBaseView:_View_DevelopmentFund WithContent:_txf_DevelopmentFund WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine WithString:Custing(@"民航发展基金", nil) WithInfodict:@{@"value1":self.str_DevelopmentFund} WithTips:Custing(@"请输入民航发展基金(必填)", nil) WithNumLimit:50];
    [_View_DevelopmentFund addSubview:view2];
    
    
    _txf_FuelSurcharge = [[GkTextField alloc]init];
    SubmitFormView *view3 = [[SubmitFormView alloc]initBaseView:_View_FuelSurcharge WithContent:_txf_FuelSurcharge WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine WithString:Custing(@"燃油费附加费", nil) WithInfodict:@{@"value1":self.str_FuelSurcharge} WithTips:Custing(@"请输入燃油费附加费(必填)", nil) WithNumLimit:50];
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
    SubmitFormView *view4 = [[SubmitFormView alloc]initBaseView:_View_OtherTaxes WithContent:_txf_OtherTaxes WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine WithString:Custing(@"其他税费", nil) WithInfodict:@{@"value1":self.str_OtherTaxes} WithTips:Custing(@"请输入其他税费(必填)", nil) WithNumLimit:50];
    [_View_OtherTaxes addSubview:view4];
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

//更新税率视图
-(void)update_TaxRateView:(MyProcurementModel *)model{
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
    UILabel *title=[GPUtils createLable:CGRectMake(12,0,XBHelper_Title_Width, 50) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    title.numberOfLines = 2;
    [_view_Tax addSubview:title];
    [_view_Tax addSubview:[self createLineViewOfHeight_ByTitle:0]];
    _txf_Tax = [[GkTextField alloc]initWithFrame:CGRectMake(XBHelper_Title_Width+27,0,Main_Screen_Width-XBHelper_Title_Width-42, 50)];
    _txf_Tax.placeholder=[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"";
    _txf_Tax.delegate=self;
    _txf_Tax.font=Font_Important_15_20;
    _txf_Tax.textColor=Color_form_TextField_20;
    _txf_Tax.keyboardType =UIKeyboardTypeDefault;
    _txf_Tax.textAlignment = NSTextAlignmentLeft;
    [_view_Tax addSubview:_txf_Tax];
    
    if ([NSString isEqualToNull:model.fieldValue]) {
        _txf_Tax.text=model.fieldValue;
    }
}
//更新不含税金额视图
-(void)update_ExclTaxView:(MyProcurementModel *)model{
    _txf_ExclTax=[[GkTextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExclTax WithContent:_txf_ExclTax WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    [_view_ExclTax addSubview:view];
    [_view_Tax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
}
//MARK:更新付款金额税额视图
-(void)updateInvPmtTaxViewWithModel:(MyProcurementModel *)model{
    _txf_InvPmtTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtTax WithContent:_txf_InvPmtTax WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setAmountChangedBlock:^(NSString *amount) {
        NSString *local = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate]?weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
        weakSelf.txf_InvPmtAmountExclTax.text =[GPUtils transformNsNumber:[GPUtils decimalNumberSubWithString:local with:amount]];
    }];
    [_View_InvPmtTax addSubview:view];
    
    if (![[NSString stringWithFormat:@"%@",self.str_InvoiceType] isEqualToString:@"1"]) {
        [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _txf_InvPmtTax.text=@"";
    }else{
        if (([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"])&&[NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0){
            [_View_InvPmtTax updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_InvPmtTax.text=@"";
        }
    }
    
}
//MARK:更新付款金额不含税金额视图
-(void)updateInvPmtAmountExclTaxViewWithModel:(MyProcurementModel *)model{
    _txf_InvPmtAmountExclTax = [[GkTextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_InvPmtAmountExclTax WithContent:_txf_InvPmtAmountExclTax WithFormType:formViewShowAmount WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
    [_View_InvPmtAmountExclTax addSubview:view];
    
    if (![[NSString stringWithFormat:@"%@",self.str_InvoiceType] isEqualToString:@"1"]) {
        [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        _txf_InvPmtAmountExclTax.text=@"";
    }else{
        if (([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"])&&[NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] < 0){
            [_View_InvPmtAmountExclTax updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            _txf_InvPmtAmountExclTax.text=@"";
        }
    }
}
//更新报销类型视图
-(void)update_ClaimTypeView:(MyProcurementModel *)model{
    if (_Enabled_Expense==0) {
        _txf_ClaimType = [[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ClaimType WithContent:_txf_ClaimType WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model){
            STOnePickView *picker = [[STOnePickView alloc]init];
            [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                if (![Model.Id isEqualToString:self.str_ClaimType]) {
                    weakSelf.str_ClaimType = Model.Id;
                    weakSelf.txf_ClaimType.text = Model.Type;
                    [weakSelf dealWithClaimType];
                }
            }];
            picker.typeTitle=Custing(@"报销类型", nil);
            picker.DateSourceArray=weakSelf.arr_ClaimType;
            STOnePickModel *model1=[[STOnePickModel alloc]init];
            model1.Id=[NSString isEqualToNull: weakSelf.str_ClaimType]?weakSelf.str_ClaimType:@"";
            picker.Model=model1;
            [picker UpdatePickUI];
            [picker setContentMode:STPickerContentModeBottom];
            [picker show];
        }];
        [_view_ClaimType addSubview:view];
        
        
        if (self.arr_ClaimType.count > 0) {
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", _str_ClaimType];
            NSArray *filterArray = [self.arr_ClaimType filteredArrayUsingPredicate:pred1];
            if (filterArray.count > 0) {
                STOnePickModel *model1 = filterArray[0];
                _str_ClaimType = model1.Id;
                _txf_ClaimType.text = model1.Type;
            }else{
                _str_ClaimType = @"1";
                _txf_ClaimType.text = Custing(@"差旅费", nil);
            }
        }else{
            _str_ClaimType = @"1";
            _txf_ClaimType.text = Custing(@"差旅费", nil);
        }
    }
}

-(void)dealWithClaimType{
    _str_expenseCode = @"";
    _str_expenseIcon = @"";
    _txf_ExpenseCode.text = @"";
    _str_expenseDesc = @"";
    _img_ExpenseCode.image = [UIImage new];
    _str_expenseCode_tag = @"";
    [self cleanData];
    [self requestGetTyps];
    [self updateCateGoryView];
    [self clearCateData];
    [self update_View_ExpenseCode_Click_First:@""];
    [[NSUserDefaults standardUserDefaults]setInteger:[_str_ClaimType integerValue] forKey:Define_addCost];
}

//更新费用类别视图
-(void)update_ExpenseCodeView:(MyProcurementModel *)model{
    _txf_ExpenseCode = [[UITextField alloc]init];
    _sub_Expense = [[SubmitFormView alloc]initBaseView:_view_ExpenseCode WithContent:_txf_ExpenseCode WithFormType:formViewSelectCate WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    _sub_Expense.CateClickedBlock = ^(MyProcurementModel *model, UIImageView *image) {
        if (![NSString isEqualToNull:weakSelf.str_show_title]) {
            weakSelf.img_ExpenseCode = image;
            UIButton *btn = [UIButton new];
            btn.tag = 4;
            [weakSelf btn_Click:btn];
        }
    };
    [_view_ExpenseCode addSubview:_sub_Expense];
    if ([NSString isEqualToNull:_str_expenseIcon]) {
        [_sub_Expense setCateImg:_str_expenseIcon];
    }
    if (_Type == 3) {
        [_sub_Expense setCateImg:[NSString isEqualToNull:_str_expenseIcon]?_str_expenseIcon:@"15"];
        _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_str_ExpenseCat,_expenseType]];
        _str_expenseCode = [NSString isEqualToNull:model.fieldValue]?model.fieldValue:_str_expenseCode;
    }else{
        _str_expenseCode = [NSString isEqualToNull:model.fieldValue]?model.fieldValue:@"";
    }
    if ([NSString isEqualToNull:_str_expenseCode]) {
        _str_lastExpenseCode = _str_expenseCode;
    }
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
        _str_lastExpenseDate = model.fieldValue;
    }else{
        _txf_ExpenseDate.text = [NSString stringWithDate:[NSDate date]];
    }
    if (_Action == 4) {
        _txf_ExpenseDate.text = [NSString stringWithDate:[NSDate date]];
    }
}

-(void)update_PayTypeIdView:(MyProcurementModel *)model{
    _model_PayTypeId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_PayTypeId.view_View WithContent:_model_PayTypeId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    _model_PayTypeId.txf_TexfField.text = @"";
    [_model_PayTypeId.view_View addSubview:view];
    
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"2"]) {
        _model_PayTypeId.Id = @"2";
        _model_PayTypeId.txf_TexfField.text = Custing(@"企业支付", nil);
        
    }else{
        _model_PayTypeId.Id = @"1";
        _model_PayTypeId.txf_TexfField.text = Custing(@"个人支付", nil);
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.model_PayTypeId.txf_TexfField.text = Model.Type;
            weakSelf.model_PayTypeId.Id = Model.Id;
        }];
        picker.typeTitle = Custing(@"支付方式", nil);
        picker.DateSourceArray = [NSMutableArray arrayWithArray:weakSelf.arr_PayTypeId];
        STOnePickModel *stmodel = [[STOnePickModel alloc]init];
        stmodel.Id = [NSString isEqualToNull:weakSelf.model_PayTypeId.Id]?weakSelf.model_PayTypeId.Id:@"1";
        picker.Model = stmodel;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
}

-(void)update_SupplierIdView:(MyProcurementModel *)model{
    _model_SupplierId.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_SupplierId.view_View WithContent:_model_SupplierId.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    _model_SupplierId.txf_TexfField.text = @"";
    [_model_SupplierId.view_View addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _model_SupplierId.Id = model.fieldValue;
    }
    if ([NSString isEqualToNull:_model_SupplierId.Value]) {
        _model_SupplierId.txf_TexfField.text = _model_SupplierId.Value;
    }
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Supplier"];
        vc.ChooseCategoryId=weakSelf.model_SupplierId.Id;
        vc.ChooseModel=model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_SupplierId.txf_TexfField.text =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.model_SupplierId.Value = [GPUtils getSelectResultWithArray:@[model.code,model.name]];
            weakSelf.model_SupplierId.Id = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//MARK:是否境外
-(void)updateOverseasView:(MyProcurementModel *)model{
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
        self.model_Overseas.Id = @"1";
    }else{
        model.fieldValue = Custing(@"否", nil);
        self.model_Overseas.Id = @"0";
    }
    _model_Overseas.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_model_Overseas.view_View WithContent:_model_Overseas.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![weakSelf.model_Overseas.Id isEqualToString:Model.Id]) {
                weakSelf.model_Overseas.Id = Model.Id;
                weakSelf.model_Overseas.txf_TexfField.text = Model.Type;
                [weakSelf updateOverseasSubViews];
            }
        }];
        picker.typeTitle = Custing(@"是否境外", nil);
        picker.DateSourceArray = weakSelf.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.model_Overseas.Id;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_model_Overseas.view_View addSubview:view];
}

//MARK:国别
-(void)updateNationalityView:(MyProcurementModel *)model{
    _model_Nationality.model = model;
    _model_Nationality.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_model_Nationality.view_View WithContent:_model_Nationality.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.model_Nationality.Id;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_Nationality.Value = model.name;
            weakSelf.model_Nationality.txf_TexfField.text = model.name;
            weakSelf.model_Nationality.Id = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_model_Nationality.view_View addSubview:view];
}
//MARK:交易代码
-(void)updateTransactionCodeView:(MyProcurementModel *)model{
    _model_TransactionCode.model = model;
    _model_TransactionCode.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_model_TransactionCode.view_View WithContent:_model_TransactionCode.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
        vc.ChooseCategoryId = weakSelf.model_TransactionCode.Id;
        vc.ChooseModel = model;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.model_TransactionCode.Value = model.name;
            weakSelf.model_TransactionCode.txf_TexfField.text = model.name;
            weakSelf.model_TransactionCode.Id = model.Id;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [_model_TransactionCode.view_View addSubview:view];
}
//MARK:是否手工票据
-(void)updateHandmadePaperView:(MyProcurementModel *)model{
    _model_HandmadePaper.model = model;
    if ([[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"1"]) {
        model.fieldValue = Custing(@"是", nil);
        self.model_HandmadePaper.Id = @"1";
    }else{
        model.fieldValue = Custing(@"否", nil);
        self.model_HandmadePaper.Id = @"0";
    }
    _model_HandmadePaper.txf_TexfField = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_model_HandmadePaper.view_View WithContent:_model_HandmadePaper.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    view.FormClickedBlock = ^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            if (![weakSelf.model_HandmadePaper.Id isEqualToString:Model.Id]) {
                weakSelf.model_HandmadePaper.Id = Model.Id;
                weakSelf.model_HandmadePaper.txf_TexfField.text = Model.Type;
            }
        }];
        picker.typeTitle = Custing(@"是否手工票据", nil);
        picker.DateSourceArray = weakSelf.arr_IsOrNot;
        STOnePickModel *model1 = [[STOnePickModel alloc]init];
        model1.Id = weakSelf.model_HandmadePaper.Id;
        picker.Model = model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    };
    [_model_HandmadePaper.view_View addSubview:view];
}
//MARK:更新是否外币相关视图
-(void)updateOverseasSubViews{
    NSInteger height = 0;
    if ([self.model_Overseas.Id isEqualToString:@"1"]) {
        height = 60;
    }
    if ([[_model_Nationality.model.isShow stringValue]isEqualToString:@"1"]) {
        [_model_Nationality.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if ([[_model_TransactionCode.model.isShow stringValue]isEqualToString:@"1"]) {
        [_model_TransactionCode.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if ([[_model_HandmadePaper.model.isShow stringValue]isEqualToString:@"1"]) {
        [_model_HandmadePaper.view_View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }
    if (height == 0) {
        _model_Nationality.Value = @"";
        _model_Nationality.Id = @"0";
        _model_TransactionCode.Value = @"";
        _model_TransactionCode.Id = @"";
        _model_HandmadePaper.Id = @"0";
    }
}
//更新发票号码视图
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
            self.int_requiredReason=model1.requiredReason;
            self.int_requiredAtt=model1.requiredAtt;
        }
    }
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_model_HasInvoice.view_View WithContent:_model_HasInvoice.txf_TexfField WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_HasInvoice=Model.Id;
            weakSelf.model_HasInvoice.txf_TexfField.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",Model.Type]]?[NSString stringWithFormat:@"%@",Model.Type]:@"";
            weakSelf.int_requiredAtt=Model.requiredAtt;
            weakSelf.int_requiredReason=Model.requiredReason;
            weakSelf.str_ReplExpenseCode=@"";
            weakSelf.str_ReplExpenseType=@"";
            [weakSelf update_NoInvReasonView:weakSelf.model_NoInvReason];
            [weakSelf update_ReplExpenseView:weakSelf.model_ReplExpense];
        }];
        picker.typeTitle=Custing(@"是否有发票", nil);
        picker.DateSourceArray=self.array_HasInvoice;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=[NSString isEqualToNull:weakSelf.str_HasInvoice]?weakSelf.str_HasInvoice:@"1";
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }];
    [_model_HasInvoice.view_View addSubview:view];
}

//更新无发票要原因视图
-(void)update_NoInvReasonView:(MyProcurementModel *)model{
    for(UIView *view in [_view_NoInvReason subviews]){
        [view removeFromSuperview];
    }
    if (([self.str_HasInvoice isEqualToString:@"0"]||[self.str_HasInvoice isEqualToString:@"2"])&&[model.isShow floatValue]==1) {
        _txf_NoInvReason=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_NoInvReason WithContent:_txf_NoInvReason WithFormType:formViewEnterText WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
        [_view_NoInvReason addSubview:view];
        _txf_NoInvReason.placeholder=[NSString stringIsExist:model.tips];
    }else{
        [_view_NoInvReason updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
}
//MARK:更新替票费用类别
-(void)update_ReplExpenseView:(MyProcurementModel *)model{
    for(UIView *view in [_view_ReplExpense subviews]){
        [view removeFromSuperview];
    }
    if ([self.str_HasInvoice isEqualToString:@"2"]&&[model.isShow floatValue]==1) {
        _txf_ReplExpense=[[UITextField alloc]init];
        SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ReplExpense WithContent:_txf_ReplExpense WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:@{@"value1":self.str_ReplExpenseType}];
        __weak typeof(self) weakSelf = self;
        [view setFormClickedBlock:^(MyProcurementModel *model) {
            [weakSelf keyClose];
            if (!weakSelf.arr_ReplCategoryArr) {
                weakSelf.arr_ReplCategoryArr = [NSMutableArray array];
                NSString *url=[NSString stringWithFormat:@"%@",GETCATEList];
                NSDictionary *parameters = @{@"Type":@"0"};
                [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:weakSelf SerialNum:5 IfUserCache:NO];
            }else{
                [weakSelf ReplExpenseClick];
            }
        }];
        [_view_ReplExpense addSubview:view];
    }else{
        [_view_ReplExpense updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
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
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithBaseView:_view_Attachments withEditStatus:1 withModel:model];
    view.maxCount = 10;
    [_view_Attachments addSubview:view];
    [view updateWithTotalArray:_totalArray WithImgArray:_imagesArray];
    
}

//更新附件视图
-(void)update_FilesView:(MyProcurementModel *)model{
    [_model_Files.view_View updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@138);
    }];
    [_model_Files.view_View addSubview:[self createUpLineView]];
    UILabel * titleLbl = [GPUtils createLable:CGRectMake(12,10,Main_Screen_Width-24, 40) text:model.Description font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [_model_Files.view_View addSubview:titleLbl];
    
    EditAndLookImgView *view=[[EditAndLookImgView alloc]initWithFrame:CGRectMake(0, 40, Main_Screen_Width, 88) withEditStatus:1];
    view.maxCount=10;
    [_model_Files.view_View addSubview:view];
    [view updateWithTotalArray:_arr_FilesTotal WithImgArray:_arr_FilesImage];
    
    UIView *views= [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    views.backgroundColor = Color_form_TextFieldBackgroundColor;
    [view addSubview:views];
}

//更新成本中心视图
-(void)update_CostCenterIdView:(MyProcurementModel *)model{
    _txf_CostCenterId = [[UITextField alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_CostCenterId WithContent:_txf_CostCenterId WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        UIButton *btn = [UIButton new];
        btn.tag = 8;
        [weakSelf btn_Click:btn];
    }];
    [_view_CostCenterId addSubview:view];
    if ([NSString isEqualToNull:model.fieldValue]) {
        _str_CostCenterId = model.fieldValue;
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
//更新项目活动视图
-(void)updateProjectActivityView:(MyProcurementModel *)model{
    model.fieldValue = [GPUtils getSelectResultWithArray:@[self.str_ProjectActivityLv1Name,self.str_ProjectActivityLv2Name] WithCompare:@"/"];
    _txf_ProjActivity = [[UITextField alloc]init];
    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:_View_ProjActivity WithContent:_txf_ProjActivity WithFormType:formViewSelect WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model){
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ProjActivitys"];
        vc.ChooseCategoryId = self.str_ProjectActivityLv2;
        if ([NSString isEqualToNullAndZero:weakSelf.str_ProjId]) {
            vc.dict_otherPars = @{@"PrjId":weakSelf.str_ProjId};
        }
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            self.str_ProjectActivityLv1 = model.id_Lv1;
            self.str_ProjectActivityLv1Name = model.name_Lv1;
            self.str_ProjectActivityLv2 = model.Id;
            self.str_ProjectActivityLv2Name = model.name;
            self.txf_ProjActivity.text = [GPUtils getSelectResultWithArray:@[model.name_Lv1,model.name] WithCompare:@"/"];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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

//更新费用描述视图
-(void)update_ExpenseDescView:(MyProcurementModel *)model{
    _txv_ExpenseDesc=[[UITextView alloc]init];
    model.enterLimit=500;
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_ExpenseDesc WithContent:_txv_ExpenseDesc WithFormType:formViewEnterTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    [_view_ExpenseDesc addSubview:view];
}

//更新备注视图
-(void)update_RemarkView:(MyProcurementModel *)model{
    if (self.model_didi) {
        model.fieldValue = [NSString stringWithIdOnNO:self.model_didi.remark];
    }else if (self.model_addDetail){
        model.fieldValue = [NSString stringWithIdOnNO:self.model_addDetail.remark];
    }
    _txv_Remark=[[UITextView alloc]init];
    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:_view_Remark WithContent:_txv_Remark WithFormType:formViewVoiceTextView WithSegmentType:lineViewNoneLine Withmodel:model WithInfodict:nil];
    view.iflyRecognizerView=_iflyRecognizerView;
    [_view_Remark addSubview:view];
}

//更新通用审批自定义字段
-(void)updateReserved1ViewWithModel:(MyProcurementModel *)model{
    __weak typeof(self) weakSelf = self;
    [_Reserved1View addSubview:[[ReserverdMainView alloc]initArr:_muarr_MainView isRequiredmsdic:[NSMutableDictionary dictionary] reservedDic:[NSMutableDictionary dictionary] UnShowmsArray:[NSMutableArray array] view:_Reserved1View model:_model_rs block:^(NSInteger height) {
        [weakSelf.Reserved1View updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }]];
}

-(void)update_View_ExpenseCode_Click_First:(NSString *)tip{
    [self requestGetExpStdAddFirst];
}


//费用类别选择后
-(void)update_View_ExpenseCode_Click:(NSString *)tip{
    
    if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"10"] && _model_addDetail) {
        tip = _model_addDetail.tag;
    }
    
    if ([_str_isShowExpenseDesc isEqualToString:@"1"]) {
        if ([NSString isEqualToNull:_str_expenseDesc]) {
            
            CGFloat height = [_str_expenseDesc sizeCalculateWithFont:Font_Same_12_20 constrainedToSize:CGSizeMake(Main_Screen_Width-24, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height+4;
            [_view_ExpenseCode mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(height+60);
            }];
            if (_view_ex_expenseDesc == nil) {
                _view_ex_expenseDesc = [[UIView alloc]initWithFrame:CGRectMake(0, 60, Main_Screen_Width, height)];
                _view_ex_expenseDesc.backgroundColor = Color_White_Same_20;
                [_view_ExpenseCode addSubview:_view_ex_expenseDesc];
                [self.view_ContentView layoutIfNeeded];
            }
            if (_lab_ex_expenseDesc == nil) {
                _lab_ex_expenseDesc = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width-24, height) text:_str_expenseDesc font:Font_Same_12_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
                _lab_ex_expenseDesc.numberOfLines = 0;
                [_view_ex_expenseDesc addSubview:_lab_ex_expenseDesc];
            }
            _view_ex_expenseDesc.hidden = NO;
            _lab_ex_expenseDesc.hidden = NO;
            _lab_ex_expenseDesc.text = _str_expenseDesc;
        }else{
            [_view_ExpenseCode mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
            }];
            [_view_ex_expenseDesc removeFromSuperview];
            _view_ex_expenseDesc = nil;
            [_lab_ex_expenseDesc removeFromSuperview];
            _lab_ex_expenseDesc = nil;
        }
    }
    
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
            [self requestExpuserGetStdType];
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
        [self requestGetExpStd];
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
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Hospitality"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"hospitality"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"hospitality"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                cell_height = [dic[@"isShow"]integerValue]==1?cell_height+1:cell_height;
                MyProcurementModel *model = [MyProcurementModel new];
                [model setValuesForKeysWithDictionary:dic];
                if ([model.fieldName isEqualToString:@"ReceptionFellowOfficers"]) {
                    _str_ReceptionFellowOfficers=[NSString stringWithIdOnNO:model.fieldValue];
                }
                [arr_Expense_Click addObject:model];
            }
        }
        [self requestGetExpStd];
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
                    model.isRequired=[NSNumber numberWithInteger:[dic[@"isRequired"]integerValue]];
                    model.fieldValue=[NSString stringWithIdOnNO:_str_CorpCarFromDate];
                    model.fieldName=@"CorpCarFromDate";
                    model.tips=Custing(@"请选择开始时间", nil);
                    [arr_Expense_Click addObject:model];
                    
                    MyProcurementModel *model1 = [MyProcurementModel new];
                    model1.Description=Custing(@"结束时间", nil);
                    model1.isShow=[NSNumber numberWithInteger:[dic[@"isShow"]integerValue]];
                    model1.fieldName=@"CorpCarToDate";
                    model1.tips=Custing(@"请选择结束时间", nil);
                    model1.isRequired=[NSNumber numberWithInteger:[dic[@"isRequired"]integerValue]];
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
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Correspondence"]) {
        arr_Expense_temporary = [_dic_request[@"result"][@"correspondence"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"correspondence"]:[NSArray array];
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
                    _model_TransTypeId.Value=[NSString stringWithIdOnNO:dic[@"fieldValue"]];
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
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Office"]) {
        cell_height = cell_height+4;
        NSArray *arr=@[@{@"isShow": @1,
                         @"tips": Custing(@"请选择办事处", nil),
                         @"isRequired": @1,
                         @"fieldName": @"Location",
                         @"description":Custing(@"办事处", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请选择开始时间", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OfficeFromDate",
                         @"description":Custing(@"开始时间", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请选择结束时间", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OfficeToDate",
                         @"description":Custing(@"结束时间", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请输入天数", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OfficeTotalDays",
                         @"description":Custing(@"天数", nil)}];
        for (NSDictionary *dic in arr) {
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr_Expense_Click addObject:model];
        }
        [self requestGetExpStd];
    }else if ([tip isEqualToString:@"Overseas"]) {
        cell_height = cell_height+4;
        NSArray *arr=@[@{@"isShow": @1,
                         @"tips": Custing(@"请选择公司", nil),
                         @"isRequired": @1,
                         @"fieldName": @"Branch",
                         @"description":Custing(@"公司", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请选择开始时间", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OverseasFromDate",
                         @"description":Custing(@"开始时间", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请选择结束时间", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OverseasToDate",
                         @"description":Custing(@"结束时间", nil)},
                       @{@"isShow": @1,
                         @"tips": Custing(@"请输入天数", nil),
                         @"isRequired": @1,
                         @"fieldName": @"OverseasTotalDays",
                         @"description":Custing(@"天数", nil)}];
        for (NSDictionary *dic in arr) {
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr_Expense_Click addObject:model];
        }
        [self requestGetExpStd];
    }else{
        [self requestGetExpStd];
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
            if ([tip isEqualToString:@"CorpCar"]||[tip isEqualToString:@"Hospitality"]||[tip isEqualToString:@"Taxi"]||[tip isEqualToString:@"Office"]||[tip isEqualToString:@"Overseas"]||[tip isEqualToString:@"SelfDrive"]) {
                UIView *baseView=[[UIView alloc]init];
                [_view_ExpenseCode_Click addSubview:baseView];
                [baseView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                    make.left.width.equalTo(self.view_ExpenseCode_Click);
                }];
                if ([model.fieldName isEqualToString:@"ReceptionObject"]) {
                    _txf_ReceptionObject=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionObject WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionReason"]){
                    _txf_ReceptionReason=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionReason WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionLocation"]){
                    _txf_ReceptionLocation=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionLocation WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"Visitor"]){
                    _txf_Visitor=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Visitor WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"VisitorDate"]){
                    _txf_VisitorDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_VisitorDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                    
                }else if ([model.fieldName isEqualToString:@"LeaveDate"]){
                    _txf_LeaveDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_LeaveDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionFellowOfficersId"]){
                    _txf_ReceptionFellowOfficers=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionFellowOfficers WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_ReceptionFellowOfficers}];
                    _str_ReceptionFellowOfficerId=[NSString stringWithIdOnNO:model.fieldValue];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model){
                        contactsVController *contactVC=[[contactsVController alloc]init];
                        contactVC.status = @"3";
                        NSMutableArray *array = [NSMutableArray array];
                        NSArray *idarr = [weakSelf.str_ReceptionFellowOfficerId componentsSeparatedByString:@","];
                        for (int i = 0 ; i<idarr.count ; i++) {
                            NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                            [array addObject:dic];
                        }
                        contactVC.arrClickPeople =array;
                        contactVC.menutype=2;
                        contactVC.itemType = 99;
                        contactVC.Radio = @"2";
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
                            weakSelf.str_ReceptionFellowOfficerId=[GPUtils getSelectResultWithArray:idArr WithCompare:@","];
                            weakSelf.str_ReceptionFellowOfficers=[GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
                            weakSelf.txf_ReceptionFellowOfficers.text=weakSelf.str_ReceptionFellowOfficers;
                        }];
                        [weakSelf.navigationController pushViewController:contactVC animated:YES];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"ReceptionTotalPeople"]){
                    _txf_ReceptionTotalPeople=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionTotalPeople WithFormType:formViewEnterNum WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"ReceptionCateringCo"]){
                    _txf_ReceptionCateringCo=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ReceptionCateringCo WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarDCityName"]){
                    _txf_CorpCarDCityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarDCityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarACityName"]){
                    _txf_CorpCarACityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarACityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"CorpCarMileage"]){
                    _txf_CorpCarMileage=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarMileage WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    //                    __weak typeof(self) weakSelf = self;
                    //                    [view setAmountChangedBlock:^(NSString *amount) {
                    //                        [weakSelf update_Amount:amount textField:weakSelf.txf_CorpCarMileage];
                    //                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CorpCarFuelBills"]){
                    _txf_CorpCarFuelBills=[[UITextField alloc]init];
                    SubmitFormView *view= [[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarFuelBills WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf update_Amount:amount textField:weakSelf.txf_CorpCarFuelBills];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CorpCarPontage"]){
                    _txf_CorpCarPontage=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarPontage WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf update_Amount:amount textField:weakSelf.txf_CorpCarPontage];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CorpCarParkingFee"]){
                    _txf_CorpCarParkingFee=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarParkingFee WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf update_Amount:amount textField:weakSelf.txf_CorpCarParkingFee];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CorpCarNo"]){
                    _txf_CorpCarNo=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarNo WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model){
                        ChooseCategoryController *choose=[[ChooseCategoryController alloc]initWithType:@"CARNO"];
                        choose.ChooseCategoryId=weakSelf.txf_CorpCarNo.text;
                        choose.ChooseNormalCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                            ChooseCategoryModel *model = array[0];
                            weakSelf.txf_CorpCarNo.text=model.carNo;
                        };
                        [weakSelf.navigationController pushViewController:choose animated:YES];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CorpCarFromDate"]){
                    _txf_CorpCarFromDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarFromDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                    
                }else if ([model.fieldName isEqualToString:@"CorpCarToDate"]){
                    _txf_CorpCarToDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CorpCarToDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiDCityName"]){
                    _txf_TaxiDCityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiDCityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiACityName"]){
                    _txf_TaxiACityName=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiACityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiFromDate"]){
                    _txf_TaxiFromDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiFromDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"TaxiToDate"]){
                    _txf_TaxiToDate=[[UITextField alloc]init];
                    [baseView addSubview:[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TaxiToDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil]];
                }else if ([model.fieldName isEqualToString:@"Location"]){
                    _txf_Location=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Location WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_Location}];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model) {
                        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"location"];
                        vc.ChooseCategoryId=self.str_LocationId;
                        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                            ChooseCateFreModel *model = array[0];
                            weakSelf.str_LocationId=model.Id;
                            weakSelf.txf_Location.text=model.name;
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                    self.str_Location=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeFromDate"]){
                    _txf_OfficeFromDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeFromDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeFromDate}];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        weakSelf.txf_OfficeTotalDays.text=[NSDate DateDuringFromTime:selectTime to:weakSelf.txf_OfficeToDate.text WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:2];
                    }];
                    self.str_OfficeFromDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeToDate"]){
                    _txf_OfficeToDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeToDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeToDate}];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        weakSelf.txf_OfficeTotalDays.text=[NSDate DateDuringFromTime:weakSelf.txf_OfficeFromDate.text to:selectTime WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:2];
                    }];
                    self.str_OfficeToDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OfficeTotalDays"]){
                    _txf_OfficeTotalDays=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OfficeTotalDays WithFormType:formViewEnterDays WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OfficeTotalDays}];
                    self.str_OfficeTotalDays=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Branch"]){
                    _txf_Branch=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Branch WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_Branch}];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model) {
                        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"BranchCompany"];
                        vc.ChooseCategoryId=weakSelf.str_BranchId;
                        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                            ChooseCateFreModel *model = array[0];
                            weakSelf.str_BranchId=model.groupId;
                            weakSelf.txf_Branch.text=model.groupName;
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                    self.str_Branch=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasFromDate"]){
                    _txf_OverseasFromDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasFromDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasFromDate}];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        weakSelf.txf_OverseasTotalDays.text=[NSDate DateDuringFromTime:selectTime to:weakSelf.txf_OverseasToDate.text WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:2];
                    }];
                    self.str_OverseasFromDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasToDate"]){
                    _txf_OverseasToDate=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasToDate WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasToDate}];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        weakSelf.txf_OverseasTotalDays.text=[NSDate DateDuringFromTime:weakSelf.txf_OverseasFromDate.text to:selectTime WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:2];
                    }];
                    self.str_OverseasToDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OverseasTotalDays"]){
                    _txf_OverseasTotalDays=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OverseasTotalDays WithFormType:formViewEnterDays WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OverseasTotalDays}];
                    self.str_OverseasTotalDays=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"OilPrice"]){
                    _txf_OilPrice=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_OilPrice WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:@{@"value1":self.str_OilPrice}];
                    self.str_OilPrice = @"";
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"SDCityName"]){
                    _txf_SDCityName=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_SDCityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"SACityName"]){
                    _txf_SACityName=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_SACityName WithFormType:formViewEnterText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"StartMeter"]){
                    _txf_StartMeter=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_StartMeter WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        weakSelf.txf_Mileage.text = ([[GPUtils decimalNumberSubWithString:weakSelf.txf_EndMeter.text with:amount]floatValue] > 0)? [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:weakSelf.txf_EndMeter.text with:amount] afterPoint:2]:@"0";
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"EndMeter"]){
                    _txf_EndMeter=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_EndMeter WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        weakSelf.txf_Mileage.text = ([[GPUtils decimalNumberSubWithString:amount with:weakSelf.txf_StartMeter.text]floatValue] > 0) ? [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:amount with:weakSelf.txf_StartMeter.text] afterPoint:2]:@"0";
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Mileage"]){
                    _txf_Mileage=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Mileage WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"CarStd"]){
                    _txf_CarStd=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_CarStd WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"FuelBills"]){
                    _txf_FuelBills=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_FuelBills WithFormType:formViewShowText WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Pontage"]){
                    _txf_Pontage=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_Pontage WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"ParkingFee"]){
                    _txf_ParkingFee=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_ParkingFee WithFormType:formViewEnterAmout WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf dealSelfDriverAmount];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"SDepartureTime"]){
                    _txf_SDepartureTime=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_SDepartureTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    //                    __weak typeof(self) weakSelf = self;
                    //                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                    //                        weakSelf.txf_OfficeTotalDays.text=[NSDate DateDuringFromTime:selectTime to:weakSelf.txf_OfficeToDate.text WithFormat:@"yyyy/MM/dd HH:mm" WithDuringType:2];
                    //                    }];
                    //                    self.str_OfficeFromDate=@"";
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"SArrivalTime"]){
                    _txf_SArrivalTime=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_SArrivalTime WithFormType:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
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
                }else if ([model.fieldName isEqualToString:@"TotalDays"]) {
                    _txf_TotalDays = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TotalDays.delegate=self;
                    _txf_TotalDays.keyboardType =UIKeyboardTypeNumberPad;
                    [_view_ExpenseCode_Click addSubview:_txf_TotalDays];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TotalDays.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"HotelPrice"]) {
                    _txf_HotelPrice = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_HotelPrice.delegate=self;
                    _txf_HotelPrice.userInteractionEnabled = NO;
                    _txf_HotelPrice.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_HotelPrice];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_HotelPrice.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"HotelName"]) {
                    [title removeFromSuperview];
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_HotelName = [[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_HotelName WithFormType:[model.ctrlTyp isEqualToString:@"dialog"] ? formViewSelect:formViewEnterText WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model){
                        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
                        vc.ChooseCategoryName = weakSelf.txf_HotelName.text;
                        vc.ChooseModel = model;
                        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                            ChooseCateFreModel *model = array[0];
                            weakSelf.txf_HotelName.text = model.name;
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        self.txf_HotelName.text = model.fieldValue;
                    }
                    [baseView addSubview:view];
                    
                }else if ([model.fieldName isEqualToString:@"Rooms"]) {
                    _txf_Rooms = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Rooms.delegate=self;
                    _txf_Rooms.keyboardType =UIKeyboardTypeNumberPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Rooms];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Rooms.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"FellowOfficersId"]) {
                    _txf_FellowOfficers = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42-30, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FellowOfficers.delegate=self;
                    _txf_FellowOfficers.keyboardType =UIKeyboardTypeNumberPad;
                    _txf_FellowOfficers.userInteractionEnabled = NO;
                    _txf_FellowOfficers.textAlignment = NSTextAlignmentLeft;
                    [_view_ExpenseCode_Click addSubview:_txf_FellowOfficers];
                    
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 15;
                    [_view_ExpenseCode_Click addSubview:btn];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _str_FellowOfficersId=model.fieldValue;
                    }else{
                        if ([NSString isEqualToNull:_str_FellowOfficers]) {
                            _txf_FellowOfficers.text = _str_FellowOfficers;
                        }else{
                            _txf_FellowOfficers.text = self.dict_parameter[@"Requestor"] ? self.dict_parameter[@"Requestor"]:self.userdatas.userDspName;
                        }
                    }
                }else if ([model.fieldName isEqualToString:@"Breakfast"]) {
                    _txf_Breakfast = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Breakfast.delegate=self;
                    _txf_Breakfast.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Breakfast];
                    if ([NSString isEqualToNullAndZero:model.fieldValue]&&[model.fieldValue floatValue]!=0) {
                        _txf_Breakfast.text=model.fieldValue;
                    }else{
                        if ([NSString isEqualToNull:_txf_TotalPeople.text]) {
                            _txf_Breakfast.text = [self getStandardAmountWithKey:@"amount"];;
                        }
                    }
                }else if ([model.fieldName isEqualToString:@"TotalPeople"]) {
                    _txf_TotalPeople = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    
                    _txf_TotalPeople.delegate=self;
                    _txf_TotalPeople.keyboardType =UIKeyboardTypeNumberPad;
                    [_view_ExpenseCode_Click addSubview:_txf_TotalPeople];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TotalPeople.text=model.fieldValue;
                    }else{
                        if ([NSString isEqualToNull:_str_TotalPeople]) {
                            _txf_TotalPeople.text = _str_TotalPeople;
                        }else{
                        _txf_TotalPeople.text = @"1";
                        }
                    }
                }else if ([model.fieldName isEqualToString:@"MealsTotalDays"]) {
                    [title removeFromSuperview];
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_MealsTotalDays = [[UITextField alloc]init];
                    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_MealsTotalDays WithFormType:formViewEnterDays WithSegmentType:lineViewNone Withmodel:model WithInfodict:nil];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"Lunch"]) {
                    _txf_Lunch = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Lunch.delegate=self;
                    _txf_Lunch.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Lunch];
                    if ([NSString isEqualToNullAndZero:model.fieldValue]&&[model.fieldValue floatValue]!=0) {
                        _txf_Lunch.text=model.fieldValue;
                    }else{
                        _txf_Lunch.text = [self getStandardAmountWithKey:@"amount2"];;
                    }
                }else if ([model.fieldName isEqualToString:@"Supper"]) {
                    _txf_Supper = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Supper.delegate=self;
                    _txf_Supper.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Supper];
                    if ([NSString isEqualToNullAndZero:model.fieldValue]&&[model.fieldValue floatValue]!=0) {
                        _txf_Supper.text=model.fieldValue;
                    }else{
                        _txf_Supper.text = [self getStandardAmountWithKey:@"amount3"];;
                    }
                }else if ([model.fieldName isEqualToString:@"Flight"]) {
                    _txf_Flight = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Flight.delegate=self;
                    _txf_Flight.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Flight];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Flight.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"CateringCo"]) {
                    _txf_CateringCo = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_CateringCo.delegate=self;
                    _txf_CateringCo.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_CateringCo];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_CateringCo.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"FDCityName"]) {
                    _txf_FDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FDCityName.delegate=self;
                    _txf_FDCityName.keyboardType = UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_FDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FDCityName.text=model.fieldValue;
                    }
                    _txf_FDCityName.userInteractionEnabled = NO;
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 32;
                    [_view_ExpenseCode_Click addSubview:btn];
                }else if ([model.fieldName isEqualToString:@"FACityName"]) {
                    _txf_FACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_FACityName.delegate=self;
                    _txf_FACityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_FACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_FACityName.text=model.fieldValue;
                    }
                    _txf_FACityName.userInteractionEnabled = NO;
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                    btn.tag = 33;
                    [_view_ExpenseCode_Click addSubview:btn];
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
                }else if ([model.fieldName isEqualToString:@"Discount"]) {
                    _txf_Discount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_Discount.delegate=self;
                    _txf_Discount.keyboardType =UIKeyboardTypeDecimalPad;
                    [_view_ExpenseCode_Click addSubview:_txf_Discount];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_Discount.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"TDCityName"]) {
                    _txf_TDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TDCityName.delegate=self;
                    _txf_TDCityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_TDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TDCityName.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"TACityName"]) {
                    _txf_TACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TACityName.delegate=self;
                    _txf_TACityName.keyboardType =UIKeyboardTypeDefault;
                    [_view_ExpenseCode_Click addSubview:_txf_TACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TACityName.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"SeatName"]) {
                    
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_SeatName=[[UITextField alloc]init];
                    SubmitFormView *view = [[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_SeatName WithFormType:formViewSelect WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setFormClickedBlock:^(MyProcurementModel *model){
                        STOnePickView *picker = [[STOnePickView alloc]init];
                        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
                            weakSelf.txf_SeatName.text = Model.Type;
                        }];
                        picker.typeTitle=Custing(@"座位", nil);
                        picker.DateSourceArray=weakSelf.arr_TrainSeats;
                        [picker UpdatePickUI];
                        [picker setContentMode:STPickerContentModeBottom];
                        [picker show];
                    }];
                    [baseView addSubview: view];
                    
                }else if ([model.fieldName isEqualToString:@"AllowanceAmount"]) {
                    _txf_AllowanceAmount = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_AllowanceAmount.userInteractionEnabled=NO;
                    [_view_ExpenseCode_Click addSubview:_txf_AllowanceAmount];
                }else if ([model.fieldName isEqualToString:@"TransDCityName"]) {
                    _txf_TransDCityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TransDCityName.delegate=self;
                    [_view_ExpenseCode_Click addSubview:_txf_TransDCityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TransDCityName.text=model.fieldValue;
                    }
                }else if ([model.fieldName isEqualToString:@"TransACityName"]) {
                    _txf_TransACityName = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _txf_TransACityName.delegate=self;
                    [_view_ExpenseCode_Click addSubview:_txf_TransACityName];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _txf_TransACityName.text=model.fieldValue;
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
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransFromDate WithFormType:_int_TransTimeType==1?formViewSelectDate:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        if ([NSString isEqualToNull:weakSelf.txf_TransToDate.text]) {
                            weakSelf.txf_TransTotalDays.text = [NSDate DateDuringFromTime:[selectTime substringToIndex:10] to:[weakSelf.txf_TransToDate.text substringToIndex:10] WithFormat:@"yyyy/MM/dd" WithDuringType:3];
                            [weakSelf dealWithTransAmountViews];
                        }
                    }];
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
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransToDate WithFormType:_int_TransTimeType == 1 ? formViewSelectDate:formViewSelectDateTime WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setTimeClickedBlock:^(MyProcurementModel *model, NSString *selectTime) {
                        if ([NSString isEqualToNull:weakSelf.txf_TransFromDate.text]) {
                            weakSelf.txf_TransTotalDays.text = [NSDate DateDuringFromTime:[weakSelf.txf_TransFromDate.text substringToIndex:10] to:selectTime WithFormat:@"yyyy/MM/dd" WithDuringType:3];
                            [weakSelf dealWithTransAmountViews];
                        }
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"TransTotalDays"]) {
                    UIView *baseView=[[UIView alloc]init];
                    [_view_ExpenseCode_Click addSubview:baseView];
                    [baseView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view_ExpenseCode_Click.mas_top).offset(@(50*i));
                        make.left.width.equalTo(self.view_ExpenseCode_Click);
                    }];
                    _txf_TransTotalDays=[[UITextField alloc]init];
                    SubmitFormView *view=[[SubmitFormView alloc]initBaseView:baseView WithContent:_txf_TransTotalDays WithFormType:formViewEnterDays WithSegmentType:lineViewOnlyLine Withmodel:model WithInfodict:nil];
                    __weak typeof(self) weakSelf = self;
                    [view setAmountChangedBlock:^(NSString *amount) {
                        [weakSelf dealWithTransAmountViews];
                    }];
                    [baseView addSubview:view];
                }else if ([model.fieldName isEqualToString:@"TransTypeId"]) {
                    _model_TransTypeId.txf_TexfField = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42-10, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _model_TransTypeId.txf_TexfField.delegate=self;
                    _model_TransTypeId.txf_TexfField.keyboardType =UIKeyboardTypeNumberPad;
                    _model_TransTypeId.txf_TexfField.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_model_TransTypeId.txf_TexfField];
                    if ([NSString isEqualToNull:model.fieldValue]) {
                        _model_TransTypeId.Id=model.fieldValue;
                    }
                    if ([NSString isEqualToNull:_model_TransTypeId.Value]) {
                        _model_TransTypeId.txf_TexfField.text = _model_TransTypeId.Value;
                    }
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:nil delegate:self];
                    [_view_ExpenseCode_Click addSubview:btn];
                    __weak typeof(self) weakSelf = self;
                    [btn bk_whenTapped:^{
                        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
                        vc.ChooseCategoryId=weakSelf.model_TransTypeId.Id;
                        vc.ChooseModel=model;
                        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                            ChooseCateFreModel *model = array[0];
                            weakSelf.model_TransTypeId.txf_TexfField.text = model.name;
                            weakSelf.model_TransTypeId.Value = model.name;
                            weakSelf.model_TransTypeId.Id = model.Id;
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                }else if ([model.fieldName isEqualToString:@"CrspFromDate"]) {
                    _model_CrspFromDate.txf_TexfField = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42-10, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                    _model_CrspFromDate.txf_TexfField.delegate=self;
                    _model_CrspFromDate.txf_TexfField.keyboardType =UIKeyboardTypeNumberPad;
                    _model_CrspFromDate.txf_TexfField.userInteractionEnabled = NO;
                    [_view_ExpenseCode_Click addSubview:_model_CrspFromDate.txf_TexfField];
                    if ([NSString isEqualToNull:_model_CrspFromDate.Value]&&[NSString isEqualToNull:_model_CrspFromDate.Id]) {
                        _model_CrspFromDate.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",_model_CrspFromDate.Id,_model_CrspFromDate.Value];
                    }
                    if ([NSString isEqualToNull:_model_CrspFromDate.Value]&&[NSString isEqualToNull:_model_CrspFromDate.Id]) {
                        _model_CrspFromDate.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",_model_CrspFromDate.Id,_model_CrspFromDate.Value];
                    }
                    UIImageView *image =[GPUtils createImageViewFrame:CGRectMake(Main_Screen_Width-35,(i*50)+ 15, 20, 20) imageName:@"skipImage"];
                    [_view_ExpenseCode_Click addSubview:image];
                    
                    UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:nil delegate:self];
                    [_view_ExpenseCode_Click addSubview:btn];
                    __weak typeof(self) weakSelf = self;
                    __block NSString *str_date = @"";
                    [btn bk_whenTapped:^{
                        STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"开始时间", nil) Type:1 Date:weakSelf.model_CrspFromDate.Id];
                        [view setSTblock:^(NSString *date) {
                            str_date = date;
                            STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"结束时间", nil) Type:1 Date:weakSelf.model_CrspFromDate.Value];
                            [view setSTblock:^(NSString *date) {
                                NSTimeInterval secs = [[NSDate TimeFromString:str_date] timeIntervalSinceDate:[NSDate TimeFromString:date]];
                                if (secs>0) {
                                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.5];
                                }else{
                                    weakSelf.model_CrspFromDate.txf_TexfField.text = [NSString stringWithFormat:@"%@-%@",str_date,date];
                                    weakSelf.model_CrspFromDate.Id = str_date;
                                    weakSelf.model_CrspFromDate.Value = date;
                                }
                            }];
                            [view show];
                        }];
                        [view show];
                    }];
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
}

-(void)dealWithTransAmountViews{
    _txf_Amount.text = [GPUtils decimalNumberMultipWithString:_txf_AllowanceAmount.text with:_txf_TransTotalDays.text];
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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

//更新点击费用类别视图
-(void)updateCateGoryView{
    if ([_str_ExpenseCode_level isEqualToString:@"1"]) {
        if (_bool_isOpenGener == YES) {
            _img_CateImage.image=[UIImage imageNamed:@"skipImage"];
            _bool_isOpenGener = NO;
            [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.view_ex_expenseDesc ? @(self.view_ex_expenseDesc.zl_height+60):@60);
            }];
            [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }else if(_bool_isOpenGener==NO){
            _img_CateImage.image=[UIImage imageNamed:@"share_Open"];
            _bool_isOpenGener=YES;
            if (_inte_ExpenseCode_Rows == 0) {
                [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(self.view_ex_expenseDesc ? @(self.view_ex_expenseDesc.zl_height+60):@60);
                }];
                [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }else{
                [_view_ExpenseCode updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@((65*self.inte_ExpenseCode_Rows)+(self.view_ex_expenseDesc ? self.view_ex_expenseDesc.zl_height+70:70)));
                }];
                [_col_CategoryCollectView updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view_ExpenseCode.top).offset(self.view_ex_expenseDesc?@85:@60);
                    make.height.equalTo(@((65*self.inte_ExpenseCode_Rows)+(self.view_ex_expenseDesc ? self.view_ex_expenseDesc.zl_height+70:70)));
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
            _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:newString] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"]) afterPoint:2];
        }
        if (textField == _txf_Rooms) {
            _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:_txf_TotalDays.text] with:[newString floatValue] > 0 ? newString:@"1"]) afterPoint:2];
        }
        if (textField == _txf_Amount) {
            if ([NSString isEqualToNull:_txf_TotalDays.text]) {
                NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:newString with:[self getEndExchangeRate]];
                LocalCyAmount=[GPUtils getRoundingOffNumber:LocalCyAmount afterPoint:2];
                LocalCyAmount=[NSString isEqualToNull:LocalCyAmount]?LocalCyAmount:@"0.00";
                _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:LocalCyAmount with:_txf_TotalDays.text] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"]) afterPoint:2];
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_Breakfast == textField) {
                _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_Supper.text floatValue]+[newString floatValue]+[_txf_Lunch.text floatValue]];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                
            }else if (_txf_Supper == textField){
                _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_Breakfast.text floatValue]+[newString floatValue]+[_txf_Lunch.text floatValue]];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                
            }else if (_txf_Lunch == textField){
                _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_Breakfast.text floatValue]+[newString floatValue]+[_txf_Supper.text floatValue]];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
    }else if ([_str_expenseCode_tag isEqualToString:@"CorpCar"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_CorpCarFuelBills == textField){
                NSString *amount=[GPUtils decimalNumberAddWithString:newString with:_txf_CorpCarPontage.text];
                amount=[GPUtils decimalNumberAddWithString:amount with:_txf_CorpCarParkingFee.text];
                _txf_Amount.text =[NSString notRounding:amount afterPoint:2];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                
            }else if (_txf_CorpCarPontage == textField){
                NSString *amount=[GPUtils decimalNumberAddWithString:_txf_CorpCarFuelBills.text with:newString];
                amount=[GPUtils decimalNumberAddWithString:amount with:_txf_CorpCarParkingFee.text];
                _txf_Amount.text =[NSString notRounding:amount afterPoint:2];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                
            }else if (_txf_CorpCarParkingFee == textField){
                NSString *amount=[GPUtils decimalNumberAddWithString:_txf_CorpCarFuelBills.text with:_txf_CorpCarPontage.text];
                amount=[GPUtils decimalNumberAddWithString:amount with:newString];
                _txf_Amount.text =[NSString notRounding:amount afterPoint:2];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
    }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]){
        if ([NSString isEqualToNull:newString]||[newString isEqualToString:@""]) {
            if (_txf_Day == textField) {
                _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[[self dealWithMealAmountText] floatValue]*[newString floatValue]];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
    }
}

//更新
-(void)updateAllowanceView:(NSInteger )basis{
    NSMutableArray *arr_Expense_Click = [NSMutableArray array];
    _arr_Allowance_Main = [NSMutableArray array];
    NSInteger cell_height = 0;
    
    if (basis == 1) {
        _arr_Allowance_Main = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
                                                                 @"tips": Custing(@"请输入补贴标准", nil),
                                                                 @"isRequired": @0,
                                                                 @"fieldName": @"MealAmount",
                                                                 @"description":Custing(@"补贴标准", nil),
                                                                 @"fieldValue":@""}
        ]];
    }else if (basis == 2) {
        _arr_Allowance_Main = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
    }else if (basis == 3) {
        _arr_Allowance_Main = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
                                                                 @"isRequired": @0,
                                                                 @"fieldName": @"MealAmount",
                                                                 @"description":Custing(@"补贴标准", nil),
                                                                 @"fieldValue":@""}
        ]];
    }else if (basis == 4) {
        _arr_Allowance_Main = [NSMutableArray arrayWithArray:@[@{@"isShow": @1,
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
        [_arr_Allowance_Main addObject:@{@"isShow": @1,
                                         @"tips": Custing(@"请输入天数", nil),
                                         @"isRequired": @1,
                                         @"fieldName": @"TotalDays",
                                         @"description":Custing(@"天数", nil),
                                         @"fieldValue":@"1"}];
    }
    
    if ([_model_AllowanceFromDate.model.isShow integerValue]==1) {
        _model_AllowanceToDate.model.isShow=[NSNumber numberWithInteger:1];
        _model_AllowanceToDate.model.isRequired=[NSNumber numberWithInteger:[_model_AllowanceFromDate.model.isRequired integerValue]];
        _model_AllowanceToDate.model.ctrlTyp=_model_AllowanceFromDate.model.ctrlTyp;
        if (basis ==1) {
            [_arr_Allowance_Main insertObject:[MyProcurementModel initDicByModel:_model_AllowanceToDate.model] atIndex:0];
        }else{
            [_arr_Allowance_Main insertObject:[MyProcurementModel initDicByModel:_model_AllowanceToDate.model] atIndex:2];
        }
    }
    if ([_model_AllowanceFromDate.model.isShow integerValue]==1) {
        if (basis ==1) {
            [_arr_Allowance_Main insertObject:[MyProcurementModel initDicByModel:_model_AllowanceFromDate.model] atIndex:0];
        }else{
            [_arr_Allowance_Main insertObject:[MyProcurementModel initDicByModel:_model_AllowanceFromDate.model] atIndex:2];
        }
    }
    if ([_model_TravelUserName.model.isShow integerValue] == 1) {
        [_arr_Allowance_Main addObject:[MyProcurementModel initDicByModel:_model_TravelUserName.model]];
    }
    if (_arr_Allowance_Main.count>0) {
        for (int i = 0; i<_arr_Allowance_Main.count; i++) {
            NSDictionary *dic = _arr_Allowance_Main[i];
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
                if ([NSString isEqualToNullAndZero:_str_Amount]) {
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
                [self updateAllowanceData];
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
            }else if ([model.fieldName isEqualToString:@"AllowanceFromDate"]) {
                
                _model_AllowanceFromDate.txf_TexfField = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _model_AllowanceFromDate.txf_TexfField.delegate=self;
                _model_AllowanceFromDate.txf_TexfField.userInteractionEnabled = NO;
                _model_AllowanceFromDate.txf_TexfField.keyboardType = UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_model_AllowanceFromDate.txf_TexfField];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _model_AllowanceFromDate.txf_TexfField.text =[model.ctrlTyp isEqualToString:@"day"]?[model.fieldValue substringToIndex:10]: model.fieldValue;
                    _model_AllowanceFromDate.Value=_model_AllowanceFromDate.txf_TexfField.text;
                }
                UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                [_view_ExpenseCode_Click addSubview:iconImage];
                UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                __weak typeof(self) weakSelf = self;
                [btn bk_whenTapped:^{
                    if ([model.ctrlTyp isEqualToString:@"day"]) {
                        weakSelf.selectDataType=1;
                        [weakSelf chooseTime];
                    }else{
                        HKDatePickView *DuringDatePicker = [[HKDatePickView alloc]initWithType:1 WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                        DuringDatePicker.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200);
                        NSDateFormatter *format=[[NSDateFormatter alloc] init];
                        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
                        NSDate *fromdate=[format dateFromString:[NSString isEqualToNull:weakSelf.model_AllowanceFromDate.Value]?weakSelf.model_AllowanceFromDate.Value:[NSDate getDateAndTimeNow]];
                        DuringDatePicker.curDate=fromdate;
                        [weakSelf.view addSubview:DuringDatePicker];
                        [DuringDatePicker showInView:weakSelf.view];
                        [DuringDatePicker setBlock:^(NSString *date, NSInteger type) {
                            weakSelf.model_AllowanceFromDate.txf_TexfField.text = date;
                            weakSelf.model_AllowanceFromDate.Value = date;
                            if ([weakSelf.str_expenseCode_tag isEqualToString:@"Allowance"] && [[weakSelf getStandardAmountWithKey:@"basis"]floatValue]==4) {
                                [weakSelf requestGetExpStdUpdateView];
                            }
                            if ([NSString isEqualToNull:weakSelf.model_AllowanceFromDate.txf_TexfField.text]&&[NSString isEqualToNull:weakSelf.model_AllowanceToDate.txf_TexfField.text]) {
                                if ([NSDate CompareDateStartTime:weakSelf.model_AllowanceFromDate.txf_TexfField.text endTime:weakSelf.model_AllowanceToDate.txf_TexfField.text WithFormatter:@"yyyy/MM/dd HH:mm"]<=0) {
                                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"开始时间不能小于结束时间", nil) duration:1.5];
                                    weakSelf.model_AllowanceFromDate.txf_TexfField.text = weakSelf.model_AllowanceToDate.txf_TexfField.text;
                                    weakSelf.model_AllowanceFromDate.Value = weakSelf.model_AllowanceToDate.txf_TexfField.text;
                                }else{
                                    if (weakSelf.txf_Day!=nil) {
                                        weakSelf.txf_Day.text = [NSDate AddCostCountFromDate:weakSelf.model_AllowanceFromDate.txf_TexfField.text ToDate:weakSelf.model_AllowanceToDate.txf_TexfField.text];
                                    }
                                }
                            }
                        }];
                    }
                }];
                [_view_ExpenseCode_Click addSubview:btn];
            }else if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                _model_AllowanceToDate.txf_TexfField = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必填)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                _model_AllowanceToDate.txf_TexfField.delegate=self;
                _model_AllowanceToDate.txf_TexfField.userInteractionEnabled = NO;
                _model_AllowanceToDate.txf_TexfField.keyboardType = UIKeyboardTypeNumberPad;
                [_view_ExpenseCode_Click addSubview:_model_AllowanceToDate.txf_TexfField];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _model_AllowanceToDate.txf_TexfField.text =[model.ctrlTyp isEqualToString:@"day"]?[model.fieldValue substringToIndex:10]:model.fieldValue;
                    _model_AllowanceToDate.Value=_model_AllowanceToDate.txf_TexfField.text;
                }
                UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                [_view_ExpenseCode_Click addSubview:iconImage];
                UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                __weak typeof(self) weakSelf = self;
                [btn bk_whenTapped:^{
                    if ([model.ctrlTyp isEqualToString:@"day"]) {
                        weakSelf.selectDataType=2;
                        [weakSelf chooseTime];
                    }else{
                        HKDatePickView *DuringDatePicker = [[HKDatePickView alloc]initWithType:1 WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                        DuringDatePicker.frame = CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 200);
                        NSDateFormatter *format=[[NSDateFormatter alloc] init];
                        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
                        NSDate *fromdate=[format dateFromString:[NSString isEqualToNull:weakSelf.model_AllowanceToDate.Value]?weakSelf.model_AllowanceToDate.Value:[NSDate getDateAndTimeNow]];
                        DuringDatePicker.curDate=fromdate;
                        [weakSelf.view addSubview:DuringDatePicker];
                        [DuringDatePicker showInView:weakSelf.view];
                        [DuringDatePicker setBlock:^(NSString *date, NSInteger type) {
                            weakSelf.model_AllowanceToDate.txf_TexfField.text = date;
                            weakSelf.model_AllowanceToDate.Value = date;
                            if ([NSString isEqualToNull:weakSelf.model_AllowanceFromDate.txf_TexfField.text]&&[NSString isEqualToNull:weakSelf.model_AllowanceToDate.txf_TexfField.text]) {
                                if ([NSDate CompareDateStartTime:weakSelf.model_AllowanceFromDate.txf_TexfField.text endTime:weakSelf.model_AllowanceToDate.txf_TexfField.text WithFormatter:@"yyyy/MM/dd HH:mm"]>=0) {
                                    if (weakSelf.txf_Day!=nil) {
                                        weakSelf.txf_Day.text = [NSDate AddCostCountFromDate:weakSelf.model_AllowanceFromDate.txf_TexfField.text ToDate:weakSelf.model_AllowanceToDate.txf_TexfField.text];
                                        [weakSelf updateAllowanceData];
                                    }
                                }else{
                                    [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.5];
                                    weakSelf.model_AllowanceToDate.txf_TexfField.text = weakSelf.model_AllowanceFromDate.txf_TexfField.text;
                                    weakSelf.model_AllowanceToDate.Value = weakSelf.model_AllowanceFromDate.txf_TexfField.text;
                                }
                            }
                        }];
                        
                    }
                }];
                [_view_ExpenseCode_Click addSubview:btn];
            }else if ([model.fieldName isEqualToString:@"TravelUserName"]){
                
                _model_TravelUserName.txf_TexfField = [GPUtils createTextField:CGRectMake(XBHelper_Title_Width+27,(i*50),Main_Screen_Width-XBHelper_Title_Width-42, 50) placeholder:[model.isRequired intValue]==1?[NSString stringWithFormat:@"%@%@",[NSString isEqualToNull:model.tips]?model.tips:@"",Custing(@"(必选)",nil)]:[NSString isEqualToNull:model.tips]?model.tips:@"" delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
                [_view_ExpenseCode_Click addSubview:_model_TravelUserName.txf_TexfField];
                if ([NSString isEqualToNull:model.fieldValue]) {
                    _model_TravelUserName.txf_TexfField.text = [NSString stringWithIdOnNO:model.fieldValue];
                }
                UIImageView * iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skipImage"]];
                iconImage.frame = CGRectMake(Main_Screen_Width-35, (i*50)+15, 20, 20);
                [_view_ExpenseCode_Click addSubview:iconImage];
                UIButton *btn = [GPUtils createButton:CGRectMake(100, (i*50), Main_Screen_Width-100, 50) action:@selector(btn_Click:) delegate:self];
                __weak typeof(self) weakSelf = self;
                [btn bk_whenTapped:^{
                    contactsVController *contactVC=[[contactsVController alloc]init];
                    contactVC.status = @"3";
                    NSMutableArray *array = [NSMutableArray array];
                    NSArray *idarr = [self.model_TravelUserName.Id componentsSeparatedByString:@","];
                    for (int i = 0 ; i<idarr.count ; i++) {
                        NSDictionary *dic = @{@"requestorUserId":idarr[i]};
                        [array addObject:dic];
                    }
                    contactVC.arrClickPeople =array;
                    contactVC.menutype=2;
                    contactVC.itemType = 99;
                    contactVC.Radio = @"2";
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
                        weakSelf.model_TravelUserName.Id = [GPUtils getSelectResultWithArray:idArr WithCompare:@","];
                        weakSelf.model_TravelUserName.Value = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
                        weakSelf.model_TravelUserName.txf_TexfField.text = weakSelf.model_TravelUserName.Value;
                        [weakSelf requestGetExpStdUpdateView];
                    }];
                    [weakSelf.navigationController pushViewController:contactVC animated:YES];
                }];
                [_view_ExpenseCode_Click addSubview:btn];
            }
            
        }
    }
}
//更新汇率视图
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
        
        //        [self cleanData];
        //        [self requestGetTyps];
        //        [self updateCateGoryView];
        if ([_dic_route isKindOfClass:[NSDictionary class]]&&_dic_route.count>0) {
            if ([NSString isEqualToNull:_dic_route[@"expenseCode"]]) {
                [_sub_Expense setCateImg:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
                _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
                _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_dic_route[@"expenseCat"],_dic_route[@"expenseType"]]];
                _str_expenseDesc = [NSString stringWithIdOnNO:_dic_route[@"expenseDesc"]];
                _str_expenseCode = _dic_route[@"expenseCode"];
                _str_expenseIcon = _dic_route[@"expenseIcon"];
                _str_expenseCode_tag = [NSString isEqualToNull:_dic_route[@"tag"]]?_dic_route[@"tag"]:@"";
            }
        }
        [self updateRouteDeta];
    }else if (_model_didi!=nil){
        [_view_RouteDetail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@265);
        }];
        
        RouteModel *route = [RouteDidiModel DidiChangeRouteModle:_model_didi];
        RouteDetailView *view=[[RouteDetailView alloc]initRouteDetail:route withType:2];
        view.frame=CGRectMake(0, 0, Main_Screen_Width, 215);
        [_view_RouteDetail addSubview:view];
        [_view_RouteDetail addSubview:[self createLineViewOfHeight:215]];
        view.backgroundColor = Color_eaeaea_20;
        UILabel *lab = [GPUtils createLable:CGRectMake(0, 215, Main_Screen_Width, 50) text:Custing(@"订单来源：滴滴出行", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentCenter];
        [_view_RouteDetail addSubview:lab];
        
        _str_expenseCode_tag = [NSString stringWithIdOnNO:_model_didi.tag];
        
        
        //        [self cleanData];
        //        [self requestGetTyps];
        //        [self updateCateGoryView];
        //        [self updateRouteDetaDidi];
    }
}

-(void)updateRouteDeta{
    if (_model_route!=nil) {
        if (![NSString isEqualToNull:_txf_SDCityName.text]) {
            _txf_SDCityName.text = _model_route.departureName;
        }
        if (![NSString isEqualToNull:_txf_SACityName.text]) {
            _txf_SACityName.text = _model_route.arrivalName;
        }
        if (![NSString isEqualToNull:_txf_Mileage.text]) {
            _txf_Mileage.text = _model_route.mileage;
        }
    }
}

-(void)updateRouteDetaDidi{
    if ([_dic_route isKindOfClass:[NSDictionary class]]&&_model_didi!=nil) {
        if ([NSString isEqualToNull:_dic_route[@"expenseCode"]]) {
            [_sub_Expense setCateImg:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
            _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_dic_route[@"expenseIcon"]]?_dic_route[@"expenseIcon"]:@"15"];
            _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_dic_route[@"expenseCat"],_dic_route[@"expenseType"]]];
            _str_expenseCode = _dic_route[@"expenseCode"];
            _str_expenseDesc = [NSString stringWithIdOnNO:_dic_route[@"expenseDesc"]];
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
    if ([NSString isEqualToNull:_txf_Day.text]) {
        _txf_Amount.text = [GPUtils decimalNumberMultipWithString:[self dealWithMealAmountText] with:_txf_Day.text];
    }else{
        _txf_Amount.text = [self dealWithMealAmountText];
    }
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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

#pragma mark 数据处理
//初始化数据
-(void)initializeData{
    _bool_firstIn=YES;
    _txf_ExchangeRate=[[UITextField alloc]init];
    _txf_CarStd=[[UITextField alloc]init];
    _str_ClaimType = @"0";
    _str_MealType = @"1";
    _str_City = @"";
    _str_Day = @"";
    _str_MealAmount = @"";
    _str_MealAmount1 = @"";
    if (!_Type) {
        _before_Type = 1;
        if (_Enabled_addAgain != 1) {
            NSInteger i = [[[NSUserDefaults standardUserDefaults] objectForKey:Define_addCost] integerValue];
            if (i != 3) {
                _Type = i?i:1;
            }else{
                _Type = 1;
            }
        }else{
            _Type = 1;
        }
    }else{
        _before_Type = _Type;
    }
    if (_Type) {
        _str_ClaimType = [NSString stringWithFormat:@"%ld",(long)_Type];
    }
    
    if (!_Action) {
        _Action = 1;
    }
    if (!_Enabled_Expense) {
        _Enabled_Expense = 0;
    }
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
    _str_Currency = @"";
    _arr_expenseCodeList = [NSArray array];
    _str_Status = @"";
    _str_Basis = @"";
    _str_Amount = @"";
    _str_Amount2 = @"";
    _str_Amount3 = @"";
    _str_Unit = @"";
    _str_Class = @"";
    _str_Discount = @"";
    _str_IsExpensed = @"";
    _str_LimitMode = @"";
    _str_Flight = @"";
    _str_FellowOfficersId = @"";
    _arr_FellowOfficersId = [NSMutableArray array];
    _dic_stdOutput = [NSDictionary dictionary];
    _arr_Flight = @[Custing(@"经济舱", nil),Custing(@"商务舱", nil),Custing(@"头等舱", nil)];
    _str_AllowanceCurrency = @"";
    _str_AllowanceCurrencyCode = @"";
    _str_AllowanceCurrencyRate = @"";
    _str_Currency = @"";
    _arr_stdSelfDriveDtoList = [NSArray array];
    _str_RequestUserId = @"";
    _str_MedicalAmount = @"";
    _str_expenseDesc = @"";
    _model_Files = [[WorkFormFieldsModel alloc]initialize];
    _arr_FilesTotal = [NSMutableArray array];
    _arr_FilesImage = [NSMutableArray array];
    _arr_FilesType = [NSMutableArray array];
    _str_isShowExpenseDesc = @"0";
    _str_FDCityType = @"";
    _str_FDCityCode = @"";
    _str_FACityType = @"";
    _str_FACityCode = @"";
    _model_AllowanceFromDate = [[WorkFormFieldsModel alloc]initialize];
    _model_AllowanceToDate = [[WorkFormFieldsModel alloc]initialize];
    _model_TravelUserName = [[WorkFormFieldsModel alloc]initialize];
    _model_rs = [[ReserverdMainModel alloc]init];
    _model_HasInvoice = [[WorkFormFieldsModel alloc]initialize];
    _model_PayTypeId = [[WorkFormFieldsModel alloc]initialize];
    _model_PayTypeId.Id=@"1";
    _model_SupplierId = [[WorkFormFieldsModel alloc]initialize];
    _model_TransTypeId = [[WorkFormFieldsModel alloc]initialize];
    _model_CrspFromDate = [[WorkFormFieldsModel alloc]initialize];
    
    _model_Overseas = [[WorkFormFieldsModel alloc]initialize];
    _model_Nationality = [[WorkFormFieldsModel alloc]initialize];
    _model_TransactionCode = [[WorkFormFieldsModel alloc]initialize];
    _model_HandmadePaper = [[WorkFormFieldsModel alloc]initialize];
    
    _arr_PayTypeId = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        STOnePickModel *model = [[STOnePickModel alloc]init];
        model.Id = [NSString stringWithFormat:@"%d",i+1];
        model.Type = i==0?Custing(@"个人支付", nil):Custing(@"企业支付", nil);
        [_arr_PayTypeId addObject:model];
    }
    self.str_HasInvoice=@"1";
    _str_InvoiceTypeName = @"";
    _str_InvoiceTypeCode = @"";
    _str_InvoiceType = @"0";
    
    self.array_shareForm = [NSMutableArray array];
    self.array_shareData = [NSMutableArray array];
    self.str_shareTotal = @"0";
    self.str_shareRatio = @"0";

//    礼品费
    self.arr_DetailsArray = [NSMutableArray array];
    self.arr_DetailsDataArray = [NSMutableArray array];
}

//处理请求后数据
-(void)analysisRequestData{
//    expenseShare 费用分摊判断
    self.bool_shareShow = [_dic_request[@"result"][@"expenseShare"] floatValue] == 1 ? YES:NO;
    if (self.bool_shareShow) {
//        expenseShareFields  费用分摊
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
    if ([NSString isEqualToNull:_dic_request[@"result"][@"expenseGiftDetailCodes"]]) {
        self.expenseGiftDetailCodes = _dic_request[@"result"][@"expenseGiftDetailCodes"];
    }
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
//    发票类型 expenseInvSettingDtos  有发票 无发票 合并发票
    if ([_dic_request[@"result"][@"expenseInvSettingDtos"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getInvoiceTypeWithDate:_dic_request[@"result"][@"expenseInvSettingDtos"] WithResult:_array_HasInvoice];
    }
    _arr_ClaimType=[NSMutableArray array];
//   报销类型 reimbursementTypes 差旅费 日常费 专项费
    if ([_dic_request[@"result"][@"reimbursementTypes"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getClaimTypeWithDate:_dic_request[@"result"][@"reimbursementTypes"] WithResult:_arr_ClaimType];
    }
    _arr_InvoiceType=[NSMutableArray array];
//     发票类别 invoiceTypes 增值税专用发票 增值税普通发票  增值税电子普通发票
    if ([_dic_request[@"result"][@"invoiceTypes"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getInvoiceTypesWithDate:_dic_request[@"result"][@"invoiceTypes"] WithResult:_arr_InvoiceType];
    }
    
    
    _arr_TaxRates=[NSMutableArray array];
//    税率 taxRates 0 3 6 9 10 。。。
    if ([_dic_request[@"result"][@"taxRates"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getTaxRatesWithDate:_dic_request[@"result"][@"taxRates"] WithResult:_arr_TaxRates];
    }
//  trainSeats 一等座 商务座
    _arr_TrainSeats=[NSMutableArray array];
    if ([_dic_request[@"result"][@"trainSeats"]isKindOfClass:[NSArray class]]) {
        [STOnePickModel getTrainSeatsWithDate:_dic_request[@"result"][@"trainSeats"] WithResult:_arr_TrainSeats];
    }
//   formFields 主表
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dic_request[@"result"][@"formFields"]];
    _muarr_MainView = [NSMutableArray array];
    _muarr_MainEndData = [NSMutableArray array];
//    claimPolicy 报销政策字典
    if (![_dic_request[@"result"][@"claimPolicy"] isKindOfClass:[NSNull class]]) {
        _dic_ReimPolicy = _dic_request[@"result"][@"claimPolicy"];
    }
//    driveCar
    if (![_dic_request[@"result"][@"driveCar"] isKindOfClass:[NSNull class]]) {
        _dic_route = _dic_request[@"result"][@"driveCar"];
        _model_route = [RouteModel modelWithDict:_dic_route];
    }
    //currency 币种
    NSMutableDictionary *Currencydict=[NSMutableDictionary dictionary];
    [STOnePickModel getCurrcyWithDate:[NSMutableArray arrayWithArray:[_dic_request[@"result"][@"currency"] isKindOfClass:[NSNull class]]?[NSMutableArray array]:_dic_request[@"result"][@"currency"]] WithResult:_muarr_CurrencyCode WithCurrencyDict:Currencydict];
    _str_CurrencyCode=Currencydict[@"CurrencyCode"];
    _str_ExchangeRate=Currencydict[@"ExchangeRate"];
    _txf_ExchangeRate.text=[NSString stringWithFormat:@"%@",_str_ExchangeRate];
    _str_Currency=Currencydict[@"Currency"];
//    expenseCodeList  expenseCode列表
    _arr_expenseCodeList = _dic_request[@"result"][@"expenseCodeList"];
    if (arr.count>0) {
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
//            MyProcurementModel 主表model  formFields字段下的
            MyProcurementModel *model = [MyProcurementModel new];
            [model setValuesForKeysWithDictionary:dic];
            model.isOnlyRead = [NSString stringWithId:dic[@"isReadOnly"]];
            [_muarr_MainView addObject:model];
            
            if ([model.fieldName isEqualToString:@"CostCenterId"]) {
                self.str_CostCenterId = [NSString stringIsExist:model.fieldValue];
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
            if ([model.fieldName isEqualToString:@"TotalDays"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_Day = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ExpenseCat"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ExpenseCat = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ExpenseCatCode"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ExpenseCatCode = [NSString stringWithFormat:@"%@",model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"MealType"]) {
                _str_MealType = [[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"0"] ? @"0":@"1";
                _model_mealType = model;
            }
            if ([model.fieldName isEqualToString:@"SupplierName"]&&[NSString isEqualToNull:model.fieldValue]) {
                _model_SupplierId.Value = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"DataSource"]&&[NSString isEqualToNull:model.fieldValue]) {
                _dateSource = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"RequestUserId"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_RequestUserId = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FDCityCode"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_FDCityCode = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FDCityType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_FDCityType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FACityCode"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_FACityCode = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"FACityType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_FACityType = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"PayTypeId"]) {
                _model_PayTypeId.Id = [[NSString stringWithFormat:@"%@",model.fieldValue]isEqualToString:@"2"] ? @"2":@"1";
            }
            
            if ([model.fieldName isEqualToString:@"CorpCarFromDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarFromDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"CorpCarToDate"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_CorpCarToDate = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ReceptionFellowOfficers"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReceptionFellowOfficers = model.fieldValue;
            }
            if ([model.fieldName isEqualToString:@"ReplExpenseType"]&&[NSString isEqualToNull:model.fieldValue]) {
                _str_ReplExpenseType = model.fieldValue;
            }
            if ([dic[@"fieldName"] isEqualToString:@"CostCenterMgrUserId"]) {
                self.str_CostCenterMgrUserId = [NSString stringIsExist:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"CostCenterMgr"]) {
                self.str_CostCenterMgr = [NSString stringIsExist:dic[@"fieldValue"]];
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
                self.str_InvoiceTypeCode = [NSString stringWithIdOnNO:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"Currency"]) {
                self.str_Currency=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_Currency;
            }
            if ([dic[@"fieldName"] isEqualToString:@"CurrencyCode"]) {
                self.str_CurrencyCode=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_CurrencyCode;
            }
            if ([dic[@"fieldName"] isEqualToString:@"ExchangeRate"]) {
                self.str_ExchangeRate=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",dic[@"fieldValue"]]]?dic[@"fieldValue"]:self.str_ExchangeRate;
                self.txf_ExchangeRate.text=self.str_ExchangeRate;
            }
            
            if ([model.fieldName isEqualToString:@"HasInvoice"]) {
                self.str_HasInvoice=[NSString isEqualToNull:model.fieldValue]?[NSString stringWithFormat:@"%@",model.fieldValue]:@"1";
            }
            if ([model.fieldName isEqualToString:@"CrspFromDate"]) {
                _model_CrspFromDate.Id = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"CrspToDate"]) {
                _model_CrspFromDate.Value = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"AllowanceFromDate"]) {
                model.Description = Custing(@"开始时间", nil);
                model.tips = Custing(@"请选择开始时间", nil);
                _model_AllowanceFromDate.model = model;
            }
            if ([model.fieldName isEqualToString:@"AllowanceToDate"]) {
                model.Description = Custing(@"结束时间", nil);
                model.tips = Custing(@"请选择结束时间", nil);
                _model_AllowanceToDate.model = model;
            }
            if ([model.fieldName isEqualToString:@"TravelUserId"]) {
                _model_TravelUserName.Id = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"TravelUserName"]) {
                _model_TravelUserName.model = model;
                _model_TravelUserName.Value = [NSString stringWithIdOnNO:model.fieldValue];
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
            if ([dic[@"fieldName"] isEqualToString:@"AccountItem"]) {
                self.str_accountItem = [NSString stringIsExist:dic[@"fieldValue"]];
            }
            if ([dic[@"fieldName"] isEqualToString:@"AccountItemCode"]) {
                self.str_accountItemCode = [NSString stringIsExist:dic[@"fieldValue"]];
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
                self.str_AirTicketPrice = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"";
            }
            if ([dic[@"fieldName"] isEqualToString:@"DevelopmentFund"]) {
                self.str_DevelopmentFund = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"";
            }
            if ([dic[@"fieldName"] isEqualToString:@"FuelSurcharge"]) {
                self.str_FuelSurcharge = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"";
            }
            if ([dic[@"fieldName"] isEqualToString:@"OtherTaxes"]) {
                self.str_OtherTaxes = [NSString isEqualToNull:dic[@"fieldValue"]] ? [NSString stringWithFormat:@"%@",dic[@"fieldValue"]]:@"";
            }
            
            if ([model.fieldName isEqualToString:@"Overseas"]) {
                _model_Overseas.Id = [NSString isEqualToNull:model.fieldValue] ? [NSString stringWithFormat:@"%@",model.fieldValue]:@"0";
            }
            if ([model.fieldName isEqualToString:@"Nationality"]) {
                _model_Nationality.Value = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"NationalityId"]) {
                _model_Nationality.Id = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"Nationality"]) {
                _model_Nationality.Value = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"TransactionCode"]) {
                _model_TransactionCode.Value = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"TransactionCodeId"]) {
                _model_TransactionCode.Id = [NSString stringWithIdOnNO:model.fieldValue];
            }
            if ([model.fieldName isEqualToString:@"HandmadePaper"]) {
                _model_HandmadePaper.Id = [NSString isEqualToNull:model.fieldValue] ? [NSString stringWithFormat:@"%@",model.fieldValue]:@"0";
            }
            //解析图片
            if ([dic[@"fieldName"] isEqualToString:@"Attachments"]&&_Action!=4) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_totalArray addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_totalArray WithImageArray:_imagesArray WithMaxCount:10];
                }
            }
            //解析图片
            if ([dic[@"fieldName"] isEqualToString:@"Files"]&&_Action!=4) {
                if (![model.fieldValue isKindOfClass:[NSNull class]]) {
                    _model_Files.Value = model.fieldValue;
                    NSArray * array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",model.fieldValue]];
                    for (NSDictionary *dict in array) {
                        [_arr_FilesTotal addObject:dict];
                    }
                    [GPUtils updateImageDataWithTotalArray:_arr_FilesTotal WithImageArray:_arr_FilesImage WithMaxCount:10];
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
    _str_isShowExpenseDesc=parDict[@"isShowExpenseDesc"];
}

//拼接上传数据
-(void)jointResponse{
    _model_NewAddCost = [[NewAddCostModel alloc]init];
    _model_NewAddCost.Type = [_str_ClaimType floatValue];
    _model_NewAddCost.ClaimType = [_str_ClaimType floatValue];
    _model_NewAddCost.Amount = _txf_Amount.text;
    _model_NewAddCost.CurrencyCode = _str_CurrencyCode;
    _model_NewAddCost.Currency = [NSString isEqualToNull:_txf_CurrencyCode.text]?_txf_CurrencyCode.text:_str_Currency;
    _model_NewAddCost.ExchangeRate =_txf_ExchangeRate.text;
    
    _model_NewAddCost.LocalCyAmount = [self getLocalCyAmount];
    
    CGFloat InvoiceTypeViewHeight = self.view_InvoiceType.zl_height;
    if (InvoiceTypeViewHeight > 0) {
        _model_NewAddCost.InvoiceType = _str_InvoiceType;
        _model_NewAddCost.InvoiceTypeName = _str_InvoiceTypeName;
        _model_NewAddCost.InvoiceTypeCode = _str_InvoiceTypeCode;
        
    }else{
        _model_NewAddCost.InvoiceType = @"0";
        _model_NewAddCost.InvoiceTypeName = @"";
        _model_NewAddCost.InvoiceTypeCode = @"";
    }
    
    _model_NewAddCost.TaxRate = self.view_TaxRate.zl_height > 0 ? _txf_TaxRate.text :@"";
    _model_NewAddCost.Tax = self.view_Tax.zl_height > 0 ?_txf_Tax.text:@"";
    _model_NewAddCost.AirlineFuelFee = self.View_AirlineFuelFee.zl_height > 0 ?_txf_AirlineFuelFee.text:@"0";
    _model_NewAddCost.AirTicketPrice = self.View_AirTicketPrice.zl_height > 0 ?_txf_AirTicketPrice.text:@"0";
    _model_NewAddCost.DevelopmentFund = self.View_DevelopmentFund.zl_height > 0 ?_txf_DevelopmentFund.text:@"0";
    _model_NewAddCost.FuelSurcharge = self.View_FuelSurcharge.zl_height > 0 ?_txf_FuelSurcharge.text:@"0";
    _model_NewAddCost.OtherTaxes = self.View_OtherTaxes.zl_height > 0 ?_txf_OtherTaxes.text:@"0";
    _model_NewAddCost.ExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:_model_NewAddCost.LocalCyAmount with:self.model_NewAddCost.Tax] afterPoint:2];
    
    _model_NewAddCost.InvCyPmtExchangeRate = self.str_InvCyPmtExchangeRate;
    NSString *InvPmtAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
    InvPmtAmount = [GPUtils getRoundingOffNumber:InvPmtAmount afterPoint:2];
    self.model_NewAddCost.InvPmtAmount = [NSString isEqualToNull:InvPmtAmount] ? InvPmtAmount:@"0.00";
    if (_View_InvPmtTax.zl_height > 0 && self.txf_InvPmtTax) {
        self.model_NewAddCost.InvPmtTax = self.txf_InvPmtTax.text;
    }else{
        self.model_NewAddCost.InvPmtTax = [NSString countTax:InvPmtAmount taxrate:self.model_NewAddCost.TaxRate];
    }
    self.model_NewAddCost.InvPmtAmountExclTax = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberSubWithString:InvPmtAmount with:self.model_NewAddCost.InvPmtTax] afterPoint:2];
    
    _model_NewAddCost.ExpenseCode = _str_expenseCode;
    if ([NSString isEqualToNull:_txf_ExpenseCode.text]) {
        _model_NewAddCost.ExpenseType = [_txf_ExpenseCode.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",_str_ExpenseCat] withString:@""];
    }
    _model_NewAddCost.ExpenseIcon = _str_expenseIcon;
    _model_NewAddCost.ExpenseCatCode = _str_ExpenseCatCode;
    _model_NewAddCost.ExpenseCat = _str_ExpenseCat;
    _model_NewAddCost.ExpenseDate = _txf_ExpenseDate.text;
    _model_NewAddCost.PayType =[[NSString stringWithFormat:@"%@",_model_PayTypeId.Id] isEqualToString:@"2"]?Custing(@"企业支付", nil):Custing(@"个人支付", nil);
    _model_NewAddCost.PayTypeId = [[NSString stringWithFormat:@"%@",_model_PayTypeId.Id] isEqualToString:@"2"]? @"2":@"1";
    _model_NewAddCost.SupplierName = _model_SupplierId.txf_TexfField.text;
    _model_NewAddCost.SupplierId = _model_SupplierId.Id;
    
    _model_NewAddCost.Overseas = [NSString isEqualToNull:_model_Overseas.Id] ? _model_Overseas.Id:@"0";
    _model_NewAddCost.Nationality = _model_Nationality.Value;
    _model_NewAddCost.NationalityId = [NSString isEqualToNull:_model_Nationality.Id] ? _model_Nationality.Id:@"0";
    _model_NewAddCost.TransactionCode = _model_TransactionCode.Value;
    _model_NewAddCost.TransactionCodeId = _model_TransactionCode.Id;
    _model_NewAddCost.HandmadePaper = [NSString isEqualToNull:_model_HandmadePaper.Id] ? _model_HandmadePaper.Id:@"0";
    
    
    _model_NewAddCost.InvoiceNo = _txf_InvoiceNo.text;
    _model_NewAddCost.HasInvoice = self.str_HasInvoice;
    
    _model_NewAddCost.NoInvReason = _txf_NoInvReason.text;
    _model_NewAddCost.Attachments = _str_imageDataString;
    _model_NewAddCost.Files = _model_Files.Value;
    _model_NewAddCost.CostCenterId = _str_CostCenterId;
    _model_NewAddCost.CostCenterMgr = _str_CostCenterMgr;
    _model_NewAddCost.CostCenterMgrUserId = _str_CostCenterMgrUserId;
    
    _model_NewAddCost.CostCenter = _txf_CostCenterId.text;
    _model_NewAddCost.ProjId = _str_ProjId;
    _model_NewAddCost.ProjName = _txf_ProjId.text;
    _model_NewAddCost.ProjMgr = _str_ProjMgr;
    _model_NewAddCost.ProjMgrUserId = _str_ProjMgrUserId;
    
    _model_NewAddCost.ProjectActivityLv1 = _str_ProjectActivityLv1;
    _model_NewAddCost.ProjectActivityLv1Name = _str_ProjectActivityLv1Name;
    _model_NewAddCost.ProjectActivityLv2 = _str_ProjectActivityLv2;
    _model_NewAddCost.ProjectActivityLv2Name = _str_ProjectActivityLv2Name;
    
    
    _model_NewAddCost.ExpenseDesc = _txv_ExpenseDesc.text;
    _model_NewAddCost.Remark = _txv_Remark.text;
    _model_NewAddCost.CityCode = _str_CityCode;
    _model_NewAddCost.CityName = _str_City;
    _model_NewAddCost.CityType = _str_CityType;
    _model_NewAddCost.MealType = _str_MealType;
    _model_NewAddCost.CheckInDate = _txf_CheckInDate.text;
    _model_NewAddCost.CheckOutDate = _txf_CheckOutDate.text;
    _model_NewAddCost.TotalDays = [_str_expenseCode_tag isEqualToString:@"Hotel"]?_txf_TotalDays.text:_txf_Day.text;
    _model_NewAddCost.HotelName = _txf_HotelName.text;
    _model_NewAddCost.Rooms = _txf_Rooms.text;
    _model_NewAddCost.MealsTotalDays = _txf_MealsTotalDays.text;
    _model_NewAddCost.TotalPeople = _txf_TotalPeople.text;//同行总人数
    _model_NewAddCost.HotelPrice = _txf_HotelPrice.text;
//    _model_NewAddCost.FellowOfficersId = _str_FellowOfficersId;
    _model_NewAddCost.FellowOfficers = _txf_FellowOfficers.text;
    _model_NewAddCost.FellowOfficersId = [NSString isEqualToNull:_str_FellowOfficersId]?_str_FellowOfficersId:(self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId);
//    _model_NewAddCost.FellowOfficers = [NSString isEqualToNull:_txf_FellowOfficers.text]?_txf_FellowOfficers.text(self.dict_parameter[@"Requestor"] ? self.dict_parameter[@"Requestor"]:self.userdatas.userDspName);
    _model_NewAddCost.Breakfast = _txf_Breakfast.text;
    _model_NewAddCost.Lunch = _txf_Lunch.text;
    _model_NewAddCost.Supper = _txf_Supper.text;
    _model_NewAddCost.Flight = _txf_Flight.text;
    _model_NewAddCost.CateringCo = _txf_CateringCo.text;
    _model_NewAddCost.FDCityName = _txf_FDCityName.text;
    _model_NewAddCost.FDCityCode = _str_FDCityCode;
    _model_NewAddCost.FDCityType = _str_FDCityType;
    _model_NewAddCost.FACityName = _txf_FACityName.text;
    _model_NewAddCost.FACityCode = _str_FACityCode;
    _model_NewAddCost.FACityType = _str_FACityType;
    if ([_txf_ClassName.text isEqualToString:Custing(@"经济舱", nil)]) {
        _model_NewAddCost.ClassName = @"1";
    }else if ([_txf_ClassName.text isEqualToString:Custing(@"商务舱", nil)]){
        _model_NewAddCost.ClassName = @"2";
    }else if ([_txf_ClassName.text isEqualToString:Custing(@"头等舱", nil)]){
        _model_NewAddCost.ClassName = @"3";
    }
    _model_NewAddCost.Discount = _txf_Discount.text;
    _model_NewAddCost.TDCityName = _txf_TDCityName.text;
    _model_NewAddCost.TACityName = _txf_TACityName.text;
    _model_NewAddCost.SeatName = _txf_SeatName.text;
    
    _model_NewAddCost.SDCityName = _txf_SDCityName.text;
    _model_NewAddCost.SACityName = _txf_SACityName.text;
    _model_NewAddCost.StartMeter = _txf_StartMeter.text;
    _model_NewAddCost.EndMeter = _txf_EndMeter.text;
    _model_NewAddCost.Mileage = _txf_Mileage.text;
    _model_NewAddCost.OilPrice = _txf_OilPrice.text;
    _model_NewAddCost.CarStd = _txf_CarStd.text;
    _model_NewAddCost.FuelBills = _txf_FuelBills.text;
    _model_NewAddCost.Pontage = _txf_Pontage.text;
    _model_NewAddCost.ParkingFee = _txf_ParkingFee.text;
    
    _model_NewAddCost.SDepartureTime = [NSString isEqualToNull:_txf_SDepartureTime.text] ? _txf_SDepartureTime.text:(id)[NSNull null];
    _model_NewAddCost.SArrivalTime = [NSString isEqualToNull:_txf_SArrivalTime.text] ? _txf_SArrivalTime.text:(id)[NSNull null];;
    
    
    if ([NSString isEqualToNull:_txf_Mileage.text]&&[NSString isEqualToNull:_txf_CarStd.text]) {
        if (![NSString isEqualToNull:_txf_FuelBills.text]) {
            _model_NewAddCost.FuelBills =[GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:_txf_CarStd.text] afterPoint:2];
        }
    }
    
    
    _model_NewAddCost.TransTypeId = _model_TransTypeId.Id;
    _model_NewAddCost.TransType = _model_TransTypeId.txf_TexfField.text;
    _model_NewAddCost.TransTotalDays = _txf_TransTotalDays.text;
    
    _model_NewAddCost.CrspFromDate = _model_CrspFromDate.Id;
    _model_NewAddCost.CrspToDate = _model_CrspFromDate.Value;
    
    
    _model_NewAddCost.ReceptionObject = _txf_ReceptionObject.text;
    _model_NewAddCost.ReceptionReason = _txf_ReceptionReason.text;
    _model_NewAddCost.ReceptionLocation = _txf_ReceptionLocation.text;
    _model_NewAddCost.Visitor = _txf_Visitor.text;
    _model_NewAddCost.VisitorDate = _txf_VisitorDate.text;
    _model_NewAddCost.LeaveDate = _txf_LeaveDate.text;
    _model_NewAddCost.ReceptionFellowOfficersId = _str_ReceptionFellowOfficerId;
    _model_NewAddCost.ReceptionFellowOfficers = _str_ReceptionFellowOfficers;
    _model_NewAddCost.ReceptionTotalPeople = _txf_ReceptionTotalPeople.text;
    _model_NewAddCost.ReceptionCateringCo = _txf_ReceptionCateringCo.text;
    
    _model_NewAddCost.ReplExpenseCode = _str_ReplExpenseCode;
    _model_NewAddCost.ReplExpenseType = _str_ReplExpenseType;
    
    
    _model_NewAddCost.CorpCarDCityName = _txf_CorpCarDCityName.text;
    _model_NewAddCost.CorpCarACityName = _txf_CorpCarACityName.text;
    _model_NewAddCost.CorpCarMileage = _txf_CorpCarMileage.text;
    _model_NewAddCost.CorpCarFuelBills = _txf_CorpCarFuelBills.text;
    _model_NewAddCost.CorpCarPontage = _txf_CorpCarPontage.text;
    _model_NewAddCost.CorpCarParkingFee = _txf_CorpCarParkingFee.text;
    _model_NewAddCost.CorpCarNo = _txf_CorpCarNo.text;
    _model_NewAddCost.CorpCarFromDate = _txf_CorpCarFromDate.text;
    _model_NewAddCost.CorpCarToDate = _txf_CorpCarToDate.text;
    
    
    _model_NewAddCost.TaxiDCityName = _txf_TaxiDCityName.text;
    _model_NewAddCost.TaxiACityName = _txf_TaxiACityName.text;
    _model_NewAddCost.TaxiFromDate = _txf_TaxiFromDate.text;
    _model_NewAddCost.TaxiToDate = _txf_TaxiToDate.text;
    
    
    _model_NewAddCost.AllowanceAmount = [_str_expenseCode_tag isEqualToString:@"Trans"]?_txf_AllowanceAmount.text:[self getEndMealAmout];
    
    _model_NewAddCost.AllowanceUnit = _txf_AllowanceUnit.text;
    _model_NewAddCost.OverStd = @"0";
    _model_NewAddCost.TransDCityName = _txf_TransDCityName.text;
    _model_NewAddCost.TransACityName = _txf_TransACityName.text;
    _model_NewAddCost.TransFromDate = _txf_TransFromDate.text;
    _model_NewAddCost.TransToDate = _txf_TransToDate.text;
    if ([NSString isEqualToNull:_str_expenseCode_tag]) {
        _model_NewAddCost.Tag = _str_expenseCode_tag;
    }
    _model_NewAddCost.AllowanceFromDate = [NSString isEqualToNull:_model_AllowanceFromDate.txf_TexfField.text]?_model_AllowanceFromDate.txf_TexfField.text:(id)[NSNull null];
    _model_NewAddCost.AllowanceToDate = [NSString isEqualToNull:_model_AllowanceToDate.txf_TexfField.text]?_model_AllowanceToDate.txf_TexfField.text:(id)[NSNull null];
    
    _model_NewAddCost.TravelUserId = [NSString stringWithIdOnNO:_model_TravelUserName.Id];
    _model_NewAddCost.TravelUserName = [NSString stringWithIdOnNO:_model_TravelUserName.Value];
    
    _model_NewAddCost.ClientId = _str_ClientId;
    _model_NewAddCost.ClientName = _txf_ClientId.text;
    _model_NewAddCost.Reserved1 = _model_rs.Reserverd1;
    _model_NewAddCost.Reserved2 = _model_rs.Reserverd2;
    _model_NewAddCost.Reserved3 = _model_rs.Reserverd3;
    _model_NewAddCost.Reserved4 = _model_rs.Reserverd4;
    _model_NewAddCost.Reserved5 = _model_rs.Reserverd5;
    _model_NewAddCost.Reserved6 = _model_rs.Reserverd6;
    _model_NewAddCost.Reserved7 = _model_rs.Reserverd7;
    _model_NewAddCost.Reserved8 = _model_rs.Reserverd8;
    _model_NewAddCost.Reserved9 = _model_rs.Reserverd9;
    _model_NewAddCost.Reserved10 = _model_rs.Reserverd10;
    
    _model_NewAddCost.OverStd2 = @"0";
    
    //驻办
    _model_NewAddCost.LocationId=_str_LocationId;
    _model_NewAddCost.Location=_txf_Location.text;
    _model_NewAddCost.OfficeFromDate=_txf_OfficeFromDate.text;
    _model_NewAddCost.OfficeToDate=_txf_OfficeToDate.text;
    _model_NewAddCost.OfficeTotalDays=_txf_OfficeTotalDays.text;
    //驻外
    _model_NewAddCost.BranchId=_str_BranchId;
    _model_NewAddCost.Branch=_txf_Branch.text;
    _model_NewAddCost.OverseasFromDate=_txf_OverseasFromDate.text;
    _model_NewAddCost.OverseasToDate=_txf_OverseasToDate.text;
    _model_NewAddCost.OverseasTotalDays=_txf_OverseasTotalDays.text;
    
    _model_NewAddCost.DataSource = self.dateSource;
    
    if ([_dic_route isKindOfClass:[NSDictionary class]]) {
        _model_NewAddCost.DriveCarId = _dic_route[@"driveCar"][@"id"];
    }
    if (_model_didi && [NSString isEqualToNullAndZero:_model_didi.order_id]) {
        _model_NewAddCost.DidiOrderId = _model_didi.order_id;
    }
//    费用分摊
    _model_NewAddCost.ShareId = (self.array_shareData.count > 0 && [NSString isEqualToNull:self.str_shareId]) ? self.str_shareId:@"0";
    _model_NewAddCost.ShareTotalAmt = self.str_shareTotal;
    _model_NewAddCost.ShareRatio = self.str_shareRatio;
    _model_NewAddCost.ExpenseShares = @"";
    if (self.array_shareData.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (AddReimShareModel *model in self.array_shareData) {
            NSMutableDictionary *modelsDic=[AddReimShareModel initDicByModel:model];
            [modelsDic setObject:@"1" forKey:@"ShareType"];
            [array addObject:modelsDic];
        }
        _model_NewAddCost.ExpenseShares = [NSString transformToJson:array];
    }
//    礼品费 ExpenseGiftDetail
    _model_NewAddCost.ExpenseGiftDetail = @"";
    if (self.arr_DetailsDataArray.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (GiftFeeDetail *model in self.arr_DetailsDataArray) {
            NSMutableDictionary *modelsDic = [GiftFeeDetail initDicByModel:model];
            [array addObject:modelsDic];
        }
        _model_NewAddCost.ExpenseGiftDetail = [NSString transformToJson:array];
    }
    
    _model_NewAddCost.OwnerUserId = self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId;
    _model_NewAddCost.UserId = self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId;
    _model_NewAddCost.AccountItemCode = self.str_accountItemCode;
    _model_NewAddCost.AccountItem = self.str_accountItem;
    
}


//验证数据
-(NSString *)verifyRequiredMessage{
    if ([NSString isEqualToNull:self.dateSource]&&([self.dateSource floatValue]==15||[self.dateSource floatValue]==16||[self.dateSource floatValue]==18)&&[[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:self.str_lastAmount] floatValue]>0) {
        return Custing(@"金额不能改大", nil);
    }
//    　判断礼品费总金额是否与提交金额一致
    if (self.arr_DetailsDataArray.count > 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"isShow = 1 && isRequired = 1"];
        NSArray *filterArray = [self.arr_DetailsArray filteredArrayUsingPredicate:pred];
        NSString *TotalMoney=@"";
        for (GiftFeeDetail *models in self.arr_DetailsDataArray) {
            for (MyProcurementModel *cellModel in filterArray) {
                if (([cellModel.fieldName isEqualToString:@"TCompanyName"]||[cellModel.fieldName isEqualToString:@"TRecipient"]||[cellModel.fieldName isEqualToString:@"GiftName"]||[cellModel.fieldName isEqualToString:@"Remark"]||[cellModel.fieldName isEqualToString:@"Amount"])&&![NSString isEqualToNull:[models valueForKey:cellModel.fieldName]]) {
                    return [NSString isEqualToNull:cellModel.tips]?cellModel.tips:[NSString stringWithFormat:@"%@%@",cellModel.fieldName,Custing(@"不能为空", nil)];
                }
            }
            TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
        }
        if ([_txf_Amount.text doubleValue] != [TotalMoney doubleValue]) {
            return Custing(@"礼品费明细金额之和必须与记一笔金额一致", nil);
        }
    }
    for (int i = 0; i<_muarr_MainView.count; i++) {
        MyProcurementModel *model = _muarr_MainView[i];
        if ([[NSString stringWithFormat:@"%@",model.isShow] isEqualToString:@"1"]&&[[NSString stringWithFormat:@"%@",model.isRequired] isEqualToString:@"1"]) {
            if ([model.fieldName isEqualToString:@"Amount"]&&![NSString isEqualToNull:_model_NewAddCost.Amount]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"CurrencyCode"]&&![NSString isEqualToNull:_model_NewAddCost.CurrencyCode]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ExchangeRate"]&&![NSString isEqualToNull:_model_NewAddCost.ExchangeRate]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]&&![NSString isEqualToNull:_model_NewAddCost.InvCyPmtExchangeRate]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Tax"]&&![NSString isEqualToNull:_model_NewAddCost.Tax]&&_view_Tax.zl_height>0) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"InvPmtTax"]&&![NSString isEqualToNull:_model_NewAddCost.InvPmtTax]&&_view_Tax.zl_height>0) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ExclTax"]&&![NSString isEqualToNull:_model_NewAddCost.ExclTax]&&_view_ExclTax.zl_height>0) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ClaimType"]&&![NSString isEqualToNull:[NSString stringWithFormat:@"%ld",(long)_model_NewAddCost.Type]]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ExpenseCode"]&&![NSString isEqualToNull:_model_NewAddCost.ExpenseCode]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ExpenseDate"]&&![NSString isEqualToNull:_model_NewAddCost.ExpenseDate]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"InvoiceType"]&&![NSString isEqualToNullAndZero:_model_NewAddCost.InvoiceTypeCode]&&_view_InvoiceType.zl_height > 0) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"InvoiceNo"]&&![NSString isEqualToNull:_model_NewAddCost.InvoiceNo]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ReplExpenseCode"]) {
                if ([self.str_HasInvoice isEqualToString:@"2"]&&![NSString isEqualToNull:_model_NewAddCost.ReplExpenseCode]) {
                    return [NSString stringWithFormat:@"%@",model.tips];
                }
            }else if ([model.fieldName isEqualToString:@"Attachments"]&&![NSString isEqualToNull:_model_NewAddCost.Attachments]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ExpenseDesc"]&&![NSString isEqualToNull:_model_NewAddCost.ExpenseDesc]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Nationality"]&&_model_Nationality.view_View.zl_height > 0 && ![NSString isEqualToNullAndZero:_model_NewAddCost.NationalityId]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"TransactionCode"]&&_model_TransactionCode.view_View.zl_height > 0 && ![NSString isEqualToNull:_model_NewAddCost.TransactionCodeId]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Files"]&&![NSString isEqualToNull:_model_NewAddCost.Files]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"CostCenterId"]&&![NSString isEqualToNull:_model_NewAddCost.CostCenterId]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ProjId"]&&![NSString isEqualToNull:_model_NewAddCost.ProjId]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ProjectActivityLv1Name"]&&![NSString isEqualToNullAndZero:_str_ProjectActivityLv1]) {
                return model.tips;
            }else if ([model.fieldName isEqualToString:@"Remark"]&&![NSString isEqualToNull:_model_NewAddCost.Remark]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"ClientId"]&&![NSString isEqualToNull:_model_NewAddCost.ClientId]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"InvoiceNo"]&&![NSString isEqualToNull:_model_NewAddCost.InvoiceNo]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved1"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved1]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved2"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved2]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved3"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved3]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved4"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved4]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved5"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved5]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved6"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved6]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved7"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved7]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved8"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved8]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved9"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved9]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }else if ([model.fieldName isEqualToString:@"Reserved10"]&&![NSString isEqualToNull:_model_NewAddCost.Reserved10]) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.Description];
            }
        }
        
        if ([model.fieldName isEqualToString:@"NoInvReason"]&&[model.isShow floatValue]==1) {
            if (([self.str_HasInvoice isEqualToString:@"0"]||[self.str_HasInvoice isEqualToString:@"2"])&&![NSString isEqualToNull:_model_NewAddCost.NoInvReason]&&_int_requiredReason==1) {
                return [NSString stringWithFormat:@"%@",model.tips];
            }
        }
        //控制发票类型选择附件控制项
        if ([model.fieldName isEqualToString:@"Attachments"] && [model.isShow floatValue] == 1 && _int_requiredAtt == 1 && ![NSString isEqualToNull:_model_NewAddCost.Attachments]) {
            if ([_dateSource integerValue] != 16 && [_dateSource integerValue] != 12) {
                return [NSString stringWithFormat:@"%@%@",Custing(@"添加", nil),model.Description];
            }
            
        }
    }
    
    if ([NSString isEqualToNullAndZero:self.str_CurrencyCode] && ![[NSString stringWithFormat:@"%@",self.str_CurrencyCode]isEqualToString:@"CNY"] && ([self.str_InvoiceTypeCode isEqualToString:@"1003"]||[self.str_InvoiceTypeCode isEqualToString:@"1004"]||[self.str_InvoiceTypeCode isEqualToString:@"1005"])) {
        return Custing(@"币种不是人民币，发票类型不能为铁路车票、航空行程单、公路、水路客票", nil);
    }
    
    if ([self.str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
        if (_View_AirTicketPrice.zl_height > 0 && ![NSString isEqualToNull:self.model_NewAddCost.AirTicketPrice]) {
            return Custing(@"请输入票价", nil);
        }else if (_View_DevelopmentFund.zl_height > 0 && ![NSString isEqualToNull:self.model_NewAddCost.DevelopmentFund]){
            return Custing(@"请输入民航发展基金", nil);
        }else if (_View_FuelSurcharge.zl_height > 0 && ![NSString isEqualToNull:self.model_NewAddCost.FuelSurcharge]){
            return Custing(@"请输入燃油附加费", nil);
        }else if (_View_OtherTaxes.zl_height > 0 && ![NSString isEqualToNull:self.model_NewAddCost.OtherTaxes]){
            return Custing(@"请输入其他税费", nil);
        }else{
            if (_View_AirTicketPrice.zl_height > 0 || _View_DevelopmentFund.zl_height > 0 || _View_FuelSurcharge.zl_height > 0 || _View_OtherTaxes.zl_height > 0) {
                NSString *amount = [GPUtils decimalNumberSubWithString:self.txf_Amount.text with:self.model_NewAddCost.AirTicketPrice];
                amount = [GPUtils decimalNumberSubWithString:amount with:self.model_NewAddCost.DevelopmentFund];
                amount = [GPUtils decimalNumberSubWithString:amount with:self.model_NewAddCost.FuelSurcharge];
                amount = [GPUtils decimalNumberSubWithString:amount with:self.model_NewAddCost.OtherTaxes];
                if ([amount floatValue] != 0) {
                    return Custing(@"票价、民航发展基金、燃油附加费、其他税费之和必须与金额一致", nil);
                }
            }
        }
    }
    
    if ([_str_expenseCode_tag isEqualToString:@"Hotel"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"hotelFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"hotelFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"CityCode"]&&![NSString isEqualToNull:_model_NewAddCost.CityCode]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TotalDays"]&&![NSString isEqualToNull:_model_NewAddCost.TotalDays]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }
                    //                    else if ([dic[@"fieldName"] isEqualToString:@"HotelPrice"]&&![NSString isEqualToNull:_model_NewAddCost.HotelPrice]) {
                    //                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    //                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]) {
        NSMutableArray *arr_Expense_temporary = [_dic_request[@"result"][@"flightFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"flightFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"FDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.FDCityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"FACityName"]&&![NSString isEqualToNull:_model_NewAddCost.FACityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ClassName"]&&![NSString isEqualToNull:_model_NewAddCost.ClassName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Discount"]&&![NSString isEqualToNull:_model_NewAddCost.Discount]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Train"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"trainFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"trainFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"TDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.TDCityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TACityName"]&&![NSString isEqualToNull:_model_NewAddCost.TACityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"SeatName"]&&![NSString isEqualToNull:_model_NewAddCost.SeatName]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"mealsFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"mealsFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"FellowOfficersId"]&&![NSString isEqualToNull:_model_NewAddCost.FellowOfficersId]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"MealsTotalDays"]&&![NSString isEqualToNull:_model_NewAddCost.MealsTotalDays]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Breakfast"]&&![NSString isEqualToNull:_model_NewAddCost.Breakfast]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Lunch"]&&![NSString isEqualToNull:_model_NewAddCost.Lunch]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Supper"]&&![NSString isEqualToNull:_model_NewAddCost.Supper]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"selfDriveFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"selfDriveFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"SDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.SDCityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"SACityName"]&&![NSString isEqualToNull:_model_NewAddCost.SACityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Mileage"]&&![NSString isEqualToNull:_model_NewAddCost.Mileage]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CarStd"]&&![NSString isEqualToNull:_model_NewAddCost.CarStd]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"FuelBills"]&&![NSString isEqualToNull:_model_NewAddCost.FuelBills]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Pontage"]&&![NSString isEqualToNull:_model_NewAddCost.Pontage]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ParkingFee"]&&![NSString isEqualToNull:_model_NewAddCost.ParkingFee]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"StartMeter"]&&![NSString isEqualToNull:_model_NewAddCost.StartMeter]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"EndMeter"]&&![NSString isEqualToNull:_model_NewAddCost.EndMeter]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Hospitality"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"hospitality"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"hospitality"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"ReceptionObject"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionObject]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ReceptionReason"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionReason]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ReceptionLocation"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionLocation]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"Visitor"]&&![NSString isEqualToNull:_model_NewAddCost.Visitor]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"VisitorDate"]&&![NSString isEqualToNull:_model_NewAddCost.VisitorDate]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"LeaveDate"]&&![NSString isEqualToNull:_model_NewAddCost.LeaveDate]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ReceptionFellowOfficersId"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionFellowOfficersId]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ReceptionTotalPeople"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionTotalPeople]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"ReceptionCateringCo"]&&![NSString isEqualToNull:_model_NewAddCost.ReceptionCateringCo]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }
                }
            }
            if ([NSString isEqualToNullAndZero:_model_NewAddCost.VisitorDate]&&[NSString isEqualToNullAndZero:_model_NewAddCost.LeaveDate]) {
                
                NSDate *date1 =[GPUtils TimeStringTranFromData:_model_NewAddCost.LeaveDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:_model_NewAddCost.VisitorDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0){
                    return Custing(@"来访时间不能大于等于离开时间", nil) ;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"CorpCar"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"corpCar"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"corpCar"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"CorpCarDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarDCityName]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarACityName"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarACityName]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarMileage"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarMileage]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarFuelBills"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarFuelBills]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarPontage"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarPontage]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarParkingFee"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarParkingFee]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarNo"]&&![NSString isEqualToNull:_model_NewAddCost.CorpCarNo]) {
                        return [NSString stringWithIdOnNO:dic[@"tips"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"CorpCarFromDate"]) {
                        if (![NSString isEqualToNull:_model_NewAddCost.CorpCarFromDate]) {
                            return Custing(@"请选择开始时间", nil);
                        }else if (![NSString isEqualToNull:_model_NewAddCost.CorpCarToDate]){
                            return Custing(@"请选择结束时间", nil);
                        }
                    }
                }
            }
            if ([NSString isEqualToNullAndZero:_model_NewAddCost.CorpCarToDate]&&[NSString isEqualToNullAndZero:_model_NewAddCost.CorpCarFromDate]) {
                
                NSDate *date1 =[GPUtils TimeStringTranFromData:_model_NewAddCost.CorpCarToDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:_model_NewAddCost.CorpCarFromDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0){
                    return Custing(@"开始时间不能大于等于结束时间", nil) ;
                }
            }
        }
        
    }else if ([_str_expenseCode_tag isEqualToString:@"Taxi"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"taxi"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"taxi"]:[NSArray array];
        for (NSDictionary *dic in arr_Expense_temporary) {
            if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                if ([dic[@"fieldName"] isEqualToString:@"TaxiDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.TaxiDCityName]) {
                    return [NSString stringWithIdOnNO:dic[@"tips"]];
                }else if ([dic[@"fieldName"] isEqualToString:@"TaxiACityName"]&&![NSString isEqualToNull:_model_NewAddCost.TaxiACityName]) {
                    return [NSString stringWithIdOnNO:dic[@"tips"]];
                }else if ([dic[@"fieldName"] isEqualToString:@"TaxiFromDate"]&&![NSString isEqualToNull:_model_NewAddCost.TaxiFromDate]) {
                    return [NSString stringWithIdOnNO:dic[@"tips"]];//Custing(@"请选择开始时间", nil)
                }else if ([dic[@"fieldName"] isEqualToString:@"TaxiToDate"]&&![NSString isEqualToNull:_model_NewAddCost.TaxiToDate]) {
                    return [NSString stringWithIdOnNO:dic[@"tips"]];//Custing(@"请选择结束时间", nil)
                }
            }
        }
        if ([NSString isEqualToNullAndZero:_model_NewAddCost.TaxiFromDate]) {
            if ([NSString isEqualToNullAndZero:_model_NewAddCost.TaxiToDate]) {
                NSDate *date1 =[GPUtils TimeStringTranFromData:_model_NewAddCost.TaxiToDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                NSDate *date2 =[GPUtils TimeStringTranFromData:_model_NewAddCost.TaxiFromDate WithTimeFormart:@"yyyy/MM/dd HH:mm"];
                if ([date2 timeIntervalSinceDate:date1]>=0.0){
                    return Custing(@"出发时间不能大于等于到达时间", nil) ;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]) {
        if (_arr_Allowance_Main.count>0) {
            for (int i = 0; i<_arr_Allowance_Main.count; i++) {
                NSDictionary *dic = _arr_Allowance_Main[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([_str_Unit isEqualToString:@"天"]||[_str_Unit isEqualToString:@"月"]||[_str_Unit isEqualToString:@"年"]){
                        if ([dic[@"fieldName"] isEqualToString:@"City"]&&![NSString isEqualToNull:_model_NewAddCost.CityName]&&[_str_Basis integerValue]!=1) {
                            return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),dic[@"description"]];
                        }
                        if ([dic[@"fieldName"] isEqualToString:@"TotalDays"]&&![NSString isEqualToNull:_model_NewAddCost.TotalDays]&&[_str_Basis integerValue]!=1) {
                            return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                        }
                        if ([dic[@"fieldName"] isEqualToString:@"AllowanceFromDate"]&&![NSString isEqualToNull:_model_NewAddCost.AllowanceFromDate]&&[_str_Basis integerValue]!=1) {
                            return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),dic[@"Description"]];
                        }
                        if ([dic[@"fieldName"] isEqualToString:@"AllowanceToDate"]&&![NSString isEqualToNull:_model_NewAddCost.AllowanceToDate]&&[_str_Basis integerValue]!=1) {
                            return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),dic[@"Description"]];
                        }
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Trans"]) {
        NSArray *arr_Expense_temporary = [_dic_request[@"result"][@"transFields"] isKindOfClass:[NSArray class]]?_dic_request[@"result"][@"trainFields"]:[NSArray array];
        if (arr_Expense_temporary.count>0) {
            for (int i = 0; i<arr_Expense_temporary.count; i++) {
                NSDictionary *dic = arr_Expense_temporary[i];
                if ([dic[@"isShow"]integerValue]==1&&[dic[@"isRequired"]integerValue]==1) {
                    if ([dic[@"fieldName"] isEqualToString:@"TransDCityName"]&&![NSString isEqualToNull:_model_NewAddCost.TransDCityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TransACityName"]&&![NSString isEqualToNull:_model_NewAddCost.TransACityName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TransFromDate"]&&![NSString isEqualToNull:_model_NewAddCost.TransFromDate]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TransToDate"]&&![NSString isEqualToNull:_model_NewAddCost.TransToDate]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }else if ([dic[@"fieldName"] isEqualToString:@"TransTotalDays"]&&![NSString isEqualToNull:_model_NewAddCost.SeatName]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),dic[@"description"]];
                    }
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Office"]) {
        if (![NSString isEqualToNullAndZero:self.str_LocationId]) {
            return Custing(@"请选择办事处", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OfficeFromDate.text]){
            return Custing(@"请选择开始时间", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OfficeToDate.text]){
            return Custing(@"请选择结束时间", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OfficeTotalDays.text]){
            return Custing(@"请输入天数", nil);
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Overseas"]) {
        if (![NSString isEqualToNullAndZero:self.str_BranchId]) {
            return Custing(@"请选择公司", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OverseasFromDate.text]){
            return Custing(@"请选择开始时间", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OverseasToDate.text]){
            return Custing(@"请选择结束时间", nil);
        }else if (![NSString isEqualToNullAndZero:self.txf_OverseasTotalDays.text]){
            return Custing(@"请输入天数", nil);
        }
    }
    
    
    if (self.bool_shareShow && self.array_shareData.count > 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"isShow = 1 && isRequired = 1"];
        NSArray *filterArray = [self.array_shareForm filteredArrayUsingPredicate:pred];
        for (AddReimShareModel *data in self.array_shareData) {
            for (MyProcurementModel *model in filterArray) {
                if (([model.fieldName isEqualToString:@"BranchId"]||[model.fieldName isEqualToString:@"RequestorDeptId"]||[model.fieldName isEqualToString:@"RequestorBusDeptId"]||[model.fieldName isEqualToString:@"CostCenterId"]||[model.fieldName isEqualToString:@"ProjId"])&&(![NSString isEqualToNullAndZero:[data valueForKey:model.fieldName]])) {
                    return [NSString isEqualToNull:model.tips] ? model.tips:[NSString stringWithFormat:@"%@%@",model.fieldName,Custing(@"不能为空", nil)];
                }else if (([model.fieldName isEqualToString:@"Reserved1"]||[model.fieldName isEqualToString:@"Reserved2"]||[model.fieldName isEqualToString:@"Reserved3"]||[model.fieldName isEqualToString:@"Reserved4"]||[model.fieldName isEqualToString:@"Reserved5"])&&(![NSString isEqualToNull:[data valueForKey:model.fieldName]])){
                    if ([model.ctrlTyp isEqualToString:@"text"]) {
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请输入", nil),model.fieldName];
                    }else{
                        return [NSString stringWithFormat:@"%@%@",Custing(@"请选择", nil),model.fieldName];
                    }
                }else if (([model.fieldName isEqualToString:@"ShareRatio"]||[model.fieldName isEqualToString:@"Amount"]||[model.fieldName isEqualToString:@"Remark"])&&(![NSString isEqualToNull:[data valueForKey:model.fieldName]])){
                    return [NSString isEqualToNull:model.tips] ? model.tips:[NSString stringWithFormat:@"%@%@",model.fieldName,Custing(@"不能为空", nil)];
                }
                break;
            }
        }
    }
    return nil;
}
-(void)JudgeStd{
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
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    NSString *approval = [self getStandardAmountWithKey:@"approval"];
                    if (approval&&[approval floatValue]>100) {
                        NSString *str = [GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:([GPUtils decimalNumberMultipWithString:[GPUtils decimalNumberMultipWithString:_txf_TotalDays.text with:standardAmount] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"])];
                        str = [GPUtils decimalNumberMultipWithString:str with:@"100"];
                        str = [GPUtils decimalNumberSubWithString:str with:[NSString stringWithFormat:@"%@",approval]];
                        if ([str floatValue]>0) {
                            _model_NewAddCost.OverStd2= str;
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
                    return;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]){
        
        if ([NSString isEqualToNull:_txf_Discount.text]&&![_txf_Discount.text isEqualToString:@"0"]) {
            NSString *discount=[self getStandardAmountWithKey:@"discount"];
            if ([NSString isEqualToNullAndZero:discount]) {
                NSString *loan=[GPUtils decimalNumberSubWithString:_txf_Discount.text with:discount];
                if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                    _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
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
                    return;
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
                    return;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Train"]){
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
                return;
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
        NSString *amount1=[self getStandardAmountWithKey:@"amount"];
        NSString *amount2=[self getStandardAmountWithKey:@"amount2"];
        NSString *amount3=[self getStandardAmountWithKey:@"amount3"];
        if (amount1||amount2||amount3) {
            NSString *tolAmount = [GPUtils decimalNumberAddWithString:[GPUtils decimalNumberAddWithString:amount1 with:amount2] with:amount3];
            tolAmount = [GPUtils decimalNumberMultipWithString:tolAmount with:([NSString isEqualToNullAndZero:self.txf_TotalPeople.text]?self.txf_TotalPeople.text:@"1")];
            tolAmount = [GPUtils decimalNumberMultipWithString:tolAmount with:([NSString isEqualToNullAndZero:self.txf_MealsTotalDays.text]?self.txf_MealsTotalDays.text:@"1")];
            NSString *loan = [GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:tolAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                NSString *approval = [self getStandardAmountWithKey:@"approval"];
                if (approval&&[approval floatValue]>100) {
                    NSString *str = [GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:tolAmount];
                    str = [GPUtils decimalNumberMultipWithString:str with:@"100"];
                    str = [GPUtils decimalNumberSubWithString:str with:[NSString stringWithFormat:@"%@",approval]];
                    if ([str floatValue]>0) {
                        _model_NewAddCost.OverStd2= str;
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
                return;
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]) {
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
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
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
                    return;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Taxi"]) {
        if (self.dict_Standard&&[self.dict_Standard[@"stdTaxis"]isKindOfClass:[NSArray class]]) {
            NSArray *stdTaxis = self.dict_Standard[@"stdTaxis"];
            if (stdTaxis.count>0) {
                for (NSDictionary *dicts in stdTaxis) {
                    if ([dicts[@"isLimit"]floatValue]==1&&_model_NewAddCost.TaxiFromDate&&_model_NewAddCost.TaxiFromDate.length > 11) {
                        NSDate *date1 =[GPUtils TimeStringTranFromData:dicts[@"toTime"] WithTimeFormart:@"HH:mm"];
                        NSDate *date2 =[GPUtils TimeStringTranFromData:dicts[@"fromTime"] WithTimeFormart:@"HH:mm"];
                        NSDate *date3 =[GPUtils TimeStringTranFromData:([_model_NewAddCost.TaxiFromDate substringFromIndex:11]) WithTimeFormart:@"HH:mm"];
                        if ([date2 timeIntervalSinceDate:date1]>=0.0){
                            if ([date3 timeIntervalSinceDate:date2]>0||[date1 timeIntervalSinceDate:date3]>0) {
                                goto when_failed;
                                break;
                            }
                        }else{
                            if ([date3 timeIntervalSinceDate:date2]>0&&[date1 timeIntervalSinceDate:date3]>0) {
                                goto when_failed;
                                break;
                            }
                        }
                    }else{
                        goto when_failed;
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
                _model_NewAddCost.OverStd = @"1";
                return;
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]) {
        //        ![_str_Unit isEqualToString:@"天"]&&
        if (![NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)self.Id]]&&[[NSString stringWithFormat:@"%@",[self getStandardAmountWithKey:@"isExpense"]]isEqualToString:@"0"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前单据已经报销", nil) duration:1.5];
            _view_DockView.userInteractionEnabled=YES;
            return;
        }
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
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
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
                    return;
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
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                    
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
                    return;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Other"]) {
        if (![_str_Unit isEqualToString:@"天"]&&[_str_lastExpenseDate isEqualToString:_txf_ExpenseDate.text]&&[_str_lastExpenseCode isEqualToString:_str_expenseCode]&&[NSString isEqualToNull:_str_lastExpenseDate]&&[NSString isEqualToNull:_str_lastExpenseCode]) {
            if (![NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)self.Id]]&&[_str_IsExpensed isEqualToString:@"0"]) {
                [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前单据已经报销", nil) duration:1.5];
                _view_DockView.userInteractionEnabled=YES;
                return;
            }
        }
        NSString *standardAmount = [self getStandardAmountWithKey:@"amount"];
        if (standardAmount) {
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:standardAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
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
                return;
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
                    _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
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
                    return;
                }
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Office"]) {
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[[self getStandardAmountWithKey:@"unit"]isEqualToString:@"天"]&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:([NSString isEqualToNullAndZero:_txf_OfficeTotalDays.text]?_txf_OfficeTotalDays.text:@"1") with:standardAmount]];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻办津贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻办津贴标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,请重新填写", nil)] duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return ;
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Overseas"]){
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[[self getStandardAmountWithKey:@"unit"]isEqualToString:@"天"]&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:[GPUtils decimalNumberMultipWithString:([NSString isEqualToNullAndZero:_txf_OverseasTotalDays.text]?_txf_OverseasTotalDays.text:@"1") with:standardAmount]];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻外补助标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"驻外补助标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元/天,请重新填写", nil)] duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return ;
            }
        }
    }else if ([_str_expenseCode_tag isEqualToString:@"Mobile"]){
        if (![NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)self.Id]]&&[_str_IsExpensed isEqualToString:@"0"]) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"当前单据已经报销", nil) duration:1.0];
            _view_DockView.userInteractionEnabled=YES;
            return;
        }
        if ([[self getStandardAmountWithKey:@"status"]floatValue]!=0&&[self getStandardAmountWithKey:@"amount"]) {
            NSString *standardAmount=[self getStandardAmountWithKey:@"amount"];;
            NSString *loan=[GPUtils decimalNumberSubWithString:[self getLocalCyAmount] with:standardAmount];
            if ([self compareAmountWithStr:loan withSecStr:@"0.005"]) {
                _model_NewAddCost.OverStd = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                _model_NewAddCost.OverStdAmt = [GPUtils getRoundingOffNumber:loan afterPoint:2];
                if ([[self getStandardAmountWithKey:@"limitMode"] isEqualToString:@"1"]) {
                    _alt_Warring = [[UIAlertView alloc]initWithTitle:Custing(@"超标准", nil)
                                                             message:[NSString stringWithFormat:@"%@ %@%@",Custing(@"通讯费标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,是否提交?", nil)]
                                                            delegate:self
                                                   cancelButtonTitle:Custing(@"取消", nil)
                                                   otherButtonTitles:Custing(@"确定", nil),nil];
                    [_alt_Warring  show];
                }else{
                    [[GPAlertView sharedAlertView]showAlertText:self WithText:[NSString stringWithFormat:@"%@ %@%@",Custing(@"通讯费标准，超出", nil),_model_NewAddCost.OverStd,Custing(@"元,请重新填写", nil)] duration:1.5];
                    _view_DockView.userInteractionEnabled=YES;
                }
                return ;
            }
        }
    }
when_failed:
    [self requestCheckInvoiceNo];
}

-(void)cleanData{
    _str_expenseIcon = @"";
    _str_CityCode = @"";
    _txf_CityName.text = @"";
    _str_CityType = @"";
    _txf_TotalDays.text = @"";
    _txf_HotelPrice.text = @"";
    _dic_CityCode = [NSDictionary dictionary];
    _str_FellowOfficersId = @"";
    _arr_FellowOfficersId = [NSMutableArray array];
    _txf_FellowOfficers.text = @"";
    _txf_Breakfast.text = @"";
    _txf_Lunch.text = @"";
    _txf_Supper.text = @"";
    _txf_CateringCo.text = @"";
    _txf_Flight.text = @"";
    _txf_FDCityName.text = @"";
    _txf_FACityName.text = @"";
    _txf_ClassName.text = @"";
    _txf_Discount.text = @"";
    _txf_TransDCityName.text = @"";
    _txf_TransACityName.text = @"";
    _txf_TransFromDate.text = @"";
    _txf_TransToDate.text = @"";
    _pic_Flight = nil;
    _str_Flight = @"";
    _txf_TDCityName.text = @"";
    _txf_TACityName.text = @"";
    _txf_SeatName.text = @"";
    _txf_SDCityName.text = @"";
    _txf_SACityName.text = @"";
    _txf_Mileage.text = @"";
    _txf_CarStd.text = @"";
    _txf_FuelBills.text = @"";
    _txf_Pontage.text = @"";
    _txf_ParkingFee.text = @"";
    _txf_StartMeter.text=@"";
    _txf_EndMeter.text=@"";
    _txf_AllowanceAmount.text = @"";
    _txf_AllowanceUnit.text = @"";
    _txf_OverStd.text = @"";
    _txf_Tag.text = @"";
    _str_Status = @"";
    _str_Amount = @"";
    _str_Amount2 = @"";
    _str_Amount3 = @"";
    _str_Basis = @"";
    _str_Unit = @"";
    _str_Class = @"";
    _str_Discount = @"";
    _str_IsExpensed = @"";
    _str_LimitMode = @"";
    _dic_stdOutput = [NSDictionary dictionary];
    _str_MealAmount = @"";
    _str_MealAmount1 = @"";
    _str_AllowanceCurrency = @"";
    _str_AllowanceCurrencyCode = @"";
    _str_AllowanceCurrencyRate = @"";
    _arr_stdSelfDriveDtoList = [NSArray array];
    _str_RequestUserId = @"";
    _str_MedicalAmount = @"";
    
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

#pragma mark 网络请求
//获取页面数据
-(void)requestExpuserGetFormData{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",expuser_GetFormData];
    NSDictionary *parameters = @{@"Action":[NSString stringWithFormat:@"%ld",(long)((long)_Action == 4?2:_Action)],
                                 @"Type":[NSString stringWithFormat:@"%ld",(long)_Type],
                                 @"Id":[NSString stringWithFormat:@"%ld",(long)_Id],
                                 @"UserId":self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId,
                                 @"ProcId":self.dict_parameter[@"ProcId"] ? self.dict_parameter[@"ProcId"]:@"",
                                 @"FlowGuid":self.dict_parameter[@"FlowGuid"] ? self.dict_parameter[@"FlowGuid"]:@""
    };
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:0 IfUserCache:NO];
}

// 获取费用类别选择中的类别
-(void)requestGetTyps{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters=@{@"Type":_str_ClaimType,@"CostCenterId":_str_CostCenterId};
    NSString *url=[NSString stringWithFormat:@"%@",GetAddCostNewCategry];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:1 IfUserCache:NO];
}

// 获取费用标准 
-(void)requestGetExpStd{
    //    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_txf_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequestUserId,
                                 @"LocationId":_str_LocationId,
                                 @"BranchId":_str_BranchId,
                                 @"CheckInDate":[NSString stringWithIdOnNO:_txf_CheckInDate.text],
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_model_AllowanceFromDate.txf_TexfField.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_model_AllowanceToDate.txf_TexfField.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_model_TravelUserName.Id],
                                 @"UserId":self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId,
                                 @"Id":[NSString stringWithFormat:@"%ld",(long)_Id],
    };
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:2 IfUserCache:NO];
}
-(void)requestGetExpStdAddFirst{
    //    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSDictionary *parameters = @{@"ExpenseCode":_str_expenseCode,
                                 @"ExpenseDate":_txf_ExpenseDate.text,
                                 @"Tag":[_str_expenseCode_tag isEqualToString:@"Correspondence"]?@"Mobile":_str_expenseCode_tag,
                                 @"CityCode":_str_CityCode,
                                 @"CityType":_str_CityType,
                                 @"RequestUserId":_str_RequestUserId,
                                 @"LocationId":_str_LocationId,
                                 @"BranchId":_str_BranchId,
                                 @"CheckInDate":[NSString stringWithIdOnNO:_txf_CheckInDate.text],
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_model_AllowanceFromDate.txf_TexfField.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_model_AllowanceToDate.txf_TexfField.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_model_TravelUserName.Id],
                                 @"UserId":self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId,
                                 @"Id":[NSString stringWithFormat:@"%ld",(long)_Id],
    };
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:20 IfUserCache:NO];
}
//保存数据
-(void)requestAddCostList{
    if (self.model_didi && ![NSString isEqualToNullAndZero:self.model_didi.order_id]) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存失败", nil) duration:1.0];
        self.view_DockView.userInteractionEnabled = YES;
        return;
    }
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",_Action == 2 ? addRequestEditCostList:addRequestAddCostList];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:_model_NewAddCost]];
    if (_Action == 2) {
        [parameters setValue:[NSNumber numberWithInteger:_Id] forKey:@"Id"];
        [parameters setValue:[NSNumber numberWithInteger:_before_Type] forKey:@"BeforeType"];
    }
    if (![NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)_Id]] && ([_dateSource integerValue]==9||[_dateSource integerValue]==10||[_dateSource integerValue]==12)) {
        [parameters setValue:_dateSource forKey:@"DataSource"];
        url = [NSString stringWithFormat:@"%@",LeadHotelCuston];
        if (_Action != 2) {
            [parameters setValue:_model_addDetail.OrderId forKey:@"OrderId"];
        }
    }
    if ([_dateSource integerValue] == 13) {
        [parameters setValue:_model_route.Id forKey:@"DriveCarId"];
        [parameters setValue:_dateSource forKey:@"DataSource"];
    }
    if ([_dateSource integerValue] == 14) {
        if (_model_didi && [NSString isEqualToNullAndZero:_model_didi.order_id]) {
            [parameters setValue:_model_didi.order_id forKey:@"DidiOrderId"];
        }
        [parameters setValue:_dateSource forKey:@"DataSource"];
    }
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:3 IfUserCache:NO];
}

-(void)requestCheckInvoiceNo{
    if (_Action != 2&&[NSString isEqualToNull:_txf_InvoiceNo.text]) {
        [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
        NSString *url=[NSString stringWithFormat:@"%@",CheckInvoiceNo];
        NSDictionary *parameters = @{@"Type":_str_ClaimType,@"Id":[NSNumber numberWithInteger:_Id],@"InvoiceNo":_txf_InvoiceNo!=nil?_txf_InvoiceNo.text:@""};
        [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:13 IfUserCache:NO];
    }else{
        [self requestAddCostList];
    }
}

//获取住宿类型
-(void)requestExpuserGetStdType{
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    NSString *url=[NSString stringWithFormat:@"%@",expuserGetStdType];
    NSDictionary *parameters = @{@"ExpenseCode":@"",@"Tag":[NSNumber numberWithInteger:_Id],@"UserId":self.dict_parameter[@"UserId"] ? self.dict_parameter[@"UserId"]:self.userdatas.userId};
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:14 IfUserCache:NO];
}

//处理图片请求
-(void)requestUploader{
    __weak typeof(self) weakSelf = self;
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:_totalArray WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.view_DockView.userInteractionEnabled = YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.str_imageDataString=data;
            [weakSelf requestFilesUploader];
        }
    }];
}

-(void)requestFilesUploader{
    __weak typeof(self) weakSelf = self;
    [[VoiceDataManger sharedManager]uploadImageDataWithImgSoure:_arr_FilesTotal WithUrl:travelImgLoad WithBlock:^(id data, BOOL hasError) {
        [YXSpritesLoadingView dismiss];
        if (hasError) {
            weakSelf.view_DockView.userInteractionEnabled = YES;
            [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText: data duration:2.0];
        }else{
            weakSelf.model_Files.Value= data;
            [weakSelf jointResponse];
            NSString *str_message = [weakSelf verifyRequiredMessage];
            if ([NSString isEqualToNull:str_message]) {
                [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:str_message duration:2.0];
                weakSelf.view_DockView.userInteractionEnabled = YES;
                return;
            }
            if ([weakSelf.str_expenseCode_tag isEqualToString:@"Hotel"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Flight"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Train"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Meals"]||[weakSelf.str_expenseCode_tag isEqualToString:@"SelfDrive"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Allowance"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Other"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Medical"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Office"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Overseas"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Mobile"]||[weakSelf.str_expenseCode_tag isEqualToString:@"Taxi"]) {
                [weakSelf requestGetSubmitExpStd];
            }else{
                [weakSelf requestCheckInvoiceNo];
            }
        }
    }];
}
// 请求被管控的发票类别
- (void)checkInvoiceTypeGetInvPolicy{
    if (![NSString isEqualToNull:self.dateSource]||[self.dateSource integerValue] == 0 || [self.dateSource integerValue] == 1) {
    [YXSpritesLoadingView showWithText:Custing(@"光速加载中...",nil) andShimmering:NO andBlurEffect:NO];
      NSString *url=[NSString stringWithFormat:@"%@",GetInvPolicy];
      [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:nil Delegate:self SerialNum:25 IfUserCache:NO];
    }else{
    [self requestUploader];
    }
}
#pragma mark - action
-(void)btn_Click:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    [self keyClose];
    //保存
    if (btn.tag == 0) {
        _view_DockView.userInteractionEnabled = NO;
//        先查验发票类型是否在管控清单中
        [self checkInvoiceTypeGetInvPolicy];
//        [self requestUploader];
    }
    //在记一笔
    if (btn.tag == 1) {
        _view_DockView.userInteractionEnabled = NO;
        _int_load = 1;
//        先查验发票类型是否在管控清单中
        [self checkInvoiceTypeGetInvPolicy];
//        [self requestUploader];
    }
    //币种
    if (btn.tag == 2) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        __weak typeof(self) weakSelf = self;
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_CurrencyCode=Model.Id;
            weakSelf.str_Currency=Model.Type;
            weakSelf.txf_CurrencyCode.text=Model.Type;
            weakSelf.txf_ExchangeRate.text=Model.exchangeRate;
            weakSelf.str_ExchangeRate = Model.exchangeRate;
            weakSelf.txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:weakSelf.str_ExchangeRate]];
            weakSelf.str_InvCyPmtExchangeRate = Model.exchangeRate;
            weakSelf.txf_InvCyPmtExchangeRate.text = Model.exchangeRate;
            
            NSString *airLoc = [weakSelf getLocalCyAmount];
            NSString *payLoc = [GPUtils decimalNumberMultipWithString:weakSelf.txf_Amount.text with:([NSString isEqualToNull:weakSelf.str_InvCyPmtExchangeRate] ? weakSelf.str_InvCyPmtExchangeRate:@"1.0000")];
            NSString *airLoc1 = payLoc;
            if ([weakSelf.str_InvoiceType floatValue] == 1 && [self.str_InvoiceTypeCode isEqualToString:@"1004"] && [NSDate intervalSinceReferenceDate_double:[NSDate dateWithstring:[NSDate dateWithstringBySemicolon:self.txf_ExpenseDate.text]] localeDate:[NSDate dateWithstring:@"2019-04-01"]] > 0) {
                airLoc = [GPUtils decimalNumberSubWithString:airLoc with:[GPUtils decimalNumberSubWithString:airLoc with:weakSelf.txf_AirlineFuelFee.text]];
                airLoc1 = [GPUtils decimalNumberSubWithString:airLoc1 with:[GPUtils decimalNumberSubWithString:airLoc1 with:weakSelf.txf_AirlineFuelFee.text]];
            }
            weakSelf.txf_Tax.text = [NSString countTax:airLoc taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_ExclTax.text = [GPUtils decimalNumberSubWithString:[weakSelf getLocalCyAmount] with:weakSelf.txf_Tax.text];
            
            weakSelf.txf_InvPmtTax.text = [NSString countTax:airLoc1 taxrate:weakSelf.txf_TaxRate.text];
            weakSelf.txf_InvPmtAmountExclTax.text = [GPUtils decimalNumberSubWithString:payLoc with:weakSelf.txf_InvPmtTax.text];
            
            [weakSelf AmountChangeAgainWithNewString:nil WithType:3];
        }];
        picker.typeTitle=Custing(@"币种", nil);
        picker.DateSourceArray=[NSMutableArray arrayWithArray:_muarr_CurrencyCode];
        STOnePickModel *model=[[STOnePickModel alloc]init];
        model.Id=[NSString isEqualToNull: _str_CurrencyCode]?_str_CurrencyCode:@"";
        picker.Model=model;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }
    
    //费用类别
    if (btn.tag == 4) {
        if (_muarr_ExpenseCode.count==0) {
            [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"没相关费用类别", nil) duration:1.0];
            return;
        }
        if ([_str_ExpenseCode_level isEqualToString:@"1"]) {
            [self updateCateGoryView];
        }else if ([_str_ExpenseCode_level isEqualToString:@"2"]){
            STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
            self.int_ReplClick=0;
            pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:_muarr_ExpenseCode];
            CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
            model.expenseCode=  _str_expenseCode;
            pickerArea.typeTitle = Custing(@"费用类别", nil);
            pickerArea.CateModel=model;
            [pickerArea UpdatePickUI];
            [pickerArea setContentMode:STPickerContentModeBottom];
            
            if (self.Type==1){
                pickerArea.str_flowCode=@"F0002";
            }else if (self.Type==2){
                pickerArea.str_flowCode=@"F0003";
            }else if (self.Type==3){
                pickerArea.str_flowCode=@"F0010";
            }
            __weak typeof(self) weakSelf = self;
            [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
                if (![secondModel.expenseType isEqualToString:weakSelf.txf_ExpenseCode.text]) {
                    [self keyClose];
                    weakSelf.img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15"];
                    weakSelf.txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[secondModel.expenseCat,secondModel.expenseType]];
                    weakSelf.str_expenseDesc = [NSString stringWithIdOnNO:secondModel.expenseDesc];
                    weakSelf.str_expenseCode = secondModel.expenseCode;
                    weakSelf.str_expenseIcon = [NSString isEqualToNull:secondModel.expenseIcon]?secondModel.expenseIcon:@"15";
                    weakSelf.str_expenseCode_tag = [secondModel.tag isKindOfClass:[NSString class]]?secondModel.tag:@"";
                    weakSelf.str_ExpenseCat = secondModel.expenseCat;
                    weakSelf.str_ExpenseCatCode = secondModel.expenseCatCode;
                    weakSelf.str_accountItemCode = secondModel.accountItemCode;
                    weakSelf.str_accountItem = [GPUtils getSelectResultWithArray:@[secondModel.accountItemCode,secondModel.accountItem] WithCompare:@"/"];
                    [weakSelf dealInvoiceDefultValue];
                    [self clearCateData];
                    [weakSelf update_View_ExpenseCode_Click_First:secondModel.tag];
                    //                    [weakSelf updateRouteDeta];
                    //                    [weakSelf updateRouteDetaDidi];
                    if (self.bool_expenseGiftDetail && [weakSelf.str_expenseCode integerValue] == [self.expenseGiftDetailCodes integerValue]) {
                        if (self.arr_DetailsDataArray.count <= 0) {
                              GiftFeeDetail *dModel = [[GiftFeeDetail alloc] init];
                              [self.arr_DetailsDataArray addObject:dModel];
                          }
                        [self updateGiftDetailsTableView];
                        [self updateAddGiftDetailsView];
                    }else{
                        [self.arr_DetailsDataArray removeAllObjects];
                        [self updateGiftDetailsTableView];
                        [self updateAddGiftDetailsView];
                    }
                }
            }];
            [pickerArea show];
        }else if([_str_ExpenseCode_level isEqualToString:@"3"]){
            ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
            ex.arr_DataList = _muarr_ExpenseCode;
            ex.str_CateLevel = _str_ExpenseCode_level;
            if (self.Type == 1) {
                ex.str_flowCode = @"F0002";
            }else if (self.Type == 2){
                ex.str_flowCode = @"F0003";
            }else if (self.Type == 2){
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
                    weakSelf.str_expenseCode_tag = model.tag;
                    weakSelf.str_ExpenseCat = model.expenseCat;
                    weakSelf.str_ExpenseCatCode = model.expenseCatCode;
                    weakSelf.str_expenseDesc = [NSString stringWithIdOnNO:model.expenseDesc];
                    weakSelf.str_accountItemCode = model.accountItemCode;
                    weakSelf.str_accountItem = [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem] WithCompare:@"/"];
                    [weakSelf dealInvoiceDefultValue];
                    [self clearCateData];
                    [weakSelf update_View_ExpenseCode_Click_First:model.tag];
                    //                    [weakSelf updateRouteDeta];
                    //                    [weakSelf updateRouteDetaDidi];
                    if (self.bool_expenseGiftDetail && [self.str_expenseCode integerValue] == [self.expenseGiftDetailCodes integerValue]) {
                        if (self.arr_DetailsDataArray.count <= 0) {
                            GiftFeeDetail *dModel = [[GiftFeeDetail alloc] init];
                            [self.arr_DetailsDataArray addObject:dModel];
                        }
                        [self updateGiftDetailsTableView];
                        [self updateAddGiftDetailsView];
                    }else{
                        [self.arr_DetailsDataArray removeAllObjects];
                        [self updateGiftDetailsTableView];
                        [self updateAddGiftDetailsView];
                    }
                }
            };
            [self.navigationController pushViewController:ex animated:YES];
        }
    }
    //日期
    if (btn.tag == 5) {
        if (![NSString isEqualToNull:_txf_ExpenseDate.text]) {
            NSDate *date = [NSDate date];
            _txf_ExpenseDate.text = [NSString stringWithDate:date];
        }
        _txf_ExpenseDate.text = [_txf_ExpenseDate.text substringToIndex:10];
        
        STOnePickDateView *view = [[STOnePickDateView alloc]initWithTitle:Custing(@"日期", nil) Type:1 Date:_txf_ExpenseDate.text];
        [view setSTblock:^(NSString *date) {
            weakSelf.txf_ExpenseDate.text = date;
            [weakSelf updateInvoiceTypeViesWithType:2];
            if ([weakSelf.str_expenseCode_tag isEqualToString:@"Allowance"] && [[weakSelf getStandardAmountWithKey:@"basis"]floatValue]==4) {
                [weakSelf requestGetExpStdUpdateView];
            }
        }];
        [view show];
    }
    //成本中心
    if (btn.tag == 8) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"costCenter"];
        vc.ChooseCategoryId = _str_CostCenterId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            if (![[NSString stringWithFormat:@"%@",weakSelf.str_CostCenterId] isEqualToString:model.Id]) {
                weakSelf.str_CostCenterId = model.Id;
                weakSelf.str_CostCenterMgr = model.costCenterMgr;
                weakSelf.str_CostCenterMgrUserId = model.costCenterMgrUserId;
                weakSelf.txf_CostCenterId.text = model.costCenter;
                
                if (self.Type != 3) {
                    weakSelf.img_ExpenseCode.image = nil;
                    weakSelf.txf_ExpenseCode.text = @"";
                    weakSelf.str_expenseDesc = @"";
                    weakSelf.str_expenseCode = @"";
                    weakSelf.str_expenseIcon = @"";
                    weakSelf.str_ExpenseCat = @"";
                    weakSelf.str_ExpenseCatCode = @"";
                    weakSelf.str_accountItemCode = @"";
                    weakSelf.str_accountItem = @"";
                    weakSelf.sub_Expense.img_cate.image = nil;
                    weakSelf.str_expenseCode_tag = @"";
                    [self cleanData];
                    [self requestGetTyps];
                    [self updateCateGoryView];
                    [self clearCateData];
                    [self update_View_ExpenseCode_Click_First:@""];
                }
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    //项目名称
    if (btn.tag == 9) {
        ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"projectName"];
        vc.dict_otherPars = @{@"CostCenterId":self.dict_parameter[@"CostCenterId"] ? self.dict_parameter[@"CostCenterId"]:@"0"};
        vc.ChooseCategoryId = _str_ProjId;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_ProjId = model.Id;
            weakSelf.str_ProjMgrUserId = model.projMgrUserId;
            weakSelf.str_ProjMgr = model.projMgr;
            weakSelf.txf_ProjId.text=[GPUtils getSelectResultWithArray:@[model.no,model.projName]];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //住宿 选择城市
    if (btn.tag == 12) {
        NewAddressViewController *add = [[NewAddressViewController alloc]init];
        add.Type = 1;
        if (_Type == 1) {
            add.isGocity = @"3";
        }else if (_Type == 2){
            add.isGocity = @"4";
        }else if (_Type == 3){
            add.isGocity = @"5";
        }
        add.isAll = 0;
        add.status = @"1";
        add.delegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }
    //机票 舱位
    if (btn.tag == 13) {
        if (_arr_Flight == nil) {
            _arr_Flight = @[Custing(@"经济舱", nil),Custing(@"商务舱", nil),Custing(@"头等舱", nil)];
        }
        if (_pic_Flight == nil) {
            _pic_Flight = [[UIPickerView alloc]init];
            _pic_Flight.dataSource = self;
            _pic_Flight.delegate = self;
        }
        if (_cho_datelView == nil) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
            lbl.text=Custing(@"舱位", nil);
            lbl.font=Font_cellContent_16;
            lbl.textColor=Color_cellTitle;
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
            [view addSubview:lbl];
            UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定", nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            sureDataBtn.tag = 14;
            [view addSubview:sureDataBtn];
            UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
            cancelDataBtn.tag = 34;
            [view addSubview:cancelDataBtn];
            if (!_cho_datelView) {
                _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _pic_Flight.frame.size.height+40) pickerView:_pic_Flight titleView:view];
                _cho_datelView.delegate = self;
            }
            [_cho_datelView showUpView:_pic_Flight];
            [_cho_datelView show];
        }
        if (![NSString isEqualToNull:_txf_ClassName.text]) {
            _txf_ClassName.text = _arr_Flight[0];
        }
        for (int i = 0; i<_arr_Flight.count; i++) {
            if ([_txf_ClassName.text isEqualToString:_arr_Flight[i]]) {
                [_pic_Flight selectRow:i inComponent:0 animated:YES];
            }
        }
        [_cho_datelView show];
    }
    //机票 舱位选择确定
    if (btn.tag == 14) {
        if ([NSString isEqualToNull:_str_Flight]) {
            _txf_ClassName.text = _str_Flight;
        }
        _pic_Flight = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    //餐饮 同行人员
    if (btn.tag == 15) {
        contactsVController *contactVC=[[contactsVController alloc]init];
        contactVC.status = @"3";
        if (_arr_FellowOfficersId.count == 0) {
            NSString *requestorUserIdStr = self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId;
            [_arr_FellowOfficersId addObject:@{@"requestorUserId":requestorUserIdStr}];
        }
        contactVC.arrClickPeople = _arr_FellowOfficersId;
        contactVC.menutype=2;
        contactVC.itemType = 99;
        contactVC.Radio = @"2";
        __weak typeof(self) weakSelf = self;
        [contactVC setBlock:^(NSMutableArray *array) {
            weakSelf.arr_FellowOfficersId = [[NSMutableArray alloc]init];
            NSMutableArray *nameArr = [NSMutableArray array];
            NSMutableArray *idArr = [NSMutableArray array];
            for (buildCellInfo *bul in array) {
                NSDictionary *dic = @{@"requestorUserId":[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]};
                if ([NSString isEqualToNull:bul.requestor]) {
                    [nameArr addObject:[NSString stringWithFormat:@"%@",bul.requestor]];
                }
                if ([NSString isEqualToNullAndZero:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]]) {
                    [idArr addObject:[NSString stringWithFormat:@"%ld",(long)bul.requestorUserId]];
                }
                [weakSelf.arr_FellowOfficersId addObject:dic];
            }
            weakSelf.str_FellowOfficersId = [GPUtils getSelectResultWithArray:idArr WithCompare:@","];
            weakSelf.txf_FellowOfficers.text = [GPUtils getSelectResultWithArray:nameArr WithCompare:@","];
            weakSelf.str_FellowOfficers = weakSelf.txf_FellowOfficers.text;
            weakSelf.txf_TotalPeople.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
            weakSelf.str_TotalPeople = weakSelf.txf_TotalPeople.text;
        }];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    //查看PDF文件
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
            vc.AddModel=_model_addDetail;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (btn.tag == 18) {
        ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"Client"];
        vc.ChooseCategoryId=_str_ClientId;
        __weak typeof(self) weakSelf = self;
        vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
            ChooseCateFreModel *model = array[0];
            weakSelf.str_ClientId = model.Id;
            weakSelf.txf_ClientId.text =[GPUtils getSelectResultWithArray:@[model.code,model.name]];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    //补贴城市点击
    if (btn.tag == 19) {
        NewAddressViewController *add = [[NewAddressViewController alloc]init];
        add.Type = 1;
        if (_Type == 1) {
            add.isGocity = @"3";
        }else if (_Type == 2){
            add.isGocity = @"4";
        }else if (_Type == 3){
            add.isGocity = @"5";
        }
        add.isAll = 0;
        add.status = @"2";
        add.delegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }
    //室内交通出发地 出发时间
    if (btn.tag == 20) {
        NSString *dateString;
        if (![NSString isEqualToNull:_txf_TransFromDate.text]) {
            dateString= [NSString GetstringFromDate];
        }else{
            dateString=[_txf_TransFromDate.text substringToIndex:16];
        }
        _dap_ExpenseDate = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *fromDate=[format dateFromString:dateString];
        _dap_ExpenseDate.date=fromDate;
        userData *userdatas=[userData shareUserData];
        _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        _dap_ExpenseDate.datePickerMode = UIDatePickerModeDateAndTime;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"时间",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = 22;
        [view addSubview:sureDataBtn];
        
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 37;
        [view addSubview:cancelDataBtn];
        
        if (!_cho_datelView) {
            _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
            _cho_datelView.delegate = self;
        }
        [_cho_datelView showUpView:_dap_ExpenseDate];
        [_cho_datelView show];
    }
    //室内交通出发地 到达时间
    if (btn.tag == 21) {
        NSString *dateString;
        if (![NSString isEqualToNull:_txf_TransToDate.text]) {
            dateString= [NSString GetstringFromDate];
        }else{
            dateString=[_txf_TransToDate.text substringToIndex:16];
        }
        _dap_ExpenseDate = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *fromDate=[format dateFromString:dateString];
        _dap_ExpenseDate.date=fromDate;
        userData *userdatas=[userData shareUserData];
        _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        _dap_ExpenseDate.datePickerMode = UIDatePickerModeDateAndTime;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"时间",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = 23;
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 38;
        [view addSubview:cancelDataBtn];
        if (!_cho_datelView) {
            _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
            _cho_datelView.delegate = self;
        }
        [_cho_datelView showUpView:_dap_ExpenseDate];
        [_cho_datelView show];
    }
    if (btn.tag == 22) {
        NSDate * pickerDate = [_dap_ExpenseDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_TransFromDate.text = str;
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 23) {
        NSDate * pickerDate = [_dap_ExpenseDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_TransToDate.text = str;
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    //入住时间
    if (btn.tag == 24) {
        if (![NSString isEqualToNull:_txf_CheckInDate.text]) {
            NSDate *date = [NSDate date];
            _txf_CheckInDate.text = [NSString stringWithDate:date];
        }
        _txf_CheckInDate.text = [_txf_CheckInDate.text substringToIndex:10];
        _dap_ExpenseDate = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd"];
        NSDate *fromdate=[format dateFromString:_txf_CheckInDate.text];
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
        NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
        _dap_ExpenseDate.date=fromDate;
        userData *userdatas=[userData shareUserData];
        _dap_ExpenseDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        
        _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"日期",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = 26;
        [view addSubview:sureDataBtn];
        
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 39;
        [view addSubview:cancelDataBtn];
        
        if (!_cho_datelView) {
            _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
            _cho_datelView.delegate = self;
        }
        
        [_cho_datelView showUpView:_dap_ExpenseDate];
        [_cho_datelView show];
    }
    //退房时间
    if (btn.tag == 25) {
        if (![NSString isEqualToNull:_txf_CheckOutDate.text]) {
            NSDate *date = [NSDate date];
            _txf_CheckOutDate.text = [NSString stringWithDate:date];
        }
        _txf_CheckOutDate.text = [_txf_CheckOutDate.text substringToIndex:10];
        _dap_ExpenseDate = [[UIDatePicker alloc]init];
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy/MM/dd"];
        NSDate *fromdate=[format dateFromString:_txf_CheckOutDate.text];
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
        NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
        _dap_ExpenseDate.date=fromDate;
        userData *userdatas=[userData shareUserData];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
        _dap_ExpenseDate.datePickerMode = UIDatePickerModeDate;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
        lbl.text=Custing(@"日期",nil);
        lbl.font=Font_cellContent_16;
        lbl.textColor=Color_cellTitle;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
        [view addSubview:lbl];
        
        UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btn_Click:) delegate:self title:Custing(@"确定",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        sureDataBtn.tag = 27;
        [view addSubview:sureDataBtn];
        UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btn_Click:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
        cancelDataBtn.tag = 40;
        [view addSubview:cancelDataBtn];
        
        if (!_cho_datelView) {
            _cho_datelView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height, 0, _dap_ExpenseDate.frame.size.height+40) pickerView:_dap_ExpenseDate titleView:view];
            _cho_datelView.delegate = self;
        }
        
        [_cho_datelView showUpView:_dap_ExpenseDate];
        [_cho_datelView show];
    }
    if (btn.tag == 26) {
        NSDate * pickerDate = [_dap_ExpenseDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_CheckInDate.text = str;
        
        if ([NSString isEqualToNull:_txf_CheckOutDate.text]) {
            NSInteger date = [NSString datebydays:_txf_CheckOutDate.text date2:_txf_CheckInDate.text];
            if (date>0) {
                if (_txf_TotalDays) {
                    _txf_TotalDays.text = [NSString stringWithFormat:@"%ld",(long)date];
                    _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:_txf_TotalDays.text] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"]) afterPoint:2];
                }
            }
        }
        
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 27) {
        NSDate * pickerDate = [_dap_ExpenseDate date];
        NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString * str = [pickerFormatter stringFromDate:pickerDate];
        
        _txf_CheckOutDate.text = str;
        if ([NSString isEqualToNull:_txf_CheckInDate.text]) {
            NSInteger date = [NSString datebydays:_txf_CheckOutDate.text date2:_txf_CheckInDate.text];
            if (date>0) {
                if (_txf_TotalDays) {
                    _txf_TotalDays.text = [NSString stringWithFormat:@"%ld",(long)date];
                    _txf_HotelPrice.text = [GPUtils getRoundingOffNumber:([GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberDividingWithString:[self getLocalCyAmount] with:_txf_TotalDays.text] with:[_txf_Rooms.text floatValue] > 0 ? _txf_Rooms.text:@"1"]) afterPoint:2];
                }
            }
        }
        
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    
    //补贴选择补贴类型
    if (btn.tag == 30) {
        STOnePickView *picker = [[STOnePickView alloc]init];
        __weak typeof(self) weakSelf = self;
        [picker setBlock:^(STOnePickModel *Model, NSInteger type) {
            weakSelf.str_MealType=Model.Id;
            weakSelf.txf_MealType.text=Model.Type;
            if ([weakSelf.str_MealType isEqualToString:@"0"]) {
                weakSelf.txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[weakSelf.str_AllowanceCurrencyCode,weakSelf.str_MealAmount] WithCompare:@" "];
            }else{
                weakSelf.txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[weakSelf.str_AllowanceCurrencyCode,weakSelf.str_MealAmount1] WithCompare:@" "];
            }
            [self updateAllowanceData];
        }];
        picker.typeTitle=Custing(@"补贴类型", nil);
        picker.DateSourceArray=self.arr_AllowType;
        STOnePickModel *model1=[[STOnePickModel alloc]init];
        model1.Id=self.str_MealType;
        picker.Model=model1;
        [picker UpdatePickUI];
        [picker setContentMode:STPickerContentModeBottom];
        [picker show];
    }
    //飞机起点
    if (btn.tag == 32) {
        NewAddressViewController *add = [[NewAddressViewController alloc]init];
        add.Type = 1;
        add.notOften=YES;
        add.isGocity = @"0";
        add.isAll = 0;
        add.status = @"32";
//        add.isXiecheng = YES;
        add.delegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }
    //飞机终点
    if (btn.tag == 33) {
        NewAddressViewController *add = [[NewAddressViewController alloc]init];
        add.Type = 1;
        add.notOften=YES;
        add.isGocity = @"0";
        add.isAll = 0;
        add.status = @"33";
//        add.isXiecheng = YES;
        add.delegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }
    if (btn.tag == 34) {
        _pic_Flight = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 37) {
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 38) {
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 39) {
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
    if (btn.tag == 40) {
        _dap_ExpenseDate = nil;
        [_cho_datelView remove];
        _cho_datelView = nil;
    }
}

//自驾车行程轨迹
-(void)btn_route:(UIButton *)btn{
    MapRecordController *vc=[[MapRecordController alloc]init];
    vc.model = _model_route;
    [self.navigationController pushViewController:vc animated:YES];
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

//MARK:自定义字段选择器
-(void)gotoSlectController:(MyProcurementModel *)model textField:(UITextField *)textfield{
    MasterListViewController *vc=[[MasterListViewController alloc]initWithType:@"MasterList"];
    vc.model=model;
    vc.aimTextField=textfield;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)requestGetExpStdUpdateView{
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
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_model_AllowanceFromDate.txf_TexfField.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_model_AllowanceToDate.txf_TexfField.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_model_TravelUserName.Id],
                                 @"UserId":self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId};
    NSString *url=[NSString stringWithFormat:@"%@",GetExpStdV2];
    [[GPClient shareGPClient]REquestByPostWithPath:url Parameters:parameters Delegate:self SerialNum:22 IfUserCache:NO];
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
                                 @"AllowanceFromDate":[NSString stringWithIdOnNO:_model_AllowanceFromDate.txf_TexfField.text],
                                 @"AllowanceToDate":[NSString stringWithIdOnNO:_model_AllowanceToDate.txf_TexfField.text],
                                 @"TravelUserId":[NSString stringWithIdOnNO:_model_TravelUserName.Id],
                                 @"UserId":self.dict_parameter[@"OwnerUserId"] ? self.dict_parameter[@"OwnerUserId"]:self.userdatas.userId};
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
        [self requestGetTyps];
    }else if (serialNum == 1) {
        _dic_ExpenseCode_requst = responceDic;
        [self analysisRequestDataByExpenseCode];
        _bool_isOpenGener = YES;
        [self updateCateGoryView];
        [self updateExpenseCodeList_View];
        NSDictionary *Basedict=[_dic_ExpenseCode_requst objectForKey:@"result"];
        if (![Basedict isKindOfClass:[NSNull class]]) {
            if ([_str_ExpenseCode_level isEqualToString:@"1"]) {
                NSArray *result=[Basedict objectForKey:@"expTypBoxOutputs"];
                if (![result isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result) {
                        if ([dict[@"expenseCode"] isEqualToString:_str_expenseCode]) {
                            _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:dict[@"expenseIcon"]]?dict[@"expenseIcon"]:@"15"];
                            _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[dict[@"expenseCat"],dict[@"expenseType"]]];
                            _str_expenseCode = dict[@"expenseCode"];
                            _str_expenseDesc = [NSString stringWithIdOnNO:dict[@"expenseDesc"]];
                            _str_expenseIcon = [NSString isEqualToNull:dict[@"expenseIcon"]]?dict[@"expenseIcon"]:@"15";
                            _str_ExpenseCat = dict[@"expenseCat"];
                            _str_ExpenseCatCode = dict[@"expenseCatCode"];
                            [_sub_Expense setCateImg:_str_expenseIcon];
                            _str_expenseCode_tag = [dict[@"tag"] isKindOfClass:[NSString class]]?dict[@"tag"]:@"";
                        }
                    }
                }
            }else if ([_str_ExpenseCode_level isEqualToString:@"2"]||[_str_ExpenseCode_level isEqualToString:@"3"]){
                NSArray *result=[Basedict objectForKey:@"expTypListOutputs"];
                if (![result isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result) {
                        CostCateNewModel *model = [[CostCateNewModel alloc]init];
                        if (![dict[@"getExpTypeList"] isKindOfClass:[NSNull class]]) {
                            model.getExpTypeList = dict[@"getExpTypeList"];
                            for (NSDictionary *dict in model.getExpTypeList) {
                                if ([dict[@"expenseCode"] isEqualToString:_str_expenseCode]) {
                                    _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:dict[@"expenseIcon"]]?dict[@"expenseIcon"]:@"15"];
                                    _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[dict[@"expenseCat"],dict[@"expenseType"]]];
                                    _str_expenseCode = dict[@"expenseCode"];
                                    _str_expenseDesc = [NSString stringWithIdOnNO:dict[@"expenseDesc"]];
                                    _str_expenseIcon = [NSString isEqualToNull:dict[@"expenseIcon"]]?dict[@"expenseIcon"]:@"15";
                                    _str_ExpenseCat = dict[@"expenseCat"];
                                    _str_ExpenseCatCode = dict[@"expenseCatCode"];
                                    [_sub_Expense setCateImg:_str_expenseIcon];
                                    _str_expenseCode_tag = [dict[@"tag"] isKindOfClass:[NSString class]]?dict[@"tag"]:@"";
                                }
                            }
                        }
                    }
                }
            }
        }
        [self update_View_ExpenseCode_Click_First:_str_expenseCode_tag];
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
        _str_Unit = [responceDic[@"result"][@"unit"] isKindOfClass:[NSNull class]]?@"":responceDic[@"result"][@"unit"];
        _str_Class = responceDic[@"result"][@"class"];
        _str_Discount = [responceDic[@"result"][@"discount"] isKindOfClass:[NSNull class]]?@"":responceDic[@"result"][@"discount"];
        _str_IsExpensed = [NSString stringWithIdOnNO:responceDic[@"result"][@"isExpense"]];
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
            _str_Basis = responceDic[@"result"][@"basis"] ;
            if (_Id == 0) {
                [self update_Amount:_txf_TotalDays.text textField:[UITextField new]];
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"SelfDrive"]){
            if ([[self getStandardAmountWithKey:@"basis"]floatValue] == 3) {
                if ([responceDic[@"result"][@"getStdPrivateCar"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *getStdPrivateCar = responceDic[@"result"][@"getStdPrivateCar"];
                    _txf_CarStd.text = [NSString stringWithIdOnNO:getStdPrivateCar[@"fuelConsumption"]];
                    NSString *amount = [GPUtils decimalNumberMultipWithString:self.txf_OilPrice.text with:_txf_CarStd.text];
                    amount = [GPUtils decimalNumberMultipWithString:self.txf_Mileage.text with:amount];
                    amount = [GPUtils decimalNumberDividingWithString:amount with:@"100"];
                    _txf_FuelBills.text = [GPUtils getRoundingOffNumber:amount afterPoint:2];
                    if (_txf_FuelBills) {
                        _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_FuelBills.text floatValue]+[_txf_Pontage.text floatValue]+[_txf_ParkingFee.text floatValue]];
                        _txf_LocalCyAmount.text =[GPUtils transformNsNumber: [GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                if ([responceDic[@"result"][@"stdSelfDriveDtoList"] isKindOfClass:[NSArray class]]) {
                    _arr_stdSelfDriveDtoList = responceDic[@"result"][@"stdSelfDriveDtoList"];
                }
                if (_arr_stdSelfDriveDtoList.count>0) {
                    NSString *amount = [self returnSelfCarAmount:self.txf_Mileage.text];
                    _txf_CarStd.text = [NSString stringWithFormat:@"%@", amount];
                    _txf_FuelBills.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:_txf_CarStd.text] afterPoint:2];
                    if (_txf_FuelBills) {
                        
                        _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_FuelBills.text floatValue]+[_txf_Pontage.text floatValue]+[_txf_ParkingFee.text floatValue]];
                        _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                }else{
                    _txf_CarStd.text = [NSString stringWithFormat:@"%@", responceDic[@"result"][@"amount"]];
                    _txf_FuelBills.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:_txf_CarStd.text] afterPoint:2];
                    if (_txf_FuelBills) {
                        _txf_Amount.text = [NSString stringWithFormat:@"%.2f",[_txf_FuelBills.text floatValue]+[_txf_Pontage.text floatValue]+[_txf_ParkingFee.text floatValue]];
                        _txf_LocalCyAmount.text =[GPUtils transformNsNumber: [GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Flight"]){
            if (_Id == 0) {
                _txf_ClassName.text = _arr_Flight[[responceDic[@"result"][@"class"]integerValue]==0?1:[responceDic[@"result"][@"class"]integerValue]-1];
                _txf_Discount.text = [NSString isEqualToNull:responceDic[@"result"][@"discount"]]?responceDic[@"result"][@"discount"]:@"";
            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Meals"]){
            if (_Id == 0) {
                NSString *amount1=[self getStandardAmountWithKey:@"amount"];
                NSString *amount2=[self getStandardAmountWithKey:@"amount2"];
                NSString *amount3=[self getStandardAmountWithKey:@"amount3"];
                _txf_Breakfast.text = amount1;
                _txf_Lunch.text = amount2;
                _txf_Supper.text = amount3;
                NSString *tolAmount=[GPUtils decimalNumberAddWithString:[GPUtils decimalNumberAddWithString:amount1 with:amount2] with:amount3];
                _txf_Amount.text = [GPUtils getRoundingOffNumber:tolAmount afterPoint:2];
                _txf_LocalCyAmount.text = [self getLocalCyAmount];
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
        }else if ([_str_expenseCode_tag isEqualToString:@"Allowance"]){
            if ([_str_Unit isEqualToString:@"天"]||[_str_Unit isEqualToString:@"月"]||[_str_Unit isEqualToString:@"年"]) {
                _str_Basis = responceDic[@"result"][@"basis"] ;
                [self updateAllowanceView:[responceDic[@"result"][@"basis"] integerValue]];
            }
            //            else{
            //                _txf_Amount.text = [NSString stringWithFormat:@"%@",_str_Amount];
            //                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_str_Amount] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
            //                _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
            //            }
        }else if ([_str_expenseCode_tag isEqualToString:@"Medical"]){
            if (_Id == 0) {
                if ([responceDic[@"result"][@"staffExpenses"] isKindOfClass:[NSDictionary class]]){
                    _str_MedicalAmount = [NSString stringWithFormat:@"%@",responceDic[@"result"][@"staffExpenses"][@"amount"]];
                    _txf_Amount.text = _str_MedicalAmount;
                    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
        }else if ([_str_expenseCode_tag isEqualToString:@"Trans"]){
            if ([_str_Unit isEqualToString:@"天"]) {
                _txf_AllowanceAmount.text=[NSString stringWithIdOnNO:_str_Amount];
            }
            if (_Id == 0) {
                if ([_str_Unit isEqualToString:@"天"]) {
                    _txf_AllowanceAmount.text=[NSString stringWithIdOnNO:_str_Amount];
                    
                    _txf_Amount.text = [GPUtils decimalNumberMultipWithString:_txf_AllowanceAmount.text with:_txf_TransTotalDays.text];
                    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_txf_Amount.text] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
                else{
                    _txf_Amount.text = [NSString stringWithFormat:@"%@",_str_Amount];
                    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_str_Amount] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
        }else if ([_str_expenseCode_tag isEqualToString:@"Mobile"]){
            if (_Id == 0) {
                _txf_Amount.text = [NSString stringWithFormat:@"%@",_str_Amount];
                _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:[NSString stringWithFormat:@"%@",_str_Amount] with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
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
        if (_bool_firstIn) {
            [self dealEditEndData];
            [self checkInDiDiData];
            _bool_firstIn=NO;
            if ([NSString isEqualToNull:_dateSource] && _model_addDetail) {
                if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"9"]) {
                    _txf_Amount.text = _model_addDetail.amount;
                    _txf_ExpenseDate.text = _model_addDetail.expenseDate;
                    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
                }else if ([[NSString stringWithFormat:@"%@",_dateSource] isEqualToString:@"10"]){
                    self.str_expenseCode_tag = _model_addDetail.tag;
                    //携程信息录入
                    _txf_Amount.text = _model_addDetail.amount;
                    if ([NSString isEqualToNull:_model_addDetail.reimbursementTypId]) {
                        if (self.arr_ClaimType.count > 0) {
                            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", [NSString stringWithFormat:@"%@",_model_didi.reimbursementTypId]];
                            NSArray *filterArray = [self.arr_ClaimType filteredArrayUsingPredicate:pred1];
                            if (filterArray.count > 0) {
                                STOnePickModel *model1 = filterArray[0];
                                _str_ClaimType = model1.Id;
                                _txf_ClaimType.text = model1.Type;
                            }else{
                                _str_ClaimType = @"1";
                                _txf_ClaimType.text = Custing(@"差旅费", nil);
                            }
                        }else{
                            _str_ClaimType = @"1";
                            _txf_ClaimType.text = Custing(@"差旅费", nil);
                        }
                    }else{
                        _str_ClaimType = @"1";
                        _txf_ClaimType.text = Custing(@"差旅费", nil);
                    }
                    _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_model_addDetail.expenseIcon]?_model_addDetail.expenseIcon:@"15"];
                    _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[_model_addDetail.expenseCat,_model_addDetail.expenseType]];
                    _str_expenseDesc = [NSString stringWithIdOnNO:_model_addDetail.expenseDesc];
                    _str_expenseCode = _model_addDetail.expenseCode;
                    _str_expenseIcon = [NSString isEqualToNull:_model_addDetail.expenseIcon]?_model_addDetail.expenseIcon:@"15";
                    _str_ExpenseCat = _model_addDetail.expenseCat;
                    _str_ExpenseCatCode = _model_addDetail.expenseCatCode;
                    [_sub_Expense setCateImg:_str_expenseIcon];
                    _txf_ExpenseDate.text = _model_addDetail.expenseDate;
                    _txf_CityName.text = _model_addDetail.cityName;
                    _str_City = _model_addDetail.cityName;
                    _str_CityCode = _model_addDetail.cityCode;
                    _txf_CheckInDate.text = _model_addDetail.checkInDate;
                    _txf_CheckOutDate.text = _model_addDetail.checkOutDate;
                    _txf_TotalDays.text = _model_addDetail.totalDays;
                    if ([NSString isEqualToNull:_model_addDetail.remark]) {
                        _remarksTextView.text = _model_addDetail.remark;
                        _remarkTipField.hidden = YES;
                    }
                    self.str_InvoiceType = _model_addDetail.invoiceType;
                    self.str_InvoiceTypeName = _model_addDetail.invoiceTypeName;
                    self.txf_InvoiceType.text = self.str_InvoiceTypeName;
                    self.str_InvoiceTypeCode = _model_addDetail.invoiceTypeCode;
                    [self updateExpenseCodeList_View];
                    [self updateInvoiceTypeViesWithType:1];
                    
                    self.str_AirlineFuelFee = _model_addDetail.airlineFuelFee;
                    self.txf_AirlineFuelFee.text = [NSString stringWithIdOnNO:self.str_AirlineFuelFee];
                    self.str_AirTicketPrice = _model_addDetail.airTicketPrice;
                    self.txf_AirTicketPrice.text = [NSString stringWithIdOnNO:self.str_AirTicketPrice];
                    self.str_DevelopmentFund = _model_addDetail.developmentFund;
                    self.txf_DevelopmentFund.text = [NSString stringWithIdOnNO:self.str_DevelopmentFund];
                    self.str_FuelSurcharge = _model_addDetail.fuelSurcharge;
                    self.txf_FuelSurcharge.text = [NSString stringWithIdOnNO:self.str_FuelSurcharge];
                    self.str_OtherTaxes = _model_addDetail.otherTaxes;
                    self.txf_OtherTaxes.text = [NSString stringWithIdOnNO:self.str_OtherTaxes];
                    
                    NSString *local = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:[self getEndExchangeRate]];
                    NSString *local1 = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:([NSString isEqualToNull:self.str_InvCyPmtExchangeRate] ? self.str_InvCyPmtExchangeRate:@"1.0000")];
                    
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
                }
            }
        }
    }else if (serialNum == 3) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"保存成功", nil)];
        if (_int_load == 1) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            [self cleanData];
            _int_load = 0;
            _view_DockView.userInteractionEnabled = YES;
            [self viewDidLoad];
        }else{
            NSMutableDictionary *makeDict =[NSMutableDictionary dictionaryWithDictionary:[NSObject getObjectData:_model_NewAddCost]];
            
            if (_Action==1) {
                [makeDict addString:@"1" forKey:@"checked"];
            }else{
                [makeDict addString:_check forKey:@"checked"];
            }
            [makeDict addString:responceDic[@"result"] forKey:@"Id"];
            
            
            NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
            [note postNotificationName:_Action==2?@"EDITCOST":@"ADDCOST" object:self userInfo:@{@"info" :makeDict}];
            [self performBlock:^{
                self.view_DockView.userInteractionEnabled = YES;
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1];
        }
    }else if (serialNum == 5) {
        [CostCateNewModel getCostCateByDict:responceDic array:self.arr_ReplCategoryArr withType:2];
        [self ReplExpenseClick];
    }else if (serialNum == 6) {
        NSArray *array = (NSArray *)[NSString transformToObj:[NSString stringWithFormat:@"%@",[responceDic objectForKey:@"result"]]];
        for (int i=0; i<array.count; i++) {
            [_totalArray replaceObjectAtIndex:[_imageTypeArray[i] integerValue] withObject:array[i]];
        }
        _str_imageDataString = [NSString transformToJsonWithOutEnter:_totalArray];
        [self requestFilesUploader];
    }else if (serialNum == 13) {
        [self requestAddCostList];
    }else if (serialNum == 14) {
        if ([responceDic[@"result"] isKindOfClass:[NSDictionary class]]) {
            _str_Basis = responceDic[@"result"][@"basis"];
        }
        [self requestGetExpStd];
    }else if (serialNum == 17) {
        if ([NSString isEqualToNull:responceDic[@"result"]]) {
            PdfReadViewController *vc=[[PdfReadViewController alloc]init];
            vc.PdfUrl =[NSString stringWithFormat:@"%@",responceDic[@"result"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (serialNum ==20){
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        
        [self update_View_ExpenseCode_Click:_str_expenseCode_tag];
    }else if (serialNum ==21){
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        [self JudgeStd];
    }else if (serialNum ==22){
        if ([responceDic[@"result"]isKindOfClass:[NSDictionary class]]) {
            _dict_Standard=responceDic[@"result"];
            if ([responceDic[@"result"][@"stdOutput"] isKindOfClass:[NSDictionary class]]) {
                _dict_Standard_StdOutput=responceDic[@"result"][@"stdOutput"];
            }
        }
        
        if ([_str_expenseCode_tag isEqualToString:@"Allowance"]) {
//            NSString *standardAmount;
            if ([[self getStandardAmountWithKey:@"basis"]floatValue]==1||[[self getStandardAmountWithKey:@"basis"]floatValue]==2||[[self getStandardAmountWithKey:@"basis"]floatValue]==4) {
                _txf_MealAmount.text  = [self getStandardAmountWithKey:@"amount"];
            }else{
                _txf_MealAmount.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithIdOnNO:_dict_Standard_StdOutput[@"currencyCode"]],[self getStandardHasCurrency]] WithCompare:@" "];
            }
            [self updateAllowanceData];
        }
    }else if (serialNum == 25){
        _view_DockView.userInteractionEnabled = YES;
        __weak typeof(self) weakSelf = self;
            NSLog(@"发票信息：%@",responceDic[@"result"]);
        if ([NSString isEqualToNull:responceDic[@"result"]]) {
            NSDictionary *invCdDic = responceDic[@"result"];
            if ([NSString isEqualToNull:invCdDic[@"invoiceCodes"]]) {
                NSString *invCodesStr = invCdDic[@"invoiceCodes"];
                NSArray *invCodesArr = [invCodesStr componentsSeparatedByString:@","];
                for (NSString *invCode in invCodesArr) {
                    if ([invCode integerValue] == [weakSelf.str_InvoiceTypeCode integerValue] ) {
                        [[GPAlertView sharedAlertView]showAlertText:weakSelf WithText:Custing(@"需要发票拍照/发票扫描进行查验，不予保存消费记录", nil) duration:1.5];
                        return;
                    }
                }
            }
        }
//        weakSelf.str_InvoiceTypeCode = Model.Id;
//        weakSelf.str_InvoiceTypeName = Model.Type;
        [weakSelf requestUploader];
    }
}

-(void)requestFail:(NSString *)responceFail serialNum:(int)serialNum{
    _view_DockView.userInteractionEnabled=YES;
    [YXSpritesLoadingView dismiss];
    [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"网络请求失败", nil) duration:2.0];
}
-(void)dealEditEndData{
    if (_Id!=0) {
        for (MyProcurementModel *model in _muarr_MainEndData) {
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
            }else if ([model.fieldName isEqualToString:@"InvCyPmtExchangeRate"]) {
                _txf_InvCyPmtExchangeRate.text=[NSString stringWithIdOnNO:model.fieldValue];
            }else if ([model.fieldName isEqualToString:@"InvPmtAmount"]) {
                _txf_InvPmtAmount.text=[NSString stringWithIdOnNO:model.fieldValue];
            }else if ([model.fieldName isEqualToString:@"InvPmtTax"]) {
                _txf_InvPmtTax.text=[NSString stringWithIdOnNO:model.fieldValue];
            }else if ([model.fieldName isEqualToString:@"InvPmtAmountExclTax"]) {
                _txf_InvPmtAmountExclTax.text=[NSString stringWithIdOnNO:model.fieldValue];
            }
        }
        self.txf_AirlineFuelFee.text = [NSString stringWithIdOnNO:self.str_AirlineFuelFee];
        self.txf_AirTicketPrice.text = [NSString stringWithIdOnNO:self.str_AirTicketPrice];
        self.txf_DevelopmentFund.text = [NSString stringWithIdOnNO:self.str_DevelopmentFund];
        self.txf_FuelSurcharge.text = [NSString stringWithIdOnNO:self.str_FuelSurcharge];
        self.txf_OtherTaxes.text = [NSString stringWithIdOnNO:self.str_OtherTaxes];
        
        self.str_lastAmount = [self getLocalCyAmount];
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
            _str_expenseDesc = [NSString stringWithIdOnNO:model.expenseDesc];
            _str_expenseCode = model.expenseCode;
            _str_expenseIcon = [NSString isEqualToNull:model.expenseIcon]?model.expenseIcon:@"15";
            _str_ExpenseCat = model.expenseCat;
            _str_ExpenseCatCode = model.expenseCatCode;
            self.str_accountItemCode = model.accountItemCode;
            self.str_accountItem = [GPUtils getSelectResultWithArray:@[model.accountItemCode,model.accountItem] WithCompare:@"/"];
            [_sub_Expense setCateImg:_str_expenseIcon];
            _str_expenseCode_tag = [model.tag isKindOfClass:[NSString class]]?model.tag:@"";
            [self dealInvoiceDefultValue];
            [self updateCateGoryView];
            [self clearCateData];
            [self update_View_ExpenseCode_Click_First:model.tag];
            //            [self updateRouteDeta];
            //            [self updateRouteDetaDidi];
            if (self.bool_expenseGiftDetail && [self.str_expenseCode integerValue] == [self.expenseGiftDetailCodes integerValue]) {
                if (self.arr_DetailsDataArray.count <= 0) {
                    GiftFeeDetail *dModel = [[GiftFeeDetail alloc] init];
                    [self.arr_DetailsDataArray addObject:dModel];
                }
                [self updateGiftDetailsTableView];
                [self updateAddGiftDetailsView];
            }else{
                [self.arr_DetailsDataArray removeAllObjects];
                [self updateGiftDetailsTableView];
                [self updateAddGiftDetailsView];
            }
        }else{
            [self updateCateGoryView];
        }
    }
}

#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.array_shareData.count;
    if ([tableView isEqual:self.View_shareTable]) {
        return self.array_shareData.count;
    }else if([tableView isEqual:self.View_GiftDetailsTable]){
        return self.arr_DetailsDataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.array_shareForm.count;
    if ([tableView isEqual:self.View_shareTable]) {
        return self.array_shareForm.count;
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
        return self.arr_DetailsArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
    if (tableView==_View_shareTable) {
        return 50;
    }else  if (tableView==_View_GiftDetailsTable){
        return 42;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.View_shareTable]) {
        FormDetailBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FormDetailBaseCell"];
        if (cell==nil) {
            cell=[[FormDetailBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormDetailBaseCell"];
        }
        cell.IndexPath=indexPath;
        [cell configAddReimShareCellWithFormModel:self.array_shareForm[indexPath.row] withDataModel:self.array_shareData[indexPath.section]];
        __weak typeof(self) weakSelf = self;
        cell.CellBackDataBlock = ^(NSIndexPath * _Nonnull index, UITextField * _Nonnull tf, MyProcurementModel * _Nonnull model, id  _Nonnull dModel) {
            AddReimShareModel *shareModel = (AddReimShareModel*)dModel;
            if ([model.fieldName isEqualToString:@"BranchId"]) {
                [weakSelf keyClose];
                ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"BranchCompany"];
                vc.ChooseCategoryId = shareModel.BranchId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    shareModel.BranchId = model.groupId;
                    shareModel.Branch = model.groupName;
                    tf.text=model.groupName;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.fieldName isEqualToString:@"RequestorDeptId"]) {
                [weakSelf keyClose];
                self.userdatas.PeoplePage = self.navigationController.viewControllers.count;
                ComPeopleViewController *cp = [[ComPeopleViewController alloc]init];
                cp.nowGroupname = self.userdatas.company;
                cp.ComPeopleViewControllerBlock = ^(NSDictionary *dict) {
                    shareModel.RequestorDeptId = [NSString stringIsExist:dict[@"id"]];
                    shareModel.RequestorDept = [NSString stringIsExist:dict[@"name"]];
                    tf.text = shareModel.RequestorDept;
                };
                [weakSelf.navigationController pushViewController:cp animated:YES];
            }else if ([model.fieldName isEqualToString:@"RequestorBusDeptId"]) {
                [weakSelf keyClose];
                ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"BDivision"];
                vc.ChooseCategoryId = shareModel.RequestorBusDeptId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    shareModel.RequestorBusDeptId = model.Id;
                    shareModel.RequestorBusDept = model.name;
                    tf.text=model.name;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.fieldName isEqualToString:@"CostCenterId"]) {
                [weakSelf keyClose];
                ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"costCenter"];
                vc.ChooseCategoryId = shareModel.CostCenterId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    shareModel.CostCenterId = model.Id;
                    shareModel.CostCenter = model.costCenter;
                    tf.text=model.costCenter;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.fieldName isEqualToString:@"ProjId"]) {
                [weakSelf keyClose];
                ChooseCateFreshController *vc=[[ChooseCateFreshController alloc]initWithType:@"projectName"];
                vc.ChooseCategoryId = shareModel.ProjId;
                vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                    ChooseCateFreModel *model = array[0];
                    shareModel.ProjId = model.Id;
                    shareModel.ProjName = [GPUtils getSelectResultWithArray:@[model.no,model.projName]];
                    tf.text = shareModel.ProjName;
                    shareModel.ProjMgrUserId = model.projMgrUserId;
                    shareModel.ProjMgr = model.projMgr;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.fieldName isEqualToString:@"ShareRatio"]){
                shareModel.ShareRatio = tf.text;
                //            NSString *locAmount = [weakSelf getLocalCyAmount];
                //            shareModel.Amount = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberMultipWithString:locAmount with:shareModel.ShareRatio] with:@"100"] afterPoint:2];
                [weakSelf dealShareAllContentDataWithType:0];
                //            [weakSelf updateShareTableView];
                //            FormDetailBaseCell *cell = [weakSelf.View_shareTable cellForRowAtIndexPath:index];
                //            [cell.txf_Contet becomeFirstResponder];
            }else if ([model.fieldName isEqualToString:@"Amount"]){
                shareModel.Amount = tf.text;
                //            NSString *locAmount = [weakSelf getLocalCyAmount];
                //            shareModel.ShareRatio = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:[GPUtils decimalNumberDividingWithString:shareModel.Amount with:locAmount] with:@"100"] afterPoint:2];
                [weakSelf dealShareAllContentDataWithType:0];
                //            [weakSelf updateShareTableView];
                //            FormDetailBaseCell *cell = [weakSelf.View_shareTable cellForRowAtIndexPath:index];
                //            [cell.txf_Contet becomeFirstResponder];
            }else if ([model.fieldName isEqualToString:@"Remark"]) {
                shareModel.Remark = tf.text;
            }else if ([model.fieldName containsString:@"Reserved"]){
                if ([model.ctrlTyp isEqualToString:@"text"]||[model.ctrlTyp isEqualToString:@"date"]) {
                    [shareModel setValue:tf.text forKey:model.fieldName];
                }else if ([model.ctrlTyp isEqualToString:@"dialog"]||[model.ctrlTyp isEqualToString:@"multi"]){
                    ChooseCateFreshController *vc = [[ChooseCateFreshController alloc]initWithType:@"ConfigurationItem"];
                    vc.ChooseModel = model;
                    vc.isMultiSelect = [model.ctrlTyp isEqualToString:@"multi"];
                    vc.ChooseFreshCateBackBlock = ^(NSMutableArray *array, NSString *type) {
                        NSMutableArray *arr=[NSMutableArray array];
                        for (ChooseCateFreModel *model in array) {
                            [arr addObject:model.name];
                        }
                        tf.text=[GPUtils getSelectResultWithArray:arr WithCompare:@","];
                        [shareModel setValue:tf.text forKey:model.fieldName];
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        };
        return cell;
    }else if([tableView isEqual:self.View_GiftDetailsTable]){
        DeatilsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DeatilsViewCell"];
        if (cell==nil) {
            cell=[[DeatilsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeatilsViewCell"];
        }
        [cell configGiftFeeCellWithModel:self.arr_DetailsArray[indexPath.row] withDetailsModel:self.arr_DetailsDataArray[indexPath.section] WithCount:self.arr_DetailsArray.count WithIndex:indexPath.row];
        [cell.TCompanyNameTF addTarget:self action:@selector(TCompanyNameChange:) forControlEvents:UIControlEventEditingChanged];
        cell.TCompanyNameTF.tag=100+indexPath.section;
        cell.TCompanyNameTF.delegate = self;
        
        [cell.TRecipientTF addTarget:self action:@selector(TRecipientChange:) forControlEvents:UIControlEventEditingChanged];
        cell.TRecipientTF.tag=100+indexPath.section;
        cell.TRecipientTF.delegate = self;
        
        [cell.GiftNameTF addTarget:self action:@selector(GiftNameChange:) forControlEvents:UIControlEventEditingChanged];
        cell.GiftNameTF.tag=100+indexPath.section;
        cell.GiftNameTF.delegate = self;
        
        [cell.RemarkTextField addTarget:self action:@selector(RemarkChange:) forControlEvents:UIControlEventEditingChanged];
        cell.RemarkTextField.tag=100+indexPath.section;
        cell.RemarkTextField.delegate = self;
        
        [cell.AmountTF addTarget:self action:@selector(AmountChange:) forControlEvents:UIControlEventEditingChanged];
        cell.AmountTF.tag=1000+indexPath.section;
        cell.AmountTF.delegate = self;
        
//        [cell.ExpenseTypeBtn addTarget:self action:@selector(CateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.ExpenseTypeBtn.tag=1+indexPath.section;
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [head addSubview:ImgView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [head addSubview:titleLabel];
    if ([tableView isEqual:self.View_shareTable]) {
        if (self.array_shareData.count == 1) {
            titleLabel.text=Custing(@"费用分摊", nil);
        }else{
            titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"费用分摊", nil),(long)section+1];
            if (section!=0) {
                UILabel *deleteLab = [GPUtils createLable:CGRectMake(Main_Screen_Width - 162, 0, 150, 27) text:Custing(@"删除", nil) font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentRight];
                deleteLab.userInteractionEnabled = YES;
                __weak typeof(self) weakSelf = self;
                [deleteLab bk_whenTapped:^{
                    [weakSelf keyClose];
                    [UIAlertView bk_showAlertViewWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除费用分摊", nil),(long)(section+1)] cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:@[Custing(@"删除",nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakSelf.array_shareData removeObjectAtIndex:section];
                            [weakSelf dealShareAllContentDataWithType:0];
                            [weakSelf updateShareTableView];
                        }
                    }];
                }];
                [head addSubview:deleteLab];
            }
        }
        head.backgroundColor=Color_White_Same_20;
        return head;
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
       [self createHeadViewWithSection:section];
       return _View_Head;
    }else{
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([tableView isEqual:self.View_shareTable]) {
        return [[UIView alloc]init];
    }else if ([tableView isEqual:self.View_GiftDetailsTable]){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor =Color_WhiteWeak_Same_20;
        return view;
    }else{
        return [[UIView alloc]init];
    }
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        return _arr_Flight.count;
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        return _arr_Flight[row];
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _pic_Flight) {
        _str_Flight = _arr_Flight[row];
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
    if (_txf_Amount == textField||_txf_Tax == textField||_txf_Breakfast == textField||_txf_Lunch == textField||_txf_Supper == textField) {
        pattern = @"^-?((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
    }else if (_txf_ExchangeRate == textField){
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,5})?)?$";
    }else if (_txf_TotalDays==textField||_txf_Day==textField||_txf_TransTotalDays==textField){
        pattern = @"^((0|[1-9][0-9]{0,3})(\\.[0-9]{0,1})?)?$";
    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    else if (textField.tag>=1000&&textField.tag<=1250){
        NSString *pattern;
        pattern = @"^((0|[1-9][0-9]{0,8})(\\.[0-9]{0,2})?)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        return match!= 0;
    }
    NSError *error = nil;
    NSUInteger match = 0;
    if (_txf_Amount == textField||_txf_Tax == textField||_txf_ExchangeRate == textField||_txf_Breakfast == textField||_txf_Lunch == textField||_txf_Supper == textField||_txf_TotalDays==textField||_txf_Day==textField||_txf_TransTotalDays==textField) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        match = [regex numberOfMatchesInString:newString options:0 range:NSMakeRange(0, [newString length])];
        if (match==0) {
            return 0;
        }
    }
    
    if (_txf_Amount == textField) {
        _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:newString with:!_txf_ExchangeRate?@"1":_txf_ExchangeRate.text]];
        if ([NSString isEqualToNull:newString]) {
            _txf_Tax.text = [NSString countTax:newString taxrate:[NSString isEqualToNull:_txf_TaxRate.text]?_txf_TaxRate.text:@"0"];
        }else{
            _txf_Tax.text = @"0";
        }
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
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?[NSString isEqualToNull:_txf_Amount.text]?_txf_Amount.text:@"0":_txf_LocalCyAmount.text with:newString];
    }else if (_txf_ExchangeRate == textField){
        _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Amount.text with:newString]];
        _txf_Tax.text = [NSString countTax:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text taxrate:_txf_TaxRate.text];
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
    }else if (_txf_TaxRate == textField){
        _txf_Tax.text = [NSString countTax:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text taxrate:newString];
        _txf_ExclTax.text = [GPUtils decimalNumberSubWithString:!_txf_LocalCyAmount?_txf_Amount.text:_txf_LocalCyAmount.text with:!_txf_Tax?@"0":_txf_Tax.text];
    }else if (_txf_TotalDays == textField||_txf_Lunch == textField||_txf_Breakfast == textField||_txf_Supper == textField||_txf_Day == textField||_txf_Rooms == textField){
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
            [self requestCheckInvoiceNo];
        }else{
            self.view_DockView.userInteractionEnabled = YES;
        }
    }else{
        if (buttonIndex==1) {
            [_imagesArray removeObjectAtIndex:alertView.tag];
            if (_imagesArray.count>0) {
                [self.imgCollectView reloadData];
            }else{
                [self.imgCollectView reloadData];
                [self updateImageCollect];
            }
            if (alertView==_Aler_deleteDetils) {
                [self.arr_DetailsDataArray removeObjectAtIndex:alertView.tag];
                NSString *TotalMoney=@"";
                for (GiftFeeDetail *models in self.arr_DetailsDataArray) {
                    TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
                }
//                _txf_Acount.text=TotalMoney;
//                NSString *LocalCyAmount=[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")];
//                self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:LocalCyAmount];
                _str_Amount = TotalMoney;
                NSString *LocalCyAmount = [GPUtils decimalNumberMultipWithString:_txf_Amount.text with:[NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000"];
                self.txf_LocalCyAmount.text = [GPUtils transformNsNumber:LocalCyAmount];
                _txf_Amount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:TotalMoney with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
                _txf_InvPmtAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:TotalMoney with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
                [self updateGiftDetailsTableView];
            }

        }else{
            _view_DockView.userInteractionEnabled = YES;
        }
    }
}

-(void)dimsissPDActionView{
    _cho_datelView = nil;
    _DateChooseView = nil;
}

//地址返回
-(void)NewaddressVCDelegatellClickedLoadBtn:(NSArray *)array start:(NSString *)start{
    if ([start isEqualToString:@"32"]) {
        NSDictionary *dic = array[0];
        _str_FDCityType = dic[@"cityType"];
        _str_FDCityCode = dic[@"cityCode"];
        _txf_FDCityName.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
    }else if ([start isEqualToString:@"33"]){
        NSDictionary *dic = array[0];
        _str_FACityType = dic[@"cityType"];
        _str_FACityCode = dic[@"cityCode"];
        _txf_FACityName.text = [self.userdatas.language isEqualToString:@"ch"]?dic[@"cityName"]:[NSString isEqualToNull:dic[@"cityNameEn"]]?dic[@"cityNameEn"]:dic[@"cityName"];
    }else{
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
}

-(void)chooseTime{
    _datePicker = [[UIDatePicker alloc]init];
    NSString *dateStr;
    if (_selectDataType==1) {
        if ([NSString isEqualToNull:_model_AllowanceFromDate.txf_TexfField.text]) {
            dateStr=_model_AllowanceFromDate.txf_TexfField.text;
            _selectDataString=_model_AllowanceFromDate.txf_TexfField.text;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr=currStr;
            _selectDataString=currStr;
        }
    }else{
        if ([NSString isEqualToNull:_model_AllowanceToDate.txf_TexfField.text]) {
            dateStr=_model_AllowanceToDate.txf_TexfField.text;
            _selectDataString=_model_AllowanceToDate.txf_TexfField.text;
        }else{
            NSDate *pickerDate = [NSDate date];
            NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
            [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
            NSString *currStr= [pickerFormatter stringFromDate:pickerDate];
            dateStr=currStr;
            _selectDataString=currStr;
        }
    }
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    _datePicker.date=fromdate;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[self.userdatas.language isEqualToString:@"ch"] ? @"zh_CN":@"en"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    
    UILabel *lbl=[GPUtils createLable:CGRectMake(0, 0,ScreenRect.size.width, 40)];
    lbl.text=Custing(@"日期", nil);
    lbl.font=Font_cellContent_16;
    lbl.textColor=Color_cellTitle;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.backgroundColor = [GPUtils colorHString:ColorBanground];
    [view addSubview:lbl];
    
    UIButton *sureDataBtn=[GPUtils createButton:CGRectMake(Main_Screen_Width-50, 0, 40, 40) action:@selector(btnClick:) delegate:self title:Custing(@"确定", nil)  font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    sureDataBtn.tag=12;
    [view addSubview:sureDataBtn];
    
    UIButton *cancelDataBtn=[GPUtils createButton:CancelBtnFrame action:@selector(btnClick:) delegate:self title:Custing(@"取消",nil) font:Font_Same_14_20 titleColor:Color_Blue_Important_20];
    cancelDataBtn.tag = 14;
    [view addSubview:cancelDataBtn];
    
    if (!_DateChooseView) {
        _DateChooseView=[[chooseTravelDateView alloc]initWithFrame:CGRectMake(0, ApplicationDelegate.window.bounds.size.height, 0, _datePicker.frame.size.height+40) pickerView:_datePicker titleView:view];
        _DateChooseView.delegate = self;
    }
    
    [_DateChooseView showUpView:_datePicker];
    [_datePicker addTarget:self action:@selector(DateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==12){//确定选择日期
        if (_selectDataString) {
            if (_selectDataType==1) {
                _model_AllowanceFromDate.txf_TexfField.text =_selectDataString;
                _model_AllowanceFromDate.Value = _selectDataString;
                if ([self.str_expenseCode_tag isEqualToString:@"Allowance"] && [[self getStandardAmountWithKey:@"basis"]floatValue]==4) {
                    [self requestGetExpStdUpdateView];
                }
                if ([NSString isEqualToNull:self.model_AllowanceFromDate.txf_TexfField.text]&&[NSString isEqualToNull:self.model_AllowanceToDate.txf_TexfField.text]) {
                    if ([NSDate CompareDateStartTime:self.model_AllowanceFromDate.txf_TexfField.text endTime:self.model_AllowanceToDate.txf_TexfField.text WithFormatter:@"yyyy/MM/dd"]<=0) {
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"开始时间不能小于结束时间", nil) duration:1.5];
                        self.model_AllowanceFromDate.txf_TexfField.text = self.model_AllowanceToDate.txf_TexfField.text;
                        self.model_AllowanceFromDate.Value = self.model_AllowanceToDate.txf_TexfField.text;
                    }else{
                        if (_txf_Day!=nil) {
                            _txf_Day.text =[NSString stringWithFormat:@"%.2f",[NSDate CompareDateStartTime:[self.model_AllowanceFromDate.txf_TexfField.text substringToIndex:10] endTime:[self.model_AllowanceToDate.txf_TexfField.text substringToIndex:10] WithFormatter:@"yyyy/MM/dd"]/(60*60*24)+1];
                        }
                    }
                }
            }else{
                
                _model_AllowanceToDate.txf_TexfField.text =_selectDataString;
                self.model_AllowanceToDate.Value = _selectDataString;
                if ([NSString isEqualToNull:self.model_AllowanceFromDate.txf_TexfField.text]&&[NSString isEqualToNull:self.model_AllowanceToDate.txf_TexfField.text]) {
                    if ([NSDate CompareDateStartTime:self.model_AllowanceFromDate.txf_TexfField.text endTime:self.model_AllowanceToDate.txf_TexfField.text WithFormatter:@"yyyy/MM/dd"]>=0) {
                        if (_txf_Day!=nil) {
                            _txf_Day.text =[NSString stringWithFormat:@"%.2f",[NSDate CompareDateStartTime:[self.model_AllowanceFromDate.txf_TexfField.text substringToIndex:10] endTime:[self.model_AllowanceToDate.txf_TexfField.text substringToIndex:10] WithFormatter:@"yyyy/MM/dd"]/(60*60*24)+1];;
                            [self updateAllowanceData];
                        }
                    }else{
                        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"结束时间不能小于开始时间", nil) duration:1.5];
                        self.model_AllowanceToDate.txf_TexfField.text = self.model_AllowanceFromDate.txf_TexfField.text;
                        self.model_AllowanceToDate.Value = self.model_AllowanceFromDate.txf_TexfField.text;
                    }
                }
            }
        }
        [_DateChooseView remove];
    }else if (btn.tag == 14){
        [_DateChooseView remove];
        _DateChooseView = nil;
        _datePicker = nil;
    }
    
}
-(void)DateChanged:(UIDatePicker *)sender{
    NSDate * pickerDate = [_datePicker date];
    NSDateFormatter * pickerFormatter = [[NSDateFormatter alloc]init];
    [pickerFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString * str = [pickerFormatter stringFromDate:pickerDate];
    _selectDataString=str;
}

-(void)ReplExpenseClick{
    STPickerCategory *pickerArea = [[STPickerCategory alloc]init];
    pickerArea.typeTitle=Custing(@"费用类别", nil);
    pickerArea.DateSourceArray=[NSMutableArray arrayWithArray:self.arr_ReplCategoryArr];
    CostCateNewSubModel *model=[[CostCateNewSubModel alloc]init];
    self.int_ReplClick=1;
    model.expenseCode=self.str_ReplExpenseCode;
    pickerArea.CateModel=model;
    [pickerArea UpdatePickUI];
    [pickerArea setContentMode:STPickerContentModeBottom];
    __weak typeof(self) weakSelf = self;
    [pickerArea setChooseCateBlock:^(CostCateNewModel *firstModel, CostCateNewSubModel *secondModel) {
        if (![secondModel.expenseCode isEqualToString:weakSelf.str_ReplExpenseCode]) {
            weakSelf.str_ReplExpenseCode=secondModel.expenseCode;
            weakSelf.str_ReplExpenseType=secondModel.expenseType;
            weakSelf.txf_ReplExpense.text=weakSelf.str_ReplExpenseType;
        }
    }];
    [pickerArea show];
}


-(NSString *)dealWithMealAmountText{
    if ([NSString isEqualToNull:_txf_MealAmount.text]) {
        NSArray *arr=[_txf_MealAmount.text componentsSeparatedByString:@" "];
        return [NSString stringWithFormat:@"%@",arr.lastObject];
    }
    return @"";
}
-(NSString *)getEndMealAmout{
    NSString *mealAmount= [self dealWithMealAmountText];
    if (![NSString isEqualToNull:_str_AllowanceCurrencyCode]) {
        return mealAmount;
    }else if ([_str_AllowanceCurrencyCode isEqualToString:_str_CurrencyCode]) {
        return [GPUtils decimalNumberMultipWithString:mealAmount with:self.txf_ExchangeRate.text];
    }else{
        return  [GPUtils decimalNumberMultipWithString:mealAmount with:_str_AllowanceCurrencyRate];
    }
    return @"";
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
            standard = nil;
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

-(NSMutableArray *)arr_AllowType{
    if (_arr_AllowType==nil) {
        _arr_AllowType=[NSMutableArray array];
        NSArray *type=@[Custing(@"一天餐补", nil),Custing(@"半天餐补", nil)];
        NSArray *code=@[@"1",@"0"];
        for (int i=0; i<type.count; i++) {
            STOnePickModel *model=[[STOnePickModel alloc]init];
            model.Type=type[i];
            model.Id=code[i];
            [_arr_AllowType addObject:model];
        }
    }
    return _arr_AllowType;
}
-(void)clearCateData{
    self.str_BranchId = @"";
    self.str_LocationId =@"";
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
-(void)checkInDiDiData{
    if (_model_didi) {
        
        if ([NSString isEqualToNull:_model_didi.reimbursementTypId]) {
            if (self.arr_ClaimType.count > 0) {
                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"Id MATCHES %@", [NSString stringWithFormat:@"%@",_model_didi.reimbursementTypId]];
                NSArray *filterArray = [self.arr_ClaimType filteredArrayUsingPredicate:pred1];
                if (filterArray.count > 0) {
                    STOnePickModel *model1 = filterArray[0];
                    _str_ClaimType = model1.Id;
                    _txf_ClaimType.text = model1.Type;
                }else{
                    _str_ClaimType = @"1";
                    _txf_ClaimType.text = Custing(@"差旅费", nil);
                }
            }else{
                _str_ClaimType = @"1";
                _txf_ClaimType.text = Custing(@"差旅费", nil);
            }
        }else{
            _str_ClaimType = @"1";
            _txf_ClaimType.text = Custing(@"差旅费", nil);
        }
        
        
        [_sub_Expense setCateImg:[NSString isEqualToNull:_model_didi.expenseIcon]?_model_didi.expenseIcon:@"15"];
        _img_ExpenseCode.image = [UIImage imageNamed:[NSString isEqualToNull:_model_didi.expenseIcon]?_model_didi.expenseIcon:@"15"];
        _txf_ExpenseCode.text = [GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",_model_didi.expenseCat],[NSString stringWithFormat:@"%@",_model_didi.expenseType]]];
        
        _str_ExpenseCat = [NSString stringWithIdOnNO:_model_didi.expenseCat];
        _str_ExpenseCatCode = [NSString stringWithIdOnNO:_model_didi.expenseCatCode];
        _str_expenseCode = [NSString stringWithIdOnNO:_model_didi.expenseCode];
        _str_expenseIcon = [NSString stringWithIdOnNO:_model_didi.expenseIcon];
        
        _txf_TransDCityName.text = [NSString stringWithIdOnNO:_model_didi.start_name];;
        _txf_TransACityName.text = [NSString stringWithIdOnNO:_model_didi.end_name];;
        _txf_TaxiDCityName.text = [NSString stringWithIdOnNO:_model_didi.start_name];
        _txf_TaxiACityName.text = [NSString stringWithIdOnNO:_model_didi.end_name];
        _txv_Remark.text = [NSString stringWithIdOnNO:_model_didi.remark];
        
        
//        if ([[NSString stringWithFormat:@"%@",_model_didi.pay_type]isEqualToString:@"1"]) {
//            _model_PayTypeId.Id = @"1";
//            _model_PayTypeId.txf_TexfField.text = Custing(@"个人支付", nil);
//            _txf_Amount.text = [NSString stringWithIdOnNO:_model_didi.personal_real_pay];
//
//        }else{
//            _model_PayTypeId.Id = @"2";
//            _model_PayTypeId.txf_TexfField.text = Custing(@"企业支付", nil);
//            _txf_Amount.text = [NSString stringWithIdOnNO:_model_didi.company_real_pay];
//        }
        if ([[NSString stringWithFormat:@"%@",self.str_payType]isEqualToString:@"1"]) {
            _model_PayTypeId.Id = @"1";
            _model_PayTypeId.txf_TexfField.text = Custing(@"个人支付", nil);
            _txf_Amount.text = [NSString stringWithIdOnNO:_model_didi.personal_real_pay];
            
        }else if([[NSString stringWithFormat:@"%@",self.str_payType]isEqualToString:@"0"]){
            _model_PayTypeId.Id = @"2";
            _model_PayTypeId.txf_TexfField.text = Custing(@"企业支付", nil);
            _txf_Amount.text = [NSString stringWithIdOnNO:_model_didi.company_real_pay];
        }else if ([[NSString stringWithFormat:@"%@",self.str_payType]isEqualToString:@""]){
            _model_PayTypeId.Id = @"2";
            _model_PayTypeId.txf_TexfField.text = Custing(@"企业支付", nil);
            _txf_Amount.text = [GPUtils decimalNumberAddWithString:[NSString stringWithIdOnNO:_model_didi.company_real_pay] with:[NSString stringWithIdOnNO:_model_didi.personal_real_pay]];
        }
        
        _txf_LocalCyAmount.text = [self getLocalCyAmount];
        
        NSString *departureTime = [[NSString stringWithIdOnNO:_model_didi.departure_time] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        NSString *departureDay = departureTime.length >10 ? [departureTime substringToIndex:10]:@"";
        NSString *departureHour = departureTime.length >16 ? [departureTime substringToIndex:16]:@"";
        
        
        NSString *finishTime = [[NSString stringWithIdOnNO:_model_didi.finish_time] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        NSString *finishDay = finishTime.length >10 ? [finishTime substringToIndex:10]:@"";
        NSString *finishHour =finishTime.length >16 ? [finishTime substringToIndex:16]:@"";
        
        if (_int_TransTimeType==1) {
            _txf_TransFromDate.text = departureDay;
            _txf_TransToDate.text = finishDay;
        }else{
            _txf_TransFromDate.text = departureHour;
            _txf_TransToDate.text = finishHour;
            
        }
        _txf_TaxiFromDate.text = departureHour;
        _txf_TaxiToDate.text = finishHour;
        
        if ([NSString isEqualToNull:departureDay]) {
            _txf_ExpenseDate.text = departureDay;
        }
        
    }
}

-(void)dealSelfDriverAmount{
    if ([[self getStandardAmountWithKey:@"basis"]floatValue] == 3) {
        if ([self.dict_Standard[@"getStdPrivateCar"]isKindOfClass:[NSDictionary class]]) {
            NSDictionary *getStdPrivateCar = self.dict_Standard[@"getStdPrivateCar"];
            _txf_CarStd.text = [NSString stringWithIdOnNO:getStdPrivateCar[@"fuelConsumption"]];
            NSString *fuelAmount = [GPUtils decimalNumberMultipWithString:self.txf_OilPrice.text with:_txf_CarStd.text];
            fuelAmount = [GPUtils decimalNumberMultipWithString:self.txf_Mileage.text with:fuelAmount];
            fuelAmount = [GPUtils decimalNumberDividingWithString:fuelAmount with:@"100"];
            _txf_FuelBills.text = [GPUtils getRoundingOffNumber:fuelAmount afterPoint:2];
            NSString *amount = [GPUtils decimalNumberAddWithString:_txf_Pontage.text with:_txf_ParkingFee.text];
            amount = [GPUtils decimalNumberAddWithString:_txf_FuelBills.text with:amount];
            _txf_Amount.text =  [GPUtils getRoundingOffNumber:amount afterPoint:2];
            _txf_LocalCyAmount.text = [self getLocalCyAmount];
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
    }else{
        if (_arr_stdSelfDriveDtoList.count>0) {
            _txf_CarStd.text = [self returnSelfCarAmount:_txf_Mileage.text];
        }
        _txf_FuelBills.text = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:_txf_Mileage.text with:_txf_CarStd.text] afterPoint:2];
        NSString *amount = [GPUtils decimalNumberAddWithString:_txf_Pontage.text with:_txf_ParkingFee.text];
        amount = [GPUtils decimalNumberAddWithString:_txf_FuelBills.text with:amount];
        _txf_Amount.text =  [GPUtils getRoundingOffNumber:amount afterPoint:2];
        _txf_LocalCyAmount.text = [self getLocalCyAmount];
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


//MARK:创建分摊d头尾视图
-(void)createShareHeadFootView{
    __weak typeof(self) weakSelf = self;
    SubmitFormView *view=[[SubmitFormView alloc]initWithBaseView:_View_shareTableOpen WithSwitch:[[UISwitch alloc]init] WithString:Custing(@"开启费用分摊", nil) WithInfo:self.array_shareData.count WithTips:nil];
    [view.lab_title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110));
    }];
    view.viewClickedBackBlock = ^(id object) {
        if ([object floatValue] == 1) {
            AddReimShareModel *model = [[AddReimShareModel alloc]init];
            [weakSelf.array_shareData addObject:model];
        }else{
            [weakSelf.array_shareData removeAllObjects];
            weakSelf.str_shareRatio = @"0";
            weakSelf.str_shareTotal = @"0";
        }
        [weakSelf updateShareTableView];
    };
    [_View_shareTableOpen addSubview:view];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 100)];
    footView.userInteractionEnabled = YES;
    UILabel *ratioLab = [GPUtils createLable:CGRectMake(12, 0, Main_Screen_Width/3-12, 50) text:Custing(@"按比例分摊", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentLeft];
    ratioLab.userInteractionEnabled = YES;
    [ratioLab bk_whenTapped:^{
        [weakSelf dealShareAllContentDataWithType:1];
        [weakSelf.View_shareTable reloadData];
    }];
    [footView addSubview:ratioLab];
    
    UILabel *averageLab = [GPUtils createLable:CGRectMake(Main_Screen_Width/3, 0, Main_Screen_Width/3, 50) text:Custing(@"平均分摊", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
    averageLab.userInteractionEnabled = YES;
    [averageLab bk_whenTapped:^{
        [weakSelf dealShareAllContentDataWithType:2];
        [weakSelf.View_shareTable reloadData];
    }];
    [footView addSubview:averageLab];
    
    UILabel *addLab = [GPUtils createLable:CGRectMake(Main_Screen_Width/3*2, 0, Main_Screen_Width/3-12, 50) text:Custing(@"添加分摊", nil) font:Font_Important_15_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentRight];
    addLab.userInteractionEnabled = YES;
    [addLab bk_whenTapped:^{
        AddReimShareModel *model = [[AddReimShareModel alloc]init];
        [weakSelf.array_shareData addObject:model];
        [weakSelf updateShareTableView];
    }];
    [footView addSubview:addLab];
    
    
    UILabel *totol=[GPUtils createLable:CGRectMake(12, 50, XBHelper_Title_Width, 50) text:Custing(@"合计 :", nil)  font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    [footView addSubview:totol];
    
    self.lab_sharePercent = [GPUtils createLable:CGRectMake(12+XBHelper_Title_Width+10, 50, Main_Screen_Width-12-XBHelper_Title_Width-10-12, 50) text:[NSString stringWithFormat:@"%@(%@%%)",[NSString isEqualToNull:self.str_shareTotal]?self.str_shareTotal:@"0",[NSString isEqualToNull:self.str_shareRatio]?self.str_shareRatio:@"0"] font:Font_Important_15_20 textColor:[self.str_shareRatio floatValue] > 100 ? Color_Red_Weak_20:Color_form_TextField_20 textAlignment:NSTextAlignmentLeft];
    [footView addSubview:self.lab_sharePercent];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 50, Main_Screen_Width-12, 0.5)];
    line.backgroundColor = Color_LineGray_Same_20;
    [footView addSubview:line];
    _View_shareTable.tableFooterView = footView;
    
    [_View_shareTable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(150);
    }];
}

#pragma mark-创建礼品费tableView头视图
-(void)createHeadViewWithSection:(NSInteger)section{
    _View_Head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [_View_Head addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [_View_Head addSubview:titleLabel];
    
    if (self.arr_DetailsDataArray.count==1) {
        titleLabel.text=Custing(@"礼品费明细", nil);
    }else{
        titleLabel.text=[NSString stringWithFormat:@"%@(%ld)",Custing(@"礼品费明细", nil),(long)section+1];
        if (section!=0) {
            UIButton *deleteBtn=[GPUtils createButton:CGRectMake(0, 0, 50, 30) action:@selector(deleteDetails:) delegate:self title:Custing(@"删除", nil) font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
            deleteBtn.center=CGPointMake(Main_Screen_Width-15-25, 13.5);
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            deleteBtn.tag=1200+section;
            [_View_Head addSubview:deleteBtn];
        }
    }
    _View_Head.backgroundColor=Color_White_Same_20;
}
//MARK:更新费用分摊TableView
-(void)updateShareTableView{
    self.lab_sharePercent.text = [NSString stringWithFormat:@"%@(%@%%)",[NSString isEqualToNull:self.str_shareTotal]?self.str_shareTotal:@"0",[NSString isEqualToNull:self.str_shareRatio]?self.str_shareRatio:@"0"];
    self.lab_sharePercent.textColor = [self.str_shareRatio floatValue] > 100 ? Color_Red_Weak_20:Color_form_TextField_20;
    
    if (self.array_shareData.count > 0) {
        NSInteger height = self.array_shareData.count * (self.array_shareForm.count * 50 + 27) + 100;
        [_View_shareTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
    }else{
        [_View_shareTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    }
    [self.View_shareTable reloadData];
}

//MARK:更新礼品费明细
-(void)updateGiftDetailsTableView{
    [_View_GiftDetailsTable updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.arr_DetailsArray.count*42+27)*self.arr_DetailsDataArray.count));
    }];
    [_View_GiftDetailsTable reloadData];
}
//MARK:更新增加按钮
-(void)updateAddGiftDetailsView{
    
    SubmitFormView *view=[[SubmitFormView alloc]initAddBtbWithBaseView:_View_AddGiftDetails withTitle:Custing(@"增加明细", nil) withTitleAlignment:1 withImageArray:@[@"commom_addDetails_Icon"] withBtnLocation:1 withlineStyle:0];
    __weak typeof(self) weakSelf = self;
    [view setFormClickedBlock:^(MyProcurementModel *model) {
        GiftFeeDetail *model1=[[GiftFeeDetail alloc]init];
        [weakSelf.arr_DetailsDataArray addObject:model1];
        [weakSelf updateGiftDetailsTableView];
    }];
    [_View_AddGiftDetails addSubview:view];
//    当待提交的礼品费的时候，隐藏增加按钮
    if (self.arr_DetailsDataArray.count <= 0) {
        _View_AddGiftDetails.alpha = 0;
        [_View_AddGiftDetails mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    }else{
        _View_AddGiftDetails.alpha = 1;
        [_View_AddGiftDetails mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.View_GiftDetailsTable.bottom);
            make.left.right.equalTo(self.view_ContentView);
        }];
    }
}

//MARK:手动输入(type = 0)按比例分摊(type =1)平均分摊(type =2)
-(void)dealShareAllContentDataWithType:(NSInteger)type{
    self.str_shareTotal = @"0";
    self.str_shareRatio = @"0";
    NSString *locAmount = [self getLocalCyAmount];
    for (AddReimShareModel *model in self.array_shareData) {
        if (type == 1) {
            model.Amount = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberDividingWithString:[GPUtils decimalNumberMultipWithString:locAmount with:model.ShareRatio] with:@"100"] afterPoint:2];
        }else if (type == 2){
            model.Amount = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberDividingWithString:locAmount with:[NSString stringWithFormat:@"%lu",(unsigned long)self.array_shareData.count]] afterPoint:2];
            model.ShareRatio = [GPUtils getRoundingOffNumber:[GPUtils decimalNumberMultipWithString:[GPUtils decimalNumberDividingWithString:model.Amount with:locAmount] with:@"100"] afterPoint:2];
        }
        self.str_shareTotal = [GPUtils decimalNumberAddWithString:self.str_shareTotal with:model.Amount];
        self.str_shareRatio = [GPUtils decimalNumberAddWithString:self.str_shareRatio with:model.ShareRatio];
    }
    self.str_shareTotal = [GPUtils getRoundingOffNumber:self.str_shareTotal afterPoint:2];
    self.str_shareRatio = [GPUtils getRoundingOffNumber:self.str_shareRatio afterPoint:2];

    self.lab_sharePercent.text = [NSString stringWithFormat:@"%@(%@%%)",[NSString isEqualToNull:self.str_shareTotal]?self.str_shareTotal:@"0",[NSString isEqualToNull:self.str_shareRatio]?self.str_shareRatio:@"0"];
    self.lab_sharePercent.textColor = [self.str_shareRatio floatValue] > 100 ? Color_Red_Weak_20:Color_form_TextField_20;
}


//MARK:礼品费明细详情填写
-(void)TCompanyNameChange:(UITextField *)text
{
    GiftFeeDetail *model=[self.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        GiftFeeDetail *model=[[GiftFeeDetail alloc]init];
        [self.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.TCompanyName=text.text;
    }else{
        model.TCompanyName=text.text;
    }
}
-(void)TRecipientChange:(UITextField *)text
{
    GiftFeeDetail *model=[self.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        GiftFeeDetail *model=[[GiftFeeDetail alloc]init];
        [self.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.TRecipient=text.text;
    }else{
        model.TRecipient=text.text;
    }
}
-(void)GiftNameChange:(UITextField *)text
{
    GiftFeeDetail *model=[self.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        GiftFeeDetail *model=[[GiftFeeDetail alloc]init];
        [self.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.GiftName=text.text;
    }else{
        model.GiftName=text.text;
    }
}
-(void)RemarkChange:(UITextField *)text
{
    GiftFeeDetail *model=[self.arr_DetailsDataArray objectAtIndex:text.tag-100];
    if (!model) {
        GiftFeeDetail *model=[[GiftFeeDetail alloc]init];
        [self.arr_DetailsDataArray insertObject:model atIndex:text.tag-100];
        model.Remark=text.text;
    }else{
        model.Remark=text.text;
    }
}
-(void)AmountChange:(UITextField *)text
{
    GiftFeeDetail *model=[self.arr_DetailsDataArray objectAtIndex:text.tag-1000];
    if (!model) {
        GiftFeeDetail *model=[[GiftFeeDetail alloc]init];
        [self.arr_DetailsDataArray insertObject:model atIndex:text.tag-1000];
        model.Amount=text.text;
    }else{
        model.Amount=text.text;
    }
    NSString *TotalMoney=@"";
    for (GiftFeeDetail *models in self.arr_DetailsDataArray) {
        TotalMoney=[GPUtils decimalNumberAddWithString:TotalMoney with:models.Amount];
    }
//    _txf_Acount.text=TotalMoney;
//    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
//    _txf_Amount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:_txf_Acount.text with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
//    _txf_Amount.text = TotalMoney;
    _str_Amount = TotalMoney;
    _txf_LocalCyAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString: TotalMoney with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
    _txf_Amount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:TotalMoney with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
    _txf_InvPmtAmount.text = [GPUtils transformNsNumber:[GPUtils decimalNumberMultipWithString:TotalMoney with:([NSString isEqualToNull:self.str_ExchangeRate]?self.str_ExchangeRate:@"1.0000")]];
}
//MARK:删除明细
-(void)deleteDetails:(UIButton *)btn{
    
    [self keyClose];
    NSLog(@"删除明细");
    _Aler_deleteDetils=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%ld?",Custing(@"你确定要删除礼品费明细", nil),(long)(btn.tag-1200+1)] delegate:self cancelButtonTitle:Custing(@"取消",nil) otherButtonTitles:Custing(@"删除",nil), nil];
    _Aler_deleteDetils.tag=btn.tag-1200;
    [_Aler_deleteDetils show];
    
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
