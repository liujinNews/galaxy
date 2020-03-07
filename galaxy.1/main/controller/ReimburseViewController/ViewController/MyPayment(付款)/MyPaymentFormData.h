//
//  MyPaymentFormData.h
//  galaxy
//
//  Created by hfk on 2018/11/30.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "FormBaseModel.h"
#import "MyPaymentData.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyPaymentFormData : FormBaseModel
/**
 消费明细项目信息
 */
@property (nonatomic, strong) NSDictionary *dict_PaymentExpDetailProj;
/**
 付款金额
 */
@property (nonatomic, copy) NSString *str_PaymentAmount;
/**
 付款类型
 */
@property (nonatomic, copy) NSString *str_PayTypeId;
@property (nonatomic, copy) NSString *str_PayType;
/**
 关联付款单
 */
@property (nonatomic, copy) NSString *str_RelPaymentNumber;
@property (nonatomic, copy) NSString *str_RelPaymentInfo;
/**
 关联付款单请求参数(0单次 1多次)
 */
@property(nonatomic,copy)NSString *str_RelatedPaymentType;
/**
 付款方式
 */
@property (nonatomic, copy) NSString *str_PayMode;
@property (nonatomic, copy) NSString *str_PayCode;
@property (nonatomic, strong) NSMutableArray *arr_PayCode;
/**
 财务审核付款银行信息
 */
@property (nonatomic, copy) NSString *str_PayBankName;
@property (nonatomic, copy) NSString *str_PayAccountName;
@property (nonatomic, copy) NSString *str_PayBankAccount;
/**
 费用类别视图是否打开
 */
@property (nonatomic, assign) BOOL bool_isOpenCate;
/**
 费用类别描述
 */
@property (nonatomic, copy) NSString *str_CateSubDesc;

/**
 发票类型 （1增值税专用发票 2增值税普通发票）
 */
@property (nonatomic, copy) NSString *str_InvoiceType;
@property (nonatomic, copy) NSString *str_InvoiceTypeName;
@property (nonatomic, copy) NSString *str_InvoiceTypeCode;
/**
 机票费用相关
 */
@property (nonatomic, copy) NSString *str_AirTicketPrice;
@property (nonatomic, copy) NSString *str_DevelopmentFund;
@property (nonatomic, copy) NSString *str_FuelSurcharge;
@property (nonatomic, copy) NSString *str_OtherTaxes;
/**
 机票和燃油附加费合计
 */
@property (nonatomic, copy) NSString *str_AirlineFuelFee;

/**
 费用申请单
 */
@property (nonatomic, copy) NSString *str_FeeAppNumber;
@property (nonatomic, copy) NSString *str_FeeAppInfo;
/**
 预计金额
 */
@property (nonatomic, copy) NSString *str_EstimatedAmount;
/**
 采购申请单
 */
@property (nonatomic, copy) NSString *str_PurchaseNumber;
@property (nonatomic, copy) NSString *str_PurchaseInfo;
@property (nonatomic, copy) NSString *str_PurAmount;
@property (nonatomic, copy) NSString *str_PurOverAmount;
/**
 关联合同/申请单
 */
@property (nonatomic, copy) NSString *str_RelateContFlowCode;
@property (nonatomic, copy) NSString *str_RelateContNo;
@property (nonatomic, copy) NSString *str_RelateContInfo;
@property (nonatomic, copy) NSString *str_RelateContTotalAmount;
@property (nonatomic, copy) NSString *str_RelateContAmountPaid;
/**
 合同
 */
@property (nonatomic, copy) NSString *str_ContractAppNumber;
@property (nonatomic, copy) NSString *str_ContractName;
@property (nonatomic, copy) NSString *str_ContractNo;
@property (nonatomic, copy) NSString *str_ContractAmount;
@property (nonatomic, copy) NSString *str_ContractOverAmount;
/**
 合同付款方式
 */
