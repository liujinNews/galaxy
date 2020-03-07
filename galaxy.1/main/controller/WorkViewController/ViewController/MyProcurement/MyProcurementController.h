//
//  MyProcurementController.h
//  galaxy
//
//  Created by hfk on 16/4/11.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "DeatilsViewCell.h"
#import "chooseCategoryController.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ChooseCategoryModel.h"
#import "DeatilsModel.h"
#import "MyProcureFormData.h"
@interface MyProcurementController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)MyProcureFormData *FormDatas;
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
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyUpView;
/**
 *  报销政策视图
 */
@property(nonatomic,strong)UIView *ReimPolicyDownView;
/**
 提交人相关视图
 */
@property(nonatomic,strong)SubmitPersonalView *SubmitPersonalView;
/**
 *  报销事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  报销事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;
/**
*  单据可见范围
*/
@property(nonatomic,strong)UIView *View_FormScope;
@property(nonatomic,strong)NSMutableArray *arr_FormScope;
@property (nonatomic, strong) NSString *str_FormScopeType;
@property (nonatomic, strong) NSString *str_FormScopeCode;
@property (nonatomic, strong) NSString *str_FormScopeName;
@property(nonatomic,strong)UITextField *txf_FormScope;


/**
 *  费用申请单单视图
 */
@property (nonatomic,strong)MulChooseShowView *View_FeeAppForm;
/**
 *  采购类型视图
 */
@property(nonatomic,strong)UIView *View_Type;
/**
 *  采购类型txf
 */
@property(nonatomic,strong)UITextField *txf_Type;

/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  采购明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  采购明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_head;
/**
 *  采购增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_deleteDetils;
/**
 *  采购金额明细
 */
@property(nonatomic,strong)UITableView *View_purAmountTable;
@property(nonatomic,strong)UIView *View_AmHead;
@property(nonatomic,strong)UIView *View_AmAddDetails;
@property(nonatomic,strong)UIAlertController *Alert_AmDeleteC;
@property(nonatomic,strong)NSMutableArray *arr_IsCrossD;
/**
 *  采购内容明细
*/
@property(nonatomic,strong)UITableView *View_purBusinessTable;
@property(nonatomic,strong)UIView *View_BuHead;
@property(nonatomic,strong)UIView *View_BuAddDetails;
@property(nonatomic,strong)UIAlertController *Alert_BuDeleteC;
/**
 *  单一采购来源清单
*/
@property(nonatomic,strong)UITableView *View_purSourceTable;
@property(nonatomic,strong)UIView *View_SoHead;
@property(nonatomic,strong)UIView *View_SoAddDetails;
@property(nonatomic,strong)UIAlertController *Alert_SoDeleteC;
/**
 *  采购支付方式视图
 */
@property(nonatomic,strong)UIView *View_PayWay;
/**
 *  支付方式txf
 */
@property(nonatomic,strong)UITextField *txf_PayWay;
/**
 *  采购交付日期视图
 */
@property(nonatomic,strong)UIView *View_PayDate;
/**
 *  采购交付日期txf
 */
@property(nonatomic,strong)UITextField *txf_PayDate;
/**
 *  采购金额视图
 */
@property(nonatomic,strong)UIView *View_TotalMoney;
@property(nonatomic,strong)UITextField *txf_TotalMoney;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
@property (nonatomic, strong) UITextField *txf_Capitalized;
/**
 *  自定义字段
 */
@property(nonatomic,strong)UIView *View_Reserved;
/**
 *  采购备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
/**
 *  备注输入框
 */
@property(nonatomic,strong)UITextView *txv_Remark;
/**
 *  采购图片视图
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
