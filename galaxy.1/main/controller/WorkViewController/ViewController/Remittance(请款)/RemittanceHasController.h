//
//  RemittanceHasController.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "RemittanceFormData.h"
#import "MainReleSubInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemittanceHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate>

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
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  合同金额视图
 */
@property(nonatomic,strong)UIView *View_ContractAmount;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  单位名称视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
/**
 *  银行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
/**
 *  结算状态视图
 */
@property(nonatomic,strong)UIView *View_SettlementStatus;
/**
 *  工程进度视图
 */
@property(nonatomic,strong)UIView *View_ProjectProgress;
/**
 *  本次申领金额视图
 */
@property(nonatomic,strong)UIView *View_ClaimAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
/**
 *  累计已收款（含已扣）视图
 */
@property (nonatomic, strong) UIView *View_TotalReceivables;
/**
 *  累计已扣款视图
 */
@property (nonatomic, strong) UIView *View_TotalDeduction;
/**
 *  累计提供发票（含本次）视图
 */
@property (nonatomic, strong) UIView *View_AccumulativeInvoice;
/**
 *  手续合规性视图
 */
@property (nonatomic, strong) UIView *View_FormalityCompliance;
/**
 *  审批金额视图
 */
@property(nonatomic,strong)UIView *View_ApprovalAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_ApprovalCapitalized;
/**
 *  付款金额视图
 */
@property(nonatomic,strong)UIView *View_PaymentAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_PaymentCapitalized;
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
 已登记发票信息
 */
@property(nonatomic,strong)MainReleSubInfoView *View_InvoiceRegAppInfo;
/**
 已请款单信息
 */
@property(nonatomic,strong)MainReleSubInfoView *View_RemittanceAppInfo;
/**
 已结算单信息
 */
@property(nonatomic,strong)MainReleSubInfoView *View_SettlementSlipInfo;


/**
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;

//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;

@end

NS_ASSUME_NONNULL_END
