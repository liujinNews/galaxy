//
//  FeeAppController.h
//  galaxy
//
//  Created by hfk on 2017/6/22.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "DeatilsViewCell.h"
#import "FeeAppDeatil.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "FeeAppData.h"
#import "STPickerCategory.h"
#import "FeeAppFormData.h"
@interface FeeAppController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
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
 *  报销事由视图
 */
@property(nonatomic,strong)UIView *View_Reason;
/**
 *  报销事由输入框
 */
@property(nonatomic,strong)UITextView *txv_Reason;

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
 *  费用类别描述视图
 */
@property(nonatomic,strong)UIView *View_CateDes;
/**
 *  费用类别描述输入框
 */
@property(nonatomic,strong)UITextView *txv_CateDes;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  借款金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
/**
 *  借款金额输入框
 */
@property (nonatomic,strong)GkTextField * txf_Acount;
/**
 币种视图
 */
@property (nonatomic, strong) UIView *View_CurrencyCode;
@property (nonatomic, strong) UITextField *txf_CurrencyCode;
/**
 汇率视图
 */
@property (nonatomic, strong) UIView *View_ExchangeRate;//汇率
@property (nonatomic, strong) UITextField *txf_ExchangeRate;
/**
 *本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
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
 *  采购明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  采购明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  采购增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_deleteDetils;
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

/**
 *  成本中心超预算提示
 */
@property(nonatomic,strong)UITableView *View_table;
/**
 * 费用类型数组
*/
@property (nonatomic,strong)NSMutableArray *arr_CostType;


@end
