//
//  VehicleApplyApproveController.h
//  galaxy
//
//  Created by hfk on 2018/7/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "STOnePickView.h"
#import "STOnePickModel.h"
#import "VehicleApplyData.h"
#import "VehicleApplyFormData.h"

@interface VehicleApplyApproveController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate>
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
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  出发地视图
 */
@property(nonatomic,strong)UIView *View_DepartCity;
@property(nonatomic,strong)UITextField *txf_DepartCity;
/**
 *  目的地视图
 */
@property(nonatomic,strong)UIView *View_BackCity;
@property(nonatomic,strong)UITextField *txf_BackCity;
/**
 *  用车时间视图
 */
@property(nonatomic,strong)UIView *View_VehicleDate;
@property(nonatomic,strong)UITextField *txf_VehicleDate;
/**
 *  返回时间视图
 */
@property(nonatomic,strong)UIView *View_BackDate;
@property(nonatomic,strong)UITextField *txf_BackDate;
/**
 *  同车人员视图
 */
@property(nonatomic,strong)UIView *View_VehicleStaff;
@property(nonatomic,strong)UITextField *txf_VehicleStaff;
/**
 *  起始里程视图
 */
@property(nonatomic,strong)UIView *View_InitialMileage;
@property(nonatomic,strong)UITextField *txf_InitialMileage;
/**
 *  预计结束里程视图
 */
@property(nonatomic,strong)UIView *View_EndMileage;
@property(nonatomic,strong)UITextField *txf_EndMileage;
/**
 *  实际里程视图
 */
@property(nonatomic,strong)UIView *View_Mileage;
@property(nonatomic,strong)UITextField *txf_Mileage;
/**
 *  私车公用补贴（元/公里）视图
 */
@property(nonatomic,strong)UIView *View_PteCarAllowance;
@property(nonatomic,strong)UITextField *txf_PteCarAllowance;
/**
 燃油费视图
 */
@property (nonatomic, strong) UIView *View_FuelBills;
@property (nonatomic, strong) UITextField *txf_FuelBills;
/**
 路桥费视图
 */
@property (nonatomic, strong) UIView *View_Pontage;
@property (nonatomic, strong) UITextField *txf_Pontage;
/**
 停车费视图
 */
@property (nonatomic, strong) UIView *View_ParkingFee;
@property (nonatomic, strong) UITextField *txf_ParkingFee;
/**
 其他费用视图
 */
@property (nonatomic, strong) UIView *View_OtherFee;
@property (nonatomic, strong) UITextField *txf_OtherFee;
/**
 合计视图
 */
@property (nonatomic, strong) UIView *View_TotalBudget;
@property (nonatomic, strong) UITextField *txf_TotalBudget;
/**
 是否过夜视图
 */
@property (nonatomic, strong) UIView *View_IsPassNight;
@property (nonatomic, strong) UITextField *txf_IsPassNight;
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
@property (nonatomic, strong) UITextField *txf_CarNo;
/**
 司机视图
 */
@property (nonatomic, strong) UIView *View_Driver;
@property (nonatomic, strong) UITextField *txf_Driver;
/**
 司机电话视图
 */
@property (nonatomic, strong) UIView *View_DriverTel;
@property (nonatomic, strong) UITextField *txf_DriverTel;
/**
 同行人员视图
 */
@property (nonatomic, strong) UIView *View_Entourage;
@property (nonatomic, strong) UITextField *txf_Entourage;
/**
 车辆调度评审视图
 */
@property (nonatomic, strong) UIView *View_DispatcherReview;
@property (nonatomic, strong) UITextField *txf_DispatcherReview;
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;
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


@end
