//
//  OutGoingController.h
//  galaxy
//
//  Created by hfk on 2017/12/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "OutGoingData.h"
#import "OutGoingFormData.h"
#import "EditAndLookImgView.h"
@interface OutGoingController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)OutGoingFormData *FormDatas;
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
 外出事由
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 类型
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_StartTime;
@property(nonatomic,strong)UITextField *txf_StartTime;
/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_EndTime;
@property(nonatomic,strong)UITextField *txf_EndTime;
/**
 *  外出时间(小时)视图
 */
@property(nonatomic,strong)UIView *View_OutTime;
@property(nonatomic,strong)GkTextField *txf_OutTime;
/**
 *  实际外出时间视图
 */
@property(nonatomic,strong)UIView *View_ActualFromDate;
@property(nonatomic,strong)UITextField *txf_ActualFromDate;
/**
 *  实际返回时间视图
 */
@property(nonatomic,strong)UIView *View_ActualToDate;
@property(nonatomic,strong)UITextField *txf_ActualToDate;
/**
 *  实际外出时间共计(小时)视图
 */
@property(nonatomic,strong)UIView *View_ActualOutTime;
@property(nonatomic,strong)GkTextField *txf_ActualOutTime;
/**
 *  外出地点视图
 */
@property(nonatomic,strong)UIView *View_OutPlace;
@property(nonatomic,strong)UITextField *txf_OutPlace;
/**
 *  拜访对象视图
 */
@property(nonatomic,strong)UIView *View_Visitor;
@property(nonatomic,strong)UITextField *txf_Visitor;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  同行人
 */
@property (nonatomic, strong) UIView *View_Fellow;
@property (nonatomic, strong) UITextField *txf_Fellow;
/**
 *  市内交通
 */
@property (nonatomic, strong) UIView *View_CityTransFee;
@property (nonatomic, strong) UITextField *txf_CityTransFee;
/**
 *  业务招待
 */
@property (nonatomic, strong) UIView *View_EntertainmentFee;
@property (nonatomic, strong) UITextField *txf_EntertainmentFee;
/**
 *  误餐费
 */
@property (nonatomic, strong) UIView *View_MealFee;
@property (nonatomic, strong) UITextField *txf_MealFee;
/**
 *  其他费
 */
@property (nonatomic, strong) UIView *View_OtherFee;
@property (nonatomic, strong) UITextField *txf_OtherFee;
/**
 *  合计费用
 */
@property (nonatomic, strong) UIView *View_TotalBudget;
@property (nonatomic, strong) UITextField *txf_TotalBudget;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  备注输入框
 */
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
