//
//  PerformanceNewController.h
//  galaxy
//
//  Created by hfk on 2018/1/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "PerformanceFormData.h"
#import "STNewPickView.h"
@interface PerformanceNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 * tableView的头视图
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

@property(nonatomic,strong)UILabel *Lab_SelfScore;
@property(nonatomic,strong)UILabel *Lab_LeaderScore;

/**
 *  评价月份年季度视图
 */
@property(nonatomic,strong)UIView *View_ChooseDate;
@property(nonatomic,strong)UITextField *txf_ChooseDate;
/**
 *  评价视图
 */
@property(nonatomic,strong)UIView *View_Appraise;
/**
*  评价输入框
 */
@property(nonatomic,strong)UITextView *txv_Appraise;
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
/**
 *  抄送人Label
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;


@end
