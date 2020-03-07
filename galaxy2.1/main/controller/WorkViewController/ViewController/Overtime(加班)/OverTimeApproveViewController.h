//
//  OverTimeApproveViewController.h
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "OverTimeFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTimeApproveViewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 表单上数据
 */
@property (nonatomic,strong)OverTimeFormData *FormDatas;
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
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_FromData;
@property(nonatomic,strong)UITextField *txf_FromData;
/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_ToData;
@property(nonatomic,strong)UITextField *txf_ToData;
/**
 *  加班时长视图
 */
@property(nonatomic,strong)UIView *View_TotalTime;
@property(nonatomic,strong)UITextField *txf_TotalTime;
/**
 *  加班类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  加班核算方式视图
 */
@property(nonatomic,strong)UIView *View_AccountingMode;
@property(nonatomic,strong)UITextField *txf_AccountingMode;
/**
 *  调休天数视图
 */
@property(nonatomic,strong)UIView *View_ExchangeHoliday;
@property(nonatomic,strong)UITextField *txf_ExchangeHoliday;
/**
 *  明细视图
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
 本月加班明细
 */
@property(nonatomic, strong)UIView *View_OvertimeHistory;
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

NS_ASSUME_NONNULL_END
