//
//  SpecialReqestNewController.h
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
#import "SpecialReqestData.h"
#import "SpecialReqestDetail.h"
#import "SpecialReqestFormData.h"

@interface SpecialReqestNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)SpecialReqestFormData *FormDatas;
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
 *  出差申请单视图
 */
@property(nonatomic,strong)UIView *View_TravelForm;
@property(nonatomic,strong)UITextField *txf_TravelForm;
/**
 *  出差地
 */
@property(nonatomic,strong)UIView *View_TravelCity;
@property(nonatomic,strong)UITextField *txf_TravelCity;
/**
 *  出差人员
 */
@property(nonatomic,strong)UIView *View_TravelUser;
@property(nonatomic,strong)UITextField *txf_TravelUser;
/**
 *  出发日期
 */
@property(nonatomic,strong)UIView *View_DepartureDate;
@property(nonatomic,strong)UITextField *txf_DepartureDate;
/**
 *  返回日期
 */
@property(nonatomic,strong)UIView *View_ReturnDate;
@property(nonatomic,strong)UITextField *txf_ReturnDate;
/**
 * 项目
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  超标信息明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  超标信息明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  超标信息明细增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除超标信息明细警告框
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
@property(nonatomic,strong)UITextField *txf_CcToPeople;


@end
