//
//  WareHouseEntryNewController.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "WareHouseEntryData.h"
#import "WareHouseEntryFormData.h"
#import "WareHouseEntryDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface WareHouseEntryNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 表单上数据
 */
@property (nonatomic,strong)WareHouseEntryFormData *FormDatas;
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
@property(nonatomic,strong)UITextView *txv_Reason;
/**
 * 入库日期视图
 */
@property(nonatomic,strong)UIView *View_StoreDate;
@property(nonatomic,strong)UITextField *txf_StoreDate;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
@property(nonatomic,strong)UITextField *txf_Project;
/**
 *  采购申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_PurchaseForm;
/**
 * 收货时间视图
 */
@property(nonatomic,strong)UIView *View_ReceivedDate;
@property(nonatomic,strong)UITextField *txf_ReceivedDate;
/**
 * 入库类型视图
 */
@property(nonatomic,strong)UIView *View_StoreType;
@property(nonatomic,strong)UITextField *txf_StoreType;
/**
 * 仓库视图
 */
@property(nonatomic,strong)UIView *View_InvStorage;
@property(nonatomic,strong)UITextField *txf_InvStorage;
/**
 * 仓库地址视图
 */
@property(nonatomic,strong)UIView *View_InvStorageAddr;
@property(nonatomic,strong)UITextField *txf_InvStorageAddr;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_head;
/**
 *  增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  总金额视图
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
 *  备注视图
 */
@property(nonatomic,strong)UIView *View_Remark;
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
@property(nonatomic,strong)UIImageView *View_ApproveImg;
@property(nonatomic,strong)UITextField *txf_Approver;
/**
 *  抄送人视图
 */
@property(nonatomic,strong)UIView *View_CcToPeople;
@property(nonatomic,strong)UITextField *txf_CcToPeople;

@end

NS_ASSUME_NONNULL_END
