//
//  WorkCardNewController.h
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
#import "WorkCardData.h"
#import "WorkCardFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkCardNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)WorkCardFormData *FormDatas;
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
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 补卡时间
 */
@property(nonatomic,strong)UIView *View_TimeCard;
@property(nonatomic,strong)UITextField *txf_TimeCard;
/**
 *  补卡理由
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextField *txf_Reason;
/**
 *  证明人
 */
@property(nonatomic,strong)UIView *View_Witness;
@property(nonatomic,strong)UITextField *txf_Witness;
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
