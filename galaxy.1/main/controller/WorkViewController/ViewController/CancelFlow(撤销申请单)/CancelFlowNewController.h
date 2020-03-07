//
//  CancelFlowNewController.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "CancelFlowData.h"
#import "CancelFlowFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CancelFlowNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)CancelFlowFormData *FormDatas;
/**
 *  滚动视图
 */
@property (nonatomic,strong)UIScrollView *scrollView;
/**
 *  滚动视图contentView
 */
@property (nonatomic,strong)BottomView *contentView;
/**
 *  底部按钮视图
 */
@property (nonatomic,strong)DoneBtnView *dockView;
/**
 *提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 * 撤销申请单
 */
@property(nonatomic,strong)UIView *View_CancelForm;
@property(nonatomic,strong)UITextField *txf_CancelForm;
/**
 *  流程名称
 */
@property(nonatomic,strong)UIView *View_FlowName;
@property(nonatomic,strong)UITextField *txf_FlowName;
/**
 *  撤销原因
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextField *txf_Reason;
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
