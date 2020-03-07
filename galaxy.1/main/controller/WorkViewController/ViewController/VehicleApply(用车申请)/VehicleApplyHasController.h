//
//  VehicleApplyHasController.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "VehicleApplyFormData.h"

@interface VehicleApplyHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)VehicleApplyFormData *FormDatas;
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
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  出发地视图
 */
@property(nonatomic,strong)UIView *View_DepartCity;
/**
 *  目的地视图
 */
@property(nonatomic,strong)UIView *View_BackCity;
/**
 *  用车时间视图
 */
@property(nonatomic,strong)UIView *View_VehicleDate;
/**
 *  返回时间视图
 */
@property(nonatomic,strong)UIView *View_BackDate;
/**
 *  同车人员视图
 */
@property(nonatomic,strong)UIView *View_VehicleStaff;
/**
 *  起始里程视图
 */
@property(nonatomic,strong)UIView *View_InitialMileage;
/**
 *  预计结束里程视图
 */
@property(nonatomic,strong)UIView *View_EndMileage;
/**
 *  实际里程视图
 */
@property(nonatomic,strong)UIView *View_Mileage;
/**
 *  私车公用补贴（元/公里）视图
 */
@property(nonatomic,strong)UIView *View_PteCarAllowance;
/**
 燃油费视图
 */
@property (nonatomic, strong) UIView *View_FuelBills;
/**
 路桥费视图
 */
@property (nonatomic, strong) UIView *View_Pontage;
/**
 停车费视图
 */
@property (nonatomic, strong) UIView *View_ParkingFee;
/**
 其他费用视图
 */
@property (nonatomic, strong) UIView *View_OtherFee;
/**
 合计视图
 */
@property (nonatomic, strong) UIView *View_TotalBudget;
/**
 是否过夜视图
 */
@property (nonatomic, strong) UIView *View_IsPassNight;
/**
 出差申请单
 */
@property (nonatomic, strong) MulChooseShowView *View_TravelForm;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 车辆视图
 */
@property (nonatomic, strong) UIView *View_CarNo;
/**
 司机视图
 */
@property (nonatomic, strong) UIView *View_Driver;
/**
 司机电话视图
 */
@property (nonatomic, strong) UIView *View_DriverTel;
/**
 同行人员视图
 */
@property (nonatomic, strong) UIView *View_Entourage;
/**
 车辆调度评审视图
 */
@property (nonatomic, strong) UIView *View_DispatcherReview;
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
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;

@end
