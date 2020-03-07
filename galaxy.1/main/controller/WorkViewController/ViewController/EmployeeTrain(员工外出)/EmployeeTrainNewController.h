//
//  EmployeeTrainNewController.h
//  galaxy
//
//  Created by hfk on 2018/7/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "EmployeeTrainData.h"
#import "EmployeeTrainDetail.h"
#import "EmployeeTrainFormData.h"

@interface EmployeeTrainNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>

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
 *  培训名称视图
 */
@property(nonatomic,strong)UIView *View_Name;
@property(nonatomic,strong)UITextField *txf_Name;
/**
 *  培训机构视图
 */
@property(nonatomic,strong)UIView *View_Institution;
@property(nonatomic,strong)UITextField *txf_Institution;
/**
 *  培训形式视图
 */
@property(nonatomic,strong)UIView *View_Mode;
@property(nonatomic,strong)UITextField *txf_Mode;
/**
 *  培训地点视图
 */
@property(nonatomic,strong)UIView *View_Location;
@property(nonatomic,strong)UITextField *txf_Location;
/**
 *  培训开始日期视图
 */
@property(nonatomic,strong)UIView *View_StartDate;
@property(nonatomic,strong)UITextField *txf_StartDate;
/**
 *  培训结束日期视图
 */
@property(nonatomic,strong)UIView *View_EndDate;
@property(nonatomic,strong)UITextField *txf_EndDate;
/**
 *  培训天数视图
 */
@property(nonatomic,strong)UIView *View_Days;
@property(nonatomic,strong)UITextField *txf_Days;
/**
 *  培训费用视图
 */
@property(nonatomic,strong)UIView *View_Fee;
@property(nonatomic,strong)GkTextField *txf_Fee;
/**
 *  培训内容视图
 */
@property(nonatomic,strong)UIView *View_Content;
@property(nonatomic,strong)UITextView *txv_Content;
/**
 *  考核方式视图
 */
@property(nonatomic,strong)UIView *View_Method;;
@property(nonatomic,strong)UITextField *txf_Method;
/**
 *  培训证书视图
 */
@property(nonatomic,strong)UIView *View_Certificate;
@property(nonatomic,strong)UITextField *txf_Certificate;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  参训人员名单明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  参训人员名单明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  参训人员名单明细增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除参训人员名单明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_DeleteDetils;
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
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;

@end
