//
//  RemittanceNewController.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "RemittanceData.h"
#import "RemittanceFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemittanceNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)RemittanceFormData *FormDatas;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView * scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView * dockView;
/**
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  合同金额视图
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
@property(nonatomic,strong)GkTextField *txf_ContractAmount;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  单位名称视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
@property(nonatomic,strong)UITextField *txf_BankName;
/**
 *  银行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
@property(nonatomic,strong)UITextField *txf_BankAccount;
/**
 *  结算状态视图
 */
@property(nonatomic,strong)UIView *View_SettlementStatus;
@property(nonatomic,strong)UITextField *txf_SettlementStatus;
/**
 *  工程进度视图
 */
@property(nonatomic,strong)UIView *View_ProjectProgress;
@property(nonatomic,strong)UITextField *txf_ProjectProgress;
/**
 *  本次申领金额视图
 */
@property(nonatomic,strong)UIView *View_ClaimAmount;
@property(nonatomic,strong)GkTextField *txf_ClaimAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
@property (nonatomic, strong) UITextField *txf_Capitalized;
/**
 *  累计已收款（含已扣）视图
 */
@property (nonatomic, strong) UIView *View_TotalReceivables;
@property (nonatomic, strong) GkTextField *txf_TotalReceivables;
/**
 *  累计已扣款视图
 */
@property (nonatomic, strong) UIView *View_TotalDeduction;
@property (nonatomic, strong) GkTextField *txf_TotalDeduction;
/**
 *  累计提供发票（含本次）视图
 */
@property (nonatomic, strong) UIView *View_AccumulativeInvoice;
@property (nonatomic, strong) GkTextField *txf_AccumulativeInvoice;
/**
 *  手续合规性视图
 */
@property (nonatomic, strong) UIView *View_FormalityCompliance;
@property (nonatomic, strong) UITextField *txf_FormalityCompliance;
/**
 *  审批金额视图
 */
@property(nonatomic,strong)UIView *View_ApprovalAmount;
@property(nonatomic,strong)GkTextField *txf_ApprovalAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_ApprovalCapitalized;
@property (nonatomic, strong) UITextField *txf_ApprovalCapitalized;
/**
 *  付款金额视图
 */
@property(nonatomic,strong)UIView *View_PaymentAmount;
@property(nonatomic,strong)GkTextField *txf_PaymentAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_PaymentCapitalized;
@property (nonatomic, strong) UITextField *txf_PaymentCapitalized;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;


@end

NS_ASSUME_NONNULL_END
