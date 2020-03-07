//
//  TravelAppoverController.h
//  galaxy
//
//  Created by hfk on 2017/8/31.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "travelHasSubmitCell.h"
#import "examineViewController.h"
#import "PayMentDetailController.h"
#import "MyApplyModel.h"
#import "NewAddCostApproveViewController.h"
#import "AppoverEditModel.h"
#import "ReimShareMainView.h"
#import "travelReimFormDate.h"

@interface TravelAppoverController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate,ReimShareDelegate,UITextFieldDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)travelReimFormDate *FormDatas;
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
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;
/**
 *  报销金额视图
 */
@property(nonatomic,strong)UIView *View_PrivateAmount;
/**
 *  报销金额视图
 */
@property(nonatomic,strong)UITextField *txf_PrivateAmount;
/**
 费用币种金额汇总
 */
@property (nonatomic,strong)BaseFormSumView *CurrencySumView;
/**
 费用汇总
 */
@property (nonatomic,strong)BaseFormSumView *CostCateSumView;
/**
 *  报销明细视图
 */
@property(nonatomic,strong)UIView *View_Detail;
/**
 *  明细箭头按钮
 */
@property(nonatomic,strong)UIImageView *ImV_DetailClick;
/**
 *  消费记录tableView
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  收款人明细视图
 */
@property(nonatomic,strong)UITableView *View_PayeeTable;
/**
 分摊明细
 */
@property (nonatomic,strong)ReimShareMainView *ReimShareMainView;
/**
 费用分摊部门汇总
 */
@property (nonatomic,strong)BaseFormSumView *ReimShareDeptSumView;
/**
 *  报销类型视图
 */
@property(nonatomic,strong)UIView *View_ClaimType;
/**
 *  报销类型输入框
 */
@property(nonatomic,strong)UITextField *txf_ClaimType;
/**
 *  报销事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  报销事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  受益人视图
 */
@property(nonatomic,strong)UIView *View_Beneficiaries;
/**
 *  受益人txf
 */
@property(nonatomic,strong)UITextField *txf_Beneficiaries;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
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
 *  出差申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_TravelForm;
/**
 出差类型
 */
@property(nonatomic,strong)UIView *View_TravelType;
@property(nonatomic,strong)UITextField *txf_TravelType;
/**
 归口部门
 */
@property(nonatomic,strong)UIView *View_RelevantDept;
@property(nonatomic,strong)UITextField *txf_RelevantDept;
/**
 经费来源
 */
@property(nonatomic,strong)UIView *View_FinancialSource;
@property(nonatomic,strong)UITextField *txf_FinancialSource;
/**
 *  出差期间出发日期
 */
@property(nonatomic,strong)UIView *View_FromDate;
@property(nonatomic,strong)UITextField *txf_FromDate;
/**
 *  出差期间结束日期
 */
@property(nonatomic,strong)UIView *View_ToDate;
@property(nonatomic,strong)UITextField *txf_ToDate;
/**
 *  出发地
 */
@property(nonatomic,strong)UIView *View_FromCity;
@property(nonatomic,strong)UITextField *txf_FromCity;
/**
 *  目的地
 */
@property(nonatomic,strong)UIView *View_ToCity;
@property(nonatomic,strong)UITextField *txf_ToCity;
/**
 *  出差同行人员
 */
@property(nonatomic,strong)UIView *View_FellowOfficers;
/**
 *  出差同行人员txf
 */
@property(nonatomic,strong)UITextField *txf_FellowOfficers;
/**
 *  预计金额视图
 */
@property(nonatomic,strong)UIView *View_Estimated;
/**
 *  预计金额Label
 */
@property(nonatomic,strong)UITextField *txf_Estimated;
/**
 *  超预算原因视图
 */
@property(nonatomic,strong)UIView *View_OverBud;
@property(nonatomic,strong)UITextView *txv_OverBud;
/**
 *  外出申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_StaffOutForm;
/**
 *  用车申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_VehicleForm;
/**
 *  借款单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_BorrowingForm;
/**
 *  减借款视图
 */
@property(nonatomic,strong)UIView *View_Loan;
/**
 *  减借款Label
 */
@property(nonatomic,strong)UITextField *txf_Loan;
/**
 *  应付金额视图
 */
@property(nonatomic,strong)UIView *View_Actual;
/**
 *  应付金额Label
 */
