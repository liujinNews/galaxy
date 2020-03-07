//
//  PerformanceHasController.h
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "PerformanceFormData.h"

@interface PerformanceHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)PerformanceFormData *FormDatas;
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
 *  采购明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_head;
/**
 评分视图
 */
@property(nonatomic,strong)UITableView *View_tableScore;;
/**
 *  分数视图
 */
@property(nonatomic,strong)UIView *View_Score;
@property(nonatomic,strong)UIImageView *img_middleLine;
@property(nonatomic,strong)UIView *View_selfScore;
@property(nonatomic,strong)UILabel *lab_selfScore;
@property(nonatomic,strong)UILabel *lab_selfTitle;
@property(nonatomic,strong)UIView *View_LeaderScore;
@property(nonatomic,strong)UILabel *lab_LeaderScore;
@property(nonatomic,strong)UILabel *lab_leaderTitle;
/**
 *  评价月份年季度视图
 */
@property(nonatomic,strong)UIView *View_ChooseDate;
/**
 *  自评查看视图
 */
@property(nonatomic,strong)UIView *View_SelfAppraise;
/**
 *  领导评论视图
 */
@property(nonatomic,strong)UIView *View_LeaderAppraise;
/**
 *  评价输入框
 */
@property(nonatomic,strong)UITextView *txv_LeaderAppraise;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 * 备注视图
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
@property (nonatomic, assign) NSInteger int_line1;
@end
