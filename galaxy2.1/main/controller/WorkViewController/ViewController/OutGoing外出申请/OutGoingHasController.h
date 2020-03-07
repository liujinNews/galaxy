//
//  OutGoingHasController.h
//  galaxy
//
//  Created by hfk on 2017/12/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "OutGoingFormData.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"

@interface OutGoingHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
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
 *  外出原因视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  外出类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  外出开始视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
/**
 *  外出结束视图
 */
@property(nonatomic,strong)UIView *View_EndDate;

/**
 *  外出时长视图
 */
@property(nonatomic,strong)UIView *View_Time;
/**
 *  实际外出时间视图
 */
@property(nonatomic,strong)UIView *View_ActualFromDate;
/**
 *  实际返回时间视图
 */
@property(nonatomic,strong)UIView *View_ActualToDate;
/**
 *  实际外出时间共计(小时)视图
 */
@property(nonatomic,strong)UIView *View_ActualOutTime;
/**
 *  外出地点视图
 */
@property(nonatomic,strong)UIView *View_Place;
/**
 *  外出对象视图
 */
@property(nonatomic,strong)UIView *View_Visitor;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  同行人
 */
@property (nonatomic, strong) UIView *View_Fellow;
/**
 *  市内交通
 */
@property (nonatomic, strong) UIView *View_CityTransFee;
/**
 *  业务招待
 */
@property (nonatomic, strong) UIView *View_EntertainmentFee;
/**
 *  误餐费
 */
@property (nonatomic, strong) UIView *View_MealFee;
/**
 *  其他费
 */
@property (nonatomic, strong) UIView *View_OtherFee;
/**
 *  合计费用
 */
@property (nonatomic, strong) UIView *View_TotalBudget;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  采购备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  采购图片视图
 */
@property(nonatomic,strong)UIView *View_AttachImg;

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
