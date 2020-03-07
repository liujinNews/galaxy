//
//  EntertainmentHasController.h
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"

@interface EntertainmentHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)EntertainmentFormData *FormDatas;
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
 *  内容视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  接待对象视图
 */
@property(nonatomic,strong)UIView *View_Object;
/**
 *  来访时间视图
 */
@property(nonatomic,strong)UIView *View_StartTime;
/**
 *  离开时间视图
 */
@property(nonatomic,strong)UIView *View_EndTime;
/**
 *  来访人员视图
 */
@property(nonatomic,strong)UIView *View_Visitor;
/**
 *  通用审批类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_ExpenseType;
/**
 *  费用类别描述视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDes;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 是否用车视图
 */
@property (nonatomic, strong) UIView *View_IsUseCar;
/**
 租车费视图
 */
@property (nonatomic, strong) UIView *View_RentCarFee;
/**
 路桥费视图
 */
@property (nonatomic, strong) UIView *View_Pontage;
/**
 餐费视图
 */
@property (nonatomic, strong) UIView *View_MealFee;
/**
 住宿费视图
 */
@property (nonatomic, strong) UIView *View_HotelFee;
/**
 其他费用视图
 */
@property (nonatomic, strong) UIView *View_OtherFee;

/**
 *  金额视图
 */
@property (nonatomic,strong)UIView *View_Amount;
/**
 *  币种视图
 */
@property (nonatomic,strong)UIView *View_Currency;
/**
 *  汇率视图
 */
@property (nonatomic,strong)UIView *View_Exchange;
/**
 *  本位币视图
 */
@property (nonatomic,strong)UIView *View_LocalAmount;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  接待记录明细视图
 */
@property(nonatomic,strong)UITableView *View_VistorDetailsTable;
/**
 *  接待记录明细视图
 */
@property(nonatomic,strong)UITableView *View_SecDetailsTable;
/**
 *  预算扣除日view
 */
@property(nonatomic,strong)UIView *View_BudgetSubDate;
/**
 *  预算扣除日txf
 */
@property(nonatomic,strong)UITextField *txf_BudgetSubDate;
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
 超预算信息
 */
@property(nonatomic,strong)UIView *View_Budget;
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