@property(nonatomic,strong)UITextField *txf_Actual;
/**
 *  公司合计金额视图
 */
@property(nonatomic,strong)UIView *View_CompanyAmount;
/**
 *  公司合计金额txf
 */
@property(nonatomic,strong)UITextField *txf_CompanyAmount;
/**
 *  合计金额视图
 */
@property(nonatomic,strong)UIView *View_TotalAmount;
/**
 *  合计金额txf
 */
@property(nonatomic,strong)UITextField *txf_TotalAmount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 *  报销金额大写txf
 */
@property(nonatomic,strong)UITextField *txf_Capitalized;
/**
 *  无发票金额视图
 */
@property(nonatomic,strong)UIView *View_NoInvoice;
/**
 *  无发票金额Label
 */
@property(nonatomic,strong)UITextField *txf_NoInvoice;
/**
 付款减借款视图
 */
@property (nonatomic, strong) UIView *View_InvLoanAmount;
@property (nonatomic, strong) UITextField *txf_InvLoanAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_InvTotalAmount;
@property (nonatomic, strong) UITextField *txf_InvTotalAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_InvActualAmount;
@property (nonatomic, strong) UITextField *txf_InvActualAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 *  单据数量视图
 */
@property(nonatomic,strong)UIView *View_DocumentNum;
/**
 *  单据数量输入框
 */
@property(nonatomic,strong)UITextField *txf_DocumentNum;
/**
 *  结算信息填写视图视图
 */
@property(nonatomic,strong)UITableView *View_PmtMethodTable;
@property(nonatomic,strong)UIView *View_PmtMethodHead;
@property(nonatomic,strong)UIView *View_PmtMethodAdd;
/**
 *  结算信息查看明细视图
 */
@property(nonatomic,strong)UITableView *View_SecDetailsTable;
/**
 *  收款人视图
 */
@property(nonatomic,strong)UIView *View_Payee;
/**
 *  收款人输入框
 */
@property(nonatomic,strong)UITextField *txf_Payee;
/**
 *  收款银行账号视图
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
 *  结算方式视图
 */
@property(nonatomic,strong)UIView *View_PmtMethod;
/**
 *  结算方式输入框
 */
@property(nonatomic,strong)UITextField *txf_PmtMethod;
/**
 *  预算扣除日view
 */
@property(nonatomic,strong)UIView *View_BudgetSubDate;
/**
 *  预算扣除日txf
 */
@property(nonatomic,strong)UITextField *txf_BudgetSubDate;
/**
 *  是否收到发票视图
 */
@property(nonatomic,strong)UIView *View_ReceiptOfInv;
/**
 *  是否收到发票txf
 */
@property(nonatomic,strong)UITextField *txf_ReceiptOfInv;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *Reserved1View;
@property(nonatomic,strong)UIView *Reserved2View;
@property(nonatomic,strong)UIView *Reserved3View;
@property(nonatomic,strong)UIView *Reserved4View;
@property(nonatomic,strong)UIView *Reserved5View;
@property(nonatomic,strong)UIView *Reserved6View;
@property(nonatomic,strong)UIView *Reserved7View;
@property(nonatomic,strong)UIView *Reserved8View;
@property(nonatomic,strong)UIView *Reserved9View;
@property(nonatomic,strong)UIView *Reserved10View;
@property(nonatomic,strong)UITextField *Reserved1TF;
@property(nonatomic,strong)UITextField *Reserved2TF;
@property(nonatomic,strong)UITextField *Reserved3TF;
@property(nonatomic,strong)UITextField *Reserved4TF;
@property(nonatomic,strong)UITextField *Reserved5TF;
@property(nonatomic,strong)UITextField *Reserved6TF;
@property(nonatomic,strong)UITextField *Reserved7TF;
@property(nonatomic,strong)UITextField *Reserved8TF;
@property(nonatomic,strong)UITextField *Reserved9TF;
@property(nonatomic,strong)UITextField *Reserved10TF;
/**
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
@property(nonatomic,strong)UITextField *txf_IsDeptBearExps;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  备注输入框
 */
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  预算视图
 */
@property(nonatomic,strong)UIView *View_Budget;
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
/**
 *  审批人Label
 */
@property(nonatomic,strong)UITextField *txf_Approver;

/**
 *  审批人头像
 */
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITableView *View_table;


@end
