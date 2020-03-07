//
//  ContractAppHasController.h
//  galaxy
//
//  Created by hfk on 2018/10/27.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "FormChildTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractAppHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 表单上数据
 */
@property (nonatomic,strong)ContractAppFormData *FormDatas;
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
 *  内容视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  合同编号视图
 */
@property(nonatomic,strong)UIView *View_ContNo;
/**
 *  合同名称视图
 */
@property(nonatomic,strong)UIView *View_ContName;
/**
*  描述
*/
@property(nonatomic,strong)UIView *View_Description;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
/**
 *  关联合同视图
 */
@property(nonatomic,strong)UIView *View_RelCont;
/**
 *  采购申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_PurchaseForm;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  合同类型视图
 */
@property(nonatomic,strong)UIView *View_ContType;
/**
*  是否使用标准合同模版 IsStandardContractTemplate
*/
@property (nonatomic, strong) UIView *view_StdConTemplate;//是否使用标准模版
@property (nonatomic, strong) UILabel *lab_StdConTemplate;
@property (nonatomic, copy) NSString *str_StdConTemplate;
@property (nonatomic, strong) NSMutableArray *array_IsStdConTemplate;
/**
 *  合同金额视图
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
会签人员
*/
@property(nonatomic,strong)UIView *View_ApprovalPersonnel;//会签人员view
/**
 签订日期视图
 */
@property (nonatomic, strong) UIView *View_ContractDate;
/**
 开始日期视图
 */
@property (nonatomic, strong) UIView *View_EffectiveDate;
/**
 截止日期视图
 */
@property (nonatomic, strong) UIView *View_ExpiryDate;
/**
 付款方式视图
 */
@property (nonatomic, strong) UIView *View_PayCode;
/**
 汇票比例视图
 */
@property (nonatomic, strong) UIView *View_MoneyOrderRate;
/**
 签订份数视图
 */
@property (nonatomic, strong) UIView *View_ContractCopies;
/**
 关联合同
 */
@property (nonatomic, strong) FormChildTableView *View_ReleContract;
/**
 我方单位视图
 */
@property (nonatomic, strong) UIView *View_PartyA;
/**
 我方单位负责人视图
 */
@property (nonatomic, strong) UIView *View_PartyAStaff;
/**
 我方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyATel;
/**
 对方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyB;
/**
 对方单位地址视图
 */
@property (nonatomic, strong) UIView *View_PartyBAddr;
/**
 对方单位邮编视图
 */
@property (nonatomic, strong) UIView *View_PartyBPostCode;
/**
 对方单位负责人视图
 */
@property (nonatomic, strong) UIView *View_PartyBStaff;
/**
 对方单位电话视图
 */
@property (nonatomic, strong) UIView *View_PartyBTel;
/**
 开户银行视图
 */
@property (nonatomic, strong) UIView *View_BankName;
/**
 银行账号视图
 */
@property (nonatomic, strong) UIView *View_BankAccount;
/**
 发票抬头视图
 */
@property (nonatomic, strong) UIView *View_InvoiceTitle;
/**
 发票类型视图
 */
@property (nonatomic, strong) UIView *View_InvoiceType;
/**
 税率视图
 */
@property (nonatomic, strong) UIView *View_TaxRate;
/**
 客户名称视图
 */
@property (nonatomic, strong) UIView *View_ClientName;
/**
 客户地址视图
 */
@property (nonatomic, strong) UIView *View_ClientAddr;
/**
 IbanName视图
 */
@property (nonatomic, strong) UIView *View_IbanName;
/**
 IbanAccount视图
 */
@property (nonatomic, strong) UIView *View_IbanAccount;
/**
 IbanAddr视图
 */
@property (nonatomic, strong) UIView *View_IbanAddr;
/**
 SwiftCode视图
 */
@property (nonatomic, strong) UIView *View_SwiftCode;
/**
 IbanNo视图
 */
@property (nonatomic, strong) UIView *View_BankNo;
/**
 IbanADDRESS视图
 */
@property (nonatomic, strong) UIView *View_BankADDRESS;
/**
 *  合同条款明细视图
 */
@property(nonatomic,strong)UITableView *View_TermTable;
/**
 * 付款方式明细视图
 */
@property(nonatomic,strong)UITableView *View_PayModeTable;
/**
 * 年度费用明细明细视图
 */
@property(nonatomic,strong)UITableView *View_ConYearExpTable;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 付款，回款，开票信息
 */
@property (nonatomic, strong) FormChildTableView *View_ContractReleInfo;
/**
 *  审批人视图
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
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;

//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;

@end

NS_ASSUME_NONNULL_END
