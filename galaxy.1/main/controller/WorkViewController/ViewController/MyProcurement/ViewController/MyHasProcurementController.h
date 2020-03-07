//
//  MyHasProcurementController.h
//  galaxy
//
//  Created by hfk on 16/4/18.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "DeatilsModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "MyProcureFormData.h"

@interface MyHasProcurementController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyProcureFormData *FormDatas;
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
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyUpView;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;
/**
 *  内容1视图
 */
@property (nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  采购事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  采购类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  成本中心视图
 */
@property (nonatomic,strong)UIView *View_CostCenter;
/**
 *  项目名称视图
 */
@property (nonatomic,strong)UIView *View_Project;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  采购支付方式视图
 */
@property(nonatomic,strong)UIView *View_PayWay;
/**
 *  采购交付日期视图
 */
@property(nonatomic,strong)UIView *View_PayDate;
/**
 *  采购合计金额视图
 */
@property(nonatomic,strong)UIView *View_TotalMoney;
/**
 *  采购明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
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