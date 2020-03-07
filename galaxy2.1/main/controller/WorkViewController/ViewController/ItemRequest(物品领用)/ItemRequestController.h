//
//  ItemRequestController.h
//  galaxy
//
//  Created by hfk on 2018/3/23.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "FormDetailBaseCell.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "ChooseCategoryModel.h"
#import "ItemRequestDetail.h"
#import "ItemRequestFormData.h"

@interface ItemRequestController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>
/**
 表单上数据
 */
@property (nonatomic,strong)ItemRequestFormData *FormDatas;
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
 *  用途视图
 */
@property(nonatomic,strong)UIView *View_Usage;
@property(nonatomic,strong)UITextField *txf_Usage;
/**
 类型
 */
@property(nonatomic,strong)UIView *View_Type;
@property(nonatomic,strong)UITextField *txf_Type;
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
 *  入库单视图
 */
@property(nonatomic,strong)MulChooseShowView *View_InventoryForm;
/**
 *  客户视图
 */
@property(nonatomic,strong)UIView *View_Client;
@property(nonatomic,strong)UITextField *txf_Client;
/**
 *  供应商视图
 */
@property(nonatomic,strong)UIView *View_Supplier;
@property(nonatomic,strong)UITextField *txf_Supplier;
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
 *  库存超标提示
 */
@property(nonatomic,strong)UITableView *View_table;


@end
