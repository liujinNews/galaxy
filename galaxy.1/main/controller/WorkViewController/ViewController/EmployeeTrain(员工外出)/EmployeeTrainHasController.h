//
//  EmployeeTrainHasController.h
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "EmployeeTrainFormData.h"
#import "EmployeeTrainDetail.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"

@interface EmployeeTrainHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)EmployeeTrainFormData *FormDatas;
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
 *  培训名称视图
 */
@property(nonatomic,strong)UIView *View_Name;
/**
 *  培训机构视图
 */
@property(nonatomic,strong)UIView *View_Institution;
/**
 *  培训形式视图
 */
@property(nonatomic,strong)UIView *View_Mode;
/**
 *  培训地点视图
 */
@property(nonatomic,strong)UIView *View_Location;
/**
 *  培训开始日期视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
/**
 *  培训结束日期视图
 */
@property(nonatomic,strong)UIView *View_EndDate;
/**
 *  培训天数视图
 */
@property(nonatomic,strong)UIView *View_Days;
/**
 *  培训费用视图
 */
@property(nonatomic,strong)UIView *View_Fee;
/**
 *  培训内容视图
 */
@property(nonatomic,strong)UIView *View_Content;
/**
 *  考核方式视图
 */
@property(nonatomic,strong)UIView *View_Method;
/**
 *  培训证书视图
 */
@property(nonatomic,strong)UIView *View_Certificate;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  参训人员名单明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
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
