//
//  MyAdvanceController.h
//  galaxy
//
//  Created by hfk on 16/5/6.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "contactsVController.h"
#import "MyProcurementModel.h"
#import "buildCellInfo.h"
#import "STOnePickView.h"
#import "STOnePickModel.h"
#import "MyAdvanceData.h"
#import "MyAdvanceFormData.h"

@interface MyAdvanceController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,ByvalDelegate>
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
 *  借款类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  借款类型Label
 */
@property(nonatomic,strong)UITextField *txf_Type;
/**
 *  借款事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  借款事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 *  借款金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
/**
 *  借款金额输入框
 */
@property (nonatomic,strong)GkTextField * txf_Acount;
/**
 *  报销金额大写视图
 */
@property(nonatomic,strong)UIView *View_Capitalized;
/**
 *  报销金额大写txf
 */
@property(nonatomic,strong)UITextField *txf_Capitalized;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 /本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 *  选择日期视图
 */
@property(nonatomic,strong)UIView *View_Duration;
/**
 *  日期label
 */
@property (nonatomic,strong)UITextField *txf_Date;
/**
 *  出差申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_TravelForm;
/**
 *  费用申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_FeeAppForm;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_Cate;
/**
 *  费用类别Label
 */
@property (nonatomic,strong)UITextField * txf_Cate;
/**
 *  费用类别图片
 */
@property(nonatomic,strong)UIImageView * Imv_category;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  是否本部门承担费用视图
 */
@property(nonatomic,strong)UIView *View_IsDeptBearExps;
@property(nonatomic,strong)UITextField *txf_IsDeptBearExps;
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
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
/**
 *  抄送人txf
 */
@property(nonatomic,strong)UITextField *txf_CcToPeople;

/**
 *  成本中心超预算提示
 */
@property(nonatomic,strong)UITableView *View_table;

@end
