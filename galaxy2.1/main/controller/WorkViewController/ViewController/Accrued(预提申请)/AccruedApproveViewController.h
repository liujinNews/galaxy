//
//  AccruedApproveViewController.h
//  galaxy
//
//  Created by APPLE on 2020/1/4.
//  Copyright © 2020 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "ReimShareMainView.h"
#import "AccruedReqDetailView.h"
//#import "PaymentExpDetailHasController.h"
#import "AccruedReqDetailHasController.h"
#import "PurAndContractDetailView.h"


NS_ASSUME_NONNULL_BEGIN

@interface AccruedApproveViewController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ReimShareDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**
 表单上数据
 */
@property (nonatomic,strong)AccruedFormData *FormDatas;
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
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 * 事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 * 申请类型
 */
@property(nonatomic,strong)UIView *View_AppType;
@property (nonatomic,strong)UITextField *txf_AppType;
@property (nonatomic,copy)NSString *str_AppTypeId;
@property (nonatomic,copy)NSString *str_AppTypeInfo;
@property (nonatomic,strong)NSMutableArray *arr_AppType;
/**
 * 付款类型视图
 */
@property(nonatomic,strong)UIView *View_PaymentType;
@property(nonatomic,strong)UITextField *txf_PaymentType;
/**
 * 关联付款视图
 */
@property(nonatomic,strong)MulChooseShowView *View_RelPay;
/**
 *  金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
@property(nonatomic,strong)GkTextField *txf_Amount;
/**
 *  大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
@property(nonatomic,strong)UITextField *txf_Capitalized;
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
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 付款方式视图
 */
@property (nonatomic, strong) UIView *View_PayMode;
@property (nonatomic, strong) UITextField *txf_PayMode;
/**
 付款银行视图
 */
@property (nonatomic, strong) UIView *View_PayBankName;
@property (nonatomic, strong) UITextField *txf_PayBankName;
/**
 付款日期视图
 */
@property (nonatomic, strong) UIView *View_PaymentDate;
@property (nonatomic, strong) UITextField *txf_PaymentDate;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
@property (nonatomic,strong)UITextField * txf_Cate;
/**
 费用类别是否显示描述
 */
@property (nonatomic, strong) UIView *View_CateSubDesc;
@property (nonatomic, strong) UILabel *lab_CateSubDesc;
/**
 *  费用类别图片
 */
@property(nonatomic,strong)UIImageView * Imv_category;
/**
 *  费用类别选择视图
 */
@property(nonatomic,strong)UIView *CategoryView;
@property(nonatomic,strong)UICollectionView *CategoryCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *CategoryLayOut;
@property(nonatomic,strong)CategoryCollectCell *cell;
/**
 *  费用类别描述视图
 */
@property (nonatomic,strong) UIView *View_ExpenseDesc;
@property (nonatomic,strong) UITextField * txf_ExpenseDesc;
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
 *  费用申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_FeeAppForm;
/**
 *  预计金额视图
 */
@property(nonatomic,strong)UIView *View_Estimated;
@property(nonatomic,strong)UITextField *txf_Estimated;
/**
 *  超预算原因视图
 */
@property(nonatomic,strong)UIView *View_OverBudReason;
@property(nonatomic,strong)UITextView *txv_OverBudReason;
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
@property(nonatomic,strong)UITextField *txf_RelateContTotal;
/**
 *  关联合同/申请单已付金额视图
 */
@property(nonatomic,strong)UIView *View_RelateContPaid;
@property(nonatomic,strong)UITextField *txf_RelateContPaid;
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
@property(nonatomic,strong)UITextField *txf_ContEffectiveDate;
/**
 *合同截止日期视图
 */
@property(nonatomic,strong)UIView *View_ContExpiryDate;
@property(nonatomic,strong)UITextField *txf_ContExpiryDate;
/**
 *合同付款方式视图
 */
@property(nonatomic,strong)UIView *View_ContPmtTyp;
@property(nonatomic,strong)UITextField *txf_ContPmtTyp;
/**
 *项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 项目活动视图
 */
@property (nonatomic, strong) UIView *View_ProjActivity;
@property (nonatomic, strong) UITextField *txf_ProjActivity;
/**
 *  受益人视图
 */
@property(nonatomic,strong)UIView *View_Bnf;
@property(nonatomic,strong)UITextField *txf_Bnf;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
@property(nonatomic,strong)UITextField *txf_Client;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
/**
 *  VMS Code视图
 */
@property(nonatomic,strong)UIView *View_VMSCode;
@property(nonatomic,strong)UITextField *txf_VMSCode;
/**
 *  开户行总行名称视图
 */
