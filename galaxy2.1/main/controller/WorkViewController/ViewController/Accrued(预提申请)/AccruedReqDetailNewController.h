//
//  AccruedReqDetailNewController.h
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
//#import "PaymentExpDetail.h"
#import "AccruedReqDetail.h"
//#import "MyPaymentFormData.h"
#import "AccruedFormData.h"
#import "AccruedDetailViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface AccruedReqDetailNewController : VoiceBaseController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GPClientDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)AccruedFormData *FormDatas;
/**
 *  表单需要的一些参数
 */
@property (nonatomic,strong)NSDictionary *dict_parameter;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;
/**
 显示信息
 */
@property (nonatomic, strong) NSMutableArray *arr_show;
/**
 数据信息
 */
@property (nonatomic, strong) AccruedReqDetail *AccruedReqDetail;
/**
 币种数组
 */
@property (nonatomic, strong) NSMutableArray *arr_CurrencyCode;
@property (nonatomic, strong) NSDictionary *dict_CurrencyCode;

/**
 税率数组
 */
@property (nonatomic, strong) NSMutableArray *arr_TaxRates;
/**
 发票类型数组
 */
@property (nonatomic, strong) NSMutableArray *arr_New_InvoiceTypes;
/**
 合同选择区分
 */
@property (nonatomic, assign) NSInteger isContractPaymentMethod;
@property (nonatomic, strong) NSString *str_flowGuid;

/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView *scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView *dockView;

/**
 *归属月份undone
 */
@property(nonatomic,strong)UIView *View_AccruedMonth;
@property(nonatomic,strong)UITextField *txf_AccruedMonth;

/**
 *  日期视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDate;
@property(nonatomic,strong)UITextField *txf_ExpenseDate;
/**
 *  发票号码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceNo;
@property(nonatomic,strong)UITextField *txf_InvoiceNo;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
@property (nonatomic,strong)UITextField * txf_Cate;
@property(nonatomic,strong)UIImageView * categoryImage;
/**
 *  费用类别
 */
@property(nonatomic,strong)NSMutableArray * categoryArr;
/**
 *  费用类别是否分级(1/2)
 */
@property(nonatomic,strong)NSString *CateLevel;
/**
 *  费用类型是否打开的
 */
@property(nonatomic,assign)BOOL isOpenGener;
/**
 *  费用类别
 */
@property(nonatomic,assign)NSInteger categoryRows;
/**
 *  费用类别选择视图
 */
@property(nonatomic,strong)UIView *CategoryView;
/**
 *  费用类别collectView
 */
@property(nonatomic,strong)UICollectionView *CategoryCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *CategoryLayOut;
@property(nonatomic,strong)CategoryCollectCell *cell;

/**
 *供应商视图 undone
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
/**
 *预提类型undone
 */
@property(nonatomic,strong)UIView *View_AccruedType;
@property(nonatomic,strong)UITextField *txf_AccruedType;
@property(nonatomic,strong)NSMutableArray *arr_AccruedType;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
@property (nonatomic,strong)GkTextField * txf_Amount;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 发票币种对支付币种汇率视图
 */
@property (nonatomic, strong) UIView *View_InvCyPmtExchangeRate;
@property (nonatomic, strong) UITextField *txf_InvCyPmtExchangeRate;
/**
 付款金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmount;
@property (nonatomic, strong) UITextField *txf_InvPmtAmount;

/**
 *是否专票undone
 */
@property(nonatomic,strong)UIView *View_IsVAT;
@property(nonatomic,strong)UITextField *txf_IsVAT;
/**
 *  发票类型视图
 */
@property(nonatomic,strong)UIView *View_InvoiceType;
@property(nonatomic,strong)UITextField *txf_InvoiceType;
/**
 机票
 */
@property (nonatomic, strong) UIView *View_AirTicketPrice;
@property (nonatomic, strong) GkTextField *txf_AirTicketPrice;
/**
 民航发展基金
 */
@property (nonatomic, strong) UIView *View_DevelopmentFund;
@property (nonatomic, strong) GkTextField *txf_DevelopmentFund;
/**
 燃油附加费
 */
@property (nonatomic, strong) UIView *View_FuelSurcharge;
@property (nonatomic, strong) GkTextField *txf_FuelSurcharge;
/**
 其他税费
 */
@property (nonatomic, strong) UIView *View_OtherTaxes;
@property (nonatomic, strong) GkTextField *txf_OtherTaxes;
/**
 机票和燃油附加费合计视图
 */
@property (nonatomic, strong) UIView *View_AirlineFuelFee;
@property (nonatomic, strong) GkTextField *txf_AirlineFuelFee;
/**
 *  税率视图
 */
@property(nonatomic,strong)UIView *View_TaxRate;
@property(nonatomic,strong)UITextField *txf_TaxRate;
/**
 *  税额视图
 */
@property(nonatomic,strong)UIView *View_Tax;
@property(nonatomic,strong)UITextField *txf_Tax;
/**
 *  不含税金额视图
 */
