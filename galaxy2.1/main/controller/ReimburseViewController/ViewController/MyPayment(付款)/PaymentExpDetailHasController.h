//
//  PaymentExpDetailHasController.h
//  galaxy
//
//  Created by hfk on 2018/11/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "PaymentExpDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentExpDetailHasController : VoiceBaseController<UIScrollViewDelegate>
/**
 显示信息
 */
@property (nonatomic, strong) NSMutableArray *arr_show;
/**
 数据信息
 */
@property (nonatomic, strong) PaymentExpDetail *PaymentExpDetail;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView *scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  日期视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDate;
/**
 *  发票号码视图
 */
@property(nonatomic,strong)UIView *View_InvoiceNo;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
/**
 发票币种对支付币种汇率视图
 */
@property (nonatomic, strong) UIView *View_InvCyPmtExchangeRate;
/**
 付款金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmount;
/**
 *  发票类型视图
 */
@property(nonatomic,strong)UIView *View_InvoiceType;
/**
 机票
 */
@property (nonatomic, strong) UIView *View_AirTicketPrice;
/**
 民航发展基金
 */
@property (nonatomic, strong) UIView *View_DevelopmentFund;
/**
 燃油附加费
 */
@property (nonatomic, strong) UIView *View_FuelSurcharge;
/**
 其他税费
 */
@property (nonatomic, strong) UIView *View_OtherTaxes;
/**
 机票和燃油附加费合计视图
 */
@property (nonatomic, strong) UIView *View_AirlineFuelFee;
/**
 *  税率视图
 */
@property(nonatomic,strong)UIView *View_TaxRate;
/**
 *  税额视图
 */
@property(nonatomic,strong)UIView *View_Tax;
/**
 *  不含税金额视图
 */
@property(nonatomic,strong)UIView *View_ExclTax;
/**
 付款税额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtTax;
/**
 付款不含税金额视图
 */
@property (nonatomic, strong) UIView *View_InvPmtAmountExclTax;
/**
 类型
 */
@property (nonatomic, strong) UIView *View_CostType;
/**
 是否已入库
 */
@property (nonatomic, strong) UIView *View_IsStorage;
/**
 是否预付
 */
@property (nonatomic, strong) UIView *View_IsPrepay;
/**
 预付开始时间
 */
@property (nonatomic, strong) UIView *View_PrepayStartDate;
/**
 预付结束时间
 */
@property (nonatomic, strong) UIView *View_PrepayEndDate;
/**
 是否预提
 */
@property (nonatomic, strong) UIView *View_IsAccruedaccount;

@property (nonatomic, strong) NSMutableArray *accruedArr;
/**
 *  预提明细列表视图
 */
@property(nonatomic,strong)MulChooseShowView *View_AccruedForm;
/**
 是否政府相关
 */
@property (nonatomic, strong) UIView *View_Government;
/**
 *  合同名称视图
 */
@property(nonatomic,strong)UIView *View_ContName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  成本中心
 */
@property(nonatomic,strong)UIView *View_CostCenter;
/**
 *  关联费用申请单
 */
@property(nonatomic,strong)MulChooseShowView *View_FeeAppNumber;
/**
 *  是否已结项
*/
@property(nonatomic,strong)UIView *View_IsSettlement;
/**
 *  辅助核算项
*/
@property(nonatomic,strong)UIView *View_AccountItem;
/**
 *  辅助核算金额
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount;
/**
 *  辅助核算项2
*/
@property(nonatomic,strong)UIView *View_AccountItem2;
/**
 *  辅助核算金额2
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount2;
/**
 *  辅助核算项3
*/
@property(nonatomic,strong)UIView *View_AccountItem3;
/**
 *  辅助核算金额3
*/
@property(nonatomic,strong)UIView *View_AccountItemAmount3;
/**
 *  是否境外视图
 */
@property(nonatomic,strong)UIView *View_Overseas;
/**
 *  国别视图
 */
@property(nonatomic,strong)UIView *View_Nationality;
/**
 *  交易代码视图
 */
@property(nonatomic,strong)UIView *View_TransactionCode;
/**
 *  是否手工票据视图
 */
@property(nonatomic,strong)UIView *View_HandmadePaper;
/**
 *  费用描述视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDesc;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
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


@property (nonatomic, copy) void(^PaymentExpDetailAddEditBlock)(PaymentExpDetail *model, NSInteger type);

@end

NS_ASSUME_NONNULL_END
