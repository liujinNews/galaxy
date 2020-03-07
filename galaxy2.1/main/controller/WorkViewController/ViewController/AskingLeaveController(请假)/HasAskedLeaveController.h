//
//  HasAskedLeaveController.h
//  galaxy
//
//  Created by hfk on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "MyAskLeaveFormData.h"
@interface HasAskedLeaveController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyAskLeaveFormData *FormDatas;
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
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  请假类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  请假天数视图
 */
@property(nonatomic,strong)UIView *View_LeaveDays;
/**
 *  开始视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
/**
 *  开始时间上午或下午视图
 */
@property(nonatomic,strong)UIView *View_StartNoon;
/**
 *  结束视图
 */
@property(nonatomic,strong)UIView *View_EndDate;
/**
 *  结束时间上午下午视图
 */
@property(nonatomic,strong)UIView *View_EndNoon;
/**
 *  请假调休详情视图
 */
@property(nonatomic,strong)UIView *View_LeaveHoildays;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  采购图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  采购审批人视图
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
