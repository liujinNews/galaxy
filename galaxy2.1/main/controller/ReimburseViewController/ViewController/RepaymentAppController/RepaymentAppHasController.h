//
//  RepaymentAppHasController.h
//  galaxy
//
//  Created by hfk on 2017/6/20.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "RepayMentFormData.h"
@interface RepaymentAppHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)RepayMentFormData *FormDatas;
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
 *  借款单单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_BorrowForm;
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
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
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
