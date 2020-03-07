//
//  CancelFlowHasController.h
//  galaxy
//
//  Created by hfk on 2019/1/17.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "CancelFlowFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface CancelFlowHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate>
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
@property (nonatomic,strong)UIView *contentView;
/**
 *  下部按钮底层视图
 */
@property (nonatomic, strong) DoneBtnView *dockView;
/**
 *  内容1视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 * 撤销申请单
 */
@property(nonatomic,strong)UIView *View_CancelForm;
/**
 *  流程名称
 */
@property(nonatomic,strong)UIView *View_FlowName;
/**
 *  撤销原因
 */
@property(nonatomic,strong)UIView *View_Reason;
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
//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;

@end

NS_ASSUME_NONNULL_END
