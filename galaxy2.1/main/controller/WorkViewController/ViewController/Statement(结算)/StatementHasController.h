//
//  StatementHasController.h
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
#import "StatementFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatementHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate>

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
/**
 *  分包单位名称视图
 */
@property(nonatomic,strong)UIView *View_SubcontractorName;
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
 *  开工日期视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
/**
 *  完工日期视图
 */
@property(nonatomic,strong)UIView *View_EndDate;
/**
 *  验收日期视图
 */
@property(nonatomic,strong)UIView *View_AcceptanceDate;
/**
 *  结算日期视图
 */
@property(nonatomic,strong)UIView *View_SettlementDate;
/**
 *  扣款金额视图
 */
@property(nonatomic,strong)UIView *View_DeductionAmount;
/**
 *  扣款附件视图
 */
@property(nonatomic,strong)UIView *View_DeductionAttachment;
/**
 *  结算价视图
 */
@property(nonatomic,strong)UIView *View_SettlementPrice;
/**
 *  扣款附件视图
 */
@property(nonatomic,strong)UIView *View_SettlementAttachment;
/**
 *  最终双方确认总价视图
 */
@property(nonatomic,strong)UIView *View_TotalAmount;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
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
