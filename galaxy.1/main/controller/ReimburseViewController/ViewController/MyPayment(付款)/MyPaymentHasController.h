//
//  MyPaymentHasController.h
//  galaxy
//
//  Created by hfk on 2018/11/30.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "ReimShareMainView.h"
#import "MyPaymentFormData.h"
#import "PaymentExpDetailHasController.h"
#import "PurAndContractDetailView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPaymentHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyPaymentFormData *FormDatas;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)UIView *contentView;
/**
 *  下部按钮底层视图
 */
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyUpView;
@property(nonatomic,strong)UIView *ReimPolicyDownView;
/**
 *  内容1视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 * 事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 * 付款类型视图
 */
@property(nonatomic,strong)UIView *View_PaymentType;
/**
 * 关联付款视图
 */
@property(nonatomic,strong)MulChooseShowView *View_RelPay;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
/**
 *  大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
/**
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
/**
 付款方式视图
 */
@property (nonatomic, strong) UIView *View_PayMode;
/**
 付款银行视图
 */
@property (nonatomic, strong) UIView *View_PayBankName;
/**
 付款日期视图
 */
@property (nonatomic, strong) UIView *View_PaymentDate;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
/**
 *  费用类别描述视图
 */
@property (nonatomic,strong) UIView *View_ExpenseDesc;
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
 *  费用申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_FeeAppForm;
/**
 *  预计金额视图
 */
@property(nonatomic,strong)UIView *View_Estimated;
/**
 *  超预算原因视图
 */
@property(nonatomic,strong)UIView *View_OverBudReason;
/**
 * 采购申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_PurchaseForm;
/**
 * 采购申请单详情视图
 */
@property(nonatomic,strong)PurAndContractDetailView *View_PurchaseDetail;
/**
 * 关联合同/申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_RelateCont;
/**
 *  关联合同/申请单总金额视图
 */
@property(nonatomic,strong)UIView *View_RelateContTotal;
/**
 *  关联合同/申请单已付金额视图
 */
@property(nonatomic,strong)UIView *View_RelateContPaid;
/**
 *合同名称视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 * 合同付款详情视图
 */
@property(nonatomic,strong)PurAndContractDetailView *View_ContractDetail;
/**
 *合同开始日期视图
 */
@property(nonatomic,strong)UIView *View_ContEffectiveDate;
/**
 *合同截止日期视图
 */
@property(nonatomic,strong)UIView *View_ContExpiryDate;
/**
 *合同付款方式视图
 */
@property(nonatomic,strong)UIView *View_ContPmtTyp;
/**
 *项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 项目活动视图
 */
@property (nonatomic, strong) UIView *View_ProjActivity;
/**
 *  受益人视图
 */
@property(nonatomic,strong)UIView *View_Bnf;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  VMS Code视图
 */
@property(nonatomic,strong)UIView *View_VMSCode;
/**
 *  开户行总行名称视图
 */
@property(nonatomic,strong)UIView *View_BankHeadOffice;
/**
 *  开户行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 *  开户行网点视图
 */
@property(nonatomic,strong)UIView *View_BankOutlets;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
/**
 *  开户行城市视图
 */
@property(nonatomic,strong)UIView *View_BankCity;
/**
 *  客户名称视图
 */
@property(nonatomic,strong)UIView *View_IbanClientName;
/**
 *  客户地址视图
 */
@property(nonatomic,strong)UIView *View_IbanClientAddr;
/**
 *  IbanName视图
 */
@property(nonatomic,strong)UIView *View_IbanName;
/**
 *  IbanAccount视图
 */
@property(nonatomic,strong)UIView *View_IbanAccount;
/**
 *  IbanAddr视图
 */
@property(nonatomic,strong)UIView *View_IbanAddr;
/**
 *  SwiftCode视图
 */
@property(nonatomic,strong)UIView *View_SwiftCode;
/**
 *  IbanNo视图
 */
@property(nonatomic,strong)UIView *View_IbanNo;
/**
 *  IbanADDRESS视图
 */
@property(nonatomic,strong)UIView *View_IbanADDRESS;
/**
 *  RefInvoiceAmount视图
 */
@property(nonatomic,strong)UIView *View_RefInvoiceAmount;
/**
 *  RefInvoiceType视图
 */
@property(nonatomic,strong)UIView *View_RefInvoiceType;
/**
 *  RefTaxRate视图
 */
@property(nonatomic,strong)UIView *View_RefTaxRate;
/**
 *  RefTax视图
 */
@property(nonatomic,strong)UIView *View_RefTax;
/**
 *  RefExclTax视图
 */
@property(nonatomic,strong)UIView *View_RefExclTax;
/**
 分摊明细
 */
@property (nonatomic,strong)ReimShareMainView *ReimShareMainView;
/**
 费用分摊部门汇总
 */
@property (nonatomic,strong)BaseFormSumView *ReimShareDeptSumView;
/**
 费用明细
 */
@property (nonatomic,strong)PaymentExpDetailView *PaymentExpDetailView;
/**
 *  是否有发票视图
 */
@property(nonatomic,strong)UIView *View_HasInvoice;
/**
 *  无发票原因视图
 */
@property(nonatomic,strong)UIView *View_NoInvReason;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 是否收到发票原件
 */
@property(nonatomic,strong)UIView *View_ReceiptOfInv;
@property(nonatomic,strong)UILabel *Lab_ReceiptOfInv;
/**
 辅助核算项目
 */
@property(nonatomic,strong)UIView *View_AccountItem;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  附件视图
 */
@property(nonatomic,strong)UIView *View_File;
/**
 超预算信息
 */
@property(nonatomic,strong)UIView *View_Budget;
/**
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
/**
 *  审批人头像
 */
@property(nonatomic,strong)UIImageView *View_ApproveImg;
/**
 *  审批人Label
 */
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 签收记录
 */
@property(nonatomic,strong)FormSignInfoView *FormSignInfoView;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, strong) UIView *view_line4;
@property (nonatomic, strong) UIView *view_line5;

@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;
@property (nonatomic, assign) NSInteger int_line4;
@property (nonatomic, assign) NSInteger int_line5;




@end

NS_ASSUME_NONNULL_END
