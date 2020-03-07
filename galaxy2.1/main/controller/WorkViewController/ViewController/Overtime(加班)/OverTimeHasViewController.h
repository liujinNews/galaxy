//
//  OverTimeHasViewController.h
//  galaxy
//
//  Created by hfk on 2018/9/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "OverTimeDeatil.h"
#import "OverTimeFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTimeHasViewController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  开始时间视图
 */
@property(nonatomic,strong)UIView *View_FromData;
/**
 *  结束时间视图
 */
@property(nonatomic,strong)UIView *View_ToData;
/**
 *  加班时长视图
 */
@property(nonatomic,strong)UIView *View_TotalTime;
/**
 *  加班类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  加班核算方式视图
 */
@property(nonatomic,strong)UIView *View_AccountingMode;
/**
 *  调休天数视图
 */
@property(nonatomic,strong)UIView *View_ExchangeHoliday;
/**
 *  明细视图
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
 本月加班明细
 */
@property(nonatomic, strong)UIView *View_OvertimeHistory;
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

NS_ASSUME_NONNULL_END
