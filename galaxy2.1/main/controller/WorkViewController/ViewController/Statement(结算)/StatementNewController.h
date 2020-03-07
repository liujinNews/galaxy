//
//  StatementNewController.h
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
#import "StatementData.h"
#import "StatementFormData.h"


NS_ASSUME_NONNULL_BEGIN

@interface StatementNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)StatementFormData *FormDatas;
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
 *  总包单位名称视图
 */
@property(nonatomic,strong)UIView *View_EpcName;
@property(nonatomic,strong)UITextField *txf_EpcName;
/**
 *  分包单位名称视图
 */
@property(nonatomic,strong)UIView *View_SubcontractorName;
@property(nonatomic,strong)UITextField *txf_SubcontractorName;
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
 *  开工日期视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
@property(nonatomic,strong)UITextField *txf_StartDate;
/**
 *  完工日期视图
 */
@property(nonatomic,strong)UIView *View_EndDate;
@property(nonatomic,strong)UITextField *txf_EndDate;
/**
 *  验收日期视图
 */
@property(nonatomic,strong)UIView *View_AcceptanceDate;
@property(nonatomic,strong)UITextField *txf_AcceptanceDate;
/**
 *  结算日期视图
 */
@property(nonatomic,strong)UIView *View_SettlementDate;
@property(nonatomic,strong)UITextField *txf_SettlementDate;
/**
 *  扣款金额视图
 */
@property(nonatomic,strong)UIView *View_DeductionAmount;
@property(nonatomic,strong)GkTextField *txf_DeductionAmount;
/**
 *  扣款附件视图
 */
@property(nonatomic,strong)UIView *View_DeductionAttachment;
/**
 *  结算价视图
 */
@property(nonatomic,strong)UIView *View_SettlementPrice;
@property(nonatomic,strong)GkTextField *txf_SettlementPrice;
/**
 *  扣款附件视图
 */
@property(nonatomic,strong)UIView *View_SettlementAttachment;
/**
 *  最终双方确认总价视图
 */
@property(nonatomic,strong)UIView *View_TotalAmount;
@property(nonatomic,strong)GkTextField *txf_TotalAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
@property (nonatomic, strong) UITextField *txf_Capitalized;
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
