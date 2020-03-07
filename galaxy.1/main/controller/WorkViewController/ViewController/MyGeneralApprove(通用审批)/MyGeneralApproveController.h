//
//  MyGeneralApproveController.h
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "MyGeneralApproveDate.h"
#import "MyGeneralFormData.h"

@interface MyGeneralApproveController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyGeneralFormData *FormDatas;
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
 通用审批类型
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  通用审批标题视图
 */
@property(nonatomic,strong)UIView *View_Title;
@property(nonatomic,strong)UITextField *txf_Title;
/**
 *  通用审批Detail视图
 */
@property(nonatomic,strong)UIView *View_Detail;
@property(nonatomic,strong)UITextView *txv_Detail;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  通用审批图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 处置收益
 */
@property(nonatomic,strong)UIView *View_DisposalProceeds;
@property(nonatomic,strong)GkTextField *txf_DisposalProceeds;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;

/**
 *  通用审批审批人视图
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人txf
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;


@end
