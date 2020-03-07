//
//  SupplierApplyNewController.h
//  galaxy
//
//  Created by hfk on 2018/6/12.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "VoiceBaseController.h"
#import "BottomView.h"
#import "MyProcurementModel.h"
#import "contactsVController.h"
#import "buildCellInfo.h"
#import "SupplierData.h"
#import "SupplierFormData.h"
#import "SupplierDetail.h"

@interface SupplierApplyNewController : VoiceBaseController<UIScrollViewDelegate,GPClientDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ByvalDelegate>

/**
 表单上数据
 */
@property (nonatomic,strong)SupplierFormData *FormDatas;
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
 *  供应商名称视图
 */
@property(nonatomic,strong)UIView *View_SupplierName;
@property(nonatomic,strong)UITextField *txf_SupplierName;
/**
 *  供应商编号视图
 */
@property(nonatomic,strong)UIView *View_SupplierCode;
@property(nonatomic,strong)UITextField *txf_SupplierCode;
/**
 *  供应商分类视图
 */
@property(nonatomic,strong)UIView *View_SupplierCat;
@property(nonatomic,strong)UITextField *txf_SupplierCat;
/**
 *  VMS Code视图
 */
@property(nonatomic,strong)UIView *View_VMSCode;
@property(nonatomic,strong)UITextField *txf_VMSCode;
/**
 *  联系人明细视图
 */
@property(nonatomic,strong)UITableView *View_DetailsTable;
/**
 *  联系人明细tableView的头视图
 */
@property(nonatomic,strong)UIView *View_Head;
/**
 *  联系人明细增加明细按钮视图
 */
@property(nonatomic,strong)UIView *View_AddDetails;
/**
 *  删除联系人明细警告框
 */
@property (nonatomic,strong)UIAlertView *Aler_DeleteDetils;
/**
 *  开户银行账号视图
 */
@property(nonatomic,strong)UIView *View_BankAccount;
@property(nonatomic,strong)UITextField *txf_BankAccount;
/**
 *  开户行网点视图
 */
@property(nonatomic,strong)UIView *View_BankOutlets;
@property(nonatomic,strong)UITextField *txf_BankOutlets;
/**
 *  开户行视图
 */
@property(nonatomic,strong)UIView *View_BankName;
@property(nonatomic,strong)UITextField *txf_BankName;
/**
 *  开户行城市视图
 */
@property(nonatomic,strong)UIView *View_BankCity;
@property(nonatomic,strong)UITextField *txf_BankCity;
/**
 *  联系人视图
 */
@property(nonatomic,strong)UIView *View_Contacts;
@property(nonatomic,strong)UITextField *txf_Contacts;
/**
 *  电话视图
 */
@property(nonatomic,strong)UIView *View_Tel;
@property(nonatomic,strong)UITextField *txf_Tel;
/**
 *  地址视图
 */
@property(nonatomic,strong)UIView *View_Addr;
@property(nonatomic,strong)UITextField *txf_Addr;
/**
 *  邮编视图
 */
@property(nonatomic,strong)UIView *View_ZipCode;
@property(nonatomic,strong)UITextField *txf_ZipCode;

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



@end