@property(nonatomic,strong)UIView *View_BankHeadOffice;
@property(nonatomic,strong)UITextField *txf_BankHeadOffice;
/**
 *  开户行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
@property(nonatomic,strong)UITextField *txf_BankAccount;
/**
 *  开户行网点视图
 */
@property(nonatomic,strong)UIView *View_BankOutlets;
@property(nonatomic,strong)UITextField *txf_BankOutlets;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
@property(nonatomic,strong)UITextField *txf_BankName;
/**
 *  开户行城市视图
 */
@property(nonatomic,strong)UIView *View_BankCity;
@property(nonatomic,strong)UITextField *txf_BankCity;
/**
 *  客户名称视图
 */
@property(nonatomic,strong)UIView *View_IbanClientName;
@property(nonatomic,strong)UITextField *txf_IbanClientName;
/**
 *  客户地址视图
 */
@property(nonatomic,strong)UIView *View_IbanClientAddr;
@property(nonatomic,strong)UITextField *txf_IbanClientAddr;
/**
 *  IbanName视图
 */
@property(nonatomic,strong)UIView *View_IbanName;
@property(nonatomic,strong)UITextField *txf_IbanName;
/**
 *  IbanAccount视图
 */
@property(nonatomic,strong)UIView *View_IbanAccount;
@property(nonatomic,strong)UITextField *txf_IbanAccount;
/**
 *  IbanAddr视图
 */
@property(nonatomic,strong)UIView *View_IbanAddr;
@property(nonatomic,strong)UITextField *txf_IbanAddr;
/**
 *  SwiftCode视图
 */
@property(nonatomic,strong)UIView *View_SwiftCode;
@property(nonatomic,strong)UITextField *txf_SwiftCode;
/**
 *  IbanNo视图
 */
@property(nonatomic,strong)UIView *View_IbanNo;
@property(nonatomic,strong)UITextField *txf_IbanNo;
/**
 *  IbanADDRESS视图
 */
@property(nonatomic,strong)UIView *View_IbanADDRESS;
@property(nonatomic,strong)UITextField *txf_IbanADDRESS;
/**
 * 是否已扣款
 */
@property(nonatomic,strong)UIView *View_IsPayment;
@property(nonatomic,strong)UITextField *txf_IsPayment;
@property(nonatomic,strong)NSMutableArray *arr_IsPayment;
/**
 *  RefInvoiceAmount视图
 */
@property(nonatomic,strong)UIView *View_RefInvoiceAmount;
@property(nonatomic,strong)UITextField *txf_RefInvoiceAmount;
/**
 *  RefInvoiceType视图
 */
@property(nonatomic,strong)UIView *View_RefInvoiceType;
@property(nonatomic,strong)UITextField *txf_RefInvoiceType;
/**
 *  RefTaxRate视图
 */
@property(nonatomic,strong)UIView *View_RefTaxRate;
@property(nonatomic,strong)UITextField *txf_RefTaxRate;
/**
 *  RefTax视图
 */
@property(nonatomic,strong)UIView *View_RefTax;
@property(nonatomic,strong)UITextField *txf_RefTax;
/**
 *  RefExclTax视图
 */
@property(nonatomic,strong)UIView *View_RefExclTax;
@property(nonatomic,strong)UITextField *txf_RefExclTax;
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
@property (nonatomic,strong)AccruedReqDetailView *AccruedReqDetailView;
/**
 *  是否有发票视图
 */
@property(nonatomic,strong)UIView *View_HasInvoice;
@property(nonatomic,strong)UITextField *txf_HasInvoice;
/**
 *  无发票原因视图
 */
@property(nonatomic,strong)UIView *View_NoInvReason;
@property(nonatomic,strong)UITextField *txf_NoInvReason;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  预算视图
 */
@property(nonatomic,strong)UIView *View_Budget;
/**
 *  预算扣除日
 */
@property(nonatomic,strong)UIView *View_BudgetSubDate;
@property(nonatomic,strong)UITextField *txf_BudgetSubDate;
/**
 *  是否收到发票视图
 */
@property(nonatomic,strong)UIView *View_ReceiptOfInv;
@property(nonatomic,strong)UITextField *txf_ReceiptOfInv;
/**
 辅助核算项目
 */
@property(nonatomic,strong)UIView *View_AccountItem;
@property(nonatomic,strong)UITextField *txf_AccountItem;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
@property(nonatomic,strong)UITextField *txf_IsDeptBearExps;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;
/**
 *  附件视图
 */
@property(nonatomic,strong)UIView *View_File;
/**
 签收记录
 */
@property(nonatomic,strong)FormSignInfoView *FormSignInfoView;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
/**
 *  审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  成本中心超预算提示
 */
@property(nonatomic,strong)UITableView *View_table;


@end

NS_ASSUME_NONNULL_END
