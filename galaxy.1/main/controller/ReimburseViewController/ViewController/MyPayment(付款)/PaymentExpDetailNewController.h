//
//  PaymentExpDetailNewController.h
//  galaxy
//
//  Created by hfk on 2018/11/13.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "PaymentExpDetail.h"
#import "MyPaymentFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentExpDetailNewController : VoiceBaseController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GPClientDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyPaymentFormData *FormDatas;
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
@property (nonatomic, strong) PaymentExpDetail *PaymentExpDetail;
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
@property (nonatomic, copy) void(^PaymentExpDetailAddEditBlock)(PaymentExpDetail *model, NSInteger type);

//type1新增2修改3删除4财务修改
@property(nonatomic,assign)NSInteger type;


@end

NS_ASSUME_NONNULL_END
