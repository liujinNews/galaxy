//
//  VehicleRepairNewController.h
//  galaxy
//
//  Created by hfk on 2018/4/22.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "DeatilsViewCell.h"
#import "VehicleRepairDeatil.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "VehicleRepairData.h"
#import "STPickerCategory.h"
#import "VehicleRepairFormData.h"

@interface VehicleRepairNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)VehicleRepairFormData *FormDatas;
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
@property(nonatomic,strong)UITextField *txf_Reason;
/**
 *  车牌号视图
 */
@property(nonatomic,strong)UIView *View_CarNo;
@property(nonatomic,strong)UITextField *txf_CarNo;
/**
 *  车型
 */
@property(nonatomic,strong)UIView *View_CarSize;
@property(nonatomic,strong)UITextField *txf_CarSize;
/**
 *  载重
 */
@property(nonatomic,strong)UIView *View_LoadCapacity;
@property(nonatomic,strong)UITextField *txf_LoadCapacity;
/**
 *  里程
 */
@property(nonatomic,strong)UIView *View_Mileage;
@property(nonatomic,strong)UITextField *txf_Mileage;
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
@property(nonatomic,strong)UITextField *txf_CateDes;
/**
 项目客户等相关视图
 */
@property(nonatomic,strong)FormRelatedView *FormRelatedView;
/**
 *  预估金额视图
 */
@property(nonatomic,strong)UIView *View_Acount;
@property (nonatomic,strong)GkTextField * txf_Acount;
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
 本位币视图
 */
@property (nonatomic, strong) UIView *View_LocalCyAmount;
@property (nonatomic, strong) UITextField *txf_LocalCyAmount;
/**
 *  费用明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
@property(nonatomic,strong)UIView *View_Head;
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_deleteDetils;
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

/**
 *  成本中心超预算提示
 */
@property(nonatomic,strong)UITableView *View_table;


@end
