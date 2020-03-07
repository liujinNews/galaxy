//
//  AskingLeaveController.h
//  galaxy
//
//  Created by hfk on 16/5/12.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "GkTextField.h"
#import "MyAskLeaveData.h"
#import "MyAskLeaveFormData.h"

@interface AskingLeaveController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
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
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  请假类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  请假类型Label
 */
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  请假假期视图
 */
@property(nonatomic,strong)UIView *View_LeaveHoliday;
@property(nonatomic,strong)UILabel *lab_LeaveHoliday;
/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_StartTime;
@property(nonatomic,strong)UITextField *txf_StartTime;
/**
 *  开始时间上午或下午视图
 */
@property(nonatomic,strong)UIView *View_StartNoon;
@property(nonatomic,strong)UITextField *txf_StartNoon;

/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_EndTime;
@property(nonatomic,strong)UITextField *txf_EndTime;
/**
 *  结束时间上午下午视图
 */
@property(nonatomic,strong)UIView *View_EndNoon;
@property(nonatomic,strong)UITextField *txf_EndNoon;
/**
 *  请假天数视图
 */
@property(nonatomic,strong)UIView *View_LeaveTolDay;
/**
 *  请假天数textField
 */
@property(nonatomic,strong)GkTextField *txf_LeaveTolDay;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;

@end
