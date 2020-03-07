//
//  travelHasSubmitController.h
//  galaxy
//
//  Created by hfk on 16/5/1.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "travelHasSubmitCell.h"
#import "NewLookAddCostViewController.h"
#import "examineViewController.h"
#import "PayMentDetailController.h"
#import "MyApplyModel.h"
#import "BudgetInfoController.h"
#import "ReimShareMainView.h"
#import "travelReimFormDate.h"
#import "BaseFormSumView.h"




@interface travelHasSubmitController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 *  申请人相关视图
 */
@property(nonatomic,strong)UIView *View_Requestor;
@property (nonatomic, assign) NSInteger int_RequestorLine;//申请人底下是否有线
/**
 *  报销金额视图
 */
@property(nonatomic,strong)UIView *View_PriveateAmount;
/**
 *  减借款视图
 */
@property(nonatomic,strong)UIView *View_LoanAmount;
/**
 *  应付金额视图
 */
@property(nonatomic,strong)UIView *View_ActualAmount;
/**
 *  公司合计金额视图
 */
@property(nonatomic,strong)UIView *View_CompanyAmount;

/**
 *  合计金额视图
 */
@property(nonatomic,strong)UIView *View_TotalAmount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 *  无发票金额视图
 */
@property(nonatomic,strong)UIView *View_NoInvoice;
/**
 付款减借款视图
 */
@property (nonatomic, strong) UIView *View_InvLoanAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_InvTotalAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_InvActualAmount;
/**
 付款总金额视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 费用币种金额汇总
 */
@property (nonatomic,strong)BaseFormSumView *CurrencySumView;
/**
 费用汇总
 */
@property (nonatomic,strong)BaseFormSumView *CostCateSumView;
/**
 *  消费记录视图
 */
@property(nonatomic,strong)UITableView *View_CustomTable;
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
@property (nonatomic,strong)UIView *View_ClaimType;
/**
 *  报销事由视图
 */
@property (nonatomic,strong)UIView *View_Reason;
/**
 *  提交人信息视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  受益人视图
 */
@property (nonatomic,strong)UIView *View_Beneficiaries;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  出差申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_TravelForm;
/**
 出差类型
 */
@property(nonatomic,strong)UIView *View_TravelType;
/**
 归口部门
 */
@property(nonatomic,strong)UIView *View_RelevantDept;
/**
 经费来源
 */
@property(nonatomic,strong)UIView *View_FinancialSource;
/**
 *  出差期间出发日期
 */
@property(nonatomic,strong)UIView *View_FromDate;
/**
 *  出差期间结束日期
 */
@property(nonatomic,strong)UIView *View_ToDate;
/**
 *  出发地
 */
@property(nonatomic,strong)UIView *View_FromCity;
/**
 *  目的地
 */
@property(nonatomic,strong)UIView *View_ToCity;
/**
 *  出差同行人员
 */
@property(nonatomic,strong)UIView *View_FellowOfficers;
/**
 *  预计金额视图
 */
@property(nonatomic,strong)UIView *View_Estimated;
/**
 *  超预算原因视图
 */
@property(nonatomic,strong)UIView *View_OverBud;
/**
 *  外出申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_StaffOutForm;
/**
 *  用车申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_VehicleForm;
/**
 *  借款单单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_BorrowForm;
/**
 *  单据数量视图
 */
@property (nonatomic,strong)UIView *View_DocumentNum;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_SecDetailsTable;
/**
 *  收款人视图
 */
@property(nonatomic,strong)UIView *View_Payee;
/**
 *  收款银行账号视图
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
 *  结算方式视图
 */
@property(nonatomic,strong)UIView *View_PmtMethod;
/**
 *  是否收到发票视图
 */
@property(nonatomic,strong)UIView *View_ReceiptOfInv;
@property(nonatomic,strong)UILabel *Lab_ReceiptOfInv;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
/**
 *  采购备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  采购图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
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
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;
@property (nonatomic, assign) NSInteger int_line4;



@end
