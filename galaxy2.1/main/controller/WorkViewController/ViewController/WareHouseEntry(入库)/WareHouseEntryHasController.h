//
//  WareHouseEntryHasController.h
//  galaxy
//
//  Created by hfk on 2018/12/11.
//  Copyright © 2018 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "ProcureDetailsCell.h"
#import "MyProcurementModel.h"
#import "WareHouseEntryDetail.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "examineViewController.h"
#import "WareHouseEntryFormData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WareHouseEntryHasController : VoiceBaseController<GPClientDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

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
/**
 * 入库日期视图
 */
@property(nonatomic,strong)UIView *View_StoreDate;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
/**
 *  合同视图
 */
@property(nonatomic,strong)MulChooseShowView *View_ContractName;
/**
 *  项目视图
 */
@property(nonatomic,strong)UIView *View_Project;
/**
 *  采购申请单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_PurchaseForm;
/**
 * 收货时间视图
 */
@property(nonatomic,strong)UIView *View_ReceivedDate;
/**
 * 入库类型视图
 */
@property(nonatomic,strong)UIView *View_StoreType;
/**
 * 仓库视图
 */
@property(nonatomic,strong)UIView *View_InvStorage;
/**
 * 仓库地址视图
 */
@property(nonatomic,strong)UIView *View_InvStorageAddr;
/**
 *  总金额视图
 */
@property(nonatomic,strong)UIView *View_TotalMoney;
/**
 *  金额大写视图
 */
@property (nonatomic, strong) UIView *View_Capitalized;
/**
 *  明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
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
 *  采购审批人视图
 */
@property(nonatomic,strong)UIView *View_Approve;
@property(nonatomic,strong)UIImageView *View_ApproveImg;
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

NS_ASSUME_NONNULL_END