@property (nonatomic, copy) NSString *str_ContPmtTyp;
@property (nonatomic, copy) NSString *str_ContPmtTypId;
@property (nonatomic, strong) NSMutableArray *arr_ContPay;
/**
 受益人
 */
@property (nonatomic, copy) NSString *str_BnfId;
@property (nonatomic, copy) NSString *str_BnfName;
/**
 VMSCode
 */
@property (nonatomic, copy) NSString *str_VmsCode;
/**
 开户行网点
 */
@property (nonatomic, copy) NSString *str_BankOutlets;
/**
 开户行行号
 */
@property (nonatomic, copy) NSString *str_BankNo;
/**
 开户行编号
 */
@property (nonatomic, copy) NSString *str_BankCode;
/**
 支行行号
 */
@property (nonatomic, copy) NSString *str_CNAPS;
/**
 省
 */
@property (nonatomic, copy) NSString *str_BankProvinceCode;
@property (nonatomic, copy) NSString *str_BankProvince;
/**
 城市code
 */
@property (nonatomic, copy) NSString *str_BankCityCode;
@property (nonatomic, copy) NSString *str_BankCity;
/**
 关联多个付款单发票类型 （1增值税专用发票 2增值税普通发票）
 */
@property (nonatomic, copy) NSString *str_RefInvoiceType;
@property (nonatomic, copy) NSString *str_RefInvoiceTypeName;
@property (nonatomic, copy) NSString *str_RefInvoiceTypeCode;

/**
 是否有发票
 */
@property (nonatomic, copy) NSString *str_HasInvoice;
/**
 *  发票中图片数组
 */
@property (nonatomic, strong) NSMutableArray *arr_filesArray;
/**
 *  发票总文件数组
 */
@property (nonatomic, strong) NSMutableArray *arr_TolfilesArray;
/**
 辅助核算项目
 */
@property (nonatomic, copy) NSString *str_AccountItemCode;
@property (nonatomic, copy) NSString *str_AccountItem;
/**
 记录是否收到发票
 */
@property (nonatomic, copy) NSString *str_ReceiptOfInv;
/**
 费用分摊是否必须
 */
@property (nonatomic, assign) BOOL bool_isPaymentShareRequire;//（1是0否）
/**
  合同付款方式
 */
@property (nonatomic, assign) NSInteger int_isContractPaymentMethod;//(0合同付款 1 合同分期付款)
/**
 合同付款(已付款的信息)
 */
@property (nonatomic, strong) ChooseCateFreModel *model_ContractHas;
/**
 是否是同一个分期付款合同
 */
@property (nonatomic, assign) BOOL bool_isSameContract;
/**
 付款金额和合同金额是否完全一致（0一致，1不一致） yes不一样可以提交  NO不能提交
 */
@property (nonatomic, assign) BOOL bool_IsSameAmount;
/**
 是否外币(是否显示外币信息)
 */
@property (nonatomic, assign) BOOL bool_isForeign;

/**
 付款合同详情数组
 */
@property (nonatomic, strong) NSMutableArray *arr_paymentContDetailDtoList;
/**
 付款采购详情数组
 */
@property (nonatomic, strong) NSMutableArray *arr_paymentPurDetails;
/**
 是否是财务
 */
@property (nonatomic, assign) BOOL bool_isCashier;
/**
 开户行信息
 */
@property (nonatomic, copy) NSString *str_DepositBank;
@property (nonatomic, copy) NSString *str_BankAccount;


/**
 * 拼接数据
 */
@property (nonatomic, strong) MyPaymentData *SubmitData;

//表单初始化
-(instancetype)initWithStatus:(NSInteger)status;
//获取表单打开接口
-(NSString *)OpenFormUrl;
//处理表单数据
-(void)DealWithFormBaseData;
/**
 获取表名
 */
-(NSString *)getTableName;
/**
 获取关联合同
 */
-(NSString *)getContractFormsUrl;
-(NSDictionary *)getContractFormsParame;
-(void )dealContractFormsWithDict:(NSDictionary *)responceDic;



@end

NS_ASSUME_NONNULL_END
