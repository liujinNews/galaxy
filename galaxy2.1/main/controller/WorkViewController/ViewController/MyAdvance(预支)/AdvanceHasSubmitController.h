//
//  AdvanceHasSubmitController.h
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "PayMentDetailController.h"
#import "MyApplyModel.h"
#import "MyAdvanceFormData.h"

@interface AdvanceHasSubmitController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyAdvanceFormData *FormDatas;
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
 *  借款事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  借款类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  借款金额视图
 */
@property(nonatomic,strong)UIView *View_Amount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
/**
 汇率
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
/**
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
/**
 *  还款日期视图
 */
@property(nonatomic,strong)UIView *View_RepayDate;
/**
 *  出差申请单视图
 */
@property (nonatomic,strong)MulChooseShowView *View_TravelForm;
/**
 *  费用申请单单视图
 */
@property (nonatomic,strong)MulChooseShowView *View_FeeAppForm;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_ExpenseType;
/**
 *  结算方式视图
 */
@property(nonatomic,strong)UIView *View_PmtMethod;
/**
 *  结算方式输入框
 */
@property(nonatomic,strong)UITextField *txf_PmtMethod;
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
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
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
 *  已申请借款视图
 */
@property(nonatomic,strong)UIView *View_NotYetAdvance;
/**
 超预算信息
 */
@property(nonatomic,strong)UIView *View_Budget;
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
 签收记录
 */
@property(nonatomic,strong)FormSignInfoView *FormSignInfoView;
/**
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;

//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, strong) UIView *view_line3;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;
@property (nonatomic, assign) NSInteger int_line3;



@end
