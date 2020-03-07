//
//  FeeAppHasController.h
//  galaxy
//
//  Created by hfk on 2017/6/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "FeeAppDeatil.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "FeeAppFormData.h"
@interface FeeAppHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)FeeAppFormData *FormDatas;
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
 *  申请类型
 */
@property(nonatomic,strong)UIView *View_AppType;
@property (nonatomic,strong)UITextField *txf_AppType;
@property (nonatomic,copy)NSString *str_AppTypeId;
@property (nonatomic,copy)NSString *str_AppTypeInfo;
@property (nonatomic,strong)NSMutableArray *arr_AppType;
/**
 *  关联费用申请
 */
@property (nonatomic,strong)MulChooseShowView *View_FeeAppForm;
@property (nonatomic,strong)UITextField *txf_FeeAppForm;
@property (nonatomic,copy)NSString *str_FeeAppInfo;
@property (nonatomic,copy)NSString *str_FeeAppNum;
/**
 *  费用类别视图
 */
@property(nonatomic,strong)UIView *View_ExpenseType;
/**
 *  费用类别描述视图
 */
@property(nonatomic,strong)UIView *View_ExpenseDes;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
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
 *资本性支出
*/
@property (nonatomic, strong) UIView *View_CapexAmount;
@property (nonatomic, strong) UITextField *txf_CapexAmount;
/**
 *费用
*/
@property (nonatomic, strong) UIView *View_CostAmount;
@property (nonatomic, strong) UITextField *txf_CostAmount;
/**
 *业务经理
*/
@property (nonatomic, strong) UIView *View_BusinessMgr;
@property (nonatomic, strong) UITextField *txf_BusinessMgr;
/**
 *业务负责人
*/
@property (nonatomic, strong) UIView *View_BusinessOwner;
@property (nonatomic, strong) UITextField *txf_BusinessOwner;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
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
 *  审批记录
 */
@property (nonatomic,strong)UIView *View_Note;


//分割块
@property (nonatomic, strong) UIView *view_line1;
@property (nonatomic, strong) UIView *view_line2;
@property (nonatomic, assign) NSInteger int_line1;
@property (nonatomic, assign) NSInteger int_line2;

/**
 * 费用类型数组
*/
@property (nonatomic,strong)NSMutableArray *arr_CostType;
@end
