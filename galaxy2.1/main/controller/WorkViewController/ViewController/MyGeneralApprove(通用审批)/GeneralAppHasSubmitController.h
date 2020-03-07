//
//  GeneralAppHasSubmitController.h
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "MyGeneralFormData.h"
@interface GeneralAppHasSubmitController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
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
 *  通用审批类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  通用审批事由视图
 */
@property(nonatomic,strong)UIView *View_Title;
/**
 *  通用审批详情视图
 */
@property(nonatomic,strong)UIView *View_Detail;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  图片视图
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