@property(nonatomic,strong)UIView *View_ExclTax;
@property(nonatomic,strong)UITextField *txf_ExclTax;
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
 *是否有支持材料undone
 */
@property (nonatomic, strong) UIView *View_IsSupportMaterials;
@property (nonatomic, strong) UITextField *txf_IsSupportMaterials;
/**
 类型
 */
@property (nonatomic, strong) UIView *View_CostType;
@property (nonatomic, strong) UITextField *txf_CostType;
@property (nonatomic, strong) NSMutableArray *arr_CostType;
/**
 是否已入库
 */
@property (nonatomic, strong) UIView *View_IsStorage;
@property (nonatomic, strong) UITextField *txf_IsStorage;
@property (nonatomic, copy) MyProcurementModel *model_IsStorage;//是否已入库

/**
 是否预付
 */
@property (nonatomic, strong) UIView *View_IsPrepay;
@property (nonatomic, strong) UITextField *txf_IsPrepay;
/**
 预付开始时间
 */
@property (nonatomic, strong) UIView *View_PrepayStartDate;
@property (nonatomic, strong) UITextField *txf_PrepayStartDate;
@property (nonatomic, copy) MyProcurementModel *model_PrepayStartDate;//预付开始时间

/**
 预付结束时间
 */
@property (nonatomic, strong) UIView *View_PrepayEndDate;
@property (nonatomic, strong) UITextField *txf_PrepayEndDate;
@property (nonatomic, copy) MyProcurementModel *model_PrepayEndDate;//预付结束时间
/**
 是否预提
 */
@property (nonatomic, strong) UIView *View_IsAccruedaccount;
@property (nonatomic, strong) UITextField *txf_IsAccruedaccount;
/**
 *  预提明细列表视图
 */
@property(nonatomic,strong)MulChooseShowView *View_AccruedForm;
/**
 是否政府相关
 */
@property (nonatomic, strong) UIView *View_Government;
@property (nonatomic, strong) UITextField *txf_Government;

/**
 *  合同名称视图
 */
@property(nonatomic,strong)UIView *View_ContName;
@property(nonatomic,strong)UITextField *txf_ContName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  成本中心
 */
@property(nonatomic,strong)UIView *View_CostCenter;
@property(nonatomic,strong)UITextField *txf_CostCenter;
/**
 *  关联费用申请单
 */
@property(nonatomic,strong)MulChooseShowView *View_FeeAppNumber;
@property(nonatomic,strong)UITextField *txf_FeeAppNumber;
/**
 *  是否已结项
*/
@property(nonatomic,strong)UIView *View_IsSettlement;
@property(nonatomic,strong)UITextField *txf_IsSettlement;
/**
 *  辅助核算项
*/
@property(nonatomic,strong)UIView *View_AccountItem;
@property(nonatomic,strong)UITextField *txf_AccountItem;
/**
 *  辅助核算金额
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount;
@property(nonatomic,strong)UITextField *txf_AccountItemAmount;
/**
 *  辅助核算项2
*/
@property(nonatomic,strong)UIView *View_AccountItem2;
@property(nonatomic,strong)UITextField *txf_AccountItem2;
/**
 *  辅助核算金额2
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount2;
@property(nonatomic,strong)UITextField *txf_AccountItemAmount2;
/**
 *  辅助核算项3
*/
@property(nonatomic,strong)UIView *View_AccountItem3;
@property(nonatomic,strong)UITextField *txf_AccountItem3;
/**
 *  辅助核算金额3
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount3;
@property(nonatomic,strong)UITextField *txf_AccountItemAmount3;
/**
 *  是否境外视图
 */
@property(nonatomic,strong)UIView *View_Overseas;
@property(nonatomic,strong)UITextField *txf_Overseas;
/**
 *  国别视图
 */
@property(nonatomic,strong)UIView *View_Nationality;
@property(nonatomic,strong)UITextField *txf_Nationality;
/**
 *  交易代码视图
 */
@property(nonatomic,strong)UIView *View_TransactionCode;
@property(nonatomic,strong)UITextField *txf_TransactionCode;
/**
 *  是否手工票据视图
 */
@property(nonatomic,strong)UIView *View_HandmadePaper;
@property(nonatomic,strong)UITextField *txf_HandmadePaper;
/**
 *  费用描述视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDesc;
@property(nonatomic,strong)UITextView *txv_ExpenseDesc;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  附件中图片数组
 */
@property(nonatomic,strong)NSMutableArray *arr_imagesArray;
/**
 *  附件总文件数组
 */
@property(nonatomic,strong)NSMutableArray *arr_totalFileArray;

//1新增2修改
@property (nonatomic, copy) void(^AccruedReqDetailAddEditBlock)(AccruedReqDetail *model, NSInteger type,NSMutableArray *accruedArr);

//type1新增2修改3删除4财务修改
@property(nonatomic,assign)NSInteger type;

@end

NS_ASSUME_NONNULL_END
