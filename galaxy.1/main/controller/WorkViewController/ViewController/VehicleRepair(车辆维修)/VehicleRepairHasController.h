//
//  VehicleRepairHasController.h
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


@interface VehicleRepairHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)VehicleRepairFormData *FormDatas;
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
 *  车牌号码视图
 */
@property(nonatomic,strong)UIView *View_CarNo;
/**
 *  型号视图
 */
@property(nonatomic,strong)UIView *View_CarSize;
/**
 *  载重量(吨)视图
 */
@property(nonatomic,strong)UIView *View_LoadCapacity;
/**
 *  现行里程视图
 */
@property(nonatomic,strong)UIView *View_Mileage;
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
